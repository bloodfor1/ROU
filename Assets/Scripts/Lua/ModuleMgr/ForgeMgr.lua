---@module ModuleMgr.ForgeMgr
module("ModuleMgr.ForgeMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

ForgeTaskChangeEvent = "ForgeTaskChangeEvent"
--打造成功服务器返回打造的装备数据
ForgeEquipSucceed = "ForgeEquipSucceed"

local C_WEAPON_FORGE_KEY = "ForgeWeaponHint"
local C_ARMOR_FORGE_KEY = "ForgeArmorHint"
local C_GLOBAL_KEY_MAP = {
    [true] = C_WEAPON_FORGE_KEY,
    [false] = C_ARMOR_FORGE_KEY,
}

local strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")
local _moduleForgeData = DataMgr:GetData("ForgeData")
local recommendMapMgr = MgrMgr:GetMgr("RecommendMapMgr")
local forgeSchoolRecommendMgr = MgrMgr:GetMgr("ForgeSchoolRecommendMgr")

--全局表的数据
ForgeLevelShow = _moduleForgeData.ForgeLevelShow
ForgeLevelShowSection = _moduleForgeData.ForgeLevelShowSection
ForgeLevelShowArmor = _moduleForgeData.ForgeLevelShowArmor
ForgeLevelShowSectionArmor = _moduleForgeData.ForgeLevelShowSectionArmor

eForgeType = {
    ForgeWeapon = 1,
    ForgeArmor = 2,
}

CurrentSelectIndex = 0

--需要选中的装备id
NeedSelectEquipId = nil

--已经打造的装备id
_forgedEquipIds = nil

--缓存材料追踪任务ID列表
ForgeTaskIds = {}
--缓存着所有的可显示的装备
EquipForgeDatas = {}
CacheRecommendDatas = nil

--缓存的所有可打造的装备的等级
local _forgeLevelRanges = nil

--缓存的玩家的所有父职业
local l_cachePlayerParentProfession = nil
StartForgeTasks = {}
CurrentForgeId = eForgeType.ForgeWeapon
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function GotoForgeWithId(id)
    local l_equipForgeTableInfo = TableUtil.GetEquipForgeTable().GetRowById(id)
    if l_equipForgeTableInfo == nil then
        return
    end

    if l_equipForgeTableInfo.Type == 1 then
        Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeWeapon, id)
    else
        Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeArmor, id)
    end
end

function OpenForge(forgeId, equipId)
    CurrentForgeId = tonumber(forgeId)
    NeedSelectEquipId = equipId
    if _forgedEquipIds == nil then
        RequestEquipForgedList()
    else
        OpenForgePanel()
    end
end

--取当前需要显示的等级区间
function GetCurrentShowLevel()
    if NeedSelectEquipId then
        local l_equipForgeTableInfo = TableUtil.GetEquipForgeTable().GetRowById(NeedSelectEquipId)
        if l_equipForgeTableInfo then
            return l_equipForgeTableInfo.ForgeLevel
        else
            NeedSelectEquipId = nil
        end
    end
    return MPlayerInfo.Lv
end

function IsWeaponForge()
    if CurrentForgeId == eForgeType.ForgeWeapon then
        return true
    end
    return false
end

function GetForgeLevelShow()
    if IsWeaponForge() then
        return ForgeLevelShow
    else
        return ForgeLevelShowArmor
    end
end

function GetForgeLevelShowSection()
    if IsWeaponForge() then
        return ForgeLevelShowSection
    else
        return ForgeLevelShowSectionArmor
    end
end

function OpenForgePanel()
    UIMgr:ActiveUI(UI.CtrlNames.Forge)
end

