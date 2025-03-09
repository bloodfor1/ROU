module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageFreshSelectchar = class("StageFreshSelectchar", super)

function StageFreshSelectchar:ctor()
	super.ctor(self, MStageEnum.FreshSelectchar)
end

function StageFreshSelectchar:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageFreshSelectchar:OnLeaveStage()
	super.OnLeaveStage(self)
end

function StageFreshSelectchar:OnEnterScene(sceneId)
	super.OnEnterScene(self, sceneId)

	MAudioMgr:PlayBGM("CutScene/1-01-Opening");
	if DataMgr:GetData("SelectRoleData").IsSkipFresher() then
		MUICutSceneJumpMgr.jumpCallback=function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben011",DirectorWrapMode.None,function()
				MAudioMgr:PlayBGM("BGM/BGM_OpeningBossBattle");
				MUIBlackWordMgr.bwTableId=1
				MUIBlackWordMgr.endCallback=function (  )
					UIMgr:ActiveUI(UI.CtrlNames.PlaySelecChar)
				end
				UIMgr:ActiveUI(UI.CtrlNames.BlackWord)
			end)
		end
		MCutSceneMgr:PlayImmJump("sc_guochang_001/xinshoufuben002",function()
			MScene:SetActivedScene(1)
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben003",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben003a",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben004",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben005",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben006",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben007",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben009",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben010a",function()
			MCutSceneMgr:PlayImmJump("sc_xinshoufuben_001/xinshoufuben010b",function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben011",DirectorWrapMode.None,function()
				MAudioMgr:PlayBGM("BGM/BGM_OpeningBossBattle");
				MUIBlackWordMgr.bwTableId=1
				MUIBlackWordMgr.endCallback=function (  )
					UIMgr:ActiveUI(UI.CtrlNames.PlaySelecChar)
				end
				UIMgr:ActiveUI(UI.CtrlNames.BlackWord)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
	else
		MCutSceneMgr:PlayImm("sc_guochang_001/xinshoufuben002",DirectorWrapMode.None,function()
			MScene:SetActivedScene(1)
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben003",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben003a",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben004",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben005",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben006",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben007",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben009",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben010a",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben010b",DirectorWrapMode.None,function()
			MCutSceneMgr:PlayImm("sc_xinshoufuben_001/xinshoufuben011",DirectorWrapMode.None,function()
				MAudioMgr:PlayBGM("BGM/BGM_OpeningBossBattle");
				MUIBlackWordMgr.bwTableId=1
				MUIBlackWordMgr.endCallback=function (  )
					UIMgr:ActiveUI(UI.CtrlNames.PlaySelecChar)
				end
				UIMgr:ActiveUI(UI.CtrlNames.BlackWord)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
			end)
	end

	MgrMgr:GetMgr("WeakGuideMgr").OnLogIn()
end