--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ReturnGuildItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field NumberOfPeople MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field matching MoonClient.MLuaUICom
---@field GuildIcon MoonClient.MLuaUICom
---@field choose MoonClient.MLuaUICom

---@class ReturnGuildItem : BaseUITemplate
---@field Parameter ReturnGuildItemParameter

ReturnGuildItem = class("ReturnGuildItem", super)
--lua class define end

--lua functions
function ReturnGuildItem:Init()
	
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("ReBackMgr")

	self.Parameter.choose:OnToggleChanged(function(value)
		self:onTglChange(value)
	end)
	
end --func end
--next--
function ReturnGuildItem:BindEvents()
	
	
end --func end
--next--
function ReturnGuildItem:OnDestroy()
	
	
end --func end
--next--
function ReturnGuildItem:OnDeActive()
	
	
end --func end
--next--
function ReturnGuildItem:OnSetData(data)
	self.data = data
	self.Parameter.Name.LabText = data.guildName
	self.Parameter.NumberOfPeople.LabText = StringEx.Format("{0}/{1}",data.currentCount,data.maxCount)
	if self.ShowIndex > 0 and self.ShowIndex <= 2  then
		self.Parameter.matching.LabText = Common.Utils.Lang("RETURN_GUILD_FRIEND_COUNT",data.friendCount)
	elseif self.ShowIndex > 2 and self.ShowIndex <= 4 then
		self.Parameter.matching.LabText = Common.Utils.Lang("RETURN_GUILD_MATCH")
	end

	local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(data.iconId)
	self.Parameter.GuildIcon:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)
end --func end
--next--
--lua functions end

--lua custom scripts

function ReturnGuildItem:onTglChange(value)
	self.mgr.l_eventDispatcher:Dispatch(self.mgr.SIG_WELCOME_GUILD_CHOOSE_CHANGE,self.data.guildId,value)
end

--lua custom scripts end
return ReturnGuildItem