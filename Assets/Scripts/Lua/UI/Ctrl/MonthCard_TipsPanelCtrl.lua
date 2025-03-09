--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MonthCard_TipsPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_monthCardMgr = MgrMgr:GetMgr("MonthCardMgr")
--lua fields end

--lua class define
MonthCard_TipsPanelCtrl = class("MonthCard_TipsPanelCtrl", super)
--lua class define end

--lua functions
function MonthCard_TipsPanelCtrl:ctor()

    super.ctor(self, CtrlNames.MonthCard_TipsPanel, UILayer.Function, nil, ActiveType.Normal)
end --func end
--next--
function MonthCard_TipsPanelCtrl:Init()

    self.panel = UI.MonthCard_TipsPanelPanel.Bind(self)
    super.Init(self)

end --func end
--next--
function MonthCard_TipsPanelCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MonthCard_TipsPanelCtrl:OnActive()
    self.panel.Btn_Get:AddClick(function()
        UIMgr:ActiveUI(self.uiPanelData.GotoUIName)
        self.uiPanelData.MarkIsFirstFunc()
        MgrMgr:GetMgr("MonthCardMgr").PopExpiredTips()
    end)
    self.panel.Btn_Close:AddClick(function()
        self.uiPanelData.MarkIsFirstFunc()
        MgrMgr:GetMgr("MonthCardMgr").PopExpiredTips()
    end)
    self.panel.ContentText.LabText = self.uiPanelData.ContentText
    self.panel.BtnText.LabText = self.uiPanelData.BtnText
end --func end
--next--
function MonthCard_TipsPanelCtrl:OnDeActive()

end --func end
--next--
function MonthCard_TipsPanelCtrl:Update()


end --func end
--next--
function MonthCard_TipsPanelCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MonthCard_TipsPanelCtrl