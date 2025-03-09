require "Data/Model/BagApi"

module("ModuleMgr.ArrowMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
SELECT_ITEM = "SELECT_ITEM"
REFRESH_SLOTS = "REFRESH_SLOTS"
UPDATE_MAINARROW = "UPDATE_MAINARROW"

-- 是否装备弓类武器
g_wearBow = false
-- 装载的弓箭信息
g_arrows = {}
-- 等待设置箭矢
g_waitForSetArrow = false
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function OnLogout()

    g_wearBow = false
    g_arrows = {}
    g_waitForSetArrow = false

end

function OnSelectRoleNtf(l_info)

    local arrows = l_info.bag and l_info.bag.arrows
    if arrows then
        SetArrows(arrows)
    end

    local equips = _getAllEquips()
    for i, v in pairs(equips) do
        if v.TID > 0 then
            g_wearBow = IsBow(v.TID)
            if g_wearBow then
                break
            end
        end
    end

end

function SetArrows(arrows)

    for i, arrowpair in ipairs(arrows) do
        local pos = arrowpair.pos or 0
        g_arrows[pos] = arrowpair.arrow_id or 0
    end

end

--- cs当中对于这个代码是有调用的，lua当中没有引用，不能随便用
---@return int64
function GetArrowCost()
    local ret = 0
    if not g_arrows[0] or g_arrows[0] == 0 then
        ret = -1
        return ret
    end

    ret = Data.BagModel:GetBagItemCountByTid(g_arrows[0])
    return tonumber(ret)
end

function GetEquipArrowPos(arrowId)

    local _pos = nil
    for pos, v in pairs(g_arrows) do
        if v == arrowId and pos > 0 then
            _pos = pos
            break
        end
    end
    return _pos

end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)

    if nil == itemUpdateDataList then
        logError("[ArrowMgr] invalid param")
        return
    end
    local newArrows = {}
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local compareData = singleUpdateData:GetItemCompareData()
        if nil ~= singleUpdateData.NewItem
                and IsArrow(compareData.id)
                and not HasLoadArrow(compareData.id)
        then
            array.addUnique(newArrows, compareData.id)
        end
    end
    g_wearBow = _playerWearingBow()
    _saveArrows(newArrows)

end

---@return boolean
function _playerWearingBow()

    local containerType = GameEnum.EBagContainerType
    local equipSlot = GameEnum.EEquipSlotIdxType
    local targetItem = Data.BagApi:GetItemByTypeSlot(containerType.Equip, equipSlot.MainWeapon)
    if nil == targetItem then
        return false
    end
    if nil == targetItem.EquipConfig then
        return false
    end

    local weaponDetailType = GameEnum.EWeaponDetailType
    return weaponDetailType.Bow == targetItem.EquipConfig.WeaponId

end

function _saveArrows(newArrows)

    local autoSave = false
    for i, v in ipairs(newArrows) do
        for i = 1, 3 do
            if not g_arrows[i] or g_arrows[i] == 0 then
                g_arrows[i] = v
                autoSave = true
                break
            end
        end
    end

    if autoSave then
        Save(g_arrows)
    end

end

function IsBow(itemId)

    local isBow = false
    local equipSdata = TableUtil.GetEquipTable().GetRowById(itemId)
    if equipSdata then
        isBow = equipSdata.WeaponId == 11
    end
    return isBow

end

--- 判断道具是否是弓箭
function IsArrow(propId)

    local isArrow = false
    local itemFuncSdata = TableUtil.GetItemFunctionTable().GetRowByItemId(propId, true)
    if itemFuncSdata then
        isArrow = itemFuncSdata.ItemFunction == 8
    end
    return isArrow

end

function OnChangeSkillOperation()

    local ui = UIMgr:GetUI(UI.CtrlNames.MainArrows)
    if ui then
        ui:RefreshArrows()
    end

end

function IsWearBow()
    return g_wearBow
end

