module("Stage", package.seeall)

require "Stage/StageBase"

local super = Stage.StageBase
StageWild = class("StageWild", super)

function StageWild:ctor()
	super.ctor(self, MStageEnum.Wild)
end

function StageWild:OnEnterStage(toSceneId, fromStage)
	super.OnEnterStage(self, toSceneId, fromStage)
end

function StageWild:OnLeaveStage()
	super.OnLeaveStage(self)
end