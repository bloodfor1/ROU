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
---@class ItemAttrListTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Loop_AttrList MoonClient.MLuaUICom
---@field Img_Star MoonClient.MLuaUICom

---@class ItemAttrListTemplate : BaseUITemplate
---@field Parameter ItemAttrListTemplateParameter

ItemAttrListTemplate = class("ItemAttrListTemplate", super)
--lua class define end

--lua functions
function ItemAttrListTemplate:Init()
    super.Init(self)
    self:_initTemplateConfig()
    self:_initWidgets()
end --func end
--next--
function ItemAttrListTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function ItemAttrListTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function ItemAttrListTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function ItemAttrListTemplate:OnSetData(data)
    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function ItemAttrListTemplate:_initTemplateConfig()
    self._attrLabTemplatePoolConfig = {
        TemplateClassName = "AttrDescLab",
        TemplatePath = "UI/Prefabs/AttrDescLab",
        ScrollRect = self.Parameter.Loop_AttrList.LoopScroll
    }
end

function ItemAttrListTemplate:_initWidgets()
    self._attrList = self:NewTemplatePool(self._attrLabTemplatePoolConfig)
end

---@param data AttrCompareListParam
function ItemAttrListTemplate:_setData(data)
    if nil == data then
        logError("[ItemAttrList] param got nil")
        return
    end

    local paramWrap = { Datas = data.attrs }
    self._attrList:ShowTemplates(paramWrap)
    self.Parameter.Text.LabText = data.showName
    self.Parameter.Img_Star.gameObject:SetActiveEx(data.showStar)
end
--lua custom scripts end
return ItemAttrListTemplate