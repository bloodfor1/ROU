---@module ModuleMgr.VehicleInfoMgr
module("ModuleMgr.VehicleInfoMgr", package.seeall)

local l_attrInfoTable = nil   --属性相关信息
local l_lvUpPropInfoTable = {}   --载具升级的道具信息
local l_usingVehicleId = 0   --正在使用的载具ID
local l_proId = 0   --职业载具ID
local l_proLevel = 0  --职业载具等级
local l_proCurExp = 0  --职业载具经验
local l_stage = 0   --职业载具阶数
local l_vehicleCD = nil --载具骑乘CD
local l_showLv = nil --功能显示提前的等级
local l_hasProVehicle = false
local l_maxUseSuperPropNum = 0 --超级卷轴最高可使用次数
local l_superPropRemainUseCount = 0  --超级卷轴剩余可使用次数
local l_permenentVehicleInfo = {}   --永久载具信息
local l_tempSpecialInfo = {}   --临时载具信息
local l_hasCacheJuniorCulture = false  --是否有缓存的初级培养
local l_hasCacheSeniorCulture = false  --是否有缓存的高级培养
local l_proVehicleLvLimitInfo = {}
local l_limit = nil
local l_remainCount = nil  --周剩余可升级次数
local l_waitUpgradeVehicleRet = false  --等待升级载具消息返回
local l_lastReqUpgradeVehicleTime = 0
local l_superAddQualityPropInfos = nil --增加品质的超级卷轴信息
EventDispatcher = EventDispatcher.new()
cultureType =
{
    primary = 1, --初级培养
    senior = 2, --高级培养
}

VehicleAttrQualityType=
{
    Bravery = 1 , --勇猛
    Smart = 2, --机灵
    Love = 3, --爱心
    Lively = 4, --活泼
    Cute = 5, --可爱
}

EventType =
{
    VehicleUseStateChange = 1, --载具使用状态变更
    VehicleUpgrade = 2, --职业载具升级
    VehicleUpgradeLimit = 3, --职业载具素质上限变更
    DevelopVehicleQualitySuc = 4, --职业载具培养成功
    ConfirmVehicleQuality = 5, --确认载具培养成功
    ExchangeSpecialVehicle = 6, --兑换载具成功
    AddOrnamentDyeSuc = 7, --添加配饰或染色成功
    UseOrnamentDyeSuc = 8, --启用配饰或染色成功
    VEHICLE_LEVEL_UP = 9, --载具升级
    ChangeProVehiclePanelInfo = 10, --更改职业载具面板显示的信息
    OnVehicleUseStateChanged = 11,  --载具状态发生变更
    ShowVehicleStagePanel = 12, --展示载具升阶面板
    ShowVehicleAbilityAttrInfo = 13,--展示能力界面的属性提示
    UpdateVehiclePanelChooseVehicle = 14, --更新特色载具面板选中的载具
}
--region----------------------------生命周期-----------------------------------
function OnLogout()
    l_attrInfoTable = nil
    l_lvUpPropInfoTable = {}
    l_usingVehicleId = 0
    l_proId = 0
    l_proLevel = 0
    l_proCurExp = 0
    l_stage = 0
    l_hasProVehicle = false
    l_permenentVehicleInfo = {}
    l_tempSpecialInfo = {}
    l_hasCacheJuniorCulture = false
    l_hasCacheSeniorCulture = false
    l_limit = nil
    l_remainCount = nil
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.OnTaskFinishNotify)
end
--endregion----------------------------生命周期 END-------------------------------

--region-------------------------------custom script---------------------------
function ShowVehicleCharacteristicPanel(vehicleID)
    if UIMgr:IsActiveUI(UI.CtrlNames.VehiclesCharacteristic) then
        EventDispatcher:Dispatch(
                EventType.UpdateVehiclePanelChooseVehicle,defaultChooseVehicleId)
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.VehiclesBG, {
        selectPanel = UI.CtrlNames.VehiclesCharacteristic,
        chooseVehicleId = vehicleID
    })
end

function GetVehicleLevelAndExp()
    return l_proLevel, l_proCurExp
end
function OnTransferProfession()
    GetProfessionVehicleId() --重新计算职业载具ID
end

function CanOpenVehiclePanel()
    local l_tempProId = GetVehicleIdByProfession(MPlayerInfo.ProfessionId)
    return l_tempProId ~= 0
end
---获得载具最大可以升到的阶数
function GetProVehicleMaxStage()
    --todo 旧的系统载具只升一阶
    return 1
end
function GetVehicleQualityAddAttrInfo(qualityId,qualityLevel)
    local l_qualityAttrItem = TableUtil.GetVehicleQualityAttrTable().GetRowByVehicleQuality(qualityLevel)
    if MLuaCommonHelper.IsNull(l_qualityAttrItem) then
        return
    end
    if qualityId == VehicleAttrQualityType.Bravery then
        return l_qualityAttrItem.Attr1
    elseif qualityId == VehicleAttrQualityType.Smart then
        return l_qualityAttrItem.Attr2
    elseif qualityId == VehicleAttrQualityType.Love then
        return l_qualityAttrItem.Attr3
    elseif qualityId == VehicleAttrQualityType.Lively then
        return l_qualityAttrItem.Attr4
    end
    return l_qualityAttrItem.Attr5
end
function GetVehicleLevelAddAttrInfo(qualityId,vehicleLevel)
    local l_qualityAttrItem = TableUtil.GetVehicleAttrTable().GetRowByVehicleLv(vehicleLevel)
    if MLuaCommonHelper.IsNull(l_qualityAttrItem) then
        return
    end
    if qualityId == VehicleAttrQualityType.Bravery then
        return l_qualityAttrItem.Attr1
    elseif qualityId == VehicleAttrQualityType.Smart then
        return l_qualityAttrItem.Attr2
    elseif qualityId == VehicleAttrQualityType.Love then
        return l_qualityAttrItem.Attr3
    elseif qualityId == VehicleAttrQualityType.Lively then
        return l_qualityAttrItem.Attr4
    end
    return l_qualityAttrItem.Attr5
end

function GetVehicleSpeedPercent(vehicleSpeed)
    local l_professionTableInfo = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId, true)
    local l_speedUpPercent = 120
    if l_professionTableInfo == nil then
        return l_speedUpPercent
    end
    l_speedUpPercent = math.modf( vehicleSpeed / l_professionTableInfo.MoveSpeed * 100)
    if l_speedUpPercent==0 then
        l_speedUpPercent = 120
    end
    return l_speedUpPercent
end

