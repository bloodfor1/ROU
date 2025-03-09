--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/InfinityTowerBtnTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class InfinityTowerTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel

---@class InfinityTowerTemplate : BaseUITemplate
---@field Parameter InfinityTowerTemplateParameter

InfinityTowerTemplate = class("InfinityTowerTemplate", super)
--lua class define end

--lua functions
function InfinityTowerTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function InfinityTowerTemplate:OnDestroy()
	
	self.btnPool = nil
	
end --func end
--next--
function InfinityTowerTemplate:OnSetData(data)
	
	if not self.btnPool then
		self.btnPool = self:NewTemplatePool({
	        UITemplateClass = UITemplate.InfinityTowerBtnTemplate,
	        TemplateParent = self.Parameter.LuaUIGroup.transform,
	        TemplatePrefab = data.btn,
	    })
	end
	self:ShowData(data)
	
end --func end
--next--
function InfinityTowerTemplate:BindEvents()
	
	
end --func end
--next--
function InfinityTowerTemplate:OnDeActive()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function InfinityTowerTemplate:ShowData(data)

	self.Parameter.LuaUIGroup.gameObject:SetActiveEx(true)

	local l_block = data.block
	local l_current = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_saveTowerLevel
	local l_baseBlockSplit = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_towerBlockSplit
	-- 未解锁的显示默认的塔身体
	if (l_block - 1) * l_baseBlockSplit > l_current then
		return
	end

	local l_unlockLevel = l_current + 1

	-- 一个block包含5层
	local l_records = {}
	local l_saveTower = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_saveTowerLevel
	local l_baseLevel = (l_block - 1) * l_baseBlockSplit
	for id = l_baseLevel + 1, l_baseLevel + l_baseBlockSplit do
		local l_row = TableUtil.GetEndlessTowerTable().GetRowByID(id,true)
		-- 解锁并且为记录层
		if l_row and l_row.IsSave == 1 and (id <= l_unlockLevel) then
			local l_left = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").GetLevelIsLeft(l_row.ID)
			local l_record = {
				ID = id,
				left = l_left,
				mvp = l_row.IsBossFloor,
				selectId = l_saveTower,
			}
			-- 计算标签index
			if (id % l_baseBlockSplit) == 0 then
				l_record.index = l_baseBlockSplit
			else
				l_record.index = id - math.floor(id / l_baseBlockSplit) * l_baseBlockSplit
			end
			table.insert(l_records, l_record)
		end
	end

	self.btnPool:ShowTemplates({Datas = l_records, Method = function(_, id)
		UIMgr:ActiveUI(UI.CtrlNames.InfinityTowerStageInfo, function(ctrl)
			ctrl:InitWithTowerLevel(id)
			self:UpdateSelectState(id)
			MgrMgr:GetMgr("InfiniteTowerDungeonMgr").OnSelectTower(id)
		end)
	end})
	
end

function InfinityTowerTemplate:UpdateSelectState(id)
	
	local l_items = self.btnPool:GetItems()
	if l_items then
		for k, v in pairs(l_items) do
			v:UpdateSelectState(id)
		end
	end
end
--lua custom scripts end
return InfinityTowerTemplate