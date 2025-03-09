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
---@class RefineAttrParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ShowAttrBtn MoonClient.MLuaUICom
---@field RefineAttrName MoonClient.MLuaUICom
---@field AttrValue MoonClient.MLuaUICom

---@class RefineAttr : BaseUITemplate
---@field Parameter RefineAttrParameter

RefineAttr = class("RefineAttr", super)
--lua class define end

--lua functions
function RefineAttr:Init()
    super.Init(self)
end --func end
--next--
function RefineAttr:BindEvents()
    -- do nothing
end --func end
--next--
function RefineAttr:OnDestroy()
    -- do nothing
end --func end
--next--
function RefineAttr:OnDeActive()
    -- do nothing
end --func end
--next--
function RefineAttr:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param data RefineAttrParam
function RefineAttr:_onSetData(data)
    if nil == data then
        logError("[RefineAttr] invalid param")
        return
    end

    self.Parameter.RefineAttrName.LabText = data.name
    self.Parameter.AttrValue.LabText = data.value
    local onClick = function()
        self:_onAttrClick(data.desc)
    end

    self.Parameter.ShowAttrBtn:AddClick(onClick)
end

function RefineAttr:_onAttrClick(tipStr)
    if nil == tipStr then
        logError("invalid param")
        return
    end

    local l_pointEventData = {}
    local pos = Vector2.New(Input.mousePosition.x-300,Input.mousePosition.y)

    l_pointEventData.position = pos
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(
            tipStr,
            l_pointEventData,
            Vector2(0, 0),
            false,
            nil,
            MUIManager.UICamera,
            true)
end

--lua custom scripts end
return RefineAttr