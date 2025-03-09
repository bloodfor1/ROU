--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PartyMainPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PartyMainCtrl = class("PartyMainCtrl", super)

local l_nowPlayDanceId = 0  --全局存储当前播放的舞蹈Id
local l_nextPlayDanceId = 0 --全局存储下一次需要播放的舞蹈Id

local l_showQuick = false
local l_startClick = false
local l_quickDanceId = 0
local l_quickLongTime = 0
local l_quickLongMax = 0.4
local l_quickLongPos
local l_quickDragGo
local l_customDragNum = 0
local l_startSetTime = false
local l_startSetPredictTime = true
local l_danceMusicAllTime = nil
local l_themePartyMgr = nil
local l_player = nil
local fx_ClickName = "Effects/Prefabs/Creature/Ui/Fx_Ui_CDFinish_01"
local fx_PlayingName = "Effects/Prefabs/Creature/Ui/Fx_Ui_JiNengXuanZhong_02"
--lua class define end

--lua functions
function PartyMainCtrl:ctor()
	
	super.ctor(self, CtrlNames.PartyMain, UILayer.Normal, nil, ActiveType.Normal)
	l_themePartyMgr = MgrMgr:GetMgr("ThemePartyMgr")
end --func end
--next--
function PartyMainCtrl:Init()
	self.panel = UI.PartyMainPanel.Bind(self)
	super.Init(self)
	self.panel.DanceBtnDataTable = 
	{
		{btn=self.panel.Dance01},
		{btn=self.panel.Dance02},
		{btn=self.panel.Dance03},
		{btn=self.panel.Dance04},
		{btn=self.panel.Dance05},
		{btn=self.panel.Dance06},
		{btn=self.panel.Dance07},
		{btn=self.panel.Dance08},
	}
	self.panel.DanceEditBtnDataTable = 
	{
		{obj=self.panel.Edit01},
		{obj=self.panel.Edit02},
		{obj=self.panel.Edit03},
		{obj=self.panel.Edit04},
		{obj=self.panel.Edit05},
	}
	self.panel.DanceActionIndexTb = 
	{

	}
	self:InitDanceBtnPanel()
	self:InitDanceEditBtnPanel()
end --func end
--next--
function PartyMainCtrl:Uninit()
	
	super.Uninit(self)
	self:resetData()
	self.panel = nil
	
end --func end
--next--
function PartyMainCtrl:OnActive()
	l_player = MEntityMgr.PlayerEntity
	self:InitPanel()
end --func end
--next--
function PartyMainCtrl:OnDeActive()
	self.statrRunMusic = false
	self:DestoryDanceActionIndexPanel()
