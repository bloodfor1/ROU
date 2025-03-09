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
---@class MercenarySkillCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockLV MoonClient.MLuaUICom
---@field SkillName5Text MoonClient.MLuaUICom
---@field SkillName5 MoonClient.MLuaUICom
---@field SkillName3Text MoonClient.MLuaUICom
---@field SkillName3 MoonClient.MLuaUICom
---@field SkillBtn MoonClient.MLuaUICom
---@field Skill MoonClient.MLuaUICom
---@field pre MoonClient.MLuaUICom
---@field PassiveImg MoonClient.MLuaUICom
---@field OptionTog MoonClient.MLuaUICom
---@field Noskill MoonClient.MLuaUICom
---@field NormalImg MoonClient.MLuaUICom
---@field learnEff MoonClient.MLuaUICom

---@class MercenarySkillCellTemplate : BaseUITemplate
---@field Parameter MercenarySkillCellTemplateParameter

MercenarySkillCellTemplate = class("MercenarySkillCellTemplate", super)
--lua class define end

--lua functions
function MercenarySkillCellTemplate:Init()
	
    super.Init(self)
    self.mercenaryMgr = MgrMgr:GetMgr("MercenaryMgr")
    self.Parameter.SkillBtn:AddClick(function()
        if self.skillInfo then
            MgrMgr:GetMgr("SkillLearningMgr").ShowSkillTip(self.skillInfo.tableInfo.Id, self.Parameter.SkillBtn.gameObject, self.skillInfo.level)
        end
    end)
	
end --func end
--next--
function MercenarySkillCellTemplate:OnDestroy()
	
	
end --func end
--next--
function MercenarySkillCellTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenarySkillCellTemplate:OnSetData(data,AdditionalData)
	
    self.skillInfo = data.skillInfo
    self.mercenaryInfo = data.mercenaryInfo
    --if not self.mercenaryInfo.isRecruited then
    --    self.Parameter.Skill:SetActiveEx(false)
    --    self.Parameter.Noskill:SetActiveEx(true)
    --    return
    --end
    local l_isLock = self.mercenaryInfo.level < self.skillInfo.lockLevel

    -- 解锁
    self.Parameter.UnlockLV:SetActiveEx(l_isLock)
    self.Parameter.UnlockLV.LabText = Lang("MERCENARY_SKILL_LOCK", self.skillInfo.lockLevel)

    self.Parameter.Skill:SetActiveEx(true)
    self.Parameter.Noskill:SetActiveEx(false)
    local l_skillName = self.skillInfo.tableInfo.Name
    self.Parameter.SkillName3.gameObject:SetActiveEx(#l_skillName / 3 <= 3)
    self.Parameter.SkillName3Text.LabText = l_skillName
    self.Parameter.SkillName5.gameObject:SetActiveEx(#l_skillName / 3 > 3)
    self.Parameter.SkillName5Text.LabText = Common.Utils.GetCutOutText(l_skillName, 5)
    self.Parameter.OptionTog:SetActiveEx(self.skillInfo.isOptionSkill and self.mercenaryInfo.isRecruited and not data.isFromAdvance and not l_isLock)
    self.Parameter.OptionTog.Tog.onValueChanged:RemoveAllListeners()
    self.Parameter.OptionTog.Tog.isOn = self.skillInfo.isOption
    self.Parameter.OptionTog.Tog.onValueChanged:AddListener(function(isOn)
        self.mercenaryMgr.ChangeOptionSkillState(self.mercenaryInfo.tableInfo.Id, self.skillInfo.tableInfo.Id, isOn)
    end)
    self.Parameter.SkillBtn:SetSprite(self.skillInfo.tableInfo.Atlas, self.skillInfo.tableInfo.Icon, true)
    self.Parameter.SkillBtn:SetGray(not self.mercenaryInfo.isRecruited and not data.isFromAdvance and l_isLock)
    if AdditionalData ~= nil then
        self.Parameter.pre.transform:SetLocalScale(AdditionalData.x,AdditionalData.y,AdditionalData.z)
    else
        self.Parameter.pre.transform:SetLocalScaleOne()
    end
	
end --func end
--next--
function MercenarySkillCellTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenarySkillCellTemplate