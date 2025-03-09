--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "Data.Model.BagModel"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class AutoBattleDargItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemTemp MoonClient.MLuaUICom
---@field DragName MoonClient.MLuaUICom
---@field DragDescription MoonClient.MLuaUICom
---@field BtnString MoonClient.MLuaUICom
---@field BtnAddOrRemove MoonClient.MLuaUICom

---@class AutoBattleDargItemTemplate : BaseUITemplate
---@field Parameter AutoBattleDargItemTemplateParameter

AutoBattleDargItemTemplate = class("AutoBattleDargItemTemplate", super)
--lua class define end

--lua functions
function AutoBattleDargItemTemplate:Init()
    super.Init(self)
end --func end
--next--
function AutoBattleDargItemTemplate:OnDestroy()
    self.itemTemplate = nil
end --func end
--next--
function AutoBattleDargItemTemplate:OnSetData(data)
    self.itemId = data.itemId
    self.isSelected = data.isSelected
    self.parent = data.parent
    self.onSelect = data.onSelect
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(self.itemId)
    local l_descRow = TableUtil.GetChooseDescTable().GetRowByItemId(self.itemId)
    local l_itemCount = Data.BagModel:GetCoinOrPropNumById(self.itemId)
    local l_showCount = l_itemCount > 0
    local l_iconCallback

    l_iconCallback = function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.itemId)
    end
    if l_descRow == nil then
        logError("未能在ChooseDesc中找到itemid:" .. tostring(self.itemId))
    end
    self.Parameter.DragName.LabText = l_itemRow.ItemName
    self.Parameter.DragDescription.LabText = l_descRow.Desc
    self.itemTemplate = self:NewTemplate("ItemTemplate", {
        TemplateParent = self.Parameter.ItemTemp.transform,
        Data = {
            ID = self.itemId,
            Count = l_itemCount,
            IsShowCount = l_showCount,
            IsGray = not l_showCount,
            ButtonMethod = l_iconCallback,
        }
    })
    self.itemTemplate:gameObject():SetLocalScaleOne()
    self.itemTemplate:gameObject():SetLocalPosZero()
    if not self.isSelected and l_itemCount > 0 then
        self.Parameter.BtnString.LabText = Common.Utils.Lang("PUTIN")
        self.Parameter.BtnAddOrRemove:AddClick(function()
            if self.onSelect ~= nil then
                self.onSelect(self.itemId)
            end
            self.parent:CloseSelectItem()
        end)
    else
        self.Parameter.BtnString.LabText = Common.Utils.Lang("GET")
        self.Parameter.BtnAddOrRemove:AddClick(function()
            self:ShowItemAchieveWithId(self.itemId)
        end)
    end

end --func end
--next--
function AutoBattleDargItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function AutoBattleDargItemTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function AutoBattleDargItemTemplate:ShowItemAchieveWithId(itemId)
    self.parent.panel.SelectDragItemScrollView.RectTransform.anchoredPosition = Vector2.New(-self.parent.panel.SelectDragItemScrollView.RectTransform.rect.width / 2, 0)
    MgrMgr:GetMgr("ItemTipsMgr").ShowItemAchieveWithId(itemId,self.parent.panel.SelectDragItemScrollView.RectTransform)
end
--lua custom scripts end
return AutoBattleDargItemTemplate