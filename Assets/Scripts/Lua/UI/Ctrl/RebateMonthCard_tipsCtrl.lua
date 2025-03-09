--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RebateMonthCard_tipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
RebateMonthCard_tipsCtrl = class("RebateMonthCard_tipsCtrl", super)
--lua class define end

--lua functions
function RebateMonthCard_tipsCtrl:ctor()

    super.ctor(self, CtrlNames.RebateMonthCard_tips, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.RebateMonthCard_tips
end --func end
--next--
function RebateMonthCard_tipsCtrl:Init()

    self.panel = UI.RebateMonthCard_tipsPanel.Bind(self)
    super.Init(self)
    self.panel.Btn_cancel:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.RebateMonthCard_tips)
    end)
    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.RebateMonthCard_tips)
    end)
end --func end
--next--
function RebateMonthCard_tipsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function RebateMonthCard_tipsCtrl:OnActive()
    self.panel.Tips.LabText = Lang("REBATE_CARD_YES_NO_TIPS", self.uiPanelData.TotalDay)
    self.panel.Btn_buy:AddClick(function()
        self.uiPanelData.BuyFunc()
    end)
    self.panel.Num_Everyday.LabText = self.uiPanelData.EverydayNum
    self.panel.Num_Immediatiately.LabText = self.uiPanelData.ImmediatiatelyNum

end --func end
--next--
function RebateMonthCard_tipsCtrl:OnDeActive()


end --func end
--next--
function RebateMonthCard_tipsCtrl:Update()


end --func end
--next--
function RebateMonthCard_tipsCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RebateMonthCard_tipsCtrl