--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ParallelSceneUITemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Auto MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field SceneObjCDText MoonClient.MLuaUICom
---@field SceneObjCD MoonClient.MLuaUICom
---@field Raw_AutoEffect MoonClient.MLuaUICom
---@field ExplainTextMessage MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field CircularbarTxt MoonClient.MLuaUICom
---@field BtnUse MoonClient.MLuaUICom
---@field BtnEffect MoonClient.MLuaUICom
---@field BtnCloseExplain MoonClient.MLuaUICom
---@field BtnAddItem MoonClient.MLuaUICom
---@field Btn_Auto MoonClient.MLuaUICom
---@field AddItemIcon MoonClient.MLuaUICom
---@field AddItemCount MoonClient.MLuaUICom
---@field AddItem MoonClient.MLuaUICom

---@class ParallelSceneUITemplate : BaseUITemplate
---@field Parameter ParallelSceneUITemplateParameter

ParallelSceneUITemplate = class("ParallelSceneUITemplate", super)
--lua class define end

--lua functions
function ParallelSceneUITemplate:Init()

	super.Init(self)

end --func end
--next--
function ParallelSceneUITemplate:BindEvents()

	local l_mgr=MgrMgr:GetMgr("SceneObjControllerMgr")
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.GatherItemChangeEvent, self.refreshItem)
	local l_hymnTrialMgr=MgrMgr:GetMgr("HymnTrialMgr")
	self:BindEvent(l_hymnTrialMgr.EventDispatcher,l_hymnTrialMgr.SceneObjControllerCloseGuideArrowEvent, self.UninitGuideArrow)
	local l_beginnerGuideMgr=MgrMgr:GetMgr("BeginnerGuideMgr")
	self:BindEvent(l_beginnerGuideMgr.EventDispatcher,l_beginnerGuideMgr.ShowSceneObjControllerGuideEvent, self.ShowBeginnerGuide)
	local l_lifeProMgr=MgrMgr:GetMgr("LifeProfessionMgr")
	self:BindEvent(l_lifeProMgr.EventDispatcher,l_lifeProMgr.EventType.AutoCollectStateChanged, self.onAutoCollectStateChange)
end --func end
--next--
function ParallelSceneUITemplate:OnDestroy()

	self:barPlayEnd()
	self:stopFx()
	self:destroyAutoEffect()

end --func end
--next--
function ParallelSceneUITemplate:OnDeActive()


end --func end
--next--
function ParallelSceneUITemplate:OnSetData(data)

	if data==nil then
		return
	end
	self.fxId = data.fxId
	self.isPlaying = false
	--初始化SliderValue
	self.startValue = 0
	--目标SliderValue
	self.targetValue = 0
	--动画总时间
	self.totalAniTime = 0
	--当前播放时间
	self.playTime = 0
	---@type MoonClient.MSceneObjInfo
	self.sceneUIInfo = data.sceneUIInfo
	self.cd = 0
	self.btnFx = -1
	self.contextText = ""
	self.titleText = ""
	self.Parameter.CircularbarTxt:SetActiveEx(true)
	self.Parameter.AddItem:SetActiveEx(false)
	self.Parameter.Slider:SetActiveEx(false)
	self.Parameter.Btn_Auto:SetActiveEx(false)
	self.Parameter.BtnUse:AddClick(function() self:OnClicked() end,true)
	self.Parameter.BtnAddItem:AddClick(function() self:On_BtnAddItem_Click() end,true)
	self.Parameter.BtnCloseExplain:AddClick(function() self:On_BtnCloseExplain_Click() end,true)
	self:setUIInfo(self.sceneUIInfo)
	self:initAutoBtn()
	local l_dungeonsType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
	local l_beginnerGuideChecks={}
	if l_dungeonsType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonHymn then
		table.insert(l_beginnerGuideChecks,"HymnTrial")
		--如果是圣歌试炼副本中的场景交互 则判断新手指引
		--MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuideFromCS("HymnTrial")
	else
		table.insert(l_beginnerGuideChecks,"SceneInteraction")
		--MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuideFromCS("SceneInteraction")
	end
	MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, UI.CtrlNames.SceneObjController)

