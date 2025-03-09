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
---@class RefineTransferItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field MaterialSelectItem MoonClient.MLuaUICom
---@field Description MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom

---@class RefineTransferItemTemplate : BaseUITemplate
---@field Parameter RefineTransferItemTemplateParameter

RefineTransferItemTemplate = class("RefineTransferItemTemplate", super)
--lua class define end

--lua functions
function RefineTransferItemTemplate:Init()
    super.Init(self)
end --func end
--next--
function RefineTransferItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function RefineTransferItemTemplate:OnDestroy()
    self._item = nil
end --func end
--next--
function RefineTransferItemTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function RefineTransferItemTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
---@param param RefineTransTargetData
function RefineTransferItemTemplate:CustomSetData(param)
    local data = param.targetItem
    local l_item_row = data.ItemConfig
    if not l_item_row then
        logError("RefineTransferItemTemplate:CustomSetData fail, cannot find item", data.TID)
        return
    end

    if self._item == nil then
        self._item = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.MaterialSelectItem.transform })
        MLuaCommonHelper.SetLocalPosX(self._item:gameObject(), -140)
    end

    self._item:SetData({ PropInfo = data, IsShowCount = false })
    local l_texts = self:_getRefineAttrStrs(self:_getAttrs(data))
    local l_text = ""
    for i = 1, #l_texts do
        l_text = l_text .. l_texts[i]
        if i ~= #l_texts then
            l_text = l_text .. ";"
        end
    end

    self.Parameter.Description.LabText = l_text
    self.Parameter.Name.LabText = l_item_row.ItemName
    local setGray = param.currentSelectTid == data.TID
    local l_clickFunc = function()
        if setGray then
            local hintStr = Common.Utils.Lang("C_EQUIP_SAME_TID")
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(hintStr)
            return
        end

        if self.MethodCallback then
            self.MethodCallback(data)
        end
    end

    self.Parameter.BtnSelect:SetGray(setGray)
    self.Parameter.BtnSelect:AddClick(l_clickFunc)
    self.Parameter.MaterialSelectItem:AddClick(l_clickFunc)
end

function RefineTransferItemTemplate:_getAttrs(itemData)
    local refineAttrSet = itemData.AttrSet[GameEnum.EItemAttrModuleType.Refine]
    local refineAttr = {}
    if nil ~= refineAttrSet then
        refineAttr = refineAttrSet[1]
    end

    return refineAttr
end

function RefineTransferItemTemplate:_getRefineAttrStrs(attrs)
    local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
    local ret = {}
    for i = 1, #attrs do
        local attrDesc = attrUtil.GetAttrStr(attrs[i]).FullValue
        table.insert(ret, attrDesc)
    end

    return ret
end

function RefineTransferItemTemplate:OnPressDown()
    -- do nothing
end

--lua custom scripts end
return RefineTransferItemTemplate