end --func end
--next--
function PartyMainCtrl:Update()

	-----以下处理跳舞按钮上面的进度条显示----------------------
	l_nowPlayDanceId = l_player.DanceComp:GetDanceId()
	if l_nowPlayDanceId == 0 then
		self:ResetAllCd(l_nowPlayDanceId)
	end

	if l_nowPlayDanceId and self.panel.DanceBtnDataTable[l_nowPlayDanceId] then
		local cdImg = self.panel.DanceBtnDataTable[l_nowPlayDanceId].cdImg
		local dancePercent = l_player.DanceComp:GetDancePercent()
		self:ResetAllCd(l_nowPlayDanceId)
		cdImg.Img.fillAmount = dancePercent
	end

	--如果有下个需要播放的动作 设置当前为播放Id为下个动作Id 下个动作Id重置
	if l_nextPlayDanceId ~= 0 and not l_player.IsDancing then --and l_player.DanceComp:GetDancePercent() >= 0.99 
        MgrMgr:GetMgr("ThemePartyMgr").DoDanceReq(l_nextPlayDanceId)
        --有预加载特效则关闭
        self:DestroyRewardFx(self.panel.DanceBtnDataTable[l_nextPlayDanceId])
        --重置下个播放数据
        l_nextPlayDanceId = 0
    end

	self:SetDanceTipsIndex(l_nowPlayDanceId,l_nextPlayDanceId)

	----以下处理编辑跳舞按钮拖动逻辑处理----------------------
	if l_showQuick and l_startClick then
		l_quickLongTime=l_quickLongTime+Time.deltaTime
		if l_quickLongTime>l_quickLongMax then
			if not l_quickDragGo then
				l_quickDragGo=self.panel.DanceDragGo.gameObject
				l_quickDragGo.transform.position=l_quickLongPos
				l_quickDragGo:SetActiveEx(true)
				local danceTableData = TableUtil.GetDanceActionTable().GetRowById(l_quickDanceId)
				if danceTableData then
					self.panel.DanceDragGo:SetSprite(danceTableData.AnimationAtlas, danceTableData.AnimationIcon)
				end
			end
		end
	end

	-----以下处理时间的倒计时
	if l_startSetTime then
		local l_decNumber = l_themePartyMgr.l_time - Common.TimeMgr.GetNowTimestamp()
		if l_decNumber > 0 then
		local l_remainintMerchantRet =  Common.TimeMgr.GetCountDownDayTimeTable(l_decNumber)
			self.panel.TextLeftTime.LabText = StringEx.Format("{0:00}:{1:00}:{2:00}", l_remainintMerchantRet.hour,l_remainintMerchantRet.min, l_remainintMerchantRet.sec)
		else
			self.panel.TextLeftTime.LabText = "00:00:00"
		end
	end

	--以下处理抽奖预告
	if l_startSetPredictTime and l_themePartyMgr.l_lotteryPredictType ~= nil then
		local l_predictTime = l_themePartyMgr.l_lotteryPredictLeftTime - Common.TimeMgr.GetNowTimestamp()
		if l_predictTime > 0 then
			local l_remainintMerchantRet =  Common.TimeMgr.GetCountDownDayTimeTable(l_predictTime)
			self.panel.PredictLeftTime.LabText = StringEx.Format("{0:00}:{1:00}:{2:00}", l_remainintMerchantRet.hour,l_remainintMerchantRet.min, l_remainintMerchantRet.sec)..Lang("LOTTERY_PREDICT")
		else
			l_startSetPredictTime = false
			self:SetLotteryPredictPanel()
			if l_themePartyMgr.l_lotteryPredictType ~= ThemePartyLotteryType.kLotteryTypeLuckyPrize then
				local l_time = self:NewUITimer(function()
					l_themePartyMgr.RequestLotteryDrawInfo()
				end,l_themePartyMgr.l_lotteryKeepTime) --10s预告
				l_time:Start()
			end
			self.panel.PredictLeftTime.LabText = "00:00:00"
		end
	end
	
	--音乐文本跑动
	if self.statrRunMusic then
		self.runDis = self.panel.MusicName.RectTransform.sizeDelta.x
		if self.panel.MusicName.RectTransform.anchoredPosition.x < -self.runDis-20 then
			self.panel.MusicName.RectTransform.anchoredPosition = Vector2.New(self.runDis+20,0)
		end
		self.panel.MusicName.RectTransform.anchoredPosition = Vector2.New(self.panel.MusicName.RectTransform.anchoredPosition.x - Time.deltaTime*40,0)
	end

	self:SetDanceLeftInfo()
end --func end



--next--
function PartyMainCtrl:OnShow()
	
	self:SetLotteryPredictPanel()
end --func end

--next--
function PartyMainCtrl:BindEvents()
	self:BindEvent(l_themePartyMgr.EventDispatcher,l_themePartyMgr.ON_GET_THEM_PARTYACTIVITY_INFO,function()
		self:SetDanceBasicInfo()
	end)
	self:BindEvent(l_themePartyMgr.EventDispatcher,l_themePartyMgr.ON_SAVE_DANCE_SETUP_INFO,function()
		self:SetDanceBtnEdit()
	end)
	self:BindEvent(l_themePartyMgr.EventDispatcher,l_themePartyMgr.ON_SAVE_DANCE_SETUP_INFO_FAILED,function()
		self:SetDanceBtnEdit()
	end)
	self:BindEvent(l_themePartyMgr.EventDispatcher,l_themePartyMgr.ON_GET_THEM_PARTY_MUSIC_CHANGE,function()
		self:SetMusicPanel()
	end)
	self:BindEvent(l_themePartyMgr.EventDispatcher,l_themePartyMgr.ON_DANCE_ACTION_CHANGE,function()
		self:ShowDanceAction()
	end)
	self:BindEvent(l_themePartyMgr.EventDispatcher,l_themePartyMgr.ON_GET_LOTTERY_LEFT_TIME,function()
		self:SetLotteryPredictPanel()
	end)
	self:BindEvent(l_themePartyMgr.EventDispatcher,l_themePartyMgr.ON_DANCE_STOPED,function()
        if l_nextPlayDanceId ~= 0 then
            --有预加载特效则关闭
            self:DestroyRewardFx(self.panel.DanceBtnDataTable[l_nextPlayDanceId])
            --重置下个播放数据
			l_nextPlayDanceId = 0
		end
		self:ResetDanceTipsIndex()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function PartyMainCtrl:InitPanel( ... )
	self:InitDanceActionIndexPanel()
	self:ResetDanceTipsIndex()
	self:SetDanceInfoPanel()
	self:SetMusicPanel()
	self:SetDanceBtnPanel()
	self:SetDanceBtnEditPanel()
	self:SetLotteryPredictPanel()
	--初始化不显示抽奖预测界面
	self.panel.LotteryPredict.gameObject:SetActiveEx(false)
end

function PartyMainCtrl:SetDanceInfoPanel( ... )
	self:SetDanceBasicInfo()
	self.panel.BtnInfo.Listener.onClick = function(go, eventData)
		local l_infoText = Lang("PARTY_MAIN_INFORMATION")
		local pos = Vector2.New(eventData.position.x,eventData.position.y+160) 
		eventData.position = pos
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, Vector2(0, 1))
	end
	self.panel.BtnLake:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.LakeList)
	end)
	self.panel.BtnLuckyStar:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.PartyLuckStar)
	end)
