module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageLogin = class("StageLogin", super)
local l_firstIn = true
local l_sceneEnterData = DataMgr:GetData("SceneEnterData")

local PLAYTYPE = {
    ALLWAYS = 1,
    ALLWAYSNot = 2,
    FIRSTIN = 3,
}

function StageLogin:ctor()
	super.ctor(self, MStageEnum.Login)
end

function StageLogin:OnEnterStage(toSceneId, fromStage)
	--UIMgr:DeActiveAll({UI.CtrlNames.Loading, UI.CtrlNames.Dialog, UI.CtrlNames.Login})
	super.OnEnterStage(self, toSceneId, fromStage)
    MStatistics.DoStatistics(CJson.encode({
        tag = MLuaCommonHelper.Enum2Int(TagPoint.EnterLogin),
        status = true,
        msg = "",
        authorize = false,
        finish = false
    }))
end

function StageLogin:OnLeaveStage()
	super.OnLeaveStage(self)
    --UIMgr:DeActiveAll({UI.CtrlNames.Loading, UI.CtrlNames.Dialog})
end

function StageLogin:OnEnterScene(sceneId)

    super.OnEnterScene(self, sceneId)
    local CGFlag = MGlobalConfig:GetInt("CGTypes")
    if CGFlag == PLAYTYPE.FIRSTIN then
        if PlayerPrefs.GetString("IS_FIRST_LOGIN", "1") == "1" and MGameContext.IsPublish then
            UIMgr:ActiveUI(UI.CtrlNames.FullScreenCG)
            -- 上报adjust首次开启日志
            MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.FirstAppOpen)
        end
    elseif CGFlag == PLAYTYPE.ALLWAYS then
        if  MGameContext.IsPublish then
            UIMgr:ActiveUI(UI.CtrlNames.FullScreenCG)
        end
    elseif CGFlag == PLAYTYPE.ALLWAYSNot then
        --todo 后续需求
    end

    PlayerPrefs.SetString("IS_FIRST_LOGIN", "Not_First")

    MoonClient.MSceneObjectEvent.SendEvent(2)
end

function StageLogin:InitMainPanel(sceneId)
    super.InitMainPanel(self, sceneId)
    l_sceneEnterData.InsertDataToEnterScenePanels(UI.CtrlNames.Login)
    self:AddKeepActiveUI(UI.CtrlNames.FullScreenCG)
end

function StageLogin:ActiveMainPanels()
	self:AddKeepActiveUI(UI.CtrlNames.Login)
    self:AddKeepActiveUI(UI.CtrlNames.Waiting)
    self:AddKeepActiveUI(UI.CtrlNames.BindAccount)
	super.ActiveMainPanels(self)
end

return StageLogin