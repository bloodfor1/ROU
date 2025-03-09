--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamOfferPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamOfferCtrl = class("TeamOfferCtrl", super)
--lua class define end

--lua functions
function TeamOfferCtrl:ctor()
	super.ctor(self, "TeamOffer", UILayer.Tips, nil, ActiveType.Standalone)
end --func end
--next--
function TeamOfferCtrl:Init()
    self.hasInit = true
    self.panel = UI.TeamOfferPanel.Bind(self)
	super.Init(self)

    self.panel.ButtonClose:AddClick(function ()
        DataMgr:GetData("TeamData").HidTeamInvite()
    end)

    self.panel.Btnspread:AddClick(function ()
        UIMgr:ActiveUI(UI.CtrlNames.TeamOfferList,function (ctrl)
            local data = DataMgr:GetData("TeamData").TeamInviteList
            ctrl:RefreshByData(data)
        end)
        UIMgr:DeActiveUI(UI.CtrlNames.TeamOffer)
    end)

end --func end
--next--
function TeamOfferCtrl:Uninit()
    super.Uninit(self)
	self.panel = nil
end --func end
--next--
function TeamOfferCtrl:OnActive()

    if table.maxn(DataMgr:GetData("TeamData").TeamInviteList) <=0 then
        UIMgr:DeActiveUI("TeamOffer")
        return
    end

    self:InitOfferPanel()
end --func end
--next--
function TeamOfferCtrl:OnDeActive()
    self.hasInit = false
end --func end
--next--
function TeamOfferCtrl:Update()
	for z=1,table.maxn(DataMgr:GetData("TeamData").TeamInviteList) do
        local TeamInviteList = DataMgr:GetData("TeamData").TeamInviteList
        if TeamInviteList[1].remainTime > 0 then
            self:RefreshNowTime(DataMgr:GetData("TeamData").TotalTime,TeamInviteList[1].remainTime)
        else
            table.remove(TeamInviteList,1)
            if table.maxn(DataMgr:GetData("TeamData").TeamInviteList) > 0 then
                if self.hasInit then
                    self:InitOfferPanel()
                end
            else
                UIMgr:DeActiveUI("TeamOffer")
            end
            break
        end
        TeamInviteList[z].remainTime = TeamInviteList[z].remainTime - UnityEngine.Time.deltaTime
    end
end --func end

--next--
function TeamOfferCtrl:BindEvents()
    --刷新邀请列表按钮事件绑定
    local OnAddNewMemberFunc = function()
        self:ShowMoreOfferBtnBtState(true)
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher,DataMgr:GetData("TeamData").ON_ADD_NEW_INVATION,OnAddNewMemberFunc)
    --组队信息变更
    local SelfInTeamFunc = function()
        UIMgr:DeActiveUI("TeamOffer")
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher,DataMgr:GetData("TeamData").ON_SELF_IN_TEAM,SelfInTeamFunc)
end --func end
--next--
--lua functions end

--lua custom scripts
function TeamOfferCtrl:RefreshNowTime(totalTime, remainTime)
	if self.hasInit and self:IsShowing() then
		self.panel.Slider.Slider.value = remainTime/totalTime
	end
end

function TeamOfferCtrl:ShowMoreOfferBtnBtState(state)
    if self.panel ~= nil then
        self.panel.Btnspread.gameObject:SetActiveEx(state)
    end
end

function TeamOfferCtrl:GetCaptainLevel()
    local teamInfo  = DataMgr:GetData("TeamData").GetInvitationTeamInfo()
    local captainId = teamInfo.captainId
    for i = 1, table.maxn(teamInfo.memberList) do
        if teamInfo.memberList[i].roleId == captainId then
            return teamInfo.memberList[i].roleLevel
        end
    end
    return 0
end

function TeamOfferCtrl:InitOfferPanel()
    local teamInfo = DataMgr:GetData("TeamData").GetInvitationTeamInfo()
    if teamInfo == nil then
       return
    end
    self.panel.Slider.Slider.value = teamInfo.remainTime/DataMgr:GetData("TeamData").TotalTime
	if teamInfo then
		self.panel.TextName.LabText = teamInfo.inviterName or teamInfo.captainName
        self.panel.CaptainLv.LabText = "Lv "..self:GetCaptainLevel()
		for i = 1, 5 do
			if i <= table.maxn(teamInfo.memberList) then
				local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(teamInfo.memberList[i].roleType)
				if imageName then
					self.panel["BG" .. i]:SetSpriteAsync("Common", imageName)
				end
			else
				self.panel["BG" .. i]:SetSpriteAsync("Common", "UI_Common_Toggle_02a.png")
			end
		end

        --邀请-->加入
        if teamInfo.isInvate then
            self.panel.ButtonJoinTxt.LabText = Common.Utils.Lang("JOIN_TEAMOFFER")
            self.panel.TextInfo.LabText = Common.Utils.Lang("INVATE_IN_TEAM")
            self.panel.ButtonJoin:AddClick(function ()
                MgrMgr:GetMgr("TeamMgr").AcceptTeamInvatationByTeamInfo(teamInfo)
            end)
        end

        --推荐-->申请
        if teamInfo.isRecommend then
            self.panel.ButtonJoinTxt.LabText = Common.Utils.Lang("JOIN_TEAMOFFER_CAPTAIN_AGREE")
            self.panel.TextInfo.LabText = Common.Utils.Lang("RECOMMEND_TEAMOFFER")
            self.panel.ButtonJoin:AddClick(function ()
                MgrMgr:GetMgr("TeamMgr").BegInTeamByTeamId(teamInfo.teamId)
                teamInfo.isRecommend = false
                self:SetToWaitCaptain(teamInfo)
            end)
        end

        --等待队长-->等待队长同意
        if teamInfo.isWaitCaptain then
            self.panel.ButtonJoinTxt.LabText = Common.Utils.Lang("WAIT_CAPTAIN_AGREE_TEAMOFFER")
            self.panel.ButtonJoin:AddClick(function ()

            end)
        end
	end

    if table.maxn(DataMgr:GetData("TeamData").TeamInviteList) > 1 then
        self:ShowMoreOfferBtnBtState(true)
    else
        self:ShowMoreOfferBtnBtState(false)
    end
end

--设置当前的按钮为等待队长同意
function TeamOfferCtrl:SetToWaitCaptain(teamdata)
    teamdata.remainTime = DataMgr:GetData("TeamData").TotalTime --重置倒计时
    teamdata.isWaitCaptain = true
    self.panel.ButtonJoinTxt.LabText = Common.Utils.Lang("WAIT_CAPTAIN_AGREE_TEAMOFFER")
    self.panel.ButtonJoin:AddClick(function ()

    end)
end
--lua custom scripts end
