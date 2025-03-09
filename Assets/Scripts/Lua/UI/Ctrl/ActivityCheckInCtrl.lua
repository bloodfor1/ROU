--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ActivityCheckInPanel"
require "Data/Model/BagModel"
require "UI/Template/ActivityCheckInSelectedItem"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_mgr = MgrMgr:GetMgr("ActivityCheckInMgr")
--lua fields end

--lua class define
---@class ActivityCheckInCtrl : UIBaseCtrl
---@field m_award_list ActivityCheckInAwardItemTemplate[]
---@field m_dice_list ActivityCheckInDiceItemTemplate[]
---@field m_current_award ItemTemplate
---@field m_count_down_start boolean
---@field m_slider_dots number[]
---@field m_cat_model MoonClient.MModel
ActivityCheckInCtrl = class("ActivityCheckInCtrl", super)
--lua class define end

--lua functions
function ActivityCheckInCtrl:ctor()
	
	super.ctor(self, CtrlNames.ActivityCheckIn, UILayer.Function, nil, ActiveType.Exclusive)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
end --func end
--next--
function ActivityCheckInCtrl:Init()
	
	self.panel = UI.ActivityCheckInPanel.Bind(self)
	super.Init(self)
	l_mgr = MgrMgr:GetMgr("ActivityCheckInMgr") -- 方便编辑器debug
	-- 奖励列表
	self.m_award_list = {}
	for i = 0,6 do
		---@type MoonClient.MLuaUICom
		local p = self.panel["Reward"..i]
		self.m_award_list[i+1] = self:NewTemplate("ActivityCheckInAwardItemTemplate",{
			TemplatePrefab = self.panel.ActivityCheckInAwardItemTemplate.gameObject,
			TemplateParent = p.transform,
		})
	end
	self.panel.ActivityCheckInAwardItemTemplate.gameObject:SetActiveEx(false)
	-- 色子列表
	self.m_dice_list = {}
	for i = 1,6 do
		---@type MoonClient.MLuaUICom
		local p = self.panel["Dice"..i]
		self.m_dice_list[i] = self:NewTemplate("ActivityCheckInDiceItemTemplate",{
			TemplatePrefab = self.panel.ActivityCheckInDiceItemTemplate.gameObject,
			TemplateParent = p.transform,
		})
	end
	self.panel.ActivityCheckInDiceItemTemplate.gameObject:SetActiveEx(false)
	--- 色子定制结果类别
	self.m_dice_result_pool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ActivityCheckInSelectedItem,
		TemplatePrefab = self.panel.ActivityCheckInSelectedItem.gameObject,
		TemplateParent = self.panel.SelectedList.transform,
	})
	--- 时间滑动条的关键点
	do
		local x_max = 362.47
		local x_min = -160
		local x_range = x_max - x_min
		self.m_slider_dots = {0}
		for i = 1, 6 do
			---@type MoonClient.MLuaUICom
			local p = self.panel["Dice"..i]
			local x = p.transform.localPosition.x
			table.insert(self.m_slider_dots, (x - x_min)/x_range)
		end
		table.insert(self.m_slider_dots,1)
	end
	-- 其他
	self.m_current_award = self:NewTemplate("ItemTemplate", {TemplateParent = self.panel.RewardRoot.transform})
	self.m_count_down_start = false
	local price
	if MgrMgr:GetMgr("PropMgr").IsCoin(l_mgr.Datas.m_SignInReDicePrice[0]) then
		price =  MNumberFormat.GetNumberFormat(l_mgr.Datas.m_SignInReDicePrice[1])
	else
		price = tostring(l_mgr.Datas.m_SignInReDicePrice[1])
	end
	self.panel.CostNum.LabText = price .. "  " .. Lang("ActivityCheckIn_ReRandomDice_Word")
	self.panel.CostImage:SetSprite(l_mgr.Datas.m_cost_item.ItemAtlas, l_mgr.Datas.m_cost_item.ItemIcon)

	self:ResetUI()
end --func end
--next--
function ActivityCheckInCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.m_award_list = nil
	self.m_dice_list = nil
	self.m_current_award = nil