---@return table<number, int64>
function GetBagArrows()
    local arrows = {}
    local props = _getArrowInBag()
    for i, v in ipairs(props) do
        if IsArrow(v.TID) then
            arrows[v.TID] = v.ItemCount
        end
    end

    for i = 1, 3 do
        local arrowId = g_arrows[i]
        if arrowId and arrowId > 0 then
            if not arrows[arrowId] then
                arrows[arrowId] = 0
            end
        end
    end

    return arrows
end

--- 获取装备位上的道具
---@return ItemData[]
function _getAllEquips()

    local types = { GameEnum.EBagContainerType.Equip }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret

end

--- 获取背包当中的道具
---@return ItemData[]
function _getArrowInBag()

    local types = { GameEnum.EBagContainerType.Bag }
    ---@type FiltrateCond
    local condition = { Cond = _isArrow, Param = GameEnum.EItemFunctionType.Arrow }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret

end

--- 获取道具的判断条件
---@param itemData ItemData
---@param funcType number
function _isArrow(itemData, funcType)

    if nil == itemData then
        return false
    end
    if nil == itemData.ItemFunctionConfig then
        return false
    end
    return itemData.ItemFunctionConfig.ItemFunction == funcType

end

function GetBagArrowsList()

    local arrows = {}
    local props = _getArrowInBag()
    for i, v in ipairs(props) do
        if IsArrow(v.TID) then
            table.insert(arrows, v)
        end
    end
    for i = 1, 3 do
        local arrowId = g_arrows[i]
        if arrowId and arrowId > 0 then
            if not array.find(arrows, function(v)
                return v.TID == arrowId
            end) then
                local locItem = Data.BagModel:CreateItemWithTid(arrowId)
                locItem.ItemCount = 0
                table.insert(arrows, locItem)
            end
        end
    end
    return arrows

end


--==============================--
--@Description:设置箭矢
--@Date: 2018/11/21
--@Param: [args]
--@Return:
--==============================--
function SetUpArrow(i)

    local equipArrowId = g_arrows[i]
    if equipArrowId and equipArrowId > 0 then
        g_waitForSetArrow = true
        local l_msgId = Network.Define.Rpc.SetArrow
        ---@type SetArrowArg
        local l_sendInfo = GetProtoBufSendTable("SetArrowArg")
        local arrowData = l_sendInfo.arrow_data:add()
        arrowData.arrow_id = equipArrowId
        arrowData.pos = ArrowPos.ARROW_POS_IN_USE
        Network.Handler.SendRpc(l_msgId, l_sendInfo, { { pos = i, arrowId = equipArrowId }, setUpArrow = true })
    end

end

function CancleArrow(i)

    local equipArrowId = g_arrows[i]
    if equipArrowId and equipArrowId > 0 then
        g_waitForSetArrow = true
        local l_msgId = Network.Define.Rpc.SetArrow
        ---@type SetArrowArg
        local l_sendInfo = GetProtoBufSendTable("SetArrowArg")
        local arrowData = l_sendInfo.arrow_data:add()
        arrowData.arrow_id = 0
        arrowData.pos = ArrowPos.ARROW_POS_IN_USE
        Network.Handler.SendRpc(l_msgId, l_sendInfo, { { pos = i, arrowId = equipArrowId }, { pos = 0, arrowId = 0 }, cancleArrow = true })
    end

end

function Save(chooseInfo)

    if chooseInfo then
        g_waitForSetArrow = true
        local l_msgId = Network.Define.Rpc.SetArrow
        ---@type SetArrowArg
        local l_sendInfo = GetProtoBufSendTable("SetArrowArg")
        local customData = {}
        for i = 0, 3 do
            local arrowData = l_sendInfo.arrow_data:add()
            arrowData.pos = i
            if i == 0 then
                if g_arrows[i] and g_arrows[i] > 0 then
                    local isFind = false
                    for j = 1, 3 do
                        if chooseInfo[j] and chooseInfo[j] == g_arrows[i] then
                            arrowData.arrow_id = chooseInfo[j]
                            isFind = true
                            break
                        end
                    end
                    if not isFind then
                        arrowData.arrow_id = 0
                    end
                else
                    arrowData.arrow_id = 0
                end
            else
                arrowData.arrow_id = chooseInfo[i] or 0
            end
            table.insert(customData, { pos = i, arrowId = arrowData.arrow_id })
        end
        Network.Handler.SendRpc(l_msgId, l_sendInfo, customData)
    end

