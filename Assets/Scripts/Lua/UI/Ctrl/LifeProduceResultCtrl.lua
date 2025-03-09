--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LifeProduceResultPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
LifeProduceResultCtrl = class("LifeProduceResultCtrl", super)
--lua class define end

--lua functions
function LifeProduceResultCtrl:ctor()
	
	super.ctor(self, CtrlNames.LifeProduceResult, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function LifeProduceResultCtrl:Init()
	---@type LifeProduceResultPanel
	self.panel = UI.LifeProduceResultPanel.Bind(self)
	super.Init(self)

	self.lifeProMgr = MgrMgr:GetMgr("LifeProfessionMgr")
	self.isAnimPlaying = false
	self.hasPlayAnimDatas = {}
	self.canClose = false
	self.resultEffects = {}
	self.addAlphaTweenIds = {}
	self.reduceAlphaTweenIds = {}
	self.rewardTimers = {}
	self.lifeSkillAnimInterval =tonumber(MGlobalConfig:GetFloat("CraftingResultAnimDelay"))
	self.panel.Img_Bg.Listener.onClick=function(obj,eventData)
		if self.canClose then
			self:Close()
			self.canClose = false
		end
		self:Close()
	end
end --func end
--next--
function LifeProduceResultCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function LifeProduceResultCtrl:OnActive()
	if self.uiPanelData then
		self.classID = self.uiPanelData.classID
		self.rewardDatas = self.uiPanelData.rewardDatas
	end
	self:playAnim()
end --func end
--next--
function LifeProduceResultCtrl:OnDeActive()
	self:clearRewardDelayShowTimer()
	self.lifeProMgr.ClearProduceRewardQueue()
	self:killAlphaAnim()
	self:destroyEffect()
	self.isAnimPlaying = false
	MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.LIFE_PROFESSION, true)
end --func end
--next--
function LifeProduceResultCtrl:Update()
	
	
end --func end
--next--
function LifeProduceResultCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function LifeProduceResultCtrl:playAnim()
	local l_showRewardCount = #self.rewardDatas
	for i = 1, #self.rewardDatas do
		local l_rewardData = self.rewardDatas[i]
		self:playRewardAnim(i,l_rewardData.propID,l_rewardData.produceCount,l_rewardData.propNum,l_rewardData.produceResult,l_showRewardCount)
	end
end
function LifeProduceResultCtrl:playRewardAnim(index,itemID,produceCount,itemCount,produceResult,totalRewardCount)
	local l_propItem  = TableUtil.GetItemTable().GetRowByItemID(itemID)
	if MLuaCommonHelper.IsNull(l_propItem) then
		return
	end

	local l_rawImgCom
	local l_txtRewardItem
	local l_imgRewardItem
	local l_txtProduceCount
	if produceResult == self.lifeProMgr.EProduceResult.BIG_SUCCESS then
		l_rawImgCom = self.panel.Raw_ProduceResult
		l_txtRewardItem = self.panel.Txt_RewardProp
		l_imgRewardItem = self.panel.Img_RewardProp
		l_txtProduceCount =self.panel.Txt_ProduceCount
	elseif produceResult == self.lifeProMgr.EProduceResult.SUCCESS then
		l_rawImgCom = self.panel.Raw_ProduceResult1
		l_txtRewardItem = self.panel.Txt_RewardProp1
		l_imgRewardItem = self.panel.Img_RewardProp1
		l_txtProduceCount =self.panel.Txt_ProduceCount1
	else
		l_rawImgCom = self.panel.Raw_ProduceResult2
		l_txtRewardItem = self.panel.Txt_RewardProp2
		l_imgRewardItem = self.panel.Img_RewardProp2
		l_txtProduceCount =self.panel.Txt_ProduceCount2
	end
	l_txtProduceCount.LabText = StringEx.Format("x {0}",produceCount)
	l_imgRewardItem:SetSpriteAsync(l_propItem.ItemAtlas,l_propItem.ItemIcon,nil,true)
	l_txtRewardItem.LabText = StringEx.Format("{0}x{1}",l_propItem.ItemName,itemCount)

	self:moveRewardAnim(index,produceResult,l_rawImgCom,totalRewardCount)
