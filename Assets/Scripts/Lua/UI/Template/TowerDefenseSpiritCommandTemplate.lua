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
---@class TowerDefenseSpiritCommandTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName MoonClient.MLuaUICom
---@field TxtExpend MoonClient.MLuaUICom
---@field TxtDesc MoonClient.MLuaUICom
---@field TxtCDDesc MoonClient.MLuaUICom
---@field TowerDefenseSpiritCommandPrefab MoonClient.MLuaUICom
---@field ImgCommond MoonClient.MLuaUICom
---@field BtnUse MoonClient.MLuaUICom
---@field BtnGrayUse MoonClient.MLuaUICom

---@class TowerDefenseSpiritCommandTemplate : BaseUITemplate
---@field Parameter TowerDefenseSpiritCommandTemplateParameter

TowerDefenseSpiritCommandTemplate = class("TowerDefenseSpiritCommandTemplate", super)
--lua class define end

--lua functions
function TowerDefenseSpiritCommandTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function TowerDefenseSpiritCommandTemplate:OnDestroy()
	
	
end --func end
--next--
function TowerDefenseSpiritCommandTemplate:OnDeActive()
	
	
end --func end
--next--
function TowerDefenseSpiritCommandTemplate:OnSetData(data)
	
	self.data = data
	self.Parameter.ImgCommond:SetSprite(data.IconAtlas, data.IconName, false)
	self.Parameter.TxtName.LabText = data.Name
	self.Parameter.TxtCDDesc.LabText = Common.Utils.Lang("TowerDefenseSpiritCDTime", data.CoolDown)
	self.Parameter.TxtDesc.LabText = data.Desc
	self.Parameter.TxtExpend.LabText = data.Cost
	local l_time = MgrMgr:GetMgr("TowerDefenseMgr").GetSpiritCDTimeByType(self.ShowIndex, MgrMgr:GetMgr("TowerDefenseMgr").CurrentSummonId)
	if l_time <= 0 then
		self.Parameter.BtnUse.gameObject:SetActiveEx(true)
		self.Parameter.BtnGrayUse.gameObject:SetActiveEx(false)
	else
		self.Parameter.BtnUse.gameObject:SetActiveEx(false)
		self.Parameter.BtnGrayUse.gameObject:SetActiveEx(true)
		self.Parameter.BtnGrayUse.GradualChange:SetData(l_time)
		self.Parameter.BtnGrayUse.GradualChange:SetMethod(nil,function()
			self.Parameter.BtnUse.gameObject:SetActiveEx(true)
			self.Parameter.BtnGrayUse.gameObject:SetActiveEx(false)
		end)
	end
	self.Parameter.BtnUse:AddClick(function()
		local l_tdOrderData = MgrMgr:GetMgr("TowerDefenseMgr").GetTdOrderRowById(self.ShowIndex)
		if l_tdOrderData then
			if MgrMgr:GetMgr("TowerDefenseMgr").TowerDefenseMagicPowerData.magic_value < l_tdOrderData.Cost then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseMagicPowerNotEnough"))
				return
			end
			MgrMgr:GetMgr("TowerDefenseMgr").ReqCommandSpirit({ summon_id = MgrMgr:GetMgr("TowerDefenseMgr").CurrentSummonId, servant_cmd = self.ShowIndex })
		end
	end)
	
end --func end
--next--
function TowerDefenseSpiritCommandTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return TowerDefenseSpiritCommandTemplate