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
---@class GuideSpineTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field NpcAnim MoonClient.MLuaUICom

---@class GuideSpineTemplate : BaseUITemplate
---@field Parameter GuideSpineTemplateParameter

GuideSpineTemplate = class("GuideSpineTemplate", super)
--lua class define end

--lua functions
function GuideSpineTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuideSpineTemplate:OnDestroy()
	
	
end --func end
--next--
function GuideSpineTemplate:OnDeActive()
	
	
end --func end
--next--
function GuideSpineTemplate:OnSetData(data)
	
	    local l_spineMesh = self.Parameter.NpcAnim.UObj:GetComponent("MeshRenderer")
	    if l_spineMesh then
	        l_spineMesh.sortingOrder = data.layer or 0
	    end
	
end --func end
--next--
function GuideSpineTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GuideSpineTemplate:ctor(data)
    if data==nil then
        data={}
    end
    data.TemplatePath = "UI/Prefabs/GuideSpine"
    super.ctor(self,data)
end
--lua custom scripts end
return GuideSpineTemplate