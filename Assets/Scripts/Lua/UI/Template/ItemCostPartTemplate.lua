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
---@class ItemCostPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemNumber MoonClient.MLuaUICom

---@class ItemCostPartTemplate : BaseUITemplate
---@field Parameter ItemCostPartTemplateParameter

ItemCostPartTemplate = class("ItemCostPartTemplate", super)
--lua class define end

--lua functions
function ItemCostPartTemplate:Init()
    super.Init(self)

    self.propInfo = nil
    self.isShowRequire = false
    self.requireCount = 0
end --func end
--next--
function ItemCostPartTemplate:OnDeActive()
    self.Parameter.ItemNumber:SetActiveEx(false)
end --func end
--next--
---@param data ItemTemplateParam
function ItemCostPartTemplate:OnSetData(data)
    self.Parameter.ItemNumber:SetActiveEx(false)
    self.propInfo = data.PropInfo
    self.isShowRequire = data.IsShowRequire
    self.requireCount = data.RequireCount
    self.Parameter.ItemNumber.gameObject:SetActiveEx(self.isShowRequire)
    if self.isShowRequire then
        local currentCount = 0
        if data.Count~=nil then
            currentCount = data.Count
        elseif data.RequireMaxCount then
            currentCount = data.RequireMaxCount
        else
            currentCount = Data.BagModel:GetCoinOrPropNumById(self.propInfo.TID)
        end

        --- 道具本身判断是不是货币的逻辑和这个不一样，娃娃和标本算道具；这个接口是用来判断是否是流通货币的
        if MgrMgr:GetMgr("PropMgr").IsCoin(self.propInfo.TID) then
            self.Parameter.ItemNumber.LabText = MNumberFormat.GetNumberFormat(tostring(self.requireCount))
        else
            self.Parameter.ItemNumber.LabText = tostring(currentCount) .. "/" .. tostring(self.requireCount)
        end

        if currentCount >= self.requireCount then
            self.Parameter.ItemNumber.LabColor = UIDefineColor.ItemCountColor
        else
            self.Parameter.ItemNumber.LabColor = UIDefineColor.WaringColor
        end
    end
end --func end

--next--
--lua functions end

--lua custom scripts
ItemCostPartTemplate.TemplatePath = "UI/Prefabs/ItemPart/ItemCostPart"
function ItemCostPartTemplate:ctor(itemData)
    itemData = itemData or {}
    super.ctor(self, itemData)
end

--lua custom scripts end

return ItemCostPartTemplate