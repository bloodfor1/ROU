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
local Mgr = MgrProxy:GetGarderobeMgr()
local ornamentScale = 0.5
local eyeScale = 0.8
local hairScele = 0.8
local normal = 1.0
local itemIconBgNormal = "UI_Garderobe_IconBG.png"
local FindObjectInChild = function(...)
    return MoonCommonLib.GameObjectEx.FindObjectInChild(...)
end
--lua fields end

--lua class define
---@class GardrobeCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgMask MoonClient.MLuaUICom
---@field ImgBoard MoonClient.MLuaUICom
---@field IconTryon MoonClient.MLuaUICom
---@field IconTrial MoonClient.MLuaUICom
---@field IconSelected MoonClient.MLuaUICom
---@field IconSave MoonClient.MLuaUICom
---@field IconContentFashion MoonClient.MLuaUICom
---@field IconContent MoonClient.MLuaUICom
---@field GardrobeCellBtn MoonClient.MLuaUICom

---@class GardrobeCellTemplate : BaseUITemplate
---@field Parameter GardrobeCellTemplateParameter

GardrobeCellTemplate = class("GardrobeCellTemplate", super)
--lua class define end

--lua functions
function GardrobeCellTemplate:Init()
	
	    super.Init(self)
	    self:Bind()
	
end --func end
--next--
function GardrobeCellTemplate:OnDestroy()
	
	    self.cellData = nil
	
end --func end
--next--
function GardrobeCellTemplate:OnSetData(data)
	
	    if data ~= nil then
	        self.cellData = data
	        self:RefreshCell()
	    end
	
end --func end
--next--
function GardrobeCellTemplate:OnDeActive()
	
end --func end
--next--
function GardrobeCellTemplate:BindEvents()
	
	    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_WEAR_ORNAMENT, self.OnWearOrnamentOrFashion, self)
	    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_WEAR_FASHION, self.OnWearOrnamentOrFashion, self)
	    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_ADD_ITEM, self.OnAddItem, self)
	    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_ITEM_CLICK, self.RefreshFrame, self)
	    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_STORE_ADD, self.RefreshCell, self)
        self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_STORE_REMOVE, self.RefreshCell, self)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GardrobeCellTemplate:OnActive()
    -- do nothing
end

function GardrobeCellTemplate:OnAddItem(itemId)
    if self.cellData.itemRow and self.cellData.itemRow.ItemID == itemId then
        self:RefreshCell()
    end
end

function GardrobeCellTemplate:Bind()
    self.Parameter.GardrobeCellBtn:AddClick(function()
        if self.MethodCallback ~= nil and self.cellData ~= nil then
            self:ShowRedSign(false)
            self.MethodCallback(self.ShowIndex, self.cellData)
        end
    end)
end

function GardrobeCellTemplate:OnDeselect()
    self.Parameter.IconTrial:SetActiveEx(false)
end

function GardrobeCellTemplate:OnSelect()
    self.Parameter.IconTrial:SetActiveEx(true)
end

function GardrobeCellTemplate:RefreshFrame()
    if Mgr.UISelectItem.Attr ~= nil and Mgr.UISelectItem.Attr.EquipData ~= nil and self.cellData ~= nil then
        if self.cellData.garderobeType == Mgr.EGarderobeType.Ornament then
            self.Parameter.IconTrial:SetActiveEx(Mgr.IsEquipDataContainItemId(Mgr.UISelectItem.Attr.EquipData, self.cellData.itemRow.ItemID))
        elseif self.cellData.garderobeType == Mgr.EGarderobeType.Eye then
            self.Parameter.IconTrial:SetActiveEx(Mgr.IsEquipDataContainItemId(Mgr.UISelectItem.Attr.EquipData, self.cellData.row.EyeID))
        elseif self.cellData.garderobeType == Mgr.EGarderobeType.Hair then
            self.Parameter.IconTrial:SetActiveEx(Mgr.IsEquipDataContainItemId(Mgr.UISelectItem.Attr.EquipData, self.cellData.row.BarberID))
        elseif self.cellData.garderobeType == Mgr.EGarderobeType.Fashion then
            self.Parameter.IconTrial:SetActiveEx(Mgr.IsEquipDataContainItemId(Mgr.UISelectItem.Attr.EquipData, self.cellData.itemRow.ItemID))
        end
    elseif self.Parameter ~= nil and self.Parameter.IconTrial ~= nil then
        self.Parameter.IconTrial:SetActiveEx(false)
    end
end

function GardrobeCellTemplate:ShowTryIcon(isShow)
    self.Parameter.IconTryon:SetActiveEx(isShow)
end

function GardrobeCellTemplate:ShowRedSign(isShow)
    if isShow == false and (self.cellData.garderobeType == Mgr.EGarderobeType.Ornament
            or self.cellData.garderobeType == Mgr.EGarderobeType.Fashion) then
        Mgr.RemoveNewItemId(self.cellData.itemRow.ItemID)
        Mgr.EventDispatcher:Dispatch(Mgr.ON_GARDEROBE_NEW_ITEM_CLICK)
    end
    local redSign = FindObjectInChild(self.Parameter.GardrobeCellBtn.gameObject, "RedPrompt")
    if redSign == nil then
        logError("没有找到红点物体")
        return
    end
    redSign:SetActiveEx(isShow)
