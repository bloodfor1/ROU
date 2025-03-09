---
--- Created by richardjiang.
--- DateTime: 2017/12/16 14:26
---

module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageRing = class("StageRing", super)

function StageRing:ctor()
    super.ctor(self, MStageEnum.Ring)
end

function StageRing:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageRing:OnLeaveStage()
    super.OnLeaveStage(self)
    MgrMgr:GetMgr("ArenaMgr").LeaveFight()
end

function StageRing:OnEnterScene(sceneId)

    super.OnEnterScene(self, sceneId)
    if not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        MgrMgr:GetMgr("ArenaMgr").EnterFight()
    end

end

function StageRing:ActiveMainPanels()

    super.ActiveMainPanels(self)
    if not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        MgrMgr:GetMgr("ArenaMgr").EnterFightUI()
    end

end