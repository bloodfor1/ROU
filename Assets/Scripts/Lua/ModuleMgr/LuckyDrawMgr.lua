---
--- Created by chauncyhu.
--- DateTime: 2018/11/13 11:16
--- 抽卡机制
---
---@module ModuleMgr.LuckyDrawMgr
module("ModuleMgr.LuckyDrawMgr", package.seeall)

g_callBack = nil
g_isTimeLimit = true
g_reward = {}
g_realSlot = {}
g_otherSlot = {}
g_info = nil

WeightQuality = MGlobalConfig:GetVectorSequence("WeightQuality")
DungeonLuckyDrawExitTime  = MGlobalConfig:GetInt("DungeonLuckyDrawExitTime")

local l_mgr = MgrMgr:GetMgr("RollMgr")

g_type = l_mgr.g_RollContext.RollContextNone


function OnEnterScene(sceneId)
    if g_type ~= l_mgr.g_RollContext.RollContextNone then
        g_type = l_mgr.g_RollContext.RollContextNone
        g_reward = {}
        g_realSlot = {}
        g_otherSlot = {}
        g_callBack = nil
        g_isTimeLimit = true
        g_info = nil
    end
end

function PlayLuckyDraw(type, callBack,isTimeLimit)
    g_callBack = callBack
    if type ~= g_type then
        if g_callBack then
            g_callBack()
        end
        OnEnterScene()
        return
    end
    local l_ui = UIMgr:GetUI(UI.CtrlNames.LuckyDraw)
    if l_ui then
        UIMgr:DeActiveUI(UI.CtrlNames.LuckyDraw)
    else
        UIMgr:ActiveUI(UI.CtrlNames.LuckyDraw)
    end
end

function OnNotifyFlop(msg)
    ---@type FlopInfo
    local l_info = ParseProtoBufToTable("FlopInfo", msg)
    g_realSlot = l_info.real_slot
    g_otherSlot = l_info.other_slots
    g_type = l_info.context
    if g_type == l_mgr.g_RollContext.RollContextMini or g_type == l_mgr.g_RollContext.RollContextMvp then
        UIMgr:DeActiveUI(UI.CtrlNames.LuckyDraw)
    end
end

function DumpReward(id, num)
    g_reward = {}
    g_reward.id = id
    g_reward.num = num
end

-- 测试代码，用来查看特效
function TestUI()
    g_type = l_mgr.g_RollContext.RollContextDungeonsResult
    g_realSlot.price = 40 -- 1=40=1|41=60=2|61=80=3|81=100=4
    g_realSlot.item_count = 1
    g_realSlot.item_id = 2010001
    for i = 1, 4 do
        g_otherSlot[i] = {}
        g_otherSlot[i].item_id = 2010001 + i
    end
    UIMgr:ActiveUI(UI.CtrlNames.LuckyDraw)
end

return ModuleMgr.LuckyDrawMgr