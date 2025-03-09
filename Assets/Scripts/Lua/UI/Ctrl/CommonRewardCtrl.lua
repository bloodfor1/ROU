--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CommonRewardPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CommonRewardCtrl = class("CommonRewardCtrl", super)
--lua class define end

--lua functions
function CommonRewardCtrl:ctor()

    super.ctor(self, CtrlNames.CommonReward, UILayer.Function, nil, ActiveType.None)

end --func end
--next--
function CommonRewardCtrl:Init()

    self.panel = UI.CommonRewardPanel.Bind(self)
    super.Init(self)
    --消耗品
    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })

    self.panel.ContinueBtn:AddClick(function ()
        if self.onContinue then
            self.onContinue()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.CommonReward)
    end)

    self.panel.CloseBtn:AddClick(function ()
        if self.delayConfirm then
            self.delayConfirm()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.CommonReward)
    end)
end --func end
--next--
function CommonRewardCtrl:Uninit()
    self.onContinue = nil
    self.delayConfirm = nil
    self.itemPool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CommonRewardCtrl:OnActive()


end --func end
--next--
function CommonRewardCtrl:OnDeActive()


end --func end
--next--
function CommonRewardCtrl:Update()


end --func end



--next--
function CommonRewardCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function CommonRewardCtrl:SetDlgInfo(title, rewardDatas, continueFuc, closeFuc)
    self.onContinue = continueFuc
    self.delayConfirm = closeFuc
    self.panel.Title.LabText = title or ""
    self.itemPool:ShowTemplates({Datas = rewardDatas, Parent = self.panel.ItemParent.transform})
end
--lua custom scripts end
