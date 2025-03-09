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
---@class ItemDestroyEquipPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field DestroyFlag MoonClient.MLuaUICom
---@field GrayMask MoonClient.MLuaUICom
---@field DestroyImage MoonClient.MLuaUICom
---@field ImgCD MoonClient.MLuaUICom

---@class ItemDestroyEquipPartTemplate : BaseUITemplate
---@field Parameter ItemDestroyEquipPartTemplateParameter

ItemDestroyEquipPartTemplate = class("ItemDestroyEquipPartTemplate", super)
--lua class define end

--lua functions
function ItemDestroyEquipPartTemplate:Init()
    super.Init(self)
end --func end
--next--
function ItemDestroyEquipPartTemplate:OnDestroy()


end --func end
--next--
function ItemDestroyEquipPartTemplate:OnDeActive()


end --func end
--next--
function ItemDestroyEquipPartTemplate:OnSetData(data)
    local l_mgr = MgrMgr:GetMgr("SkillDestroyEquipMgr")
    local l_isDestroy = l_mgr.IsDestroyWithPropInfo(data)
    self.Parameter.DestroyFlag:SetActiveEx(l_isDestroy)
    self.Parameter.ImgCD:SetActiveEx(l_isDestroy)
    if l_isDestroy then
        local l_serverEnum = MgrMgr:GetMgr("BodyEquipMgr").GetEquipServerEnumWithPropInfo(data)
        local l_totalTime = l_mgr.GetTotalTimeWithServerEnum(l_serverEnum)
        local l_currentTime = l_mgr.GetCurrentTimeWithServerEnum(l_serverEnum)
        local l_imageName = l_mgr.GetDestroyImageNameWithServerEnum(l_serverEnum)
        self.Parameter.DestroyImage:SetSpriteAsync("CommonIcon", l_imageName)
        self.Parameter.ImgCD.GradualChange:SetData(l_currentTime)
        self.Parameter.ImgCD.GradualChange:SetTotalValue(l_totalTime)
        self.Parameter.ImgCD.GradualChange:SetMethod(nil, function()
            self.Parameter.DestroyFlag:SetActiveEx(false)
            self.Parameter.ImgCD:SetActiveEx(false)
        end)
    end
end --func end

--next--
--lua functions end

--lua custom scripts
ItemDestroyEquipPartTemplate.TemplatePath = "UI/Prefabs/ItemPart/ItemDestroyEquipPartPrefab"
--lua custom scripts end
return ItemDestroyEquipPartTemplate