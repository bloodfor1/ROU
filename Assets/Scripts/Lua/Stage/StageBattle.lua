---
--- Created by chauncyhu.
--- DateTime: 2018/6/15 16:09
---

module("Stage", package.seeall)

require "Stage/StageBase"

local super = Stage.StageBase
StageBattle = class("StageBattle", super)

function StageBattle:ctor()
    super.ctor(self, MStageEnum.Battle)
end

function StageBattle:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageBattle:OnLeaveStage()
    super.OnLeaveStage(self)
end

function StageBattle:OnEnterScene(sceneId)
    super.OnEnterScene(self, sceneId)
    --UIMgr:ActiveUI(UI.CtrlNames.Battle)
end