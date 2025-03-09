--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GoalachievedPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
GoalachievedCtrl = class("GoalachievedCtrl", super)
--lua class define end

--lua functions
function GoalachievedCtrl:ctor()
	
	super.ctor(self, CtrlNames.Goalachieved, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function GoalachievedCtrl:Init()
	
	self.panel = UI.GoalachievedPanel.Bind(self)
	super.Init(self)
    self.panel.BackBtn:AddClickWithLuaSelf(function(self_param)
        UIMgr:DeActiveUI(UI.CtrlNames.Goalachieved)
    end, self)
    self.closeTimer = self:NewUITimer(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Goalachieved)
    end, 5)
    self.closeTimer:Start()
end --func end
--next--
function GoalachievedCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function GoalachievedCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.resultType then
        if self.uiPanelData.resultType == GameEnum.ESucceedFail.Succeed then
            self:Succeed()
        elseif self.uiPanelData.resultType == GameEnum.ESucceedFail.Fail then
            self:Fail()
        end
    end
end --func end
--next--
function GoalachievedCtrl:OnDeActive()
	
	
end --func end
--next--
function GoalachievedCtrl:Update()
	
	
end --func end
--next--
function GoalachievedCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GoalachievedCtrl:Succeed()
    self.panel.Succeed:SetActiveEx(true)
    self.panel.Fail:SetActiveEx(false)
    MLuaClientHelper.PlayFxHelper(self.panel.Succeed.gameObject)
end

function GoalachievedCtrl:Fail()
    self.panel.Succeed:SetActiveEx(false)
    self.panel.Fail:SetActiveEx(true)
    MLuaClientHelper.PlayFxHelper(self.panel.Fail.gameObject)
end
--lua custom scripts end
return GoalachievedCtrl