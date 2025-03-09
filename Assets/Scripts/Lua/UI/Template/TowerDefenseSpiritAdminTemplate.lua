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
---@class TowerDefenseSpiritAdminTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtSummonExpend MoonClient.MLuaUICom
---@field TxtNum MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field TxtLvUpExpend MoonClient.MLuaUICom
---@field TxtLv MoonClient.MLuaUICom
---@field TxtDesc MoonClient.MLuaUICom
---@field TowerDefenseSpiritAdminPrefab MoonClient.MLuaUICom
---@field ImgAdmin MoonClient.MLuaUICom
---@field IconHead MoonClient.MLuaUICom
---@field BtnSummon MoonClient.MLuaUICom
---@field BtnLvUp MoonClient.MLuaUICom

---@class TowerDefenseSpiritAdminTemplate : BaseUITemplate
---@field Parameter TowerDefenseSpiritAdminTemplateParameter

TowerDefenseSpiritAdminTemplate = class("TowerDefenseSpiritAdminTemplate", super)
--lua class define end

--lua functions
function TowerDefenseSpiritAdminTemplate:Init()
	
	super.Init(self)
	self.isOpenYesNoDlg = false        -- 是否打开了dlg
	self.currentYesNoDlgEventStatus = -1    -- 当前打开dlg状态 0表示升级英灵魔力不足 1表示升级英灵魔力足够 默认-1	
	
end --func end
--next--
function TowerDefenseSpiritAdminTemplate:BindEvents()
	
	self:BindEvent(MgrMgr:GetMgr("TowerDefenseMgr").EventDispatcher,MgrMgr:GetMgr("TowerDefenseMgr").ReceiveTowerDefenseMagicPowerNtfEvent, function()
		self:SetYesNoDlgConfirmGray()
	end)
	
end --func end
--next--
function TowerDefenseSpiritAdminTemplate:OnDestroy()
	
	
end --func end
--next--
function TowerDefenseSpiritAdminTemplate:OnDeActive()
	
	self.isOpenYesNoDlg = false
	self.currentYesNoDlgEventStatus = -1
	GlobalEventBus:Dispatch(EventConst.Names.SetYesNoDlgBtnGray, "confirm", false)
	
