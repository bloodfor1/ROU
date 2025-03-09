require "Common/Bit32"
require "Common/Functions"
require "Data/Model/BagModel"
require "Data/Model/BagApi"

---@module ModuleMgr.RefineTransferMgr
module("ModuleMgr.RefineTransferMgr", package.seeall)

--- uint64
SelectOldEquip = nil
--- uint64
SelectNewEquip = nil
SelectBlockEquip = nil

ON_SELECT_TRANSFER_EQUIP = "ON_SELECT_TRANSFER_EQUIP"
ON_TRANSFER_SUCCESS_EVENT = "ON_TRANSFER_SUCCESS_EVENT"
ON_UNSEAL_SUCCESS_EVENT = "ON_UNSEAL_SUCCESS_EVENT"

EventDispatcher = EventDispatcher.new()

local function _shr(shift)
    return Common.Bit32.Lshift(1, shift)
end

local _job_style_map = {
    [1] = _shr(1) + _shr(16),
    [2] = _shr(2) + _shr(3) + _shr(4) + _shr(5),
    [3] = _shr(2) + _shr(3) + _shr(4) + _shr(5),
    [4] = _shr(2) + _shr(3) + _shr(4) + _shr(5),
    [5] = _shr(2) + _shr(3) + _shr(4) + _shr(5),
    [6] = _shr(6) + _shr(7) + _shr(8),
    [7] = _shr(6) + _shr(7) + _shr(8),
    [8] = _shr(6) + _shr(7) + _shr(8) + _shr(9) + _shr(10),
    [9] = _shr(8) + _shr(9) + _shr(10),
    [10] = _shr(8) + _shr(9) + _shr(10),
    [11] = _shr(11),
    [16] = _shr(1) + _shr(16),
}

--- 检查是不是装备
---@param itemData ItemData
local function _common_check(itemData)
    return nil ~= itemData and nil ~= itemData.EquipConfig
end

function Reset()
    SelectOldEquip = nil
    SelectNewEquip = nil
    SelectBlockEquip = nil
    if UIMgr:IsActiveUI(UI.CtrlNames.RefineTransfer) then
        MgrMgr:GetMgr("SelectEquipMgr").g_equipSystem = MgrMgr:GetMgr("SelectEquipMgr").EquipSystem.Transfer
    end
end

-- 是否可以转移
---@param itemData ItemData
function OriginalEquipCanTransfer(itemData)
    if not _common_check(itemData) then
        return false, 1
    end

    if 0 >= itemData.RefineLv then
        return false, 3
    end

    if itemData.Damaged then
        return false, 4
    end

    if 0 < itemData.RefineSealLv then
        return false, 8
    end

    -- 判断新装备
    local l_ori_equip = GetEquipByUid(SelectNewEquip)
    if l_ori_equip then
        if not CheckTwoEquipCanTransfer(itemData, l_ori_equip) then
            return false, 7
        end
    end

    return true
end

---@param itemData ItemData
---@param srcItemData ItemData
function NewEquipCanBeTransfer(itemData, srcItemData)
    if not _common_check(itemData) then
        return false, 1
    end

    if itemData.Damaged then
        return false, 4
    end

    --- 如果直接点击右侧加号，旧数据会为空，这个时候不需要判断
    if nil ~= srcItemData then
        if itemData.RefineLv >= srcItemData.RefineLv then
            return false, 6
        end
    end

    if 7 == itemData.EquipConfig.EquipId then
        return false, 6
    end

    local l_old_equip = GetEquipByUid(SelectOldEquip)
    if l_old_equip then
        if not CheckTwoEquipCanTransfer(l_old_equip, itemData) then
            return false, 5
        end
    end

    return true
end

