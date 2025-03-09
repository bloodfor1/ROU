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
---@class DisplacerEquipItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field RefineLv MoonClient.MLuaUICom
---@field Rare MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemHole MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field IsUsedDisplacer MoonClient.MLuaUICom
---@field IsEquiped MoonClient.MLuaUICom
---@field ImgHole4 MoonClient.MLuaUICom
---@field ImgHole3 MoonClient.MLuaUICom
---@field ImgHole2 MoonClient.MLuaUICom
---@field ImgHole1 MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom

---@class DisplacerEquipItemTemplate : BaseUITemplate
---@field Parameter DisplacerEquipItemTemplateParameter

DisplacerEquipItemTemplate = class("DisplacerEquipItemTemplate", super)
--lua class define end

--lua functions
function DisplacerEquipItemTemplate:Init()
    super.Init(self)


end --func end
--next--
function DisplacerEquipItemTemplate:OnDeActive()

end --func end
--next--
---@param displacerData DisplacerData
function DisplacerEquipItemTemplate:OnSetData(displacerData)
    self.data = displacerData
    local l_itemInfo = displacerData.Item.ItemConfig
    local l_ReplaceAttrs = displacerData.Item.AttrSet[GameEnum.EItemAttrModuleType.Device]
    self.data.isUsedDisplacer = l_ReplaceAttrs ~= nil and #l_ReplaceAttrs > 0 and #l_ReplaceAttrs[1] > 0
    self.Parameter.EquipIcon:SetSprite(displacerData.Item.ItemConfig.ItemAtlas, displacerData.Item.ItemConfig.ItemIcon, true)
    self.Parameter.IsUsedDisplacer.UObj:SetActiveEx(self.data.isUsedDisplacer)
    self.Parameter.IsEquiped.UObj:SetActiveEx(displacerData.isEquiped)
    local l_name = l_itemInfo.ItemName
    self.Parameter.RefineLv.gameObject:SetActiveEx(false)
    self.Parameter.Damage.gameObject:SetActiveEx(false)
    self.Parameter.Rare.gameObject:SetActiveEx(false)
    local l_holeList = {}
    for i = 1, 4 do
        l_holeList[i] = self.Parameter.ItemHole.transform:Find("ImgHole" .. i):GetComponent("MLuaUICom")
        l_holeList[i].gameObject:SetActiveEx(false)
    end

    --精炼等级
    if displacerData.Item.RefineLv > 0 then
        l_name = StringEx.Format("+{0}" .. l_name, displacerData.Item.RefineLv)
        self.Parameter.RefineLv.gameObject:SetActiveEx(true)
        self.Parameter.RefineLv.LabText = StringEx.Format("+{0}", displacerData.Item.RefineLv)
    end

    --洞
    if l_itemInfo.TypeTab == 1 then
        MgrMgr:GetMgr("EquipMgr").SetEquipIconHole(displacerData.Item, l_holeList)
    end

    if displacerData.Item.Damaged then
        --损坏
        self.Parameter.Damage.gameObject:SetActiveEx(true)
        self.Parameter.Damage:SetSprite("Common", "UI_Common_IconPosun.png")
        self.Parameter.Rare.gameObject:SetActiveEx(false)
    elseif displacerData.Item.RefineSealLv > 0 then
        --封印
        self.Parameter.Damage.gameObject:SetActiveEx(true)
        self.Parameter.Damage:SetSprite("Common", "UI_Common_IconSeal.png")
        self.Parameter.Rare.gameObject:SetActiveEx(false)
    else
        self.Parameter.Damage.gameObject:SetActiveEx(false)
        self.Parameter.Rare.gameObject:SetActiveEx(MgrMgr:GetMgr("EquipMgr").IsRaity(displacerData.Item))
    end
    self.Parameter.Name.LabText = l_name
    self.Parameter.ItemButton:AddClick(function()
        self:MethodCallback(self)
    end)
    self.Parameter.EquipIconBg:AddClick(function()
        if nil == self.data then
            return
        end

        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(self.data.Item, self:transform(), Data.BagModel.WeaponStatus.NORMAL_PROP, nil, false, nil)
    end)
end --func end
--next--
function DisplacerEquipItemTemplate:OnDestroy()


end --func end
--next--
function DisplacerEquipItemTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function DisplacerEquipItemTemplate:SetSelect(isSelected)
    self.Parameter.Selected.UObj:SetActiveEx(isSelected)
end
--lua custom scripts end
return DisplacerEquipItemTemplate