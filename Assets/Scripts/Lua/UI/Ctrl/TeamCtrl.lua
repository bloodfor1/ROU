--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamPanel"



--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamCtrl = class("TeamCtrl", super)
--lua class define end

--lua functions
function TeamCtrl:ctor()

    super.ctor(self, "Team", UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function TeamCtrl:Init()
    self.panel = UI.TeamPanel.Bind(self)
	super.Init(self)
    self.panel.ButtonClose:AddClick(function ()
        UIMgr:DeActiveUI("Team")
    end)
end --func end

function TeamCtrl:SetupHandlers()
    local l_handlerTb = {
        {HandlerNames.TeamMember, Lang("TEAM_TEAMMEMBER"),"CommonIcon","UI_CommonIcon_Tab_zuduichengyuan_01.png","UI_CommonIcon_Tab_zuduichengyuan_02.png"},
        {HandlerNames.TeamApply, Lang("TEAM_ASKLIST"),"CommonIcon","UI_CommonIcon_Tab_zuduishenqing_01.png","UI_CommonIcon_Tab_zuduishenqing_02.png"}
    }
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, false)
end

--next--
function TeamCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function TeamCtrl:OnActive()
	UIMgr:DeActiveUI(UI.CtrlNames.TeamInvite)
    if MgrMgr:GetMgr("RedSignMgr").IsRedSignShow(eRedSignKey.TeamApply) then
        self:SelectOneHandler(HandlerNames.TeamApply)
    else
        self:SelectOneHandler(HandlerNames.TeamMember)
    end

    self.RedSignProcessorTeamApply=self:NewRedSign({
        Key=eRedSignKey.TeamApply,
        RedSignParent = self:GetHandlerByName(HandlerNames.TeamApply).toggle:GetComponent("MLuaUICom").Transform:Find("RedSignParent"),
        ClickTogEx = self:GetHandlerByName(HandlerNames.TeamApply).toggle:GetComponent("MLuaUICom"),
        OnRedSignShow = function(template, redTableInfo, redCounts)
            if self.curHandler.name==HandlerNames.TeamApply then
                local l_currentRedCount=0
                for i = 1, #redCounts do
                    l_currentRedCount=l_currentRedCount+redCounts[i]
                end
                if l_currentRedCount>0 then

                    template:ShowRedSign(redTableInfo,{0})
                end
            end

        end
    })
end --func end
--next--
function TeamCtrl:OnDeActive()
    if self.RedSignProcessorTeamApply ~= nil then
        self:UninitRedSign(self.RedSignProcessorTeamApply)
        self.RedSignProcessorTeamApply = nil
    end
end --func end
--next--
function TeamCtrl:Update()
    super.Update(self)
end --func end


--next--
function TeamCtrl:BindEvents()
    local TeamInfoUpdate = function()
        self:SetTeamAskList()
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher,DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE,TeamInfoUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts
function TeamCtrl:OnHandlerActive(handlerName)

end

function TeamCtrl:IsHandlerActived(name)
	return self:IsHandlerActive(name)
end

function TeamCtrl:SetTeamAskList()
    local selfInTeam,selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
    if self.panel and self.handlers[UI.HandlerNames.TeamApply].toggle.UObj then
        if not selfIsCaptain then
            self.handlers[UI.HandlerNames.TeamApply].toggle.UObj:SetActiveEx(false)
        else
            self.handlers[UI.HandlerNames.TeamApply].toggle.UObj:SetActiveEx(true)
        end
    end
end

return TeamCtrl
--lua custom scripts end