function GetVehicleStageUpLimitLevel(targetStage)
    if targetStage ==nil then
        targetStage = l_stage + 1
    end
    --获取载具升阶所需的载具等级限制
    local l_limitLevel = -1
    local l_vehicleQuaItem = TableUtil.GetVehicleQualityTable().GetRowById(1)
    if MLuaCommonHelper.IsNull(l_vehicleQuaItem) then
        logError("GetVehicleStageUpLimitLevel 无法获取VehicleQualityTable数据！")
        return l_limitLevel
    end
    if targetStage == 1 then
        return l_vehicleQuaItem.OnceLv
    --暂不开放
    --elseif targetStage == 2 then
    --    return l_vehicleQuaItem.OnceLv
    end
    return -1
end
function GetLevelUpPropData()
    if #l_lvUpPropInfoTable < 1 then
        local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleLvConsume")
        if l_row ~= nil then
            local l_itemSplitStr = Common.Utils.ParseString(l_row.Value, "|", 1)
            if l_itemSplitStr ~= nil then
                for i = 1, #l_itemSplitStr do
                    local l_itemSplStr = Common.Utils.ParseString(l_itemSplitStr[i], "=", 2)
                    if l_itemSplStr ~= nil then
                        table.insert(l_lvUpPropInfoTable, {
                            itemId = tonumber(l_itemSplStr[1]),
                            addExp = tonumber(l_itemSplStr[2])
                        })
                    end
                end
            end
        end
        local l_specialConsumeRow = TableUtil.GetGlobalTable().GetRowByName("VehicleLvSpecialConsume")
        if l_specialConsumeRow ~= nil then
            local l_itemSplStr = Common.Utils.ParseString(l_specialConsumeRow.Value, "=", 2)
            if l_itemSplStr ~= nil then
                table.insert(l_lvUpPropInfoTable, {
                    itemId = tonumber(l_itemSplStr[1]),
                    addExp = tonumber(l_itemSplStr[2])
                })
            end
        end
    end
    return l_lvUpPropInfoTable
end

---根据品质id获得超级卷轴的道具信息
function GetSuperPropInfoByQualityID(qualityID)
    if l_superAddQualityPropInfos==nil then
        local  l_scrollEffectItems = Common.Functions.VectorSequenceToTable(MGlobalConfig:GetVectorSequence("VehicleScrollEffect"))
        l_superAddQualityPropInfos = {}
        for k,v in pairs(l_scrollEffectItems) do
            l_superAddQualityPropInfos[v[2]] = v
        end
    end
    return l_superAddQualityPropInfos[tostring(qualityID)]
end

function GetSuperExpPropId()
    --获取超级经验道具（不消耗次数）
    local l_lvupInfo = GetLevelUpPropData()
    local l_propNum = #l_lvupInfo
    return l_lvupInfo[l_propNum].itemId     --最后一个为超级经验道具，不消耗次数
end
function GetExpByItemId(itemId)
    --根据载具升级道具id获得增加的经验值
    local l_lvUpTable = GetLevelUpPropData()
    for i = 1, #l_lvUpTable do
        local l_lvUpInfo = l_lvUpTable[i]
        if l_lvUpInfo.itemId == itemId then
            return l_lvUpInfo.addExp
        end
    end
    return 0
end

function OnTaskStateChanged(taskId)
    local vehicleData = TableUtil.GetGlobalTable().GetRowByName("VehicleTaskId")
    if not MLuaCommonHelper.IsNull(vehicleData) then
        local l_vehicleTaskId = tonumber(vehicleData.Value)
        if l_vehicleTaskId == taskId then
            local l_professionVehicleId = GetProfessionVehicleId()
            if l_professionVehicleId ~= nil and l_professionVehicleId ~= 0 then
                MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(l_professionVehicleId, 1, function()
                    UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
                    UIMgr:ActiveUI(UI.CtrlNames.VehiclesBG, {
                        selectPanel = UI.CtrlNames.VehiclesOccupation,
                    })
                end)
            else
                logError("非法渠道尝试获取职业载具，需要转职成功方可获取!")
            end
            RefreshVehicleState()
        end
    end
end
function RefreshVehicleState()
    if not UIMgr:IsPanelShowing(UI.CtrlNames.Vehicle) then
        UIMgr:ActiveUI(UI.CtrlNames.Vehicle)
    end
    EventDispatcher:Dispatch(EventType.OnVehicleUseStateChanged)
end
function HasVehicle()
    if HasProfessionVehicle() then
        return true
    end
    for k, v in pairs(l_permenentVehicleInfo) do
        --拥有永久载具
        if k ~= l_proId and v ~= nil then
            return true
        end
    end
    for _, v in pairs(l_tempSpecialInfo) do
        --拥有临时载具
        if v ~= nil then
            return true
        end
    end
    return false
end
function GetAttrInfoData()
    if l_attrInfoTable ~= nil then
        return l_attrInfoTable
    end
    local l_vehicleQualityTable = TableUtil.GetVehicleQualityTable().GetTable()
    l_attrInfoTable = {}
    for i, row in ipairs(l_vehicleQualityTable) do
        l_attrInfoTable[row.Id] = {
            Id = row.Id,
            Name = row.Name,
            Atlas = row.Atlas,
            ItemIcon = row.ItemIcon,
            totalValue = 0,
            primaryTrain = 0,
            seniorTrain = 0,
            trainValue = 0,
            trainValueLimit = 1,
            showQualityType = cultureType.primary, --默认显示初级培养属性
        }
    end
    l_attrInfoTable.hasPrimaryCulture = false   --是否存在初级培养缓存值
    l_attrInfoTable.hasSeniorCulture = false    --是否存在高级培养缓存值
    return l_attrInfoTable
end
function UpdateAttTotalValue()
    local l_attInfos = GetAttrInfoData()
    for i, info in ipairs(l_attInfos) do
        info.totalValue = CountTotalAttrValueInner(info.trainValue, i,l_proLevel)
    end
end
function GetAttrInfoById(id)
    local l_allAttrInfo = GetAttrInfoData()
    local l_attInfo = l_allAttrInfo[id]
    if l_attInfo == nil then
        logError("@周阳VehicleQualityTable not exist Item ID:" .. tostring(id))
        l_attInfo = {}
    end
    return l_attInfo
end

function GetNextStageInfo()
    --获得升级下阶所需数据
    local l_currentStage = 0
    local l_vehicleQuaItem = TableUtil.GetVehicleQualityTable().GetRowById(1)
    if MLuaCommonHelper.IsNull(l_vehicleQuaItem) then
        logError("GetNextStageInfo 无法获取VehicleQualityTable数据！")
        return
    end
    if l_currentStage == 0 then
        return l_vehicleQuaItem.OnceLv, l_vehicleQuaItem.OnceConsume
    end
end

function ClearAttrInfoData()
    l_attrInfoTable = nil
