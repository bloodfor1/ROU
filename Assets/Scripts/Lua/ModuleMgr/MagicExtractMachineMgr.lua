---@module ModuleMgr.MagicExtractMachineMgr
module("ModuleMgr.MagicExtractMachineMgr", package.seeall)

--抽取材料
OrnamentExpendBCAmount = MGlobalConfig:GetVectorSequence("OrnamentExpendBCAmount")
--每日抽取最大次数
OrnamentExpendNumberMax = MGlobalConfig:GetInt("OrnamentExpendNumberMax")
--头饰预览奖池
OrnamentBCAwardID = MGlobalConfig:GetInt("OrnamentBCAwardID")

--抽取紫卡材料
ExpendAAmount = MGlobalConfig:GetVectorSequence("ExpendAAmount")
--抽取蓝绿卡材料
ExpendBCAmount = MGlobalConfig:GetVectorSequence("ExpendBCAmount")
--每日抽取最大次数
ExpendNumberMax = MGlobalConfig:GetInt("ExpendNumberMax")
--紫卡奖池
CardAAwardID = MGlobalConfig:GetInt("CardAAwardID")
--蓝绿卡奖池
CardBCAwardID = MGlobalConfig:GetInt("CardBCAwardID")

--抽取稀有装备材料
EquipExpendAAmount = MGlobalConfig:GetVectorSequence("EquipExpendAAmount")
--抽取普通装备材料
EquipExpendBCAmount = MGlobalConfig:GetVectorSequence("EquipExpendBCAmount")
--每日抽取最大次数
EquipExpendNumberMax = MGlobalConfig:GetInt("EquipExpendNumberMax")
--稀有装备奖池
EquipAAwardID = MGlobalConfig:GetInt("EquipAAwardID")
--普通装备奖池
EquipBCAwardID = MGlobalConfig:GetInt("EquipBCAwardID")

-- 事件注册
EventDispatcher = EventDispatcher.new()
-- 抽取成功
ExtractSuccess = "ExtractSuccess"
-- 预览界面
OnExtractPreviewEvent = "OnExtractPreviewEvent"

-- 魔力分解机器类型
EMagicExtractMachineType = {
    None = 0, -- 初始值
    HeadWear = 1, -- 魔力头饰机
    Card = 2, -- 魔力卡片机
    Equip = 3, -- 魔力装备机
}
-- 抽取卡片类型类型
EExtractCardType = {
    None = 0, -- 初始值
    ACard = 1, -- 紫卡
    BCCard = 2, -- 蓝绿卡
}
-- 抽取装备类型类型
EExtractEquipType = {
    None = 0, -- 初始值
    AEquip = 1, -- 稀有
    BCEquip = 2, -- 普通
}

-- 当前选择的魔力机器类型
CurrentMachineType = EMagicExtractMachineType.None
-- 当前抽取的卡片类型
CurrentExtractCardType = EExtractCardType.None
-- 当前卡片抽取的奖池类型
CurrentExtractCardAwardType = -1
-- 当前抽取的装备类型
CurrentExtractEquipType = EExtractEquipType.None
-- 当前装备抽取的奖池类型
CurrentExtractEquipAwardType = -1
-- 是否是通过非npc渠道打开panel
IsOpenPanelByOther = false

function Uninit()
    CurrentMachineType = EMagicExtractMachineType.None
    CurrentExtractCardType = EExtractCardType.None
    CurrentExtractCardAwardType = -1
    CurrentExtractEquipType = EExtractEquipType.None
    CurrentExtractEquipAwardType = -1
    IsOpenPanelByOther = false
end

