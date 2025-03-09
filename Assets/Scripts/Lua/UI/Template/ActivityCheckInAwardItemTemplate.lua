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
local l_mgr = MgrMgr:GetMgr("ActivityCheckInMgr")
--lua fields end

--lua class define
---@class ActivityCheckInAwardItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field AwardToggleSelcet MoonClient.MLuaUICom
---@field AwardToggleBG MoonClient.MLuaUICom
---@field AwardToggle MoonClient.MLuaUICom
---@field AwardName MoonClient.MLuaUICom
---@field AwardIcon MoonClient.MLuaUICom
---@field AwardCountDownText MoonClient.MLuaUICom
---@field AwardCountDown MoonClient.MLuaUICom

---@class ActivityCheckInAwardItemTemplate : BaseUITemplate
---@field Parameter ActivityCheckInAwardItemTemplateParameter
---@field m_item_id number
---@field m_cd_end_time number
---@field m_count number
---@field m_idx number -- 索引从0开始
---@field m_choosed_idx number -- 选择的索引
---@field m_item_ui ItemTemplate
ActivityCheckInAwardItemTemplate = class("ActivityCheckInAwardItemTemplate", super)
--lua class define end

--lua functions
function ActivityCheckInAwardItemTemplate:Init()
	
	super.Init(self)

	l_mgr = MgrMgr:GetMgr("ActivityCheckInMgr")

	self.m_item_id = 0
	self.m_cd_end_time = 0
	self.m_count = 1
	self.m_idx = 0
	self.m_choosed_idx = -1

end --func end
--next--
function ActivityCheckInAwardItemTemplate:BindEvents()
	--self.Parameter.AwardToggle.Tog.onValueChanged:AddListener(function(isOn)
	--	-- self:OnToggleValueChange(isOn)
	--end)
	self.Parameter.AwardToggleBG:AddClick(handler(self, self.OnClickChoose))
end --func end
--next--
function ActivityCheckInAwardItemTemplate:OnDestroy()
	
	if self.m_item_ui then
		self.m_item_ui = nil
	end
	self:ClearTimer()
	
end --func end
--next--
function ActivityCheckInAwardItemTemplate:OnDeActive()
	
	
end --func end
--next--
function ActivityCheckInAwardItemTemplate:OnSetData(data)
	
	if data == nil then
		return
	end
	self.m_idx = data.m_idx
	self.m_item_id = data.m_item_id
	self.m_cd_end_time = data.m_cd_end_time
	-- fortest
	-- self.m_cd_end_time = l_mgr.GetTimestamp() + (self.m_idx - 3 ) * 86400 + 20
	self.m_choosed_idx = data.m_choosed_idx
	self.m_count = data.m_count
	self:RefreshUI()
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ActivityCheckInAwardItemTemplate:RefreshUI()
	local info = TableUtil.GetItemTable().GetRowByItemID(self.m_item_id)
	if info == nil then
		return
	end
	self.Parameter.AwardName.LabText = info.ItemName
	if self.m_item_ui == nil then
		self.m_item_ui = self:NewTemplate("ItemTemplate", {TemplateParent = self.Parameter.AwardIcon.transform})
	end

	self:TryStartCountDown()
	self:RefreshItemUI()
	self.Parameter.AwardToggle.Tog.isOn = self.m_choosed_idx == self.m_idx
end

function ActivityCheckInAwardItemTemplate:ClearTimer()
	if self.m_timer ~= nil then
		self:StopUITimer(self.m_timer)
		self.m_timer = nil
	end
end
-- 看看是否要倒计时
function ActivityCheckInAwardItemTemplate:TryStartCountDown()
	if self.m_idx ~= self.m_choosed_idx then
		if l_mgr.GetTimestamp() < self.m_cd_end_time then
			self:ClearTimer()
			self.Parameter.AwardCountDown:SetActiveEx(true)
			self.m_timer = self:NewUITimer(function() self:CountDownFunc() end, 0.5, -1)
			-- self.m_timer = self:NewUITimer(self.CountDownFunc, 0.2, true)
			self.m_timer:Start()
			return
		end
	end
	self.Parameter.AwardCountDown:SetActiveEx(false)
end
function ActivityCheckInAwardItemTemplate:CountDownFunc()
	local delta = self.m_cd_end_time - l_mgr.GetTimestamp()
	if delta > 0 then
		local format = Lang("ActivityCheckIn_CountDown_CD")
		-- + 59 避免显示出 00:00
		self.Parameter.AwardCountDownText.LabText = ExtensionByQX.TimeHelper.SecondConvertTime(delta + 59, format)
	else
		self.Parameter.AwardCountDown:SetActiveEx(false)
		self:ClearTimer()
		self:RefreshItemUI()
	end
end
function ActivityCheckInAwardItemTemplate:RefreshItemUI()
	if self.m_item_ui == nil then return end

	local gray = self.m_choosed_idx ~= self.m_idx and (self.m_choosed_idx >= 0 or l_mgr.GetTimestamp() < self.m_cd_end_time)
	self.m_item_ui:SetData({
		ID = self.m_item_id,
		Count = self.m_count,
		IsShowCount = true,
		IsGray = gray,
	})
	-- self.Parameter.AwardToggleBG.Btn.interactable = not gray and self.m_choosed_idx ~= self.m_idx
	self.Parameter.AwardToggleBG:SetGray(gray) -- 非常不明显
	self.Parameter.AwardToggleBG:SetActiveEx(not(self.m_choosed_idx >= 0 and self.m_choosed_idx ~= self.m_idx))
end
--function ActivityCheckInAwardItemTemplate:OnToggleValueChange()
--
--end

function ActivityCheckInAwardItemTemplate:OnClickChoose()
	log("OnClickChoose")
	if self.m_item_ui == nil then return end
	-- 可以领奖，先领奖
	if l_mgr.Datas.m_can_recv_awards then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_ChooseAward_Tip_2"))
		return
	end
	-- 已经选中
	if self.m_choosed_idx == self.m_idx then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_ChooseAward_Tip_1"))
		return
	end
	-- 已经选了其他奖品
	if self.m_choosed_idx >= 0 then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_ChooseAward_Tip_1"))
		return
	end
	-- 还在等cd
	if l_mgr.GetTimestamp() < self.m_cd_end_time then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_ChooseAward_Tip_3"))
		return
	end

	local isOn = not self.Parameter.AwardToggle.Tog.isOn
	if isOn then
		--local txt = Lang("ActivityCheckIn_ChooseAward_Tip",self.Parameter.AwardName.LabText, math.ceil(l_mgr.Datas.m_SignInSelectItemCD/3600))
		local txt = Lang("ActivityCheckIn_ChooseAward_Tip",self.Parameter.AwardName.LabText)
		CommonUI.Dialog.ShowYesNoDlg(true, Lang("TIP"), txt, function()
			l_mgr.SendChooseSpecilSupplyAwards(self.m_idx)
		end,nil)
	else
		-- do nothing
	end
end
--lua custom scripts end
return ActivityCheckInAwardItemTemplate