end
function HasProfessionVehicle()
    if not l_hasProVehicle then
        local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
        local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleTaskId")
        if not MLuaCommonHelper.IsNull(l_row) then
            l_hasProVehicle = l_taskMgr.CheckTaskFinished(tonumber(l_row.Value))
        end
    end
    return l_hasProVehicle
end
function OnGetProfessionVehicle()
    l_hasProVehicle = true
end
function GetProfessionVehicleId()
    if l_proId == 0 then
        l_proId = GetVehicleIdByProfession(MPlayerInfo.ProfessionId)
    end
    return l_proId
end
function updateTempVehicleState()
    local l_nowTimeStamp = Common.TimeMgr.GetNowTimestamp()
    for k, v in pairs(l_tempSpecialInfo) do
        if v <= l_nowTimeStamp then
            if l_usingVehicleId == k then
                l_usingVehicleId = 0
            end
            l_tempSpecialInfo[k] = nil
        end
    end
end
function GetTempVehicleDeadLine(vehicleId)
    --获取临时载具到期时间
    if IsPermentVehicle(vehicleId) then
        return nil
    end
    if l_tempSpecialInfo[vehicleId] and l_tempSpecialInfo[vehicleId] <= Common.TimeMgr.GetNowTimestamp() then
        updateTempVehicleState()
        return nil
    end
    return l_tempSpecialInfo[vehicleId]
end

function IsPermentVehicle(vehicleId)
    --是否永久载具
    if l_permenentVehicleInfo[vehicleId] == nil then
        return false
    end
    return true
end
function GetPermentVehicleData(vehicleId)
    --获取永久载具数据
    local l_permenentInfo = l_permenentVehicleInfo[vehicleId]
    if l_permenentInfo == nil and vehicleId == l_proId then
        AddPermenentVehicleInfo(l_proId, nil, nil)
        l_permenentInfo = l_permenentVehicleInfo[vehicleId]
    end
    return l_permenentInfo
end
--- 尝试获取有效的载具数据
function TryGetValidVehicle(vehicleId)
    local l_vehicleData = GetPermentVehicleData(vehicleId)
    if l_vehicleData~=nil then
        return l_vehicleData
    end
    local l_tempVehicleDeadLine = GetTempVehicleDeadLine(vehicleId)
    if l_tempVehicleDeadLine~=nil then
        l_vehicleData = createNewVehicleData()
        return l_vehicleData
    end
    return nil
end
function GetProVehicleUseLv()
    --职业载具启用等级
    local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleUseLv")
    local l_lv = 25
    if not l_row then
        l_lv = tonumber(l_row.value)
    end
    return l_lv
end

function GetProVehicleLvLimit()
    local l_lvLimit = 50
    local l_nextLimitNeedRoleLevel = 0
    if #l_proVehicleLvLimitInfo <= 0 then
        local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleLvLimit")
        if l_row then
            local l_lvLimitSplit = Common.Utils.ParseString(l_row.Value, "|", 1)
            if l_lvLimitSplit ~= nil then
                for i = 1, #l_lvLimitSplit do
                    local l_limitSplit = Common.Utils.ParseString(l_lvLimitSplit[i], "=", 3)
                    if l_limitSplit ~= nil then
                        table.insert(l_proVehicleLvLimitInfo, {
                            minLevel = tonumber(l_limitSplit[1]),
                            maxLevel = tonumber(l_limitSplit[2]),
                            limit = tonumber(l_limitSplit[3]),
                        })
                    end
                end
            end
        end
    end
    local l_limitInfoNum = #l_proVehicleLvLimitInfo
    for i = 1, l_limitInfoNum do
        local l_info = l_proVehicleLvLimitInfo[i]
        if l_limitInfoNum == i then
            l_lvLimit = l_info.limit
            l_nextLimitNeedRoleLevel = -1
        end
        if MPlayerInfo.Lv >= l_info.minLevel and MPlayerInfo.Lv < l_info.maxLevel then
            l_lvLimit = l_info.limit
            l_nextLimitNeedRoleLevel = l_info.maxLevel
            break
        end
    end
    return l_lvLimit, l_nextLimitNeedRoleLevel
end

function GetVehicleHeadInfo(vehicleID,dyeID)
    local l_vehicleItem = TableUtil.GetItemTable().GetRowByItemID(vehicleID)
    if MLuaCommonHelper.IsNull(l_vehicleItem) then
        return
    end
    local l_itemAtlas = l_vehicleItem.ItemAtlas
    local l_itemIcon = l_vehicleItem.ItemIcon
    if dyeID > 0  then
        local l_colorImg = TableUtil.GetVehicleColorationTable().GetRowByColorationID(dyeID)
        if not MLuaCommonHelper.IsNull(l_colorImg) then
            if string.len(l_colorImg.ItemAtlas)>0 then
                l_itemAtlas = l_colorImg.ItemAtlas
                l_itemIcon = l_colorImg.ItemIcon
            end
        end
    end
    return l_itemAtlas,l_itemIcon
end

function GetVehicleIdByProfession(professionId)
    --根据职业ID获取载具ID
    local l_parentProfession = math.floor(professionId / 1000) * 1000
    local l_vehicle = TableUtil.GetVehicleTable().GetTable()
    local l_vehicleId = 0

    for i = 1, #l_vehicle do
        local l_vehicleItem = l_vehicle[i]
        if l_vehicleItem.Type[0] == 1 and l_vehicleItem.Type[1] == l_parentProfession then
            l_vehicleId = l_vehicleItem.ID
            break
        end
    end
    return l_vehicleId
end

function CountTotalAttrValueInner(qualityValue, attrId,vehicleLevel)
    local l_addAttrValue = 0
    local l_leverAddAttrInfo = GetVehicleLevelAddAttrInfo(attrId,vehicleLevel)
    if l_leverAddAttrInfo ==nil then
        return l_addAttrValue
    end
    l_addAttrValue = l_leverAddAttrInfo[2]
    if qualityValue==0 then
        return l_addAttrValue
    end
    local l_attrInfo =  GetVehicleQualityAddAttrInfo(attrId,qualityValue)
    if l_attrInfo ==nil then
        return l_addAttrValue
    end
    l_addAttrValue = l_addAttrValue + l_attrInfo[2]
    return l_addAttrValue
end

function createNewVehicleData()
    return {
        ornamentIds = {
            cur_equip = 0,
        },
        dyeIds = {
            cur_equip = 0,
        }
    }
end