end --func end
--next--
function ActivityCheckInCtrl:OnActive()
	
	-- 打开是先重置下UI，发协议强求，等数据
	self:ResetUI()
	self.m_cat_model = nil
	self.panel.Eff_ShuiHUa.gameObject:SetActiveEx(false)

	self.panel.CatAnim:PlayDynamicEffect(0, {
		modelLoadCallback = function(model)
			self.m_cat_model = model
			local idle = "Anims/NPC/NPC_M_MiZiShangRen03/NPC_M_MiZiShangRen03_Idle"
			local talk = "Anims/NPC/NPC_M_MiZiShangRen03/NPC_M_MiZiShangRen03_Talk"
			self.m_cat_model.Ator:OverrideAnim("Idle", idle)
			self.m_cat_model.Ator:OverrideAnim("Special", talk)
		end
	})
	l_mgr.SendGetSpecialSupplyInfo()
	
end --func end
--next--
function ActivityCheckInCtrl:OnDeActive()
	self.panel.AllRoot:SetActiveEx(false)
	if self.timer1 then
		self:StopUITimer(self.timer1)
		self.timer1 = nil
	end

	l_mgr.SendGetSpecialSupplyInfo() -- 及时刷新下数据
end --func end
--next--
function ActivityCheckInCtrl:Update()
	
	-- 倒计时
	self:CountDown()
	-- ForTest
	--l_mgr.Datas.m_online_time = l_mgr.Datas.m_online_time + 10
	--self:RefreshDiceList()
	
end --func end
--next--
function ActivityCheckInCtrl:BindEvents()
	
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.GetAllInfo, self.OnGetAllInfo)
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.ActivityEnded, self.OnActivityEnded)
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.ChooseAward, self.OnChooseAward)
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.SetDice, self.OnSetDice)
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.RandomDice, self.OnRandomDice)
	self.panel.Btn_close:AddClick(function() UIMgr:DeActiveUI(CtrlNames.ActivityCheckIn)  end)
	self.panel.Btn_Change:AddClick(handler(self, self.OnClickOpenReRoll))
	self.panel.Btn_Receive:AddClick(handler(self, self.OnClickGetAward))
	self.panel.Btn_Wenhao:AddClick(handler(self, self.OnClickHelp))
	self.panel.Btn_OK:AddClick(handler(self, self.OnClickRollOk))
	self.panel.Btn_Rethrow:AddClick(handler(self, self.OnClickReRollDice))
	self.panel.RollDiceBtn:AddClick(handler(self, self.OnClickRandomDice))
	self.panel.DiceBtn:AddClick(handler(self, self.OnClickDiceBtn))
	self.panel.CatAnim:AddClick(handler(self, self.CatPlayAnim))
	self.panel.MultiplePoint:AddClick(handler(self, self.OnClickMultiplePoint))
end --func end
--next--
--lua functions end

--lua custom scripts
local function _GetLangWithDefaultCheck(key, ...)
	if l_mgr.Datas.m_default_dice then
		return Lang(key .. "_default",...)
	else
		return Lang(key,...)
	end
end

function ActivityCheckInCtrl:OnClickDiceBtn()
	if self.panel.DiceBtn.Img.color.a > 0.9 then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_DontGet_Award"))
	else
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_CatTalk_2"))
		-- self:CatPlayAnim() -- 测试代码，后边注释掉
	end
end

function ActivityCheckInCtrl:OnClickMultiplePoint()
	if not l_mgr.Datas.m_can_recv_awards then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_NextDay_Confirm"))
	elseif l_mgr.Datas.m_awards_multiple > 0 then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_ToDay_Confirm", l_mgr.Datas.m_awards_multiple))
	end
end

function ActivityCheckInCtrl:OnActivityEnded()
	CommonUI.Dialog.ShowOKDlg(true, Lang("TIP"), Lang("ActivityCheckIn_End"), function()
		UIMgr:DeActiveUI(CtrlNames.ActivityCheckIn)
	end)
end

