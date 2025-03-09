--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ProbabilityInfoPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ProbabilityInfoCtrl = class("ProbabilityInfoCtrl", super)
--lua class define end

--lua functions
function ProbabilityInfoCtrl:ctor()

    super.ctor(self, CtrlNames.ProbabilityInfo, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = UI.CtrlNames.ProbabilityInfo
    self.IsCloseOnSwitchScene = true
end --func end
--next--
function ProbabilityInfoCtrl:Init()

    self.panel = UI.ProbabilityInfoPanel.Bind(self)
    super.Init(self)
    self.panel.Btn_Close:AddClickWithLuaSelf(self.CloseSelf, self)
    self.BlockTemPool = nil
end --func end
--next--
function ProbabilityInfoCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.BlockTemPool = nil
end --func end
--next--
function ProbabilityInfoCtrl:OnActive()
    self.data = self.uiPanelData.showDatas
    self.QAText = self.uiPanelData.QaText
    self.panel.Btn_Question.Listener:SetActionClick(self.ShowQuestionTip, self)
    local hrefStr = StringEx.Format("<a href=URL@@{0}>{1}</a>", self.uiPanelData.Url, self.uiPanelData.UrlName)
    self.panel.UrlText.LabText = hrefStr
    self.panel.UrlText:GetRichText().onHrefClick:AddListener(function(hrefName)
        MgrMgr:GetMgr("CapraFAQMgr").ParsHref(hrefName)
    end)
    if not self.BlockTemPool then
        self.BlockTemPool = self:NewTemplatePool({
            TemplateClassName = "ProbablityBlockTem",
            TemplatePrefab = self.panel.ProbablityBlockTem.gameObject,
            ScrollRect = self.panel.ScrollRect.LoopScroll
        })
    end
    self.BlockTemPool:ShowTemplates({ Datas = self.data })
end --func end
--next--
function ProbabilityInfoCtrl:OnDeActive()


end --func end
--next--
function ProbabilityInfoCtrl:Update()


end --func end
--next--
function ProbabilityInfoCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

function ProbabilityInfoCtrl:CloseSelf()
    UIMgr:DeActiveUI(UI.CtrlNames.ProbabilityInfo)
end

function ProbabilityInfoCtrl:ShowQuestionTip(go, eventData)
    local l_anchor = Vector2.New(0.5, 1)
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(self.QAText, eventData, l_anchor, true)
end

--lua custom scripts end
return ProbabilityInfoCtrl