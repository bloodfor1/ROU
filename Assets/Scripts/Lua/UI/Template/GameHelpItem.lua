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
---@class GameHelpItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class GameHelpItem : BaseUITemplate
---@field Parameter GameHelpItemParameter

GameHelpItem = class("GameHelpItem", super)
--lua class define end

--lua functions
function GameHelpItem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GameHelpItem:OnDestroy()
	
	
end --func end
--next--
function GameHelpItem:OnDeActive()
	
	
end --func end
--next--
function GameHelpItem:OnSetData(data)
	
	self:OnInitialize(data)
	
end --func end
--next--
function GameHelpItem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GameHelpItem:OnInitialize(data)
	self.Parameter.Text.gameObject:SetActiveEx(false)
	self.Parameter.Image.gameObject:SetActiveEx(false)
	if not data then
		return
	end
	if data.str then
		self.Parameter.Text.gameObject:SetActiveEx(true)
		local l_content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(data.str)
		self.Parameter.Text.LabText = l_content
	end
	if data.img and #data.img == 2 then
		self.Parameter.Image.gameObject:SetActiveEx(true)
		self.Parameter.Image:SetSpriteAsync(data.img[1],data.img[2], nil, true)
	end
end
--lua custom scripts end
return GameHelpItem