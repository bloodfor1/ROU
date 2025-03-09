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
---@class EquipCardPropertyTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectItemButton MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field HoleBG MoonClient.MLuaUICom
---@field CardText MoonClient.MLuaUICom
---@field CardImage MoonClient.MLuaUICom
---@field CardEmpty MoonClient.MLuaUICom
---@field CardClose MoonClient.MLuaUICom
---@field CardBG MoonClient.MLuaUICom
---@field Card MoonClient.MLuaUICom
---@field AddCard MoonClient.MLuaUICom

---@class EquipCardPropertyTemplate : BaseUITemplate
---@field Parameter EquipCardPropertyTemplateParameter

EquipCardPropertyTemplate = class("EquipCardPropertyTemplate", super)
--lua class define end

--lua functions
function EquipCardPropertyTemplate:Init()

    super.Init(self)
    self.countDownPart = nil

end --func end
--next--
function EquipCardPropertyTemplate:OnDeActive()

    self.data = nil

end --func end
--next--
function EquipCardPropertyTemplate:OnSetData(data)

    self:ShowPropertyInfo(data)

end --func end
--next--
function EquipCardPropertyTemplate:OnDestroy()
    self.countDownPart = nil
    -- do nothing

end --func end
--next--
function EquipCardPropertyTemplate:BindEvents()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
---@param data CardHoleConfig
function EquipCardPropertyTemplate:ShowPropertyInfo(data)
    self.Parameter.Select.gameObject:SetActiveEx(false)
    self.data = data
    --点击属性区域
    self.Parameter.HoleBG:AddClick(function()
        MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EquipCardPropertyClick, self)
    end)
    self.Parameter.AddCard:AddClick(function()
        MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EquipCardPropertyClick, self)
    end)
    self.Parameter.SelectItemButton:AddClick(function()
        MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EquipCardPropertyClick, self)
    end)

    self.Parameter.CardImage:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.cardID, self.Parameter.CardImage.transform)
    end)

    self.Parameter.CardClose.gameObject:SetActiveEx(data.isOpenHole == 0 and data.attr == nil)
    self.Parameter.CardEmpty.gameObject:SetActiveEx(data.cardID == 0 and data.isOpenHole == 1)
    self.Parameter.Card.gameObject:SetActiveEx(data.cardID > 0)
    self.Parameter.CardText.LabColor = Color.New(89 / 255, 135 / 255, 229 / 255, 1)
    self.Parameter.HoleBG.Img.color = Color.New(1, 1, 1, 1)
    if self.countDownPart then
        self:UninitTemplate(self.countDownPart)
        self.countDownPart = nil
    end
    --未打洞
    if data.isOpenHole == 0 and data.attr == nil then
        self.Parameter.CardText.LabColor = Color.New(120 / 255, 125 / 255, 177 / 255, 1)
        self.Parameter.HoleBG.Img.color = Color.New(212 / 255, 215 / 255, 223 / 255, 68 / 255)
        l_curText = Common.Utils.Lang("EQUIP_HOLE_CLOSE")
        --未插卡的
    elseif data.cardID == 0 and data.isOpenHole == 1 then
        self.Parameter.CardText.LabColor = Color.New(120 / 255, 125 / 255, 177 / 255, 1)
        self.Parameter.HoleBG.Img.color = Color.New(1, 1, 1, 120 / 255)
        l_curText = self:_getAttrStr(data.attr)

        --已插卡的
    elseif data.cardID > 0 then
        local itemData = Data.BagApi:CreateLocalItemData(data.cardID)
        if itemData:GetExistTime() > 0 then
            local countdownPartData={ Data = itemData, TemplateParent = self.Parameter.ItemCountdownPartParent.transform }
            self.countDownPart = self:NewTemplate("ItemCountdownPartTemplate", countdownPartData)
        end

        local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(data.cardID)
        local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(data.cardID)
        l_curText = l_cardInfo.CardName
        self.Parameter.CardImage:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon)
        local l_bgAtlas, l_bgIcon = Data.BagModel:getCardBgInfo(data.cardID)
        self.Parameter.CardBG:SetSprite(l_bgAtlas, l_bgIcon)
        local l_atlas, l_sprite = Data.BagModel:getCardPosInfo(data.cardID)
        self.Parameter.Icon:SetSprite(l_atlas, l_sprite, true)
    end

    self.Parameter.CardText.LabText = l_curText
end

---@param itemAttrDataList ItemAttrData[]
function EquipCardPropertyTemplate:_getAttrStr(itemAttrDataList)
    if nil == itemAttrDataList then
        return "[EquipCardPropertyTemplate] attrs got nil"
    end

    local ret = ""
    for i = 1, #itemAttrDataList do
        local singleAttr = itemAttrDataList[i]
        local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(singleAttr.TableID)
        if nil ~= l_holeTableInfo then
            local colorTag = RoQuality.GetColorTag(l_holeTableInfo.Quality)
            ret = ret .. attrUtil.GetAttrStr(singleAttr, colorTag).FullValue .. ";"
        else
            logError("[Card] invalid attr table ID: " .. tostring(singleAttr.TableID))
        end
    end

    return ret
end

function EquipCardPropertyTemplate:OnSelect()
    self.Parameter.Select:SetActiveEx(true)
end

function EquipCardPropertyTemplate:OnDeselect()
    self.Parameter.Select:SetActiveEx(false)
end
--lua custom scripts end
return EquipCardPropertyTemplate