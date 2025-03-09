require "Data/Model/BagApi"

---@module ModuleMgr.MagicRecoveMachineMgr
module("ModuleMgr.MagicRecoveMachineMgr", package.seeall)

--分解头饰最小数量
OrnamentResolveNumberMin = MGlobalConfig:GetInt("OrnamentResolveNumberMin")
--分解头饰最大数量
OrnamentResolveNumberMax = MGlobalConfig:GetInt("OrnamentResolveNumberMax")
--分解卡片最小数量
CardResolveNumberMin = MGlobalConfig:GetInt("ResolveNumberMin")
--分解卡片最大数量
CardResolveNumberMax = MGlobalConfig:GetInt("ResolveNumberMax")
--分解装备最小数量
EquipResolveNumberMin = MGlobalConfig:GetInt("EquipResolveNumberMin")
--分解装备最大数量
EquipResolveNumberMax = MGlobalConfig:GetInt("EquipResolveNumberMax")

-- 事件注册
EventDispatcher = EventDispatcher.new()
-- 分解成功
OnRecoveItemSuccess = "OnRecoveItemSuccess"

-- 魔力分解机器类型
EMagicRecoveMachineType = {
    None = 0, -- 初始值
    HeadWear = 1, -- 魔力头饰机
    Card = 2, -- 魔力卡片机
    Equip = 3, -- 魔力装备机
}
-- 当前选择的魔力机器类型
CurrentMachineType = EMagicRecoveMachineType.None
function Uninit()
    CurrentMachineType = EMagicRecoveMachineType.None
end
-- 请求分解
function ReqRecoveItem(data)
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        local l_msgId = Network.Define.Rpc.RecoveOrnament
        ---@type RecoveOrnamentArg
        local l_sendInfo = GetProtoBufSendTable("RecoveOrnamentArg")
        for i = 1, #data do
            local l_ItemInfo = l_sendInfo.item_uid:add()
            l_ItemInfo.value = data[i].uid
        end
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        local l_msgId = Network.Define.Rpc.RecoveCard
        ---@type RecoveCardArg
        local l_sendInfo = GetProtoBufSendTable("RecoveCardArg")
        for i = 1, #data do
            local l_ItemInfo = l_sendInfo.id_and_num:add()
            l_ItemInfo.key = data[i].uid
            l_ItemInfo.value = data[i].count
        end
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        local l_msgId = Network.Define.Rpc.RecoveEquip
        ---@type RecoveEquipArg
        local l_sendInfo = GetProtoBufSendTable("RecoveEquipArg")
        for i = 1, #data do
            local l_ItemInfo = l_sendInfo.item_uid:add()
            l_ItemInfo.value = data[i].uid
        end
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end
-- 请求成功回调
function RspRecoveItem(msg)
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        ---@type RecoveOrnamentRes
        local l_info = ParseProtoBufToTable("RecoveOrnamentRes", msg)
        local l_result = l_info.result.errorno
        if l_result ~= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result.errorno))
            return
        end
        EventDispatcher:Dispatch(OnRecoveItemSuccess, l_info.id_and_num)
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        ---@type RecoveCardRes
        local l_info = ParseProtoBufToTable("RecoveCardRes", msg)
        local l_result = l_info.result.errorno
        if l_result ~= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result.errorno))
            return
        end
        EventDispatcher:Dispatch(OnRecoveItemSuccess, l_info.id_and_num)
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        ---@type RecoveEquipRes
        local l_info = ParseProtoBufToTable("RecoveEquipRes", msg)
        local l_result = l_info.result.errorno
        if l_result ~= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result.errorno))
            return
        end
        EventDispatcher:Dispatch(OnRecoveItemSuccess, l_info.id_and_num)
    end
