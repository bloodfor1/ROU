--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/MercenaryTalentCellTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class MercenaryTalentInfoTemplateParameter.MercenaryTalentCell
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

---@class MercenaryTalentInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalentLvMax MoonClient.MLuaUICom
---@field TalentLv4 MoonClient.MLuaUICom
---@field TalentLv3 MoonClient.MLuaUICom
---@field TalentLv2 MoonClient.MLuaUICom
---@field TalentLv1 MoonClient.MLuaUICom
---@field TalentImg MoonClient.MLuaUICom
---@field TalentDetailScroll MoonClient.MLuaUICom
---@field TalentDetailContent MoonClient.MLuaUICom
---@field StudyText MoonClient.MLuaUICom
---@field Study MoonClient.MLuaUICom
---@field SelectEffect MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field LockText MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LevelText MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Detail MoonClient.MLuaUICom
---@field DesText MoonClient.MLuaUICom
---@field MercenaryTalentCell MercenaryTalentInfoTemplateParameter.MercenaryTalentCell

---@class MercenaryTalentInfoTemplate : BaseUITemplate
---@field Parameter MercenaryTalentInfoTemplateParameter

MercenaryTalentInfoTemplate = class("MercenaryTalentInfoTemplate", super)
--lua class define end

--lua functions
function MercenaryTalentInfoTemplate:Init()
	
	super.Init(self)
    self.talentLvComs = nil
    self.selectedTemplate = nil
    self.Parameter.Icon:AddClick(function()
            --if self.isLocked then return end
            if self.parentCtrl then
                self.parentCtrl:HandleTalentInfoClicked(self)
            end
            --清除红点
            MgrMgr:GetMgr("MercenaryMgr").SetTalentRedSignClicked(self.mercenaryInfo.tableInfo.Id, self.talentInfo.lockLevel, true)
        --self:SetSelected(not self.isSelected)
    end)
    self:SetSelected(false)
	
end --func end
--next--
function MercenaryTalentInfoTemplate:OnDestroy()
	
	self:DestroySelectEffect()
	
end --func end
--next--
function MercenaryTalentInfoTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenaryTalentInfoTemplate:OnSetData(data)
	
	self.mercenaryInfo = data.mercenaryInfo
	self.talentInfo = data.talentInfo
	    self.groupInfo = data.groupInfo
	    self.parentCtrl = data.parentCtrl
	    self.Parameter.MercenaryTalentCell.LuaUIGroup.gameObject:SetActiveEx(false)
	    self.isLocked = self.mercenaryInfo.level < self.talentInfo.lockLevel
	    self.Parameter.Lock:SetActiveEx(self.isLocked)
	    self.Parameter.Study:SetActiveEx(not self.isLocked)
	    self.Parameter.TalentImg:SetActiveEx(not self.isLocked)
	    self.Parameter.TalentDetailScroll:SetActiveEx(not self.isLocked)
	    self.Parameter.StudyText:SetActiveEx(not self.isLocked)
	    self.Parameter.Detail:SetActiveEx(not self.isLocked)
	    self.Parameter.LockText.LabText = Lang("MERCENARY_LEVEL_LOCK", self.talentInfo.lockLevel)
	    local l_data = {}
	    --生效的天赋信息
	    self.effectTalentInfo = nil
	    for i = 1, #self.talentInfo.talents do
	        table.insert(l_data, {talent = self.talentInfo.talents[i], groupInfo = self.groupInfo, parentCtrl = self, onlyRefreshData = data.onlyRefreshData})
	        if self.talentInfo.talents[i].talentBaseId == self.groupInfo.selectedTalentBaseId then
	            self.effectTalentInfo = self.talentInfo.talents[i]
	        end
	    end
	    if not self.talentTemplatePool then
	        self.talentTemplatePool = self:NewTemplatePool({
	            UITemplateClass = UITemplate.MercenaryTalentCellTemplate,
	            TemplatePrefab = self.Parameter.MercenaryTalentCell.LuaUIGroup.gameObject,
	            TemplateParent = self.Parameter.TalentDetailContent.transform,
	        })
	    end
	    self.talentTemplatePool:ShowTemplates({Datas = l_data})
	    if self.effectTalentInfo then
	        self.Parameter.Study:SetActiveEx(false)
	        self.Parameter.TalentImg:SetActiveEx(true)
	        self.Parameter.TalentImg:SetSprite(self.effectTalentInfo.tableInfo.IconAtlas, self.effectTalentInfo.tableInfo.Icon)
	        self.Parameter.NameText.LabText = self.effectTalentInfo.tableInfo.Name
	        self.Parameter.DesText.LabText = self.effectTalentInfo.tableInfo.Description
	        if self.effectTalentInfo.tableInfo.Sign == 2 then
	            self.Parameter.LevelText.LabText = "Lv.Max"
	        else
	            self.Parameter.LevelText.LabText = "Lv." .. self.groupInfo.level
	        end
	    else
	        self.Parameter.Study:SetActiveEx(true)
	        self.Parameter.TalentImg:SetActiveEx(false)
	    end
	    --设置等级图标
	    self.Parameter.TalentLvMax:SetActiveEx(self.effectTalentInfo and self.effectTalentInfo.tableInfo.Sign == 2)
	    self.Parameter.TalentLvMax:SetGray(self.selectedTalentInfo and not self.selectedTalentInfo.isStudied)
	    if not self.talentLvComs then
	        self.talentLvComs = { self.Parameter.TalentLv1, self.Parameter.TalentLv2, self.Parameter.TalentLv3, self.Parameter.TalentLv4 }
	    end
	    local l_lvIndex = 0
	    if self.effectTalentInfo then
	        l_lvIndex = self.effectTalentInfo.tableInfo.ID % 10
	    end
	    for i, com in ipairs(self.talentLvComs) do
	        com:SetActiveEx(i == l_lvIndex)
	        com:SetGray(self.selectedTalentInfo and not self.selectedTalentInfo.isStudied)
	    end
	    if data.onlyRefreshData then
	        self:SetSelected(self.isSelected)
	    else
	        self:SetSelected(false)
	    end
	    --设置红点
	    self.Parameter.RedSign:SetActiveEx(self.mercenaryInfo.outTime ~= 0 and not self.isLocked and not MgrMgr:GetMgr("MercenaryMgr").IsTalentRedSignClicked(self.mercenaryInfo.tableInfo.Id, self.talentInfo.lockLevel))
	
