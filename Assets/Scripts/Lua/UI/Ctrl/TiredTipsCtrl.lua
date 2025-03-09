--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TiredTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
ExtraFightStatus = GameEnum.ExtraFightStatus
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TiredTipsCtrl = class("TiredTipsCtrl", super)
--lua class define end

--lua functions
function TiredTipsCtrl:ctor()

	super.ctor(self, CtrlNames.TiredTips, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function TiredTipsCtrl:Init()

	self.panel = UI.TiredTipsPanel.Bind(self)
	super.Init(self)
    self.panel.infoBtn:AddClick(function()
        local l_openSysMgr=MgrMgr:GetMgr("OpenSystemMgr")
        if not l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.MonsterExpel) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_openSysMgr.GetOpenSystemTipsInfo(l_openSysMgr.eSystemId.MonsterExpel))
            return
        end
        UIMgr:ActiveUI(UI.CtrlNames.MonsterRepel, function(ctrl)
            ctrl:SetAutoShowQuestionTip(true)
        end)
    end)
    self.panel.closeBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TiredTips)
    end)
end --func end
--next--
function TiredTipsCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function TiredTipsCtrl:OnActive()

end --func end
--next--
function TiredTipsCtrl:OnDeActive()


end --func end
--next--
function TiredTipsCtrl:Update()


end --func end

--next--
function TiredTipsCtrl:OnLogout()
    UIMgr:DeActiveUI(UI.CtrlNames.TiredTips)
end --func end

--next--
function TiredTipsCtrl:BindEvents()

    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher,l_logoutMgr.OnLogoutEvent, self.OnLogout)
	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function TiredTipsCtrl:UpdateNotice(extraFightStatus)
    local str = ""
    local extraFightTime = MPlayerInfo.ExtraFightTime
    --if extraFightStatus == ExtraFightStatus.tired then
    --    str = Lang("EXTRA_FIGHTTIME_TIP_TIRED", math.floor(extraFightTime/60/1000))
    --else
    if extraFightStatus == ExtraFightStatus.exhaust then
        str = Lang("EXTRA_FIGHTTIME_TIP_EXHAUST", math.floor(extraFightTime/60/1000))
    end
    self.panel.content.LabText = str
    self.panel.PanelRef.transform:SetAsLastSibling()
end
--lua custom scripts end
