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
---@class CreateCharTogTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogEditEye MoonClient.MLuaUICom
---@field Tog MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class CreateCharTogTemplate : BaseUITemplate
---@field Parameter CreateCharTogTemplateParameter

CreateCharTogTemplate = class("CreateCharTogTemplate", super)
--lua class define end

--lua functions
function CreateCharTogTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function CreateCharTogTemplate:OnDestroy()
	
	
end --func end
--next--
function CreateCharTogTemplate:OnDeActive()
	
	
end --func end
--next--
function CreateCharTogTemplate:OnSetData(data)
	
	    self:CustomSetData(data)
	
end --func end
--next--
function CreateCharTogTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function CreateCharTogTemplate:CustomSetData(data)
    
    self.Parameter.Icon:SetSprite(data.atlas, data.icon)
    self.Parameter.Text.LabText = data.name

    self.Parameter.Tog.Tog.group = data.group
    self.Parameter.Select.gameObject:SetActiveEx(data.selected)
    self.Parameter.Tog:OnToggleChanged(function (value)
        if value then
            self.MethodCallback(data.id, data.index)
            self.Parameter.Select.gameObject:SetActiveEx(true)
        else
            self.Parameter.Select.gameObject:SetActiveEx(false)
        end
    end)

    self.Parameter.Tog.Tog.isOn = data.selected
end
--lua custom scripts end
return CreateCharTogTemplate