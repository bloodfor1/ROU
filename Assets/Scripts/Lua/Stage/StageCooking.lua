---
--- Created by nealzhang.
--- DateTime: 2018/3/7 14:26
---

module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageCooking = class("StageCooking", super)

function StageCooking:ctor()
    super.ctor(self, MStageEnum.Cooking)
end

function StageCooking:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageCooking:OnLeaveStage()
    super.OnLeaveStage(self)
end