end
-- 获取当前下拉框要显示的内容
function GetCurrentArrowNames()
    local l_ArrowNames = {}
    table.insert(l_ArrowNames, { name = Common.Utils.Lang("AllText"), index = 0 })
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        for k, v in pairs(MgrMgr:GetMgr("EquipMgr").eRecoveHeadColorName) do
            table.insert(l_ArrowNames, { name = v, index = k })
        end
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        for k, v in pairs(MgrMgr:GetMgr("EquipMgr").eCardColorName) do
            table.insert(l_ArrowNames, { name = v, index = k })
        end
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        for k, v in pairs(MgrMgr:GetMgr("EquipMgr").eRecoveEquipName) do
            table.insert(l_ArrowNames, { name = v, index = k })
        end
    end
    return l_ArrowNames
end

-- 提供外部访问的接口 判断当前的item是否可以分解
---@param data ItemData
function IsOutsideCanRecoveItem(machineType, data)
    CurrentMachineType = machineType
    local l_Recovedata = GetCurrentShowItemsDataByArrow(0, false)
    local l_CanRecove = false
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear
            or CurrentMachineType == EMagicRecoveMachineType.Equip then
        -- 剔除 [双装备方案中的头饰、装备不可分解，包括背包中带“换”标签的头饰、装备]
        local l_status, l_, l__ = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquipWithUid(data.UID)
        if l_status then
            return false
        end
    end
    for _, v in ipairs(l_Recovedata) do
        if v.bagdata.TID == data.TID then
            l_CanRecove = true
        end
    end
    CurrentMachineType = EMagicRecoveMachineType.None
    return l_CanRecove
end

--- 获取背包中的道具
---@return ItemData[]
function _getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

--- 获取所有的装备
---@return ItemData[]
function _getAllEquips()
    local types = { GameEnum.EBagContainerType.Equip }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

function _getItemsByTidAndContType(containerType, tid)
    if GameEnum.ELuaBaseType.Number ~= type(containerType) or GameEnum.ELuaBaseType.Number ~= type(tid) then
        logError("[MagicRecoverMachine] invalid param")
        return {}
    end

    local types = { containerType }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret
end

function _getWareHouseItemByTID(tid)
    return _getItemsByTidAndContType(GameEnum.EBagContainerType.WareHouse, tid)
end

function _getCartItemsByTid(tid)
    return _getItemsByTidAndContType(GameEnum.EBagContainerType.Cart, tid)
end

