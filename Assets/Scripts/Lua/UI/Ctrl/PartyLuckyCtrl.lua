--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PartyLuckyPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PartyLuckyCtrl = class("PartyLuckyCtrl", super)
--lua class define end

--lua functions
function PartyLuckyCtrl:ctor()
	
	super.ctor(self, CtrlNames.PartyLucky, UILayer.Function, nil, ActiveType.None)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.PartyLucky
	self.MaskDelayClickTime=3
	
end --func end
--next--
local l_themePartyMgr = nil
maxNumItemSize = 6
getPrizeNum = 0
getPrizeName = ""
getPrizeMaxNum = 0
function PartyLuckyCtrl:Init()
	self.panel = UI.PartyLuckyPanel.Bind(self)
	super.Init(self)
	l_themePartyMgr = MgrMgr:GetMgr("ThemePartyMgr")
	self:InitNumberItemSlot()
	self.lotteryLuckyItem = {}
end --func end
--next--
function PartyLuckyCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function PartyLuckyCtrl:OnActive()
	self.panel.TitleText.LabText = Lang("NONE_REWARD")
	UIMgr:DeActiveUI(UI.CtrlNames.PartyLottery)
	--self:SetBlockOpt(BlockColor.Dark,function ()
	--	UIMgr:DeActiveUI(UI.CtrlNames.PartyLucky)
	--end,3)
end --func end
--next--
function PartyLuckyCtrl:OnDeActive()
	self:DestoryTweenEffect()
	self:DestoryPointFinishEffect()
	self:UnLoadLuckTemPlent()
	self:UnLoadScrollPlent()
end --func end
--next--
function PartyLuckyCtrl:Update()
	for i=1,maxNumItemSize do
		if self.numberScrollItems[i].isInited then
			self.numberScrollItems[i]:Update()
		end
	end
end --func end

--next--
function PartyLuckyCtrl:BindEvents()
	self:BindEvent(MgrMgr:GetMgr("ThemePartyMgr").EventDispatcher,MgrMgr:GetMgr("ThemePartyMgr").ON_FINISH_NUMBER_SCROLLANIM,function()
		self:DestoryTweenEffect()
		self:CreatePointFinishEffect()
		self:CreatePlayerGetPrizeEffect()
		if self.numberScrollAnim then self.numberScrollAnim:StopAll() end
		if self.handleAnim then self.handleAnim:StopAll() end
	end)
end --func end
--next--
--lua functions end

--lua custom scripts

function PartyLuckyCtrl:ShowPanelByData(rankTitle,finalNumber,memberData)
	if not self:ShowLuckyLotteryByData(memberData,finalNumber) then return end
	self:SetItemSlotByNumber(finalNumber,memberData)
	MAudioMgr:Play("event:/UI/Party_Casino")
end

