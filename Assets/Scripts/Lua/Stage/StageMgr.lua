module("Stage", package.seeall)

require "Stage/StageBase"
require "Stage/StageLogin"
require "Stage/StageSelectChar"
require "Stage/StageHall"
require "Stage/StageWild"
require "Stage/StageDungeon"
require "Stage/StageArenaPre"
require "Stage/StageArena"
require "Stage/StageRingPre"
require "Stage/StageRing"
require "Stage/StageCooking"
require "Stage/StageBattlePre"
require "Stage/StageBattle"
require "Stage/StageMatchPre"
require "Stage/StageMatch"

---@class Stage.StageMgr
StageMgr = class("StageMgr")

function StageMgr:ctor()
	self.stages = {}
	self.stages[MStageEnum.Null] = StageBase.new(MStageEnum.Null)
	self.stages[MStageEnum.Login] = StageLogin.new()
	self.stages[MStageEnum.SelectChar] = StageSelectChar.new()
	self.stages[MStageEnum.Hall] = StageHall.new()
	self.stages[MStageEnum.Wild] = StageWild.new()
	self.stages[MStageEnum.Dungeon] = StageDungeon.new()
	self.stages[MStageEnum.ArenaPre] = StageArenaPre.new()
	self.stages[MStageEnum.Arena] = StageArena.new()
	self.stages[MStageEnum.RingPre] = StageRingPre.new()
	self.stages[MStageEnum.Ring] = StageRing.new()
	self.stages[MStageEnum.Cooking] = StageCooking.new()
	self.stages[MStageEnum.FreshSelectchar] = StageBase.new(MStageEnum.Null) -- 这个状态干掉不用了
	self.stages[MStageEnum.BattlePre] = StageBattlePre.new()
	self.stages[MStageEnum.Battle] = StageBattle.new()
	self.stages[MStageEnum.MatchPre] = StageMatchPre.new()
	self.stages[MStageEnum.Match] = StageMatch.new()
	self.current = MStageEnum.Null
end

function StageMgr:CurStage()
	return self.stages[self.current]
end

function StageMgr:GetCurStageEnum()
	return self.current
end

function StageMgr:OnLeaveScene(sceneId)
	self:CurStage():OnLeaveScene(sceneId)
end

function StageMgr:OnLeaveStage(stage)
	self.stages[stage]:OnLeaveStage()
end

function StageMgr:OnEnterStage(stage, toSceneId)
	self.stages[stage]:OnEnterStage(toSceneId, self.current)
	self.current = stage
end

function StageMgr:OnSceneLoaded(sceneId)
	self:CurStage():OnSceneLoaded(sceneId)
end

function StageMgr:OnLuaDoEnterScene(msg)
	self:CurStage():OnLuaDoEnterScene(msg)
end

function StageMgr:OnEnterScene(sceneId)
	self:CurStage():OnEnterScene(sceneId)
end

function StageMgr:IsStage(stageEnum)
	return self.current == stageEnum
end
