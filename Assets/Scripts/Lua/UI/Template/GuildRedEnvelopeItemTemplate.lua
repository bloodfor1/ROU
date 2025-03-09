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
---@class GuildRedEnvelopeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedTypeName MoonClient.MLuaUICom
---@field RedIcon MoonClient.MLuaUICom
---@field BtnOpen MoonClient.MLuaUICom

---@class GuildRedEnvelopeItemTemplate : BaseUITemplate
---@field Parameter GuildRedEnvelopeItemTemplateParameter

GuildRedEnvelopeItemTemplate = class("GuildRedEnvelopeItemTemplate", super)
--lua class define end

--lua functions
function GuildRedEnvelopeItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildRedEnvelopeItemTemplate:OnDestroy()
	
	
end --func end
--next--
function GuildRedEnvelopeItemTemplate:OnDeActive()
	
	
end --func end
--next--
function GuildRedEnvelopeItemTemplate:OnSetData(data)
	
	    self.data = data
	    if data.is_received then
	        self.Parameter.RedIcon:SetSprite(MGlobalConfig:GetString("REIconAtlas"), MGlobalConfig:GetString("REIconHongbao02"))
	    else
	        self.Parameter.RedIcon:SetSprite(MGlobalConfig:GetString("REIconAtlas"), MGlobalConfig:GetString("REIconHongbao01"))
	    end
	    if data.red_envelope_type == MgrMgr:GetMgr("RedEnvelopeMgr").RED_TYPE.PASSWORD then
	        self.Parameter.RedTypeName.LabText = Lang("PASSWORD_RED_ENVELOPE")
	    else
	        self.Parameter.RedTypeName.LabText = Lang("LUCK_RED_ENVELOPE")
	    end
	    self.Parameter.BtnOpen:AddClick(function ()
	        self:MethodCallback()
	    end)
	
end --func end
--next--
function GuildRedEnvelopeItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildRedEnvelopeItemTemplate