--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HymnTrialEnterPanel"
require "UI/Template/ItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
HymnTrialEnterCtrl = class("HymnTrialEnterCtrl", super)
--lua class define end

local l_dungeonId = 3  --圣歌试炼在副本表中的编号 DungeonsTable
local l_teamTargetId = 4000  --圣歌试炼在组队目标表中的编号 TeamTargetTable
local l_entrustActivitiesId = 3  --圣歌试炼在委托活动表中的编号 EntrustActivitiesTable

--lua functions
function HymnTrialEnterCtrl:ctor()

    super.ctor(self, CtrlNames.HymnTrialEnter, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true

end --func end
--next--
function HymnTrialEnterCtrl:Init()

    self.panel = UI.HymnTrialEnterPanel.Bind(self)
    super.Init(self)

    --副本基础数据获取
    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonId)
    --最低等级限制获取
    local l_levelLimit = l_dungeonRow.LevelLimit
    local l_minLevel = l_levelLimit:get_Item(0)
    --最少人数获取
    local l_numLimit = l_dungeonRow.NumbersLimit
    --显示基础要求内容
    self.panel.LvTxt.LabText = "Lv."..l_minLevel
    self.panel.MemberTxt.LabText = StringEx.Format(Lang("RECOMMEND_MEMBER_NUM"), l_numLimit[0], l_numLimit[1])

    --按钮点击事件绑定
    self:ButtonClickEventAdd()

    --奖励列表项的池创建
    self.awardTemplatePool=self:NewTemplatePool({
        UITemplateClass=UITemplate.ItemTemplate,
        ScrollRect=self.panel.AwardView.LoopScroll
    })

    --剩余奖励次数回调事件绑定
    local finishTime, maxTime = MgrMgr:GetMgr("DelegateModuleMgr").GetDelegateTimesInfo(GameEnum.Delegate.activity_Trial)
    self.panel.AwardCountTxt.LabText = StringEx.Format("{0}/{1}", finishTime, maxTime)

    --请求奖励预览
    local l_entrustActivitiesInfo = TableUtil.GetEntrustActivitiesTable().GetRowByMajorID(l_entrustActivitiesId)
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_entrustActivitiesInfo.RewardID)

end --func end
--next--
function HymnTrialEnterCtrl:Uninit()

    --奖励列表池释放
    self.awardTemplatePool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function HymnTrialEnterCtrl:OnActive()

end --func end
--next--
function HymnTrialEnterCtrl:OnDeActive()

end --func end

--next--
function HymnTrialEnterCtrl:Update()


end --func end

--next--
function HymnTrialEnterCtrl:BindEvents()
    --奖励预览回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,function(object, ...)
        self:RefreshPreviewAwards(...)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--请求进入副本
--按钮点击功能绑定
function HymnTrialEnterCtrl:ButtonClickEventAdd()
    --关闭按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialEnter)
    end)
    --快速组队按钮
    self.panel.BtnTeam:AddClick(function()
        if DataMgr:GetData("TeamData").myTeamInfo.isInTeam then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_HAVE_A_TEAM"))
        else
            UIMgr:ActiveUI(UI.CtrlNames.TeamSearch, function(ctrl)
                ctrl:SetTeamTargetPre(l_teamTargetId)
            end)
        end
    end)
    --开始试炼按钮
    self.panel.BtnStart:AddClick(function()
        local delegateMgr = MgrMgr:GetMgr("DelegateModuleMgr")
        if DataMgr:GetData("TeamData").GetTeamNum() <= 1 then
            delegateMgr.EnterDungeonAccordDelegate(GameEnum.Delegate.activity_Trial, function()
                self:EnterHymnTrial()
            end)
        else
            self:EnterHymnTrial()
        end
    end)
end

--点击进入副本按钮 请求进入副本
function HymnTrialEnterCtrl:EnterHymnTrial()
    --通知服务器请求进入副本
    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_dungeonId, 0, 0)
end

--奖励预览显示
function HymnTrialEnterCtrl:RefreshPreviewAwards(...)

    local l_awardPreviewRes = ...
    local l_awardList = l_awardPreviewRes and l_awardPreviewRes.award_list
    local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
    local l_previewnum = l_awardPreviewRes.preview_num
    if l_awardList then
        local l_rewardDatas={}
        for i, v in ipairs(l_awardList) do
            table.insert(l_rewardDatas, {ID = v.item_id, Count = v.count, IsShowCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(l_previewnum, v.count)})
            if i >= l_previewCount then break end
        end
        --奖励显示
        self.awardTemplatePool:ShowTemplates({Datas = l_rewardDatas})
    end

end


--lua custom scripts end