--  外部设置初始数据的入口 此时还没有打开Panel
function SetExtractMagicPreViewData(arg)
    IsOpenPanelByOther = true
    if CurrentMachineType == EMagicExtractMachineType.Card then
        -- expendAmountID代表抽取卡片的材料 itemid表示展示的卡片id
        if arg.expendamountid ~= nil then
            if arg.expendamountid == tonumber(ExpendAAmount[0][0]) then
                CurrentExtractCardType = EExtractCardType.ACard
                CurrentExtractCardAwardType = CardAAwardID
            elseif arg.expendamountid == tonumber(ExpendBCAmount[0][0]) then
                CurrentExtractCardType = EExtractCardType.BCCard
                CurrentExtractCardAwardType = CardBCAwardID
            end
        elseif arg.itemid ~= nil then
            local l_Data = TableUtil.GetItemTable().GetRowByItemID(arg.itemid, true)
            if l_Data then
                if l_Data.ItemQuality > 2 then
                    CurrentExtractCardType = EExtractCardType.ACard
                    CurrentExtractCardAwardType = CardAAwardID
                else
                    CurrentExtractCardType = EExtractCardType.BCCard
                    CurrentExtractCardAwardType = CardBCAwardID
                end
            else
                logError("ItemTable not have id " .. arg.itemid)
            end
        end
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        -- expendAmountID代表抽取装备的材料 itemid表示展示的装备id
        if arg.expendamountid ~= nil then
            if arg.expendamountid == tonumber(EquipExpendAAmount[0][0]) then
                CurrentExtractEquipType = EExtractEquipType.AEquip
                CurrentExtractEquipAwardType = EquipAAwardID
            elseif arg.expendamountid == tonumber(EquipExpendBCAmount[0][0]) then
                CurrentExtractEquipType = EExtractEquipType.BCEquip
                CurrentExtractEquipAwardType = EquipBCAwardID
            end
        elseif arg.itemid ~= nil then
            local l_Data = TableUtil.GetItemTable().GetRowByItemID(arg.itemid, true)
            if l_Data then
                if l_Data.ItemQuality > 2 then
                    --CurrentExtractEquipType = EExtractEquipType.AEquip
                    --CurrentExtractEquipAwardType = EquipAAwardID
                    --【【成长线复盘专项】装备稀有抽取屏蔽】 https://www.tapd.cn/20332331/prong/stories/view/1120332331001057897
                    CurrentExtractEquipType = EExtractEquipType.BCEquip
                    CurrentExtractEquipAwardType = EquipBCAwardID
                else
                    CurrentExtractEquipType = EExtractEquipType.BCEquip
                    CurrentExtractEquipAwardType = EquipBCAwardID
                end
            else
                logError("ItemTable not have id " .. arg.itemid)
            end
        end
    end
end
-- 打开魔力卡片机的panel
function OpenExtractCardPanel()
    if not IsOpenPanelByOther then
        -- 当前是正常的npc对话打开panel 填写默认值
        CurrentExtractCardType = EExtractCardType.ACard
        CurrentExtractCardAwardType = CardAAwardID
    end
    IsOpenPanelByOther = false
    ReqExtractPreview()
end
-- 打开魔力装备机的panel
function OpenExtractEquipPanel()
    if not IsOpenPanelByOther then
        -- 当前是正常的npc对话打开panel 填写默认值
        CurrentExtractEquipType = EExtractEquipType.BCEquip
        CurrentExtractEquipAwardType = EquipBCAwardID
    end
    IsOpenPanelByOther = false
    ReqExtractPreview()
