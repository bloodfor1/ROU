module("Stage", package.seeall)

require "Stage/StageBase"

local super = Stage.StageBase
StageHall = class("StageHall", super)

function StageHall:ctor()
	super.ctor(self, MStageEnum.Hall)
end

function StageHall:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageHall:OnLeaveStage()
	super.OnLeaveStage(self)
end

function StageHall:ActiveMainPanels()
	super.ActiveMainPanels(self)
	---战场提示
	if MScene.SwitchSceneType == 2 then
		local l_count= MGlobalConfig:GetInt("BgRewardAmountCap")
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("BATTLE_COUNT_FULL"),l_count))
	end
end