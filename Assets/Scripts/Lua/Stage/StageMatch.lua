---
--- Created by dingshanchen.
--- DateTime: 2019/11/6 10:06
---

module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageMatch = class("StageMatch", super)

function StageMatch:ctor()
    super.ctor(self, MStageEnum.Match)
end

function StageMatch:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
    --MgrMgr:GetMgr("BattleMgr").m_groupNum = {}
end

function StageMatch:OnLeaveStage()
    super.OnLeaveStage(self)
    MgrMgr:GetMgr("GuildMatchMgr").LeaveFight()
end

function StageMatch:OnEnterScene(sceneId)
    super.OnEnterScene(self, sceneId)
    UIMgr:ActiveUI(UI.CtrlNames.MainGuildMatch, DataMgr:GetData("GuildMatchData").EUIOpenType.MATCH_TIME)
end