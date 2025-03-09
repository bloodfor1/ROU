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
---@class CardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Use MoonClient.MLuaUICom
---@field NameBG MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IsCard MoonClient.MLuaUICom
---@field InfoUI MoonClient.MLuaUICom
---@field InforBG MoonClient.MLuaUICom
---@field img_recommendw MoonClient.MLuaUICom
---@field HideInforButton MoonClient.MLuaUICom
---@field CardName MoonClient.MLuaUICom
---@field CardImg MoonClient.MLuaUICom
---@field CardImageBtn MoonClient.MLuaUICom
---@field BindPanel MoonClient.MLuaUICom
---@field BigBG MoonClient.MLuaUICom
---@field BaiTiao MoonClient.MLuaUICom
---@field Attr MoonClient.MLuaUICom

---@class CardTemplate : BaseUITemplate
---@field Parameter CardTemplateParameter

CardTemplate = class("CardTemplate", super)
--lua class define end

--lua functions
function CardTemplate:Init()
    super.Init(self)

    self.attrMgr = MgrMgr:GetMgr("AttrDescUtil")

    self.Parameter.CardEffect:SetActiveEx(false)
    self.data = nil
    self.additionalShowText=nil
    self.attrItems = {}
    self.Parameter.HideInforButton:AddClickWithLuaSelf(self._hideCardInfo,self)
    self.Parameter.CardImg:AddClickWithLuaSelf(self._showCardInfo,self)

end --func end
--next--
function CardTemplate:OnDestroy()
    for i = 1, #self.attrItems do
        MResLoader:DestroyObj(self.attrItems[i].gameObject)
    end

    self.Parameter.CardEffect:StopDynamicEffect()
    self.Parameter.CardEffect.RawImg.texture=nil
    self.Parameter.CardEffect.RawImg.material=nil
    self.attrItems = nil
    self.data = nil

    self:transform().anchorMax = Vector2(0.5, 0.5)
    self:transform().anchorMin = Vector2(0.5, 0.5)
    self:transform().anchoredPosition = Vector2.zero

end --func end
--next--
function CardTemplate:OnSetData(data,additional)
    self:ShowCardTemplate(data,additional)
end --func end
--next--
function CardTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function CardTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
CardTemplate.TemplatePath = "UI/Prefabs/CardPrefab"
function CardTemplate:ShowCardTemplate(data,additional)
    self.data = data
    self.additionalShowText=additional.ShowUseTimeText
    local cardId=0
    if data.ItemData then
        cardId=data.ItemData.TID
    end

    self.Parameter.IsCard.gameObject:SetActiveEx(cardId > 0)
    local isBind=false
    if data.IsBind then
        isBind=true
    end
    self.Parameter.BindPanel.gameObject:SetActiveEx(isBind)
    if cardId <= 0 then
        return
    end

    for i = 1, #self.attrItems do
        self.attrItems[i].gameObject:SetActiveEx(false)
    end

    local l_bgAtlas, l_bgIcon = Data.BagModel:getCardTextureBgInfo(cardId)
    self.Parameter.CardImageBtn:SetSprite(l_bgAtlas, l_bgIcon)

    local attrs = data.ItemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Base)
    for i = 1, #attrs do
        if self.attrItems[i] == nil then
            self.attrItems[i] = MResLoader:CloneObj(self.Parameter.Attr.gameObject, false)
        end

        self.attrItems[i].gameObject:SetActiveEx(true)
        local l_text = self.attrItems[i]:GetComponent("MLuaUICom")
        l_text.transform:SetParent(self.Parameter.Attr.transform.parent)
        l_text.transform:SetLocalScaleOne()
        local attr = self.attrMgr.GetAttrStr(attrs[i])
        l_text.LabText = attr.Desc
        Common.CommonUIFunc.CalculateLowLevelTipsInfo(l_text, nil, Vector2.New(0.5, 0.5))
    end

    local l_c1, l_c2 = Data.BagModel:getCardTextureBgColor(cardId)
    self.Parameter.CardImageBtn.Img.color = l_c1
    self.Parameter.NameBG.Img.color = l_c2

    local cardTableData = TableUtil.GetEquipCardTable().GetRowByID(cardId)

    if cardTableData then
        self.Parameter.CardImg:SetRawTex(cardTableData.CardTexture)
        self.Parameter.Name.LabText = cardTableData.CardName
        local cardNameText=data.ItemData:GetName()
        if data.Count then
            cardNameText=cardNameText.. "X" .. tostring(data.Count)
        end
        self.Parameter.CardName.LabText = cardNameText
    end

    self.Parameter.InfoUI.gameObject:SetActiveEx(false)

    if data.ItemData:GetExistTime()>0 or additional.IsShowEffect then
        self.Parameter.CardEffectContainer:SetActiveEx(true)
        if additional.EffectTexture then
            self.Parameter.CardEffect:SetActiveEx(true)
            self.Parameter.CardEffect.RawImg.texture=additional.EffectTexture
            self.Parameter.CardEffect.RawImg.material=additional.EffectTextureMaterial
        else
            self.Parameter.CardEffect:PlayDynamicEffect()
        end
    else
        self.Parameter.CardEffect:SetActiveEx(false)
        self.Parameter.CardEffect:StopDynamicEffect()
    end

    if additional.IsShowCardInfo then
        self:_showCardInfo()
    end

end

function CardTemplate:ShowCardInfo()
    self:_showCardInfo()
end
function CardTemplate:HideCardInfo()
    self:_hideCardInfo()
end

function CardTemplate:_showCardInfo()
    if self.data == nil then
        return
    end
    if self.data.ItemData == nil then
        return
    end
    if self.data.ItemData.TID <= 0 then
        return
    end
    self:_showCanUsePosition()
    self:_showAdditionalText()
    --查看属性
    self.Parameter.InfoUI:SetActiveEx(true)
    self.Parameter.CardEffectContainer:SetActiveEx(false)
end

function CardTemplate:_hideCardInfo()
    self.Parameter.InfoUI:SetActiveEx(false)
    self.Parameter.CardEffectContainer:SetActiveEx(true)
end

function CardTemplate:_showAdditionalText()
    if self.additionalShowText == nil then
        self.Parameter.AdditionalShowGameObject:SetActiveEx(false)
        return
    end
    self.Parameter.AdditionalShowGameObject:SetActiveEx(true)
    self.Parameter.AdditionalShowText.LabText = self.additionalShowText
end

function CardTemplate:_showCanUsePosition()
    local cardCfg = TableUtil.GetEquipCardTable().GetRowByID(self.data.ItemData.TID)
    local positionNameEnum = MgrMgr:GetMgr("EquipMgr").eEquipTypeName
    local des = ""
    for i = 0,cardCfg.CanUsePosition.Length - 1 do
        des = des.. positionNameEnum[cardCfg.CanUsePosition[i]]
    end
    self.Parameter.CanUsePosition.LabText =Common.Utils.Lang("Card_Position",des)
end


--lua custom scripts end
return CardTemplate