end --func end
--next--
--lua functions end

--lua custom scripts
function ParallelSceneUITemplate:getLifeSkillType()
	local l_lifeProfessionMgr = MgrMgr:GetMgr("LifeProfessionMgr")
	local l_isLifeSkillSceneUI = false
	local l_collectType = LifeSkillType.LIFE_SKILL_TYPE_GARDEN
	if self.sceneUIInfo.collectType == l_lifeProfessionMgr.ClassID.Mining then
		l_collectType = LifeSkillType.LIFE_SKILL_TYPE_MINING
		l_isLifeSkillSceneUI = true
	elseif self.sceneUIInfo.collectType == l_lifeProfessionMgr.ClassID.Gather then
		l_collectType = LifeSkillType.LIFE_SKILL_TYPE_GARDEN
		l_isLifeSkillSceneUI = true
	end
	return l_isLifeSkillSceneUI,l_collectType
end
function ParallelSceneUITemplate:initAutoBtn()
	local l_showAutoButton = false
	local l_collectType = LifeSkillType.LIFE_SKILL_TYPE_GARDEN
	local l_lifeProfessionMgr = MgrMgr:GetMgr("LifeProfessionMgr")
	local l_autoTxtContent = nil
	if self.sceneUIInfo.collectType>0 then
		if self.sceneUIInfo.collectType == l_lifeProfessionMgr.ClassID.Mining then
			l_collectType = LifeSkillType.LIFE_SKILL_TYPE_MINING
			l_autoTxtContent = Lang("AUTO_COLLECT_MINING")
			l_showAutoButton = true
		elseif self.sceneUIInfo.collectType == l_lifeProfessionMgr.ClassID.Gather then
			l_collectType = LifeSkillType.LIFE_SKILL_TYPE_GARDEN
			l_autoTxtContent = Lang("AUTO_COLLECT_GARDEN")
			l_showAutoButton = true
		end
	end
	if l_showAutoButton then
		local l_isAutoCollect = l_lifeProfessionMgr.GetAutoCollectState()
		if l_isAutoCollect then
			l_autoTxtContent = Lang("EXIT_AUTO_MODE")
		end
        local l_autoIcon = l_isAutoCollect and "UI_main_Fishing_Auto_Out.png" or "UI_main_Fishing_Auto.png"
        self.Parameter.Btn_Auto:SetSpriteAsync("main",l_autoIcon)
		self:showAutoEffect(l_isAutoCollect)
		self.Parameter.Txt_Auto.LabText = l_autoTxtContent
	else
		self:destroyAutoEffect()
	end
	self.Parameter.Btn_Auto:SetActiveEx(l_showAutoButton)
	self.Parameter.Btn_Auto:AddClick(function()
		---@type ModuleMgr.LifeProfessionMgr
		local l_lifeProfessionMgr = MgrMgr:GetMgr("LifeProfessionMgr")
        if not l_lifeProfessionMgr.CanCollect(l_collectType,true) then
            return
        end
        if l_lifeProfessionMgr.GetAutoCollectState() then
			l_lifeProfessionMgr.ReqBreakOffAutoCollect()
			UIMgr:ActiveUI(UI.CtrlNames.CollectAutoSetting, l_collectType)
		else
			l_lifeProfessionMgr.ReqGetAutoCollectEndTime(l_collectType,true)
		end
	end,true)
end
function ParallelSceneUITemplate:UninitGuideArrow()
	local l_aimWorldPos = self.Parameter.BtnUse.transform.position
	MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
end
function ParallelSceneUITemplate:ShowBeginnerGuide(guideStepInfo)
    if not UIMgr:IsPanelShowing(UI.CtrlNames.SceneObjController) then
        self:UninitGuideArrow()
        return
    end
    local l_aimWorldPos = self.Parameter.BtnUse.transform.position
	MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_aimWorldPos,
			self.Parameter.BtnUse.transform, guideStepInfo)
