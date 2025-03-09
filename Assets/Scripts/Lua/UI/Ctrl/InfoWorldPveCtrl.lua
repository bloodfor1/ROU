--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InfoWorldPvePanel"
require "UI/Template/RewardItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
InfoWorldPveCtrl = class("InfoWorldPveCtrl", super)
--lua class define end

--lua functions
function InfoWorldPveCtrl:ctor()

    super.ctor(self, CtrlNames.InfoWorldPve, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

    self.InsertPanelName=UI.CtrlNames.DailyTask

end --func end
--next--
function InfoWorldPveCtrl:Init()
    self.panel = UI.InfoWorldPvePanel.Bind(self)
    super.Init(self)

    self.mgr = MgrMgr:GetMgr("DailyTaskMgr")
    self.rewardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.RewardItemTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.RewardItemTemplate.LuaUIGroup.gameObject
    })

end --func end
--next--
function InfoWorldPveCtrl:Uninit()

    self.rewardPool = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function InfoWorldPveCtrl:OnActive()
    --self:SetParent(UI.CtrlNames.DailyTask)
    local mgr = MgrMgr:GetMgr("WorldPveMgr")
    local worldPveActivityId = MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_WorldNews
    local activitySdata = TableUtil.GetDailyActivitiesTable().GetRowById(worldPveActivityId)
    if activitySdata==nil then
        return
    end
    self.panel.InfoTitle.LabText = activitySdata.ActivityName
    self.panel.InfoContext.LabText = activitySdata.AcitiveText
    if mgr.HasWorldPve() then
        self.panel.InfoOpening.LabText = Lang("WORLD_PVE_TIME_CONTENT")
        self.panel.InfoOpening.UObj:SetActiveEx(true)
        self.panel.InfoTime.UObj:SetActiveEx(false)
    else
        self.panel.InfoTime.LabText = activitySdata.TimeTextDisplay
        self.panel.InfoOpening.UObj:SetActiveEx(false)
        self.panel.InfoTime.UObj:SetActiveEx(true)
    end
    self.panel.BgImg:SetRawTexAsync(string.format("%s/%s",activitySdata.ContentPicAtlas, activitySdata.ContentPicName))
    self.panel.InfoLv.LabText =  activitySdata.LevelTextDisplay
    self.panel.InfoMod.LabText = activitySdata.ModeTextDisplay

    self.panel.InfoNum.LabText=MgrMgr:GetMgr("DailyTaskMgr").GetShowTextByDailyActivityItem(activitySdata,true,false)

    self.panel.InfoTeamBtn:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)

        local teamTargetInfo = self.mgr.GetTeamTargetInfo(worldPveActivityId)
        if teamTargetInfo.teamTargetType ~= 0 then
            UIMgr:ActiveUI(UI.CtrlNames.TeamSearch, function(ctrl)
                ctrl:SetTeamTargetPre(teamTargetInfo.teamTargetType, teamTargetInfo.teamTargetId)
            end)
        end
    end)
    self.panel.infoGoBtn:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
        self.mgr.GotoDailyTask(worldPveActivityId, nil, true)
    end)
    self.panel.InfoWorldBG:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.InfoWorldPve)
    end)
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(activitySdata.AwardText)
end --func end
--next--
function InfoWorldPveCtrl:OnDeActive()


end --func end
--next--
function InfoWorldPveCtrl:Update()


end --func end

--next--
function InfoWorldPveCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG, self.OnPreviewReward)
end --func end
--next--
--lua functions end

--lua custom scripts
function InfoWorldPveCtrl:OnPreviewReward(info)
    local awardPreviewRes = info
    local awardList = awardPreviewRes and awardPreviewRes.award_list or {}
    local previewCount = awardPreviewRes.preview_count == -1 and #awardList or awardPreviewRes.preview_count
    local previewnum = awardPreviewRes.preview_num
    local datas = {}
    for i, v in ipairs(awardList) do
        if i > previewCount then break end
        table.insert(datas, {id = v.item_id, count = v.count, isShowCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(previewnum, v.count)})
    end
    local mgr = MgrMgr:GetMgr("DailyTaskMgr")
    local boliAwardCount = mgr.GetBoliAwardCount(mgr.g_ActivityType.activity_WorldNews)
    if boliAwardCount > 0 then
        table.insert(datas,1,{id = 301, count = boliAwardCount, isShowCount = true})
    end
    self.rewardPool:ShowTemplates({Datas = datas})
end
--lua custom scripts end

return InfoWorldPveCtrl