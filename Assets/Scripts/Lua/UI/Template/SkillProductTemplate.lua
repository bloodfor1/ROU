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
---@class SkillProductTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_LockTip MoonClient.MLuaUICom
---@field Img_unlock MoonClient.MLuaUICom
---@field Img_ProductItem MoonClient.MLuaUICom

---@class SkillProductTemplate : BaseUITemplate
---@field Parameter SkillProductTemplateParameter

SkillProductTemplate = class("SkillProductTemplate", super)
--lua class define end

--lua functions
function SkillProductTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function SkillProductTemplate:BindEvents()
	
	
end --func end
--next--
function SkillProductTemplate:OnDestroy()
	
	
end --func end
--next--
function SkillProductTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillProductTemplate:OnSetData(data)
	
	if data == nil then
		return
	end
	---@type RecipeTable
	local l_recipeData = data.data
	self.Parameter.Img_ProductItem:SetSpriteAsync(l_recipeData.Atlas,l_recipeData.Icon,nil,true)
	self.Parameter.Txt_LockTip:SetActiveEx(data.lock)
	self.Parameter.Img_unlock:SetActiveEx(data.lock)
	if data.lock then
		self.Parameter.Txt_LockTip.LabText = Lang("MEDAL_UNLOCK",data.lockLv)
	end
	self.Parameter.Img_ProductItem:AddClick(function()
		if data.onClick~=nil then
			local l_creenPos = MLuaCommonHelper.LocalPositionToScreenPos(self.Parameter.Img_ProductItem.Transform.localPosition,
					MUIManager.UICamera,self.Parameter.Img_ProductItem.Transform)
			l_creenPos.x = l_creenPos.x - self.Parameter.Img_ProductItem.RectTransform.rect.width/2
			l_creenPos.y = l_creenPos.y + self.Parameter.Img_ProductItem.RectTransform.rect.height/2
			data.onClick(l_creenPos,l_recipeData)
		end
	end,true)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SkillProductTemplate