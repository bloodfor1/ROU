---@module ModuleMgr.ShortCutItemMgr
module("ModuleMgr.ShortCutItemMgr", package.seeall)
local luaBaseType = GameEnum.ELuaBaseType
local gameEventMgr = MgrProxy:GetGameEventMgr()

--- 快捷使用槽位总数
C_ITEM_SLOT_COUNT = 8
C_INVALID_SLOT_IDX = -1
---@type table<number, ItemData>
_itemMap = {}

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onBagSync, nil)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onBagUpdate, nil)
end

--- 道具同步完成之后触发的函数
function _onBagSync()
    _updateShortCutItem()
    gameEventMgr.RaiseEvent(gameEventMgr.OnShortCutItemSync, nil)
end

--- 道具更新时候触发的函数
---@param paramList ItemUpdateData[]
function _onBagUpdate(paramList)
    local needUpdate = false
    local idHash = _getShortCutIDHash()
    for i = 1, #paramList do
        local singleData = paramList[i]
        if singleData:ChangeInvolvedCont(GameEnum.EBagContainerType.ShortCut) then
            needUpdate = true
            break
        end

        if singleData:ChangeInvolvedCont(GameEnum.EBagContainerType.Bag) then
            if nil ~= idHash[singleData:GetNewOrOldItem().TID] then
                needUpdate = true
                break
            end
        end
    end

    if not needUpdate then
        return
    end

    _updateShortCutItem()
    gameEventMgr.RaiseEvent(gameEventMgr.OnShortCutItemUpdate, nil)
end

---@return table<number>
function _getShortCutIDHash()
    local ret = {}
    local containers = { GameEnum.EBagContainerType.ShortCut }
    local items = Data.BagApi:_getItemsByTypesAndConds(containers, nil)
    for i = 1, #items do
        ret[items[i].TID] = 1
    end

    return ret
end

--- 快捷使用道具是额外维护的，所以快捷使用的数量更新是在这里做的，不在背包中做
function _updateShortCutItem()
    local itemContainerMgr = MgrMgr:GetMgr("ItemContainerMgr")
    for i = 1, C_ITEM_SLOT_COUNT do
        local targetItem = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.ShortCut, i)
        --- 这里要判断道具是否可以堆叠
        if nil ~= targetItem then
            if 1 == targetItem.ItemConfig.Overlap then
                targetItem.ItemCount = ToInt64(1)
            else
                targetItem.ItemCount = itemContainerMgr.GetItemCountByContAndID(GameEnum.EBagContainerType.Bag, targetItem.TID)
            end
        end

        _itemMap[i] = targetItem
    end
end

function GetItemByIdx(idx)
    if luaBaseType.Number ~= type(idx) then
        logError("[ShortCutItemMgr] invalid param")
        return nil
    end

    return _itemMap[idx]
end

--- 获取第一个空槽位，如果没有则返回 -1
function GetFirstEmptySlot()
    for i = 1, C_ITEM_SLOT_COUNT do
        local itemData = _itemMap[i]
        if nil == itemData then
            return i
        end
    end

    return C_INVALID_SLOT_IDX
end

---@return number[]
function GetEmptySlots()
    local ret = {}
    for i = 1, C_ITEM_SLOT_COUNT do
        local itemData = _itemMap[i]
        if nil == itemData then
            table.insert(ret, i)
        end
    end

    return ret
end

---@param itemData ItemData
function UseItemByItemData(itemData)
    if luaBaseType.Table ~= type(itemData) then
        logError("[ShortCutItemMgr] invalid param")
        return
    end

    local l_row = itemData.EquipConfig
    if nil ~= l_row then
        local l_eId = l_row.EquipId
        local l_weaponId = l_row.WeaponId
        local l_pos = Data.BagModel:getWeapAdornPos(l_eId, l_weaponId)
        Data.BagApi:ReqSwapItem(itemData.UID, GameEnum.EBagContainerType.Equip, l_pos, 1)
        return
    end

    local l_uid = itemData.UID
    if itemData.ItemFunctionConfig then
        local svrContType = BagType.SHORTCUTBAR
        MgrMgr:GetMgr("PropMgr").RequestUseItem(l_uid, 1, itemData.TID, svrContType)
    else
        local l_s = Common.Functions.GetErrorCodeStr(ErrorCode.ERR_ITEM_CANNOT_USE)
        if nil ~= l_s then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
        else
            logError("快捷使用栏不能使用这个物品，道具id：" .. tostring(itemData.TID))
        end
    end
end

return ModuleMgr.ShortCutItemMgr