---
--- Created by chauncyhu.
--- DateTime: 2018/6/15 16:09
---

module("Stage", package.seeall)

require "Stage/StageBase"

local super = Stage.StageBase
StageBattlePre = class("StageBattlePre", super)

function StageBattlePre:ctor()
    super.ctor(self, MStageEnum.BattlePre)
end

function StageBattlePre:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageBattlePre:ActiveMainPanels()
    super.ActiveMainPanels(self)
    UIMgr:ActiveUI(UI.CtrlNames.Battle)
end

function StageBattlePre:OnLeaveStage()
    super.OnLeaveStage(self)
end