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
---@class ActivityCheckInDiceItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnknowPoints MoonClient.MLuaUICom
---@field RedPoint MoonClient.MLuaUICom
---@field Points MoonClient.MLuaUICom
---@field Num MoonClient.MLuaUICom
---@field notActive MoonClient.MLuaUICom
---@field Fx MoonClient.MLuaUICom
---@field currency MoonClient.MLuaUICom
---@field Active MoonClient.MLuaUICom

---@class ActivityCheckInDiceItemTemplate : BaseUITemplate
---@field Parameter ActivityCheckInDiceItemTemplateParameter
---@field m_idx number 色子索引
---@field m_minutes number
---@field m_num number
---@field m_active boolean 时间到了
ActivityCheckInDiceItemTemplate = class("ActivityCheckInDiceItemTemplate", super)
--lua class define end

--lua functions
function ActivityCheckInDiceItemTemplate:Init()
	
	super.Init(self)

	l_mgr = MgrMgr:GetMgr("ActivityCheckInMgr")
	self.Parameter.UnknowPoints:SetActiveEx(false)
	self.Parameter.currency:SetSprite(l_mgr.Datas.m_cost_reset_dice_item.ItemAtlas, l_mgr.Datas.m_cost_reset_dice_item.ItemIcon)
end --func end
--next--
function ActivityCheckInDiceItemTemplate:BindEvents()
	
	self.Parameter.Points:AddClick(handler(self,self.OnClickSetDice))
	
end --func end
--next--
function ActivityCheckInDiceItemTemplate:OnDestroy()
	
	
end --func end
--next--
function ActivityCheckInDiceItemTemplate:OnDeActive()
	
	
end --func end
--next--
function ActivityCheckInDiceItemTemplate:OnSetData(data)
	
	self.m_minutes = data.m_minutes
	self.m_num = data.m_num
	self.m_active = data.m_active
	self.m_idx = data.m_idx
	self:RefreshUI()
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ActivityCheckInDiceItemTemplate:RefreshUI()
	self.Parameter.Num.LabText = tostring(self.m_minutes)
	self.Parameter.Active:SetActiveEx(self.m_active)
	self.Parameter.currency:SetActiveEx(false)
	self.Parameter.Fx:SetActiveEx(false)
	self.Parameter.RedPoint:SetActiveEx(false)
	-- 这个的显示逻辑，感觉不太合理，策划可能会改，先这么着
	if self.m_num > 0 then
		self.Parameter.Points:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.Dice[self.m_num])
	else
		if self.m_active then
			self.Parameter.Points:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.DiceActiveMark)
			if self.m_idx == l_mgr.Datas.m_next_dice_idx then
				self.Parameter.Fx:PlayDynamicEffect()
				self.Parameter.RedPoint:SetActiveEx(true)
			end
		else
			self.Parameter.Points:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.DiceGreyMark)
			self.Parameter.currency:SetActiveEx(l_mgr.Datas.m_online_time/60 >= l_mgr.Datas.m_SignInQuickMakeNode)
		end
	end
end
function ActivityCheckInDiceItemTemplate:OnClickSetDice()
	if self.m_num <= 0 then
		if l_mgr.Datas.m_next_dice_idx ~= self.m_idx then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_SetDice_FollowOrder"))
		elseif self.m_active then
			-- 直接发协议定制。案子说要拨个动画，可以在协议返回时搞搞。
			l_mgr.SendSetSpecialSupplyDice(self.m_idx)
		elseif l_mgr.Datas.m_online_time/60 >= l_mgr.Datas.m_SignInQuickMakeNode then
			-- 没有激活，就是在线时间不够了，提示花钱
			local tip = Lang("ActivityCheckIn_SetDice_Quick"
				,math.floor(l_mgr.Datas.m_online_time/60),self.m_minutes, l_mgr.Datas.m_cost_txt_reset_dice)
			CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm,true,Lang("TIP"), tip,
					Lang("DLG_BTN_YES"),Lang("DLG_BTN_NO"),function()
						l_mgr.SendSetSpecialSupplyDice(self.m_idx)
					end)
			--CommonUI.Dialog.ShowYesNoDlg(true, Lang("TIP"), tip, function()
			--	l_mgr.SendSetSpecialSupplyDice(self.m_idx)
			--end)
		else
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_SetDice_Wait"))
		end
	else
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_SetDice_AreadySet", self.m_num))
	end
end
--lua custom scripts end
return ActivityCheckInDiceItemTemplate