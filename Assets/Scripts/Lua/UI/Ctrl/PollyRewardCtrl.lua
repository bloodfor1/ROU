--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PollyRewardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
PollyRewardCtrl = class("PollyRewardCtrl", super)
--lua class define end

--lua functions
function PollyRewardCtrl:ctor()
	
	super.ctor(self, CtrlNames.PollyReward, UILayer.Function, nil, ActiveType.Standalone)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
	self.ClosePanelNameOnClickMask = UI.CtrlNames.PollyReward
	self.awardList = {}
end --func end
--next--
function PollyRewardCtrl:Init()	
	self.panel = UI.PollyRewardPanel.Bind(self)
	super.Init(self)
	self._awardTemplatePool = self:NewTemplatePool({
	        TemplateClassName = "PollyRegionRewardTemplate",
	        TemplateParent = self.panel.Content.transform,
	        TemplatePrefab = self.panel.PollyRegionReward.gameObject,
	    })
end --func end
--next--
function PollyRewardCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function PollyRewardCtrl:OnActive()
	self.panel.CloseButton:AddClick(function( ... )
		UIMgr:DeActiveUI(UI.CtrlNames.PollyReward)
	end)	
	self:UpdateAward()
end --func end
--next--
function PollyRewardCtrl:OnDeActive()
	
	
end --func end
--next--
function PollyRewardCtrl:Update()
	
	
end --func end
--next--
function PollyRewardCtrl:BindEvents()
    self:BindEvent(GlobalEventBus,EventConst.Names.OnModifyPollyRegionAward,
	    function(self)
	    	self:UpdateAward()
	    end)		   
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,function(object, previewResult, awardIdList)
        self:RefreshPreviewAwards(previewResult, awardIdList)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function PollyRewardCtrl:UpdateAward()
	self.awardList = {}
	for i=1,#self.uiPanelData.awardData do
		local l_award = {}
		l_award.award = self.uiPanelData.awardData[i]
		l_award.awardData = {}
		table.insert(self.awardList ,l_award)
	end
	local l_awards = {}
	for i=1,#self.awardList do
		table.insert(l_awards,self.awardList[i].award.awardId)
	end
	MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(l_awards)
end

--奖励预览显示
function PollyRewardCtrl:RefreshPreviewAwards(previewResult, awardIdList)   
    --比对奖励id列表 确认是否是有效数据
    if not self.awardList or not awardIdList or #self.awardList ~= #awardIdList then return end
    for i = 1, #self.awardList do
        local l_check = false
        for j = 1, #awardIdList do
            if self.awardList[i].award.awardId == awardIdList[j].value then
                l_check = true
                break
            end
        end
        if not l_check then return end
    end 
    --解析预览奖励
    for i = 1, #previewResult do
        local l_awardPreviewRes = previewResult[i]
        local l_awardList = l_awardPreviewRes.award_list
        local l_previewCount = #l_awardList
        if l_awardPreviewRes.preview_count > 0 then
        	l_previewCount = l_awardPreviewRes.preview_count
        end
      
        local l_previewnum = l_awardPreviewRes.preview_num       
        if l_awardList then
            --获取对应的成就信息
            for j = 1, #self.awardList do 
                if self.awardList[j].award.awardId == l_awardPreviewRes.award_id then
        	        for k, v in ipairs(l_awardList) do    
			            table.insert(self.awardList[j].awardData, {ID = v.item_id, Count = v.count, IsShowCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(l_previewnum, v.count)})
			            if k >= l_previewCount then break end
			        end
                end
            end
        end
    end
    
	self._awardTemplatePool:ShowTemplates{
		Datas = self.awardList
	}
end
--lua custom scripts end
return PollyRewardCtrl