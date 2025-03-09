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
---@class SelectElementShowActionTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextIntimacy MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field BtnSingleInstance MoonClient.MLuaUICom

---@class SelectElementShowActionTemplate : BaseUITemplate
---@field Parameter SelectElementShowActionTemplateParameter

SelectElementShowActionTemplate = class("SelectElementShowActionTemplate", super)
--lua class define end

--lua functions
function SelectElementShowActionTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SelectElementShowActionTemplate:OnDeActive()
	
	
end --func end
--next--
function SelectElementShowActionTemplate:OnSetData(data)
	
	    self:CustomSetData(data)
	
end --func end
--next--
function SelectElementShowActionTemplate:BindEvents()
	
	
end --func end
--next--
function SelectElementShowActionTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SelectElementShowActionTemplate:CustomSetData(row)
    
    self.Parameter.BtnSingleInstance:SetSprite("Pose", row.Icon)
    self.Parameter.Text.LabText = row.Name

    if row.Type == 0 then
        self.Parameter.Image.gameObject:SetActiveEx(false)
    else
        if row.FriendIntimacy > 0 then
            self.Parameter.Image.gameObject:SetActiveEx(true)
            self.Parameter.TextIntimacy.LabText = tostring(row.FriendIntimacy)
            local l_preferredWidth = self.Parameter.TextIntimacy:GetText().preferredWidth
            MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Image1.gameObject, -l_preferredWidth / 2 - 0.5)
        else
            self.Parameter.Image.gameObject:SetActiveEx(false)
        end
    end

    local l_locked = row.BaseLevel > MPlayerInfo.Lv
    self.Parameter.BtnSingleInstance:SetGray(l_locked)

    self.Parameter.BtnSingleInstance:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(row)
        end
    end)
end
--lua custom scripts end
return SelectElementShowActionTemplate