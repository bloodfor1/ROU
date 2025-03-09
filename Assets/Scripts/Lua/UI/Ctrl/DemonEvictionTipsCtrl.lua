--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DemonEvictionTipsPanel"
require "UI/Template/DemonEvictionTipsTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
DemonEvictionTipsCtrl = class("DemonEvictionTipsCtrl", super)
--lua class define end

--lua functions
function DemonEvictionTipsCtrl:ctor()
    
    super.ctor(self, CtrlNames.DemonEvictionTips, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
    
end --func end
--next--
function DemonEvictionTipsCtrl:Init()
    
    self.panel = UI.DemonEvictionTipsPanel.Bind(self)
    super.Init(self)
    
    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

    self.aboveTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DemonEvictionTipsTemplate,
        TemplateParent = self.panel.AboveContent.transform,
        TemplatePrefab = self.panel.DemonEvictionTipsTemplate.gameObject,
    })

    self.belowTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DemonEvictionTipsTemplate,
        TemplateParent = self.panel.BelowContent.transform,
        TemplatePrefab = self.panel.DemonEvictionTipsTemplate.gameObject,
    })
end --func end
--next--
function DemonEvictionTipsCtrl:Uninit()
    
    self.aboveTemplatePool = nil
    self.belowTemplatePool = nil

    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function DemonEvictionTipsCtrl:OnActive()
    self:DemonEvictionTipsPanelRefresh()
end --func end
--next--
function DemonEvictionTipsCtrl:OnDeActive()
    
    
end --func end
--next--
function DemonEvictionTipsCtrl:Update()
    
    
end --func end




--next--
function DemonEvictionTipsCtrl:BindEvents()
    
    
end --func end

--next--
--lua functions end

--lua custom scripts
--next--
function DemonEvictionTipsCtrl:DemonEvictionTipsPanelRefresh()
    
    local l_rate = MGlobalConfig:GetInt("BlessBaseExpAddition") + 1

    local l_aboveConfig, l_belowConfig = {}, {}
    for i, v in ipairs(string.ro_split(MGlobalConfig:GetString("BlessExpExtraAdditionConfig"), "|")) do
        local l_ret = string.ro_split(v, "=")
        if #l_ret ~= 4 then
            logError("GlobalTable BlessExpExtraAdditionConfig配置错误，数量不匹配@陈阳", v)
        else
            local l_min = tonumber(l_ret[1])
            local l_aboveRet = l_min > 0 
            
            local l_tbl = l_aboveRet and l_aboveConfig or l_belowConfig
            if #l_tbl < 4 then
                table.insert(l_tbl, {
                    above = l_aboveRet,
                    min = math.abs(l_min),
                    max = math.abs(tonumber(l_ret[2])),
                    baseExp = tonumber(l_ret[3]),
                    addinExp = tonumber(l_ret[4]),
                    rate = l_rate,
                })
            end
        end
    end

    self.aboveTemplatePool:ShowTemplates({Datas = l_aboveConfig})
    self.belowTemplatePool:ShowTemplates({Datas = l_belowConfig})

    local l_blessInfo = MgrMgr:GetMgr("DailyTaskMgr").blessInfo
    local l_count1, l_count2 = 0, 0
    if l_blessInfo then
        local l_RepelMonsterItemInfos = {}
        local function GetKillCount(monId)
            local num = 0
            for i, info in ipairs(l_blessInfo.monsters) do
                if info.monster_id == monId then
                    num = info.kill_num
                    break
                end
            end
            return num
        end
 
        l_count1 = GetKillCount(MGlobalConfig:GetInt("ExpAwardID"))
        l_count2 = GetKillCount(MGlobalConfig:GetInt("JewelryAwardID"))
    end
    
    self.panel.ExperienceStrange.LabText = Lang("DEMON_EVICTION_TIPS_FORMAT3", l_count1)
    self.panel.TreasureChest.LabText = Lang("DEMON_EVICTION_TIPS_FORMAT4", l_count2)
    self.panel.Desc.LabText = Lang("EXPEL_QUESTION_TIPS")
end --func end
--lua custom scripts end
return DemonEvictionTipsCtrl