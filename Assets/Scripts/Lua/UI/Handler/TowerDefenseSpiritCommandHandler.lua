--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/TowerDefenseSpiritCommandPanel"
require "UI/Template/TowerDefenseSpiritCommandTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local Mgr = MgrMgr:GetMgr("TowerDefenseMgr")
--next--
--lua fields end

--lua class define
TowerDefenseSpiritCommandHandler = class("TowerDefenseSpiritCommandHandler", super)
--lua class define end

--lua functions
function TowerDefenseSpiritCommandHandler:ctor()
	
	super.ctor(self, HandlerNames.TowerDefenseSpiritCommand, 0)
	
end --func end
--next--
function TowerDefenseSpiritCommandHandler:Init()
	
	self.panel = UI.TowerDefenseSpiritCommandPanel.Bind(self)
	super.Init(self)
	-- 组件
	self.SpiritCommandItemTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.TowerDefenseSpiritCommandTemplate,
		TemplatePrefab = self.panel.TowerDefenseSpiritCommandPrefab.gameObject,
		ScrollRect = self.panel.ScrollRect.LoopScroll,
	})
	
end --func end
--next--
function TowerDefenseSpiritCommandHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function TowerDefenseSpiritCommandHandler:OnActive()

	self:RefreshPanel()
end --func end
--next--
function TowerDefenseSpiritCommandHandler:OnDeActive()
	
	
end --func end
--next--
function TowerDefenseSpiritCommandHandler:Update()
	
	
end --func end


--next--
function TowerDefenseSpiritCommandHandler:BindEvents()
	self:BindEvent(Mgr.EventDispatcher,Mgr.OnCommandSpiritEvent, function()
		self:RefreshPanel()
	end)
end --func end
--next--
--lua functions end

--lua custom scripts
function TowerDefenseSpiritCommandHandler:RefreshPanel()
	local l_itemData = {}
	for i = 1, TableUtil.GetTdOrderTable().GetTableSize() do
		local l_tdOrderData = Mgr.GetTdOrderRowById(i)
		if l_tdOrderData then
			table.insert(l_itemData, l_tdOrderData)
		end
	end
	self.SpiritCommandItemTemplatePool:ShowTemplates({
		Datas = l_itemData,
	})
end
--lua custom scripts end
return TowerDefenseSpiritCommandHandler