function ActivityCheckInCtrl:OnGetAllInfo()
	if not l_mgr.IsSystemOpenExtraCheck() then
		CommonUI.Dialog.ShowOKDlg(true, Lang("TIP"), Lang("ActivityCheckIn_End"), function()
			UIMgr:DeActiveUI(CtrlNames.ActivityCheckIn)
		end)
		return
	end
	self:ResetUI()
	self.panel.SpineShip:SetActiveEx(true)
	if not self.m_ship_has_come and l_mgr.Datas.m_choose_item_idx < 0 then
		self:CatPlayAnim()

		self.panel.SpineShip.SpineAnim.Loop = false
		self.panel.SpineShip.SpineAnim.AnimationName = "Come"
		if self.timer1 then
			self:StopUITimer(self.timer1)
			self.timer1 = nil
		end
		self.timer1 = self:NewUITimer(function()
			self.m_not_play_fade = true
			self.panel.FxControl:PlayDynamicEffect()
			self:RefreshUIAfterGetAllInfo()
			-- 临时关闭水花特效
			-- self.panel.Eff_ShuiHUa.gameObject:SetActiveEx(true)
		end,l_mgr.Datas.m_SignInShipGoneCD)
		self.timer1:Start()
		-- self.panel.FxShuiHua:PlayDynamicEffect() -- 美术设置了两秒延时
	else
		self.panel.SpineShip.SpineAnim.Loop = true
		self.panel.SpineShip.SpineAnim.AnimationName = "Idle"
		--- 领奖后重置下这个
		if not self.m_not_play_fade then
			self.m_not_play_fade = true
			self.panel.FxControl:PlayDynamicEffect()
		end
		self:RefreshUIAfterGetAllInfo()
	end

	self.m_ship_has_come = true
end

function ActivityCheckInCtrl:RefreshUIAfterGetAllInfo()
	-- 信息更新了，刷新下UI
	self.panel.AllRoot:SetActiveEx(true)
	self.panel.BottomUI:SetActiveEx(l_mgr.Datas.m_choose_item_idx >= 0 and not l_mgr.Datas.m_can_recv_awards)

	self:RefreshCatTalk()
	self:RefreshAwardUI()
	self:RefreshAwardList()
	self:RefreshDiceList()

end

function ActivityCheckInCtrl:OnChooseAward()
	self:CatPlayAnim()
	self:RefreshCatTalk()
	self:RefreshAwardList()
	self:RefreshAwardUI()
	self.panel.BottomUI:SetActiveEx(true)
end

function ActivityCheckInCtrl:OnSetDice()
	if l_mgr.Datas.m_next_dice_idx >= 6 then
		-- finish set dice
		self:CatPlayAnim()
		self.panel.FxSetDiceFinish:PlayDynamicEffect()
	end

	self:RefreshDiceList()
end

function ActivityCheckInCtrl:CatPlayAnim()
	if self.m_is_play_cat or self.m_cat_model == nil then
		return
	end
	--self.m_cat_model.Ator:CrossFade("Special", 1)
	 self.m_cat_model.Ator:Play("Special")
	--self.panel.CatAnim:PlayDynamicEffect(0,{defaultAnim = talk,})
	if self.timer2 then
		self:StopUITimer(self.timer2)
		self.timer2 = nil
	end
	self.timer2 = self:NewUITimer(function()
		self.timer2 = nil
		self.m_is_play_cat = false
		self.m_cat_model.Ator:Play("Idle")
		--self.m_cat_model.Ator:CrossFade("Idle", 1)
		--self.panel.CatAnim:PlayDynamicEffect(0, {defaultAnim = idle,})
	end,5.267)
	self.timer2:Start()
end

function ActivityCheckInCtrl:OnRandomDice(code, not_play_cat)
	self:RefreshCatTalk()
	self:RefreshAwardUI()

	self.panel.ResultRoot:SetActiveEx(true)
	self:RefreshSelectedDiceList(true)
	self.panel.ResultBackFX:PlayDynamicEffect()
	if code == 0 then
		self:RefreshResultUI(false)
		self.panel.ResultDiceFx:PlayDynamicEffect(-1, {
			loadedCallback = function(go,fxId)
				self:SetResultDiceFace(go)
			end
		})
		if not not_play_cat then
			self:CatPlayAnim()
		end
	else
		self:RefreshResultUI(true)
	end
end