end

function PartyMainCtrl:SetDanceBasicInfo()
	self.panel.PartyInfoTitle.LabText = l_themePartyMgr.GetPanelShowTitle()
	self.panel.TextLuckyCode.LabText = l_themePartyMgr.l_lucky_no or "000000"
	self.panel.TextLakeNum.LabText = l_themePartyMgr.l_love_num or "0"
	if l_themePartyMgr.l_time and l_themePartyMgr.l_time ~= 0 then
		l_startSetTime = true
	end

	--跳舞序列界面显示
	local state = l_themePartyMgr.l_themePartyEnumClientState == ThemePartyClientState.kPartyStateDance and not l_themePartyMgr.l_completeFirstRightDance
	self.panel.DanceIndex.gameObject:SetActiveEx(state)
	self:ShowDanceAction()
end

function PartyMainCtrl:SetMusicPanel()
	if self.panel == nil then return end
	if l_themePartyMgr.l_musicIndex == nil or l_themePartyMgr.l_musicIndex == 0 then
		self.panel.Music.gameObject:SetActiveEx(false)
		self.statrRunMusic = false
		return 
	end
	--新增需求 显示歌曲进度
	self.panel.PartyInfoTitle.LabText = l_themePartyMgr.GetPanelShowTitle()
	local newIndex = l_themePartyMgr.GetDanceBGMIndex(l_themePartyMgr.l_musicIndex)
	local l_row = TableUtil.GetThemePartyBGMTable().GetRowById(newIndex)
	if l_row == nil then return end
	
	self.panel.Music.gameObject:SetActiveEx(true)
	self.panel.MusicName.LabText = l_row.BGMName
	self.statrRunMusic = true
	self:PlayBgm(l_row.BGMEvent)
	self:SetDanceLeftInfo()
end

function PartyMainCtrl:PlayBgm( EventName )
	MAudioMgr:PlayBGM(EventName)
end

function PartyMainCtrl:SetDanceLeftInfo()
	if l_danceMusicAllTime == nil then
		l_danceMusicAllTime = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("DanceBgmLastTime").Value)
	end
	local l_totalTime = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("DanceBgmLastTime").Value)
	local l_decNumber = l_totalTime - (l_themePartyMgr.l_nowMusicDuration - Common.TimeMgr.GetNowTimestamp())
	if l_decNumber > 0 then
		local l_remainintMerchantRet =  Common.TimeMgr.GetCountDownDayTimeTable(l_decNumber)
		self.panel.Time.LabText = StringEx.Format("{0:00}:{1:00}",l_remainintMerchantRet.min, l_remainintMerchantRet.sec).."/"..l_themePartyMgr.l_musicTotalTime
		if l_totalTime-l_decNumber < l_themePartyMgr.l_showDanceGroupListTime then
			self.panel.DanceIndexTips.LabText = l_themePartyMgr.l_showGroupIdTips
		else
			self.panel.DanceIndexTips.LabText = Lang("FINISH_DANCE_SUNNCESSFULY")
		end
	else
		self.panel.Time.LabText = "00:00/"..l_themePartyMgr.l_musicTotalTime
		self.panel.DanceIndexTips.LabText = Lang("FINISH_DANCE_SUNNCESSFULY")
	end
	self.panel.MusicSlider.Slider.value = l_decNumber/l_danceMusicAllTime 
