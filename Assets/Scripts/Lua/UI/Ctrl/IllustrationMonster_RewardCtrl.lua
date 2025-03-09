--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationMonster_RewardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
IllustrationMonster_RewardCtrl = class("IllustrationMonster_RewardCtrl", super)
--lua class define end

--lua functions
function IllustrationMonster_RewardCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationMonster_Reward, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function IllustrationMonster_RewardCtrl:Init()

    self.panel = UI.IllustrationMonster_RewardPanel.Bind(self)
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("IllustrationMonsterMgr")
    self.data = DataMgr:GetData("IllustrationMonsterData")
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.IllustrationMonster_Reward)
    end)
    self.RowTem = nil
end --func end
--next--
function IllustrationMonster_RewardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.RowTem = nil
    self.mgr = nil
    self.data = nil
end --func end
--next--
function IllustrationMonster_RewardCtrl:OnActive()
    if self.RowTem == nil then
        self.RowTem = self:NewTemplatePool({
            TemplateClassName = "IllustrationMonster_Reward_RowTem",
            TemplatePrefab = self.panel.IllustrationMonster_Reward_RowTem.gameObject,
            ScrollRect = self.panel.Scroll.LoopScroll,
        })
    end
    self.rewardInfo = nil
    if self.uiPanelData.openType ~= nil then
        if self.uiPanelData.openType == MonsterAwardType.MONSTER_AWARD_GROUP then
            self.rewardInfo = self.uiPanelData.data
        elseif self.uiPanelData.openType == MonsterAwardType.MONSTER_AWARD_RSEARCH then
            self.rewardInfo = self.uiPanelData.data
        end
        self.RowTem:ShowTemplates({ Datas = self.rewardInfo })
    end
end --func end
--next--
function IllustrationMonster_RewardCtrl:OnDeActive()


end --func end
--next--
function IllustrationMonster_RewardCtrl:Update()


end --func end
--next--
function IllustrationMonster_RewardCtrl:BindEvents()

end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationMonster_RewardCtrl:ShowTem()
    if self.RowTem == nil then
        self.RowTem = self:NewTemplatePool({
            TemplateClassName = "IllustrationMonster_Reward_RowTem",
            TemplatePrefab = self.panel.IllustrationMonster_Reward_RowTem.gameObject,
            ScrollRect = self.panel.Scroll.LoopScroll,
        })
    end
    self.RowTem:ShowTemplates({ Datas = self.rewardInfo })
end
--lua custom scripts end
return IllustrationMonster_RewardCtrl