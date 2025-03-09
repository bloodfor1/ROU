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
---@class AttrDescLabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Img_GaoShuXing MoonClient.MLuaUICom
---@field Img_DiShuXing MoonClient.MLuaUICom
---@field AttrDescLab MoonClient.MLuaUICom

---@class AttrDescLab : BaseUITemplate
---@field Parameter AttrDescLabParameter

AttrDescLab = class("AttrDescLab", super)
--lua class define end

--lua functions
function AttrDescLab:Init()
    super.Init(self)
end --func end
--next--
function AttrDescLab:BindEvents()
    -- do nothing
end --func end
--next--
function AttrDescLab:OnDestroy()
    -- do nothing
end --func end
--next--
function AttrDescLab:OnDeActive()
    -- do nothing
end --func end
--next--
function AttrDescLab:OnSetData(data)
    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param str EquipAttrPair
function AttrDescLab:_setData(str)
    self.Parameter.Img_GaoShuXing.gameObject:SetActiveEx(str.isRare)
    self.Parameter.Img_DiShuXing.gameObject:SetActiveEx(not str.isRare)
    self.Parameter.AttrDescLab.LabText = str.desc
end
--lua custom scripts end
return AttrDescLab