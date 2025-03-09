require "SmallGames/SGameDefine"
module("ModuleMgr.SmallGameMgr", package.seeall)

OperaSmallGameObjectEvent="OperaObjectEvent"
ActiveObjectEvent="ActiveObjectEvent"

EventDispatcher = EventDispatcher.new()

--小游戏结束事件
NOTIFY_GAME_RESULT = "NOTIFY_GAME_RESULT"

local l_touchCtrl=nil
local l_handlerCtrl=nil
local l_procedureCtrl=nil
local l_qteCtrl=nil
local l_currentGameName
local l_lastQteResident=false
local l_qteResident=false--qte常驻模式
local l_gameID=0

function ShowSmallGameByID(gameID)

    local smallGameInfo= TableUtil.GetSmallGameTable().GetRow(gameID)
    if smallGameInfo==nil then
        logError("SmallGameMgr.ShowSmallGameByID error,not exsit gameID:"..tostring(gameID))
        return
    end
    
    l_lastQteResident=l_qteResident
    l_qteResident=true
    l_gameID=gameID

    local l_ctrlNames=smallGameInfo.Panel
    local l_procedureData=smallGameInfo.ProcedureData
    local l_gameParam=smallGameInfo.GameParam

    l_currentGameName=l_ctrlNames
    UIMgr:ActiveUI(l_ctrlNames,function(ctrl)
        LoadQTE()
        local l_procedureCtrl=GetProcedureCtrl()
        l_procedureCtrl:BuildGameProcedure(l_procedureData,ctrl)
        ctrl:ParseGameInfo(l_gameParam)
    end)

end
function PlayUIEffect(effectName)
    l_procedureCtrl.sGameCtrl:NoticeShowEffect(effectName,true)
end

function NotifySmallGameResult(data)
    if data.win then
        logYellow(l_currentGameName.."执行成功！")
    else
        logYellow(l_currentGameName.."执行失败！")
    end
    local l_resultData=
    {
        win=data.win,
        gameID=l_gameID
    }
    EventDispatcher:Dispatch(NOTIFY_GAME_RESULT,l_resultData)
    CloseSmallGame(l_currentGameName)
end
function CloseCurrentSmallGame()
    CloseSmallGame(l_currentGameName)
end
function CloseSmallGame(gameName)
    if l_currentGameName~=gameName then
        return
    end
    UIMgr:DeActiveUI(gameName)
    l_qteResident=l_lastQteResident
    local l_procedureCtrl=GetProcedureCtrl()
    l_procedureCtrl:Clear()
    CloseQTE()
end
function OnReceiveShakeData(luaType,shakeDegree)
    if l_qteCtrl==nil then
        return
    end
    l_qteCtrl:NotifyShake(shakeDegree)
end
function ShowQTE(qteType,argData,qteCallBack)

    --logGreen("ShowQTE")

    if l_qteCtrl==nil or not l_qteCtrl.isActive then
        UIMgr:ActiveUI(UI.CtrlNames.QTE,function(ctrl)
            l_qteCtrl=ctrl
            ctrl:ExecuteQTE(qteType,argData,qteCallBack)
        end,{IsNeedHideOnActive=true})
    else
        if not l_qteCtrl.isShowing then
            UIMgr:ShowUI(UI.CtrlNames.QTE)
        end
        l_qteCtrl:ExecuteQTE(qteType,argData,qteCallBack)
    end
end
function LoadQTE()

    --logGreen("LoadQTE()")

    UIMgr:ActiveUI(UI.CtrlNames.QTE,function(ctrl)
        l_qteCtrl=ctrl
        --UIMgr:HideUI(UI.CtrlNames.QTE)
    end,{IsNeedHideOnActive=true})
end
function CloseQTE()
    if l_qteResident then
        UIMgr:HideUI(UI.CtrlNames.QTE)
        return
    end
    UIMgr:DeActiveUI(UI.CtrlNames.QTE)
end
function OnLeaveSmallGame()
    local l_procedureCtrl=GetProcedureCtrl()
    l_procedureCtrl:Clear()
end
function ExecuteTouch(touchData,operaResultData)
    local l_touchCtrl=GetTouchCtrl()
    l_touchCtrl:HandleTouch(touchData,operaResultData)
end
function ExecuteHandler(handlerArg,resultData)
    local l_handlerCtrl=GetHandlerCtrl()
    l_handlerCtrl:ExecuteHandler(handlerArg,resultData)
end
function DeliverEvent(event,eventType)
    if l_qteCtrl==nil then
        return
    end
    l_qteCtrl:EventDeliver(event,eventType)
end
function ExecuteOneStep(objectName)
    if l_qteCtrl==nil then
        return
    end
    local l_procedureCtrl=GetProcedureCtrl()
    l_procedureCtrl:ExecuteOneStep(objectName)
end
function Init()
    EventDispatcher:Add(OperaSmallGameObjectEvent,OnReceiveOperaGameObjectEvent)
    if l_procedureCtrl==nil then
        require("SmallGames/SGameProcedureCtrl")
        l_procedureCtrl=SGame.SGameProcedureCtrl.new()
    end


end
function OnReceiveOperaGameObjectEvent(self,data)
    local l_procedureCtrl=GetProcedureCtrl()
    l_procedureCtrl:OperateObject(data)
end
function GetProcedureCtrl()
    if l_procedureCtrl==nil then
        require("SmallGames/SGameProcedureCtrl")
        l_procedureCtrl=SGame.SGameProcedureCtrl.new()
    end
    return l_procedureCtrl
end
function GetTouchCtrl()
    if l_touchCtrl==nil then
        require("SmallGames/SGameTouchCtrl")
        l_touchCtrl=SGame.SGameTouchCtrl.new()
    end
    return l_touchCtrl
end
function GetHandlerCtrl()
    if l_handlerCtrl==nil then
        require("SmallGames/SGameHandlerCtrl")
        l_handlerCtrl=SGame.SGameHandlerCtrl.new()
    end
    return l_handlerCtrl
end
function ParseTouchData(touchInfoStr)
    local l_touchCtrl=GetTouchCtrl()
    return l_touchCtrl:ParseTouchArg(touchInfoStr)
end
function ParseHandlerData(handlerInfoStr)
    local l_handlerCtrl=GetHandlerCtrl()
    return l_handlerCtrl:ParseHandlerArg(handlerInfoStr)
end
return ModuleMgr.SmallGameMgr