end --func end
--next--
function MercenaryTalentInfoTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MercenaryTalentInfoTemplate:RefreshIconColor()
    if not self.iconColors then
        self.iconColors = {RoColor.BgColor.None, RoColor.BgColor.Green, RoColor.BgColor.Blue, RoColor.BgColor.Purple, RoColor.BgColor.Yellow}
    end
    local l_colorIndex = 0
    if self.effectTalentInfo then
        l_colorIndex = self.effectTalentInfo.tableInfo.ID % 10
    end
    local l_color = self.iconColors[l_colorIndex+1]
    if l_color then
        self.Parameter.Icon.Img.color = RoColor.Hex2Color(l_color)
    end
end

function MercenaryTalentInfoTemplate:HandleTalentCellClicked(talentCellTemplate)
    self.parentCtrl:HandleTalentCellClicked(talentCellTemplate)
end

function MercenaryTalentInfoTemplate:SetSelected(isSelected)
    --if self.isSelected == isSelected then return end
    self.isSelected = isSelected


    if isSelected and self.effectTalentInfo ~= nil then
        if self.selectEffectId then
            self.Parameter.SelectEffect:SetActiveEx(true)
        else
            self:PlaySelectEffect()
        end
    else
        self.Parameter.SelectEffect:SetActiveEx(false)
    end

    self.Parameter.Select:SetActiveEx(false)
    if self.isSelected then
        self.Parameter.TalentDetailScroll:SetActiveEx(true)
        self.Parameter.StudyText:SetActiveEx(false)
        self.Parameter.Detail:SetActiveEx(false)
        --选中当前生效的天赋
        local l_found = self.talentTemplatePool:FindShowTem(function(template)
            if self.effectTalentInfo and template.talent.talentBaseId == self.effectTalentInfo.talentBaseId then
                return true
            end
            return false
        end)
        if not l_found then
            l_found = self.talentTemplatePool:GetItem(1)
        end
        if l_found then
            l_found:HandleTalentCellClicked()
        end
        self.Parameter.Lock:SetActiveEx(false)
    else
        self.Parameter.Lock:SetActiveEx(self.isLocked)
        self.Parameter.TalentDetailScroll:SetActiveEx(false)
        if self.effectTalentInfo then
            self.Parameter.StudyText:SetActiveEx(false)
            self.Parameter.Detail:SetActiveEx(true and not self.isLocked)
        else
            self.Parameter.StudyText:SetActiveEx(true and not self.isLocked)
            self.Parameter.Detail:SetActiveEx(false)
        end
    end
end

function MercenaryTalentInfoTemplate:PlaySelectEffect()
    if self.selectEffectId then return end
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.SelectEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1,1,1)
    self.selectEffectId = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_YongBing_TianFuAnNiuHuanRao_01", l_fxData)
    
    self.Parameter.SelectEffect:SetActiveEx(false)
end

function MercenaryTalentInfoTemplate:DestroySelectEffect()
    if self.selectEffectId then
        self:DestroyUIEffect(self.selectEffectId)
        self.selectEffectId = nil
    end
end
--lua custom scripts end
return MercenaryTalentInfoTemplate