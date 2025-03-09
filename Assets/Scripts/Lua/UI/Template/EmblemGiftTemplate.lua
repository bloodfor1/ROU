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
---@class EmblemGiftTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field InfoTittle MoonClient.MLuaUICom
---@field emblemRemoveBtn MoonClient.MLuaUICom
---@field emblemBtn MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@class EmblemGiftTemplate : BaseUITemplate
---@field Parameter EmblemGiftTemplateParameter

EmblemGiftTemplate = class("EmblemGiftTemplate", super)
--lua class define end

--lua functions
function EmblemGiftTemplate:Init()
    super.Init(self)
    self.Parameter.emblemBtn:AddClickWithLuaSelf(self._onClick, self)
    self.Parameter.emblemRemoveBtn:AddClickWithLuaSelf(self._onRemove, self)
end --func end
--next--
function EmblemGiftTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function EmblemGiftTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function EmblemGiftTemplate:OnSetData(data)
    self.info = data
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.info.id)
    if not l_itemData then
        logError("find item itemData fail ", self.info.id)
        return
    end

    local l_giftMgr = MgrMgr:GetMgr("GiftMgr")
    self.selected = false
    self.curCount = 0
    self._targetItem = nil
    for i = 1, #l_giftMgr.g_giftItems do
        if l_giftMgr.g_giftItems[i].itemID == self.info.id then
            self._targetItem = l_giftMgr.g_giftItems[i]
            self.curCount = l_giftMgr.g_giftItems[i].count
            self.selected = true
            break
        end
    end

    self.Parameter.ItemIcon:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon)
    self:UpdateState()
end --func end
--next--
function EmblemGiftTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

function EmblemGiftTemplate:_onClick()
    local l_giftMgr = MgrMgr:GetMgr("GiftMgr")
    local l_leftCount = l_giftMgr.g_giftTimesInfo.present_times[1].left_times
    local propInfo = Data.BagModel:CreateItemWithTid(self.info.id)
    if l_giftMgr.g_giftTimesInfo.gift_recipient_times <= l_giftMgr.g_giftCount then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("FRIEND_GIFTS_LIMIT"))
        return
    end

    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, self:transform(), nil, { IsShowCloseButton = false })
    if self.info.count > 0 and self.curCount < self.info.count and l_giftMgr.g_giftCount < l_leftCount then
        l_giftMgr.g_giftCount = l_giftMgr.g_giftCount + 1
        self.curCount = self.curCount + 1
        self.selected = true
        if self._targetItem then
            self._targetItem.count = self.curCount
        else
            local l_index = #l_giftMgr.g_giftItems + 1
            l_giftMgr.g_giftItems[l_index] = {}
            l_giftMgr.g_giftItems[l_index].count = self.curCount
            l_giftMgr.g_giftItems[l_index].itemID = self.info.id
            l_giftMgr.g_giftItems[l_index].uid = -1
            self._targetItem = l_giftMgr.g_giftItems[l_index]
        end
        self:UpdateState()
        l_giftMgr.EventDispatcher:Dispatch(l_giftMgr.SelectGiftItem)
    end
end

function EmblemGiftTemplate:_onRemove()
    local l_giftMgr = MgrMgr:GetMgr("GiftMgr")
    if self.info.count > 0 and self.curCount > 0 then
        self.curCount = self.curCount - 1
        self:UpdateState()
        l_giftMgr.g_giftCount = l_giftMgr.g_giftCount - 1
        l_giftMgr.EventDispatcher:Dispatch(l_giftMgr.SelectGiftItem)
    end
end

function EmblemGiftTemplate:Select(flag)
    self.Parameter.Checkmark:SetActiveEx(flag)
end

function EmblemGiftTemplate:UpdateState()
    if self.selected and self.curCount > 0 then
        self:Select(true)
        self.Parameter.ItemCount.LabText = tostring(self.curCount) .. "/" .. tostring(self.info.count)
        self.Parameter.emblemRemoveBtn.gameObject:SetActiveEx(true)
    else
        self:Select(false)
        self.Parameter.ItemCount.LabText = tostring(self.info.count)
        self.Parameter.emblemRemoveBtn.gameObject:SetActiveEx(false)
    end
end
--lua custom scripts end
return EmblemGiftTemplate