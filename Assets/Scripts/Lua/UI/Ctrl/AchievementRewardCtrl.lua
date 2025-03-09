--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementRewardPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
AchievementRewardCtrl = class("AchievementRewardCtrl", super)
--lua class define end

--lua functions
function AchievementRewardCtrl:ctor()

    super.ctor(self, CtrlNames.AchievementReward, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function AchievementRewardCtrl:Init()

    self.panel = UI.AchievementRewardPanel.Bind(self)
    super.Init(self)
    self._lastIndex=0
    self._currentData=nil
    self._mgr=MgrMgr:GetMgr("AchievementMgr")

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AchievementReward)
    end)

    self.panel.CanAward:AddClick(function()
        if self._currentData==nil then
            return
        end
        MgrMgr:GetMgr("AchievementMgr").RequestAchievementGetPointReward(self._currentData.Id)
    end)

    self._rewardItemTemplatePool=self:NewTemplatePool({
        TemplateClassName="AchievementRewardItemTemplate",
        TemplatePrefab=self.panel.RewardItemPrefab.gameObject,
        ScrollRect=self.panel.RewardScroll.LoopScroll,
        Method=function(index)
            self:onRewardItemButton(index)
        end
    })

end --func end
--next--
function AchievementRewardCtrl:Uninit()

    self._rewardItemTemplatePool=nil

    self._mgr=nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AchievementRewardCtrl:OnActive()

    self._lastIndex=0
    local l_table = TableUtil.GetAchievementPointsAwardTable().GetTable()

    self.panel.NeedPointText:SetActiveEx(false)
    self.panel.CantAward:SetActiveEx(false)
    self.panel.CanAward:SetActiveEx(false)
    self.panel.Awarded:SetActiveEx(false)
    self.panel.Point.LabText=tostring(self._mgr.TotalAchievementPoint)

    local l_awardIds={}
    for i = 1, #l_table do
        if l_table[i].Award~=0 then
            table.insert(l_awardIds,l_table[i].Award)
        end
    end

    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(l_awardIds,self._mgr.GetAchievementPointAwardEvent)

end --func end
--next--
function AchievementRewardCtrl:OnDeActive()
    self._currentData=nil
end --func end
--next--
function AchievementRewardCtrl:Update()


end --func end

--next--
function AchievementRewardCtrl:BindEvents()
    local l_getAchievementPointAwardFunc =  function(selfa, awardInfo)
        self._mgr.SetAchievementAwardDatas(awardInfo)

        local l_table = TableUtil.GetAchievementPointsAwardTable().GetTable()
        self._rewardItemTemplatePool:ShowTemplates({
            Datas=l_table,
        })
        local l_index=1
        for i = 1, #l_table do
            if l_table[i].Point<=self._mgr.TotalAchievementPoint then
                if not self._mgr.IsAchievementPointRewarded(l_table[i].Id) then
                    l_index=i
                    break
                end
            end
        end
        self:onRewardItemButton(l_index)
    end

    local l_achievementGetPointRewardFunc = function()
        self:_showButton()
        self._rewardItemTemplatePool:RefreshCell(self._lastIndex)
        --local l_lastTemplate= self._rewardItemTemplatePool:GetItem(self._lastIndex)
        --if l_lastTemplate then
        --  l_lastTemplate:ShowRedSign()
        --end
    end

    self:BindEvent(self._mgr.EventDispatcher,self._mgr.AchievementGetPointRewardEvent,l_achievementGetPointRewardFunc)
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,self._mgr.GetAchievementPointAwardEvent,l_getAchievementPointAwardFunc)
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementRewardCtrl:onRewardItemButton(index)
    if self._lastIndex==index then
        return
    end

    self._lastIndex=index

    self._rewardItemTemplatePool:SelectTemplate(index)

    self._currentData=self._rewardItemTemplatePool:getData(index)

    if self._currentData==nil then
        return
    end

    self.panel.NeedPointText:SetActiveEx(true)
    self.panel.NeedPointText.LabText=StringEx.Format(Lang("Achievement_NeedPointText"),self._currentData.Point)

    self:_showButton()

    local l_awardData= self._mgr.GetAchievementAwardDatas(self._currentData.Award)
    local l_award=l_awardData[1]
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_award.item_id)
    if l_itemRow == nil then
        return
    end
    self.panel.DetailName.LabText = l_itemRow.ItemName
    self.panel.Icon:SetSpriteAsync(l_itemRow.ItemAtlas, l_itemRow.ItemIcon, nil, self.panel.Icon.Img.type == UnityEngine.UI.Image.Type.Simple)
    self.panel.DetailLab.LabText = GetColorText(MgrMgr:GetMgr("ItemPropertiesMgr").GetDetailInfo(l_award.item_id) .. ":", RoColorTag.Gray)
end

function AchievementRewardCtrl:_showButton()
    if self._currentData==nil then
        return
    end

    self.panel.CantAward:SetActiveEx(false)
    self.panel.CanAward:SetActiveEx(false)
    self.panel.Awarded:SetActiveEx(false)
    if self._mgr.IsAchievementPointRewarded(self._currentData.Id) then
        self.panel.Awarded:SetActiveEx(true)
    else
        if self._currentData.Point>self._mgr.TotalAchievementPoint then
            self.panel.CantAward:SetActiveEx(true)
        else
            self.panel.CanAward:SetActiveEx(true)
        end
    end
end

--lua custom scripts end
