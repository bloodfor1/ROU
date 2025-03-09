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
---@class SlotHurtTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SKILLICON MoonClient.MLuaUICom[]
---@field Bg_zikuang3 MoonClient.MLuaUICom
---@field Text3 MoonClient.MLuaUICom
---@field Bg_zikuang5 MoonClient.MLuaUICom
---@field Text5 MoonClient.MLuaUICom
---@field Btn_skill MoonClient.MLuaUICom
---@field LvText MoonClient.MLuaUICom

---@class SlotHurtTemplate : BaseUITemplate
---@field Parameter SlotHurtTemplateParameter

SlotHurtTemplate = class("SlotHurtTemplate", super)
--lua class define end

--lua functions
function SlotHurtTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SlotHurtTemplate:OnDestroy()
	
	
end --func end
--next--
function SlotHurtTemplate:OnDeActive()
	
	
end --func end
--next--
function SlotHurtTemplate:OnSetData(data)
	
	    if data.sdata then
	        local skillName = data.sdata.Name
	        local skillId = data.sdata.Id
	        local fiveActive = #skillName / 3 > 3
	        self.Parameter.Bg_zikuang5:SetActiveEx(fiveActive)
	        self.Parameter.Bg_zikuang3:SetActiveEx(not fiveActive)
	        if fiveActive then
	            self.Parameter.Text5.LabText = skillName
	        else
	            self.Parameter.Text3.LabText = skillName
	        end
	        print(tostring(self.Parameter.SKILLICON))
	        self.Parameter.SKILLICON:SetSpriteAsync(data.sdata.Atlas, data.sdata.Icon)
	        self.Parameter.LvText.LabText = "Lv." .. data.lv
	        self.Parameter.Btn_skill:AddClick(function()
	            MgrMgr:GetMgr("SkillLearningMgr").ShowSkillTip(skillId, self.Parameter.Btn_skill.gameObject, data.lv)
	        end)
	    end
	
end --func end
--next--
function SlotHurtTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SlotHurtTemplate