---@param go UnityEngine.GameObject
function ActivityCheckInCtrl:SetResultDiceFace(go)
	---@type MoonClient.MDiceBehaviour
	local com = go.Find("Main/Item_Scene_Shaizi"):GetComponent("MDiceBehaviour")

	local result = l_mgr.Datas.m_awards_multiple
	result = math.max(1,result)
	for i = 0, 5 do
		local num = l_mgr.Datas.m_dice_list[i+1]
		num = math.max(1,num)
		com:SetDirSprite(MoonClient.DiceDirection.IntToEnum(i), l_mgr.ImgNames.DiceResult[num],l_mgr.ImgNames.Atlas)
	end

	com:SetDirSprite(MoonClient.DiceDirection.IntToEnum(4), l_mgr.ImgNames.DiceResult[result],l_mgr.ImgNames.Atlas)
end

---@param show_btn boolean
function ActivityCheckInCtrl:RefreshResultUI(show_btn)
	self.panel.ReusltBtnGroup:SetActiveEx(show_btn)

	self.panel.Btn_Rethrow:SetGray(true)
	if l_mgr.Datas.m_max_multiple <= l_mgr.Datas.m_awards_multiple then
		self.panel.ResultTips.LabText = Lang("ActivityCheckIn_RandomDice_GetMax")
	elseif l_mgr.Datas.m_use_dice_count < l_mgr.Datas.m_SignInReDiceTime + 1 then
		self.panel.ResultTips.LabText = Lang("ActivityCheckIn_RandomDice_ReDice",
				l_mgr.Datas.m_cost_item_imgae_txt,
				l_mgr.Datas.m_SignInReDiceTime + 1 - l_mgr.Datas.m_use_dice_count)
		self.panel.Btn_Rethrow:SetGray(false)
	else
		self.panel.ResultTips.LabText = _GetLangWithDefaultCheck("ActivityCheckIn_CatTalk_6",l_mgr.Datas.m_awards_multiple)
	end
end

function ActivityCheckInCtrl:CountDown()
	if not self.m_count_down_start then return end
	if l_mgr.Datas.m_choose_item_idx >= 0 and  not l_mgr.Datas.m_can_recv_awards then
		local left = l_mgr.Datas.m_tomorrow_timestamp - l_mgr.GetTimestamp()
		if left < 0 then
			self.m_count_down_start = false
			l_mgr.SendGetSpecialSupplyInfo() -- 刷新下信息，理论上凌晨五点玩家应该很少，影响不大
		else
			self.panel.TimeNum.LabText = ExtensionByQX.TimeHelper.SecondConvertTime(left, "hh:mm:ss")
		end
	end
end

function ActivityCheckInCtrl:RefreshCatTalk()
	if l_mgr.Datas.m_choose_item_idx < 0 then
		self.panel.CatTalk.LabText = Lang("ActivityCheckIn_CatTalk_1")
	elseif l_mgr.Datas.m_can_recv_awards then
		if l_mgr.Datas.m_awards_multiple > 0 then
			if l_mgr.Datas.m_use_dice_count == 0 then
				self.panel.CatTalk.LabText = Lang("ActivityCheckIn_CatTalk_3_not") -- default
			else
				if l_mgr.Datas.m_max_multiple == l_mgr.Datas.m_awards_multiple then
					self.panel.CatTalk.LabText = _GetLangWithDefaultCheck("ActivityCheckIn_CatTalk_5")
				elseif l_mgr.Datas.m_use_dice_count >= l_mgr.Datas.m_SignInReDiceTime + 1 then
					self.panel.CatTalk.LabText = _GetLangWithDefaultCheck("ActivityCheckIn_CatTalk_6", l_mgr.Datas.m_awards_multiple)
				else
					local left = l_mgr.Datas.m_SignInReDiceTime + 1 - l_mgr.Datas.m_use_dice_count
					self.panel.CatTalk.LabText = Lang("ActivityCheckIn_CatTalk_4", l_mgr.Datas.m_awards_multiple, left)
				end
			end
		else
			self.panel.CatTalk.LabText = _GetLangWithDefaultCheck("ActivityCheckIn_CatTalk_3") -- 还没开始投色子
		end
	else
		self.panel.CatTalk.LabText = Lang("ActivityCheckIn_CatTalk_2")
	end
end

function ActivityCheckInCtrl:RefreshAwardList()
	for i = 1, 7 do
		local info = l_mgr.Datas.m_item_list[i]
		self.m_award_list[i]:SetData({
			m_idx = i - 1,
			m_item_id = info.item_id,
			m_cd_end_time = info.item_cd_end_time,
			m_count = info.item_count,
			m_choosed_idx = l_mgr.Datas.m_choose_item_idx
		})
	end
