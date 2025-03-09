--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SkillLevelUpgradingPanel"
require "UI/Template/SkillUpgradeItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
SkillLevelUpgradingCtrl = class("SkillLevelUpgradingCtrl", super)
--lua class define end

--lua functions
function SkillLevelUpgradingCtrl:ctor()

    super.ctor(self, CtrlNames.SkillLevelUpgrading, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function SkillLevelUpgradingCtrl:Init()

    self.panel = UI.SkillLevelUpgradingPanel.Bind(self)
    super.Init(self)

    self.panel.PanelRef:GetComponent("FxAnimationHelper"):PlayAll()
    self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
    self.data = DataMgr:GetData("SkillData")
    self.skillUpgradeItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SkillUpgradeItemTemplate,
        TemplateParent = self.panel.normalPart.transform,
        TemplatePrefab = self.panel.SkillUpgradeItemTemplate.LuaUIGroup.gameObject
    })

    self.skillUpgradeScrollItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SkillUpgradeItemTemplate,
        TemplatePrefab = self.panel.SkillUpgradeItemTemplate.LuaUIGroup.gameObject,
        ScrollRect = self.panel.scrollPart.LoopScroll
    })


    self.mask=self:NewPanelMask(BlockColor.Dark,nil,handler(self, self.OnClose))

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark, handler(self, self.OnClose))

end --func end
--next--
function SkillLevelUpgradingCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.skillUpgradeItemPool = nil
    self.skillUpgradeScrollItemPool = nil

end --func end
--next--
function SkillLevelUpgradingCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.OpenType.SetLevelUpdateData then
            self:SetLevelUpdateData(self.uiPanelData.upgrade)
        end
    end

    self.panel.SkillUpgradeItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    if self.upgradeData then
        local count = #self.upgradeData
        self.panel.scrollPart:SetActiveEx(count > 3)
        self.panel.scrollTip:SetActiveEx(count > 3)
        self.panel.normalPart:SetActiveEx(count <= 3)
        self.panel.imageUp:SetActiveEx(count > 3)
        self.panel.imageDown:SetActiveEx(count > 3)
        if count > 3 then
            self.skillUpgradeScrollItemPool:ShowTemplates({Datas = self.upgradeData})
            self.panel.scrollPart:SetLoopScrollGameObjListener(self.panel.imageUp.gameObject,
                self.panel.imageDown.gameObject, nil, nil)
            LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Content.RectTransform)
        else
            self.skillUpgradeItemPool:ShowTemplates({Datas = self.upgradeData})
        end
    end

end --func end
--next--
function SkillLevelUpgradingCtrl:OnDeActive()


end --func end
--next--
function SkillLevelUpgradingCtrl:Update()


end --func end





--next--
function SkillLevelUpgradingCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function SkillLevelUpgradingCtrl:SetLevelUpdateData(upgradeData)
    self.upgradeData = upgradeData
end

function SkillLevelUpgradingCtrl:OnClose()

    UIMgr:DeActiveUI(UI.CtrlNames.SkillLevelUpgrading)
    self.mgr.EventDispatcher:Dispatch(self.mgr.ON_SKILL_SHOW_SKILL)

end
--lua custom scripts end
return SkillLevelUpgradingCtrl

