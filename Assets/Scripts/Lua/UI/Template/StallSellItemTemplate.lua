--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class StallSellItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SellOut MoonClient.MLuaUICom
---@field Selected2 MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field PriceCount2 MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field Price MoonClient.MLuaUICom
---@field PedlerySellItem02 MoonClient.MLuaUICom
---@field PedlerySellItem01 MoonClient.MLuaUICom
---@field OverTime MoonClient.MLuaUICom
---@field Name2 MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemCountLab MoonClient.MLuaUICom
---@field ItemButtonSell01 MoonClient.MLuaUICom
---@field ItemButton2 MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom

---@class StallSellItemTemplate : BaseUITemplate
---@field Parameter StallSellItemTemplateParameter

StallSellItemTemplate = class("StallSellItemTemplate", super)
--lua class define end

--lua functions
function StallSellItemTemplate:Init()

    super.Init(self)

end --func end
--next--
function StallSellItemTemplate:OnDestroy()

    if self.item then
        self:UninitTemplate(self.item)
        self.item = nil
    end

end --func end
--next--
function StallSellItemTemplate:OnSetData(data)

    self:InitButtonTemplate(data)

end --func end
--next--
function StallSellItemTemplate:OnDeActive()


end --func end
--next--
function StallSellItemTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
l_mgr = MgrMgr:GetMgr("StallMgr")
l_event = MgrMgr:GetMgr("StallMgr").EventDispatcher

local l_type = {
    empty = "1",
    next = "2",
    stall = "3",
}

function StallSellItemTemplate:InitButtonTemplate(info)

    --[[
    if self.info == info and info ~= "next" then
        return
    end
    ]]--
    self.info = info
    self.curType = l_type.stall
    if info == "empty" then
        self.curType = l_type.empty
    end
    if info == "next" then
        self.curType = l_type.next
    end
    self:InitButton()
end

