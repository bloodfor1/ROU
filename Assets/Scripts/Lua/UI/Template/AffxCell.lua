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
---@class AffxCellParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Line MoonClient.MLuaUICom
---@field AffixIcon MoonClient.MLuaUICom
---@field AffixDes MoonClient.MLuaUICom

---@class AffxCell : BaseUITemplate
---@field Parameter AffxCellParameter

AffxCell = class("AffxCell", super)
--lua class define end

--lua functions
function AffxCell:Init()
	
	super.Init(self)
	
end --func end
--next--
function AffxCell:BindEvents()
	
	
end --func end
--next--
function AffxCell:OnDestroy()
	
	
end --func end
--next--
function AffxCell:OnDeActive()
	
	
end --func end
--next--
function AffxCell:OnSetData(data)
    self.affixId = data.id
    self.Parameter.Line:SetActiveEx(not data.isLast)
    local l_affixRow = TableUtil.GetAffixTable().GetRowById(self.affixId)
    if l_affixRow then
        self.Parameter.AffixIcon:SetSprite(l_affixRow.IconAtlas, l_affixRow.AffixIcon)
        self.Parameter.AffixDes.LabText = RoColor.FormatWord(Lang("AFFIX_DES", l_affixRow.Name, l_affixRow.Description))
    end
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AffxCell