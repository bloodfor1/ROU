--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/PollyMyNotePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
PollyMyNoteHandler = class("PollyMyNoteHandler", super)
--lua class define end

--lua functions
function PollyMyNoteHandler:ctor()
	
	super.ctor(self, HandlerNames.PollyMyNote, 0)
	
end --func end
--next--
function PollyMyNoteHandler:Init()
	
	self.panel = UI.PollyMyNotePanel.Bind(self)
	super.Init(self)
	self.typeData = {}
	self.awardList = {}
	local l_datas = MgrMgr:GetMgr("BoliGroupMgr").GetTypeData()
	for k,v in pairs(l_datas) do
		table.insert(self.typeData,v)
	end
	table.sort(self.typeData,function(a,b)
		return a.typeId < b.typeId
	end)

	self._typeTemplatePool = self:NewTemplatePool({
	        TemplateClassName = "PollyTypeHeadTemplate",
	        TemplateParent = self.panel.Content.transform,
	        TemplatePrefab = self.panel.PollyTypeHead.gameObject,
	        Method = function(index)
            	self:onSelectOne(index)
        	end
	    })

	self._awardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "PollyTypeAwardNodeTemplate",
        TemplateParent = self.panel.AwardContent.transform,
        TemplatePrefab = self.panel.AwardNode.gameObject,
    })
    self.currentSelect = 1
    self.model = nil
    self.defaultAnim = nil
    self.showAnim = nil 
    self.animTime = -1
    self.timer = self:NewUITimer()
end --func end
--next--
function PollyMyNoteHandler:Uninit()	
	super.Uninit(self)
	self.panel = nil	
end --func end
--next--
function PollyMyNoteHandler:OnActive()
	self:UpdateNote()
	
end --func end
--next--
function PollyMyNoteHandler:OnDeActive()	
	self:DestroyModel()
end --func end
--next--
function PollyMyNoteHandler:Update()
    if self.model and self.animTime > 0 then
        self.animTime = self.animTime - Time.deltaTime 
        if self.animTime <= 0 then
        	if self.defaultAnim ~= nil then
            	self.model.Ator:OverrideAnim("Idle", self.defaultAnim)
        	end
			self.animTime = -1
        end
    end
end --func end
--next--
function PollyMyNoteHandler:BindEvents()
	    --奖励预览回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,function(object, previewResult, awardIdList)
        self:RefreshPreviewAwards(previewResult, awardIdList)
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.OnDiscoverPolly,
        function(self, isClick)
            self:UpdateNote()
        end)
end --func end
--next--
--lua functions end

--lua custom scripts

function PollyMyNoteHandler:SelectOneType(typeId)
    if typeId == 0 or self.typeData == nil then
        return
    end
    for i=1,#self.typeData do
        if typeId == self.typeData[i].typeId then
            self.currentSelect = i
            break
        end
    end
    self:UpdateNote()
end

function PollyMyNoteHandler:UpdateNote( ... )
	if self.typeData == nil then
		return
	end
	self._typeTemplatePool:ShowTemplates({
        Datas = self.typeData 
    })
    self._typeTemplatePool:SelectTemplate(self.currentSelect)
    self:UpdateSelectPolly()
end

function PollyMyNoteHandler:onSelectOne(index)
   self._typeTemplatePool:SelectTemplate(index)
   self.currentSelect = index	
   self:UpdateSelectPolly()
end

function PollyMyNoteHandler:UpdateSelectPolly()
	if self.currentSelect ==0 or self.currentSelect > #self.typeData then
		return
	end

	self.selectData = self.typeData[self.currentSelect]
	local l_rowData = TableUtil.GetElfTypeTable().GetRowByID(self.selectData.typeId)
	if l_rowData == nil then
		return
	end
    if self.awardOffset == nil then
        self.awardOffset = self.panel.AwardContent.RectTransform.anchoredPosition
    end
    self.panel.AwardContent.RectTransform.anchoredPosition = self.awardOffset
	self.panel.PollyName.LabText = l_rowData.Name
	self.panel.Desc.LabText = l_rowData.Description
	self.panel.Count.LabText = tostring(self.selectData.unlockCount)
	self:UpdateModel(l_rowData)
	self:UpdateAward()
end

--奖励预览显示

