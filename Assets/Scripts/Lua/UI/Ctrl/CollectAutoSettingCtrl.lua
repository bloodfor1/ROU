--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CollectAutoSettingPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
CollectAutoSettingCtrl = class("CollectAutoSettingCtrl", super)
--lua class define end

--lua functions
function CollectAutoSettingCtrl:ctor()
	
	super.ctor(self, CtrlNames.CollectAutoSetting, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function CollectAutoSettingCtrl:Init()
	
	self.panel = UI.CollectAutoSettingPanel.Bind(self)
	super.Init(self)

	self.mask=self:NewPanelMask(BlockColor.Transparent,nil,nil)

	self.lifeProfessionMgr = MgrMgr:GetMgr("LifeProfessionMgr")
	local l_autoCollectParam = MGlobalConfig:GetSequenceOrVectorInt("AutoGatheringSettings")
	self.isAutoContinueTime = false
	self.isAllMap = MPlayerSetting.AllMapAutoCollect
	self.collectDis = MPlayerSetting.AutoCollectScope

	self.currentChooseAddRemainTimeIndex = 0
	self.minCollectDis = l_autoCollectParam[0]
	self.maxCollectDis = l_autoCollectParam[1]
	self.increaseCollectDis = l_autoCollectParam[2]
	self.collectType = LifeSkillType.LIFE_SKILL_TYPE_GARDEN
	self:initEventInfo()
end --func end
--next--
function CollectAutoSettingCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function CollectAutoSettingCtrl:OnActive()
	if self.uiPanelData~=nil then
		self.collectType = self.uiPanelData
	end
	self.lifeProfessionMgr.ReqGetAutoCollectEndTime(self.collectType)
	self:initBaseInfo()
end --func end
--next--
function CollectAutoSettingCtrl:OnDeActive()
	self.itemTemplate = nil
end --func end
--next--
function CollectAutoSettingCtrl:Update()
	
	
end --func end
--next--
function CollectAutoSettingCtrl:BindEvents()
	self:BindEvent(self.lifeProfessionMgr.EventDispatcher,self.lifeProfessionMgr.EventType.OnGetCollectEndTime,function(_,endTime)
		self.panel.Txt_RemainTime.LabText = Common.TimeMgr.GetLeftTimeStrAccurateToSecond(endTime)
		if endTime~=nil and (endTime - Common.TimeMgr.GetNowTimestamp()>0) then
			self.currentChooseAddRemainTimeIndex = 0
		else
			self.currentChooseAddRemainTimeIndex = 1
		end
		self.panel.Dropdown_AddRemainTime.DropDown.value = self.currentChooseAddRemainTimeIndex
	end)
end --func end
--next--
--lua functions end

--lua custom scripts
function CollectAutoSettingCtrl:initEventInfo()
	self.panel.Toggle_AutoContinueTime:OnToggleChanged(function(value)
		self.isAutoContinueTime = value
	end,true)
	self.panel.Toggle_SelfDefine:OnToggleChanged(function(value)
		if value then
			self:refreshCollectDisInfo(false)
		end
	end,true)
	self.panel.Toggle_AllMap:OnToggleChanged(function(value)
		if value then
			self:refreshCollectDisInfo(true)
		end
	end,true)
	self.panel.Slider_CollectScope:OnSliderChange(function(value)
		self:setScopeSliderValue(value)
	end,true)
	self.panel.Btn_Close:AddClick(function()
		self:closeThisPanel()
	end,true)
	self.panel.Btn_Confirm:AddClick(function()
		local l_addRemainTime,l_needPropNum =  self:getAddRemainTimeAndCostPropNumByDropDownIndex(self.currentChooseAddRemainTimeIndex,self.collectType)

		local l_costItemId = 0
		if self.collectType == LifeSkillType.LIFE_SKILL_TYPE_MINING then
			l_costItemId = MGlobalConfig:GetInt("AutoMiningItemID")
		elseif self.collectType == LifeSkillType.LIFE_SKILL_TYPE_GARDEN then
			l_costItemId = MGlobalConfig:GetInt("AutoGatheringItemID")
		end
		local l_hasPropNum = Data.BagModel:GetBagItemCountByTid(l_costItemId)
		if l_hasPropNum < l_needPropNum then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
			local l_itemData = Data.BagModel:CreateItemWithTid(l_costItemId)
			MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(l_itemData, nil, nil, nil, true)
			return
		end

		MgrMgr:GetMgr("LifeProfessionMgr").ReqAutoCollect(l_needPropNum,
				self.collectType,self.isAutoContinueTime,l_addRemainTime)
		self:closeThisPanel()
	end,true)
	self.panel.Btn_Help:AddClick(function()
		self:showAutoCollectDesc()
	end,true)
	self.panel.Dropdown_AddRemainTime:SetActiveEx(true)
	self.panel.Dropdown_AddRemainTime.DropDown:ClearOptions()
	local l_addRemainPerSegment = self:getAddRemainTimePerSegment(self.collectType)


	self.panel.Listener_Handler.Listener.onDown = function(go,evenData)
		self.panel.Root.CanvasGroup.alpha = 0.5
	end
	self.panel.Listener_Handler.Listener.onUp = function(go,evenData)
		self.panel.Root.CanvasGroup.alpha = 1
	end
	self.panel.Listener_Handler.Listener.onDrag = function(go,evenData)
		MLuaCommonHelper.ExecuteDragEvent(self.panel.Slider_CollectScope.UObj,evenData)
	end
	self.panel.Listener_Handler.Listener.endDrag = function(go,evenData)
		MLuaCommonHelper.ExecuteEndDragEvent(self.panel.Slider_CollectScope.UObj,evenData)
	end
	self.panel.Listener_Handler.Listener.beginDrag = function(go,evenData)
		MLuaCommonHelper.ExecuteBeginDragEvent(self.panel.Slider_CollectScope.UObj,evenData)
	end
	local l_addRemainTimeOptions = {
		Lang("EXPEL_MONSTER_LEFT_TIME",0),
	}
	--加6个选项
	for i = 1, 6 do
		table.insert(l_addRemainTimeOptions,Lang("EXPEL_MONSTER_LEFT_TIME",i*l_addRemainPerSegment/ 60))
	end
	self.panel.Dropdown_AddRemainTime:SetDropdownOptions(l_addRemainTimeOptions)
	self.panel.Dropdown_AddRemainTime.DropDown.onValueChanged:AddListener(function(index)
		self.currentChooseAddRemainTimeIndex = index
		local _,l_needPropNum = self:getAddRemainTimeAndCostPropNumByDropDownIndex(index,self.collectType)
		self:setNeedCostPropByCollectType(self.collectType,l_needPropNum)
	end)
end
function CollectAutoSettingCtrl:setScopeSliderValue(value)
	self.collectDis = value  * self.increaseCollectDis + self.minCollectDis
	MPlayerInfo:PlayerAutoBattleRangeFx(1, self.collectDis, true)
	local l_scopeStr
	if self.collectDis==0 then
		l_scopeStr = Lang("AUTO_FIGHT_HOLD")
	else
		l_scopeStr = StringEx.Format("{0}m",self.collectDis)
	end
	self.panel.Txt_CollectScopeDis.LabText = l_scopeStr
end
function CollectAutoSettingCtrl:getAddRemainTimeAndCostPropNumByDropDownIndex(index,collectType)
	local l_addRemainTime = index * self:getAddRemainTimePerSegment(collectType)
	local l_needCostPropNum = index
	return l_addRemainTime,l_needCostPropNum
end
function CollectAutoSettingCtrl:getAddRemainTimePerSegment(collectType)
	local l_addRemainTime = 0
	if collectType == LifeSkillType.LIFE_SKILL_TYPE_GARDEN then
		l_addRemainTime = MGlobalConfig:GetInt("AutoGatheringBuffLastTime")
	else
		l_addRemainTime = MGlobalConfig:GetInt("AutoMiningBuffLastTime")
	end
	return l_addRemainTime
end
function CollectAutoSettingCtrl:initBaseInfo()
    self.panel.Txt_RemainTime.LabText = Common.TimeMgr.GetLeftTimeStrAccurateToSecond(1)
	local l_lifeProfessionName
	if self.collectType == LifeSkillType.LIFE_SKILL_TYPE_MINING then
		self.panel.Txt_Title.LabText = Lang("AUTO_COLLECT_MINING")
		l_lifeProfessionName = Lang("LifeProfession_Mining")
	else
		self.panel.Txt_Title.LabText = Lang("AUTO_COLLECT_GARDEN")
		l_lifeProfessionName = Lang("LifeProfession_Gather")
	end
	self.panel.Txt_helpTips.LabText = Lang("AUTO_ACTION_SCOPE",l_lifeProfessionName)
	self.panel.Txt_TimeAddTip.LabText = Lang("AUTO_TIME_ADD",l_lifeProfessionName)
	self.panel.Txt_TogLab.LabText = Lang("CONTINUE_ADD_LIFESKILL_TIME",l_lifeProfessionName)
	self.panel.Txt_TimeRemainTip.LabText =Common.Utils.Lang("REMAIN_LIFESKILL_TIME",l_lifeProfessionName)

	self.panel.Toggle_AutoContinueTime.Tog.isOn = false
	--目前屏蔽了全地图功能，只留自定义相关内容
	--self.panel.Toggle_SelfDefine.Tog.isOn = not MPlayerSetting.AllMapAutoCollect
	--self.panel.Toggle_AllMap.Tog.isOn = MPlayerSetting.AllMapAutoCollect
	self:refreshCollectDisInfo(false)
	self:setNeedCostPropByCollectType(self.collectType,0)

	self.panel.Slider_CollectScope.Slider.minValue = 0
	self.panel.Slider_CollectScope.Slider.maxValue = math.ceil((self.maxCollectDis -
			self.minCollectDis)/self.increaseCollectDis)
	self.panel.Slider_CollectScope.Slider.value = (MPlayerSetting.AutoCollectScope - self.minCollectDis) / self.increaseCollectDis
	self:setScopeSliderValue(self.panel.Slider_CollectScope.Slider.value)
	self.panel.Dropdown_AddRemainTime.DropDown.value = self.currentChooseAddRemainTimeIndex
	MPlayerInfo:PlayerAutoBattleRangeFx(1, MPlayerSetting.AutoCollectScope, true)
end
function CollectAutoSettingCtrl:setNeedCostPropByCollectType(collectType,needPropNum)
	local l_costPropId = 0
	if collectType == LifeSkillType.LIFE_SKILL_TYPE_GARDEN then
		l_costPropId = MGlobalConfig:GetInt("AutoGatheringItemID")
	else
		l_costPropId = MGlobalConfig:GetInt("AutoMiningItemID")
	end
	local l_propData = {
		IsActive = true,
		ID = l_costPropId,
		IsShowRequire = true,
		RequireCount = needPropNum,
		IsShowCount = false,
	}
	if MLuaCommonHelper.IsNull(self.itemTemplate) then
		self.itemTemplate = self:NewTemplate("ItemTemplate", {
			TemplateParent = self.panel.Img_NeedProp.Transform,
			Data = l_propData,
		})
	else
		self.itemTemplate:SetData(l_propData)
	end
end
function CollectAutoSettingCtrl:refreshCollectDisInfo(isAllMap)
	self.isAllMap = isAllMap
	self.panel.Img_SlideFill:SetGray(self.isAllMap)
end
function CollectAutoSettingCtrl:closeThisPanel()
	UIMgr:DeActiveUI(UI.CtrlNames.CollectAutoSetting)
	MPlayerSetting.AutoCollectScope = self.collectDis
	MPlayerSetting.AllMapAutoCollect = self.isAllMap
	MPlayerInfo:PlayerAutoBattleRangeFx(1, MPlayerSetting.AutoCollectScope, false)
end
function CollectAutoSettingCtrl:showAutoCollectDesc()
	MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
		content = Lang("AUTO_COLLECT_DESC"),
		alignment = UnityEngine.TextAnchor.LowerLeft,
		relativeLeftPos = {
			canOffset = false,
			screenPos = MUIManager.UICamera:WorldToScreenPoint(self.panel.Btn_Help.Transform.position)
		},
		pivot = Vector2.New(0,0),
		anchoreMin = Vector2.New(0.5,0.5),
		anchoreMax = Vector2.New(0.5,0.5),
		width = 400,
	})
end

--lua custom scripts end
return CollectAutoSettingCtrl