function RequestEquipForgedList()
    local l_msgId = Network.Define.Rpc.RequestEquipForgedList
    ---@type RequestEquipForgedListArg
    local l_sendInfo = GetProtoBufSendTable("RequestEquipForgedListArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveEquipForgedList(msg)
    ---@type RequestEquipForgedListRes
    local l_info = ParseProtoBufToTable("RequestEquipForgedListRes", msg)
    _forgedEquipIds = {}
    for i = 1, #l_info.forged_list do
        table.insert(_forgedEquipIds, l_info.forged_list[i].value)
    end

    OpenForgePanel()
end

--请求打造装备
function RequestForgeEquip(itemId)
    local l_msgId = Network.Define.Rpc.ForgeEquip
    ---@type ForgeEquipArg
    local l_sendInfo = GetProtoBufSendTable("ForgeEquipArg")
    l_sendInfo.item_id = itemId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveForgeEquip(msg)
    ---@type ForgeEquipRes
    local l_info = ParseProtoBufToTable("ForgeEquipRes", msg)
    MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_info.error)
end

--是否已经打造过了
function IsForged(id)
    local containerList = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.WareHouse,
    }

    local count = Data.BagApi:GetItemCountByContListAndTid(containerList, id)
    return 0 < count
end

function IsCanForge(equipForgeTableData)
    if MPlayerInfo.Lv < equipForgeTableData.ForgeLevel then
        return false
    end
    return true
end

---@param itemUpdateData ItemUpdateData[]
function _onItemUpdate(itemUpdateData)
    if nil == itemUpdateData then
        logError("[ForgeMgr] invalid param")
        return
    end

    local targetItem = nil
    for i = 1, #itemUpdateData do
        local singleUpdateData = itemUpdateData[i]
        if nil ~= singleUpdateData.NewItem
                and nil == singleUpdateData.OldItem
                and ItemChangeReason.ITEM_REASON_FORGE == singleUpdateData.Reason
        then
            targetItem = singleUpdateData.NewItem
        end
    end

    if nil == targetItem then
        return
    end

    ReceiveForgeEquipData(targetItem)
end

---@param equipData ItemData
function ReceiveForgeEquipData(equipData)
    if not table.ro_contains(_forgedEquipIds, equipData.TID) then
        table.insert(_forgedEquipIds, equipData.TID)
    end

    EventDispatcher:Dispatch(ForgeEquipSucceed, equipData)
end

--返回当前可显示的所有等级区间,int
function GetShowLevelRanges()
    local l_forgeLevelShow = GetForgeLevelShow()
    local currentRangeIndex = GetLevelRangeIndexWithCurrentLevel()
    local MinRange = currentRangeIndex - tonumber(l_forgeLevelShow[0])
    if MinRange < 2 then
        MinRange = 2
    end
    local MaxRange = currentRangeIndex + tonumber(l_forgeLevelShow[1])
    local l_forgeLevelShowSection = GetForgeLevelShowSection()
    if MaxRange > l_forgeLevelShowSection.Length then
        MaxRange = l_forgeLevelShowSection.Length
    end

    local showRanges = {}
    for i = MinRange, MaxRange do
        table.insert(showRanges, i)
    end

    return showRanges
end

--获取当前等级的等级区间的index
function GetLevelRangeIndexWithCurrentLevel()
    return GetLevelRangeIndexWithLevel(MPlayerInfo.Lv)
end
function GetLevelRangeIndexWithLevel(level)
    local l_forgeLevelShowSection = GetForgeLevelShowSection()

    local index = l_forgeLevelShowSection.Length - 1
    for i = 0, l_forgeLevelShowSection.Length - 1 do
        if tonumber(l_forgeLevelShowSection[i]) > level then
            index = i
            break
        end
    end
    return index + 1
end

function GetCachePlayerParentProfession()
    if l_cachePlayerParentProfession == nil then
        l_cachePlayerParentProfession = MgrMgr:GetMgr("EquipMgr").GetPlayerParentProfession()
    end
    return l_cachePlayerParentProfession
end

function CleanForgeData()
    EquipForgeDatas = {}
    CacheRecommendDatas = nil
    l_cachePlayerParentProfession = nil
end

