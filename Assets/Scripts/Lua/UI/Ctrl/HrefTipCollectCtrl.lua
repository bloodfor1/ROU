--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HrefTipCollectPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class HrefTipCollectCtrl : UIBaseCtrl
HrefTipCollectCtrl = class("HrefTipCollectCtrl", super)
--lua class define end

--lua functions
function HrefTipCollectCtrl:ctor()
	
	super.ctor(self, CtrlNames.HrefTipCollect, UILayer.Tips, nil, ActiveType.Standalone)
	
end --func end
--next--
function HrefTipCollectCtrl:Init()
	
	self.panel = UI.HrefTipCollectPanel.Bind(self)
	super.Init(self)

	self.panel.Btn_Close:AddClick(function ()
		self:Close()
	end ,true)
end --func end
--next--
function HrefTipCollectCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function HrefTipCollectCtrl:OnActive()
	if self.uiPanelData~=nil then
		if self.uiPanelData.hrefType == ChatHrefType.ShowServerLevel then
			MgrMgr:GetMgr("RoleInfoMgr").GetServerLevelBonusInfo()
			self:showServerLevelTips()
		end
	end
end --func end
--next--
function HrefTipCollectCtrl:OnDeActive()
	
	
end --func end
--next--
function HrefTipCollectCtrl:Update()
	
	
end --func end
--next--bin
function HrefTipCollectCtrl:BindEvents()
	local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
	self:BindEvent(l_roleInfoMgr.EventDispatcher,l_roleInfoMgr.ON_SERVER_LEVEL_UPDATE, self.showServerLevelTips)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function HrefTipCollectCtrl:showServerLevelTips()
	if self.serverLevelTipsTemplate==nil then
		self.serverLevelTipsTemplate = self:NewTemplate("ServerLevelTipsTemplate", {
			TemplateParent = self.panel.Panel_TipsParent.transform
		})
	end
	local l_data = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData
	self.serverLevelTipsTemplate:SetData(l_data)
end
--lua custom scripts end
return HrefTipCollectCtrl