end

function ActivityCheckInCtrl:RefreshDiceList()
	-- 设置下色子透明度
	if l_mgr.Datas.m_next_dice_idx >= 6 then
		self.panel.DiceBtn.Img.color = Color(1,1,1,1)
	else
		self.panel.DiceBtn.Img.color = Color(1,1,1,20/100)
	end

	local slider_idx = 0
	for i = 1, 6 do
		local m_active = l_mgr.Datas.m_online_time >= l_mgr.Datas.m_dice_time_list[i]*60
		self.m_dice_list[i]:SetData({
			m_idx = i - 1,
			m_minutes = l_mgr.Datas.m_dice_time_list[i],
			m_num = l_mgr.Datas.m_dice_list[i],
			m_active = m_active,
		})
		if m_active then
			slider_idx = i
		end
	end

	if slider_idx == 6 then
		self.panel.Slider.Slider.value = 1
		return
	end

	local min = l_mgr.Datas.m_dice_time_list[slider_idx] or 0
	local max = l_mgr.Datas.m_dice_time_list[slider_idx+1] or l_mgr.Datas.m_dice_time_list[6]*1.1
	local progress = (l_mgr.Datas.m_online_time/60 - min)/(max - min)
	slider_idx = slider_idx + 1
	progress = self.m_slider_dots[slider_idx] + progress * (self.m_slider_dots[slider_idx+1] - self.m_slider_dots[slider_idx])
	self.panel.Slider.Slider.value = progress
end

function ActivityCheckInCtrl:RefreshSelectedDiceList(show)
	if not show then
		self.panel.SelectedNumRoot:SetActiveEx(false)
		return
	end
	self.panel.SelectedNumRoot:SetActiveEx(true)
	local ls = {}
	for i = 1,6 do
		ls[i] = {
			m_num = l_mgr.Datas.m_dice_list[i] or 0
		}
	end
	self.m_dice_result_pool:ShowTemplates({Datas = ls})
end

function ActivityCheckInCtrl:RefreshAwardUI()
	self.m_current_award:SetGameObjectActive(false)
	self.panel.Btn_Receive:SetActiveEx(false)
	self.panel.DiceBtn:SetActiveEx(false)
	self.panel.Btn_Change:SetActiveEx(false)
	self.panel.AwardRedPoint:SetActiveEx(false)
	self.m_count_down_start = false

	if l_mgr.Datas.m_choose_item_idx < 0 then
		-- 还没选择奖励
		self.panel.MultiplePoint:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.DiceGreyMark)
		self.panel.TimeNum.LabText = "00:00:00"
		self.panel.AwardRedPoint:SetActiveEx(true)
		self.panel.TimeTips.LabText = Lang("ActivityCheckIn_TimeTip_Choose")
		self.panel.HasChooseRoot:SetActiveEx(false)
		self.panel.NotChooseRoot:SetActiveEx(true)
	else
		self.panel.HasChooseRoot:SetActiveEx(true)
		self.panel.NotChooseRoot:SetActiveEx(false)
		local info = l_mgr.Datas.m_item_list[l_mgr.Datas.m_choose_item_idx + 1]
		self.m_current_award:SetGameObjectActive(true)
		self.m_current_award:SetData({
			ID = info.item_id,
			Count = info.item_count,
			IsShowCount = true,
		})

		if l_mgr.Datas.m_can_recv_awards then
			-- 可以领奖了
			self.panel.TimeTips.LabText = Lang("ActivityCheckIn_TimeTip_GetAward")
			self.panel.TimeNum.LabText = "00:00:00"
			if l_mgr.Datas.m_awards_multiple > 0 then
				-- 已经摇过色子了
				self.panel.MultiplePoint:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.Dice[l_mgr.Datas.m_awards_multiple])
				self.panel.Btn_Receive:SetActiveEx(true)
				self.panel.Btn_Change:SetActiveEx(l_mgr.Datas.m_can_redice)
			else
				-- 引导去摇勺子
				self.panel.MultiplePoint:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.DiceGreyMark)
				self.panel.Btn_Change:SetActiveEx(true)
				self:ForceToRollDice()
			end
		else
			-- 等待开奖倒计时
			self.panel.TimeTips.LabText = Lang("ActivityCheckIn_TimeTip_RollDice")
			self.panel.MultiplePoint:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.DiceGreyMark)

			self.panel.DiceBtn:SetActiveEx(true)

			self.m_count_down_start = true
			self:CountDown()
		end
	end