--得到可以显示的所有的装备数据
--EquipForgeTable表数据
function GetAllCanShowEquips()
    if CacheRecommendDatas == nil then
        CacheRecommendDatas = {}

        local levelRanges = GetShowLevelRanges()
        for i = 1, #levelRanges do
            local datas = GetEquips(levelRanges[i])
            for j = 1, #datas do
                local l_equip = TableUtil.GetEquipTable().GetRowById(datas[j].Id)
                if l_equip then
                    if CacheRecommendDatas[l_equip.EquipId] == nil then
                        CacheRecommendDatas[l_equip.EquipId] = {}
                    end
                    table.insert(CacheRecommendDatas[l_equip.EquipId], datas[j])
                else
                    logError("EquipTable表中没有这条数据，id：" .. datas[j].Id)
                end
            end
        end
    end

    return CacheRecommendDatas
end

--得到符合条件的装备，EquipForgeTable表数据
--levelRangeIndex等级区间,为GlobalTable中的相应index
function GetEquips(levelRangeIndex)
    local l_showEquipForgeDatas = EquipForgeDatas[levelRangeIndex]
    if l_showEquipForgeDatas == nil then
        l_showEquipForgeDatas = {}
        local EquipForgeTable = TableUtil.GetEquipForgeTable().GetTable()
        for i = 1, #EquipForgeTable do
            if IsEligible(EquipForgeTable[i], levelRangeIndex) then
                table.insert(l_showEquipForgeDatas, EquipForgeTable[i])
            end
        end

        EquipForgeDatas[levelRangeIndex] = l_showEquipForgeDatas
    end

    local ret = _filtrateForgeData(l_showEquipForgeDatas)
    SortEquipForgeDatas(ret)
    return ret
end

---@param forgeDataList EquipForgeTable[]
function _filtrateForgeData(forgeDataList)
    if nil == forgeDataList then
        return nil
    end

    local ret = {}
    for i = 1, #forgeDataList do
        local singleForgeData = forgeDataList[i]
        if _equipMatchSchool(singleForgeData) then
            table.insert(ret, singleForgeData)
        end
    end

    return ret
end

---@param equipForgeConfig EquipForgeTable
function _equipMatchSchool(equipForgeConfig)
    if nil == equipForgeConfig then
        logError("[ForgeMgr] invalid param")
        return false
    end

    --- 如果是0说明当前不需要筛选
    local schoolID = forgeSchoolRecommendMgr.GetSelectID()
    if 0 == schoolID then
        return true
    end

    local ret = recommendMapMgr.ItemMatchesSchool(schoolID, equipForgeConfig.Id)
    return ret
end

function SortEquipForgeDatas(showEquipForgeDatas)
    table.sort(showEquipForgeDatas, function(a, b)

        local l_isForgedA = IsForged(a.Id)
        local l_isForgedB = IsForged(b.Id)
        local l_isCanForgeA = IsCanForge(a)
        local l_isCanForgeB = IsCanForge(b)

        --都可制作并且已制作
        --都可制作并且未制作
        --都不可制作并且未制作
        --都不可制作并且已制作（这种情况不可能有）
        if l_isCanForgeA == l_isCanForgeB and l_isForgedA == l_isForgedB then
            local l_equipMgr = MgrMgr:GetMgr("EquipMgr")
            local l_equipLevelA = l_equipMgr.GetEquipLimitLevel(a.Id)
            local l_equipLevelB = l_equipMgr.GetEquipLimitLevel(b.Id)
            if l_equipLevelA == l_equipLevelB then
                return a.SortId < b.SortId
            else
                return l_equipLevelA < l_equipLevelB
            end
        else
            --都可制作，一个已制作一个未制作
            --都不可制作，一个已制作一个未制作（这种情况不可能有）
            --已制作的排后面
            if l_isCanForgeA == l_isCanForgeB then
                return l_isForgedB
            else
                --当一个可制作一个不可制作的时候，可制作的排前面
                return l_isCanForgeA
            end
        end
    end)
end

