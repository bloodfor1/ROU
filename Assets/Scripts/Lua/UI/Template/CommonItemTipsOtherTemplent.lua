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
---@class CommonItemTipsOtherTemplentParameter.StickItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Item MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class CommonItemTipsOtherTemplentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StickerWall MoonClient.MLuaUICom
---@field enchantTpl MoonClient.MLuaUICom
---@field enchantName MoonClient.MLuaUICom
---@field CommonItemTipsSetNumComponent MoonClient.MLuaUICom
---@field StickItemTemplate CommonItemTipsOtherTemplentParameter.StickItemTemplate

---@class CommonItemTipsOtherTemplent : BaseUITemplate
---@field Parameter CommonItemTipsOtherTemplentParameter

CommonItemTipsOtherTemplent = class("CommonItemTipsOtherTemplent", super)
--lua class define end

--lua functions
function CommonItemTipsOtherTemplent:Init()
	
	    super.Init(self)
	
end --func end
--next--
function CommonItemTipsOtherTemplent:OnDestroy()
	
	
end --func end
--next--
function CommonItemTipsOtherTemplent:OnSetData(data)
	
	self.Parameter.OtherTipsInfo.gameObject:SetActiveEx(false)
	self.Parameter.OtherTitleTips.gameObject:SetActiveEx(false)
	
end --func end
--next--
function CommonItemTipsOtherTemplent:BindEvents()
	
	
end --func end
--next--
function CommonItemTipsOtherTemplent:OnDeActive()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
CommonItemTipsOtherTemplent.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsOtherComponent"

function CommonItemTipsOtherTemplent:SetInfo(showTxt,showTitleInfo)
    --SetActiveEx无法将string转化为bool
    self.Parameter.OtherTipsInfo.gameObject:SetActiveEx(not not showTxt)
    self.Parameter.OtherTitleTips.gameObject:SetActiveEx(not not showTitleInfo)
end

function CommonItemTipsOtherTemplent:ResetSetComponent()
	self.Parameter.OtherTipsInfo.gameObject:SetActiveEx(false)
	self.Parameter.OtherTitleTips.gameObject:SetActiveEx(false)
end
--lua custom scripts end
return CommonItemTipsOtherTemplent