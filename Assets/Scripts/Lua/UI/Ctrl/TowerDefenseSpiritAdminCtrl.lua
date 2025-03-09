--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TowerDefenseSpiritAdminPanel"
require "UI/Template/TowerDefenseSpiritAdminTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local Mgr = MgrMgr:GetMgr("TowerDefenseMgr")
--lua fields end

--lua class define
TowerDefenseSpiritAdminCtrl = class("TowerDefenseSpiritAdminCtrl", super)
--lua class define end

--lua functions
function TowerDefenseSpiritAdminCtrl:ctor()
	
	super.ctor(self, CtrlNames.TowerDefenseSpiritAdmin, UILayer.Function, nil, ActiveType.Exclusive)

	self.overrideSortLayer = UILayerSort.Function + 1
	
end --func end
--next--
function TowerDefenseSpiritAdminCtrl:Init()
	
	self.panel = UI.TowerDefenseSpiritAdminPanel.Bind(self)
	super.Init(self)

	-- 组件
	self.SpiritAdminItemTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.TowerDefenseSpiritAdminTemplate,
		TemplatePrefab = self.panel.TowerDefenseSpiritAdminPrefab.gameObject,
		ScrollRect = self.panel.ScrollRect.LoopScroll,
	})
	
end --func end
--next--
function TowerDefenseSpiritAdminCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function TowerDefenseSpiritAdminCtrl:OnActive()
	self:RefreshPanel()
	
end --func end
--next--
function TowerDefenseSpiritAdminCtrl:OnDeActive()
	
	
end --func end
--next--
function TowerDefenseSpiritAdminCtrl:Update()
	
	
end --func end
--next--
function TowerDefenseSpiritAdminCtrl:BindEvents()
	self:BindEvent(Mgr.EventDispatcher,Mgr.OnAdminSpiritEvent, function()
		self:RefreshPanel()
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function TowerDefenseSpiritAdminCtrl:RefreshPanel()
	local l_itemData = {}
	for i = 1, TableUtil.GetTdUnitTable().GetTableSize() do
		local l_tdUnitData = Mgr.GetTdUnitRowById(i)
		if l_tdUnitData then
			if Mgr.SpiritSummonData[Mgr.CurrentSummonId] then
				if Mgr.SpiritSummonData[Mgr.CurrentSummonId][l_tdUnitData.ID] then
					l_tdUnitData.servant_type = Mgr.SpiritSummonData[Mgr.CurrentSummonId][l_tdUnitData.ID].servant_type
					l_tdUnitData.servant_num = Mgr.SpiritSummonData[Mgr.CurrentSummonId][l_tdUnitData.ID].servant_num
					l_tdUnitData.servant_level = Mgr.SpiritSummonData[Mgr.CurrentSummonId][l_tdUnitData.ID].servant_level
				else
					l_tdUnitData.servant_type = l_tdUnitData.ID
					l_tdUnitData.servant_num = 0
					l_tdUnitData.servant_level = 1
				end
			else
				l_tdUnitData.servant_type = l_tdUnitData.ID
				l_tdUnitData.servant_num = 0
				l_tdUnitData.servant_level = 1
			end
			table.insert(l_itemData, l_tdUnitData)
		end
	end
	self.SpiritAdminItemTemplatePool:ShowTemplates({
		Datas = l_itemData,
	})
end

--lua custom scripts end
return TowerDefenseSpiritAdminCtrl