function PollyMyNoteHandler:UpdateModel( data )
	self:DestroyModel()
	local l_unlock = self.selectData.unlockCount > 0
	self.panel.ModelBG:SetActiveEx(l_unlock)
	if l_unlock then
		self:CreateModel(data)
		return
	end
	self.panel.LockImage:SetActiveEx(true)
	self.panel.LockImage:SetSprite(data.Atlas2, data.Icon2, true)
end

function PollyMyNoteHandler:CreateModel(data)
	self.panel.LockImage:SetActiveEx(false)
    local l_entityId = data.EntityID
    local l_entityData = TableUtil.GetEntityTable().GetRowById(l_entityId)
    if l_entityData == nil then
    	return
    end
    local l_presentData = TableUtil.GetPresentTable().GetRowById(l_entityData.PresentID)
    if l_presentData == nil then
    	return
    end
    self.defaultAnim = MAnimationMgr:GetClipPath(l_presentData.IdleAnim)
    self.showAnim = MAnimationMgr:GetClipPath(data.ShowAnim) 
    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitMonsterAttr(l_tempId, "BoliElf", l_entityId)
    local l_rtData = {}
    l_rtData.rawImage = self.panel.ModelView.RawImg
    l_rtData.attr = l_attr
    l_rtData.defaultAnim = self.defaultAnim
    self.model = self:CreateUIModel(l_rtData)
    self.model.Ator:OverrideAnim("Idle", self.defaultAnim)
    self.model:AddLoadModelCallback(function(m)
        MLuaCommonHelper.SetRotEuler(m.UObj, 0, 180, 0)
        MLuaCommonHelper.SetLocalScale(m.UObj, 1.35, 1.35, 1.35)
        MLuaCommonHelper.SetLocalPos(m.UObj, 0, 0.3, 0)
        self.panel.ModelView:SetActiveEx(true)
        self.panel.ModelView:AddClick(function( ... )
        	if self.animTime > 0 then
        		return
        	end
        	local l_clicp = self.model.Ator:OverrideAnim("Idle", self.showAnim)
        	self.model.Ator:OverrideAnim("Idle", self.showAnim)
        	self.model.Ator:Play("Idle", 0)
			self.animTime = l_clicp.Length
        end)
    end)
end

function PollyMyNoteHandler:DestroyModel( )
	if self.model ~= nil then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
    self.panel.ModelView:SetActiveEx(false)
    self.defaultAnim = nil
    self.showAnim = nil
    self.animTime = -1
end

function PollyMyNoteHandler:UpdateAward( ... )
	self.awardList = {}
	for k,v in pairs(self.selectData.awards) do
		local l_award = {}
		l_award.award = v
		l_award.previewItemId = 0
		l_award.previewCount = 0
        l_award.isShowCount = true
		table.insert(self.awardList ,l_award)
	end
	table.sort(self.awardList ,function(a,b)
		return a.award.count < b.award.count
	end)
	local l_awards = {}
	for i=1,#self.awardList do
		table.insert(l_awards,self.awardList[i].award.awardId)
	end
    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(l_awards)
end

function PollyMyNoteHandler:RefreshPreviewAwards(previewResult, awardIdList)
    
	if self.selectData == nil then
		return
	end

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
        local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
        local l_previewnum = l_awardPreviewRes.preview_num
        if l_awardList then
            for j = 1, #self.awardList do 
                if self.awardList[j].award.awardId == l_awardPreviewRes.award_id then
                	if #l_awardList > 0 then
                		self.awardList[j].previewItemId = l_awardList[1].item_id
                		self.awardList[j].previewCount = l_awardList[1].count
                        self.awardList[j].isShowCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(l_previewnum, l_awardList[1].count)
                	end
                end
            end
        end
    end

	self._awardTemplatePool:ShowTemplates{
		Datas = self.awardList
	}

	local l_maxNodeCount = 2 * #self.awardList - 1
	local l_currentNode = 0
	for i=1,#self.awardList do
		local l_unlockCount = self.selectData.unlockCount
		local l_nodeCount = self.awardList[i].award.count
		if l_unlockCount >= l_nodeCount then
			l_currentNode = i	
		end
	end
	if l_currentNode > 0 then
		l_currentNode = l_currentNode * 2 - 1
	end
	self.panel.ProgressSlider.Slider.maxValue = l_maxNodeCount
	self.panel.ProgressSlider.Slider.value = l_currentNode
end

--lua custom scripts end
return PollyMyNoteHandler