end

function OnSetUpArrow(msg, sendArg, customData)

    g_waitForSetArrow = false
    ---@type SetArrowRes
    local l_info = ParseProtoBufToTable("SetArrowRes", msg)
    if l_info.error ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        return
    end

    local function _hasArrow(_arrow_id)
        local ret = false
        for i, v in ipairs(customData) do
            if v.arrowId == _arrow_id then
                ret = true
                break
            end
        end
        return ret
    end
    if customData then
        if customData.setUpArrow then
            g_arrows[0] = customData[1].arrowId
        elseif customData.cancleArrow then
            for i, v in ipairs(customData) do
                g_arrows[v.pos] = v.arrowId
            end
        else
            for i, v in ipairs(customData) do
                g_arrows[v.pos] = v.arrowId
            end
            for pos, v in pairs(g_arrows) do
                if pos > 0 and not _hasArrow(v) then
                    g_arrows[pos] = nil
                elseif pos == 0 and not _hasArrow(v) then
                    g_arrows[pos] = nil
                end
            end
        end
        EventDispatcher:Dispatch(REFRESH_SLOTS)
        local ui = UIMgr:GetUI(UI.CtrlNames.MainArrows)
        if ui then
            ui:Packup()
        end
    end

end

function IsWaitForSetArrow()
    return g_waitForSetArrow
end

function GetEquipArrowId()
    return g_arrows[0] or 0
end

function IsEquipArrow(i)

    local ret = false
    if g_arrows[i] and g_arrows[0] and g_arrows[0] ~= 0 then
        ret = g_arrows[i] == g_arrows[0]
    end
    return ret

end

function IsFull()

    local ret = true
    for i = 1, 3 do
        if not g_arrows[i] or g_arrows[i] == 0 then
            ret = false
            break
        end
    end
    return ret

end

function OnClickGround()

    local ui = UIMgr:GetUI(UI.CtrlNames.MainArrows)
    if ui then
        ui:Packup()
    end

end

function OnDragStick()
    GlobalEventBus:Dispatch(EventConst.Names.DragJoyStick)
end

function SetToDefaultArrow()

    if not g_wearBow then
        return
    end
    local equipArrowId = GetEquipArrowId()
    if equipArrowId > 0 then
        local idx = -1
        for i = 1, 3 do
            if g_arrows[i] and g_arrows[i] == equipArrowId then
                idx = i
                break
            end
        end
        if idx > 0 then
            CancleArrow(idx)
        end
    end

end

function HasLoadArrow(arrowId)

    local ret = false
    if not arrowId then
        return ret
    end
    for i = 1, 3 do
        if g_arrows[i] and g_arrows[i] == arrowId then
            ret = true
            break
        end
    end
    return ret

end

function OpenArrowSetup()

    if not IsWearBow() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ARROW_NOT_EQUIP"))
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.ArrowSetup)

end

function CanShowArrow()

    local ret = true
    if not MgrMgr:GetMgr("MainUIMgr").IsShowSkill then
        return false
    end
    if not IsWearBow() then
        return false
    end
    if MgrMgr:GetMgr("ThemePartyMgr").DuringThemePartyScene() then
        return false
    end
    if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.IsTransfigured then
        return false
    end
    return ret

end

function RefreshArrowPanel()

    if CanShowArrow() then
        UIMgr:ActiveUI(UI.CtrlNames.MainArrows)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.MainArrows)
    end

end

function FreshMainArrow()

    local arrowMgr = MgrMgr:GetMgr("ArrowMgr")
    local showSkill = MgrMgr:GetMgr("MainUIMgr").IsShowSkill
    if showSkill and arrowMgr.IsWearBow() and not MgrMgr:GetMgr("ThemePartyMgr").DuringThemePartyScene() then
        UIMgr:ActiveUI(UI.CtrlNames.MainArrows)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.MainArrows)
    end

end

return ArrowMgr