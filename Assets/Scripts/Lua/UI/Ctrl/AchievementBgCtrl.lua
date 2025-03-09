--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementBgPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
AchievementBgCtrl = class("AchievementBgCtrl", super)
--lua class define end

--lua functions
function AchievementBgCtrl:ctor()

    super.ctor(self, CtrlNames.AchievementBg, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function AchievementBgCtrl:Init()

    self.panel = UI.AchievementBgPanel.Bind(self)
    super.Init(self)

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AchievementBg)
    end)

    self._achievementPandectRedSign=nil
    self._achievementItemRedSign=nil

end --func end
--next--
function AchievementBgCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end

function AchievementBgCtrl:SetupHandlers()
    local l_handlerTb = {{HandlerNames.AchievementPandect, Lang("Achievement_Pandect")},{HandlerNames.Achievement, Lang("Achievement")}}
    local l_defaultHandlerName=self:_getDefaultHandlerName()
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, l_defaultHandlerName)
end

--next--
function AchievementBgCtrl:OnActive()

    local l_defaultHandlerName=self:_getDefaultHandlerName()
    self:SelectOneHandler(l_defaultHandlerName)

    MgrMgr:GetMgr("AchievementMgr").RequestAchieveInfo()

    self._achievementPandectRedSign=self:GetHandlerByName(HandlerNames.AchievementPandect).toggle.transform:Find("OFF/RedSignPrompt")
    self._achievementItemRedSign=self:GetHandlerByName(HandlerNames.Achievement).toggle.transform:Find("OFF/RedSignPrompt")
    self:_showRedSign()
end --func end
--next--
function AchievementBgCtrl:OnDeActive()


end --func end
--next--
function AchievementBgCtrl:Update()
    self.curHandler:Update()
end --func end

--next--
function AchievementBgCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AchievementMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").AchievementGetBadgeRewardEvent, function()
        self:_showRedSign()
    end)
    self:BindEvent(MgrMgr:GetMgr("AchievementMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").AchievementGetItemRewardEvent, function()
        self:_showRedSign()
    end)
end --func end

--next--
--lua functions end

--lua custom scripts
function AchievementBgCtrl:_showRedSign()

    if MgrMgr:GetMgr("AchievementMgr").IsHaveBadgeAward() then
        self._achievementPandectRedSign.gameObject:SetActiveEx(true)
    else
        self._achievementPandectRedSign.gameObject:SetActiveEx(false)
    end

    if MgrMgr:GetMgr("AchievementMgr").IsHaveCanAwardAchievementSelf() then
        self._achievementItemRedSign.gameObject:SetActiveEx(true)
    else
        self._achievementItemRedSign.gameObject:SetActiveEx(false)
    end


end

function AchievementBgCtrl:_getDefaultHandlerName()
    local l_defaultHandlerName
    if MgrMgr:GetMgr("AchievementMgr").IsShowBadgePanel then
        l_defaultHandlerName=HandlerNames.AchievementPandect
    else
        l_defaultHandlerName=HandlerNames.Achievement
    end
    return l_defaultHandlerName
end

return AchievementBgCtrl
--lua custom scripts end