end --func end
--next--
function TowerDefenseSpiritAdminTemplate:OnSetData(data)
	
	self.data = data
	self.Parameter.IconHead:SetSprite(data.IconAtlas, data.IconName .. ".png", false)
	self.Parameter.TxtNum.LabText = "×" .. data.servant_num
	self.Parameter.TxtName.LabText = data.Name
	self.Parameter.TxtLv.LabText = string.format("Lv.%d", data.servant_level)
	self.Parameter.TxtSummonExpend.LabText = data.SummonCosts[data.servant_level - 1][1]
	self.Parameter.TxtLvUpExpend.LabText = self:GetCostMagicPowerNum()
	self.Parameter.TxtDesc.LabText = data.Desc
	self.Parameter.BtnLvUp:AddClick(function()
		if data.servant_level == self.data.SummonCosts.Length then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GUILD_BUILD_ALREADY_MAX_LEVEL"))
			return
		end
		local l_magicCount = self:GetCostMagicPowerNum()
		local l_msg = Common.Utils.Lang("TD_LV_UP_CONFIRM", l_magicCount, data.Name)
		local okFunc = function()
			self.isOpenYesNoDlg = false
			self.currentYesNoDlgEventStatus = -1
			if MgrMgr:GetMgr("TowerDefenseMgr").TowerDefenseMagicPowerData.magic_value < l_magicCount then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseMagicPowerNotEnough"))
				return
			end
			MgrMgr:GetMgr("TowerDefenseMgr").ReqAdminSpirit({ summon_id = MgrMgr:GetMgr("TowerDefenseMgr").CurrentSummonId, servant_type = data.servant_type, is_summon = false })
		end
		local cancelFunc = function()
			self.isOpenYesNoDlg = false
			self.currentYesNoDlgEventStatus = -1
		end
		CommonUI.Dialog.ShowYesNoDlg(true, nil, l_msg, okFunc, cancelFunc, nil, nil, nil, function()
			self.isOpenYesNoDlg = true
			self:SetYesNoDlgConfirmGray()
		end)
	end)
	self.Parameter.BtnSummon:AddClick(function()
		local Mgr = MgrMgr:GetMgr("TowerDefenseMgr")
		local l_tdUnitData = Mgr.GetTdUnitRowById(data.servant_type)
		if l_tdUnitData then
			local l_servantLevel = 1
			if Mgr.SpiritSummonData[Mgr.CurrentSummonId] and Mgr.SpiritSummonData[Mgr.CurrentSummonId][data.servant_type] then
				l_servantLevel = Mgr.SpiritSummonData[Mgr.CurrentSummonId][data.servant_type].servant_level
			end
			local l_magicCount = l_tdUnitData.SummonCosts[l_servantLevel - 1][1]
			if Mgr.TowerDefenseMagicPowerData.magic_value < l_magicCount then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseMagicPowerNotEnough"))
				return
			end
			Mgr.ReqAdminSpirit({ summon_id = Mgr.CurrentSummonId, servant_type = data.servant_type, is_summon = true })
		end
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function TowerDefenseSpiritAdminTemplate:GetCostMagicPowerNum()
	-- 升级特定兵种花费的魔力 = 升级兵种本身所需魔力 + 召唤阵内的该兵种人数 * (召唤下一级该兵种所需魔力 – 召唤本级该兵种所需魔力)
	if self.data == nil then
		return 0
	end

	if self.data.UpgradeCosts == nil then
		return 0
	end

	local l_upgradeCostsCount = self.data.UpgradeCosts.Length

	if l_upgradeCostsCount == 0 then
		return 0
	end

	local l_upgradeCostsIndex = self.data.servant_level - 1

	if l_upgradeCostsIndex >= l_upgradeCostsCount then
		l_upgradeCostsIndex = l_upgradeCostsCount - 1
	end

	local l_upgradeCost = self.data.UpgradeCosts[l_upgradeCostsIndex][1]

	local l_summonCostsIndex = self.data.servant_level

	if l_summonCostsIndex >= self.data.SummonCosts.Length then
		l_summonCostsIndex = self.data.SummonCosts.Length - 1
	end

	local l_summonCosts = self.data.SummonCosts[l_summonCostsIndex][1]

	local l_lastSummonCostsIndex = l_summonCostsIndex - 1
	if l_lastSummonCostsIndex < 0 then
		l_lastSummonCostsIndex = 0
	end

	local l_lastSummonCosts = self.data.SummonCosts[l_lastSummonCostsIndex][1]

	return l_upgradeCost + self.data.servant_num * (l_summonCosts - l_lastSummonCosts)
end

function TowerDefenseSpiritAdminTemplate:SetYesNoDlgConfirmGray()

	local l_magicCount = self:GetCostMagicPowerNum()
	if self.isOpenYesNoDlg then
		if MgrMgr:GetMgr("TowerDefenseMgr").TowerDefenseMagicPowerData.magic_value < l_magicCount then
			if self.currentYesNoDlgEventStatus ~= 0 then
				GlobalEventBus:Dispatch(EventConst.Names.SetYesNoDlgBtnGray, "confirm", true)
			end
			self.currentYesNoDlgEventStatus = 0
		else
			if self.currentYesNoDlgEventStatus ~= 1 then
				GlobalEventBus:Dispatch(EventConst.Names.SetYesNoDlgBtnGray, "confirm", false)
			end
			self.currentYesNoDlgEventStatus = 1
		end
	end
end
--lua custom scripts end
return TowerDefenseSpiritAdminTemplate