---
--- Created by chauncyhu.
--- DateTime: 2018/11/13 11:11
--- roll机制
---
---@module ModuleMgr.RollMgr
module("ModuleMgr.RollMgr", package.seeall)

g_callBack = nil
g_isTimeLimit = true
g_roleInfo = {}
g_itemInfo = {}
g_confirmRoleId = {}
g_reward = {}
g_info = nil

g_RollContext = {
    RollContextNone = 0,
    RollContextDungeonsResult = 1,
    RollContextMvp = 2,
    RollContextMini = 3,
}

g_type = g_RollContext.RollContextNone

EventDispatcher = EventDispatcher.new()

ROLL_CONFIRM_NTF = "ROLL_CONFIRM_NTF"

function CanRoll()
    return g_type ~= g_RollContext.RollContextNone or
    MgrMgr:GetMgr("LuckyDrawMgr").g_type ~= g_RollContext.RollContextNone
end

function OnEnterScene(sceneId)
    if g_type ~= g_RollContext.RollContextNone then
        g_type = g_RollContext.RollContextNone
        g_roleInfo = {}
        g_itemInfo = {}
        g_confirmRoleId = {}
        g_reward = {}
        g_callBack = nil
        g_isTimeLimit = true
        g_info = nil
    end
end

function PlayRollOrLuckyDraw(type, callBack,isTimeLimit)
    PlayRoll(type, function()
        local l_mgr = MgrMgr:GetMgr("LuckyDrawMgr")
        l_mgr.PlayLuckyDraw(type, callBack,isTimeLimit)
    end,isTimeLimit)
end

function PlayRoll(type, callBack,isTimeLimit)
    g_callBack = callBack
    g_isTimeLimit = isTimeLimit
    if type ~= g_type then
        if g_callBack then
            g_callBack()
        end
        OnEnterScene()
        return
    end

    UIMgr:DeActiveUI(UI.CtrlNames.RollPoint, false)
    UIMgr:ActiveUI(UI.CtrlNames.RollPoint)
end

function OnNotifyRollStart(msg)
    ---@type RollData
    local l_info = ParseProtoBufToTable("RollData", msg)
    g_roleInfo = {}
    g_itemInfo = {}
    g_confirmRoleId = {}
    g_callBack = nil
    if #l_info.roleinfo == 0 then
        logError("[RollMgr]player number == 0!@James")
    end
    if #l_info.iteminfo == 0 then
        logError("[RollMgr]item number == 0!@James")
    end
    if #l_info.roleinfo ~= #l_info.iteminfo then
        logError("[RollMgr]player number is not equal the item number!@James")
    end
    for i = 1, #l_info.iteminfo do
        local l_target = l_info.iteminfo[i]
        local l_itemId = l_target.item_id
        local l_count = l_target.item_count
        local l_price = l_target.price
        local l_index = #g_itemInfo + 1
        g_itemInfo[l_index] = {}
        g_itemInfo[l_index].itemId = l_itemId
        g_itemInfo[l_index].count = l_count
        g_itemInfo[l_index].price = l_price
        --logError("--->>>"..tostring(l_itemId).."--->>>"..tostring(l_price))
    end
    for i = 1, #l_info.roleinfo do
        local l_target = l_info.roleinfo[i]
        local l_roleId = l_target.key
        local l_point = l_target.value
        local l_index = #g_roleInfo + 1
        g_roleInfo[l_index] = {}
        g_roleInfo[l_index].roleId = l_roleId
        g_roleInfo[l_index].point = l_point > 99 and 99 or l_point
        g_roleInfo[l_index].itemID = g_itemInfo[l_index].itemId
        --logError("--->>>"..tostring(l_roleId).."--->>>"..tostring(l_point))
    end
    table.sort(g_itemInfo, function(x, y)
        return x.price > y.price
    end)
    g_type = l_info.context
    if g_type == g_RollContext.RollContextMini or g_type == g_RollContext.RollContextMvp then
        PlayRoll(g_type, nil)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.RollPoint)
    end
end

function SendRollConfirm()
    local l_msgId = Network.Define.Ptc.RollConfirm
    ---@type RollConfirmData
    local l_sendInfo = GetProtoBufSendTable("RollConfirmData")
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function OnRollConfirmNtf(msg)
    ---@type RollConfirmNtfData
    local l_info = ParseProtoBufToTable("RollConfirmNtfData", msg)
    local l_roleId = l_info.role_id
    local l_index = #g_confirmRoleId + 1
    g_confirmRoleId[l_index] = l_roleId
    EventDispatcher:Dispatch(ROLL_CONFIRM_NTF, l_roleId)
end

function DumpReward(id, num)
    g_reward = {}
    g_reward.id = id
    g_reward.num = num
end

return ModuleMgr.RollMgr