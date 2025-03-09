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
---@type AttrDescUtil
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
--lua fields end

--lua class define
---@class DisplacerSelectItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom

---@class DisplacerSelectItemTemplate : BaseUITemplate
---@field Parameter DisplacerSelectItemTemplateParameter

DisplacerSelectItemTemplate = class("DisplacerSelectItemTemplate", super)
--lua class define end

--lua functions
function DisplacerSelectItemTemplate:Init()
    super.Init(self)


end --func end
--next--
function DisplacerSelectItemTemplate:OnDeActive()


end --func end
--next--
---@param itemData ItemData
function DisplacerSelectItemTemplate:OnSetData(itemData)
    self.data = itemData
    self.Parameter.IconImg:SetSprite(itemData.ItemConfig.ItemAtlas, itemData.ItemConfig.ItemIcon)
    self.Parameter.Name.LabText = itemData.ItemConfig.ItemName
    local displacerData = itemData.AttrSet[GameEnum.EItemAttrModuleType.Device]
    local text = nil
    if nil ~= displacerData and 0 < #displacerData and 0 < #displacerData[1] then
        text = attrUtil.GetAttrStr(displacerData[1][1]).Desc
    end

    self.Parameter.Effect.LabText = text

    --点击事件
    self.Parameter.BtnSelect:AddClick(function()
        self:MethodCallback(self)
    end)

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return DisplacerSelectItemTemplate