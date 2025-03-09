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
---@class RankNameTextTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@class RankNameTextTem : BaseUITemplate
---@field Parameter RankNameTextTemParameter

RankNameTextTem = class("RankNameTextTem", super)
--lua class define end

--lua functions
function RankNameTextTem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function RankNameTextTem:BindEvents()
	
	
end --func end
--next--
function RankNameTextTem:OnDestroy()
	
	
end --func end
--next--
function RankNameTextTem:OnDeActive()
	
	
end --func end
--next--
function RankNameTextTem:OnSetData(data)
	
	    MLuaCommonHelper.SetRectTransformWidth(self:gameObject(), data.columnWidth)
	    self.Parameter.Text.LabText = tostring(data.value)
	    self.Parameter.Bg:SetActiveEx(data.isMine)
	    if data.color then
	        self.Parameter.Text.LabColor = data.color
	    else
	        self.Parameter.Text.LabColor = Color.white
	    end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RankNameTextTem