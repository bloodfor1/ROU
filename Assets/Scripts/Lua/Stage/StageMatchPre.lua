---
--- Created by dingshanchen.
--- DateTime: 2019/11/6 10:05
---

module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageMatchPre = class("StageMatchPre", super)

function StageMatchPre:ctor()
    super.ctor(self, MStageEnum.MatchPre)
end

function StageMatchPre:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageMatchPre:ActiveMainPanels()
    super.ActiveMainPanels(self)
    UIMgr:ActiveUI(UI.CtrlNames.MainGuildMatch, DataMgr:GetData("GuildMatchData").EUIOpenType.PRE_TIME)
end

function StageMatchPre:OnLeaveStage()
    super.OnLeaveStage(self)
end