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
---@class ForgePropertyTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropertyImage MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom

---@class ForgePropertyTemplate : BaseUITemplate
---@field Parameter ForgePropertyTemplateParameter

ForgePropertyTemplate = class("ForgePropertyTemplate", super)
--lua class define end

--lua functions
function ForgePropertyTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ForgePropertyTemplate:OnDeActive()
	
	
end --func end
--next--
function ForgePropertyTemplate:OnSetData(data)
	
	    self.Parameter.PropertyText.LabText=data.attr.Name
	    self.Parameter.PropertyImage.gameObject:SetActiveEx(data.IsShowImage)
	        self.Parameter.PropertyText:AddClick(function ()
	            --显示描述
	            if data.attr.attr ~= nil and (data.attr.attr.type == 3 or data.attr.attr.type == 4) then
	                local l_position = self.Parameter.PropertyText.transform.position
	                local l_skillData =
	                {
	                    openType = DataMgr:GetData("SkillData").OpenType.ShowSkillInfo,
	                    position = l_position,
	                    data = data.attr.attr
	                }
	                UIMgr:ActiveUI(UI.CtrlNames.SkillAttr, l_skillData)
	            end
	        end)
	
end --func end
--next--
function ForgePropertyTemplate:BindEvents()
	
	
end --func end
--next--
function ForgePropertyTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ForgePropertyTemplate