end
---@param rawImgCom MoonClient.MLuaUICom
function LifeProduceResultCtrl:moveRewardAnim(index,produceResult,rawImgCom,totalRewardCount)
	local l_delayShowTime = self.lifeSkillAnimInterval * (index - 1) +0.5
	local l_moveToPosX = 0
	local l_rewardIntervalDisHalf = 10
	if totalRewardCount == 2 then
		if index == 1 then
			l_moveToPosX = - rawImgCom.RectTransform.rect.size.x /2 - l_rewardIntervalDisHalf
		else
			l_moveToPosX =  rawImgCom.RectTransform.rect.size.x /2 + l_rewardIntervalDisHalf
		end
	elseif totalRewardCount == 3 then
		if index == 1 then
			l_moveToPosX = - rawImgCom.RectTransform.rect.size.x  - l_rewardIntervalDisHalf * 2
		elseif index == 3 then
			l_moveToPosX =  rawImgCom.RectTransform.rect.size.x  + l_rewardIntervalDisHalf * 2
		end
	end
	self:closeRewardDelayShowTime(index)
	self.rewardTimers[index]=self:NewUITimer(function()
		self:showRewardEffectAnim(index,l_moveToPosX,produceResult,rawImgCom)
	end,l_delayShowTime , 1, true)
	self.rewardTimers[index]:Start()
end
---@param l_rawImgCom MoonClient.MLuaUICom
function LifeProduceResultCtrl:showRewardEffectAnim(index,moveToPosX,produceResult,rawImgCom)
	if MLuaCommonHelper.IsNull(rawImgCom) then
		return
	end
	self:killAlphaAnimByIndex(index)
	local l_rawTargetAnchoredPos = rawImgCom.RectTransform.anchoredPosition3D
	l_rawTargetAnchoredPos.x = moveToPosX
	rawImgCom.RectTransform.anchoredPosition3D = l_rawTargetAnchoredPos
	self:showEffect(index,produceResult,rawImgCom.RawImg)

	self.addAlphaTweenIds[index] = MUITweenHelper.TweenAlpha(rawImgCom.UObj, 0, 1,1.5, function()
		self.reduceAlphaTweenIds[index] = MUITweenHelper.TweenAlpha(rawImgCom.UObj, 1, 0,1.5,function()
			self:Close()
		end)
	end)
end
function LifeProduceResultCtrl:closeRewardDelayShowTime(index)
	if self.rewardTimers[index]~=nil then
		self:StopUITimer(self.rewardTimers[index])
		self.rewardTimers[index] = nil
	end
end
function LifeProduceResultCtrl:clearRewardDelayShowTimer()
	for k,v in pairs(self.rewardTimers) do
		if v~=nil then
			self:StopUITimer(v)
		end
	end
	self.rewardTimers={}
end
function LifeProduceResultCtrl:showEffect(index,produceResult,rawImg)
	local l_effectName
	if produceResult == self.lifeProMgr.EProduceResult.SUCCESS then
		l_effectName = "c_ui_reached"
	elseif produceResult == self.lifeProMgr.EProduceResult.BIG_SUCCESS then
		l_effectName = "c_ui_successful"
	else
		l_effectName = "c_ui_failure"
	end
	local l_fxData = {}
	l_fxData.rawImage = rawImg
	l_fxData.destroyHandler = function()
		self.resultEffects[index]=0
	end
	l_fxData.position = Vector3.New(0,0.12,0)
	l_fxData.scaleFac = Vector3.New(1.5,1.5,1.5)
	self:destroyEffectByIndex(index)
	self.resultEffects[index] = self:CreateUIEffect(StringEx.Format("Effects/Prefabs/Creature/Ui/{0}",l_effectName), l_fxData)
	
end
function LifeProduceResultCtrl:destroyEffectByIndex(index)
	if self.resultEffects[index]~=nil then
		self:DestroyUIEffect(self.resultEffects[index])
		self.resultEffects[index]=0
	end
end
function LifeProduceResultCtrl:destroyEffect()
	if self.resultEffects~=nil then
		for k,v in pairs(self.resultEffects) do
			self:DestroyUIEffect(v)
			self.resultEffects[k]=0
		end
	end
end
function LifeProduceResultCtrl:killAlphaAnimByIndex(index)
	if self.addAlphaTweenIds[index]~=nil then
		MUITweenHelper.KillTweenDeleteCallBack(self.addAlphaTweenIds[index])
		self.addAlphaTweenIds[index] = 0
	end
	if self.reduceAlphaTweenIds[index]~=nil then
		MUITweenHelper.KillTweenDeleteCallBack(self.reduceAlphaTweenIds[index])
		self.reduceAlphaTweenIds[index] = 0
	end
end
function LifeProduceResultCtrl:killAlphaAnim()
	if self.addAlphaTweenIds~=nil then
		for k,v in pairs(self.addAlphaTweenIds) do
			MUITweenHelper.KillTweenDeleteCallBack(v)
		end
		self.addAlphaTweenIds = {}
	end
	if self.reduceAlphaTweenIds~=nil then
		for k,v in pairs(self.reduceAlphaTweenIds) do
			MUITweenHelper.KillTweenDeleteCallBack(v)
		end
		self.reduceAlphaTweenIds = {}
	end
end
--lua custom scripts end
return LifeProduceResultCtrl