
module("ModuleMgr.SceneObjControllerMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
GatherItemChangeEvent="GatherItemChangeEvent"
SetProgressTimeEvent="SetProgressTimeEvent"
ControleSceneUIActiveStateEvent = "ControleSceneUIActiveStateEvent"
function OnGatherItemChangeEvent()
    EventDispatcher:Dispatch(GatherItemChangeEvent)
end
---@param sceneObjInfo MoonClient.MSceneObjInfo
function OnSetProgressTimeEvent(sceneObjInfo)
    if MLuaCommonHelper.IsNull(sceneObjInfo) then
        logError("OnSetProgressTimeEvent sceneObjInfo==null!")
        return
    end

    EventDispatcher:Dispatch(SetProgressTimeEvent,sceneObjInfo)
end
function OnActiveUIEvent(info)
    MSceneObjControllerCSharpMgr.IsPlaying=true
    if not UIMgr:IsActiveUI(UI.CtrlNames.SceneObjController) then
        UIMgr:ActiveUI(UI.CtrlNames.SceneObjController,info)
    else
        EventDispatcher:Dispatch(ControleSceneUIActiveStateEvent,true,info)
    end
end

function OnDeActiveUIEvent(info)
    EventDispatcher:Dispatch(ControleSceneUIActiveStateEvent,false,info)
end


return ModuleMgr.SceneObjControllerMgr