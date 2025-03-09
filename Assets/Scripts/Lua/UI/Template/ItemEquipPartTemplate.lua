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
local C_COMMON_ATLAS_NAME = "Common"
local C_HOLE_SEALED_SP_NAME = "UI_Common_Icon_Kacao03.png"
local C_HOLE_EMPTY_SP_NAME = "UI_Common_Icon_Kacao02.png"
local C_HOLE_FILLED_SP_NAME = "UI_Common_Icon_Kacao01.png"
local itemAttrModuleType = GameEnum.EItemAttrModuleType
--lua fields end

--lua class define
---@class ItemEquipPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RefineLv MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom
---@field ItemHole MoonClient.MLuaUICom
---@field ImgHole1 MoonClient.MLuaUICom
---@field ImgHole2 MoonClient.MLuaUICom
---@field ImgHole3 MoonClient.MLuaUICom
---@field ImgHole4 MoonClient.MLuaUICom
---@field Unidentified MoonClient.MLuaUICom
---@field Rare MoonClient.MLuaUICom

---@class ItemEquipPartTemplate : BaseUITemplate
---@field Parameter ItemEquipPartTemplateParameter

ItemEquipPartTemplate = class("ItemEquipPartTemplate", super)
--lua class define end

--lua functions
function ItemEquipPartTemplate:Init()
    super.Init(self)
    self.propInfo = nil
    self.Parameter.Unidentified:SetActiveEx(false)

end --func end
--next--
function ItemEquipPartTemplate:OnDeActive()
    self.Parameter.RefineLv:SetActiveEx(false)
    self.Parameter.Damage:SetActiveEx(false)
    self.Parameter.ItemHole:SetActiveEx(false)
    self.Parameter.Rare:SetActiveEx(false)
end --func end
--next--
---@param data ItemTemplateParam
function ItemEquipPartTemplate:OnSetData(data)
    self.propInfo = data.PropInfo
    local isRare = self.propInfo:IsEquipRareStyle()
    self.Parameter.Rare.gameObject:SetActiveEx(isRare)
    self.Parameter.RefineLv:SetActiveEx(false)
    self.Parameter.Damage:SetActiveEx(false)
    self.Parameter.ItemHole:SetActiveEx(false)

    local l_holeList = {}
    for i = 1, 4 do
        l_holeList[i] = self.Parameter.ItemHole.transform:Find("ImgHole" .. i):GetComponent("MLuaUICom")
        l_holeList[i].gameObject:SetActiveEx(false)
    end
    self.Parameter.ItemHole:SetActiveEx(true)

    --是装备显示其他属性
    local itemTableInfo = self.propInfo.ItemConfig
    local SelectEquipMgr = MgrMgr:GetMgr("SelectEquipMgr")
    if itemTableInfo.TypeTab == 1 and nil ~= self.propInfo.EquipConfig then
        if SelectEquipMgr.g_equipSystem ~= SelectEquipMgr.EquipSystem.Refine and
                SelectEquipMgr.g_equipSystem ~= SelectEquipMgr.EquipSystem.Enchant then
            if self.propInfo.Damaged then
                self.Parameter.Damage:SetSprite("Common", "UI_Common_IconPosun.png")
                self.Parameter.Damage.gameObject:SetActiveEx(true)
            elseif self.propInfo.RefineSealLv > 0 then
                self.Parameter.Damage:SetSprite("Common", "UI_Common_IconSeal.png")
                self.Parameter.Damage.gameObject:SetActiveEx(true)
            else
                self.Parameter.Damage.gameObject:SetActiveEx(false)
            end
        end

        --精炼等级
        if self.propInfo.RefineLv > 0 then
            self.Parameter.RefineLv.gameObject:SetActiveEx(true)
            self.Parameter.RefineLv.LabText = StringEx.Format("+{0}", self.propInfo.RefineLv)
        end

        --- 道具是没有这个属性的
        local holeAttrMap = nil
        if nil ~= self.propInfo.AttrSet[itemAttrModuleType.Hole] then
            holeAttrMap = table.ro_reverse(self.propInfo.AttrSet[itemAttrModuleType.Hole])
        end

        local itemCardAttrMap = nil
        if nil ~= self.propInfo.AttrSet[itemAttrModuleType.Card] then
            itemCardAttrMap = table.ro_reverse(self.propInfo.AttrSet[itemAttrModuleType.Card])
        end

        if nil ~= holeAttrMap then
            for i = 1, #holeAttrMap do
                l_holeList[i].gameObject:SetActiveEx(true)
                if 0 == #holeAttrMap[i] then
                    l_holeList[i]:SetSprite(C_COMMON_ATLAS_NAME, C_HOLE_SEALED_SP_NAME)
                elseif 0 < #itemCardAttrMap[i] then
                    l_holeList[i]:SetSprite(C_COMMON_ATLAS_NAME, C_HOLE_FILLED_SP_NAME)
                else
                    l_holeList[i]:SetSprite(C_COMMON_ATLAS_NAME, C_HOLE_EMPTY_SP_NAME)
                end
            end
        end
    end
end --func end

--next--
--lua functions end

--lua custom scripts

ItemEquipPartTemplate.TemplatePath = "UI/Prefabs/ItemPart/ItemEquipPart"
function ItemEquipPartTemplate:ctor(param)
    param = param or {}
    super.ctor(self, param)
end
--lua custom scripts end

return ItemEquipPartTemplate