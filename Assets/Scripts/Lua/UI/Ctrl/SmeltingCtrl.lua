--this file is gen by script
--you can edit this file in custom part


--lua requires
require "SmallGames/SGameUIBase"
require "UI/Panel/SmeltingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = SGame.SGameUIBase
--next--
--lua fields end

--lua class define
SmeltingCtrl = class("SmeltingCtrl", super)
--lua class define end

--lua functions
function SmeltingCtrl:ctor()
	
	super.ctor(self, CtrlNames.Smelting, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function SmeltingCtrl:Init()
	self.panel = UI.SmeltingPanel.Bind(self)
	super.Init(self)
	self.missScore=0
	self.goodScore=5
	self.perfectScore=10
	self.reduceCircleSpeed=1
	self.enlargeCircleSpeed=1
	self.superPositionTime=3 --外圈与内圈重叠时间

	self.outerCircleLen=423
	self.orangeCircleLen=360
	self.yellowCircleLen=245
	self.innerCircleLen=150
	self.weaponName=""

	self.totalScore=0
	self.gameStart=false

	self.tieZhenModel=nil
	self.weaponModel=nil
	self.hammerModel=nil

	self.starFlowFbID=0
	self.clickFbID=0
	self.progressFullID=0
	self.countDownID=0
	self.starTrailID=0
	self.starDropID=0
	self.critTimeID=0

	self.star1FlowFbID=0
	self.star1TrailID=0
	self.star1DropID=0

	self.star2FlowFbID=0
	self.star2TrailID=0
	self.star2DropID=0
	self.tieHuaID=0

	self.circleChangeSmall=true

	self:RegisteOperableObject("SmeltSuc",self.panel.SmeltSuc)
	self:RegisteOperableObject("BtnFullScreen",self.panel.BtnFullScreen)

	self.panel.SliderHp.Slider.value=0
	self.panel.BtnFullScreen:AddClick(function()
		if not self.gameStart then
			return
		end
		local clickSuc=false
		if self.clickState==self.ClickStateEnum.Miss then
			self:OnScoreChange(self.missScore)
			DG.Tweening.DOTween.Restart(self.panel.MissScore.UObj)
		elseif self.clickState==self.ClickStateEnum.Good then
			self:OnScoreChange(self.goodScore)
			DG.Tweening.DOTween.Restart(self.panel.GoodScore.UObj)
			clickSuc=true
		else
			self:OnScoreChange(self.perfectScore)
			if self.clickState==self.ClickStateEnum.SuperPosition then
				self.continousAttackNum=self.continousAttackNum+1
				self.panel.ContinueClick.LabText = self.continousAttackNum
			else
				DG.Tweening.DOTween.Restart(self.panel.PerfectScore.UObj)
			end
			clickSuc=true
		end
		self.hammerModel.Ator:Play("Special", 0)
		if clickSuc then
			self.needPlayTiehuaEffect=true
			self:ShowEffect(false,"ClickEffect")
		end
	end)
	self.panel.BtnClose:AddClick(function()
		self:CloseSmallGame()
	end)
	self.ClickStateEnum=
	{
		Miss=1,
		Good=2,
		Perfect=3,
        SuperPosition=4,
	}
	self.stopChangeCircle=true
	self.clickState=self.ClickStateEnum.Miss
	self.needPlayTiehuaEffect=false
	self.coGameCountDown = coroutine.start(function()
		coroutine.wait(1.5)
		self:ShowEffect(false,"CountdownEffect")
		coroutine.wait(1.5)
		self.panel.OperateTip:SetActiveEx(true)
		self.gameStart=true
		local playTiehuaEffectDelayTime=0.35
		local currentWaitPlayEffectTime=0
		local waitPlayEffectState=false
		while true do
			if waitPlayEffectState then
				currentWaitPlayEffectTime=currentWaitPlayEffectTime+0.05
				if currentWaitPlayEffectTime>playTiehuaEffectDelayTime then
					waitPlayEffectState=false
					self:ShowEffect(false,"TieHuaEffect")
				end
			end
			coroutine.wait(0.05)
			if self.needPlayTiehuaEffect then
				if waitPlayEffectState then
					self:ShowEffect(false,"TieHuaEffect",3)
				end
				currentWaitPlayEffectTime=0
				waitPlayEffectState=true
				self.needPlayTiehuaEffect=false
			end
			self:ChangeCircleState()
		end
	end)
    self.continousAttackNum=0
    self.stopSuperPositionTimer = self:NewUITimer(function()
		if not self:IsShowing() then
			return
		end
        self.clickState=self.ClickStateEnum.Perfect
		self.panel.Crit:SetActiveEx(false)
		self.panel.ContinueTip:SetActiveEx(false)
		self.panel.CritTimeEffect:SetActiveEx(false)
		coroutine.stop(self.coGameCountDown)
		self.coGameCountDown=nil
        self:ExecuteOneStep("BtnFullScreen")
    end, self.superPositionTime, 1, false)

end --func end
--next--
function SmeltingCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function SmeltingCtrl:OnActive()
	local l_anim = self.panel.StartAnim:GetComponent("DOTweenAnimation")
	l_anim:DOPlay()
end --func end
--next--
function SmeltingCtrl:OnDeActive()
	if self.coGameCountDown~=nil then
		coroutine.stop(self.coGameCountDown)
		self.coGameCountDown=nil
	end
	if self.stopSuperPositionTimer~=nil then
		self:StopUITimer(self.stopSuperPositionTimer)
		self.stopSuperPositionTimer=nil
	end
	self:DestroyEffect()
	self:CloseSmallGame()
	if self.weaponModel then
		self:DestroyUIModel(self.weaponModel)
		self.weaponModel = nil
	end
	if self.hammerModel then
		self:DestroyUIModel(self.hammerModel)
		self.hammerModel = nil
	end
	if self.tieZhenModel then
		self:DestroyUIModel(self.tieZhenModel)
		self.tieZhenModel = nil
	end
end --func end
--next--
function SmeltingCtrl:Update()
	
	
end --func end





--next--
function SmeltingCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function SmeltingCtrl:ParseGameInfo(infoStr)
	local l_splitArray= Common.Utils.ParseString(infoStr,",",11)
	if l_splitArray==nil then
		logError("SmeltingCtrl:ParseGameInfo error!")
		self:ShowModel()
		return
	end
	self.missScore=tonumber(l_splitArray[1])
	self.goodScore=tonumber(l_splitArray[2])
	self.perfectScore=tonumber(l_splitArray[3])
	self.reduceCircleSpeed=tonumber(l_splitArray[4])
	self.enlargeCircleSpeed=tonumber(l_splitArray[5])
	self.superPositionTime=tonumber(l_splitArray[6]) --外圈与内圈重叠时间
	self.outerCircleLen=tonumber(l_splitArray[7])
	self.orangeCircleLen=tonumber(l_splitArray[8])
	self.yellowCircleLen=tonumber(l_splitArray[9])
	self.innerCircleLen=tonumber(l_splitArray[10])
	self.weaponName=l_splitArray[11]
	self:ShowModel()
end
function SmeltingCtrl:ChangeCircleState()
    if self.clickState==self.ClickStateEnum.SuperPosition then
        self.panel.outerCircle.UObj:SetRectTransformSize(self.innerCircleLen,self.innerCircleLen)
        return
    end
    local l_changeValue=0
    if self.circleChangeSmall then
        l_changeValue=self.panel.outerCircle.RectTransform.rect.size.x-self.reduceCircleSpeed
        if l_changeValue<self.innerCircleLen then
            l_changeValue=self.innerCircleLen
            self.circleChangeSmall=false
        end
    else
        l_changeValue=self.panel.outerCircle.RectTransform.rect.size.x+self.enlargeCircleSpeed
        if l_changeValue>self.outerCircleLen then
            l_changeValue=self.outerCircleLen
            self.circleChangeSmall=true
        end
    end
    if l_changeValue>self.orangeCircleLen then
        self.clickState=self.ClickStateEnum.Miss
    elseif l_changeValue>self.yellowCircleLen then
        self.clickState=self.ClickStateEnum.Good
    else
        self.clickState=self.ClickStateEnum.Perfect
    end
	local l_outCircleFactor= (l_changeValue-self.innerCircleLen)/(self.orangeCircleLen-self.innerCircleLen)
	if l_outCircleFactor>1 then
		l_outCircleFactor=1
	end
	local l_clickEffectSizeValue=210+l_outCircleFactor*(343-self.innerCircleLen)
	self.panel.ClickEffect.UObj:SetRectTransformSize(l_clickEffectSizeValue,l_clickEffectSizeValue)
	self.panel.outerCircle.UObj:SetRectTransformSize(l_changeValue,l_changeValue)
end
function SmeltingCtrl:SetSuperPositionState() --是指内外圈重合状态
    self.continousAttackNum=0
    self.clickState=self.ClickStateEnum.SuperPosition
    if self.stopSuperPositionTimer==nil then
        return
    end
	self:ShowEffect(false,"CritTimeEffect")
	self.panel.OperateTip:SetActiveEx(false)
	self.panel.Crit:SetActiveEx(true)
	self.panel.ContinueTip:SetActiveEx(true)
	self:StopUITimer(self.stopSuperPositionTimer)
    self.stopSuperPositionTimer:Start()
end
function SmeltingCtrl:OnScoreChange(addScore)
	if self.totalScore<50 then
		self.totalScore=self.totalScore+addScore
		if self.totalScore>=50 then
			self:SetSuperPositionState()
			self:ShowEffect(false,"StarTrailEffect")
			self:PlayStarsAnim(self.panel.Star01.RectTransform, function()
				self.panel.Bg:SetActiveEx(true)
				self.panel.StarTrailEffect:SetActiveEx(false)
				self:ShowEffect(false,"StarFlowEffect")
				self:ShowEffect(false,"StarDropEffect")
			end)
			self.panel.Star01:SetActiveEx(true)
		end
	elseif self.totalScore<80 then
		self.totalScore=self.totalScore+addScore
		if self.totalScore>=80 then
			self:ShowEffect(false,"StarTrailEffect1")
			self:PlayStarsAnim(self.panel.Star02.RectTransform, function()
				self.panel.Bg1:SetActiveEx(true)
				self:ShowEffect(false,"StarFlowEffect1")
				self.panel.StarTrailEffect1:SetActiveEx(false)
				self:ShowEffect(false,"StarDropEffect1")
			end)
			self.panel.Star02:SetActiveEx(true)
		end
	elseif 	self.totalScore<100 then
		self.totalScore=self.totalScore+addScore
		if self.totalScore>=100 then
			self:ShowEffect(false,"StarTrailEffect2")
			self:PlayStarsAnim(self.panel.Star03.RectTransform, function()
				self.panel.Bg2:SetActiveEx(true)
				self:ShowEffect(false,"StarFlowEffect2")
				self.panel.StarTrailEffect2:SetActiveEx(false)
				self:ShowEffect(false,"StarDropEffect2")
			end)
			self.panel.Star03:SetActiveEx(true)
			self:ShowEffect(false,"progressFullEffect")
		end
	else
		self.totalScore=self.totalScore+addScore
	end
	self.panel.SliderHp.Slider.value=self.totalScore/100
end
function SmeltingCtrl:PlayStarsAnim(rectT,callback)
	if IsNil(rectT) then
		return
	end
	local l_sourcePos=Vector2.New(141,327)
	local l_refPos=Vector2.New(500,162)
	MUITweenHelper.TweenBeziarMoveAnim(rectT,l_sourcePos,rectT.anchoredPosition,l_refPos,1000,DG.Tweening.Ease.InQuad,callback)
end
function SmeltingCtrl:ShowEffect(isLoad,effectName,speed)
	local l_fxData = {}
	if "StarFlowEffect"==effectName then
		l_fxData.rawImage = self.panel.StarFlowEffect.RawImg
		l_fxData.destroyHandler = function()
			self.starFlowFbID=0
		end
		l_fxData.scaleFac = Vector3.New(4,4,4)
		if isLoad then
			self.starFlowFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_01", l_fxData)
		else
			if self.starFlowFbID>0 then
				self:ReplayUIEffect(self.starFlowFbID,l_fxData)
			else
				self.starFlowFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_01", l_fxData)
			end
		end
	elseif "ClickEffect"==effectName then
		l_fxData.rawImage = self.panel.ClickEffect.RawImg
		l_fxData.destroyHandler = function()
			self.clickFbID=0
		end
		l_fxData.scaleFac = Vector3.New(2.2,2.2,2.2)
		if isLoad then
			self.clickFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_DianJiFanKui_01", l_fxData)
		else
			if self.clickFbID>0 then
				self:ReplayUIEffect(self.clickFbID,l_fxData)
			else
				self.clickFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_DianJiFanKui_01", l_fxData)
			end
		end
	elseif "progressFullEffect"==effectName then
		l_fxData.rawImage = self.panel.progressFullEffect.RawImg
		l_fxData.destroyHandler = function()
			self.progressFullID=0
		end
		l_fxData.scaleFac = Vector3.New(2,2,2)
		if isLoad then
			self.progressFullID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_JinDuBaoMan_01", l_fxData)
		else
			if self.progressFullID>0 then
				self:ReplayUIEffect(self.progressFullID,l_fxData)
			else
				self.progressFullID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_JinDuBaoMan_01", l_fxData)
			end
		end
	elseif "CountdownEffect"==effectName then
		l_fxData.rawImage = self.panel.CountdownEffect.RawImg
		l_fxData.destroyHandler = function()
			self.countDownID=0
		end
		l_fxData.scaleFac = Vector3.New(1,1,1)
		if isLoad then
			self.countDownID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_DaoJiShi_01", l_fxData)
		else
			if self.countDownID>0 then
				self:ReplayUIEffect(self.countDownID,l_fxData)
			else
				self.countDownID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_DaoJiShi_01", l_fxData)
			end
		end
	elseif "StarTrailEffect"==effectName then
		l_fxData.rawImage = self.panel.StarTrailEffect.RawImg
		l_fxData.destroyHandler = function()
			self.starTrailID=0
		end
		l_fxData.scaleFac = Vector3.New(4,4,4)
		if isLoad then
			self.starTrailID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingTuoWei_01", l_fxData)
		else
			if self.starTrailID>0 then
				self:ReplayUIEffect(self.starTrailID,l_fxData)
			else
				self.starTrailID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingTuoWei_01", l_fxData)
			end
		end
	elseif "StarDropEffect"==effectName then
		l_fxData.rawImage = self.panel.StarDropEffect.RawImg
		l_fxData.destroyHandler = function()
			self.starDropID=0
		end
		l_fxData.scaleFac = Vector3.New(3,3,3)
		if isLoad then
			self.starDropID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_02", l_fxData)
		else
			if self.starDropID>0 then
				self:ReplayUIEffect(self.starDropID,l_fxData)
			else
				self.starDropID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_02", l_fxData)
			end
		end
	elseif "CritTimeEffect"==effectName then
		l_fxData.rawImage = self.panel.CritTimeEffect.RawImg
		l_fxData.destroyHandler = function()
			self.critTimeID=0
		end
		l_fxData.scaleFac = Vector3.New(1,1,1)
		if isLoad then
			self.critTimeID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_BaoJiPingShan_01", l_fxData)
		else
			if self.critTimeID>0 then
				self:ReplayUIEffect(self.critTimeID,l_fxData)
			else
				self.critTimeID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_BaoJiPingShan_01", l_fxData)
			end
		end
	elseif "StarFlowEffect1"==effectName then
		l_fxData.rawImage = self.panel.StarFlowEffect1.RawImg
		l_fxData.destroyHandler = function()
			self.star1FlowFbID=0
		end
		l_fxData.scaleFac = Vector3.New(4,4,4)
		if isLoad then
			self.star1FlowFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_01", l_fxData)
		else
			if self.star1FlowFbID>0 then
				self:ReplayUIEffect(self.star1FlowFbID,l_fxData)
			else
				self.star1FlowFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_01", l_fxData)
			end
		end
	elseif "StarTrailEffect1"==effectName then
		l_fxData.rawImage = self.panel.StarTrailEffect1.RawImg
		l_fxData.destroyHandler = function()
			self.star1TrailID=0
		end
		l_fxData.scaleFac = Vector3.New(4,4,4)
		if isLoad then
			self.star1TrailID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingTuoWei_01", l_fxData)
		else
			if self.star1TrailID>0 then
				self:ReplayUIEffect(self.star1TrailID,l_fxData)
			else
				self.star1TrailID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingTuoWei_01", l_fxData)
			end
		end
	elseif "StarDropEffect1"==effectName then
		l_fxData.rawImage = self.panel.StarDropEffect1.RawImg
		l_fxData.destroyHandler = function()
			self.star1DropID=0
		end
		l_fxData.scaleFac = Vector3.New(3,3,3)
		if isLoad then
			self.star1DropID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_02", l_fxData)
		else
			if self.star1DropID>0 then
				self:ReplayUIEffect(self.star1DropID,l_fxData)
			else
				self.star1DropID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_02", l_fxData)
			end
		end
	elseif "StarFlowEffect2"==effectName then
		l_fxData.rawImage = self.panel.StarFlowEffect2.RawImg
		l_fxData.destroyHandler = function()
			self.starFlowFbID=0
		end
		l_fxData.scaleFac = Vector3.New(4,4,4)
		if isLoad then
			self.star2FlowFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_01", l_fxData)
		else
			if self.star2FlowFbID>0 then
				self:ReplayUIEffect(self.star2FlowFbID,l_fxData)
			else
				self.star2FlowFbID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_01", l_fxData)
			end
		end
	elseif "StarTrailEffect2"==effectName then
		l_fxData.rawImage = self.panel.StarTrailEffect2.RawImg
		l_fxData.destroyHandler = function()
			self.star2TrailID=0
		end
		l_fxData.scaleFac = Vector3.New(4,4,4)
		if isLoad then
			self.star2TrailID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingTuoWei_01", l_fxData)
		else
			if self.star2TrailID>0 then
				self:ReplayUIEffect(self.star2TrailID,l_fxData)
			else
				self.star2TrailID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingTuoWei_01", l_fxData)
			end
		end
	elseif "StarDropEffect2"==effectName then
		l_fxData.rawImage = self.panel.StarDropEffect2.RawImg
		l_fxData.destroyHandler = function()
			self.star2DropID=0
		end
		l_fxData.scaleFac = Vector3.New(3,3,3)
		if isLoad then
			self.star2DropID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_02", l_fxData)
		else
			if self.star2DropID>0 then
				self:ReplayUIEffect(self.star2DropID,l_fxData)
			else
				self.star2DropID = self:CreateUIEffect( "Effects/Prefabs/Creature/Ui/Fx_Ui_XingXingFanKui_02", l_fxData)
			end
		end
	elseif "TieHuaEffect"==effectName then
		l_fxData.rawImage = self.panel.TieHuaEffect.RawImg
		l_fxData.destroyHandler = function()
			self.tieHuaID=0
		end
		if speed~=nil then
			l_fxData.speed=speed
		end
		l_fxData.scaleFac = Vector3.New(3,3,3)
		local l_uiEffectPath = "Effects/Prefabs/Creature/CutScene/Fx_CutScene_ZhuangBeiDaZao_01"
		if isLoad then
			self.tieHuaID = self:CreateUIEffect( l_uiEffectPath, l_fxData)
		else
			if self.tieHuaID>0 then
				self:ReplayUIEffect(self.tieHuaID,l_fxData)
			else
				self.tieHuaID = self:CreateUIEffect(l_uiEffectPath, l_fxData)
			end
		end
	else
		logError("试图播放不存在的特效！"..tostring(effectName))
	end
	
end
function SmeltingCtrl:DestroyEffect()
	if self.starFlowFbID>0 then
		self:DestroyUIEffect(self.starFlowFbID)
		self.starFlowFbID=0
	end
	if self.clickFbID>0 then
		self:DestroyUIEffect(self.clickFbID)
		self.clickFbID=0
	end
	if self.progressFullID>0 then
		self:DestroyUIEffect(self.progressFullID)
		self.progressFullID=0
	end
	if self.countDownID>0 then
		self:DestroyUIEffect(self.countDownID)
		self.countDownID=0
	end
	if self.starTrailID>0 then
		self:DestroyUIEffect(self.starTrailID)
		self.starTrailID=0
	end
	if self.starDropID>0 then
		self:DestroyUIEffect(self.starDropID)
		self.starDropID=0
	end
	if self.critTimeID>0 then
		self:DestroyUIEffect(self.critTimeID)
		self.critTimeID=0
	end

	if self.star1FlowFbID>0 then
		self:DestroyUIEffect(self.star1FlowFbID)
		self.star1FlowFbID=0
	end
	if self.star1TrailID>0 then
		self:DestroyUIEffect(self.star1TrailID)
		self.star1TrailID=0
	end
	if self.star1DropID>0 then
		self:DestroyUIEffect(self.star1DropID)
		self.star1DropID=0
	end

	if self.star2FlowFbID>0 then
		self:DestroyUIEffect(self.star2FlowFbID)
		self.star2FlowFbID=0
	end
	if self.star2TrailID>0 then
		self:DestroyUIEffect(self.star2TrailID)
		self.star2TrailID=0
	end
	if self.star2DropID>0 then
		self:DestroyUIEffect(self.star2DropID)
		self.star2DropID=0
	end
	if self.tieHuaID>0 then
		self:DestroyUIEffect(self.tieHuaID)
		self.tieHuaID=0
	end
end
function SmeltingCtrl:ShowModel()
	if IsNil(self.tieZhenModel) then
		local l_modelData = 
        {
            prefabPath = "Prefabs/Monster_TieZhen",
            rawImage = self.panel.TieZhenRawImage.RawImg,
        }
		self.tieZhenModel = self:CreateUIModelByPrefabPath(l_modelData)
		self.tieZhenModel:AddLoadModelCallback(function(m)
			self.panel.TieZhenRawImage.RawImg.gameObject:SetActive(true)
			self.tieZhenModel.Trans:SetPos(0,0.3, 0)
			self.tieZhenModel.UObj:SetRotEuler(7, 258, 20)
		end)
	end

	if IsNil(self.weaponModel) then
		local l_modelData = 
        {
            prefabPath = "Prefabs/"..tostring(self.weaponName),
            rawImage = self.panel.WeaponRawImage.RawImg,
        }
		self.weaponModel = self:CreateUIModelByPrefabPath(l_modelData)
		self.weaponModel:AddLoadModelCallback(function(m)
			self.panel.WeaponRawImage.RawImg.gameObject:SetActive(true)
			self.weaponModel.Trans:SetPos(-1, 0.5, 4)
			self.weaponModel.Trans:SetLocalScale(3, 3, 3)
			self.weaponModel.UObj:SetRotEuler(6, -108, 27)
		end)
	end

	if IsNil(self.hammerModel) then
		local l_modelData = 
        {
            prefabPath = "Prefabs/Item_Collect_TieChui",
			rawImage = self.panel.HammerRawImage.RawImg,
			defaultAnim = "Anims/Collection/Item_Collect_TieChui/Item_Collect_TieChui_Idle",
        }
		self.hammerModel = self:CreateUIModelByPrefabPath(l_modelData)
		self.hammerModel.Ator:OverrideAnim("Special", "Anims/Collection/Item_Collect_TieChui/Item_Collect_TieChui_Qiao")
		self.hammerModel:AddLoadModelCallback(function(m)
			self.panel.HammerRawImage.RawImg.gameObject:SetActive(true)
			self.hammerModel.Trans:SetPos(0.75, 0.9, 0)
			self.hammerModel.Trans:SetLocalScale(3, 3, 3)
			self.hammerModel.UObj:SetRotEuler(-21, -30, 12)
		end)
	end
end
function SmeltingCtrl:NoticeShowEffect(effectName,showState)
	if not showState then
		return
	end
	self:ShowEffect(false,effectName)
end
--lua custom scripts end
return SmeltingCtrl