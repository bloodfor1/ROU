--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InfinityTowerResultPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
InfinityTowerResultCtrl = class("InfinityTowerResultCtrl", super)

local l_mgr = MgrMgr:GetMgr("InfiniteTowerDungeonMgr")

--lua class define end

--lua functions
function InfinityTowerResultCtrl:ctor()

	super.ctor(self, CtrlNames.InfinityTowerResult, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function InfinityTowerResultCtrl:Init()

	self.panel = UI.InfinityTowerResultPanel.Bind(self)
	super.Init(self)

	self.autoCloseTimer = nil
end --func end
--next--
function InfinityTowerResultCtrl:Uninit()

	if self.autoCloseTimer then
		self:StopUITimer(self.autoCloseTimer)
	end

	self.autoCloseTimer = nil

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function InfinityTowerResultCtrl:OnActive()

	if self.autoCloseTimer then
		self:StopUITimer(self.autoCloseTimer)
	end

	self:SetShowType()

	self.autoCloseTimer = self:NewUITimer(function ()
		UIMgr:DeActiveUI(self.name)
    end, 3, -1)
    self.autoCloseTimer:Start()
end --func end
--next--
function InfinityTowerResultCtrl:OnDeActive()

end --func end
--next--
function InfinityTowerResultCtrl:Update()


end --func end

--next--
function InfinityTowerResultCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function InfinityTowerResultCtrl:SetShowType()

	local name = self.uiPanelData.opType
	local data = self.uiPanelData.data
	if name == l_mgr.G_RESULT_OP_TYPE.StageFailed then
		self.panel.StageFailed.gameObject:SetActiveEx(true)
		self.panel.StageFinish.gameObject:SetActiveEx(false)
		self.panel.StageStart.gameObject:SetActiveEx(false)
		self.panel.StageJumpTo.gameObject:SetActiveEx(false)
		MLuaClientHelper.PlayFxHelper(self.panel.StageFailed.gameObject)
	elseif name == l_mgr.G_RESULT_OP_TYPE.StageFinish then
		self.panel.StageFailed.gameObject:SetActiveEx(false)
		self.panel.StageFinish.gameObject:SetActiveEx(true)
		self.panel.StageStart.gameObject:SetActiveEx(false)
		self.panel.StageJumpTo.gameObject:SetActiveEx(false)
		MLuaClientHelper.PlayFxHelper(self.panel.StageFinish.gameObject)
	elseif name == l_mgr.G_RESULT_OP_TYPE.StageStart then
		self.panel.StageFailed.gameObject:SetActiveEx(false)
		self.panel.StageFinish.gameObject:SetActiveEx(false)
		self.panel.StageStart.gameObject:SetActiveEx(true)
		self.panel.StageJumpTo.gameObject:SetActiveEx(false)
		MLuaClientHelper.PlayFxHelper(self.panel.StageStart.gameObject)
	elseif name == l_mgr.G_RESULT_OP_TYPE.StageJumpTo then
		self.panel.StageFailed.gameObject:SetActiveEx(false)
		self.panel.StageFinish.gameObject:SetActiveEx(false)
		self.panel.StageStart.gameObject:SetActiveEx(false)
		self.panel.StageJumpTo.gameObject:SetActiveEx(true)
		self.panel.JumpToTxt.LabText = StringEx.Format(Common.Utils.Lang("DUNGEONS_ENDLESS_WILL_TO"),data.param1)
		self.panel.StageJumpTo:PlayDynamicEffect(1,{
			stopTime = 2.7,
			stopCallback = function()
				if data.callback then
					data.callback()
				end
				self.panel.StageJumpTo.gameObject:SetActiveEx(false)
			end
		})
		self.cb = data.callback
		MLuaClientHelper.PlayFxHelper(self.panel.StageJumpTo.gameObject)
	end
end

--lua custom scripts end
