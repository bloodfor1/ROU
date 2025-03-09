require "Data/Model/BagApi"

---@module ModuleMgr.QuickUseMgr
module("ModuleMgr.QuickUseMgr", package.seeall)

-- 如果没有显示，查看是否大于50级，是否是任务道具，是否可快捷使用，性别是否符合，等级是否可使用，职业是否符合
local C_LV_LIMIT = 50
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

EShowQuickUseType = {
    ShowQuickUse = 1,
    SetPropInfo = 2,
    SetFunction = 3,
    SetFakeItem = 4,
}

---@type ItemData[]
QuickUseItems = {}

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

--升级时调用
function OnUpgrade()
    local quickUseItems = GetQuickUseItemsOnUpgrade()
    _onQuickUseChange(quickUseItems)
end

--转职时调用
function OnTransfer()
    local quickUseItems = GetQuickUseItemsOnTransfer()
    _onQuickUseChange(quickUseItems)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[QuickUseMgr] invalid param")
        return
    end

    ---@type ItemData[]
    local itemList = {}
    local hasChanged = false
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local updateData = singleUpdateData:GetItemCompareData()
        if 0 > updateData.count then
            local newItem = singleUpdateData.NewItem
            local uid = singleUpdateData:GetNewOrOldItem().UID
            local result = _removeFormCache(uid, newItem)
            if not hasChanged and result then
                hasChanged = true
            end
        elseif 0 < updateData.count and _reasonValid(singleUpdateData.Reason) then
            table.insert(itemList, singleUpdateData.NewItem)
        end
    end

    if 0 < #itemList then
        _onQuickUseChange(itemList)
        return
    end

    if hasChanged then
        ShowQuickUse()
        return
    end
end

---@return boolean
function _reasonValid(reason)
    if nil == reason then
        logError("[QuickUseMgr] invalid param")
        return false
    end

    local C_INVALID_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_TURNTABLE_TICKTY] = 1,
        [ItemChangeReason.ITEM_REASON_TURNTABLE_WABAO] = 1,
        [ItemChangeReason.ITEM_REASON_DELEGATE_DARW_AWARD] = 1,
    }

    return nil == C_INVALID_REASON_MAP[reason]
end

---@param uid int64
---@param item ItemData
---@return boolean
function _removeFormCache(uid, item)
    local ret = false
    for i = #QuickUseItems, 1, -1 do
        local singleItem = QuickUseItems[i]
        if uid:equals(singleItem.UID) then
            if nil == item then
                table.remove(QuickUseItems, i)
                ret = true
            else
                QuickUseItems[i] = item
                ret = true
            end
        end
    end

    return ret
end

--当快捷使用数据变化时调用
function _onQuickUseChange(quickUseItems)
    if #quickUseItems > 0 then
        DealWithItems(quickUseItems)
        ShowQuickUse()
    end
end

--对道具数据进行处理
function DealWithItems(items)
    local l_items = {}
    table.ro_insertRange(l_items, QuickUseItems)
    table.ro_insertRange(l_items, items)
    QuickUseItems = {}
    local wearPositionEquips = {}
    for i, propInfo in pairs(l_items) do
        local itemTableInfo = propInfo.ItemConfig
        if IsCanUse(itemTableInfo) then
            if propInfo.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
                DealWithEquip(wearPositionEquips, propInfo)
            else
                AddItems(propInfo)
            end
        end
    end

    --当主武器是双手武器时，移除副手装备
    local equipMgr = MgrMgr:GetMgr("EquipMgr")
    if wearPositionEquips[EquipPos.MAIN_WEAPON] ~= nil then
        local holdingMode = equipMgr.GetEquipHoldingModeById(wearPositionEquips[EquipPos.MAIN_WEAPON].TID)
        if holdingMode == equipMgr.HoldingModeDouble or holdingMode == equipMgr.HoldingModeDoubleHand then
            wearPositionEquips[EquipPos.SECONDARY_WEAPON] = nil
        end
    end

    for i, propInfo in pairs(l_items) do
        if propInfo ~= nil then
            for i, wearPropInfo in pairs(wearPositionEquips) do
                if propInfo == wearPropInfo then
                    AddItems(propInfo)
                end
            end
        end
    end
