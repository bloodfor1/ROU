--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BackCityOfferPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
BackCityOfferCtrl = class("BackCityOfferCtrl", super)
--lua class define end

--lua functions
function BackCityOfferCtrl:ctor()
	
	super.ctor(self, CtrlNames.BackCityOffer, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function BackCityOfferCtrl:Init()
    self.timeToClose = 0
    self.timeToCloseCountDown = 0
    self.langKey = ""

	
	self.panel = UI.BackCityOfferPanel.Bind(self)
	super.Init(self)

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.BackCityOffer)
    end)

    self.panel.CancelBtn:AddClick(function()
        MgrMgr:GetMgr("BackCityMgr").CancelBackCity()
        UIMgr:DeActiveUI(UI.CtrlNames.BackCityOffer)
    end)
	
end --func end
--next--
function BackCityOfferCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BackCityOfferCtrl:OnActive()
    if self.uiPanelData then
        self.timeToClose = self.uiPanelData.leftTime
        self.timeToCloseCountDown = self.uiPanelData.leftTime

        local l_severOnceSystemMgr = MgrMgr:GetMgr("ServerOnceSystemMgr")

        if self.uiPanelData.reason == l_severOnceSystemMgr.EServerOnceType.AutoRecallOnBlessOut then        -- 祝福时间消耗完毕自动回城
            self.langKey = "Auto_Recall_On_Bless_Out"
        elseif self.uiPanelData.reason == l_severOnceSystemMgr.EServerOnceType.AutoRecallOnFive then    --  每日五点自动回城的勾选项
            self.langKey = "Auto_Recall_On_Five"
        end
    end
end --func end
--next--
function BackCityOfferCtrl:OnDeActive()
	
	
end --func end
--next--
function BackCityOfferCtrl:Update()
    self.timeToCloseCountDown = self.timeToCloseCountDown - Time.deltaTime
    self.panel.Info.LabText = RoColor.FormatWord(Lang(self.langKey, math.ceil(self.timeToCloseCountDown)))
    self.panel.Slider.Slider.value = self.timeToCloseCountDown / self.timeToClose
    if self.timeToCloseCountDown <= 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.BackCityOffer)
    end
end --func end
--next--
function BackCityOfferCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BackCityOfferCtrl