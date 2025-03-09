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
---@class RankDetailTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogL MoonClient.MLuaUICom
---@field Text_On MoonClient.MLuaUICom
---@field Text_OFF MoonClient.MLuaUICom
---@field RankDetail MoonClient.MLuaUICom
---@field ON MoonClient.MLuaUICom
---@field OFF MoonClient.MLuaUICom

---@class RankDetailTem : BaseUITemplate
---@field Parameter RankDetailTemParameter

RankDetailTem = class("RankDetailTem", super)
--lua class define end

--lua functions
function RankDetailTem:Init()
	
	    super.Init(self)
	    self.Parameter.OFF:AddClick(function()
	        self.MethodCallback(self.ShowIndex, self.PickIndex)
	    end)
	
end --func end
--next--
function RankDetailTem:BindEvents()
	
	
end --func end
--next--
function RankDetailTem:OnDestroy()
	
	
end --func end
--next--
function RankDetailTem:OnDeActive()
	
	
end --func end
--next--
function RankDetailTem:OnSetData(data)
	
	    self.Parameter.Text_OFF.LabText = data.name
	    self.Parameter.Text_On.LabText = data.name
	    self.PickIndex = data.Index
	    self.Parameter.ON:SetActiveEx(false)
	    self.Parameter.OFF:SetActiveEx(true)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function RankDetailTem:OnSelect()
    --log("OnSelect",self.ShowIndex)
    self.Parameter.ON:SetActiveEx(true)
    self.Parameter.OFF:SetActiveEx(false)
end

function RankDetailTem:OnDeselect()
    --log("OnDeselect",self.ShowIndex)
    self.Parameter.ON:SetActiveEx(false)
    self.Parameter.OFF:SetActiveEx(true)
end
--lua custom scripts end
return RankDetailTem