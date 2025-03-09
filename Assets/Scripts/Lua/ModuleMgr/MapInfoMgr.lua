require "UI/UIConst"
module("ModuleMgr.MapInfoMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
EUpdateNavIconType=
{
    TaskNav=0,
    DungeonTargetNav=1,
}
EventType = {
    AddMapEffect = "AddMapEffect", --载具使用状态变更
    RmMapEffect = "RmMapEffect", --删除特效
    UpdateMapBg = "UpdateMapBg", --更新小地图展示内容
    OnStopNavigation = "OnStopNavigation", --C#停止寻路时事件
    OnWeatherChange = "OnWeatherChange",
    UpdateHour="UpdateHour",
    OnTaskNpcStateChanged="OnTaskNpcStateChanged",
    OnSelectTarget="OnSelectTarget",
    OnUpdateDebugVisible="OnUpdateDebugVisible",
    UpdateNavIconPos = "UpdateNavIconPos",
    ShowBigMap= "ShowBigMap",
    UpdateNpcInfoFoldState="UpdateNpcInfoFoldState",  --更新npc信息面板折叠状态
    UpdateNpcInfoSelectState="UpdateNpcInfoSelectState",  --更新npc信息面板选中状态
    OnDungeonMonsterNumUpdate="OnDungeonMonsterNumUpdate",
}
local taskNpcInfo={}

function ShowMapPanel(isShow)
    if UIMgr:IsActiveUI(UI.CtrlNames.Map) then
        EventDispatcher:Dispatch(EventType.UpdateMapBg)
        EventDispatcher:Dispatch(EventType.ShowBigMap,isShow)
    else
        if game:IsLogout()==false then
            UIMgr:ActiveUI(UI.CtrlNames.Map,{isShowBigMap=isShow})
        end
    end
end
function OnUpdateMapBg(recover,sceneId,mapIndex)
    if recover then
        MapDataModel.TriggerSceneId=0
        MapDataModel.TriggerSceneMapIndex=0
    else
        MapDataModel.TriggerSceneId=sceneId
        MapDataModel.TriggerSceneMapIndex=mapIndex
    end
    EventDispatcher:Dispatch(EventType.UpdateMapBg)
end
function OnSelectTarget(uid)
    EventDispatcher:Dispatch(EventType.OnSelectTarget,uid)
end
function OnUpdateDebugVisible(show)
    EventDispatcher:Dispatch(EventType.OnUpdateDebugVisible,show)
end
function OnDungeonMonsterNumUpdate(count,changeValue)
    EventDispatcher:Dispatch(EventType.OnDungeonMonsterNumUpdate,count,changeValue)
end
function OnStopNavigation()
    EventDispatcher:Dispatch(EventType.OnStopNavigation)
end
function OnWeatherChange()
    EventDispatcher:Dispatch(EventType.OnWeatherChange)
end
function OnUpdateHour()
    EventDispatcher:Dispatch(EventType.UpdateHour)
end
function OnEnterScene(sceneId)
    FreshAllTaskNpcMapObj(MScene.SceneID, 0)
    UIMgr:DeActiveUI(UI.CtrlNames.MonsterInfoTips)
    EventDispatcher:Dispatch(EventType.UpdateMapBg,true)
end
function OnLeaveScene(sceneId)
    OnUpdateMapBg(true,0,0)
end
--任务NPC相关
function AddNpcInfo(sceneId, npcId, taskId)
    ChangeTaskNpcInfo(sceneId, npcId, taskId)
end
function RemoveNpcInfo(sceneId, npcId, taskId)
    ChangeTaskNpcInfo(sceneId, npcId, taskId)
end

function ChangeTaskNpcInfo(sceneId, npcId, taskId)
    if taskNpcInfo[sceneId] == nil then
        taskNpcInfo[sceneId]={}
    end
    local l_info = MgrMgr:GetMgr("TaskMgr").GetNpcMapInfo(sceneId, npcId)
    taskNpcInfo[sceneId][npcId] = l_info
    ChangeTaskNpcMapObj(sceneId, npcId, taskId)
end
function ChangeTaskNpcMapObj(sceneId,npcId,taskId)
    if sceneId~=MScene.SceneID then
        return
    end
    local l_info = taskNpcInfo[sceneId][npcId]
    if l_info == nil then
        MapObjMgr:RmObj(MapObjType.TaskNpc,npcId)
        EventDispatcher:Dispatch(EventType.OnTaskNpcStateChanged,npcId)
    else
        AddTaskNpcMapObj(sceneId,npcId,taskId)
    end
end
function AddTaskNpcMapObj(sceneId,npcId,taskId)
    local l_info = taskNpcInfo[sceneId][npcId]
    if l_info==nil then
        return
    end
    --先从Lua离线表取位置 取不到再去C#取 都取不到报错
    local l_pos = Common.CommonUIFunc.GetNpcPosBySceneId(npcId,sceneId) or MSceneMgr:GetNpcPos(npcId, sceneId, taskId)
    if(l_pos.x == -1 and l_pos.y == -1 and l_pos.z == -1)then
        logError("NPC pos is nil!")
    end
    local l_v2 = Vector2(l_pos.x, l_pos.z)
    local l_sp = MgrMgr:GetMgr("TaskMgr").GetTaskMapIconByNpc(l_info.signTip,l_info.taskStatus)
    MapObjMgr:AddObj(MapObjType.TaskNpc,npcId, l_v2)
    MapObjMgr:MdObj(MapObjType.TaskNpc,npcId,l_sp)
    EventDispatcher:Dispatch(EventType.OnTaskNpcStateChanged,npcId)
end
function FreshAllTaskNpcMapObj(sceneId, taskId)
    MapObjMgr:RmObj(MapObjType.TaskNpc)
    local l_table = taskNpcInfo[sceneId]
    if l_table==nil then
        return
    end
    for k, v in pairs(l_table)  do
        AddTaskNpcMapObj(sceneId,k,taskId)
    end
end
function TaskStatusIsMapInfo(status)
    return status==MgrMgr:GetMgr("TaskMgr").ETaskStatus.CanTake or
    status==MgrMgr:GetMgr("TaskMgr").ETaskStatus.Taked or
    status==MgrMgr:GetMgr("TaskMgr").ETaskStatus.CanFinish
end
-----------------------通用方法--------------------------
function SwitchToScene(toSceneId)
    MapDataModel.ShowSceneId=toSceneId
    EventDispatcher:Dispatch(EventType.UpdateMapBg)
end
-----------------------通用方法 end----------------------
return ModuleMgr.MapInfoMgr