---@module ModuleMgr.AutoDoseDrugMgr
module("ModuleMgr.AutoDoseDrugMgr", package.seeall)

--- 自动嗑药管理器，原本是在cs处理的业务逻辑，现在移动过来
--- 道具ID和等级映射，保存了自动嗑药能使用的道具和对应的等级
--- 这个策略是如果血量发生变化，且满足自动嗑药条件，则这个时候尝试进行自动嗑药
--- 如果道具CD到了，这个时候也满足自动嗑药条件，也会自动嗑药
---@type table<number, number>
_drugIDLvMap = {}
_hpCdMap = {}
_mpCdMap = {}
_mpIDMap = {}
_hpIDMap = {}

function OnInit()
    Data.PlayerInfoModel.HPPERCENT:Add(Data.onDataChange, _onPlayerHpChange)
    Data.PlayerInfoModel.MPPERCENT:Add(Data.onDataChange, _onPlayerMpChange)
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnItemCdOver, _onItemCdOver)
    gameEventMgr.Register(gameEventMgr.OnItemGroupCdOver, _onItemCdOver)
    gameEventMgr.Register(gameEventMgr.OnPlayerAttrUpdate, _onPlayerAttrChange)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    gameEventMgr.Register(gameEventMgr.OnAutoBattleSettingsConfirmed, _autoDoseAll)
    _initMap()
end

function _insertUsrDataToMap(refTable, userTable)
    if nil == refTable then
        return
    end

    if nil == userTable then
        return
    end

    for i = 0, userTable.Length - 1 do
        local singleValue = userTable[i]
        table.insert(refTable, singleValue)
    end
end

--- 初始化缓存映射
function _initMap()
    local fullList = {}
    local hpDrugList = MGlobalConfig:GetSequenceOrVectorInt("AutoRecoveryHPGoods")
    local mpDrugList = MGlobalConfig:GetSequenceOrVectorInt("AutoRecoverySPGoods")
    _insertUsrDataToMap(fullList, hpDrugList)
    _insertUsrDataToMap(fullList, mpDrugList)
    for i = 0, hpDrugList.Length - 1 do
        local singleValue = hpDrugList[i]
        _hpIDMap[singleValue] = 1
        local groupCdID = MgrMgr:GetMgr("ItemCdMgr").GetGroupIdFromTable(singleValue)
        if 0 == groupCdID then
            _hpCdMap[singleValue] = 1
        else
            _hpCdMap[groupCdID] = 1
        end
    end

    for i = 0, mpDrugList.Length - 1 do
        local singleValue = mpDrugList[i]
        local groupCdID = MgrMgr:GetMgr("ItemCdMgr").GetGroupIdFromTable(singleValue)
        _mpIDMap[singleValue] = 1
        if 0 == groupCdID then
            _mpCdMap[singleValue] = 1
        else
            _mpCdMap[groupCdID] = 1
        end
    end

    for i = 1, #fullList do
        local singleID = fullList[i]
        local itemConfig = TableUtil.GetItemTable().GetRowByItemID(singleID)
        if nil ~= itemConfig then
            _drugIDLvMap[singleID] = itemConfig.LevelLimit[0]
        end
    end
end

function _itemInCd(id)
    local cd = MgrMgr:GetMgr("ItemCdMgr").GetCd(id)
    return 0 < cd
end

--- 找到第一个可以自动嗑药的道具
--- 需要满足两个条件，等级满足而且数量满足
---@param drugTIDList number[]
---@return number
function _getFirstAvailableDrug(drugTIDList)
    for i = 0, drugTIDList.Length - 1 do
        local singleID = drugTIDList[i]
        local itemLv = _drugIDLvMap[singleID]
        local itemCount = Data.BagApi:GetItemCountByContListAndTid({ GameEnum.EBagContainerType.Bag }, singleID)
        local lvMatch = nil ~= itemLv and MPlayerInfo.Lv >= itemLv
        local itemInCd = _itemInCd(singleID)
        if lvMatch and 0 < itemCount and not itemInCd then
            return singleID
        end
    end

    return 0
end

--- 根据具体类型返回第一个可用的ID
function _getFirstDoseByType(doseType)
    if GameEnum.EDoseDrugType.Hp == doseType then
        return _getFirstAvailableDrug(MPlayerInfo.AutoHpDragItemList)
    elseif GameEnum.EDoseDrugType.Mp == doseType then
        return _getFirstAvailableDrug(MPlayerInfo.AutoMpDragItemList)
    else
        logError("[AutoDose] invalid type: " .. tostring(doseType))
        return 0
    end
end

--- 尝试使用道具
function _tryUseItem(actionType, funcEnabled)
    if not funcEnabled then
        return
    end

    local targetID = _getFirstDoseByType(actionType)
    if 0 >= targetID or nil == _drugIDLvMap[targetID] then
        return
    end

    local propMgr = MgrMgr:GetMgr("PropMgr")
    propMgr.RequestUseItemByItemId(targetID, true)
end

function _onItemCdOver(itemID)
    if nil ~= _hpCdMap[itemID] then
        _onPlayerHpChange()
    end

    if nil ~= _mpCdMap[itemID] then
        _onPlayerMpChange()
    end
end

function _onPlayerAttrChange(param)
    if nil == param then
        return
    end

    if nil == param[AttrType.ATTR_SPECIAL_NO_USE_ITEM] then
        return
    end

    _onPlayerMpChange()
    _onPlayerHpChange()
end

function _onPlayerHpChange()
    if MPlayerInfo.IsWatchWar then
        return
    end

    --- 这里有一个问题，登录的时候血量同步下来会出现精度问题，变成99.95，如果血量调整成为100这个时候会直接嗑药
    --- 所以需要向上取整
    local currentValue = math.ceil(_getPercentageValue(Data.PlayerInfoModel:getHPPercent()))
    if MPlayerInfo.AutoDragHpPercent <= currentValue then
        return
    end

    _tryUseItem(GameEnum.EDoseDrugType.Hp, MPlayerInfo.EnableAutoHpDrag)
end

function _onPlayerMpChange()
    if MPlayerInfo.IsWatchWar then
        return
    end

    local currentValue = math.ceil(_getPercentageValue(Data.PlayerInfoModel:getMPPercent()))
    if MPlayerInfo.AutoDragMpPercent <= currentValue then
        return
    end

    _tryUseItem(GameEnum.EDoseDrugType.Mp, MPlayerInfo.EnableAutoMpDrag)
end

--- 如果玩家手动修改了自动嗑药上限，也会产生自动嗑药
function _autoDoseAll()
    _onPlayerMpChange()
    _onPlayerHpChange()
end

function _getPercentageValue(value)
    if value == nil then
        return 0
    end
    local C_INT_PERCENTAGE_VALUE = 100
    return value * C_INT_PERCENTAGE_VALUE
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[AutoDoseDrug] invalid param")
        return
    end

    local doseMpDrug = false
    local doseHpDrug = false
    for i = 1, #itemUpdateDataList do
        local singleData = itemUpdateDataList[i]
        local compareData = singleData:GetItemCompareData()
        if nil ~= _mpIDMap[compareData.id] and 0 < compareData.count and not doseMpDrug then
            doseMpDrug = true
        elseif nil ~= _hpIDMap[compareData.id] and 0 < compareData.count and not doseHpDrug then
            doseHpDrug = true
        else
            -- do nothing
        end
    end

    if doseMpDrug then
        _onPlayerMpChange()
    end

    if doseHpDrug then
        _onPlayerHpChange()
    end
end

return ModuleMgr.AutoDoseDrugMgr