function AddPermenentVehicleInfo(vehicleId, ornamentIds, dyeIds)
    if vehicleId <= 0 then
        return
    end
    local l_specialData = l_permenentVehicleInfo[vehicleId]
    if l_specialData == nil then
        l_specialData = createNewVehicleData()
        l_permenentVehicleInfo[vehicleId] = l_specialData
    else
        l_specialData.ornamentIds = {
            cur_equip = 0,
        }
        l_specialData.dyeIds = {
            cur_equip = 0,
        }
    end
    if ornamentIds ~= nil then
        l_specialData.ornamentIds.cur_equip = ornamentIds.cur_equip
        if l_specialData.ornamentIds.cur_equip == nil then
            l_specialData.ornamentIds.cur_equip = 0
        end
        local l_ownListNum = #ornamentIds.own_list
        if l_ownListNum > 0 then
            for i = 1, l_ownListNum do
                table.insert(l_specialData.ornamentIds, ornamentIds.own_list[i].value)
            end
        end
    end
    if dyeIds ~= nil then
        l_specialData.dyeIds.cur_equip = dyeIds.cur_equip
        if l_specialData.dyeIds.cur_equip == nil then
            l_specialData.dyeIds.cur_equip = 0
        end
        local l_ownDyeListNum = #dyeIds.own_list
        if l_ownDyeListNum > 0 then
            for i = 1, l_ownDyeListNum do
                table.insert(l_specialData.dyeIds, dyeIds.own_list[i].value)
            end
        end
    end
end
--errorWhenNoExist指不存在载具信息的时候报错
function UpdatePermenentVehicleInfo(vehicleId, ornamentId, dyeId, isEquip, isAdd)
    local l_specialData = l_permenentVehicleInfo[vehicleId]
    if l_specialData == nil then
        logError("非法操作，向非永久载具的配饰或染色赋值！")
        return
    end

    if ornamentId ~= -1 then
        --  -1为原来值
        if isEquip then
            l_specialData.ornamentIds.cur_equip = ornamentId
        else
            if isAdd then
                if not table.ro_contains(l_specialData.ornamentIds, ornamentId) then
                    table.insert(l_specialData.ornamentIds, ornamentId)
                end
            end
        end
    end
    if dyeId ~= -1 then
        if isEquip then
            l_specialData.dyeIds.cur_equip = dyeId
        end
        if isAdd then
            if not table.ro_contains(l_specialData.ornamentIds, dyeId) then
                table.insert(l_specialData.dyeIds, dyeId)
            end
        end
    end
end
---获得超级卷轴道具剩余使用次数、及最大使用次数
function GetSuperQualityPropUseCount()
    return l_superPropRemainUseCount,l_maxUseSuperPropNum
end
function GetVehicleStage()
    return l_stage
end
function GetVehicleCD()
    if l_vehicleCD ~= nil then
        return l_vehicleCD
    end
    l_vehicleCD = 3
    local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleCd")
    if not l_row then
        l_vehicleCD = tonumber(l_row.Value)
    end
    return l_vehicleCD
end
function CanShowVehicleFunc(funcId)
    local l_showLv = GetShowLevel()
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    return l_openSysMgr.GetSystemOpenBaseLv(funcId) - l_showLv <= MPlayerInfo.Lv
end
function GetShowLevel()
    --获取载具预览展示提前的等级
    if l_showLv == nil then
        l_showLv = 5
        local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleShowLv")
        if not l_row then
            l_showLv = tonumber(l_row.Value)
        end
    end
    return l_showLv
end
function GetVehicleLvUpItemUseNum()
    --if l_remainCount ~= nil and l_limit ~= nil then
    --    logGreen("l_remainCount:"..tostring(l_remainCount))
    --    logGreen("l_limit:"..tostring(l_limit))
    --    if l_remainCount>0 then
    --        return l_remainCount, l_limit
    --    end
    --end
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_lvUpPropData = GetLevelUpPropData()
    if #l_lvUpPropData < 1 then
        return 0, 0
    end
    local l_itemId = tostring(l_lvUpPropData[1].itemId)
    local l_type = l_limitBuyMgr.g_limitType.VEHICLE_LEVELUP_LIMIT

    l_remainCount = l_limitBuyMgr.GetItemCanBuyCount(l_type, l_itemId)
    l_limit = l_limitBuyMgr.GetLimitByKey(l_type, l_itemId)
    return l_remainCount, l_limit
end
function GetUseingVehicle()
    return l_usingVehicleId
end
function IsUseingProVehicle()
    return l_usingVehicleId > 0 and l_usingVehicleId == l_proId
end
function IsLandVehicle(vehicleType)
    local l_landVehicleType = 2
    return l_landVehicleType == vehicleType
end
function GetCurrentProVehicleModelName()
    return GetProVehicleModelName(l_stage)
end
function GetEquipOrnamentAndDyeId(vehicleId)
    local l_proVehicleInfo = GetPermentVehicleData(vehicleId)
    if l_proVehicleInfo == nil then
        return 0, 0
    end
    return l_proVehicleInfo.ornamentIds.cur_equip, l_proVehicleInfo.dyeIds.cur_equip
end

function GetProVehicleModelName(stageNum)
    local l_vehicleItem = TableUtil.GetVehicleTable().GetRowByID(l_proId)
    if MLuaCommonHelper.IsNull(l_vehicleItem) then
        return
    end
    local l_modelName = l_vehicleItem.Actor
    local l_modelId = 1
    if stageNum > 0 then
        local l_ornamentNum = l_vehicleItem.OrnametId.Count
        if stageNum <= l_ornamentNum then
            local l_ornamentItem = TableUtil.GetVehicleOrnamentTable().GetRowByOrnamentID(l_vehicleItem.OrnametId[stageNum - 1])
            if MLuaCommonHelper.IsNull(l_ornamentItem) then
                logError("试图获取VehicleOrnamentTable不存在的ID:" .. tostring(l_vehicleItem.OrnametId[stageNum - 1]))
            else
                l_modelName = l_ornamentItem.Model
                l_modelId = l_ornamentItem.OrnamentID
            end
        end
    end
    return l_modelName, l_modelId
end