end

function GardrobeCellTemplate:OnWearOrnamentOrFashion(itemId, isPutOn)
    if self.cellData.garderobeType == Mgr.EGarderobeType.Ornament
        or self.cellData.garderobeType == Mgr.EGarderobeType.Fashion then
        self:RefreshSelected()
    end
end

function GardrobeCellTemplate:RefreshSelected()
    if Mgr.IsWearByItemId(self.cellData.itemRow.ItemID) then
        self.Parameter.IconSelected.gameObject:SetActiveEx(true)
    else
        self.Parameter.IconSelected.gameObject:SetActiveEx(false)
    end
end

function GardrobeCellTemplate:RefreshCell()
    local redSign = FindObjectInChild(self.Parameter.GardrobeCellBtn.gameObject, "RedPrompt")
    redSign:SetActiveEx(false)

    self.Parameter.ImgBoard.gameObject:SetActiveEx((self.ShowIndex % 3) == 1)
    self.Parameter.IconSave.gameObject:SetActiveEx(false)
    self.Parameter.IconContentFashion.gameObject:SetActiveEx(false)
    self.Parameter.IconContent.gameObject:SetActiveEx(false)
    self:RefreshFrame()
    if self.cellData.garderobeType == Mgr.EGarderobeType.Ornament or self.cellData.garderobeType == Mgr.EGarderobeType.Fashion then
        self.Parameter.IconContent.gameObject:SetActiveEx(true)
        -- 用户可存入的装饰添加角标 已经存入的装饰不添加角标
        if not Mgr.IsStoreFashion(self.cellData.itemRow.ItemID) then
            local status, num = Mgr.IsExsitInBag(self.cellData.itemRow.ItemID)
            self.Parameter.IconSave.gameObject:SetActiveEx(status)
        end

        self:RefreshSelected()
        local showMask = Mgr.GetFashionStatus(self.cellData.itemRow.ItemID) ~= Mgr.EFashionStatusForUI.NotExist
        self.Parameter.ImgMask.gameObject:SetActiveEx(not showMask)
        MLuaCommonHelper.SetLocalScale(self.Parameter.IconContent.gameObject, ornamentScale, ornamentScale, ornamentScale)
        local spriteName = Data.BagModel:getItemBgById(self.cellData.itemRow.ItemID)
        if spriteName ~= nil then
            self.Parameter.GardrobeCellBtn:SetSpriteAsync("Common", spriteName)
        end

        self.Parameter.IconContent:SetSpriteAsync(self.cellData.itemRow.ItemAtlas, self.cellData.itemRow.ItemIcon)
        self:ShowRedSign(table.ro_contains(Mgr.NewItemId, self.cellData.itemRow.ItemID))
    elseif self.cellData.garderobeType == Mgr.EGarderobeType.Eye then
        self.Parameter.IconContent.gameObject:SetActiveEx(true)
        self.Parameter.GardrobeCellBtn:SetSpriteAsync("GarderobeNew", itemIconBgNormal)
        MLuaCommonHelper.SetLocalScale(self.Parameter.IconContent.gameObject, eyeScale, eyeScale, eyeScale)
        self.Parameter.IconContent:SetSpriteAsync(self.cellData.row.EyeAtlas, self.cellData.row.EyeIcon)
        self.Parameter.IconSelected.gameObject:SetActiveEx(false)
        self.Parameter.ImgMask.gameObject:SetActiveEx(false)
    elseif self.cellData.garderobeType == Mgr.EGarderobeType.Hair then
        self.Parameter.IconContent.gameObject:SetActiveEx(true)
        self.Parameter.GardrobeCellBtn:SetSpriteAsync("GarderobeNew", itemIconBgNormal)
        MLuaCommonHelper.SetLocalScale(self.Parameter.IconContent.gameObject, hairScele, hairScele, hairScele)
        self.Parameter.IconContent:SetSpriteAsync(self.cellData.row.BarberAtlas, self.cellData.row.BarberIcon)
        self.Parameter.IconSelected.gameObject:SetActiveEx(false)
        self.Parameter.ImgMask.gameObject:SetActiveEx(false)
    elseif self.cellData.garderobeType == Mgr.EGarderobeType.Fashion then
        self.Parameter.IconContentFashion.gameObject:SetActiveEx(true)
        self:RefreshSelected()
        local showMask = Mgr.GetFashionStatus(self.cellData.itemRow.ItemID) ~= Mgr.EFashionStatusForUI.NotExist
        self.Parameter.ImgMask.gameObject:SetActiveEx(not showMask)
        local spriteName = Data.BagModel:getItemBgById(self.cellData.itemRow.ItemID)
        if spriteName ~= nil then
            self.Parameter.GardrobeCellBtn:SetSpriteAsync("Common", spriteName)
        end
        self.Parameter.IconContentFashion:SetSpriteAsync(self.cellData.itemRow.ItemAtlas, self.cellData.itemRow.ItemIcon)
        self:ShowRedSign(table.ro_contains(Mgr.NewItemId, self.cellData.itemRow.ItemID))
    end
end
--lua custom scripts end
return GardrobeCellTemplate