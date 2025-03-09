---
--- Created by husheng.
--- DateTime: 2017/12/16 14:25
---

module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageArenaPre = class("StageArenaPre", super)

function StageArenaPre:ctor()
    super.ctor(self, MStageEnum.ArenaPre)
end

function StageArenaPre:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
    MgrMgr:GetMgr("BattleMgr").m_groupNum = {}
end

function StageArenaPre:OnLeaveStage()
    super.OnLeaveStage(self)
    UIMgr:DeActiveUI(UI.CtrlNames.MainArena)
end