end

--对装备数据进行处理
function DealWithEquip(wearPositionEquips, propInfo)
    if MPlayerInfo.Lv < C_LV_LIMIT then
        local equipPosition = GetSuitEquipPosition(propInfo)
        local wearPositionPropInfo
        if wearPositionEquips[equipPosition] == nil then

            wearPositionPropInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, equipPosition + 1)
        else
            wearPositionPropInfo = wearPositionEquips[equipPosition]
        end

        if wearPositionPropInfo == nil then
            wearPositionEquips[equipPosition] = propInfo
        else
            if MgrMgr:GetMgr("EquipMgr").GetEquipLimitLevel(wearPositionPropInfo.TID) < MgrMgr:GetMgr("EquipMgr").GetEquipLimitLevel(propInfo.TID) then
                wearPositionEquips[equipPosition] = propInfo
            end
        end
    end
end

--得到最适合的装备位置
function GetSuitEquipPosition(propInfo)
    local equipTableInfo = TableUtil.GetEquipTable().GetRowById(propInfo.TID)
    local equipId = equipTableInfo.EquipId
    local equipPosition = Data.BagModel.WeapTableType[equipId]
    if equipPosition == EquipPos.ORNAMENT1 then
        local decorationsFirst = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, equipPosition + 1)
        if decorationsFirst ~= nil then
            local decorationsSecond = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.ORNAMENT2 + 1)
            if decorationsSecond == nil then
                equipPosition = EquipPos.ORNAMENT2
            else
                if MgrMgr:GetMgr("EquipMgr").GetEquipLimitLevel(decorationsFirst.TID) > MgrMgr:GetMgr("EquipMgr").GetEquipLimitLevel(decorationsSecond.TID) then
                    equipPosition = EquipPos.ORNAMENT2
                end
            end
        end
    end

    return equipPosition
end

--添加道具数据
function AddItems(propInfo)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)
    if itemTableInfo.TypeTab == Data.BagModel.PropType.Weapon or itemTableInfo.Overlap ~= 1 then
        for i = 1, #QuickUseItems do
            if QuickUseItems[i].TID == propInfo.TID then
                table.remove(QuickUseItems, i)
                break
            end
        end
    end

    table.insert(QuickUseItems, propInfo)
end

--是否可以使用
---@param itemTableInfo ItemTable
function IsCanUse(itemTableInfo)
    --当是任务道具的时候不能快速使用
    if itemTableInfo.TypeTab == GameEnum.EItemType.Mission then
        return false
    end

    local C_QUICK_USE_MAP = {
        [GameEnum.EItemQuickUseType.NormalQuickUse] = 1,
        [GameEnum.EItemQuickUseType.ShowPackage] = 1,
    }

    if nil == C_QUICK_USE_MAP[itemTableInfo.QuickUse] then
        return false
    end

    local sexlimit = itemTableInfo.SexLimit
    local sex = MPlayerInfo.IsMale and 0 or 1
    if sexlimit == 2 or sexlimit == sex then
        if itemTableInfo.LevelLimit:get_Item(0) <= MPlayerInfo.Lv then
            if MgrMgr:GetMgr("EquipMgr").IsPlayerConformProfession(itemTableInfo.Profession) then
                return true
            end
        end
    end

    return false
end

--得到升级的道具数据
function GetQuickUseItemsOnUpgrade()
    local quickUseItems = {}
    for i, propInfo in pairs(getCanQuickUseItems()) do
        local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)
        if itemTableInfo.LevelLimit:get_Item(0) == MPlayerInfo.Lv then
            table.insert(quickUseItems, propInfo)
        end
    end

    return quickUseItems