end
function ParallelSceneUITemplate:onAutoCollectStateChange()
	self:initAutoBtn()
end
function ParallelSceneUITemplate:OnClicked()

    if self.sceneUIInfo==nil then
        return
    end

    MgrMgr:GetMgr("ChatRoomMgr").OnNavigationMove()

    self.sceneUIInfo:OnClick()

end
function ParallelSceneUITemplate:On_BtnAddItem_Click()
    self.Parameter.ExplainPanel:SetActiveEx(true)
end
function ParallelSceneUITemplate:On_BtnCloseExplain_Click()
	self.Parameter.ExplainPanel:SetActiveEx(false)
end
function ParallelSceneUITemplate:setCD(value)
	if value==nil or value<0 then
		value=0
	end
	self.cd=value
	self.Parameter.SceneObjCD.Img.fillAmount = self.cd
end
function ParallelSceneUITemplate:SetProgressTime(value)
	if self.sceneUIInfo == nil then
		return
	end
	self.sceneUIInfo.progressTime = value
	if MCommonFunctions.IsGreater(self.sceneUIInfo.progressTime, 0) then
		self:setBarAndPlay(self.sceneUIInfo.progressTime, 1, 0)
	else
		self:barPlayEnd()
		if self.btnFx < 0 then
			self:playFx()
		end
	end
end
function ParallelSceneUITemplate:refreshItem()
	if self.sceneUIInfo == nil then
		return
	end

	if not self.sceneUIInfo.needAddItem then
		return
	end

	local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(self.sceneUIInfo.addItemID,true)
	if l_itemRow then
		self.Parameter.AddItemIcon:SetSprite(l_itemRow.ItemAtlas, l_itemRow.ItemIcon)
		self.Parameter.ExplainTextMessage.LabText = l_itemRow.ItemDescription
	end
	self.Parameter.AddItemCount.LabColor = Color.white

	if MEntityMgr.PlayerEntity then
		local l_itemCount = Data.BagModel:GetCoinOrPropNumById(self.sceneUIInfo.addItemID)
		self.Parameter.AddItemCount.LabText = tostring(l_itemCount)
		if l_itemCount <= 0 then
			self.Parameter.AddItemCount.LabColor = Color.New(0.8235, 0.8235, 0.8235, 0.7)
		end
	else
		self.Parameter.AddItemCount.LabText = ""
	end
end
function ParallelSceneUITemplate:playFx()
	self:stopFx()

	if self.sceneUIInfo then
		if self.sceneUIInfo.needCircleFx == false then
			self.Parameter.BtnEffect.RawImg.enabled = false
			return
		end
	end
	self.Parameter.BtnEffect.RawImg.enabled = true

	local fxData = {}
	fxData.playTime = -1
	fxData.position = Vector3.zero
	fxData.rawImage = self.Parameter.BtnEffect.RawImg
	self.btnFx = self:CreateUIEffect(self.fxId, fxData)
end

function ParallelSceneUITemplate:showAutoEffect(isShow)
	self:destroyAutoEffect()
	if not isShow then
		return
	end
	local l_fxData = {}
	l_fxData.rawImage = self.Parameter.Raw_AutoEffect.RawImg
	l_fxData.destroyHandler = function()
		self.autoEffectId=0
	end
	l_fxData.scaleFac = Vector3.New(1.4,1.4,1.4)
	self.autoEffectId = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_RenWuDaoHang_02", l_fxData)
end
function ParallelSceneUITemplate:destroyAutoEffect()
	if self.autoEffectId~=nil and self.autoEffectId >0 then
		self:DestroyUIEffect( self.autoEffectId )
		self.autoEffectId =0
	end
end
function ParallelSceneUITemplate:stopFx()
	if self.btnFx > 0 then
		self:DestroyUIEffect(self.btnFx)
		self.btnFx = -1
	end
