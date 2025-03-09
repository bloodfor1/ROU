--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AdventureChapterAwardPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
AdventureChapterAwardCtrl = class("AdventureChapterAwardCtrl", super)
--lua class define end

--lua functions
function AdventureChapterAwardCtrl:ctor()
    
    super.ctor(self, CtrlNames.AdventureChapterAward, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.ClosePanelNameOnClickMask=UI.CtrlNames.AdventureChapterAward
    
end --func end
--next--
function AdventureChapterAwardCtrl:Init()
    
    self.panel = UI.AdventureChapterAwardPanel.Bind(self)
    super.Init(self)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark, function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.AdventureChapterAward)
    --end)

    --领取章节奖励按钮点击
    self.panel.BtnGetAward:AddClick(function ()
        local l_adventureData = DataMgr:GetData("AdventureDiaryData")
        if l_adventureData.chapterAwardIdFinishCount < l_adventureData.chapterAwardIdCount then
            --未完成
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COMPLETE_ALL_MISSION_CAN_GET"))
        else
            --已完成
            MgrMgr:GetMgr("AdventureDiaryMgr").ReqGetChapterAward()
            UIMgr:DeActiveUI(UI.CtrlNames.AdventureChapterAward)
        end
    end)

    --请求章节奖励预览
    local l_awardId = MGlobalConfig:GetInt("PostcardTotalReward")
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_awardId)
    
end --func end
--next--
function AdventureChapterAwardCtrl:Uninit()

    --奖励模型销毁
    if self.model ~=nil then
        self:DestroyUIModel(self.model);
        self.model = nil
    end
    --模型旋转销毁
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
    --特效销毁
    if self.effect ~= nil then
        self:DestroyUIEffect(self.effect)
        self.effect = nil
    end
    
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function AdventureChapterAwardCtrl:OnActive()
    
    MLuaClientHelper.PlayFxHelper(self.panel.Content.UObj)

    --特效加载
    local l_effectPath = "Effects/Prefabs/Creature/Ui/fx_UI_gongxihuode_fazhan"
    local l_fxData = {}
    l_fxData.rawImage = self.panel.EffectView.RawImg
    l_fxData.loadedCallback = function(a) self.panel.EffectView.gameObject:SetActiveEx(true) end
    l_fxData.destroyHandler = function ()
        self.effect = nil
    end
    self.effect = self:CreateUIEffect(l_effectPath, l_fxData)
    
    
end --func end
--next--
function AdventureChapterAwardCtrl:OnDeActive()
    
    
end --func end
--next--
function AdventureChapterAwardCtrl:Update()
    
    
end --func end

--next--
function AdventureChapterAwardCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,function(object, ...)
        self:RefreshPreviewAwards(...)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function AdventureChapterAwardCtrl:RefreshPreviewAwards(...)

    local l_awardPreviewRes = ...
    local l_awardList = l_awardPreviewRes and l_awardPreviewRes.award_list
    local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
    local l_previewnum = l_awardPreviewRes.preview_num
    if l_awardList then
        for i = 1, #l_awardList do
            if i > 1 then return end  --这边只有1个
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_awardList[i].item_id)
            if l_itemRow then
                self:ShowAwardModel(l_itemRow.ItemID)
                self.panel.AwardName.LabText = l_itemRow.ItemName
            end
        end
    end

end

--奖励道具模型加载
function AdventureChapterAwardCtrl:ShowAwardModel(itemId)
    local l_modelData = 
    {
        itemId = itemId,
        rawImage = self.panel.ModelView.RawImg
    }
    self.model = self:CreateUIModelByItemId(l_modelData)
    self.model.Position = Vector3.New(0, 0, 1)
    self.model.Scale = Vector3.New(1, 1, 1)
    self.model.Rotation = Quaternion.Euler(0, -180, 0)

    self.model:AddLoadModelCallback(function(m)
        self.panel.ModelView.UObj:SetActiveEx(true)
        self.tween = self.model.Trans:DOLocalRotate(Vector3.New(0,0,0), 4)
        self.tween:SetLoops(-1, DG.Tweening.LoopType.Incremental)
        self.tween:SetEase(DG.Tweening.Ease.Linear)
    end)
end
--lua custom scripts end
return AdventureChapterAwardCtrl