-- 通过下拉列表筛选 获取当前需要显示的可分解item
-- isReadTable 不用打开分解ui，就不需要读表数据
function GetCurrentShowItemsDataByArrow(arrowIndex, isNeedReadTable)
    local l_ShowItems = {}
    -- 获取背包所有物品
    local l_Bag = _getItemsInBag()
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        local l_HeadWear = {} -- 筛选出背包中的头饰部分 并 按照propid分类
        for k, bag in pairs(l_Bag) do
            local ornament = TableUtil.GetOrnamentTable().GetRowByOrnamentID(bag.TID, true)
            if ornament ~= nil then
                -- 属于头饰
                -- 有培养属性的头饰无法分解，包括：精炼属性、卡片属性、附魔属性
                local l_RefineLevel = MgrMgr:GetMgr("RefineMgr").GetRefineLevel(bag)
                local l_CardCount = MgrMgr:GetMgr("EquipMakeHoleMgr").GetInsertedCardCount(bag)
                local l_EnchantStatus = MgrMgr:GetMgr("EnchantMgr").IsEnchanted(bag)
                if l_RefineLevel == 0 and l_CardCount == 0 and not l_EnchantStatus then
                    if l_HeadWear[bag.TID] == nil or table.ro_size(l_HeadWear[bag.TID]) == 0 then
                        l_HeadWear[bag.TID] = {}
                    end
                    if arrowIndex == 0 then
                        table.insert(l_HeadWear[bag.TID], { bagdata = bag, select = false })
                    elseif arrowIndex == ornament.OrnamentType then
                        table.insert(l_HeadWear[bag.TID], { bagdata = bag, select = false })
                    end
                end
            end
        end
        for propId, v in pairs(l_HeadWear) do
            table.sort(v, function(a, b)
                return a.bagdata.ItemConfig.ItemQuality < b.bagdata.ItemConfig.ItemQuality
            end)
            -- 仓库、手推车、装备栏（穿在身上的）、双装备方案（存放在背包中，并且带“换”标签）、衣橱 中存在该头饰propid 则背包里所有该头饰均为多余的
            local l_PotPropInfos, pageNum = _getWareHouseItemByTID(propId)
            local l_CarPropInfos = _getCartItemsByTid(propId)
            local l_EquipsOnBodyStatus = false
            local equips = _getAllEquips()
            for k, equip in pairs(equips) do
                if equip.TID == propId then
                    l_EquipsOnBodyStatus = true
                end
            end

            local l_MultiTalentEquipStatus = false
            local l_TmpData = {}
            for i = 1, #v do
                local l_status, l_, l__ = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquipWithUid(v[i].bagdata.UID)
                -- 双装备方案中的头饰不可分解，包括背包中带“换”标签的头饰
                if l_status then
                    l_MultiTalentEquipStatus = true
                else
                    table.insert(l_TmpData, v[i])
                end
            end

            v = l_TmpData
            local l_fashionStatus = MgrProxy:GetGarderobeMgr().IsStoreFashion(propId)
            -- 多余的
            --log(propId .. "|" .. #v .. "|" .. table.ro_size(l_PotPropInfos) .. "|" .. table.ro_size(l_CarPropInfos) .. "|" .. tostring(l_EquipsOnBodyStatus) .. "|" .. tostring(l_MultiTalentEquipStatus) .. "|" .. tostring(l_fashionStatus))
            if table.ro_size(l_PotPropInfos) > 0 or table.ro_size(l_CarPropInfos) > 0 or l_EquipsOnBodyStatus or l_MultiTalentEquipStatus or l_fashionStatus then
                for k, bag in ipairs(v) do
                    table.insert(l_ShowItems, bag)
                end
            else
                -- N-1标记为多余
                for k = 1, table.ro_size(v) - 1 do
                    table.insert(l_ShowItems, v[k])
                end
            end
        end
        table.sort(l_ShowItems, function(a, b)
            if a.bagdata.ItemConfig.ItemQuality < b.bagdata.ItemConfig.ItemQuality then
                return true
            elseif a.bagdata.ItemConfig.ItemQuality == b.bagdata.ItemConfig.ItemQuality and a.bagdata.TID < b.bagdata.TID then
                return true
            else
                return false
            end
        end)
        l_ShowItems = GetResolveAmountData(l_ShowItems, isNeedReadTable)
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        for k, bag in ipairs(l_Bag) do
            if bag.ItemConfig.TypeTab == Data.BagModel.PropType.Card then
                -- 除去橙卡
                if bag.ItemConfig.ItemQuality < 4 then
                    if arrowIndex == 0 then
                        for j = 1, tonumber(bag.ItemCount) do
                            table.insert(l_ShowItems, { bagdata = bag, select = false })
                        end
                    elseif bag.ItemConfig.ItemQuality == 4 - arrowIndex then
                        for j = 1, tonumber(bag.ItemCount) do
                            table.insert(l_ShowItems, { bagdata = bag, select = false })
                        end
                    end
                end
            end
        end
        table.sort(l_ShowItems, function(a, b)
            if a.bagdata.ItemConfig.ItemQuality < b.bagdata.ItemConfig.ItemQuality then
                return true
            elseif a.bagdata.ItemConfig.ItemQuality == b.bagdata.ItemConfig.ItemQuality and a.bagdata.TID < b.bagdata.TID then
                return true
            else
                return false
            end
        end)
        l_ShowItems = GetResolveAmountData(l_ShowItems, isNeedReadTable)
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        local l_ForgeData = {} --锻造装
        local l_EctypeData = {} -- 副本装
        for k, bag in ipairs(l_Bag) do
            local equip = bag.EquipConfig
            if equip then
                -- 属于装备
                local cardAttrs = bag:GetAttrsByType(GameEnum.EItemAttrModuleType.Card)
                -- 双装备方案中的装备不可分解，包括背包中带“换”标签的装备
                local l_status, l_, l__ = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquipWithUid(bag.UID)
                if 0 >= #cardAttrs and not l_status then
                    local l_IsArrowIndexData = false -- 是否是当前arrow下的数据
                    if arrowIndex == 0 then
                        l_IsArrowIndexData = true
                    elseif arrowIndex == 1 and tonumber(equip.EquipId) == 1 then
                        -- 武器
                        l_IsArrowIndexData = true
                    elseif arrowIndex == 2 and (tonumber(equip.EquipId) == 2 or tonumber(equip.EquipId) == 3 or tonumber(equip.EquipId) == 4 or tonumber(equip.EquipId) == 5) then
                        -- 2：副手 3：盔甲 4：披风 5：鞋子 属于防具
                        l_IsArrowIndexData = true
                    elseif arrowIndex == 3 and tonumber(equip.EquipId) == 6 then
                        -- 饰品
                        l_IsArrowIndexData = true
                    end
                    if l_IsArrowIndexData then
                        if tonumber(equip.TypeId) == 2 then
                            --锻造装
                            table.insert(l_ForgeData, { bagdata = bag, select = false })
                        elseif tonumber(equip.TypeId) == 3 then
                            -- 副本装
                            table.insert(l_EctypeData, { bagdata = bag, select = false })
                        end
                    end
                end
            end
        end

        table.sort(l_EctypeData, _itemSortFunc)
        table.sort(l_ForgeData, _itemSortFunc)
        -- 副本装 > 锻造装
        for k, v in ipairs(l_EctypeData) do
            table.insert(l_ShowItems, v)
        end

        for k, v in ipairs(l_ForgeData) do
            table.insert(l_ShowItems, v)
        end
        l_ShowItems = GetResolveAmountData(l_ShowItems, isNeedReadTable)
    end
    --log(ToString(l_ShowItems))
    return l_ShowItems
end

--- 装备分解排序算法，需要置顶强化过的装备
function _itemSortFunc(a, b)
    ---@type ItemData
    local itemDataA = a.bagdata
    ---@type ItemData
    local itemDataB = b.bagdata
    local aEnhanced = _convertBool2Int(itemDataA:EquipEnhanced())
    local bEnhanced = _convertBool2Int(itemDataB:EquipEnhanced())
    if aEnhanced ~= bEnhanced then
        return aEnhanced > bEnhanced
    end

    if a.bagdata.ItemConfig.SortID < b.bagdata.ItemConfig.SortID then
        return true
    elseif a.bagdata.ItemConfig.SortID == b.bagdata.ItemConfig.SortID then
        if a.bagdata.TID < b.bagdata.TID then
            return true
        elseif a.bagdata.TID == b.bagdata.TID and (not a.bagdata.IsBind and b.bagdata.IsBind) then
            return false
        else
            return false
        end
    else
        return false
    end
end

--- 将布尔值转化成数字
---@param bool boolean
function _convertBool2Int(bool)
    if bool then
        return 1
    end

    return 0
end

-- 设置分解获得的材料 分解所需的材料 分解装备->去除不在分解等级区间内的装备  返回的是新的数据
function GetResolveAmountData(data, isNeedReadTable)
    if not isNeedReadTable then
        return data
    end
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear
            or CurrentMachineType == EMagicRecoveMachineType.Card then
        for _, v in ipairs(data) do
            local l_Data = GetCurrentTableRowData(v.bagdata.TID)
            if l_Data then
                local l_ItemData = v.bagdata.ItemConfig
                if l_ItemData then
                    for i = 0, l_Data.ResolveAmount.Length - 1 do
                        local l_tabledata = {}
                        l_tabledata.ResolveAmountID = l_Data.ResolveAmount[i][0]
                        l_tabledata.ResolveAmountCount = l_Data.ResolveAmount[i][1]
                        l_tabledata.ExpendZenyID = 101
                        l_tabledata.ExpendZenyCount = l_Data.ExpendZeny
                        v.tabledata = l_tabledata
                    end
                end
            end
        end
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        local l_TmpData = {}
        for _, v in ipairs(data) do
            local l_Data = GetCurrentTableRowData(v.bagdata.TID)
            if l_Data then
                local l_ItemData = v.bagdata.ItemConfig
                if l_ItemData then
                    for i = 0, l_Data.ResolveAmount.Length - 1 do
                        -- 不在分解区间内的装备不显示
                        if l_ItemData.LevelLimit[0] >= l_Data.ResolveAmount[i][0] and
                                (l_ItemData.LevelLimit[0] < l_Data.ResolveAmount[i][1] or l_Data.ResolveAmount[i][1] == -1) then
                            local l_tabledata = {}
                            l_tabledata.ResolveAmountID = l_Data.ResolveAmount[i][2]
                            l_tabledata.ResolveAmountCount = l_Data.ResolveAmount[i][3]
                            for j = 0, l_Data.ExpendZeny.Length - 1 do
                                if l_ItemData.LevelLimit[0] >= l_Data.ExpendZeny[j][0] and
                                        (l_ItemData.LevelLimit[0] < l_Data.ExpendZeny[j][1] or l_Data.ExpendZeny[j][1] == -1) then
                                    l_tabledata.ExpendZenyID = l_Data.ExpendZeny[j][2]
                                    l_tabledata.ExpendZenyCount = l_Data.ExpendZeny[j][3]
                                end
                            end
                            v.tabledata = l_tabledata
                            table.insert(l_TmpData, v)
                        end
                    end
                end
            end
        end
        data = l_TmpData
    end
    return data
end
-- 获取当前最大分解数量
function GetResolveNumberMax()
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        return OrnamentResolveNumberMax
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        return CardResolveNumberMax
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        return EquipResolveNumberMax
    end
end
-- 获取当前最小分解数量
function GetResolveNumberMin()
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        return OrnamentResolveNumberMin
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        return CardResolveNumberMin
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        return EquipResolveNumberMin
    end
end
-- 获取当前的分解物品描述
function GetCurrentRecoveDescription()
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        return Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_TOUSHI")
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        return Common.Utils.Lang("TRADE_DES_ITEM_4")
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        return Common.Utils.Lang("TRADE_DES_ITEM_1")
    end
end
-- 获取当前excel table表中的row数据
function GetCurrentTableRowData(propId)
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        return TableUtil.GetOrnamentTable().GetRowByOrnamentID(propId)
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        return TableUtil.GetEquipCardTable().GetRowByID(propId)
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        local equip = TableUtil.GetEquipTable().GetRowById(propId, true)
        local ID = tostring(tonumber(equip.EquipId * 10000) + tonumber(equip.TypeId))
        return TableUtil.GetEquipResolveTable().GetRowByID(ID)
    end
end
-- 获取当前右上角提示信息
function GetCurrentTxtHelpMessage()
    if CurrentMachineType == EMagicRecoveMachineType.HeadWear then
        return Common.Utils.Lang("MagicRecoveHeadMessageHelp")
    elseif CurrentMachineType == EMagicRecoveMachineType.Card then
        return Common.Utils.Lang("MagicRecoveCardMessageHelp")
    elseif CurrentMachineType == EMagicRecoveMachineType.Equip then
        return Common.Utils.Lang("MagicRecoveEquipMessageHelp")
    end
end

function OnLeaveScene(sceneId)
    UIMgr:DeActiveUI(UI.CtrlNames.MagicRecoveMachine)
end

return ModuleMgr.MagicRecoveMachineMgr