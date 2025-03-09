module("ModuleMgr.BlessMgr", package.seeall)


function OnInit()
    Data.PlayerInfoModel.BASELV:Add(Data.onDataChange, function()
        CheckBlessTutorial()
    end, ModuleMgr.BlessMgr)
end

function OnUninit()
    Data.PlayerInfoModel.BASELV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.BlessMgr)
end

function OnEnterScene(sceneId)
    CheckBlessTutorial()
end

-- 新手引导
function CheckBlessTutorial()
    --if Common.CommonUIFunc.IsInHallScene(MScene.SceneID) and MPlayerInfo.Lv >= MGlobalConfig:GetInt("PrayExpLimitLevel") then
    if MPlayerInfo.Lv >= MGlobalConfig:GetInt("PrayExpLimitLevel") then
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({"DailyExpGuide"}, UI.CtrlNames.RoleNurturance_TipsBtn)
    end
end

return ModuleMgr.BlessMgr