end

----以下是跳舞按钮逻辑部分----------------
MAX_PARTY_NUMBER = 8			--跳舞按钮的最大数量
CUSTOM_PARTY_SKILL_NUMBER = 8	--自定义按钮的位置
CUSTOM_LIST_DANCE_ID = 0 		--默认的自定义按钮的Id
CUSTOM_LIST_RESET_ID = 0		--自定义按钮的默认ID
function PartyMainCtrl:InitDanceBtnPanel()
	for i=1,MAX_PARTY_NUMBER do
		if self.panel.DanceBtnDataTable[i].btn then
			local cdImg = self.panel.DanceBtnDataTable[i].btn.transform:Find("SkillCD0"):GetComponent("MLuaUICom")
			local effectImg = self.panel.DanceBtnDataTable[i].btn.transform:Find("SkillEffect"):GetComponent("MLuaUICom")
			self.panel.DanceBtnDataTable[i].cdImg = cdImg
			self.panel.DanceBtnDataTable[i].effectImg = effectImg
		end
	end
end

--跳舞按钮点击方法
function PartyMainCtrl:DoDanceFunc( danceId,btnData )
	--if l_showQuick then return end --快捷操作模式不执行按钮逻辑
	--没有舞台属性 判定
	if MEntityMgr.PlayerEntity:GetAttr(AttrType.ATTR_SPECIAL_DANCE) <= 0  then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CAN_NOT_DANCE"))
		return
	end

	if danceId ~= CUSTOM_LIST_DANCE_ID then
		--当玩家不在跳舞中 发送跳舞协议 并且记录当前的动作ID
		if not MEntityMgr.PlayerEntity.IsDancing then
			self:CreateRewardFx(fx_ClickName,btnData)
			MgrMgr:GetMgr("ThemePartyMgr").DoDanceReq(danceId)
		--当玩家在跳舞中 记录下一次跳舞的舞蹈Id
		else
			if l_nextPlayDanceId ~= 0 then
				self:DestroyRewardFx(self.panel.DanceBtnDataTable[l_nextPlayDanceId])
			end
			l_nextPlayDanceId = danceId
			--播放预播放特效
			self:CreateRewardFx(fx_PlayingName,btnData)
		end
	else
		MgrMgr:GetMgr("ThemePartyMgr").DoDanceReq(danceId)
	end
end

function PartyMainCtrl:CreateRewardFx(effectName,btnData)
	self:DestroyRewardFx(btnData)
	btnData.rewardEffectId = btnData.rewardEffectId or 0
	local l_fxData = {}
	l_fxData.rawImage = btnData.effectImg.RawImg
	l_fxData.destroyHandler = function ()
		btnData.rewardEffectId = 0
	end
	btnData.rewardEffectId = self:CreateUIEffect(effectName,l_fxData)
	
end

function PartyMainCtrl:DestroyRewardFx( btnData )
	if btnData.rewardEffectId and btnData.rewardEffectId ~= 0 then
		self:DestroyUIEffect(btnData.rewardEffectId)
		btnData.rewardEffectId = 0
	end
end

function PartyMainCtrl:SetDanceBtnPanel( ... )
	for i=1,MAX_PARTY_NUMBER do
		if self.panel.DanceBtnDataTable[i].btn then
			if i == CUSTOM_PARTY_SKILL_NUMBER then
				self.panel.DanceBtnDataTable[i].btn:AddClick(function()
					if l_themePartyMgr.IsDanceCustomDataInfoListEmpty() then
						MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EDIT_CUSTOM_DANCEBTN_FIRST"))
						return
					end
					self:DoDanceFunc(CUSTOM_LIST_DANCE_ID)
				end)
			else
				local danceTableData = TableUtil.GetDanceActionTable().GetRowById(i,true)
				if danceTableData then
					local animationData = TableUtil.GetAnimationTable().GetRowByID(danceTableData.AnimationTableId)
					self.panel.DanceBtnDataTable[i].btn:SetSprite(danceTableData.AnimationAtlas, danceTableData.AnimationIcon)
					self.panel.DanceBtnDataTable[i].btn:AddClick(function()
						self:DoDanceFunc(danceTableData.Id,self.panel.DanceBtnDataTable[i])
					end)
					--self.panel.DanceBtnDataTable[i].maxTime = animationData.MaxTime
					--self.panel.DanceBtnDataTable[i].buffDec = 0 --这个是一个记录Buff减时间数值 暂时填写0
					--self.panel.DanceBtnDataTable[i].nowPlayTime = 0	--这个记录当前播放的时间
					self.panel.DanceBtnDataTable[i].cdImg.Img.fillAmount = 0
					self:SetDragGo(self.panel.DanceBtnDataTable[i].btn,danceTableData.Id)
				end
			end
		end
	end

	self.panel.BtnEdit:AddClick(function()
		self.panel.DanceEdit.gameObject:SetActiveEx(true)
		self:SetDanceBtnEdit()
		l_showQuick = true
	end)
