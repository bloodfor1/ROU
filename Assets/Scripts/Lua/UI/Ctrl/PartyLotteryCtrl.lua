--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PartyLotteryPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PartyLotteryCtrl = class("PartyLotteryCtrl", super)
--lua class define end

--lua functions
function PartyLotteryCtrl:ctor()
	
	super.ctor(self, CtrlNames.PartyLottery, UILayer.Function, nil, ActiveType.None)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.PartyLottery
	self.MaskDelayClickTime=3

end --func end
--next--
function PartyLotteryCtrl:Init()
	
	self.panel = UI.PartyLotteryPanel.Bind(self)
	super.Init(self)
	self.handleAnim = self.panel.Handle.transform:GetComponent("FxAnimationHelper")
end --func end
--next--
function PartyLotteryCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function PartyLotteryCtrl:OnActive()
	--self:SetBlockOpt(BlockColor.Dark,function ()
	--	UIMgr:DeActiveUI(UI.CtrlNames.PartyLottery)
	--end,3)
end --func end
--next--
function PartyLotteryCtrl:OnDeActive()
	self:DestoryPointEffect()
	self:DestoryPointFinishEffect()
	self:UnLoadTemPlent()
	MLuaCommonHelper.SetLocalScale(self.panel.OneLottery.gameObject,1,1,1)
end --func end
--next--
function PartyLotteryCtrl:Update()
	if self.lottery then
		for i = 1, #self.lottery do
			if self.lottery[i] then
				self.lottery[i]:Update()
			end
		end
	end
end --func end

--next--
function PartyLotteryCtrl:BindEvents()
	self:BindEvent(MgrMgr:GetMgr("ThemePartyMgr").EventDispatcher,MgrMgr:GetMgr("ThemePartyMgr").ON_FINISH_NUMBER_SCROLLANIM,function()
		if self.lottery then
			for i = 1, #self.lottery do
				if self.lottery[i] and self.lottery[i].fxAnim then
					self.lottery[i].fxAnim:StopAll()
				end
			end
		end
		if self.handleAnim then self.handleAnim:StopAll() end
		self:DestoryPointEffect()
		self:CreatePointFinishEffect()--创建
	end)
end --func end
--next--
--lua functions end

--lua custom scripts
function PartyLotteryCtrl:CreateLotteryTemplent(title,luckyNumber,rankNum)
	self:UnLoadTemPlent()
	self.lottery = {}
	if #luckyNumber == 0 or luckyNumber == nil then 
		--logError("没人获奖 关闭界面")
		UIMgr:DeActiveUI(UI.CtrlNames.PartyLottery)
		return
	end
	if #luckyNumber == 3 then
		MLuaCommonHelper.SetLocalScale(self.panel.OneLottery.gameObject,0.8,0.8,0.8)
	end
	self:SetBasicInfoByLuckyNumber(luckyNumber)
	for i=1,#luckyNumber do
		if luckyNumber[i].value then
			self.panel.ItemParent[i].gameObject:SetActiveEx(true)
			self.lottery[i] = self:NewTemplate("PartyLotteryItem",{TemplateParent=self.panel.ItemParent[i].transform})
			self.lottery[i].fxAnim  = self.panel.ItemParent[i].transform:GetComponent("FxAnimationHelper")
			if self.lottery[i].fxAnim then self.lottery[i].fxAnim:PlayAll() end
			self.lottery[i]:AddLoadCallback(function (tmp)
				tmp.uObj.transform:SetAsFirstSibling()
				tmp:ShowTemplentByNumAndTitle(title,luckyNumber[i].value)
				tmp:ShowTitleByState(i == 1)
			end)
		end
	end
	if self.handleAnim then self.handleAnim:PlayAll() end
	self:CreatePointEffect()
	--动画播完等0.2秒 关闭界面
	local l_time = self:NewUITimer(function()
		UIMgr:DeActiveUI(UI.CtrlNames.PartyLottery)
	end, MgrMgr:GetMgr("ThemePartyMgr").l_animationTotalTime+1)
	l_time:Start()
	MAudioMgr:Play("event:/UI/Party_Casino")
end

function PartyLotteryCtrl:SetBasicInfoByLuckyNumber( luckyNumber )
	if #luckyNumber == 0 or luckyNumber == nil then 
		UIMgr:DeActiveUI(UI.CtrlNames.PartyLottery)
	end
	self.panel.OneLottery:SetRawTex("Others/UI_Party_Lottery0"..#luckyNumber..".png",true)
end

--创建指针特效
function PartyLotteryCtrl:CreatePointEffect( ... )
	self:DestoryPointEffect()
	self.rewardEffectTb = self.rewardEffectTb or {}
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
function PartyLotteryCtrl:CreatePointFinishEffect( ... )
	self:DestoryPointFinishEffect()
	self.rewardEffectFinishTb = self.rewardEffectFinishTb or {}
	if self.panel == nil then return end
	for i=1,#self.panel.RawImg_Finish do
		local l_fxData = {}
        l_fxData.rawImage = self.panel.RawImg_Finish[i].RawImg
        l_fxData.destroyHandler = function ()
            self.rewardEffectFinishTb[i] = 0
		end           
		l_fxData.loadedCallback = function(go)
			go.transform:SetLocalScale(8,8,8)
		end
        self.rewardEffectFinishTb[i] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ZhuTiPaiDui_DingGeTeXiao_01",l_fxData)
        
	end
end

function PartyLotteryCtrl:DestoryPointEffect( ... )
	if self.rewardEffectTb == nil then return end
	for i=1,#self.rewardEffectTb do
		if self.rewardEffectTb[i] ~= 0 then
			self:DestroyUIEffect(self.rewardEffectTb[i])
			self.rewardEffectTb[i] = 0
		end
	end
end

function PartyLotteryCtrl:DestoryPointFinishEffect( ... )
	if self.rewardEffectFinishTb == nil then return end
	for i=1,#self.rewardEffectFinishTb do
		if self.rewardEffectFinishTb[i] ~= 0 then
			self:DestroyUIEffect(self.rewardEffectFinishTb[i])
			self.rewardEffectFinishTb[i] = 0
		end
	end
end

function PartyLotteryCtrl:UnLoadTemPlent()
	if self.lottery then
		for i = 1, #self.lottery do
			if self.lottery[i] then
				self:UninitTemplate(self.lottery[i])
				self.lottery[i] = nil
			end
		end
		self.lottery = nil
	end
end
--lua custom scripts end
return PartyLotteryCtrl