function StallSellItemTemplate:InitButton()
    self.myGod = false
    self.Parameter.Selected.gameObject:SetActiveEx(false)
    if self.item then
        self.item:SetGameObjectActive(false)
    end
    if self.curType == l_type.stall then
        local l_uid = self.info.uid
        local l_id = self.info.id
        local l_count = self.info.count
        local l_price = self.info.price
        local l_leftTime = self.info.leftTime
        local l_money = tonumber(self.info.money)
        self.Parameter.PedlerySellItem01.gameObject:SetActiveEx(true)
        self.Parameter.PedlerySellItem02.gameObject:SetActiveEx(false)
        local l_data = TableUtil.GetItemTable().GetRowByItemID(l_id)
        local l_name = l_data.ItemName
        local l_atlas = l_data.ItemAtlas
        local l_icon = l_data.ItemIcon
        self.Parameter.Name.LabText = l_name
        self.Parameter.Name.gameObject:SetActiveEx(true)
        --self.Parameter.EquipIcon.gameObject:SetActiveEx(true)
        --self.Parameter.EquipIcon:SetSprite(l_atlas,l_icon, true)
        self.Parameter.Price.gameObject:SetActiveEx(true)
        self.Parameter.PriceCount.LabText = tostring(l_price)
        self.Parameter.SellOut.gameObject:SetActiveEx(false)
        self.Parameter.OverTime.gameObject:SetActiveEx(false)
        --self.Parameter.ItemCountLab.gameObject:SetActiveEx(true)
        --self.Parameter.ItemCountLab.LabText = l_count
        if not self.item then
            self.item = self:NewTemplate("ItemTemplate", {
                TemplateParent = self.Parameter.EquipIcon.gameObject.transform.parent
            })
        end
        if self.item then
            self.item:SetData({ ID = l_id, Count = l_count, IsShowTips = false })
        end
        if l_money > 0 then
            self.Parameter.SellOut.gameObject:SetActiveEx(true)
            self.myGod = true
        else
            if l_leftTime <= 0 then
                self.Parameter.OverTime.gameObject:SetActiveEx(true)
            end
        end
        self.Parameter.ItemButtonSell01:AddClick(function()
            if l_money > 0 then
                l_mgr.SendStallDrawMoneyReq(l_uid)
                return
            end
            l_event:Dispatch(l_mgr.ON_CLICK_SELL_ITEM, self.Parameter.Selected.gameObject)
            self.Parameter.Selected.gameObject:SetActiveEx(true)
            ---[9月平台测试版本][摆摊功能二期]程序-已上架的道具id从摆摊配置中移除后，需要加容错处理
            local l_tableInfo = l_mgr.g_tableItemInfo[l_id]
            if l_leftTime <= 0 and l_tableInfo then
                l_event:Dispatch(l_mgr.ON_CLICK_REPEAT_BTN, l_id, l_price, l_count, l_uid)
                --MgrMgr:GetMgr("ItemTipsMgr").ShowStallTips(l_id,
                --function()
                --  local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
                --  if l_ui then
                --      l_ui:ShowStallRepeatSellPanel(l_id,l_price,l_count,
                --      function (itemId,num,price,state)
                --          if state then
                --              l_mgr.SendStallReSellItemReq(l_uid,price)
                --          else
                --              l_mgr.SendStallSellItemCancelReq(l_uid)
                --          end
                --      end)
                --  end
                --end)
                return
            end

            ---@type ItemData
            local l_itemInfo = self.info.itemInfo

            MgrMgr:GetMgr("ItemTipsMgr").ShowStallTipsWithInfo(l_itemInfo,
                    function()
                        local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
                        if l_ui then
                            l_ui:ShowStallSellPanel(l_id, l_price,
                                    function(itemId)
                                        l_mgr.SendStallSellItemCancelReq({ l_uid })
                                    end)
                        end
                    end, { stallUid = self.info.uid })
        end)
        return
    end
    if self.curType == l_type.empty then
        self.Parameter.PedlerySellItem01.gameObject:SetActiveEx(true)
        self.Parameter.PedlerySellItem02.gameObject:SetActiveEx(false)
        --self.Parameter.EquipIcon.gameObject:SetActiveEx(false)
        self.Parameter.Price.gameObject:SetActiveEx(false)
        self.Parameter.Name.gameObject:SetActiveEx(false)
        self.Parameter.SellOut.gameObject:SetActiveEx(false)
        self.Parameter.OverTime.gameObject:SetActiveEx(false)
        --self.Parameter.ItemCountLab.gameObject:SetActiveEx(false)
        self.Parameter.ItemButtonSell01:AddClick(function()
            if l_mgr.g_cansell then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_SELECTED_TO_SELL"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_SELECTED_TO_SELL_NON"))
            end
        end)
        return
    end
    if self.curType == l_type.next then
        self.Parameter.PedlerySellItem01.gameObject:SetActiveEx(false)
        self.Parameter.PedlerySellItem02.gameObject:SetActiveEx(true)
        local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")

        local l_count = l_limitMgr.GetItemCanBuyCount(l_limitMgr.g_limitType.STALL_UP, 1)
        local l_limit = l_limitMgr.GetItemLimitCount(l_limitMgr.g_limitType.STALL_UP, 1)
        local l_haveCount = l_limit - l_count
        local l_initData = l_limitMgr.GetRefreshNum(l_limitMgr.g_limitType.STALL_UP, 1)
        local l_target = l_haveCount + 1 - l_initData
        local l_data = nil
        local l_table = TableUtil.GetStallExpandTable().GetTable()
        for i, v in pairs(l_table) do
            if v.count == l_target then
                l_data = v
                break
            end
        end
        self.Parameter.PriceCount2.LabText = "----"
        if l_data then
            self.Parameter.PriceCount2.LabText = l_data.cost
            self.Parameter.ItemButton2:AddClick(function()
                local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(103)
                local l_msg = Lang("STALL_BUY_NEW_STALL", tostring(l_data.cost), Lang("RICH_IMAGE", tostring(l_itemInfo.ItemIcon), tostring(l_itemInfo.ItemAtlas), 20, 1))
                CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm, true, nil, l_msg, Common.Utils.Lang("DLG_BTN_YES"), Common.Utils.Lang("DLG_BTN_NO"), function()
                    l_mgr.SendStallBuyStallCountReq()
                end)
            end)
        end
    end
end

function StallSellItemTemplate:GetMoneyState()
    if self.curType == l_type.stall and self:IsActive() then
        return self.myGod
    end
    return false
end
--lua custom scripts end
return StallSellItemTemplate