end

function PartyMainCtrl:ResetAllCd(withoutId)
	local cWithoutId = withoutId or 999 
	for i=1,MAX_PARTY_NUMBER do
		if i ~= cWithoutId and self.panel.DanceBtnDataTable[i].cdImg then
			self.panel.DanceBtnDataTable[i].cdImg.Img.fillAmount = 0
		end
	end
end
----以上是跳舞按钮逻辑部分----------------

----以下是跳舞按钮自定义编辑部分----------------
MAX_DANCE_BTN_EDIT_NUM= 5
function PartyMainCtrl:InitDanceEditBtnPanel()
	for i=1,MAX_DANCE_BTN_EDIT_NUM do
		if self.panel.DanceEditBtnDataTable[i].obj then
			self.panel.DanceEditBtnDataTable[i].btnAdd = self.panel.DanceEditBtnDataTable[i].obj.transform:Find("Add"):GetComponent("MLuaUICom")
			self.panel.DanceEditBtnDataTable[i].imgDance = self.panel.DanceEditBtnDataTable[i].obj.transform:Find("DanceImage"):GetComponent("MLuaUICom")
			self.panel.DanceEditBtnDataTable[i].btnClose = self.panel.DanceEditBtnDataTable[i].obj.transform:Find("BtnEmpty"):GetComponent("MLuaUICom")
			self.panel.DanceEditBtnDataTable[i].editSelect = self.panel.DanceEditBtnDataTable[i].obj.transform:Find("EditSelect"):GetComponent("MLuaUICom")
			self.panel.DanceEditBtnDataTable[i].customNumber = i
		end
	end
end

--初始化跳舞个数界面
function PartyMainCtrl:InitDanceActionIndexPanel( ... )
	local actionTb,maxNum = l_themePartyMgr.GetDanceActionData()
	for i=1,maxNum do
		self.panel.DanceActionIndexTb[i] = {}
        self.panel.DanceActionIndexTb[i].ui = self:CloneObj(self.panel.TemIndex.gameObject)
        self.panel.DanceActionIndexTb[i].ui.transform:SetParent(self.panel.InfoGrid.transform)
        self.panel.DanceActionIndexTb[i].ui.transform:SetLocalScaleOne()
		self.panel.DanceActionIndexTb[i].ui:SetActiveEx(true)
		self.panel.DanceActionIndexTb[i].isRight = self.panel.DanceActionIndexTb[i].ui.transform:Find("IsRight").gameObject
		self.panel.DanceActionIndexTb[i].isWrong = self.panel.DanceActionIndexTb[i].ui.transform:Find("IsWrong").gameObject
		self.panel.DanceActionIndexTb[i].partyNum = self.panel.DanceActionIndexTb[i].ui.transform:Find("PartyNum"):GetComponent("MLuaUICom")
		self.panel.DanceActionIndexTb[i].partyNum.LabText = ""
		self.panel.DanceActionIndexTb[i].partyNum:SetActiveEx(true)
	end
	self.panel.TemIndex.gameObject:SetActiveEx(false)
	self.panel.DanceIndex.gameObject:SetActiveEx(false)
end

