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
---@class LifeProfessionProductTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_UnlockLevel MoonClient.MLuaUICom
---@field Text_Name MoonClient.MLuaUICom
---@field Template_LifeProfessionProduct MoonClient.MLuaUICom
---@field Img_UnlockPic MoonClient.MLuaUICom
---@field Img_Pic MoonClient.MLuaUICom
---@field Img_Icon MoonClient.MLuaUICom
---@field Img_Choose MoonClient.MLuaUICom

---@class LifeProfessionProductTemplate : BaseUITemplate
---@field Parameter LifeProfessionProductTemplateParameter

LifeProfessionProductTemplate = class("LifeProfessionProductTemplate", super)
--lua class define end

--lua functions
function LifeProfessionProductTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function LifeProfessionProductTemplate:BindEvents()
	
	
end --func end
--next--
function LifeProfessionProductTemplate:OnDestroy()
	
	
end --func end
--next--
function LifeProfessionProductTemplate:OnDeActive()
	
	
end --func end
--next--
function LifeProfessionProductTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	self.Parameter.Text_Name.LabText = data.data.Name
	self.Parameter.Img_Pic:SetSpriteAsync(data.data.Atlas,data.data.Icon,nil,true)
	self.Parameter.Img_UnlockPic:SetActiveEx(data.lock)
	self.Parameter.Txt_UnlockLevel:SetActiveEx(data.lock)
	self.Parameter.Txt_UnlockLevel.LabText = Lang("MEDAL_UNLOCK",data.lockLv)
	self.Parameter.Template_LifeProfessionProduct:AddClick(function()
		self:NotiyPoolSelect()
		if data.selectMethod~=nil then
			data.selectMethod(data.ctrl,data.data)
		end
	end,true)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function LifeProfessionProductTemplate:OnSelect()
	self.Parameter.Img_Choose:SetActiveEx(true)
end
function LifeProfessionProductTemplate:OnDeselect()
	self.Parameter.Img_Choose:SetActiveEx(false)
end
--lua custom scripts end
return LifeProfessionProductTemplate