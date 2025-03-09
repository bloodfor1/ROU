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
---@class FishPropItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field IsUsing MoonClient.MLuaUICom
---@field IsSeclect MoonClient.MLuaUICom

---@class FishPropItemTemplate : BaseUITemplate
---@field Parameter FishPropItemTemplateParameter

FishPropItemTemplate = class("FishPropItemTemplate", super)
--lua class define end

--lua functions
function FishPropItemTemplate:Init()
    super.Init(self)


end --func end
--next--
function FishPropItemTemplate:OnDeActive()
end --func end
--next--
---@param data FishItemData
function FishPropItemTemplate:OnSetData(data)
    if data == nil then
        self.Parameter.ItemIcon.UObj:SetActiveEx(false)
        self.Parameter.ItemCount.UObj:SetActiveEx(false)
        self.Parameter.IsUsing.UObj:SetActiveEx(false)
    else
        self.Parameter.ItemIcon:SetSprite(data.itemData.ItemConfig.ItemAtlas, data.itemData.ItemConfig.ItemIcon)
        self.Parameter.ItemCount.LabText = tostring(data.itemData.ItemCount)
        self.Parameter.IsUsing.UObj:SetActiveEx(data.isUse)
    end

    --点击事件绑定
    self.Parameter.Prefab:AddClick(function()
        if nil ~= data and data.itemData ~= nil then
            --展示tip
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(data.itemData, self:transform(), Data.BagModel.WeaponStatus.FISH_PROP)
            --选中效果
            self:MethodCallback(self)
        end
    end)

end --func end

--next--
--lua functions end

--lua custom scripts
--设置被选中框是否显示
function FishPropItemTemplate:SetSelect(isSelected)
    self.Parameter.IsSeclect.UObj:SetActiveEx(isSelected)
end
--lua custom scripts end
return FishPropItemTemplate