---
--- Created by husheng.
--- DateTime: 2017/12/16 14:26
---

module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageArena = class("StageArena", super)

function StageArena:ctor()
    super.ctor(self, MStageEnum.Arena)
end

function StageArena:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageArena:OnLeaveStage()
    super.OnLeaveStage(self)
end

function StageArena:OnEnterScene(sceneId)
    super.OnEnterScene(self, sceneId)
    UIMgr:ActiveUI(UI.CtrlNames.TeamFrame)
    UIMgr:ActiveUI(UI.CtrlNames.MainArena)
end