function PartyLuckyCtrl:ShowLuckyLotteryByData(data,finalNumber)
	if #data == 0 or data == nil then 
		--logError("没人获奖 关闭界面") 
		UIMgr:DeActiveUI(UI.CtrlNames.PartyLucky) 
		return false 
	end
	if finalNumber == nil then logError("没有幸运码") return false end
	for i=1,#data do
		if data[i] then
			self.lotteryLuckyItem[i] = self:NewTemplate("LotteryLuckyItem",{TemplateParent=self.panel.ObjectGroup.transform})
			self.lotteryLuckyItem[i]:AddLoadCallback(function (tmp)
				self.lotteryLuckyItem[i]:SetItemByData(data[i])
			end)
		end
	end
	--保存第几个玩家获奖了
	getPrizeMaxNum = tostring((#data-1)<0 and 0 or #data-1)
	for	i=1,#data do
		if tonumber(data[i].lucky_no) == tonumber(finalNumber) then 
			getPrizeNum = i
			getPrizeName = data[i].member.name
		end --找到停停留在哪里
	end
	return true
end

function PartyLuckyCtrl:InitNumberItemSlot( ... )
	self:UnLoadScrollPlent()
	self.numberScrollItems = {}
	for i=1,l_themePartyMgr.l_maxSize do
		self.numberScrollItems[i] = self:NewTemplate("NumberScrollItem",{TemplateParent=self.panel.PatyLotteryParent.transform})
	end
	self.numberScrollAnim  = self.panel.PatyLotteryParent.transform:GetComponent("FxAnimationHelper")
	self.handleAnim = self.panel.Handle.transform:GetComponent("FxAnimationHelper")
end

local OneItemSize = 86
local OneCircleSize = 10
local l_animationTime = MgrMgr:GetMgr("ThemePartyMgr").l_animationTotalTime
local l_basicCicleNum = 30

function PartyLuckyCtrl:SetItemSlotByNumber(num,memberData)
	local index = 1
	for	i=1,#memberData do
		if tonumber(memberData[i].lucky_no) == tonumber(num) then index = i end --找到停停留在哪里
	end
	local numberData = self:GetShowNumberData( memberData )
	for i=1,maxNumItemSize do
		self.numberScrollItems[i]:AddLoadCallback(function (tmp)
			local totalTime = l_animationTime
			tmp:InitNyNumGroup(numberData[i])
			tmp:SetIsShowSprite(false)
			local finishFunc = function ( ... )
				MgrMgr:GetMgr("ThemePartyMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("ThemePartyMgr").ON_FINISH_NUMBER_SCROLLANIM)
			end
			tmp:SetTween(totalTime,-OneItemSize*(l_basicCicleNum+self:GetRunIndex(index)),finishFunc)
			tmp:DoPlay()
		end)
	end
	self:CreateTweenEffect()
	if self.handleAnim then self.handleAnim:PlayAll() end
	if self.numberScrollAnim then self.numberScrollAnim:PlayAll() end

	--动画播完等0.2秒 关闭界面
	local l_time = self:NewUITimer(function()
		UIMgr:DeActiveUI(UI.CtrlNames.PartyLucky)
    end, l_animationTime+1)
    l_time:Start()
end

function PartyLuckyCtrl:GetRunIndex( cIndex )
	if cIndex == 1 then return 2 end
	if cIndex == 2 then return 1 end
	if cIndex == 3 then return 5 end
	if cIndex == 4 then return 4 end
	if cIndex == 5 then return 3 end
end

function PartyLuckyCtrl:GetShowNumberData( memberData )
	local finNumberTb = {}
	local tempNumber = {}
	if #memberData == 5 then
		for i=1,#memberData do
			table.insert( finNumberTb,memberData[i].lucky_no)
		end
	end
	if #memberData == 1 then
		finNumberTb = {memberData[1].lucky_no,memberData[1].lucky_no,memberData[1].lucky_no,memberData[1].lucky_no,memberData[1].lucky_no}
	end
	if #memberData == 2 then
		finNumberTb = {memberData[1].lucky_no,memberData[2].lucky_no,memberData[1].lucky_no,memberData[2].lucky_no,memberData[1].lucky_no}
	end
	if #memberData == 3 then
		finNumberTb = {memberData[1].lucky_no,memberData[2].lucky_no,memberData[3].lucky_no,memberData[1].lucky_no,memberData[2].lucky_no}
	end
	if #memberData == 4 then
		finNumberTb = {memberData[1].lucky_no,memberData[2].lucky_no,memberData[3].lucky_no,memberData[4].lucky_no,memberData[1].lucky_no}
	end

	for i=1,maxNumItemSize do
		local newNumStr = ""
		for z=1,#finNumberTb do
			local cNum = tonumber(string.sub(tostring(finNumberTb[z]),i,i))
			newNumStr = newNumStr..cNum
		end
		table.insert( tempNumber,newNumStr)
	end
	return tempNumber
end

function PartyLuckyCtrl:UnLoadLuckTemPlent()
	--这个是下面的头像
	if self.lotteryLuckyItem then
		for i = 1, #self.lotteryLuckyItem do
			if self.lotteryLuckyItem[i] then
				self:UninitTemplate(self.lotteryLuckyItem[i])
				self.lotteryLuckyItem[i] = nil
			end
		end
		self.lotteryLuckyItem = {}
	end
end

function PartyLuckyCtrl:UnLoadScrollPlent()
	--上面的滚动
	if self.numberScrollItems then
		for i = 1, #self.numberScrollItems do
			if self.numberScrollItems[i] then
				self.numberScrollItems[i]:DoKill()
				self:UninitTemplate(self.numberScrollItems[i])
				self.numberScrollItems[i] = nil
			end
		end
		self.numberScrollItems = nil
	end
end

function PartyLuckyCtrl:CreateTweenEffect( ... )
	self:DestoryTweenEffect()
	self.rewardEffectTb = self.rewardEffectId or {}
	for i=1,#self.panel.Eff_RawImage do
		local l_fxData = {}
        l_fxData.rawImage = self.panel.Eff_RawImage[i].RawImg
        l_fxData.destroyHandler = function ()
            self.rewardEffectTb[i] = 0
		end
		l_fxData.loadedCallback = function(go)
			go.transform:SetLocalScale(2.5,2.5,2.5)
		end
		self.rewardEffectTb[i] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ZhuTiPaiDui_ZhiZhenHuoXing_01",l_fxData)
        
	end
end

--创建指针Finish特效
function PartyLuckyCtrl:CreatePointFinishEffect( ... )
	self:DestoryPointFinishEffect()
	self.rewardEffectFinish = self.rewardEffectFinish or nil

	local l_fxData = {}
	l_fxData.rawImage = self.panel.RawImg_Finish.RawImg
	l_fxData.destroyHandler = function ()
		self.rewardEffectFinish = 0
	end           
	l_fxData.loadedCallback = function(go)
		go.transform:SetLocalScale(8,8,8)
	end
	self.rewardEffectFinish = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ZhuTiPaiDui_DingGeTeXiao_01",l_fxData)
	
end

function PartyLuckyCtrl:DestoryTweenEffect( ... )
	if self.rewardEffectTb == nil then return end
	for i=1,#self.rewardEffectTb do
		if self.rewardEffectTb[i] ~= 0 then
			self:DestroyUIEffect(self.rewardEffectTb[i])
			self.rewardEffectTb[i] = 0
		end
	end
end

function PartyLuckyCtrl:DestoryPointFinishEffect( ... )
	if self.rewardEffectFinish == nil then return end
	if self.rewardEffectFinish ~= 0 then
		self:DestroyUIEffect(self.rewardEffectFinish)
		self.rewardEffectFinish = 0
	end
end

function PartyLuckyCtrl:CreatePlayerGetPrizeEffect( ... )
	if getPrizeNum ~= 0 and getPrizeNum then
		if self.lotteryLuckyItem[getPrizeNum] then
			self.lotteryLuckyItem[getPrizeNum]:CreateFinishEffect()
			self.lotteryLuckyItem[getPrizeNum]:ShowWinTitle(true)
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ON_GET_LUCKY_PRIZE",getPrizeName,getPrizeMaxNum))
			getPrizeNum = 0
		end
	end
end

--lua custom scripts end
return PartyLuckyCtrl