--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/FarmPromptMonsterItem"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class FarmPromptItemParameter.FarmPromptMonsterItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field icon MoonClient.MLuaUICom

---@class FarmPromptItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropmtTip MoonClient.MLuaUICom
---@field monsterContent MoonClient.MLuaUICom
---@field MapName MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field loopScroll MoonClient.MLuaUICom
---@field goBtn MoonClient.MLuaUICom
---@field FarmPromptMonsterItem FarmPromptItemParameter.FarmPromptMonsterItem

---@class FarmPromptItem : BaseUITemplate
---@field Parameter FarmPromptItemParameter

FarmPromptItem = class("FarmPromptItem", super)
--lua class define end

--lua functions
function FarmPromptItem:Init()
	
	    super.Init(self)
	    self.monsterItemPool = self:NewTemplatePool({
	        UITemplateClass = UITemplate.FarmPromptMonsterItem,
	        TemplatePrefab = self.Parameter.FarmPromptMonsterItem.LuaUIGroup.gameObject,
	        ScrollRect = self.Parameter.loopScroll.LoopScroll,
	    })
	
end --func end
--next--
function FarmPromptItem:OnDestroy()
	
	    self.monsterItemPool = nil
	
end --func end
--next--
function FarmPromptItem:OnSetData(data)
	
	local farmSdata = TableUtil.GetFarmInfoTable().GetRowByID(data.id)
	    local sceneSdata = TableUtil.GetSceneTable().GetRowByID(farmSdata.SceneId)
	    if not sceneSdata then
	        return logError("can't find scene sdata by: ", farmSdata.SceneId)
	    end
	    self.Parameter.MapName.LabText = sceneSdata.MiniMap
	    self.Parameter.Lv.LabText = StringEx.Format("{0}~{1}", farmSdata.SceneLvRange[0] or 0, farmSdata.SceneLvRange[1] or 0)
	    self.Parameter.PropmtTip.LabText = Lang("EXPEL_FARM_TIP", farmSdata.Tip)
	    self.Parameter.goBtn:AddClick(function()
	        UIMgr:DeActiveUI(UI.CtrlNames.FarmPrompt)
	        UIMgr:DeActiveUI(UI.CtrlNames.LevelReward)
	        UIMgr:DeActiveUI(UI.CtrlNames.Welfare)
	        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
	        MTransferMgr:GotoScene(farmSdata.SceneId)
	    end)
	    local datas = {}
	    local monsters = Common.Functions.VectorToTable(farmSdata.Monsters)
	    for i, v in ipairs(monsters) do
	        table.insert(datas, { monsId = v })
	    end
	    self.monsterItemPool:ShowTemplates({Datas = datas})
	    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.LuaUIGroup.RectTransform)
	
end --func end
--next--
function FarmPromptItem:BindEvents()
	
	
end --func end
--next--
function FarmPromptItem:OnDeActive()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return FarmPromptItem