end
function ParallelSceneUITemplate:setBarAndPlay(cTotalTime, cTargetValue, cStartValue)
	self.totalAniTime = cTotalTime
	self.targetValue = cTargetValue
	self.startValue = cStartValue

	if self.sceneUIInfo == nil then
		self.playTime = 0
	else
		self.playTime = self.sceneUIInfo.hasPlayedTime
	end
	self:playBar()
end
function ParallelSceneUITemplate:playBar()
	self:setIsPlaying(true)
	self.Parameter.Slider.Slider.value = 0
	self.Parameter.Slider:SetActiveEx(true)
	self.Parameter.BtnUse.Img.color = Color.New(1, 1, 1, 0.5)
	self:stopFx()
end
function ParallelSceneUITemplate:updateProgressBar(fDelta)
	if not self.isPlaying then
		return
	end
	self.playTime = self.playTime + fDelta
	if MCommonFunctions.IsGreater(self.playTime, self.totalAniTime) then
		self:barPlayEnd()
		self:playFx()
	else
		local l_currentValue = self.startValue + (self.targetValue-self.startValue)*(self.playTime/self.totalAniTime)
		self.Parameter.Slider.Slider.value = l_currentValue
	end
end
function ParallelSceneUITemplate:barPlayEnd()
	if not self.isPlaying then
		return
	end
	self:setIsPlaying(false)
	self.startValue = 0
	self.targetValue = 0
	self.totalAniTime = 0
	self.playTime = 0

	if self.sceneUIInfo then
		self.sceneUIInfo.hasPlayedTime = 0
	end

	self.Parameter.Slider.Slider.value = 0
	self.Parameter.Slider:SetActiveEx(false)
	self.Parameter.BtnUse.Img.color = Color.white
end
function ParallelSceneUITemplate:setIsPlaying(isPlaying)
	self.isPlaying=isPlaying
	if isPlaying then
		MSceneObjControllerCSharpMgr.IsPlaying=isPlaying
	end
end
function ParallelSceneUITemplate:Update()
	if self.sceneUIInfo == nil then
		return
	end
	local l_deltaTime = UnityEngine.Time.deltaTime
	if MCommonFunctions.IsGreater(self.cd, 0) then
		self:setCD(self.cd - l_deltaTime)
	end
	if self.sceneUIInfo.getTitleTextCallback then
		self.TitleText = MLuaCommonHelper.CallResultStringFunc(self.sceneUIInfo.getTitleTextCallback)
		self.Parameter.SceneObjCDText.LabText = self.TitleText
	end
	self:updateProgressBar(l_deltaTime)
	self.Parameter.CircularbarTxt.LabText = self.ContextText
	self.Parameter.SceneObjCDText.LabText = self.TitleText
end

function ParallelSceneUITemplate:setUIInfo(info)
	if info == nil then
		self:barPlayEnd()
		return
	end

	if info.getIconCallback then
		info.icon = MLuaCommonHelper.CallResultStringFunc(info.getIconCallback)
	end

	if info.icon then
		if info.atlas then
			self.Parameter.BtnUse:SetSprite(info.atlas, info.icon)
		else
			self.Parameter.BtnUse:SetSprite("main", info.icon)
		end
	end

	if info.getContextTextCallback then
		self.ContextText = MLuaCommonHelper.CallResultStringFunc(info.getContextTextCallback)
	end
	if info.getTitleTextCallback then
		self.TitleText = MLuaCommonHelper.CallResultStringFunc(info.getTitleTextCallback)
	end

	self.Parameter.CircularbarTxt.LabText = self.ContextText
	self.Parameter.SceneObjCDText.LabText = self.TitleText

	self:setCD(info.cd)

	self:playFx()

	--注意必须放在 PlayFx() 之后，不然会出现 既有bar 又有 fx 的情况
	self:SetProgressTime(info.progressTime)
	MLuaCommonHelper.SetLocalScale(self:gameObject(), info.scale, info.scale, info.scale)
	MLuaCommonHelper.SetRectTransformPos(self:gameObject(), info.anchoredPosition.x,info.anchoredPosition.y)

	self:refreshItem()
end
--lua custom scripts end
return ParallelSceneUITemplate