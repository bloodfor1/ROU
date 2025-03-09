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
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
--lua fields end

--lua class define
---@class EquipMakeHoleRecastTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropertyOpenText MoonClient.MLuaUICom
---@field PropertyOpen MoonClient.MLuaUICom
---@field NoProperty MoonClient.MLuaUICom
---@field HolePropertyText MoonClient.MLuaUICom
---@field HaveProperty MoonClient.MLuaUICom
---@field EffectMakeHole MoonClient.MLuaUICom
---@field CardPropertyPanel MoonClient.MLuaUICom
---@field CardProperty MoonClient.MLuaUICom
---@field CardName MoonClient.MLuaUICom
---@field CardIcon MoonClient.MLuaUICom
---@field CardBg MoonClient.MLuaUICom

---@class EquipMakeHoleRecastTemplate : BaseUITemplate
---@field Parameter EquipMakeHoleRecastTemplateParameter

EquipMakeHoleRecastTemplate = class("EquipMakeHoleRecastTemplate", super)
--lua class define end

--lua functions
function EquipMakeHoleRecastTemplate:Init()
    super.Init(self)

    self._fxId1 = 0
    self.Parameter.EffectMakeHole:SetActiveEx(false)
    self._cardItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.Parameter.CardIcon.transform })

end --func end
--next--
function EquipMakeHoleRecastTemplate:OnDestroy()
    self._cardItem = nil
end --func end
--next--
function EquipMakeHoleRecastTemplate:OnDeActive()

end --func end
--next--
function EquipMakeHoleRecastTemplate:OnSetData(data, isShowEffect)
    self.Parameter.HaveProperty:SetActiveEx(false)
    self.Parameter.NoProperty:SetActiveEx(false)
    self.Parameter.CardIcon:SetActiveEx(false)
    self.Parameter.CardPropertyPanel:SetActiveEx(false)
    self.Parameter.CardBg:SetActiveEx(true)

    if data.CardId then
        self.Parameter.CardIcon:SetActiveEx(true)
        self.Parameter.CardBg:SetActiveEx(false)
        self._cardItem:SetData({ ID = data.CardId, IsShowCount = false })
        local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(data.CardId)
        self.Parameter.CardName.LabText = l_itemTableInfo.ItemName
        self.Parameter.CardPropertyPanel:SetActiveEx(true)
        local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(data.CardId)
        local l_attrs = {}

        --有卡片显示卡片属性
        for i = 0, l_cardInfo.CardAttributes.Length - 1 do
            local l_attr = {}
            l_attr.type = l_cardInfo.CardAttributes[i][0]
            l_attr.id = l_cardInfo.CardAttributes[i][1]
            l_attr.val = l_cardInfo.CardAttributes[i][2]
            table.insert(l_attrs, l_attr)
        end

        local l_attrText = MgrMgr:GetMgr("EquipMgr").GetAllAttrText(l_attrs, RoColorTag.None)
        self.Parameter.CardProperty.LabText = l_attrText
    else
        if data.TableId == 0 then
            self.Parameter.NoProperty:SetActiveEx(true)
        else
            self.Parameter.HaveProperty:SetActiveEx(true)
            self.Parameter.HolePropertyText.LabText = self:_getAttrStr(data.Entry)
            local l_openText = MgrMgr:GetMgr("EquipMakeHoleMgr").GetHoleOpenText(data.TableId)
            if l_openText == nil then
                self.Parameter.PropertyOpen:SetActiveEx(false)
            else
                self.Parameter.PropertyOpen:SetActiveEx(true)
                self.Parameter.PropertyOpenText.LabText = l_openText
            end
        end
    end

    if isShowEffect then
        self:_showFx()
    end
end --func end
--next--
function EquipMakeHoleRecastTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
---@param itemAttrDataList ItemAttrData[]
function EquipMakeHoleRecastTemplate:_getAttrStr(itemAttrDataList)
    if nil == itemAttrDataList then
        return "[MakeHoleTemp] attrs got nil"
    end

    local ret = ""
    for i = 1, #itemAttrDataList do
        local singleAttr = itemAttrDataList[i]
        local colorTag = nil
        if nil == singleAttr.TableID then
            ret = ret .. attrUtil.GetAttrStr(singleAttr, colorTag).FullValue .. ";"
        else
            local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(singleAttr.TableID)
            colorTag = RoQuality.GetColorTag(l_holeTableInfo.Quality)
            ret = ret .. attrUtil.GetAttrStr(singleAttr, colorTag).FullValue .. ";"
        end
    end

    return ret
end

function EquipMakeHoleRecastTemplate:_showFx()
    if self._fxId1 > 0 then
        self:DestroyUIEffect(self._fxId1)
    end

    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.EffectMakeHole.RawImg
    l_fxData.destroyHandler = function()
        self._fxId1 = 0
    end

    l_fxData.scaleFac = Vector3.New(3.268603, 2.829261, 3.2686)
    self._fxId1 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ChongZhu_01", l_fxData)
    
end
--lua custom scripts end
return EquipMakeHoleRecastTemplate