end

--得到转职后相应的装备数据
function GetQuickUseItemsOnTransfer()
    local professionTable = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    local l_playerParentProfession = professionTable.ParentProfession
    local quickUseItems = {}
    for i, propInfo in pairs(getCanQuickUseItems()) do
        local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)
        local equipProfession = itemTableInfo.Profession
        local l_isCanShow = false

        --只取当前职业的
        if equipProfession.Length > 0 then
            if equipProfession[0][0] ~= 0 then
                for i = 1, equipProfession.Length do
                    local l_equipProfessionId = equipProfession[i - 1][0]
                    --如果装备的职业id等于当前的职业id
                    if l_equipProfessionId == MPlayerInfo.ProfessionId then
                        --如果是指定职业
                        if equipProfession[i - 1][1] == 1 then
                            l_isCanShow = true
                            break
                        else
                            --如果是一系职业
                            --如果父职业是初心者
                            if l_playerParentProfession == 1000 then
                                l_isCanShow = true
                                break
                            end
                        end
                    end
                end
            end
        end
        if l_isCanShow then
            table.insert(quickUseItems, propInfo)
        end
    end
    return quickUseItems
end

function GetQuickUseEquipItems()
    local quickUseItems = {}
    for i, propInfo in pairs(getCanQuickUseItems()) do
        if propInfo.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
            table.insert(quickUseItems, propInfo)
        end
    end
    return quickUseItems
end

--得到可以快捷使用的数据
function getCanQuickUseItems()
    local quickUseItems = {}
    local items = _getItemsInBag()
    for i, propInfo in pairs(items) do
        local itemTableInfo = propInfo.ItemConfig
        if itemTableInfo.QuickUse == 1 then
            table.insert(quickUseItems, propInfo)
        end
    end

    return quickUseItems
end

--- 获取背包中的道具
---@return ItemData[]
function _getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

function CanShowQuick()
    local ret = true
    if MCutSceneMgr.IsPlaying or MPlayerInfo.IsPhotoMode or MgrMgr:GetMgr("NpcMgr").IsTalking() then
        ret = false
    end
    return ret
end

function ShowQuickUse()
    if not CanShowQuick() then
        return
    end
    if #QuickUseItems > 0 then
        local propInfo = QuickUseItems[#QuickUseItems]
        local quickUse = propInfo.ItemConfig.QuickUse
        if quickUse == 1 then
            local l_propIconCtrl = UIMgr:GetUI(UI.CtrlNames.PropIcon)
            if (l_propIconCtrl ~= nil) then
                l_propIconCtrl:ShowQuickUse(propInfo)
            else
                local panelData = {
                    ShowQuickUseType = EShowQuickUseType.ShowQuickUse,
                    MethodData = propInfo
                }
                UIMgr:ActiveUI(UI.CtrlNames.PropIcon, panelData)
            end
        elseif quickUse == 2 then
            Pop()
            local l_itemFunctionSdata = TableUtil.GetItemFunctionTable().GetRowByItemId(propInfo.TID)
            local l_giftCtrl = UIMgr:GetUI(UI.CtrlNames.ChooseGift)
            if l_giftCtrl then
                l_giftCtrl:ShowChooseItems(l_itemFunctionSdata, propInfo.UID, propInfo.ItemCount)
            else
                UIMgr:ActiveUI(UI.CtrlNames.ChooseGift, function(ctrl)
                    ctrl:ShowChooseItems(l_itemFunctionSdata, propInfo.UID, propInfo.ItemCount)
                end)
            end
        end
    else
        local l_ui = UIMgr:GetUI(UI.CtrlNames.PropIcon)
        if l_ui then
            l_ui:CloseQuickUse()
        end
    end
end

function Pop()
    table.remove(QuickUseItems, #QuickUseItems)
end

--MgrMgr调用
function OnLogout()
    QuickUseItems = {}
end

return ModuleMgr.QuickUseMgr