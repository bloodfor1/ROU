---
--- Created by chauncyhu.
--- DateTime: 2019/2/28 11:10
---
---@module ModuleMgr.DungeonTargetMgr
module("ModuleMgr.DungeonTargetMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

ON_UPDATE_DUNGEONS_TARGET = "ON_UPDATE_DUNGEONS_TARGET"
ON_DUNGEONS_TARGET_SECTION = "ON_DUNGEONS_TARGET_SECTION"
--副本内点击任务导航 指引观看副本目标
ON_TASK_NAVGATION_GUIDE_DUNGEONS_TARGET = "ON_TASK_NAVGATION_GUIDE_DUNGEONS_TARGET"

l_targetInfo = {}
l_id = nil
l_pos = nil
l_refresh = false

function OnUpdateDungeonsTarget(msg)
    ---@type DungeonsTargetData
    local l_info = ParseProtoBufToTable("DungeonsTargetData", msg)
    local l_id = l_info.id
    local l_curStep = tonumber(l_info.cur_step) or 0
    local l_totalCount = tonumber(l_info.total_count) or 0

    if l_id > 0 then
        local l_count = #l_targetInfo
        if l_count > 0 then
            for i = 1, l_count do
                if l_targetInfo[i].id == l_id then
                    l_targetInfo[i].cur_step = l_curStep
                    l_targetInfo[i].total_count = l_totalCount
                    if l_curStep == l_totalCount then
                        SelectPos()
                    end
                    local l_table = TableUtil.GetDungeonTargetTable().GetRowByID(l_id)
                    --if l_table then
                    --    MgrMgr:GetMgr("TipsMgr").ShowTaskTips(GetColorText(l_table.TargetDes, RoColorTag.Yellow)
                    --    .."  ".. l_curStep .. "/" .. l_totalCount)
                    --end
                end
            end
        end
        EventDispatcher:Dispatch(ON_UPDATE_DUNGEONS_TARGET, l_id, l_curStep, l_totalCount)
    end
end

function OnDungeonsTargetSection(msg)
    ---@type DungeonsTargetSection
    local l_info = ParseProtoBufToTable("DungeonsTargetSection", msg)
    local l_count = #l_info.targets
    l_targetInfo = {}
    l_id = l_info.dungeons_id
    l_refresh = true

    if l_count > 0 then
        for i = 1, l_count do
            l_targetInfo[i] = {}
            l_targetInfo[i].id = l_info.targets[i].id
            l_targetInfo[i].cur_step = tonumber(l_info.targets[i].cur_step) or 0
            l_targetInfo[i].total_count = tonumber(l_info.targets[i].total_count) or 0
            local l_table = TableUtil.GetDungeonTargetTable().GetRowByID(l_info.targets[i].id)
            if l_table then
                l_targetInfo[i].pos = l_table.GuidePos
            end
        end
    end
    SelectPos()
    EventDispatcher:Dispatch(ON_DUNGEONS_TARGET_SECTION)
end

function SelectPos()
    local l_count = #l_targetInfo
    MapObjMgr:RmObj(MapObjType.DungeonTarget)
    l_pos = nil
    if l_count > 0 then
        for i = 1, l_count do
            if l_targetInfo[i].total_count > 0 and
                    l_targetInfo[i].total_count ~= l_targetInfo[i].cur_step then
                if not l_pos and l_targetInfo[i].pos and l_targetInfo[i].pos.Length > 2 and
                        l_targetInfo[i].pos[0] > 0 and l_targetInfo[i].pos[2] > 0 then
                    l_pos = l_targetInfo[i].pos
                    local l_iconPos=Vector2.New(l_pos[0], l_pos[2])
                    local l_mapInfoMgr=MgrMgr:GetMgr("MapInfoMgr")
                    l_mapInfoMgr.EventDispatcher:Dispatch(l_mapInfoMgr.EventType.UpdateNavIconPos,l_mapInfoMgr.EUpdateNavIconType.DungeonTargetNav,l_iconPos)
                end
                return
            end
        end
    end
end

function IsInDungeonTarget(id, step)
    local ret = false
    if not id then
        return ret
    end

    step = step or -1
    for i, v in ipairs(l_targetInfo) do
        if step > 0 then
            ret = v.id == id and v.cur_step == step
        else
            ret = v.id == id
        end
        if ret then
            break
        end
    end
    return ret
end

function GetDungeonTargetInfo(targetId)
    for key, value in ipairs(l_targetInfo) do
        if value.id == targetId then
            return value
        end
    end
    return nil
end

--任务指引展示副本目标高亮
function TaskGuideToDungeonsTarget()
    EventDispatcher:Dispatch(ON_TASK_NAVGATION_GUIDE_DUNGEONS_TARGET)
end


return DungeonTargetMgr