--创建载具（ForUI）（载具ID、配饰ID、染色ID、挂载的rawImage、挂载的TouchArea、位置偏移、欧拉角，大小,开启后处理，开启阴影）
function CreateModel(vehicleID, ornamentID, colorID, rawImage, touchArea, pos, rotate, scale, enablePostEffect, enableShadow)

    local l_data, l_vehiclePath, l_defaultPath, l_vehicle
    l_data = TableUtil.GetVehicleTable().GetRowByID(vehicleID)
    if not l_data then
        logError("VehicleTable中不存在对应载具ID：{0}", vehicleID)
        return
    end
    l_defaultPath = l_data.Actor
    l_vehiclePath = l_data.Actor
    if ornamentID ~= nil and ornamentID ~= 0 then
        local l_ornamentData = TableUtil.GetVehicleOrnamentTable().GetRowByOrnamentID(ornamentID)
        if not l_ornamentData then
            logError("VehicleOrnamentTable中不存在对应配饰ID：{0}", ornamentID)
            return
        end
        l_vehiclePath = l_ornamentData.Model
    end
    if not pos then
        pos = { x = l_data.Horizontal, y = l_data.Height, z = l_data.Depth }
    end
    if not rotate then
        rotate = { x = 0, y = l_data.Rotate, z = 0 }
    end
    if not scale then
        scale = { x = l_data.Scale, y = l_data.Scale, z = l_data.Scale }
    end

    rawImage.gameObject:SetActiveEx(false)
    local l_fxData = MUIModelManagerEx:GetDataFromPool()
    l_fxData.rawImage = rawImage.RawImg
    l_fxData.prefabPath = string.format("Prefabs/%s", l_vehiclePath)
    l_fxData.height = 1024
    l_fxData.width = 1024
    l_fxData.defaultAnim = string.format("Anims/Mount/%s/%s_Idle", l_defaultPath, l_defaultPath)
    if enablePostEffect ~= nil then
        l_fxData.enablePostEffect = enablePostEffect
    end 

    if enableShadow ~= nil then
        l_fxData.useShadow = enableShadow
    end
    l_fxData.isCameraPosRotCustom = true
    l_fxData.cameraPos = Vector3.New(0.0, 1.1, -3.10)
    l_fxData.cameraRot = Quaternion.Euler(0.0, 2.0, 0.0)
    l_vehicle = MUIModelManagerEx:CreateModel(l_fxData)
    l_vehicle.Position = Vector3.New(pos.x, pos.y, pos.z)
    l_vehicle.Scale = Vector3.New(scale.x, scale.y, scale.z)
    l_vehicle:AddLoadModelCallback(function(m)
        rawImage:SetActiveEx(true)
        l_vehicle.UObj:SetRotEuler(rotate.x, rotate.y, rotate.z)
        if touchArea ~= nil then
            local l_listener = touchArea:GetComponent("MLuaUIListener")
            l_listener.onDrag = function(uobj, event)
                if l_vehicle and l_vehicle.Trans then
                    l_vehicle.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
                end
            end
        end
    end)
    if colorID ~= nil and colorID ~= 0 then
        local l_colorImg = TableUtil.GetVehicleColorationTable().GetRowByColorationID(colorID)
        if l_colorImg ~= nil then
            l_vehicle:ChangeTexture("Mount/" .. l_colorImg.Model)
        else
            logError("VehicleColorationTable中不存在对应载具配色：{0}", colorID)
        end
    end
    return l_vehicle
end

function updateDriveVehicleInfo(info)
    if info == nil or info.vehicle == nil then
        return
    end
    local l_currentVehicleInfo = GetPermentVehicleData(l_usingVehicleId)
    if l_currentVehicleInfo == nil then
        return
    end
    MPlayerInfo.VehicleItemID = 0
    if info.vehicle.is_get_on and tostring(info.vehicle.driver_uuid) == tostring(MPlayerInfo.UID) then
        MPlayerInfo.VehicleItemID = l_usingVehicleId
        MPlayerInfo.VehicleOrnamentID = l_currentVehicleInfo.ornamentIds.cur_equip
        MPlayerInfo.VehicleDyeID = l_currentVehicleInfo.dyeIds.cur_equip
    end
end
--endregion---------------------custom script end---------------------------------

--region---------------------------------消息相关------------------------------
function OnReconnected(reconnectData)
    local l_roleData = reconnectData.role_data
    if l_roleData == nil then
        return
    end
    OnSelectRoleNtf(l_roleData)
end

function OnSelectRoleNtf(info)
    OnVechicleDataCalculate(info)
    updateDriveVehicleInfo(info)
    RefreshVehicleState()
    --载具系统开放刷新载具骑乘按钮状态
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Vehicle) then
        l_openSystemMgr.EventDispatcher:RemoveObjectAllFunc(l_openSystemMgr.OpenSystemUpdate,VehicleInfoMgr)
        l_openSystemMgr.EventDispatcher:Add(l_openSystemMgr.OpenSystemUpdate,
                onSystemOpen, VehicleInfoMgr)
    end
end
function onSystemOpen(openSysMgr,openIds)
    if openIds==nil then
        return
    end
    for k,v in pairs(openIds) do
        if v == openSysMgr.eSystemId.Vehicle then
            openSysMgr.EventDispatcher:RemoveObjectAllFunc(openSysMgr.OpenSystemUpdate,VehicleInfoMgr)
            RefreshVehicleState()
            break
        end
    end