--removeAll 重置后在设置
function PartyMainCtrl:SetDanceTipsIndex(nowPlayId,nextPlayId)
	if nowPlayId == 0 or nowPlayId == nil then 
		return 
	end
	
	for i=1,table.maxn(self.panel.DanceActionIndexTb) do
		local l_danceActionIndexData = self.panel.DanceActionIndexTb[i]
		local l_danceActionIndexUi = l_danceActionIndexData and self.panel.DanceActionIndexTb[i].ui or nil
		if l_danceActionIndexData and l_danceActionIndexUi then
			if not l_danceActionIndexData.isRight.activeSelf and not l_danceActionIndexData.isRight.activeSelf then
				getNowPos = i
				getNextPos = i+1
				break
			end
		end
	end

	if getNowPos and nowPlayId then
		local l_danceActionIndexData = self.panel.DanceActionIndexTb[getNowPos]
		local l_danceActionIndexUi = l_danceActionIndexData and self.panel.DanceActionIndexTb[getNowPos].ui or nil
		if l_danceActionIndexData and l_danceActionIndexUi and l_danceActionIndexUi.gameObject.activeSelf then
			-- l_danceActionIndexData.partyNum.gameObject:SetActiveEx()
			l_danceActionIndexData.partyNum.LabText = nowPlayId ~= 0 and nowPlayId or ""
		end
	end

	if getNextPos and nextPlayId then
		local l_danceActionIndexData = self.panel.DanceActionIndexTb[getNextPos]
		local l_danceActionIndexUi = l_danceActionIndexData and self.panel.DanceActionIndexTb[getNextPos].ui or nil
		if l_danceActionIndexData and l_danceActionIndexUi and l_danceActionIndexUi.gameObject.activeSelf then
			-- l_danceActionIndexData.partyNum.gameObject:SetActiveEx(nextPlayId ~= 0)
			l_danceActionIndexData.partyNum.LabText = nextPlayId ~= 0 and nextPlayId or ""
		end
	end
end

function PartyMainCtrl:ResetDanceTipsIndex()
	for i=1,table.maxn(self.panel.DanceActionIndexTb) do
		local l_danceActionIndexData = self.panel.DanceActionIndexTb[i]
		local l_danceActionIndexUi = l_danceActionIndexData and self.panel.DanceActionIndexTb[i].ui or nil
		if l_danceActionIndexData and l_danceActionIndexUi then
			l_danceActionIndexData.partyNum.LabText = ""
		end
	end
end

function PartyMainCtrl:DestoryDanceActionIndexPanel( ... )
	for i=1,#self.panel.DanceActionIndexTb do
		if self.panel.DanceActionIndexTb[i].ui then
			MResLoader:DestroyObj(self.panel.DanceActionIndexTb[i].ui)
		end
	end
end

function PartyMainCtrl:ShowDanceAction()
	if self.panel == nil then return end
	for i=1,#self.panel.DanceActionIndexTb do
		if self.panel.DanceActionIndexTb[i].ui then
			self.panel.DanceActionIndexTb[i].ui:SetActiveEx(false)
			self.panel.DanceActionIndexTb[i].isRight.gameObject:SetActiveEx(false)
			self.panel.DanceActionIndexTb[i].isWrong.gameObject:SetActiveEx(false)
		end
	end

	--抽奖状态 关闭跳舞序列界面
	local state = l_themePartyMgr.l_themePartyEnumClientState == ThemePartyClientState.kPartyStateDance
	if l_themePartyMgr.l_danceActionLength > 0 and state and not l_themePartyMgr.l_completeFirstRightDance then
		self.panel.DanceIndex.gameObject:SetActiveEx(true)
		for i=1,l_themePartyMgr.l_danceActionLength do
			if self.panel.DanceActionIndexTb[i].ui then
				self.panel.DanceActionIndexTb[i].ui.gameObject:SetActiveEx(true)
			end
			--跳错了
			if l_themePartyMgr.l_beforDanceRightIndex >= 0 then
				if i <= l_themePartyMgr.l_beforDanceRightIndex then
					self.panel.DanceActionIndexTb[i].isRight.gameObject:SetActiveEx(true)
				end
				if i == l_themePartyMgr.l_beforDanceRightIndex + 1 then
					self.panel.DanceActionIndexTb[i].isWrong.gameObject:SetActiveEx(true)
				end
			else
				if i <= l_themePartyMgr.l_index then
					self.panel.DanceActionIndexTb[i].isRight.gameObject:SetActiveEx(true)
				end
			end
		end
	end

	--跳错了等待0.5秒 刷新下界面
	if l_themePartyMgr.l_beforDanceRightIndex >= 0 then
		local l_time = self:NewUITimer(function()
			l_themePartyMgr.ResetDanceActionFlags()
			self:ShowDanceAction()
			self:ResetDanceTipsIndex() 
			l_time = nil
		end, l_themePartyMgr.l_wrongDanceShowTime)
		l_time:Start()
	end

	--全部跳对了 关掉跳舞界面 
	if l_themePartyMgr.l_index>0 and l_themePartyMgr.l_index == l_themePartyMgr.l_danceActionLength and not l_themePartyMgr.l_completeFirstRightDance then
		l_themePartyMgr.l_completeFirstRightDance = true
		local l_time1 = self:NewUITimer(function()
			self.panel.DanceIndex.gameObject:SetActiveEx(false)
			l_themePartyMgr.ResetDanceActionFlags()
			self:ResetDanceTipsIndex()
			l_time1 = nil
		end, l_themePartyMgr.l_wrongDanceShowTime)
		l_time1:Start()
	end
