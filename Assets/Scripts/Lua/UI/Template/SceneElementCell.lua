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
---@class SceneElementCellParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SolutionText MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field EffectText MoonClient.MLuaUICom
---@field EffectName MoonClient.MLuaUICom

---@class SceneElementCell : BaseUITemplate
---@field Parameter SceneElementCellParameter

SceneElementCell = class("SceneElementCell", super)
--lua class define end

--lua functions
function SceneElementCell:Init()
	
	super.Init(self)
	
end --func end
--next--
function SceneElementCell:BindEvents()
	
	
end --func end
--next--
function SceneElementCell:OnDestroy()
	
	
end --func end
--next--
function SceneElementCell:OnDeActive()
	
	
end --func end
--next--
function SceneElementCell:OnSetData(data)
	
	self.affixId = data
	    local l_affixRow = TableUtil.GetAffixTable().GetRowById(self.affixId)
	    if l_affixRow then
	        self.Parameter.Icon:SetSprite(l_affixRow.IconAtlas, l_affixRow.AffixIcon)
	        self.Parameter.EffectText.LabText = l_affixRow.Description
	        self.Parameter.SolutionText.LabText = l_affixRow.MethodDescription
            self.Parameter.EffectName.LabText = l_affixRow.Name
	    end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SceneElementCell