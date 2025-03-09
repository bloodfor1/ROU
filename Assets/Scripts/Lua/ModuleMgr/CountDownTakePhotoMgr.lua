require "Common/ActionQueue"

module("ModuleMgr.CountDownTakePhotoMgr", package.seeall)

local l_actionQueue = Common.ActionQueue.new()
local l_timer = nil
local l_openUI = false
local l_cameraObj = nil
local l_outOfView = true
local l_lastOutOfView = l_outOfView
local l_moveStopTimer = nil
local l_fxTakePhotoRange = nil
local l_takingCountDownPhoto = false
local l_triggerRunResultTask = nil

local l_countDownTakePhotoTaskId = 138438

function BeginCountTakePhoto(openUI, cameraObj, autoSave, face, triggerRunResultTask, moveTime)

    if l_takingCountDownPhoto then
        return
    end

    if l_triggerRunResultTask then
        l_triggerRunResultTask:OnTriggerCancel()
    end
    l_triggerRunResultTask = triggerRunResultTask

    l_takingCountDownPhoto = true

    l_outOfView = true
    l_lastOutOfView = l_outOfView
    l_openUI = openUI
    l_cameraObj = cameraObj

    if l_actionQueue ~= nil then
        l_actionQueue:Clear()
    end

    if openUI then
        local l_photoData = {
            openType = DataMgr:GetData("FashionData").EUIOpenType.COUNTDOWN_CAMERA,
            cameraObj = cameraObj,
            judge = false,
            autoSave = autoSave
        }
        UIMgr:ActiveUI(UI.CtrlNames.Photograph, {[UI.CtrlNames.Photograph] = l_photoData})
    else
        local fxData = MFxMgr:GetDataFromPool()
        fxData.position = cameraObj.Position
        fxData.rotation = Quaternion.Euler(0.0, face * 1.0, 0.0)
        l_fxTakePhotoRange = MFxMgr:CreateFx("Effects/Prefabs/Creature/Common/Fx_Common_ZiDongPaiZhao_01", fxData)
        MFxMgr:ReturnDataToPool(fxData)
    end

    MgrMgr:GetMgr("TaskMgr").TaskSceneObjectStart(nil,{Id = l_countDownTakePhotoTaskId} )

    l_actionQueue:AddAciton(function(cb)
        CountDown(function()
            if l_timer ~= nil then
                l_timer:Stop()
                l_timer = nil
            end
            cb()
        end, openUI, moveTime)
        if l_timer ~= nil then
            l_timer:Stop()
            l_timer = nil
        end
        l_timer = Timer.New(function()
            l_lastOutOfView = l_outOfView
            l_outOfView = CheckOutOfView()
            if l_outOfView and l_lastOutOfView ~= l_outOfView then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COUNT_DOWN_TAKE_PHOTO_OUT_OF_VIEW"))
            end
        end, 0.5,-1)
        l_timer:Start()
    end, function()
        if l_timer ~= nil then
            l_timer:Stop()
            l_timer = nil
        end
        UIMgr:DeActiveUI(UI.CtrlNames.BigCountDown)
    end)

    if not openUI then
        l_actionQueue:AddAciton(function(cb)
            local l_photoData = {
                openType = DataMgr:GetData("FashionData").EUIOpenType.COUNTDOWN_CAMERA,
                cameraObj = cameraObj,
                judge = true,
                autoSave = autoSave
            }
            UIMgr:ActiveUI(UI.CtrlNames.Photograph, {[UI.CtrlNames.Photograph] = l_photoData})
            if cb ~= nil then
                cb()
            end
        end)
    else
        l_actionQueue:AddAciton(function(cb)
            TakePhoto(openUI, cb)
            if cb ~= nil then
                cb()
            end
        end)
    end

    l_actionQueue:AddAciton(function(cb)
        if l_fxTakePhotoRange ~= nil then
            MFxMgr:DestroyFx(l_fxTakePhotoRange)
            l_fxTakePhotoRange = nil
        end
        l_takingCountDownPhoto = false
        if cb ~= nil then
            cb()
        end
        if l_triggerRunResultTask then
            l_triggerRunResultTask:OnTriggerFinished()
            l_triggerRunResultTask = nil
        end
    end)

end

function CountDown(callback, isOpenUI, moveTime)
    StopTimer()
    if isOpenUI then
        local l_moveTime = tonumber(TableUtil.GetGlobalTable().GetRowByName("AutoTakePhotoMoveTime").Value)
        if l_moveTime > 0 then
            l_moveTime = moveTime
        end
        --先走到目标位置 然后转身
        MTransferMgr:GotoPosition(MScene.SceneID, Vector3.New(170.2, 11.9, 158.3),function (arg1, arg2, arg3)
            MVirtualTab:MoveByDir(Vector3.New(0, 0, -1))
            l_moveStopTimer = Timer.New(function()
                MEventMgr:LuaFireEvent(MEventType.MEvent_StopMove, MEntityMgr.PlayerEntity)
                StopTimer()
            end,0.1)
            l_moveStopTimer:Start()
        end)
    end
    local l_openData = {
        time = MGlobalConfig:GetInt("CountDownTakePhotoTime"),
        callback = callback
    }
    UIMgr:ActiveUI(UI.CtrlNames.BigCountDown, l_openData)

end

function TakePhoto(openUI, callback)
    local l_ui = UIMgr:GetUI(UI.CtrlNames.Photograph)
    if l_ui then
        l_ui:OnTakePhoto(function ()
            if callback ~= nil then
                callback()
            end
        end)
    end
end

function StopCountDownTakePhoto()
    if l_triggerRunResultTask then
        l_triggerRunResultTask:OnTriggerCancel()
        l_triggerRunResultTask = nil
    end
    MgrMgr:GetMgr("TaskMgr").TaskSceneObjectStop(nil, {Id = l_countDownTakePhotoTaskId})
    l_takingCountDownPhoto = false
    UIMgr:DeActiveUI(UI.CtrlNames.Photograph)
    UIMgr:DeActiveUI(UI.CtrlNames.BigCountDown)
    l_actionQueue:Clear()
    if l_timer ~= nil then
        l_timer:Stop()
        l_timer = nil
    end
   StopTimer()
    l_cameraObj = nil
    l_openUI = false
    l_outOfView = true
    if l_fxTakePhotoRange ~= nil then
        MFxMgr:DestroyFx(l_fxTakePhotoRange)
        l_fxTakePhotoRange = nil
    end
end

function OnEnterScene(sceneId)
    StopCountDownTakePhoto()
end

function CheckOutOfView()

    local l_cameraObjPos = l_cameraObj.Position
    local l_playerPos = MEntityMgr.PlayerEntity.Position

    local l_objForward = l_cameraObj.Rotation * Vector3.forward
    local l_toPlayerDir = Vector3.New(l_playerPos.x - l_cameraObjPos.x, 0, l_playerPos.z - l_cameraObjPos.z)
    local l_angle = Vector3.Angle(l_objForward, l_toPlayerDir)
    local l_currentOutOfView = false

    l_currentOutOfView = l_angle > 23

    return l_currentOutOfView
end

function  StopCountDownTakePhotoByTrigger(triggerRunResultTask)
    if(l_triggerRunResultTask == triggerRunResultTask) then
        l_triggerRunResultTask = nil
        StopCountDownTakePhoto()
    end
end

function StopTimer()
    if l_moveStopTimer ~= nil then
        l_moveStopTimer:Stop()
        l_moveStopTimer = nil
    end
end