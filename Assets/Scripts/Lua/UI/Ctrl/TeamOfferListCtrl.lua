--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamOfferListPanel"
-- 获取头像用
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamOfferListCtrl = class("TeamOfferListCtrl", super)
--lua class define end

--lua functions
function TeamOfferListCtrl:ctor()

    super.ctor(self, CtrlNames.TeamOfferList, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
local m_item = {}
--next--
function TeamOfferListCtrl:Init()
    self.panel = UI.TeamOfferListPanel.Bind(self)
    super.Init(self)
    self:InintContent()

    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamOfferList)
    end)
    self.hasInit = true
end --func end
--next--
function TeamOfferListCtrl:Uninit()
    m_item = {}

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function TeamOfferListCtrl:OnActive()

end --func end
--next--
function TeamOfferListCtrl:OnDeActive()
    self.hasInit = false
end --func end
--next--
function TeamOfferListCtrl:Update()
    if self.hasInit then
        for z = 1, table.maxn(DataMgr:GetData("TeamData").TeamInviteList) do
            local TeamInviteList = DataMgr:GetData("TeamData").TeamInviteList
            if TeamInviteList[1].remainTime > 0 then
                self:RefreshByData(TeamInviteList)
                TeamInviteList[z].remainTime = TeamInviteList[z].remainTime - UnityEngine.Time.deltaTime
            else
                table.remove(TeamInviteList, 1)
                if table.maxn(TeamInviteList) == 0 then
                    UIMgr:DeActiveUI(UI.CtrlNames.TeamOfferList)
                    UIMgr:DeActiveUI(UI.CtrlNames.TeamOffer)
                end
                break
            end
        end
    end
end --func end

--next--
function TeamOfferListCtrl:BindEvents()
    local SelfInTeamFunc = function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamOfferList)
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_SELF_IN_TEAM, SelfInTeamFunc)
end --func end
--next--
--lua functions end

--lua custom scripts
function TeamOfferListCtrl:RefreshByData(data)
    if data then
        self.ContentData = data
        self.TeamContent:SetContentCount(table.maxn(self.ContentData))
    end
end

function TeamOfferListCtrl:InintContent()
    self.TeamContent = self.panel.TeamContent.gameObject:GetComponent("UIWrapContent")
    self.TeamContent:InitContent()
    local l_count = 0
    self.TeamContent.updateOneItem = function(obj, index)
        if m_item[index] == nil then
            m_item[index] = {}
            self:SetTeamList(m_item[index], obj)
        end
        if self.ContentData[index + 1] then
            self:SetTeamListByData(m_item[index], self.ContentData[index + 1])
        end
    end
    self.TeamContent:SetContentCount(l_count)
end

local teamMaxSize = 5
function TeamOfferListCtrl:SetTeamList(element, obj)
    element.ui = obj
    element.nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("TeamName"))
    element.lvLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("TeamLv"))
    element.targetLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("TeamTarget"))
    --element.capLvLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("TeamInfoList/Lv"))
    element.capNameLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("TeamInfoList/CapName"))
    element.HeadDummy = element.ui.transform:Find("TeamInfoList/HeadDummy"):GetComponent("MLuaUICom")
    element.HeadComp = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = element.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
    element.imgTb = {}
    -- 第一个是队长，做在了头像里面
    for i = 2, teamMaxSize do
        element.imgTb[i] = element.ui.transform:Find("TeamInfoList/BG" .. i):GetComponent("MLuaUICom")
    end

    element.btnApply = element.ui.transform:Find("BtnApply"):GetComponent("MLuaUICom")
    element.btnTxt = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("BtnApply/Text"))
end

function TeamOfferListCtrl:SetTeamListByData(item, data)
    item.nameLab.LabText = data.teamSetting.name --队伍名
    item.capNameLab.LabText = data.inviterName
    --item.capLvLab.LabText = data.inviterLv
    item.targetLab.LabText = Common.Utils.Lang("TEAM_TARGET") .. DataMgr:GetData("TeamData").GetTargetNameById(data.teamSetting.target)
    local index = 2
    for i = 1, teamMaxSize do
        if data.memberList[i] then
            if data.memberList[i].roleId == data.inviterId then
                local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.memberList[i].roleBriefInfo)
                ---@type HeadTemplateParam
                local param = {
                    EquipData = equipData,
                    ShowProfession = true,
                    Profession = data.memberList[i].roleType
                }

                item.HeadComp:SetData(param)
            else
                local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(data.memberList[i].roleType)
                if imageName then
                    item.imgTb[index]:SetSpriteAsync("Common", imageName)
                    index = index + 1
                end
            end
        else
            item.imgTb[i]:SetSpriteAsync("Common", "UI_Common_Toggle_02a.png")
        end
    end
    --邀请-->加入
    if data.isInvate then
        item.btnTxt.LabText = Common.Utils.Lang("AGREE_TEAMOFFER", math.floor(data.remainTime))
        item.btnApply:AddClick(function()
            MgrMgr:GetMgr("TeamMgr").AcceptTeamInvatationByTeamInfo(data)
        end)
    end

    --推荐-->申请
    if data.isRecommend then
        item.btnTxt.LabText = Common.Utils.Lang("APPLY_TEAMOFFER", math.floor(data.remainTime))
        item.btnApply:AddClick(function()
            MgrMgr:GetMgr("TeamMgr").BegInTeamByTeamId(data.teamId)
            data.remainTime = DataMgr:GetData("TeamData").TotalTime --重置倒计时
            data.isRecommend = false
            data.isWaitCaptain = true
            item.btnTxt.LabText = Common.Utils.Lang("WAIT_AGREE_TEAMOFFER", math.floor(data.remainTime))
            item.btnApply:AddClick(function()

            end)
        end)
    end

    if data.isWaitCaptain then
        item.btnTxt.LabText = Common.Utils.Lang("WAIT_AGREE_TEAMOFFER", math.floor(data.remainTime))
        item.btnApply:AddClick(function()

        end)
    end
end

return TeamOfferListCtrl
--lua custom scripts end
