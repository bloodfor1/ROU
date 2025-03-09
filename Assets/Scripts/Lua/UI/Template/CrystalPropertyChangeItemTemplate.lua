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
---@class CrystalPropertyChangeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field NextBuffValue MoonClient.MLuaUICom
---@field NextBuffName MoonClient.MLuaUICom
---@field NextBuffBox MoonClient.MLuaUICom
---@field ImgArrow MoonClient.MLuaUICom
---@field CurBuffValue MoonClient.MLuaUICom
---@field CurBuffName MoonClient.MLuaUICom
---@field CurBuffBox MoonClient.MLuaUICom

---@class CrystalPropertyChangeItemTemplate : BaseUITemplate
---@field Parameter CrystalPropertyChangeItemTemplateParameter

CrystalPropertyChangeItemTemplate = class("CrystalPropertyChangeItemTemplate", super)
--lua class define end

--lua functions
function CrystalPropertyChangeItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function CrystalPropertyChangeItemTemplate:OnDestroy()
	
	
end --func end
--next--
function CrystalPropertyChangeItemTemplate:OnDeActive()
	
	
end --func end
--next--
function CrystalPropertyChangeItemTemplate:OnSetData(data)
	
	    if data.curName then
	        self.Parameter.CurBuffBox.UObj:SetActiveEx(true)
	        self.Parameter.CurBuffName.LabText = data.curName
	        self.Parameter.CurBuffValue.LabText = data.curValue
	    else
	        self.Parameter.CurBuffBox.UObj:SetActiveEx(false)
	    end
	    --如果下一阶不存在的话 箭头也不显示
	    if data.nextName then
	        self.Parameter.ImgArrow.UObj:SetActiveEx(true)
	        self.Parameter.NextBuffBox.UObj:SetActiveEx(true)
	        self.Parameter.NextBuffName.LabText = data.nextName
	        self.Parameter.NextBuffValue.LabText = data.nextValue
	    else
	        self.Parameter.ImgArrow.UObj:SetActiveEx(false)
	        self.Parameter.NextBuffBox.UObj:SetActiveEx(false)
	    end
	
end --func end
--next--
function CrystalPropertyChangeItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return CrystalPropertyChangeItemTemplate