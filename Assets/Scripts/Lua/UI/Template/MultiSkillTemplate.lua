--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/MultiSkillEmptyLineTemplate"
require "UI/Template/MultiSkillLineTemplate"
require "UI/Template/MultiSkillTitleLineTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class MultiSkillTemplateParameter.MultiSkillTitleLineTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Line MoonClient.MLuaUICom

---@class MultiSkillTemplateParameter.MultiSkillEmptyLineTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field EmptyLine MoonClient.MLuaUICom

---@class MultiSkillTemplateParameter.MultiSkillLineTemplate.SlotHurtTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text5 MoonClient.MLuaUICom
---@field Text3 MoonClient.MLuaUICom
---@field SKILLICON MoonClient.MLuaUICom
---@field LvText MoonClient.MLuaUICom
---@field Btn_skill MoonClient.MLuaUICom
---@field Bg_zikuang5 MoonClient.MLuaUICom
---@field Bg_zikuang3 MoonClient.MLuaUICom

---@class MultiSkillTemplateParameter.MultiSkillLineTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillLine MoonClient.MLuaUICom
---@field SlotHurtTemplate MultiSkillTemplateParameter.MultiSkillLineTemplate.SlotHurtTemplate

---@class MultiSkillTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillScroll MoonClient.MLuaUICom
---@field RedPromptParent MoonClient.MLuaUICom
---@field DropBtn MoonClient.MLuaUICom
---@field MultiSkillTitleLineTemplate MultiSkillTemplateParameter.MultiSkillTitleLineTemplate
---@field MultiSkillEmptyLineTemplate MultiSkillTemplateParameter.MultiSkillEmptyLineTemplate
---@field MultiSkillLineTemplate MultiSkillTemplateParameter.MultiSkillLineTemplate

---@class MultiSkillTemplate : BaseUITemplate
---@field Parameter MultiSkillTemplateParameter

MultiSkillTemplate = class("MultiSkillTemplate", super)
--lua class define end

--lua functions
function MultiSkillTemplate:Init()
	
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
    self.data = DataMgr:GetData("SkillData")
    self.ignoreSkills = {}
    local l_id = MPlayerInfo.ProID
    local l_row = self.data.GetDataFromTable("ProfessionTable", l_id)
    local l_fixedCommonSkillIds = Common.Functions.VectorToTable(l_row.FixedCommonSkillIds)
    for i = 1, #l_fixedCommonSkillIds do
        table.insert(self.ignoreSkills, l_fixedCommonSkillIds[i])
    end
	
end --func end
--next--
function MultiSkillTemplate:BindEvents()
	
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ON_SKILL_PLAN_CHANGE, self.OnSkillPlanChange)
	
end --func end
--next--
function MultiSkillTemplate:OnDestroy()
	
    self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
    self.multiTalentsSelectTemplate = nil

end --func end
--next--
function MultiSkillTemplate:OnDeActive()
	
	self.skillLinePool = nil
	
end --func end
--next--
function MultiSkillTemplate:OnSetData(data)
	
    self:OnCustomInit()
	
end --func end
--next--
--lua functions end

--lua custom scripts
local ContentType = {
    Title = 0,
    Empty = 1,
    Skill = 2
}

function MultiSkillTemplate:ctor(itemData)

	itemData.Data = {}
	itemData.TemplatePath = "UI/Prefabs/MultiSkillTemplate"
	super.ctor(self, itemData)

end

function MultiSkillTemplate:OnCustomInit()

    self.Parameter.MultiSkillTitleLineTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.Parameter.MultiSkillEmptyLineTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
	self.Parameter.MultiSkillLineTemplate.LuaUIGroup.gameObject:SetActiveEx(false)

    local openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    local functionId=openSystemMgr.eSystemId.SkillMultiTalent
    if not self.multiTalentsSelectTemplate then
        if openSystemMgr.IsSystemOpen(functionId) then
            self.multiTalentsSelectTemplate = self:NewTemplate("MultiTalentsSelectTemplate", {
                TemplateParent = self.Parameter.DropBtn.transform
            })
        end
    end
    if self.multiTalentsSelectTemplate then
        self.multiTalentsSelectTemplate:SetData(functionId, { IsOnlyShowSelect = true })
    end

    -- 刷新显示的技能
    self:RefreshSkills()

end

function MultiSkillTemplate:OnDeActive()
    if self.multiTalentsSelectTemplate then
        self.multiTalentsSelectTemplate:AddLoadCallback(function(template)
            template:_setTalentButtonParentActive(false)
        end)
    end

end

function MultiSkillTemplate:IsIgnoreSkill(id)

    for k, v in pairs(self.ignoreSkills) do
        if v == id then
            return true
        end
    end
    return false

end

function MultiSkillTemplate:RefreshSkills()

    local skillList = self.data.GetLearnSkillIds()
    local harmSkills, assistantSkills = {}, {}
    for i, v in ipairs(skillList) do
        local skillSdata = self.data.GetDataFromTable("SkillTable", v)
        local skillLv = MPlayerInfo:GetCurrentSkillInfo(v).lv
        if skillSdata and not self:IsIgnoreSkill(skillSdata.Id) then
            if skillSdata.SkillTypeIcon == 0 or skillSdata.SkillTypeIcon == 1 then
                table.insert(harmSkills, { id = skillSdata.Id, sdata = skillSdata, lv = skillLv })
            elseif skillSdata.SkillTypeIcon == 2 then
                table.insert(assistantSkills, { id = skillSdata.Id, sdata = skillSdata, lv = skillLv })
            end
        end
    end

    local datas = {}
    table.insert(datas, { type = ContentType.Title, name = Lang("MULTI_SKILL_HARMSKILL") })
    if #harmSkills > 0 then
        table.insert(datas, { type = ContentType.Skill, skills = harmSkills })
    else
        table.insert(datas, { type = ContentType.Empty, text = Lang("MULTI_SKILL_EMPTY_LINE") })
    end
    table.insert(datas, { type = ContentType.Title, name = Lang("MULTI_SKILL_ASSISTANTSKILL") })
    if #assistantSkills > 0 then
        table.insert(datas, { type = ContentType.Skill, skills = assistantSkills})
    else
        table.insert(datas, { type = ContentType.Empty, text = Lang("MULTI_SKILL_EMPTY_LINE") })
    end

    if not self.skillLinePool then
        self.skillLinePool = self:NewTemplatePool({
            PreloadPaths = {},
            ScrollRect = self.Parameter.SkillScroll.LoopScroll,
            GetTemplateAndPrefabMethod = function(data) return self:GetTemplate(data) end,
        })
    end
    self.skillLinePool:ShowTemplates({
        Datas = datas
    })
    self.Parameter.DropBtn.transform:SetAsLastSibling()

end

function MultiSkillTemplate:GetTemplate(data)

    local class, prefab
    if data.type == ContentType.Title then
        class, prefab = UITemplate.MultiSkillTitleLineTemplate, self.Parameter.MultiSkillTitleLineTemplate.LuaUIGroup.gameObject
    elseif data.type == ContentType.Empty then
        class, prefab = UITemplate.MultiSkillEmptyLineTemplate, self.Parameter.MultiSkillEmptyLineTemplate.LuaUIGroup.gameObject
    elseif data.type == ContentType.Skill then
        class, prefab = UITemplate.MultiSkillLineTemplate, self.Parameter.MultiSkillLineTemplate.LuaUIGroup.gameObject
    end
    return class, prefab

end

function MultiSkillTemplate:OnSkillPlanChange()
    self:RefreshSkills()
end
--lua custom scripts end
return MultiSkillTemplate