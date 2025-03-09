--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class TowerFirstRewardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLevel MoonClient.MLuaUICom
---@field TxtGetReward MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnGetReward MoonClient.MLuaUICom

---@class TowerFirstRewardTemplate : BaseUITemplate
---@field Parameter TowerFirstRewardTemplateParameter

TowerFirstRewardTemplate = class("TowerFirstRewardTemplate", super)
--lua class define end

--lua functions
function TowerFirstRewardTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function TowerFirstRewardTemplate:OnDestroy()
	
	
end --func end
--next--
function TowerFirstRewardTemplate:OnDeActive()
	
	
end --func end
--next--
function TowerFirstRewardTemplate:OnSetData(data)
	
	self.lv = data.lv
	self.items = data.items
	self.itemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
	})
	self:InitTemplate()
	
end --func end
--next--
function TowerFirstRewardTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function TowerFirstRewardTemplate:InitTemplate()

	local l_mgr = MgrMgr:GetMgr("InfiniteTowerDungeonMgr")

	self.Parameter.TxtLevel.LabText = Common.Utils.Lang("LEVEL_NUMBER", self.lv)
	
	local l_hasGetReward = l_mgr.HasGetReward(self.lv)
	self.Parameter.BtnGetReward.gameObject:SetActiveEx(not l_hasGetReward)
	if not l_hasGetReward then
		if l_mgr.IsHistoryCleared(self.lv) then
			self.Parameter.BtnGetReward:SetGray(false)
			self.Parameter.BtnGetReward:AddClick(function()
				local l_row = TableUtil.GetEndlessTowerTable().GetRowByID(self.lv)
				l_mgr.RequestTowerDungeonsAward(l_row.DungeonsID[0][1])
				self.Parameter.BtnGetReward.gameObject:SetActiveEx(false)
			end)
		else
			self.Parameter.BtnGetReward:SetGray(true)
			self.Parameter.BtnGetReward:AddClick(function()
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("INFINITE_TOWER_AWARD_NOT_READY"))
			end)
		end
	end

	local l_itemDatas = {}

	for _,item in pairs(self.items) do
		table.insert(l_itemDatas, {
			ID = item.item_id,
			Count = item.count,
			IsShowCount = true,
		})
	end

	self.itemPool:ShowTemplates({Datas = l_itemDatas, Parent = self.Parameter.Content.transform})
	
end
--lua custom scripts end
return TowerFirstRewardTemplate