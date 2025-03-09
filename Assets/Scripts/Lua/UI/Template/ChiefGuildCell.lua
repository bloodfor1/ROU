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
---@class ChiefGuildCellParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PlaceOff MoonClient.MLuaUICom
---@field Place MoonClient.MLuaUICom
---@field NameOn MoonClient.MLuaUICom
---@field NameOff MoonClient.MLuaUICom
---@field HeadOn MoonClient.MLuaUICom
---@field HeadOff MoonClient.MLuaUICom
---@field BackOn MoonClient.MLuaUICom
---@field BackOff MoonClient.MLuaUICom

---@class ChiefGuildCell : BaseUITemplate
---@field Parameter ChiefGuildCellParameter

ChiefGuildCell = class("ChiefGuildCell", super)
--lua class define end

--lua functions
function ChiefGuildCell:Init()
	
	super.Init(self)
	    self.Parameter.BackOff:AddClick(function()
	        if self.leaderId then
	            self.MethodCallback(self.ShowIndex, self.leaderId)
	        end
	    end)
	
end --func end
--next--
function ChiefGuildCell:BindEvents()
	
	
end --func end
--next--
function ChiefGuildCell:OnDestroy()
	
	
end --func end
--next--
function ChiefGuildCell:OnDeActive()
	
	
end --func end
--next--
function ChiefGuildCell:OnSetData(data)
	
	self.leaderId = data.leaderId
    self.chiefGuidCtrl = data.chiefGuidCtrl
    local l_leaderRow = TableUtil.GetLeaderMethodDetailTable().GetRowByLeaderID(self.leaderId)
    local l_entityRow = TableUtil.GetEntityTable().GetRowById(self.leaderId)
    if l_leaderRow and l_entityRow then
        self.Parameter.HeadOn:SetSpriteAsync(l_leaderRow.Atlas, l_leaderRow.Icon, nil, true)
            self.Parameter.HeadOff:SetSpriteAsync(l_leaderRow.Atlas, l_leaderRow.Icon, nil, true)
        self.Parameter.NameOn.LabText = l_entityRow.Name
            self.Parameter.NameOff.LabText = l_entityRow.Name
        local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(l_leaderRow.SceneID)
        if l_sceneRow then
            self.Parameter.PlaceOn.LabText = l_sceneRow.Comment
                self.Parameter.PlaceOff.LabText = l_sceneRow.Comment
        end
    end
    self:OnDeselect()
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ChiefGuildCell:OnSelect()
    self.Parameter.BackOn:SetActiveEx(true)
    self.Parameter.BackOff:SetActiveEx(false)
end

function ChiefGuildCell:OnDeselect()
    self.Parameter.BackOn:SetActiveEx(false)
    self.Parameter.BackOff:SetActiveEx(true)
end
--lua custom scripts end
return ChiefGuildCell