end

function PartyMainCtrl:SetDanceBtnEditPanel( ... )
	self.panel.DanceEdit.gameObject:SetActiveEx(false)
	self.panel.BtnCloseDanceEdit:AddClick(function()
		self.panel.DanceEdit.gameObject:SetActiveEx(false)
		l_showQuick = false
	end)
	self.panel.BtnDanceEditInfo.Listener.onClick = function(go, eventData)
		local l_infoText = Lang("PARTY_SKILL_INFORMATION")
		local pos = Vector2.New(eventData.position.x,eventData.position.y) 
		eventData.position = pos
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, Vector2(1, 0))
	end
end

--预告面板
function PartyMainCtrl:SetLotteryPredictPanel( ... )
	local state = l_themePartyMgr.l_themePartyEnumClientState == ThemePartyClientState.kPartyStateLottery
	self.panel.LotteryPredict.gameObject:SetActiveEx(state)
	if l_themePartyMgr.l_lotteryPredictType == nil then return end

	local infotableData,awardtableData,rankNum,rankTitle = l_themePartyMgr.GetPrizeTableDataByType(l_themePartyMgr.l_lotteryPredictType)
	self.panel.PredictTitle.LabText = rankTitle
	self.panel.PredictIcon:SetSprite("CommonIcon","UI_CommonIcon_Rank"..rankNum..".png")

	local l_predictTime = l_themePartyMgr.l_lotteryPredictLeftTime - Common.TimeMgr.GetNowTimestamp()
	if l_predictTime > 0 then
		if state then l_startSetPredictTime = true end
		self.panel.PredictLeftTime.gameObject:SetActiveEx(true)
		self.panel.IsOpenPredect.gameObject:SetActiveEx(false)
	else
		--幸运奖不显示揭晓
		if l_themePartyMgr.l_lotteryPredictType == ThemePartyLotteryType.kLotteryTypeLuckyPrize then
			l_startSetPredictTime = false
			self.panel.LotteryPredict.gameObject:SetActiveEx(false)
		end
		self.panel.PredictLeftTime.gameObject:SetActiveEx(false)
		self.panel.IsOpenPredect.gameObject:SetActiveEx(true)
	end
	self.panel.BtnCheck:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.PartyLuckStar)
	end)
end

--根据数据初始化 自定义组合的按钮
function PartyMainCtrl:SetDanceBtnEdit()
	self:resetData()
	self.panel.BtnDanceEditToggle.Tog.onValueChanged:RemoveAllListeners()
	self.panel.BtnDanceEditToggle.Tog.isOn = l_themePartyMgr.l_customIsLoop
	for i=1,MAX_DANCE_BTN_EDIT_NUM do
		local setEmpty = function ()
			self.panel.DanceEditBtnDataTable[i].imgDance.gameObject:SetActiveEx(false)
			self.panel.DanceEditBtnDataTable[i].btnClose.gameObject:SetActiveEx(false)
			self.panel.DanceEditBtnDataTable[i].editSelect.gameObject:SetActiveEx(false)
			self.panel.DanceEditBtnDataTable[i].obj.Listener.onClick = function ()
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EDIT_CUSTOM_BTN_NIL"))
			end
		end
		local setExist = function ()
			self.panel.DanceEditBtnDataTable[i].imgDance.gameObject:SetActiveEx(true)
			self.panel.DanceEditBtnDataTable[i].btnClose.gameObject:SetActiveEx(true)
			self.panel.DanceEditBtnDataTable[i].editSelect.gameObject:SetActiveEx(false)
			self.panel.DanceEditBtnDataTable[i].obj.Listener.onClick = function ()
			end
		end
		if self.panel.DanceEditBtnDataTable[i].obj then
			local cData = l_themePartyMgr.l_themePartyDanceCustomDataInfo[i]
			--有服务器数据按照数据设置
			if cData and cData ~= 0 then
				setExist()
				self:SetDanceEditBtnByNumAndId(i,cData)
			--没有服务器数据设置为空
			else
				setEmpty()
			end
			self.panel.DanceEditBtnDataTable[i].btnClose:AddClick(function()
				setEmpty()
				self:CustomDanceList(i,CUSTOM_LIST_RESET_ID)
			end)
			self:SetDanceBtnEditListener(self.panel.DanceEditBtnDataTable[i])
		end
	end

	local state = l_themePartyMgr.l_themePartyEnumClientState == ThemePartyClientState.kPartyStateDance
	self.panel.BtnNotClickToggle.gameObject:SetActiveEx(state)
	self.panel.BtnDanceEditToggleGray.gameObject:SetActiveEx(state)
	self.panel.BtnNotClickToggle:AddClick(function()
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CAN_NOT_USE_IN_THIS_STATE"))
	end)

	self.panel.BtnDanceEditToggle.Tog.onValueChanged:AddListener(function(value)
		if value == l_themePartyMgr.l_customIsLoop then return end
		l_themePartyMgr.SetLoopDanceGroup(nil,value)
	end)
