--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ForbidChatPlayerInfosPanel"
require "UI/Template/ForbidPlayerInfoTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ForbidChatPlayerInfosCtrl : UIBaseCtrl
ForbidChatPlayerInfosCtrl = class("ForbidChatPlayerInfosCtrl", super)
--lua class define end

--lua functions
function ForbidChatPlayerInfosCtrl:ctor()
	
	super.ctor(self, CtrlNames.ForbidChatPlayerInfos, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function ForbidChatPlayerInfosCtrl:Init()
	---@type ForbidChatPlayerInfosPanel
	self.panel = UI.ForbidChatPlayerInfosPanel.Bind(self)
	super.Init(self)
	---@type ChatData
	self.dataMgr = DataMgr:GetData("ChatData")
	---@type ModuleMgr.ChatMgr
	self.chatMgr = MgrMgr:GetMgr("ChatMgr")
	self.forbidPlayersPool = self:NewTemplatePool({
		ScrollRect = self.panel.LoopScroll_ForbidPlayers.LoopScroll,
		UITemplateClass = UITemplate.ForbidPlayerInfoTemplate,
		TemplatePrefab = self.panel.Template_forbidPlayerInfo.gameObject,
	})

	self.panel.Btn_Close:AddClickWithLuaSelf(self.Close,self,true)
end --func end
--next--
function ForbidChatPlayerInfosCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.forbidPlayersPool=nil
end --func end
--next--
function ForbidChatPlayerInfosCtrl:OnActive()
	self:refreshPanel()
	
end --func end
--next--
function ForbidChatPlayerInfosCtrl:OnDeActive()
	
	
end --func end
--next--
function ForbidChatPlayerInfosCtrl:Update()
	
	
end --func end
--next--
function ForbidChatPlayerInfosCtrl:BindEvents()
	self:BindEvent(self.chatMgr.EventDispatcher,self.dataMgr.EEventType.UpdateForbidPlayerInfo, self.refreshPanel,self)
	self:BindEvent(self.chatMgr.EventDispatcher,self.dataMgr.EEventType.GetForbidPlayerInfoList, self.refreshPanel,self)
end --func end
--next--
--lua functions end

--lua custom scripts
function ForbidChatPlayerInfosCtrl:refreshPanel()
	local l_forbidPlayerInfos = self.dataMgr.GetForbidPlayerInfos()
	local l_forbidPlayerNum = #l_forbidPlayerInfos
	local l_hasForbidPlayer = l_forbidPlayerNum > 0

	self.panel.Panel_NoForbidPlayer:SetActiveEx(not l_hasForbidPlayer)
	self.panel.LoopScroll_ForbidPlayers:SetActiveEx(l_hasForbidPlayer)

	if not l_hasForbidPlayer then
		return
	end

	self.forbidPlayersPool:ShowTemplates({
		Datas = l_forbidPlayerInfos,
	    StartScrollIndex=self.forbidPlayersPool:GetCellStartIndex(),
	    IsNeedShowCellWithStartIndex=false,
	    IsToStartPosition=false})
end
--lua custom scripts end
return ForbidChatPlayerInfosCtrl