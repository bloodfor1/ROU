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
---@class BoliFindRecordItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SceneName MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field BoliCountIcon MoonClient.MLuaUICom[]

---@class BoliFindRecordItemTemplate : BaseUITemplate
---@field Parameter BoliFindRecordItemTemplateParameter

BoliFindRecordItemTemplate = class("BoliFindRecordItemTemplate", super)
--lua class define end

--lua functions
function BoliFindRecordItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function BoliFindRecordItemTemplate:OnDestroy()
	
	
end --func end
--next--
function BoliFindRecordItemTemplate:OnDeActive()
	
	
end --func end
--next--
function BoliFindRecordItemTemplate:OnSetData(data)
	
	    if data.sceneId > 0 then
	        local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(data.sceneId)
	        if l_sceneRow then
	            self.Parameter.SceneName.LabText = l_sceneRow.MiniMap
	        end
	        for i = 1, #self.Parameter.BoliCountIcon do
	            self.Parameter.BoliCountIcon[i].UObj:SetActiveEx(i <= data.num)
	        end
	    else
	        self.Parameter.SceneName.LabText = "? ? ? ?"
	        for i = 1, #self.Parameter.BoliCountIcon do
	            self.Parameter.BoliCountIcon[i].UObj:SetActiveEx(false)
	        end
	    end
	
end --func end
--next--
function BoliFindRecordItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BoliFindRecordItemTemplate