--是否符合显示的逻辑
function IsEligible(equipForgeTableItem, levelRangeIndex)
    if CurrentForgeId ~= equipForgeTableItem.Type then
        return false
    end

    local l_forgeLevelShowSection = GetForgeLevelShowSection()
    local l_ForgeLevelShowSectionIndex = levelRangeIndex - 1
    if l_ForgeLevelShowSectionIndex < 0 then
        return false
    end
    if l_ForgeLevelShowSectionIndex >= l_forgeLevelShowSection.Length then
        return false
    end
    local max = tonumber(l_forgeLevelShowSection[l_ForgeLevelShowSectionIndex])
    local min
    if l_ForgeLevelShowSectionIndex == 0 then
        min = 0
    else
        min = tonumber(l_forgeLevelShowSection[l_ForgeLevelShowSectionIndex - 1])
    end
    local l_equipForgeLevel = equipForgeTableItem.ForgeLevel
    if not (l_equipForgeLevel > min and l_equipForgeLevel <= max) then
        return false
    end

    if MPlayerInfo.Lv < equipForgeTableItem.ShowLevel then
        return false
    end

    return _isForgeTableInfoConformPlayer(equipForgeTableItem)

end

--打造表中的数据是否符合当前玩家的数据（性别、职业）
function _isForgeTableInfoConformPlayer(forgeTableInfo)

    local l_equipTableInfo = TableUtil.GetEquipTable().GetRowById(forgeTableInfo.Id, true)
    if l_equipTableInfo == nil then
        return false
    end

    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(forgeTableInfo.Id, true)
    if l_itemTableInfo == nil then
        return false
    end

    local sexlimit = l_itemTableInfo.SexLimit
    local sex = MPlayerInfo.IsMale and 0 or 1
    if sexlimit ~= 2 and sexlimit ~= sex then
        return false
    end

    if not MgrMgr:GetMgr("EquipMgr").IsPlayerConformProfessionWithPlayerParentProfession(l_itemTableInfo.Profession, GetCachePlayerParentProfession()) then
        return false
    end

    return true
end

--材料是否足够打造
function IsForgeMaterialsEnough(equipForgeData)
    local h = equipForgeData.ForgeMaterials
    local forgeMaterials = Common.Functions.VectorSequenceToTable(h)
    for i = 1, #forgeMaterials do
        local forgeMaterial = forgeMaterials[i]
        local id = forgeMaterial[1]
        local needCount = forgeMaterial[2]
        local currentCount = Data.BagModel:GetCoinOrPropNumById(id)
        if currentCount < needCount then
            return false
        end
    end

    return true
end

---@return boolean, string
function ShowHint(isWeapon)
    local tableKey = C_GLOBAL_KEY_MAP[isWeapon]
    local targetStr = TableUtil.GetGlobalTable().GetRowByName(tableKey)
    if nil == targetStr then
        return false, ""
    end

    local lvRange = strParseMgr.ParseValue(targetStr.Value, GameEnum.EStrParseType.Matrix, GameEnum.ELuaBaseType.Number)
    for i = 1, #lvRange do
        local minLv = lvRange[i][1]
        local maxLv = lvRange[i][2]
        if MPlayerInfo.Lv >= minLv and MPlayerInfo.Lv < maxLv then
            local str = StringEx.Format(Common.Utils.Lang("C_FROGE_LV_HINT_STR"), maxLv)
            return true, str
        end
    end

    return false, ""
end

function IsRecommend(equipForgeData)
    if IsForged(equipForgeData.Id) then
        return false
    end

    if equipForgeData.ForgeLevel > MPlayerInfo.Lv then
        return false
    end

    local l_allEquips = GetAllCanShowEquips()
    local l_equip = TableUtil.GetEquipTable().GetRowById(equipForgeData.Id)
    if l_equip then
        local l_equips = l_allEquips[l_equip.EquipId]
        if l_equips == nil then
            return false
        end
        local l_equipMgr = MgrMgr:GetMgr("EquipMgr")
        local l_currentEquipLevel = l_equipMgr.GetEquipLimitLevel(equipForgeData.Id)
        for i = 1, #l_equips do
            if l_equips[i].ForgeLevel <= MPlayerInfo.Lv then
                if l_equipMgr.GetEquipLimitLevel(l_equips[i].Id) > l_currentEquipLevel then
                    return false
                end
            end
        end
    else
        logError("EquipTable表中没有这条数据，id：" .. equipForgeData.Id)
        return false
    end

    return true

