--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildOrganizationHanorRankPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
GuildOrganizationHanorRankCtrl = class("GuildOrganizationHanorRankCtrl", super)
--lua class define end

--lua functions
function GuildOrganizationHanorRankCtrl:ctor()
	super.ctor(self, CtrlNames.GuildOrganizationHanorRank, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function GuildOrganizationHanorRankCtrl:Init()
	self.panel = UI.GuildOrganizationHanorRankPanel.Bind(self)
	super.Init(self)

	self.mask = self:NewPanelMask(BlockColor.Transparent)

	self.guildMgr = MgrMgr:GetMgr("GuildMgr")
	self.organizationRankPool = self:NewTemplatePool({
		TemplateClassName = "GuildOraganizationRankTemplate",
		ScrollRect = self.panel.Scroll_Rank.LoopScroll,
		TemplatePrefab = self.panel.Template_GuildOraganizationRank.gameObject,
	})

	self.panel.ButtonClose:AddClick(function()
		UIMgr:DeActiveUI(CtrlNames.GuildOrganizationHanorRank)
	end,true)
end --func end
--next--
function GuildOrganizationHanorRankCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function GuildOrganizationHanorRankCtrl:OnActive()
	self.guildMgr.ReqGetGuildOrganizationRank()
end --func end
--next--
function GuildOrganizationHanorRankCtrl:OnDeActive()
	self.organizationRankPool= nil
end --func end
--next--
function GuildOrganizationHanorRankCtrl:Update()
	
	
end --func end
--next--
function GuildOrganizationHanorRankCtrl:BindEvents()
	self:BindEvent(self.guildMgr.EventDispatcher, self.guildMgr.ON_GET_GUILD_ORGANIZATION_RANK, function(_,memberList)
		self:showRankInfos(memberList)
	end , self)
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildOrganizationHanorRankCtrl:showRankInfos(data)
	local l_rankData = {}
	self.organizationRankPool:ShowTemplates({ Datas = data })
end
--lua custom scripts end
return GuildOrganizationHanorRankCtrl