end
function OnVechicleDataCalculate(info, isReconnect)
    GlobalEventBus:Add(EventConst.Names.OnTaskFinishNotify, OnTaskStateChanged)
    local l_vehicleData = info.vehicle_record
    if info == nil or l_vehicleData == nil then
        return
    end
    l_usingVehicleId = l_vehicleData.using_vehicle_id

    l_hasProVehicle = l_vehicleData.pro_id > 0
    if l_hasProVehicle then
        l_proId = l_vehicleData.pro_id
    else
        l_proId = GetVehicleIdByProfession(MPlayerInfo.ProfessionId)
    end

    l_proLevel = l_vehicleData.pro_level
    l_proCurExp = l_vehicleData.pro_cur_exp

    AddPermenentVehicleInfo(l_proId, nil, nil) --将职业载具加入永久载具库
    if l_vehicleData.special_permanent_list ~= nil then
        --将特色载具加入永久载具库
        for i = 1, #l_vehicleData.special_permanent_list do
            AddPermenentVehicleInfo(l_vehicleData.special_permanent_list[i].value, nil, nil)
        end
    end
    if l_vehicleData.perment_outlook_list ~= nil then
        --更新特色载具中具有配饰或染色的数据
        for i = 1, #l_vehicleData.perment_outlook_list do
            local l_permenentVehData = l_vehicleData.perment_outlook_list[i]
            AddPermenentVehicleInfo(l_permenentVehData.vehicle_id, l_permenentVehData.ornament, l_permenentVehData.dye)
        end
    end
    if l_vehicleData.special_temp_vehicle ~= nil then
        l_tempSpecialInfo = {}
        for i = 1, #l_vehicleData.special_temp_vehicle do
            local l_tempVehData = l_vehicleData.special_temp_vehicle[i]
            l_tempSpecialInfo[l_tempVehData.vehicle_id] = l_tempVehData.expire_time
        end
    end
    local l_devInfo = l_vehicleData.dev_info
    if l_devInfo ~= nil then
        l_maxUseSuperPropNum = MGlobalConfig:GetInt("VehicleScrollUseTimes")
        l_superPropRemainUseCount = l_maxUseSuperPropNum - l_devInfo.pro_quality_break_times
        l_stage = l_devInfo.pro_quality_level
        local l_attrData = GetAttrInfoData()
        l_attrData.hasPrimaryCulture = false
        l_attrData.hasSeniorCulture = false
        local l_hasBaseQualityValue = #l_devInfo.entrys.attrs > 0
        local l_hasCacheJuniorCulture = #l_devInfo.cache_entrys_junior.attrs > 0
        local l_hasCacheSeniorCulture = #l_devInfo.cache_entrys_senior.attrs > 0
        local l_hasQualityLimitValue = #l_devInfo.pro_quality_limit.attrs > 0
        for i = 1, #l_attrData do
            local l_attrInfo = l_attrData[i]
            if l_hasCacheJuniorCulture then
                l_attrInfo.primaryTrain = l_devInfo.cache_entrys_junior.attrs[i].value
                if l_attrInfo.primaryTrain ~= 0 then
                    l_attrData.hasPrimaryCulture = true
                end
            else
                l_attrInfo.primaryTrain = 0
            end
            if l_hasCacheSeniorCulture then
                l_attrInfo.seniorTrain = l_devInfo.cache_entrys_senior.attrs[i].value
                if l_attrInfo.seniorTrain ~= 0 then
                    l_attrData.hasSeniorCulture = true
                end
            else
                l_attrInfo.seniorTrain = 0
            end
            if l_hasBaseQualityValue then
                l_attrInfo.trainValue = l_devInfo.entrys.attrs[i].value
            else
                l_attrInfo.trainValue = 0
            end
            if l_hasQualityLimitValue then
                l_attrInfo.trainValueLimit = l_devInfo.pro_quality_limit.attrs[i].value
            else
                local l_vehicleQualityItem = TableUtil.GetVehicleQualityTable().GetRow(i)
                if not MLuaCommonHelper.IsNull(l_vehicleQualityItem) then

                    l_attrInfo.trainValueLimit = l_vehicleQualityItem.InitialQuality
                end
            end
            l_attrInfo.totalValue = CountTotalAttrValueInner( l_attrInfo.trainValue, i,l_proLevel)
        end
    end
end

function SendEnableVehicleMsg(vehicleId, isUse)
    local l_msgId = Network.Define.Rpc.EnableVehicle
    ---@type EnableVehicleArg
    local l_sendInfo = GetProtoBufSendTable("EnableVehicleArg")
    l_sendInfo.vehicle_id = vehicleId
    l_sendInfo.vehicle_op = isUse and VehicleOperation.VEHICLE_OPERATION_ENABLE or VehicleOperation.VEHICLE_OPERATION_DISABLE
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnEnableVehicleMsg(msg, arg)
    ---@type EnableVehicleRes
    local l_resInfo = ParseProtoBufToTable("EnableVehicleRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        if arg.vehicle_op == VehicleOperation.VEHICLE_OPERATION_ENABLE then
            l_usingVehicleId = arg.vehicle_id
        else
            l_usingVehicleId = 0
        end
        EventDispatcher:Dispatch(EventType.VehicleUseStateChange)
    end
end
function CanUseAddVehicleExpOrBreachProp()
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.VehicleAbility) then
        return false
    end
    if not HasProfessionVehicle() then
        return false
    end
    return true
end
function SendUpgradeVehicleMsg(itemId, count)
    local l_currentTime = Common.TimeMgr.GetLocalNowTimestamp()
    if l_waitUpgradeVehicleRet then
        local l_maxWaitTime = 3
        --避免重连等情况未收到返回值，卡流程，最长等待3秒
        if l_currentTime - l_lastReqUpgradeVehicleTime < l_maxWaitTime then
            return
        end
    end
    if not CanUseAddVehicleExpOrBreachProp() then
        local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
        local l_unlockLevel = l_openSysMgr.GetSystemOpenBaseLv(l_openSysMgr.eSystemId.VehicleAbility)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VEHICLE_PROP_USE_CONDITION", l_unlockLevel))
        return
    end

    --特殊经验道具不弹首次使用dialog
    if isSpecialAddExpProp(itemId) then
        SendUpgradeVehicleMsgInner(itemId, count)
        return
    end

    local l_key = "VehicleFirstCultureLv"
    local l_value = UserDataManager.GetStringDataOrDef(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "0")
    if  l_value == "0" then
        UserDataManager.SetDataFromLua(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "1")
        local l_txt = string.format(Lang("FIRST_LVUP_VEHICLE"), GetExpByItemId(itemId), -1)
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
            SendUpgradeVehicleMsgInner(itemId, count)
        end)
    else
        SendUpgradeVehicleMsgInner(itemId, count)
    end
end
function isSpecialAddExpProp(itemId)
    local l_addExpPropInfos = GetLevelUpPropData()
    if #l_addExpPropInfos <= 2 then
        return false
    end
    local l_specialPropInfo = l_addExpPropInfos[3]
    return l_specialPropInfo.itemId == itemId
end
function SendUpgradeVehicleMsgInner(itemId, count)
    local l_remainCount, _ = GetVehicleLvUpItemUseNum()
    if l_remainCount <= 0 then
        local l_superItemId = GetSuperExpPropId()
        if l_superItemId ~= itemId then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VEHICLE_LVUP_COUNT_NOENOUGH"))
            return
        end
    end
    local l_propNum = Data.BagModel:GetBagItemCountByTid(itemId)
    if l_propNum < 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LACK_VEHICLE_LVUP_PROP"))
        local itemData = Data.BagModel:CreateItemWithTid(itemId)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
        return
    end

    local l_proLevelLimit, l_levelUpNeedRoleLevel = GetProVehicleLvLimit()
    if l_proLevel >= l_proLevelLimit then
        if l_levelUpNeedRoleLevel == -1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CURRENT_LEVEL_MAX"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VEHICLE_LVUP_NEED_ROLELEVEL", l_levelUpNeedRoleLevel))
        end

        return
    end

    local l_msgId = Network.Define.Rpc.UpgradeVehicle
    ---@type UpgradeVehicleArg
    local l_sendInfo = GetProtoBufSendTable("UpgradeVehicleArg")
    l_sendInfo.item_id = itemId
    l_sendInfo.count = count
    l_waitUpgradeVehicleRet = true
    l_lastReqUpgradeVehicleTime = Common.TimeMgr.GetLocalNowTimestamp()
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnUpgradeVehicleMsg(msg, arg)
    l_waitUpgradeVehicleRet = false
    ---@type UpgradeVehicleRes
    local l_resInfo = ParseProtoBufToTable("UpgradeVehicleRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        local _, l_tempLimit = GetVehicleLvUpItemUseNum()
        l_remainCount = l_tempLimit - l_resInfo.used_times

        local l_lastLevel = l_proLevel
        l_proLevel = l_resInfo.cur_level
        l_proCurExp = l_resInfo.cur_exp
        UpdateAttTotalValue()

        local l_remainCount, l_limit = GetVehicleLvUpItemUseNum()
        if l_remainCount <= 50 then
            local l_mod = math.fmod(l_remainCount, 10)
            if l_mod == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("VEHICLE_LVUP_TIPS"), l_limit - l_remainCount, l_remainCount))
            end
        end
        if l_resInfo.crit_times > 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("VEHICLE_EXP_CRIT_TIP"), l_resInfo.crit_times, l_resInfo.crit_exp))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("VEHICLE_EXP_ADD"), l_resInfo.crit_exp))
        end
        if l_proLevel > l_lastLevel then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("VEHICLE_LEVEL_UP_TIPS"), l_proLevel))
            EventDispatcher:Dispatch(EventType.VEHICLE_LEVEL_UP)
        end
        EventDispatcher:Dispatch(EventType.VehicleUpgrade)
    end
