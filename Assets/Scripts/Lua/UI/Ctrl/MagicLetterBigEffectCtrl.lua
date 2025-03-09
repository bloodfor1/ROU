--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MagicLetterBigEffectPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class MagicLetterBigEffectCtrl : UIBaseCtrl
MagicLetterBigEffectCtrl = class("MagicLetterBigEffectCtrl", super)
--lua class define end

--lua functions
function MagicLetterBigEffectCtrl:ctor()
	
	super.ctor(self, CtrlNames.MagicLetterBigEffect, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function MagicLetterBigEffectCtrl:Init()
	
	self.panel = UI.MagicLetterBigEffectPanel.Bind(self)
	super.Init(self)
	self.loadEffectList = {}
end --func end
--next--
function MagicLetterBigEffectCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MagicLetterBigEffectCtrl:OnActive()
	if self.uiPanelData~=nil then
		if self.uiPanelData.showReceiveLetterEffect then
			self:createMagicLetterEffect(true)
		end

		if self.uiPanelData.showSendLetterEffect then
			self:createMagicLetterEffect(false)
		end
	end
end --func end
--next--
function MagicLetterBigEffectCtrl:OnDeActive()
	self:clearTimer()

	for _,v in ipairs(self.loadEffectList) do
		if not MLuaCommonHelper.IsNull(v) then
			MResLoader:DestroyObj(v)
		end
	end
	self.loadEffectList={}
end --func end
--next--
function MagicLetterBigEffectCtrl:Update()
	
	
end --func end
--next--
function MagicLetterBigEffectCtrl:BindEvents()
	local l_magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
	self:BindEvent(l_magicLetterMgr.EventDispatcher, l_magicLetterMgr.EMagicEvent.PlayFullScreenEffect, self.createMagicLetterEffect)
end --func end
--next--
--lua functions end

--lua custom scripts

function MagicLetterBigEffectCtrl:createMagicLetterEffect(isReceiver)
	local l_effectOriginObj = nil
	if isReceiver then
		l_effectOriginObj = self.panel.Effect_Receive.UObj
	else
		l_effectOriginObj = self.panel.Effect_Send.UObj
	end
	---@type UnityEngine.GameObject
	local l_newEffectObj = self:CloneObj(l_effectOriginObj,false)
	if not MLuaCommonHelper.IsNull(l_newEffectObj) then
		l_newEffectObj.transform:SetParent(self.panel.Panel_EffectParent.Transform)
		table.insert(self.loadEffectList,l_newEffectObj)
		l_newEffectObj:SetActiveEx(true)
	end
	self:createClosePanelTimer()
end
function MagicLetterBigEffectCtrl:createClosePanelTimer()
	self:clearTimer()
	self.closePanelTimer = Timer.New(function()
		self:Close()
	end, 3, 1)
	self.closePanelTimer:Start()
end
function MagicLetterBigEffectCtrl:clearTimer()
	if self.closePanelTimer~=nil then
		self.closePanelTimer:Stop()
		self.closePanelTimer=nil
	end
end
--lua custom scripts end
return MagicLetterBigEffectCtrl