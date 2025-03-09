---@module ModuleMgr.CrashReportMgr
module("ModuleMgr.CrashReportMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
CrashReportIsOn = MDevice.EnableSDKInterface("BuglyCrashReport") or MDevice.EnableSDKInterface("FirebaseCrashReport")

------------------------------生命周期------------------------------
function OnInit()
    if MGameContext.IsAndroid then
        MCrashReport.BuglySetCrashFilter(CJson.encode({str = "java.lang.UnsatisfiedLinkError"}))
        MCrashReport.BuglySetCrashRegularFilter(CJson.encode({str = ".*java.lang.UnsatisfiedLinkError.*"}))
    end
    GlobalEventBus:Add(EventConst.Names.QualityLevelChange, QualityLevelChange)
end

function Uninit()
    GlobalEventBus:Remove(EventConst.Names.QualityLevelChange, QualityLevelChange)
end

function QualityLevelChange()
    local l_type = tostring(MQualityGradeSetting.GetCurGradeType())
    AddSceneData("qualityType", l_type)
end

function OnLeaveScene(sceneId)
    AddSceneData("isSwitchingScene", "true")
end

function OnEnterScene(sceneId)
    AddSceneData("isSwitchingScene", "false")
    SetScene(tonumber(sceneId))
    AddSceneData("sceneId", sceneId)
end

function SetUserId(userid)
    if CrashReportIsOn then
        MCrashReport.SetUserId(CJson.encode({userid = userid}))
    end
end

function SetScene(sceneId)
    if CrashReportIsOn then
        MCrashReport.SetScene(CJson.encode({sceneid = tonumber(sceneId)}))
    end
end

function SetAppVersion(version, hotfix_version)
    if CrashReportIsOn then
        MCrashReport.SetAppVersion(CJson.encode({version = version, hotfix_version = hotfix_version}))
    end
end

function SetPlayerInfo()
    local key = ""
    local value = ""
    if MPlayerInfo.UID then
        key = key .. "uid|"
        value = value .. tostring(MPlayerInfo.UID) .. "|"
    end
    if MPlayerInfo.ProID then
        key = key .. "proid|"
        value = value .. tostring(MPlayerInfo.ProID) .. "|"
    end
    if MPlayerInfo.Lv then
        key = key .. "lv|"
        value = value .. tostring(MPlayerInfo.Lv) .. "|"
    end
    if MPlayerInfo.JobLv then
        key = key .. "joblv"
        value = value .. tostring(MPlayerInfo.JobLv)
    end
    AddSceneData(key, value)
end

function AddSceneData(key, value)
    if string.ro_isEmpty(key) or string.ro_isEmpty(value) then
        return
    end
    if CrashReportIsOn then
        MCrashReport.AddSceneData(CJson.encode({key = tostring(key), value = tostring(value)}))
    end
end

return ModuleMgr.CrashReportMgr