end

function ActivityCheckInCtrl:ResetUI()
	self.panel.SpineShip:SetActiveEx(false)
	self.panel.AllRoot:SetActiveEx(false)
	self.panel.BottomUI:SetActiveEx(false)
	self.panel.RollDiceRoot:SetActiveEx(false)
	self.panel.ResultRoot:SetActiveEx(false)
	self:RefreshSelectedDiceList(false)
end

function ActivityCheckInCtrl:ForceToRollDice()
	self.panel.RollDiceRoot:SetActiveEx(true)
	self.panel.RollDiceFX:PlayDynamicEffect()
	self:RefreshSelectedDiceList(true)
end

function ActivityCheckInCtrl:OnClickReRollDice()
	if l_mgr.Datas.m_max_multiple <= l_mgr.Datas.m_awards_multiple
			or l_mgr.Datas.m_use_dice_count >= l_mgr.Datas.m_SignInReDiceTime + 1 then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(self.panel.ResultTips.LabText)
		return
	end
	local has = tonumber(Data.BagModel:GetCoinOrPropNumById(l_mgr.Datas.m_SignInReDicePrice[0]))
	if has >= l_mgr.Datas.m_SignInReDicePrice[1] then
		local tip = Lang("ActivityCheckIn_ReRollDice_Warn", l_mgr.Datas.m_cost_item_imgae_txt)
		CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm,true,Lang("TIP"), tip,
				Lang("DLG_BTN_YES"),Lang("DLG_BTN_NO"),function()
					self:OnClickRandomDice()
				end)

		--CommonUI.Dialog.ShowYesNoDlg(true, Lang("TIP"), tip, function()
		--	self:OnClickRandomDice()
		--end)
	else
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_ReRollDice_Not_Enough", l_mgr.Datas.m_cost_item.ItemName))
	end
end

function ActivityCheckInCtrl:OnClickRandomDice()
	self.panel.RollDiceRoot:SetActiveEx(false) -- 放在前面，预防真出现异常，导致页面没法关闭
	self:RefreshSelectedDiceList(false)
	if l_mgr.Datas.m_max_multiple <= l_mgr.Datas.m_awards_multiple
			or l_mgr.Datas.m_use_dice_count >= l_mgr.Datas.m_SignInReDiceTime + 1 then
		return
	end

	self.panel.ResultRoot:SetActiveEx(true)
	self:RefreshSelectedDiceList(true)
	self:RefreshResultUI(false)
	l_mgr.SencRandomDiceValue()
end

function ActivityCheckInCtrl:OnClickOpenReRoll()
	if l_mgr.Datas.m_use_dice_count >= l_mgr.Datas.m_SignInReDiceTime + 1 then
		return
	end
	self:OnRandomDice(0, true)
	self.panel.ReusltBtnGroup:SetActiveEx(true)
	--self.panel.ResultRoot:SetActiveEx(true)
	--self:RefreshResultUI(true)
end

function ActivityCheckInCtrl:OnClickRollOk()
	self.panel.ResultRoot:SetActiveEx(false)
	self:RefreshSelectedDiceList(false)
end

function ActivityCheckInCtrl:OnClickGetAward()
	self.m_not_play_fade = false -- 领奖后，下次界面刷新，渐变下
	l_mgr.SendRecvSpecialSupplyAwards()
end

function ActivityCheckInCtrl:OnClickHelp()
	MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
		content = Lang("ActivityCheckIn_Help"),
		alignment = UnityEngine.TextAnchor.MiddleCenter,
		pivot = Vector2.New(0.5,0.5),
		anchoreMin=Vector2.New(0.5,0.5),
		anchoreMax=Vector2.New(0.5,0.5),
		pos = {
			x = 155,
			y = 104,
		},
		width = 400,
	})
end
--lua custom scripts end
return ActivityCheckInCtrl