end

function SendUpgradeVehicleLimitMsg()
    local l_nextStageNeedLv, l_nextStageNeedPropInfo = GetNextStageInfo()
    if l_nextStageNeedLv == nil then
        return
    end
    
    for i = 0, l_nextStageNeedPropInfo.Count - 1 do
        local l_propInfo = l_nextStageNeedPropInfo[i]
        local l_propNum = Data.BagModel:GetCoinOrPropNumById(l_propInfo[0])
        if l_propNum < l_propInfo[1] then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LACK_STAGEUP_PROP"))
            return
        end
    end

    local l_msgId = Network.Define.Rpc.UpgradeVehicleLimit
    ---@type UpgradeVehicleLimitArg
    local l_sendInfo = GetProtoBufSendTable("UpgradeVehicleLimitArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnUpgradeVehicleLimitMsg(msg, arg)
    ---@type UpgradeVehicleLimitRes
    local l_resInfo = ParseProtoBufToTable("UpgradeVehicleLimitRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        l_stage = l_stage + 1
        local _, l_ornamentId = GetProVehicleModelName(l_stage)
        MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(GetProfessionVehicleId(), 1, nil,
                { titleName = Lang("VEHICLE_UPGRADE"), ornamentId = l_ornamentId })

        for i = 1, #l_resInfo.quality_limit.attrs do
            local l_attValue = l_resInfo.quality_limit.attrs[i]
            local l_attInfo = GetAttrInfoById(l_attValue.key)
            l_attInfo.trainValueLimit = l_attValue.value
        end
        UpdateAttTotalValue()
        EventDispatcher:Dispatch(EventType.VehicleUpgradeLimit)
    end
end

function SendDevelopVehicleQualityMsg(developType)
    local l_vqrItem = TableUtil.GetVehicleQualityRandomTable().GetRowById(1)
    if l_vqrItem == nil then
        logError("RefreshQualityConsumeInfo 无法获取表格数据")
        return
    end
    local l_consumePropData = developType == cultureType.primary and l_vqrItem.PrimaryConsume or l_vqrItem.AdvancedConsume
    for i = 0, l_consumePropData.Count - 1 do
        local l_consumePropInfo = l_consumePropData[i]
        local l_needItemId = l_consumePropInfo[0]
        local l_needNum = l_consumePropInfo[1]
        local l_hasNum = Data.BagModel:GetBagItemCountByTid(l_needItemId)
        if l_hasNum < l_needNum then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LACK_VEHICLE_CULTURE_PROP"))
            return
        end
    end

    local l_attrInfos = GetAttrInfoData()
    local l_totalChangeValue = 0
    for i = 1, #l_attrInfos do
        local l_attrInfo = l_attrInfos[i]
        if developType == cultureType.primary then
            l_totalChangeValue = l_totalChangeValue + l_attrInfo.primaryTrain
        else
            l_totalChangeValue = l_totalChangeValue + l_attrInfo.seniorTrain
        end
    end
    local l_sendDevelopVehicleQualityFunc = function(devType)
        local l_msgId = Network.Define.Rpc.DevelopVehicleQuality
        ---@type DevelopVehicleQualityArg
        local l_sendInfo = GetProtoBufSendTable("DevelopVehicleQualityArg")
        l_sendInfo.type = developType
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
    if l_totalChangeValue > 0 then
        local L_CONST_PLAYER_PREFS = "VEHICLE_DEV_TODAY_RECORD"
        local l_txt = Lang("VEHICLE_DEVELOP_QUALITY_DIALOG")
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
            l_sendDevelopVehicleQualityFunc(developType)
        end, nil, nil, 2, L_CONST_PLAYER_PREFS)
    else
        l_sendDevelopVehicleQualityFunc(developType)
    end
end

function OnDevelopVehicleQualityMsg(msg, arg)
    ---@type DevelopVehicleQualityRes
    local l_resInfo = ParseProtoBufToTable("DevelopVehicleQualityRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        local l_hasChangeValue = false
        for i = 1, #l_resInfo.increment.attrs do
            local l_attValue = l_resInfo.increment.attrs[i]
            local l_attInfo = GetAttrInfoById(l_attValue.key)
            if l_attValue.value ~= 0 then
                l_hasChangeValue = true
            end
            if arg.type == cultureType.primary then
                l_attInfo.primaryTrain = l_attValue.value
            else
                l_attInfo.seniorTrain = l_attValue.value
            end
        end
        if l_hasChangeValue then
            local l_attrInfos = GetAttrInfoData()
            if arg.type == cultureType.primary then
                l_attrInfos.hasPrimaryCulture = true
            else
                l_attrInfos.hasSeniorCulture = true
            end
        end
        EventDispatcher:Dispatch(EventType.DevelopVehicleQualitySuc)
    end
end

function SendConfirmVehicleQualityMsg(developType)
    local l_attrInfos = GetAttrInfoData()
    local l_totalChangeValue = 0
    for i = 1, #l_attrInfos do
        local l_attrInfo = l_attrInfos[i]
        if developType == cultureType.primary then
            l_totalChangeValue = l_totalChangeValue + l_attrInfo.primaryTrain
        else
            l_totalChangeValue = l_totalChangeValue + l_attrInfo.seniorTrain
        end
    end
    local l_sendConfirmVehicleQualityFunc = function(devType)
        local l_msgId = Network.Define.Rpc.ConfirmVehicleQuality
        ---@type ConfirmVehicleQualityArg
        local l_sendInfo = GetProtoBufSendTable("ConfirmVehicleQualityArg")
        l_sendInfo.type = devType
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
    if l_totalChangeValue < 0 then
        local l_txt = Lang("VEHICLE_CULTURE_DIALOG_TIP")
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
            l_sendConfirmVehicleQualityFunc(developType)
        end,nil,nil,2,"VEHICLE_CULTURE_DIALOG_TIP")
    else
        local l_key = "VehicleFirstReplaceCulQuality"
        local l_value = UserDataManager.GetStringDataOrDef(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "0")
        if l_value == "0" then
            UserDataManager.SetDataFromLua(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "1")
            local l_txt = Lang("FIRST_CONFIRM_VEHICLE_QUALITY")
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
                l_sendConfirmVehicleQualityFunc(developType)
            end)
        else
            l_sendConfirmVehicleQualityFunc(developType)
        end
    end
