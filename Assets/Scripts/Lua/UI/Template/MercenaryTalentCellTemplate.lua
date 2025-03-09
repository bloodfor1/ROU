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
---@class MercenaryTalentCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalentLvMax MoonClient.MLuaUICom
---@field TalentLv4 MoonClient.MLuaUICom
---@field TalentLv3 MoonClient.MLuaUICom
---@field TalentLv2 MoonClient.MLuaUICom
---@field TalentLv1 MoonClient.MLuaUICom
---@field TalentImg MoonClient.MLuaUICom
---@field SelectEffect MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class MercenaryTalentCellTemplate : BaseUITemplate
---@field Parameter MercenaryTalentCellTemplateParameter

MercenaryTalentCellTemplate = class("MercenaryTalentCellTemplate", super)
--lua class define end

--lua functions
function MercenaryTalentCellTemplate:Init()
	
	super.Init(self)
    self.talentLvComs = nil
    self.mercenaryMgr = MgrMgr:GetMgr("MercenaryMgr")
    self.Parameter.TalentImg:AddClick(function()
            self:HandleTalentCellClicked()
    end)

end --func end
--next--
function MercenaryTalentCellTemplate:OnDestroy()
	
	
end --func end
--next--
function MercenaryTalentCellTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenaryTalentCellTemplate:OnSetData(data)
	
	self.talent = data.talent
	    self.groupInfo = data.groupInfo
	    self.parentCtrl = data.parentCtrl
	    self.Parameter.TalentImg:SetSprite(self.talent.tableInfo.IconAtlas, self.talent.tableInfo.Icon)
        local l_isTalentGray = not self.groupInfo.isStudied or self.groupInfo.selectedTalentBaseId ~= self.talent.talentBaseId
	    self.Parameter.TalentImg:SetGray(l_isTalentGray)
	    if not data.onlyRefreshData then
	        self:SetSelected(false)
	    end
	    --设置等级图标
	    self.Parameter.TalentLvMax:SetActiveEx(self.talent and self.talent.tableInfo.Sign == 2)
	    self.Parameter.TalentLvMax:SetGray(l_isTalentGray)
	    if not self.talentLvComs then
	        self.talentLvComs = { self.Parameter.TalentLv1, self.Parameter.TalentLv2, self.Parameter.TalentLv3, self.Parameter.TalentLv4 }
	    end
	    local l_lvIndex = 0
	    if self.talent then
	        l_lvIndex = self.talent.tableInfo.ID % 10
	    end
	    for i, com in ipairs(self.talentLvComs) do
	        com:SetActiveEx(i == l_lvIndex)
	        com:SetGray(l_isTalentGray)
	    end
	
end --func end
--next--
function MercenaryTalentCellTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MercenaryTalentCellTemplate:SetSelected(isSelected)
    if self.isSelected == isSelected then return end
    self.isSelected = isSelected

    self.Parameter.Select:SetActiveEx(isSelected)
end

function MercenaryTalentCellTemplate:HandleTalentCellClicked()
    self.parentCtrl:HandleTalentCellClicked(self)
end
--lua custom scripts end
return MercenaryTalentCellTemplate