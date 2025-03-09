--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TowerDefenseSpiritPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local Mgr = MgrMgr:GetMgr("TowerDefenseMgr")
--next--
--lua fields end

--lua class define
TowerDefenseSpiritCtrl = class("TowerDefenseSpiritCtrl", super)
--lua class define end

--lua functions
function TowerDefenseSpiritCtrl:ctor()
	
	super.ctor(self, CtrlNames.TowerDefenseSpirit, UILayer.Function, nil, ActiveType.Exclusive)

	self.IsGroup=true
	
end --func end
--next--
function TowerDefenseSpiritCtrl:Init()
	
	self.panel = UI.TowerDefenseSpiritPanel.Bind(self)
	super.Init(self)
	-- 关闭
	self.panel.BtnClose:AddClick(function ()
		UIMgr:DeActiveUI(UI.CtrlNames.TowerDefenseSpirit)
	end)
	
end --func end
--next--
function TowerDefenseSpiritCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end

function TowerDefenseSpiritCtrl:SetupHandlers()
	--local l_handlerTb = {
	--	{HandlerNames.TowerDefenseSpiritAdmin, Lang("TD_POPUP_TAB_MANAGE"),"CommonIcon","UI_Commonicon_Shuxing_01.png","UI_Commonicon_Shuxing_02.png"},
	--	--{HandlerNames.TowerDefenseSpiritCommand, Lang("TD_POPUP_TAB_ORDER"),"CommonIcon","UI_CommonIcon_Tab_Renwu_01.png","UI_CommonIcon_Tab_Renwu_02.png"},
	--}
	--self:InitHandler(l_handlerTb, self.panel.TogAdmin)
end

--next--
function TowerDefenseSpiritCtrl:OnActive()

	if Mgr.TowerDefenseMagicPowerData then
		self.panel.TxtMagicPower.LabText = tostring(Mgr.TowerDefenseMagicPowerData.magic_value)
	end
	self:SetSpiritCount()
	
end --func end
--next--
function TowerDefenseSpiritCtrl:OnDeActive()
	
	
end --func end
--next--
function TowerDefenseSpiritCtrl:Update()
	
	
end --func end

--next--
function TowerDefenseSpiritCtrl:BindEvents()
	self:BindEvent(Mgr.EventDispatcher,Mgr.OnAdminSpiritEvent, function()
		self:SetSpiritCount()
	end)
	self:BindEvent(Mgr.EventDispatcher,Mgr.ReceiveTowerDefenseMagicPowerNtfEvent, function()
		self.panel.TxtMagicPower.LabText = tostring(Mgr.TowerDefenseMagicPowerData.magic_value)
	end)
end --func end
--next--
function TowerDefenseSpiritCtrl:OnHandlerSwitch(handlerName)

	--super.OnHandlerSwitch(self, handlerName)
	--
	--if handlerName == HandlerNames.TowerDefenseSpiritAdmin then
	--	Mgr.CurrentSpiritType = Mgr.ETowerDefenseSpiritType.Admin
	--	self.panel.TxtTitle.LabText = Common.Utils.Lang("TD_POPUP_TITLE_MANAGE")
	--	self.panel.TxtTips.gameObject:SetActiveEx(true)
	--elseif handlerName == HandlerNames.TowerDefenseSpiritCommand then
	--	Mgr.CurrentSpiritType = Mgr.ETowerDefenseSpiritType.Command
	--	self.panel.TxtTitle.LabText = Common.Utils.Lang("TD_POPUP_TITLE_ORDER")
	--	self.panel.TxtTips.gameObject:SetActiveEx(false)
	--end
end --func end
--next--
--lua functions end

--lua custom scripts

-- 英灵的数量数据
function TowerDefenseSpiritCtrl:SetSpiritCount()
	local l_currentSpiritNum = Mgr.GetSpiritSummonCountByCommonId(Mgr.CurrentSummonId)
	local l_maxSpiritNum = 0
	local l_tdData = Mgr.GetTdRowByDungeonsId(MPlayerDungeonsInfo.DungeonID)
	if l_tdData then
		for i = 0, l_tdData.SummonCircleInfo.Length - 1 do
			if l_tdData.SummonCircleInfo[i][0] == Mgr.CurrentSummonId then
				l_maxSpiritNum = l_tdData.SummonCircleInfo[i][2]
				break
			end
		end
		self.panel.TxtSpiritNum.LabText = string.format("%d/%d", l_currentSpiritNum, l_maxSpiritNum)
	end
end
--lua custom scripts end
return TowerDefenseSpiritCtrl