end

function isContainEquipId(equipId)
    for i = 1, _moduleForgeData.ForgeHoleSite.Length do
        if _moduleForgeData.ForgeHoleSite[i - 1] == equipId then
            return true
        end
    end
    return false
end

function IsEquipCanShow(equipId)
    local l_equipForgeTableInfo = TableUtil.GetEquipForgeTable().GetRowById(equipId, true)
    if l_equipForgeTableInfo == nil then
        return false
    end
    if MPlayerInfo.Lv < l_equipForgeTableInfo.ShowLevel then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_FORGE", l_equipForgeTableInfo.ShowLevel))
        return false
    end

    return true
end

--打造缓存的数据，在升级和转职后清理
function OnLevelOrProfessionChange()
    _forgeLevelRanges = nil
    CacheRecommendDatas = nil
    EquipForgeDatas = {}
end

--死亡引导相关逻辑

function _getForgeLevelRanges()
    if _forgeLevelRanges == nil then
        _forgeLevelRanges = {}
    else
        return _forgeLevelRanges
    end

    local l_equipForgeTable = TableUtil.GetEquipForgeTable().GetTable()

    for i = 1, #l_equipForgeTable do
        if _isForgeTableInfoConformPlayer(l_equipForgeTable[i]) then
            _addForgeLevelRange(l_equipForgeTable[i])
        end
    end

    for i, _forgeLevelRange in pairs(_forgeLevelRanges) do
        _sortForgeLevelRange(_forgeLevelRange)
    end

    return _forgeLevelRanges
end
function _addForgeLevelRange(equipForgeTableInfo)
    local l_id = equipForgeTableInfo.Id
    local l_equipTableInfo = TableUtil.GetEquipTable().GetRowById(l_id)
    local l_equipType = l_equipTableInfo.EquipId

    local l_forgeLevel = equipForgeTableInfo.ForgeLevel

    if _forgeLevelRanges[l_equipType] == nil then
        _forgeLevelRanges[l_equipType] = {}
    end

    if not table.ro_contains(_forgeLevelRanges[l_equipType], l_forgeLevel) then
        table.insert(_forgeLevelRanges[l_equipType], l_forgeLevel)
    end
end

function _sortForgeLevelRange(forgeLevelRange)
    table.sort(forgeLevelRange, function(x, y)
        return x < y
    end)
end

function _getForgeLevelRangeWithEquipType(equipType)
    local l_forgeLevelRanges = _getForgeLevelRanges()
    return l_forgeLevelRanges[equipType]
end

function GetForgeMaxLevelWithPlayerLevel(equipType)
    local l_forgeLevelRange = _getForgeLevelRangeWithEquipType(equipType)
    if l_forgeLevelRange == nil then
        return 0
    end
    local l_index = 0
    for i = 1, #l_forgeLevelRange do
        if l_forgeLevelRange[i] > MPlayerInfo.Lv then
            l_index = i
            break
        end
    end
    l_index = l_index - 1
    if l_index <= 0 then
        return 0
    end

    return l_forgeLevelRange[l_index]
end

local _canForgeEquipType = {
    --EquipPos.MAIN_WEAPON, --主武器
    --EquipPos.SECONDARY_WEAPON, --副武器
    EquipPos.ARMOR, --盔甲
    EquipPos.CLOAK, --披风
    EquipPos.BOOTS, --靴子
}