end

function OnConfirmVehicleQualityMsg(msg, arg)
    ---@type ConfirmVehicleQualityRes
    local l_resInfo = ParseProtoBufToTable("ConfirmVehicleQualityRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        for i = 1, #l_resInfo.vehicle_attr.attrs do
            local l_attValue = l_resInfo.vehicle_attr.attrs[i]
            local l_attInfo = GetAttrInfoById(l_attValue.key)
            l_attInfo.trainValue = l_attValue.value
            if arg.type == cultureType.primary then
                l_attInfo.primaryTrain = 0
            else
                l_attInfo.seniorTrain = 0
            end
            l_attInfo.totalValue = CountTotalAttrValueInner( l_attInfo.trainValue,i,l_proLevel)

        end
        local l_attrInfos = GetAttrInfoData()
        if arg.type == cultureType.primary then
            l_attrInfos.hasPrimaryCulture = false
        else
            l_attrInfos.hasSeniorCulture = false
        end
        EventDispatcher:Dispatch(EventType.ConfirmVehicleQuality)
    end
end

function SendExchangeSpecialVehicleMsg(vehicleId)
    local l_msgId = Network.Define.Rpc.ExchangeSpecialVehicle
    ---@type ExchangeSpecialVehicleArg
    local l_sendInfo = GetProtoBufSendTable("ExchangeSpecialVehicleArg")
    l_sendInfo.item_id = vehicleId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnExchangeSpecialVehicleMsg(msg, arg)
    ---@type ExchangeSpecialVehicleRes
    local l_resInfo = ParseProtoBufToTable("ExchangeSpecialVehicleRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        local l_itemId = arg.item_id
        AddPermenentVehicleInfo(arg.item_id, nil, nil)
        MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(arg.item_id, 1)
        RefreshVehicleState()

        EventDispatcher:Dispatch(EventType.ExchangeSpecialVehicle, arg.item_id)
    end
end

function SendAddOrnamentDyeMsg(vehicleId, ornamentDyeType, ornamentDyeId)
    local l_msgId = Network.Define.Rpc.AddOrnamentDye
    ---@type AddOrnamentDyeArg
    local l_sendInfo = GetProtoBufSendTable("AddOrnamentDyeArg")
    l_sendInfo.vehicle_id = vehicleId
    l_sendInfo.type = ornamentDyeType
    l_sendInfo.id = ornamentDyeId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnAddOrnamentDyeMsg(msg, arg)
    ---@type AddOrnamentDyeRes
    local l_resInfo = ParseProtoBufToTable("AddOrnamentDyeRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        if arg.type == VehicleOutlookType.VEHICLE_OUTLOOK_ORNAMENT then
            UpdatePermenentVehicleInfo(arg.vehicle_id, arg.id, -1, false, true)
        else
            UpdatePermenentVehicleInfo(arg.vehicle_id, -1, arg.id, false, true)
        end
        EventDispatcher:Dispatch(EventType.AddOrnamentDyeSuc, arg.vehicle_id, arg.type, arg.id)
    end
end

function SendUseOrnamentDyeMsg(vehicleId, ornamentDyeType, ornamentDyeId)
    local l_msgId = Network.Define.Rpc.UseOrnamentDye
    ---@type UseOrnamentDyeArg
    local l_sendInfo = GetProtoBufSendTable("UseOrnamentDyeArg")
    l_sendInfo.vehicle_id = vehicleId
    l_sendInfo.type = ornamentDyeType
    l_sendInfo.id = ornamentDyeId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnUseOrnamentDyeMsg(msg, arg)
    ---@type UseOrnamentDyeRes
    local l_resInfo = ParseProtoBufToTable("UseOrnamentDyeRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        if arg.type == VehicleOutlookType.VEHICLE_OUTLOOK_ORNAMENT then
            UpdatePermenentVehicleInfo(arg.vehicle_id, arg.id, -1, true, false)
        else
            UpdatePermenentVehicleInfo(arg.vehicle_id, -1, arg.id, true, false)
        end
        EventDispatcher:Dispatch(EventType.UseOrnamentDyeSuc, arg.vehicle_id, arg.type, arg.id)
    end
end
function OnUpdateVehicleAttrs(msg)
    ---@type UpdateVehicleAttrsData
    local l_info = ParseProtoBufToTable("UpdateVehicleAttrsData", msg)
    if l_info.quality_limit ~= nil then
        for i = 1, #l_info.quality_limit.attrs do
            local l_attValue = l_info.quality_limit.attrs[i]
            local l_attInfo = GetAttrInfoById(l_attValue.key)
            local l_improveValue = l_attValue.value - l_attInfo.trainValueLimit
            if l_info.break_type == VehicleQualityBreakType.VEHICLE_QUALITY_BREAK_TYPE_SCROLL and l_improveValue > 0 then
                local l_vehicleItem = TableUtil.GetVehicleTable().GetRowByID(l_proId, false)
                if nil ~= l_vehicleItem then
                    l_superPropRemainUseCount = l_superPropRemainUseCount - 1
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("USE_SUPER_PROP_TIP", l_vehicleItem.Name, l_attInfo.Name, l_improveValue, l_superPropRemainUseCount))
                end
            end

            l_attInfo.trainValueLimit = l_attValue.value
        end

        UpdateAttTotalValue()
        EventDispatcher:Dispatch(EventType.VehicleUpgradeLimit)
    end
end

function OnAddTempVehicle(msg)
    ---@type AddTempVehicleData
    local l_info = ParseProtoBufToTable("AddTempVehicleData", msg)
    l_tempSpecialInfo[l_info.vehicle_id] = l_info.expire_time
    RefreshVehicleState()
end

function OnUpdateVehicleRecordForGM(msg)
    ---@type UpdateVehicleRecordForGMData
    local l_info = ParseProtoBufToTable("UpdateVehicleRecordForGMData", msg)
    OnVechicleDataCalculate(l_info)
    RefreshVehicleState()
end

--endregion---------------------------------消息相关 END--------------------------
return VehicleInfoMgr