end
-- 请求预览
function ReqExtractPreview()
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        local l_msgId = Network.Define.Rpc.PreviewOrnament
        ---@type PreviewOrnamentArg
        local l_sendInfo = GetProtoBufSendTable("PreviewOrnamentArg")
        l_sendInfo.no_use = true
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        local l_msgId = Network.Define.Rpc.RecycleCardPreview
        ---@type RecycleCardPreviewArg
        local l_sendInfo = GetProtoBufSendTable("RecycleCardPreviewArg")
        l_sendInfo.type = tonumber(CurrentExtractCardAwardType)
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        local l_msgId = Network.Define.Rpc.PreviewMagicEquipExtract
        ---@type PreviewMagicEquipExtractArg
        local l_sendInfo = GetProtoBufSendTable("PreviewMagicEquipExtractArg")
        if CurrentExtractEquipAwardType == EquipAAwardID then
            l_sendInfo.type = 0
        elseif CurrentExtractEquipAwardType == EquipBCAwardID then
            l_sendInfo.type = 1
        end
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end
-- 预览回调
function RspExtractPreview(msg)
    ---@type string
    local msgName = ""

    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        msgName = "PreviewOrnamentRes"
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        msgName = "RecycleCardPreviewRes"
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        msgName = "PreviewMagicEquipExtractRes"
    end

    local l_info = ParseProtoBufToTable(msgName, msg)
    if l_info.result ~= 0 then
        logError(l_info.result)
        return
    end
    if UIMgr:IsActiveUI(UI.CtrlNames.MagicExtractMachine) then
        EventDispatcher:Dispatch(OnExtractPreviewEvent, l_info)
    else
        UIMgr:ActiveUI(UI.CtrlNames.MagicExtractMachine, l_info)
    end
end
-- 抽取
function ReqExtractItem()
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        local l_msgId = Network.Define.Rpc.ExtractOrnament
        ---@type ExtractOrnamentArg
        local l_sendInfo = GetProtoBufSendTable("ExtractOrnamentArg")
        l_sendInfo.no_use = true
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        local l_msgId = Network.Define.Rpc.ExtractCard
        ---@type ExtractCardArg
        local l_sendInfo = GetProtoBufSendTable("ExtractCardArg")
        if CurrentExtractCardAwardType == CardAAwardID then
            l_sendInfo.type = 0
        elseif CurrentExtractCardAwardType == CardBCAwardID then
            l_sendInfo.type = 1
        end
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        local l_msgId = Network.Define.Rpc.ExtractEquip
        ---@type ExtractEquipArg
        local l_sendInfo = GetProtoBufSendTable("ExtractEquipArg")
        if CurrentExtractEquipAwardType == EquipAAwardID then
            l_sendInfo.type = 0
        elseif CurrentExtractEquipAwardType == EquipBCAwardID then
            l_sendInfo.type = 1
        end
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end
--抽取回调
function RspExtractItem(msg)
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        ---@type ExtractOrnamentRes
        local l_info = ParseProtoBufToTable("ExtractOrnamentRes", msg)
        local l_result = l_info.result.errorno
        if l_result ~= 0 then
            if l_result == ErrorCode.ERR_ORNA_TIME_NOT_ENOUGH then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_EXTRACT_TIME_NOT_ENOUGH"))
            elseif l_result == ErrorCode.CARD_AWARD_NOT_EXIST then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Common.Utils.Lang("EXTRACT_AWARD_NOT_EXIST"), GetCurrentExtractDescription()))
            elseif l_result == ErrorCode.ERR_ITEM_NOT_ENOUGH then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
            elseif l_result == ErrorCode.ERR_FAR_FROM_NPC then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_result))
                UIMgr:DeActiveUI(UI.CtrlNames.MagicExtractMachine)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_result))
            end
            return
        end
        EventDispatcher:Dispatch(ExtractSuccess, l_info)
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        ---@type ExtractCardRes
        local l_info = ParseProtoBufToTable("ExtractCardRes", msg)
        local l_result = l_info.result.errorno
        if l_result ~= 0 then
            if l_result == ErrorCode.ERR_CARD_TIME_NOT_ENOUGH then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_EXTRACT_TIME_NOT_ENOUGH"))
            elseif l_result == ErrorCode.CARD_AWARD_NOT_EXIST then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Common.Utils.Lang("EXTRACT_AWARD_NOT_EXIST"), GetCurrentExtractDescription()))
            elseif l_result == ErrorCode.ERR_NOT_CARD_TYPE then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_NOT_CARD_TYPE"))
            elseif l_result == ErrorCode.ERR_ITEM_NOT_ENOUGH then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
            elseif l_result == ErrorCode.ERR_FAR_FROM_NPC then
                UIMgr:DeActiveUI(UI.CtrlNames.MagicExtractMachine)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_result))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_result))
            end
            return
        end
        local arg = {
            item_id = l_info.card_id,
            item_num = 1
        }
        EventDispatcher:Dispatch(ExtractSuccess, arg)
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        ---@type ExtractEquipRes
        local l_info = ParseProtoBufToTable("ExtractEquipRes", msg)
        local l_result = l_info.result.errorno
        if l_result ~= 0 then
            if l_result == ErrorCode.ERR_EXTRACT_ERUIP_NOT_ENOUGH then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_EXTRACT_TIME_NOT_ENOUGH"))
            elseif l_result == ErrorCode.ERR_EQUIP_EXTRACT_AWARD_NOT_EXIST then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Common.Utils.Lang("EXTRACT_AWARD_NOT_EXIST"), GetCurrentExtractDescription()))
            elseif l_result == ErrorCode.ERR_ITEM_NOT_ENOUGH then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
            elseif l_result == ErrorCode.ERR_FAR_FROM_NPC then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_result))
                UIMgr:DeActiveUI(UI.CtrlNames.MagicExtractMachine)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_result))
            end
            return
        end
        EventDispatcher:Dispatch(ExtractSuccess, l_info)
    end