end

function PartyMainCtrl:SetDanceEditBtnByNumAndId(num,id)
	if num==nil or num == 0 or id==nil or id==0 then 
		return 
	end
	if self.panel.DanceEditBtnDataTable[num].obj then
		local danceTableData = TableUtil.GetDanceActionTable().GetRowById(id)
		if danceTableData then
			self.panel.DanceEditBtnDataTable[num].imgDance.gameObject:SetActiveEx(true)
			self.panel.DanceEditBtnDataTable[num].btnClose.gameObject:SetActiveEx(true)
			self.panel.DanceEditBtnDataTable[num].editSelect.gameObject:SetActiveEx(false)
			local animationData = TableUtil.GetAnimationTable().GetRowByID(danceTableData.AnimationTableId)
			self.panel.DanceEditBtnDataTable[num].imgDance:SetSprite(danceTableData.AnimationAtlas, danceTableData.AnimationIcon)
		end
	end
end

function PartyMainCtrl:SetDanceBtnEditListener(objData)
	objData.obj.Listener.onEnter=(function()
		if l_quickDragGo then
			l_customDragNum = objData.customNumber
			objData.editSelect.gameObject:SetActiveEx(true)
		end
	end)
	objData.obj.Listener.onExit=(function()
		objData.editSelect.gameObject:SetActiveEx(false)
	end)
end

----以上是跳舞按钮自定义编辑部分----------------

--重置标志位数据
function PartyMainCtrl:resetData()
	l_startClick = false
	if l_quickDragGo then
		l_quickDragGo.gameObject:SetActiveEx(false) 
	end
	l_quickDragGo = nil
	l_quickLongTime = 0
end

function PartyMainCtrl:SetDragGo(button,quickDanceId)
	
	button.Listener.onDown=(function(go,eventData)
		if l_showQuick==true then
			local l_cgPos=MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
			l_quickLongTime = 0
			l_quickDanceId = quickDanceId
			l_startClick = true
			l_cgPos.z=0
			l_quickLongPos = l_cgPos
		end
	end)

	button.Listener.onUp=(function(go,eventData)
		self:resetData()
	end)

	button.Listener.onDrag=(function(go,eventData)
		if l_quickDragGo then
			local l_cgPos=MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
			l_cgPos.z=0
			l_quickDragGo.transform.position=l_cgPos
		else
			self:resetData()
		end
	end)

	--结束拖拽 发送设置协议
	button.Listener.endDrag=(function()
		self:CustomDanceList(l_customDragNum,l_quickDanceId)
		l_quickDanceId = 0
		l_customDragNum = 0
		self:resetData()
	end)
end

function PartyMainCtrl:CustomDanceList(customNum,customId)
	local tempDataInfo = l_themePartyMgr.GetTempPartyDanceCustomDataInfo()
	if tempDataInfo[customNum] then
		tempDataInfo[customNum] = customId
	end
	--logError(ToString(tempDataInfo))
	self:SetDanceTipsIndex(0,0,true)
	l_themePartyMgr.SetLoopDanceGroup(tempDataInfo,self.panel.BtnDanceEditToggle.Tog.isOn)
end
--lua custom scripts end
return PartyMainCtrl