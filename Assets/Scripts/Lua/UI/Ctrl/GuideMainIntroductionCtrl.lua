--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuideMainIntroductionPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuideMainIntroductionCtrl = class("GuideMainIntroductionCtrl", super)
--lua class define end

--lua functions
function GuideMainIntroductionCtrl:ctor()

    super.ctor(self, CtrlNames.GuideMainIntroduction, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function GuideMainIntroductionCtrl:Init()

    self.panel = UI.GuideMainIntroductionPanel.Bind(self)
	super.Init(self)

    for i = 1, #self.panel.Arrow do
        MLuaClientHelper.PlayFxHelper(self.panel.Arrow[i].UObj)
    end

    self.panel.BtnNext:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuideMainIntroduction)
        MgrMgr:GetMgr("BeginnerGuideMgr").OnOneGuideOver()
    end)

end --func end
--next--
function GuideMainIntroductionCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuideMainIntroductionCtrl:OnActive()


end --func end
--next--
function GuideMainIntroductionCtrl:OnDeActive()


end --func end
--next--
function GuideMainIntroductionCtrl:Update()


end --func end





--next--
function GuideMainIntroductionCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