end

-- 获取当前下拉框要显示的内容
function GetCurrentArrowNames()
    local l_ArrowNames = {}
    table.insert(l_ArrowNames, {name = Common.Utils.Lang("AllText"), index = 0})
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        for k, v in ipairs(MgrMgr:GetMgr("EquipMgr").eHeadColorName) do
            table.insert(l_ArrowNames, {name = v, index = k})
        end
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        for k, v in ipairs(MgrMgr:GetMgr("EquipMgr").eEquipTypeName) do
            table.insert(l_ArrowNames, {name = v, index = k})
        end
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        for k, v in ipairs(MgrMgr:GetMgr("EquipMgr").eExtractEquipName) do
            table.insert(l_ArrowNames, {name = v, index = k})
        end
    end
    return l_ArrowNames
end
-- 获取当前最大抽取数量
function GetExtractNumberMax()
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        return OrnamentExpendNumberMax
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        return ExpendNumberMax
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        return EquipExpendNumberMax
    end
end
-- 获取当前的抽取物品描述
function GetCurrentExtractDescription()
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        return Common.Utils.Lang("MagicExtractMachineHead")
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        return Common.Utils.Lang("MagicExtractMachineCard")
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        return Common.Utils.Lang("MagicExtractMachineEquip")
    end
end
-- 获取所有的抽取物品
function GetAllExtractShowItemsData()
    local l_ShowItems = {}
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        l_ShowItems.BCHeadWear = {}
        local l_ArrowNames = GetCurrentArrowNames()
        for i = 1, #l_ArrowNames do
            l_ShowItems.BCHeadWear[i - 1] = {}
        end
        --图纸材料
        local l_ItemDatas = {}
        --头饰
        local l_HeadDatas = {}
        -- 对应的奖励包id PackIds
        local l_AwardData = TableUtil.GetAwardTable().GetRowByAwardId(OrnamentBCAwardID)
        if l_AwardData then
            for i = 0, l_AwardData.PackIds.Count - 1 do
                local l_AwardPackData = TableUtil.GetAwardPackTable().GetRowByPackId(l_AwardData.PackIds[i])
                if l_AwardPackData then
                    local l_ItemList = {}
                    MgrMgr:GetMgr("AwardPreviewMgr").GetAllItemByAwardPackId(l_AwardPackData.PackId, l_ItemList)
                    for _, v in ipairs(l_ItemList) do
                        local l_Data = {
                            ID = 0,
                            Count = 0,
                            IsShowName = true,
                            ButtonMethod = nil,
                            IsShowCount = false,
                            item_id = v.item_id,
                            groupWeight = v.groupWeight,
                            num = v.count,
                        }
                        local l_ItemInfo = TableUtil.GetItemTable().GetRowByItemID(l_Data.item_id, true)
                        if l_ItemInfo then
                            l_Data.ItemQuality = l_ItemInfo.ItemQuality
                            if l_ItemInfo.TypeTab == 1 then
                                table.insert(l_HeadDatas, l_Data)
                            else
                                table.insert(l_ItemDatas, l_Data)
                            end
                        else
                            logError("ItemTable id error " .. l_Data.item_id)
                        end
                    end
                else
                    logError("AwardPackTable not have id " .. l_AwardData.PackIds[i])
                end

            end
        else
            logError("AwardTable not have id " .. OrnamentBCAwardID)
        end
        --图纸按权重排序
        table.sort(l_ItemDatas, function(a, b)
            return a.groupWeight < b.groupWeight
        end)
        -- 头饰按品质-权重排序
        table.sort(l_HeadDatas, function(a, b)
            --品质
            if a.ItemQuality > b.ItemQuality then
                return true
            end
            --权重
            return a.groupWeight < b.groupWeight
        end)
        for i = 1, #l_ItemDatas do
            table.insert(l_ShowItems.BCHeadWear[0], l_ItemDatas[i])
        end
        for i = 1, #l_HeadDatas do
            table.insert(l_ShowItems.BCHeadWear[0], l_HeadDatas[i])
        end

        -- 根据头饰部位缓存头饰
        for i = 1, #l_ShowItems.BCHeadWear[0] do
            local l_Data = TableUtil.GetOrnamentTable().GetRowByOrnamentID(l_ShowItems.BCHeadWear[0][i].item_id, true)
            -- 是头饰
            if l_Data then
                l_ShowItems.BCHeadWear[0][i].ID = l_Data.OrnamentID
                l_ShowItems.BCHeadWear[0][i].ButtonMethod = function()
                    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_Data.OrnamentID, nil, Data.BagModel.WeaponStatus.EXTRACT_CARD)
                end
                -- 尾巴去掉不能占用5 稀有饰品材料给5用
                --bug=1079470 --user=李斌 【KR.DEV.CBT2分支】【魔力头饰机】【必现】抽卡机内的分解，有“尾部”分类 https://www.tapd.cn/20332331/s/1661023
                if l_Data.OrnamentType ~= 5 then
                    table.insert(l_ShowItems.BCHeadWear[l_Data.OrnamentType], l_ShowItems.BCHeadWear[0][i])
                end
            else
                --OrnamentTable没有说明是稀有饰品材料
                l_Data = TableUtil.GetItemTable().GetRowByItemID(l_ShowItems.BCHeadWear[0][i].item_id)
                l_ShowItems.BCHeadWear[0][i].ID = l_Data.ItemID
                l_ShowItems.BCHeadWear[0][i].IsShowCount = true
                l_ShowItems.BCHeadWear[0][i].Count = l_ShowItems.BCHeadWear[0][i].num
                l_ShowItems.BCHeadWear[0][i].ButtonMethod = function()
                    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_Data.ItemID, nil, Data.BagModel.WeaponStatus.EXTRACT_CARD)
                end
                table.insert(l_ShowItems.BCHeadWear[5], l_ShowItems.BCHeadWear[0][i])
            end
        end
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        l_ShowItems.ACard = {}
        l_ShowItems.BCCard = {}
        local l_ArrowNames = GetCurrentArrowNames()
        for i = 1, #l_ArrowNames do
            l_ShowItems.ACard[i - 1] = {}
            l_ShowItems.BCCard[i - 1] = {}
        end
        SetPackDataByAwardID(CardAAwardID, l_ShowItems.ACard)
        SetArrowData(l_ShowItems.ACard)
        SetPackDataByAwardID(CardBCAwardID, l_ShowItems.BCCard)
        SetArrowData(l_ShowItems.BCCard)
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        l_ShowItems.AEquip = {}
        l_ShowItems.BCEquip = {}
        local l_ArrowNames = GetCurrentArrowNames()
        for i = 1, #l_ArrowNames do
            l_ShowItems.AEquip[i - 1] = {}
            l_ShowItems.BCEquip[i - 1] = {}
        end
        SetPackDataByAwardID(EquipAAwardID, l_ShowItems.AEquip)
        SetArrowData(l_ShowItems.AEquip)
        SetPackDataByAwardID(EquipBCAwardID, l_ShowItems.BCEquip)
        SetArrowData(l_ShowItems.BCEquip)
    end
    return l_ShowItems