function IsBodyEquipMaxLevelWithForge()
    --盔甲、披风、靴子逻辑
    --如果没有装备，不符合
    --如果不大于可打造的装备，不符合
    for i = 1, #_canForgeEquipType do
        local clientEnum = _canForgeEquipType[i] + 1
        local propInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, clientEnum)
        if propInfo == nil then
            if IsCanForgeEquip(_canForgeEquipType[i]) then
                return false
            end
        end

        if propInfo ~= nil and not IsEquipLevelConformCurrentMaxForgeLevelRange(propInfo, _canForgeEquipType[i]) then
            return false
        end
    end

    --主武器逻辑
    --如果没有装备，不符合
    --如果不大于可打造的装备，不符合
    local l_mainWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.MAIN_WEAPON + 1)
    if l_mainWeapon == nil then
        --logGreen("没有装备主武器")
        return false
    end

    if not IsEquipLevelConformCurrentMaxForgeLevelRange(l_mainWeapon, EquipPos.MAIN_WEAPON) then
        return false
    end

    if IsNeedDealWithSecondaryWeapon(l_mainWeapon) then
        local l_secondaryWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.SECONDARY_WEAPON + 1)
        if l_secondaryWeapon == nil then
            if IsCanForgeEquip(EquipPos.SECONDARY_WEAPON) then
                --logGreen("没有装备盾牌")
                return false
            end
        end

        if l_secondaryWeapon ~= nil and not IsEquipLevelConformCurrentMaxForgeLevelRange(l_secondaryWeapon, EquipPos.SECONDARY_WEAPON) then
            return false
        end
    end

    return true

end

function IsNeedDealWithSecondaryWeapon(mainWeapon)

    if mainWeapon == nil then
        return true
    end

    local l_HoldingMode = MgrMgr:GetMgr("EquipMgr").GetEquipHoldingModeById(mainWeapon.TID)
    --主武器不是双持武器，需要判断副武器
    if l_HoldingMode ~= MgrMgr:GetMgr("EquipMgr").HoldingModeDouble then
        return true
    end

    --学习了双持武器技能，需要判断副武器
    if MPlayerInfo:GetCurrentSkillInfo(Data.BagModel.AssassinDoubleHandSkillID).lv > 0 then
        return true
    end

    return false
end

--装备使用等级是否大于等于当前可打造的装备的等级
function IsEquipLevelConformCurrentMaxForgeLevelRange(propInfo, equipServerEnum)
    local l_equipType = MgrMgr:GetMgr("BodyEquipMgr").GetEquipPartWithServerEnum(equipServerEnum)
    local l_forgeMaxLevel = GetForgeMaxLevelWithPlayerLevel(l_equipType)
    local l_equipLevel = MgrMgr:GetMgr("EquipMgr").GetEquipLimitLevel(propInfo.TID)
    if l_equipLevel >= l_forgeMaxLevel then
        return true
    end

    return false
end

--装备使用等级是否大于等于当前可打造的装备的等级
function IsCanForgeEquip(equipServerEnum)
    local l_equipType = MgrMgr:GetMgr("BodyEquipMgr").GetEquipPartWithServerEnum(equipServerEnum)
    local l_forgeMaxLevel = GetForgeMaxLevelWithPlayerLevel(l_equipType)
    if l_forgeMaxLevel == 0 then
        return false
    end

    return true
end

--死亡引导相关逻辑


--恢复材料追踪任务
function RecoverForgeTask()
    for i,v in ipairs(ForgeTaskIds) do
        StartForgeTask(v)
    end
end

function OnSelectRoleNtf(l_info)
    for i = 1, #l_info.equips.equip_task_id do
        local l_forgeTaskId = l_info.equips.equip_task_id[i].value
        table.insert(ForgeTaskIds, l_forgeTaskId)
        StartForgeTask(l_forgeTaskId)
    end
end

function StartForgeTask(id, isTaskNeedNavigate)
    table.insert(StartForgeTasks, id)
    MgrMgr:GetMgr("TaskMgr").CreateVirtualTask(MgrMgr:GetMgr("TaskMgr").ETaskVirtualType.EquipForge, id, isTaskNeedNavigate)
end

function IsForgeTaskStart(id)
    local l_isStart = table.ro_contains(StartForgeTasks, id)
    return l_isStart
end

