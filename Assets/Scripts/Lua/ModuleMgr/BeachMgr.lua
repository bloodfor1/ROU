---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by richardjiang.
--- DateTime: 2019/1/25 16:52
---

module("ModuleMgr.BeachMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

g_horizontalMax = 0
g_verticalMax = 0
g_beachCameraDelta = Vector3.zero
g_beachStartRotateY = 0
g_beachRotateSpeedX = 1
g_beachRotateSpeedY = 1
g_beachFov = 60
g_dis = 5
g_beach = false
g_blood = 3.5
g_maxBlood = 6
g_lastCameraState = MoonClient.MCameraState.Normal
g_combineSkills = {}

BEACH_START_AIM = "BEACH_START_AIM"
BEACH_END_AIM = "BEACH_END_AIM"
TRY_SET_CASTING_OFFSET = "TRY_SET_CASTING_OFFSET"

function OnInit()
    local beachCameraArgs = MGlobalConfig:GetSequenceOrVectorFloat("QTDLCameraCtrl")
    local beachCameraRotArgs = MGlobalConfig:GetSequenceOrVectorFloat("QTDLCameraRotMax")
    local beachCombineSkills = MGlobalConfig:GetSequenceOrVectorInt("QTDLShootSkill")
    local beachCameraRotX = MGlobalConfig:GetFloat("QTDLCameraCtrlX")
    if beachCameraArgs.Length < 3 then
        logError("抢滩登录global参数格式错误 Global.QTDLCameraCtrl @陈倪")
        return
    end
    if beachCameraRotArgs.Length < 2 then
        logError("抢滩登录global参数格式错误 Global.QTDLCameraRotMax @陈倪")
        return
    end
    if beachCombineSkills.Length < 2 then
        logError("抢滩登录global参数格式错误 Global.QTDLShootSkill @陈倪")
        return
    end

    g_horizontalMax = beachCameraRotArgs[0]
    g_verticalMax = beachCameraRotArgs[1]
    g_beachCameraDelta = Vector3(beachCameraRotX, beachCameraArgs[0], beachCameraArgs[1])
    g_beachFov = beachCameraArgs[2]
    g_maxBlood = MGlobalConfig:GetInt("QTDLMaxBlood")
    g_blood = g_maxBlood
    g_combineSkills[beachCombineSkills[0]] = beachCombineSkills[1]
    g_beachStartRotateX = MGlobalConfig:GetFloat("QTDLStartRotateY")
    g_beachRotateSpeedX = MGlobalConfig:GetFloat("QTDLRotateSpeedX")
    g_beachRotateSpeedY = MGlobalConfig:GetFloat("QTDLRotateSpeedY")
end

function StartBeach()
    g_beach = true
    if MEntityMgr.PlayerEntity then
        MEntityMgr.PlayerEntity.IsMovable = false
        MEntityMgr.PlayerEntity.IsFake = true
        MEntityMgr.PlayerEntity.InShoot = true
    end
    g_lastCameraState = MScene.GameCamera.CameraState
    UIMgr:ActiveUI(UI.CtrlNames.BeachLanding)
end

function EndBeach()
    g_beach = false
    if MEntityMgr.PlayerEntity then
        MEntityMgr.PlayerEntity.IsMovable = true
        MEntityMgr.PlayerEntity.IsFake = false
        MEntityMgr.PlayerEntity.InShoot = false
    end
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamChangeState, MScene.GameCamera, g_lastCameraState)
end

function IsBeach()
    return g_beach
end

function OnTryFixCastingOffset(_, skillId)
    if not IsBeach() or not g_combineSkills[skillId] then return end
    EventDispatcher:Dispatch(TRY_SET_CASTING_OFFSET, skillId)
end

function OnLongClickSkillSlot(skillId)
    if not IsBeach() then return end
    EventDispatcher:Dispatch(BEACH_START_AIM)
end

function OnUpSkillSlot(skillId)
    if not IsBeach() or not g_combineSkills[skillId] then return end
    EventDispatcher:Dispatch(BEACH_END_AIM)
end

function OnLogout()
    EndBeach()
end

return ModuleMgr.BeachMgr

