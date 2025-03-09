--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AdventureDiarySectionAwardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class AdventureDiarySectionAwardCtrl : UIBaseCtrl
AdventureDiarySectionAwardCtrl = class("AdventureDiarySectionAwardCtrl", super)
--lua class define end

--lua functions
function AdventureDiarySectionAwardCtrl:ctor()
    
    super.ctor(self, CtrlNames.AdventureDiarySectionAward, UILayer.Function, nil, ActiveType.Standalone)
    
end --func end
--next--
function AdventureDiarySectionAwardCtrl:Init()
    
    self.panel = UI.AdventureDiarySectionAwardPanel.Bind(self)
    super.Init(self)

    --遮罩点击关闭界面
    self.mask = self:NewPanelMask(BlockColor.Dark, nil, function()
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiarySectionAward)
    end)

    self.adventureData = DataMgr:GetData("AdventureDiaryData")
    self.adventureMgr = MgrMgr:GetMgr("AdventureDiaryMgr")

    self.isGeted = false  --是否已领取
    self.canGet = false   --是否可领取
    self.sectionInfo = nil  --章节信息

    --奖励预览池申明
    self.awardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.AwardList.transform
    })

    --关闭按钮点击事件
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiarySectionAward)
    end)

    --领取按钮点击事件
    self.panel.BtnGet:AddClick(function()
        if self.isGeted then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AWARD_IS_ALREADY_GET"))
        else
            --判断是否可领取
            if not self.canGet then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ALL_MISSION_IS_GETED"))
                return
            end

            self.adventureMgr.ReqGetSectionAward(self.sectionInfo.sectionData.Chapter)
            UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiarySectionAward)
        end
    end)
    
end --func end
--next--
function AdventureDiarySectionAwardCtrl:Uninit()
    
    super.Uninit(self)
    self.panel = nil

    self.awardItemPool = nil

    self.isGeted = false  
    self.canGet = false
    self.sectionInfo = nil  

    self.adventureData = nil
    self.adventureMgr = nil
    
end --func end
--next--
function AdventureDiarySectionAwardCtrl:OnActive()
    
    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("AdventureDiaryData").EUIOpenType.AdventureDiarySectionAward then
            self.sectionInfo = self.uiPanelData.data
            self:ShowAward()
        end
    end
    
end --func end
--next--
function AdventureDiarySectionAwardCtrl:OnDeActive()
    
    
end --func end
--next--
function AdventureDiarySectionAwardCtrl:Update()
    
    
end --func end
--next--
function AdventureDiarySectionAwardCtrl:BindEvents()
    
    --奖励预览回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,
        function(object, awardPreviewRes, customData, awardId)
            self:RefreshPreviewAwards(awardPreviewRes, awardId)
        end)
    
end --func end
--next--
--lua functions end

--lua custom scripts

function AdventureDiarySectionAwardCtrl:ShowAward()

    if self.sectionInfo == nil then
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiarySectionAward)
        return
    end

    --条件展示
    self.panel.Condition.LabText = Lang("ADVENTURE_SECTION_AWARD_CONDITION", self.sectionInfo.sectionData.Name)
    --奖励预览请求
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(self.sectionInfo.sectionData.AwardId)

    --按钮样式
    self.isGeted = self.adventureData.CheckSectionIsGetAward(self.sectionInfo)  --是否已领取
    self.canGet = self.adventureData.CheckSectionCanGetAward(self.sectionInfo)  --是否可领取
    self.panel.BtnGet:SetGray(self.isGeted or not self.canGet)
    self.panel.BtnGetText.LabText = self.isGeted and Lang("ButtonText_AwardGetFinish") or Lang("ButtonText_AwardGet")
    
end


function AdventureDiarySectionAwardCtrl:RefreshPreviewAwards(awardPreviewRes, awardId)
    --判断奖励ID是否对应
    if not self.sectionInfo or self.sectionInfo.sectionData.AwardId ~= awardId then
        return
    end

    local l_datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardPreviewRes)
    self.awardItemPool:ShowTemplates({ Datas = l_datas })

end
--lua custom scripts end
return AdventureDiarySectionAwardCtrl