-- 是否可以接受转移
---@param oldItemData ItemData
---@param newItemData ItemData
function CheckTwoEquipCanTransfer(oldItemData, newItemData)
    local l_old_item = oldItemData.ItemConfig
    local l_new_item = newItemData.ItemConfig
    if not l_old_item or not l_new_item then
        return false, 1
    end

    if newItemData.RefineLv >= oldItemData.RefineLv then
        return false, 6
    end

    -- 新装备等级大于老装备
    --local l_old_level = l_old_item.LevelLimit:get_Item(0)
    --local l_new_level = l_new_item.LevelLimit:get_Item(0)
    --if l_old_level > l_new_level then
    --    return false, 2
    --end


    local l_old_equip = oldItemData.EquipConfig
    local l_new_equip = newItemData.EquipConfig
    if not l_old_equip or not l_new_equip then
        return false, 4
    end

    --新装备的精炼最大等级要大于等于旧装备的
    if l_old_equip.RefineMaxLv>l_new_equip.RefineMaxLv then
        return false, 2
    end

    -- 装备类型相同时，可以转移
    if l_old_equip.EquipId ~= 1 then
        if l_old_equip.EquipId ~= l_new_equip.EquipId then
            return false, 6
        end

        return CheckProfessionMatch(
                Common.Functions.VectorSequenceToTable(l_old_item.Profession),
                Common.Functions.VectorSequenceToTable(l_new_item.Profession)
        )
    end

    -- 装备类型不同时
    return Common.Bit32.And(_job_style_map[l_old_equip.WeaponId], _shr(l_new_equip.WeaponId)) > 0, 5
end

function CheckProfessionMatch(p1, p2)
    if not p1 or not p2 then
        return false, 7
    end

    for i, v1 in ipairs(p1) do
        for j, v2 in ipairs(p2) do
            if v1[1] == v2[1] or v1[1] == 0 or v2[1] == 0 then
                return true
            end
        end
    end

    return false, 8
end

-- 是否可以解除封印
---@param itemData ItemData
function CheckCanUnseal(itemData)
    if not _common_check(itemData) then
        return false, 1
    end

    if 0 >= itemData.RefineLv then
        return false, 2
    end

    if itemData.Damaged then
        return false, 4
    end

    if 0 >= itemData.RefineSealLv then
        return false, 3
    end

    return true
end

function BroadcastChangeSelectHole(refresh_tog)
    EventDispatcher:Dispatch(ON_SELECT_TRANSFER_EQUIP, refresh_tog)
end

function RequestRefineTransferEquip(perfect)
    local l_old_equip = GetEquipByUid(SelectOldEquip)
    local l_new_equip = GetEquipByUid(SelectNewEquip)
    local reqRefineTransfer = function()
        if not l_old_equip or not l_new_equip then
            logError("RequestRefineTransferEquip fail, UnExpected error")
            return
        end

        local l_item_row = TableUtil.GetItemTable().GetRowByItemID(l_new_equip.TID)
        local l_name = l_item_row and l_item_row.ItemName or ""

        local l_refine_level = SafeGetEquipRefineLevel(l_old_equip)
        local l_seal_level, l_err = GetSealLevel(SelectOldEquip, SelectNewEquip)
        local l_text
        if not perfect and (l_seal_level > 0) then
            l_text = Lang("REFINE_TRANSFER_SUCCESS_FORMAT1", l_refine_level, l_seal_level, l_name)
        else
            l_text = Lang("REFINE_TRANSFER_SUCCESS_FORMAT2", l_refine_level, l_name)
        end

        local l_msgId = Network.Define.Rpc.EquipRefineTransfer
        ---@type EquipRefineTransferArg
        local l_sendInfo = GetProtoBufSendTable("EquipRefineTransferArg")
        l_sendInfo.from_uid = l_old_equip.UID
        l_sendInfo.to_uid = l_new_equip.UID
        l_sendInfo.is_perfect = perfect
        Network.Handler.SendRpc(l_msgId, l_sendInfo, l_text)
    end

    if 0 < l_new_equip.RefineLv then
        local togType = GameEnum.EDialogToggleType.NoHintToday
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("C_REFINE_OVERRIDE_CONFIRM"), reqRefineTransfer, nil, -1, togType, nil, nil)
    else
        reqRefineTransfer()
    end
end