end
-- 通过奖池id设置当前奖池的数据
function SetPackDataByAwardID(awardid, data)
    -- 对应的奖励包id PackIds
    local l_AwardData = TableUtil.GetAwardTable().GetRowByAwardId(awardid)
    if l_AwardData then
        for i = 0, l_AwardData.PackIds.Count - 1 do
            local l_AwardPackData = TableUtil.GetAwardPackTable().GetRowByPackId(l_AwardData.PackIds[i])
            if l_AwardPackData then
                local l_ItemList = {}
                MgrMgr:GetMgr("AwardPreviewMgr").GetAllItemByAwardPackId(l_AwardPackData.PackId, l_ItemList)
                for _, v in ipairs(l_ItemList) do
                    local l_Data = {
                        ID = v.item_id,
                        IsShowName = true,
                        IsShowCount = false,
                        item_id = v.item_id,
                        groupWeight = v.groupWeight,
                        count = v.count,
                        num = v.count,
                        ButtonMethod = function()
                            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(v.item_id, nil, Data.BagModel.WeaponStatus.EXTRACT_CARD)
                        end
                    }
                    local l_ItemInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(l_Data.item_id), true)
                    if l_ItemInfo then
                        l_Data.ItemQuality = l_ItemInfo.ItemQuality
                        l_Data.TypeTab = l_ItemInfo.TypeTab
                        table.insert(data[0], l_Data)
                    else
                        logError("ItemTable id error " .. l_Data.item_id)
                    end
                end
            else
                logError("AwardPackTable not have id " .. l_AwardData.PackIds[i])
            end
        end
    else
        logError("AwardTable not have id " .. awardid)
    end
    -- 排序
    table.sort(data[0], function(a, b)
        if a.ItemQuality > b.ItemQuality then
            return true
        elseif a.ItemQuality == b.ItemQuality then
            if a.groupWeight < b.groupWeight then
                return true
            else
                return false
            end
        else
            return false
        end
    end)
