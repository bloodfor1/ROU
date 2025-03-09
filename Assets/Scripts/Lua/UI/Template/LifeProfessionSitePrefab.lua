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
---@class LifeProfessionSitePrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field GoBtn MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom

---@class LifeProfessionSitePrefab : BaseUITemplate
---@field Parameter LifeProfessionSitePrefabParameter

LifeProfessionSitePrefab = class("LifeProfessionSitePrefab", super)
--lua class define end

--lua functions
function LifeProfessionSitePrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function LifeProfessionSitePrefab:OnDeActive()
	
	
end --func end
--next--
function LifeProfessionSitePrefab:OnSetData(data)
	
	    self.data = data.data
	    self.ctrl = data.ctrl
	    local l_sceneInfo = TableUtil.GetSceneTable().GetRowByID(self.data.sceneID)
	    self.Parameter.Content.LabText = l_sceneInfo.MapEntryName
	    self.Parameter.GoBtn:AddClick(function()
	        self.MethodCallback(self.ctrl, self.data)
	    end, true)
	
end --func end
--next--
function LifeProfessionSitePrefab:BindEvents()
	
	
end --func end
--next--
function LifeProfessionSitePrefab:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return LifeProfessionSitePrefab