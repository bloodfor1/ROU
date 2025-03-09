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
---@class DemonEvictionTipsTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field LvNumber MoonClient.MLuaUICom
---@field Jiantou1 MoonClient.MLuaUICom
---@field Jiantou MoonClient.MLuaUICom
---@field ExpNumber MoonClient.MLuaUICom
---@field AddNumber MoonClient.MLuaUICom

---@class DemonEvictionTipsTemplate : BaseUITemplate
---@field Parameter DemonEvictionTipsTemplateParameter

DemonEvictionTipsTemplate = class("DemonEvictionTipsTemplate", super)
--lua class define end

--lua functions
function DemonEvictionTipsTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function DemonEvictionTipsTemplate:OnDestroy()
	
	
end --func end
--next--
function DemonEvictionTipsTemplate:OnDeActive()
	
	
end --func end
--next--
function DemonEvictionTipsTemplate:OnSetData(data)
	
	    self:CustomSetData(data)
	
end --func end
--next--
function DemonEvictionTipsTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function DemonEvictionTipsTemplate:CustomSetData(data)
    if data.max >= 10000 then
        self.Parameter.LvNumber.LabText = StringEx.Format("{0}+", data.min)
    else
        self.Parameter.LvNumber.LabText = StringEx.Format("{0}-{1}", data.min, data.max)
    end
    
    if data.addinExp > 100 then
        self.Parameter.ExpNumber.LabText = Lang("DEMON_EVICTION_TIPS_FORMAT1", data.baseExp, data.addinExp-100, data.rate)
        MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Jiantou1.gameObject, 34)
    else
        self.Parameter.ExpNumber.LabText = Lang("DEMON_EVICTION_TIPS_FORMAT2", data.baseExp, data.rate)
        MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Jiantou1.gameObject, 0)
    end
    
    self.Parameter.Jiantou.gameObject:SetActiveEx(data.above)
end
--lua custom scripts end
return DemonEvictionTipsTemplate