
module("CommandConst", package.seeall)

-- Lua command 没有本地化需求
CommandList = {
    openui = "OpenUICommand",
    showtip = "ShowTipCommand",
    addcancelselect = "AddCancelTalkCommand",
    addfunc = "AddOpenFuncCommand",
    addtaskbtn = "AddTaskBtnCommand",
    scenariosetpos = "ScenarioSetPosCommand",
    scenariochat = "ScenarioChatCommand",
    scenarioemoji = "ScenarioEmojiCommand",
    scenariofontsize = "ScenarioSetFontSizeCommand",
    showaction = "ShowActionCommand",
    posfx = "PosFxCommand",
    rolefx = "RoleFxCommand",
    focus2npc = "FocusToNpcCommand",
    focus2player = "FocusToPlayerCommand",
    focus2pos = "FocusToPosCommand",
    resetcam = "ResetCameraCommand",
    gotonpc = "GotoNpcCommand",
    gotopos = "GotoPosCommand",
    openfunc = "OpenFuncCommand",
    playsound = "PlaySoundCommand",
    hidemodelalarm = "HideModelAlarmCommand",
    netaievent = "NetAIEventCommand",
    netentityaievent = "NetEntityAIEventCommand",
    netevent = "NetEventCommand",

    camerastate = "CameraStateCommand",
    cameratarget = "CameraTargetCommand",
    cameraspeed = "CameraSetTriggerSlowSpeedCommand",
    cameratonormal = "CameraToNormalCommand",
    trystoptalk = "TryStopTalkCommand",

    addlocalnpc = "AddLocalNpcCommand",
    rmlocalnpc = "RemoveLocalNpcCommand",

    addflagvar = "AddFlagValCommand",
    setinterstate = "SetInterStateCommand",

    playcv = "PlayCVCommand",
    stopcv = "StopCVCommand",
    randomcv = "RandomCVCommand",

    blackcurtain = "PlayBlackCurtainCommand",
    playtheater = "PlayTheaterCommand",
    cutscene = "PlayCutSceneCommand",
    backtrack = "BackTrackingCommand",
}

local l_commandInstance = {}

function GetCommandInstance(codeId)

    local l_commandName = CommandList[codeId]
    if not l_commandName then
		logError("cannot find codeId, id="..tostring(codeId))
		return
    end
    
    local l_instance = l_commandInstance[l_commandName]
    if l_instance then
        return l_instance
    end

    local l_modulePath = "Command/" .. l_commandName
    require(l_modulePath)

    l_instance = Command[l_commandName].new()
    l_commandInstance[l_commandName] = l_instance
    
    return l_instance
end

function CallHandleCommand(_, codeId, command, block, args)
    
    local l_instance = GetCommandInstance(codeId)
    if l_instance then
        l_instance:HandleCommand(command, block, args)
    end
end

function CallFinishCommand(_, codeId, command, block, args)
	
    local l_instance = GetCommandInstance(codeId)
    if l_instance then
        l_instance:FinishCommand(command, block, args)
    end
end

function CallUninitCommand(_, codeId, command, block, args)

    local l_instance = GetCommandInstance(codeId)
    if l_instance then
        l_instance:UninitCommand(command, block, args)
    end
end

function GetCodeIdList()
    local l_res = {}
    for k, v in pairs(CommandList) do
        table.insert(l_res, k)
    end
    return l_res
end

--codeId string
-- argStrArray string[]
function CheckCommandArg(codeId, argStrArray)
    
    local l_instance = GetCommandInstance(codeId)
    if l_instance then
        return l_instance:CheckCommand(argStrArray)
    end

    return true
end