function RequestAddEquipTask(id)
    local l_msgId = Network.Define.Rpc.AddEquipTask
    ---@type AddEquipTaskArg
    local l_sendInfo = GetProtoBufSendTable("AddEquipTaskArg")
    l_sendInfo.equip_task_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveAddEquipTask(msg, data)
    ---@type AddEquipTaskRes
    local l_info = ParseProtoBufToTable("AddEquipTaskRes", msg)
    table.insert(ForgeTaskIds, data.equip_task_id)
    StartForgeTask(data.equip_task_id, true)
    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(data.equip_task_id)
    if l_itemTableInfo == nil then
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("Forge_AddEquipTaskTipsText"), l_itemTableInfo.ItemName))
    EventDispatcher:Dispatch(ForgeTaskChangeEvent)
end

function RequestDevEquipTask(id)
    local l_msgId = Network.Define.Rpc.DelEquipTask
    ---@type DelEquipTaskArg
    local l_sendInfo = GetProtoBufSendTable("DelEquipTaskArg")
    l_sendInfo.equip_task_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveDevEquipTask(msg, data)
    table.ro_removeValue(StartForgeTasks, data.equip_task_id)
    EventDispatcher:Dispatch(ForgeTaskChangeEvent)
    MgrMgr:GetMgr("TaskMgr").DeleteVirtualTask(data.equip_task_id)
    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(data.equip_task_id)
    if l_itemTableInfo == nil then
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("Forge_DelEquipTaskTipsText"), l_itemTableInfo.ItemName))
end

function OnInit()
    Data.PlayerInfoModel.BASELV:Add(Data.onDataChange, OnLevelOrProfessionChange, ModuleMgr.ForgeMgr)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function OnUninit()
    Data.PlayerInfoModel.BASELV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.ForgeMgr)
end

function OnLogout()
    NeedSelectEquipId = nil
    StartForgeTasks = {}
    _forgedEquipIds = nil
    CurrentSelectIndex = 0
    --缓存着所有的可显示的装备
    EquipForgeDatas = {}
    CacheRecommendDatas = nil
    --缓存的所有可打造的装备的等级
    _forgeLevelRanges = nil
    l_cachePlayerParentProfession = nil
    --材料追踪任务ID缓存清理
    ForgeTaskIds = {}
end

-- todo 这个接口后面需要换个地方，会有多个地方复用这个逻辑
---@return string[]
function GetForgeDisplayAttrs(tid)
    local itemConfig = TableUtil.GetItemTable().GetRowByItemID(tid, false)
    if nil == itemConfig then
        return {}
    end

    local EAttrType = GameEnum.EItemAttrModuleType
    local itemData = Data.BagApi:CreateLocalItemData(tid)
    local baseAttrList = itemData.AttrSet[EAttrType.Base]
    local paramBaseAttrs = nil
    if nil ~= baseAttrList then
        paramBaseAttrs = baseAttrList[1]
    end

    local schoolAttrList = itemData.AttrSet[EAttrType.School]
    local paramSchoolAttrs = nil
    if nil ~= schoolAttrList then
        paramSchoolAttrs = schoolAttrList[1]
    end

    local strs = _genAttrDescList(paramBaseAttrs, paramSchoolAttrs, itemData.EquipConfig.EquipText)
    return strs
end

--- 将属性数据转化成为字符串，用来显示
---@param attrList ItemAttrData[]
---@param schoolAttrList ItemAttrData[]
---@return string[]
function _genAttrDescList(attrList, schoolAttrList, equipTextID)
    if nil == attrList then
        logError("[EquipReform] invalid input data")
        return {}
    end

    local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
    local ret = {}
    for i = 1, #attrList do
        local str = attrUtil.GetAttrStr(attrList[i], nil).Desc
        table.insert(ret, str)
    end

    local schoolAttrs = attrUtil.GenItemSchoolAttrStrList(schoolAttrList, nil)
    table.ro_insertRange(ret, schoolAttrs)
    return ret
end

return ModuleMgr.ForgeMgr