end
-- 设置页签对应数据
function SetArrowData(data)
    if CurrentMachineType == EMagicExtractMachineType.Card then
        -- 根据装备部位缓存卡片
        for i = 1, table.ro_size(MgrMgr:GetMgr("EquipMgr").eEquipTypeName) do
            for j = 1, #data[0] do
                local l_Data = TableUtil.GetEquipCardTable().GetRowByID(data[0][j].item_id)
                if l_Data then
                    for k = 0, l_Data.CanUsePosition.Length - 1 do
                        if l_Data.CanUsePosition[k] == i then
                            table.insert(data[i], data[0][j])
                            break
                        end
                    end
                else
                    logError("EquipCardTable not have id " .. data[0][j].item_id)
                end
            end
        end
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        -- 1是装备，其他的都是道具分类
        for i = 1, #data[0] do
            if data[0][i].TypeTab == 1 then
                table.insert(data[1], data[0][i])
            else
                table.insert(data[2], data[0][i])
            end
        end
    end
end
-- 获取当前npc的table数据
function GetCurrentNPCIdTbl()
    if CurrentMachineType == EMagicExtractMachineType.HeadWear then
        return Common.CommonUIFunc.GetNpcIdTbByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractHead)
    elseif CurrentMachineType == EMagicExtractMachineType.Card then
        return Common.CommonUIFunc.GetNpcIdTbByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractCard)
    elseif CurrentMachineType == EMagicExtractMachineType.Equip then
        return Common.CommonUIFunc.GetNpcIdTbByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractEquip)
    end
end

function OnLeaveScene(sceneId)
    UIMgr:DeActiveUI(UI.CtrlNames.MagicExtractMachine)
end

return ModuleMgr.MagicExtractMachineMgr