function OnRefineTransferEquip(msg, _, text)
    ---@type EquipRefineTransferRes
    local l_info = ParseProtoBufToTable("EquipRefineTransferRes", msg)
    if l_info.result ~= 0 then
        logError("OnRefineTransferEquip ErrorCode:" .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    SelectOldEquip = nil
    SelectNewEquip = nil
    BroadcastChangeSelectHole()
    EventDispatcher:Dispatch(ON_TRANSFER_SUCCESS_EVENT)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(text)
end

function RequestUnlockEquip(uid, count, content)
    local l_msgId = Network.Define.Rpc.EquipRefineUnblock
    ---@type EquipRefineUnblockArg
    local l_sendInfo = GetProtoBufSendTable("EquipRefineUnblockArg")
    l_sendInfo.item_uid = uid
    l_sendInfo.count = count
    Network.Handler.SendRpc(l_msgId, l_sendInfo, content)
end

function OnUnlockEquip(msg, arg, content)
    ---@type EquipRefineUnblockRes
    local l_info = ParseProtoBufToTable("EquipRefineUnblockRes", msg)

    if l_info.result ~= 0 then
        logError("OnUnlockEquip ErrorCode:" .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(content or "")
    if l_info.cur_exp <= 0 then
        Reset()
    end

    EventDispatcher:Dispatch(ON_UNSEAL_SUCCESS_EVENT, l_info.cur_exp <= 0)
end

---@return ItemData
function GetEquipByUid(uid)
    local types = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Bag,
    }

    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

---@param itemData ItemData
function SafeGetEquipRefineLevel(itemData)
    if not itemData then
        return 0
    end

    return itemData.RefineLv
end

---@param itemData ItemData
function SafeGetEquipSealInfo(itemData)
    if not itemData then
        return 0, 0
    end

    return itemData.RefineSealLv, itemData.RefineUnlockExp
end

function GetSealLevel(old_uid, new_uid)
    local l_old_equip = GetEquipByUid(old_uid)
    local l_new_equip = GetEquipByUid(new_uid)
    if not l_old_equip or not l_new_equip then
        return 0, 1
    end

    local l_old_row = l_old_equip.EquipConfig
    local l_new_row = l_new_equip.EquipConfig
    if not l_old_row or not l_new_row then
        return 0, 2
    end

    local l_jump_level = math.max((l_new_row.SecondId % 100 - l_old_row.SecondId % 100), 1)
    local l_refine_level = SafeGetEquipRefineLevel(l_old_equip)
    local l_seal_level = 0
    local l_perfect_cost
    for i = math.max(l_refine_level - l_jump_level, 1), l_refine_level - 1 do
        local l_transfer_row = TableUtil.GetRefineTransfer().GetRowByRefineLv(i)
        if not l_transfer_row then
            return 0, 3
        end
        l_seal_level = l_seal_level + l_transfer_row.ReduceLv

        local l_cost = TransferPerferfectcostToTable(l_transfer_row.PerfectConsume)
        if l_cost then
            l_perfect_cost = l_perfect_cost or {}
            l_perfect_cost[l_cost.item] = l_perfect_cost[l_cost.item] and (l_perfect_cost[l_cost.item] + l_cost.count) or (l_cost.count)
        end
    end

    return l_seal_level, 0, l_perfect_cost
end

function TransferPerferfectcostToTable(cost)
    if cost and cost.Length == 2 then
        if cost[1] > 0 then
            return {
                item = cost[0],
                count = cost[1],
            }
        end
    end
end

function ShowUnBlockUI(uid)
    SelectBlockEquip = uid
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenRefineTransferPanle()
end

--SelectEquip
---@param data ItemData[]
function GetSelectEquips(data)
    local equips = {}
    local l_horseType = EquipPos.HORSE
    for i = 1, #data do
        local l_equipTableInfo = data[i].EquipConfig
        if l_equipTableInfo and l_equipTableInfo.EquipId ~= l_horseType then
            table.insert(equips, data[i])
        end
    end

    return equips
end

function GetNoneEquipText()
    return Lang("NOREFINEETRANSFERQUIP")
end

function GetFinalShowEquips(equips)
    local l_result = {}
    for i, v in ipairs(equips) do
        if OriginalEquipCanTransfer(v) then
            table.insert(l_result, v)
        end
    end

    return l_result
end

return ModuleMgr.RefineTransferMgr