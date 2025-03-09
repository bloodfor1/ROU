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
---@class CarryShopTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field title MoonClient.MLuaUICom
---@field ItemNamePar MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Num MoonClient.MLuaUICom
---@field LockText MoonClient.MLuaUICom
---@field lock MoonClient.MLuaUICom
---@field Limit MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field Btn_SelectOne MoonClient.MLuaUICom

---@class CarryShopTem : BaseUITemplate
---@field Parameter CarryShopTemParameter

CarryShopTem = class("CarryShopTem", super)
--lua class define end

--lua functions
function CarryShopTem:Init()

    super.Init(self)
    self.ItemTem = nil
    self.data = nil
    self.tableId = 0
    self.Parameter.Btn_SelectOne:AddClick(function()
        self.MethodCallback(self.ShowIndex, self.tableId, self.data)
    end)

end --func end
--next--
function CarryShopTem:BindEvents()


end --func end
--next--
function CarryShopTem:OnDestroy()

    self.ItemTem = nil
    self.data = nil

end --func end
--next--
function CarryShopTem:OnDeActive()


end --func end
--next--
function CarryShopTem:OnSetData(data)

    local l_data = TableUtil.GetShopCommoditTable().GetRowById(data.table_id,true)
    if l_data == nil then
        logError("ShopCommoditTable 没有找到相关数据  Id "..data.table_id)
        return
    end
    self.tableId = data.table_id
    self.data = data
    self.ItemTem = self:NewTemplate("ItemTemplate", {
        TemplateParent = self.Parameter.ItemParent.transform,
        Data = {
            ID = l_data.ItemId,
            Count = l_data.ItemPerMount,
            IsShowCount = true,
        }
    })
    self.Parameter.Select:SetActiveEx(false)
    self.Parameter.lock:SetActiveEx(data.is_lock)
    self.Parameter.LockText:SetActiveEx(data.is_lock)
    if data.is_lock then
        if l_data.HandBookLvLimit > 0 then
            self.Parameter.LockText.LabText = Lang("MONSTER_BOOK_LVL_LIMIT", l_data.HandBookLvLimit)
        else
            self.Parameter.LockText.LabText = Lang("BASE_ACHIEVE_TO_UNLOCK_MONSTER_AWARD", l_data.BaseLvLimit)
        end
    end
    if l_data.PurchaseTimesLimit ~= 0 then
        local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
        local limitData = l_limitBuyMgr.GetLimitDataByKey(l_limitBuyMgr.g_limitType.SHOP_BUY, tostring(data.table_id))
        self.Parameter.Num.LabText = data.left_time
        if limitData.RefreshType == 0 then
            self.Parameter.title.LabText = Common.Utils.Lang("COUNT_LIMIT_ONEROLE")
        elseif limitData.RefreshType == 1 or limitData.RefreshType == 2 or limitData.RefreshType == 7 then
            self.Parameter.title.LabText = Common.Utils.Lang("COUNT_LIMIT_DAY")
        elseif limitData.RefreshType == 3 or limitData.RefreshType == 4 then
            self.Parameter.title.LabText = Common.Utils.Lang("COUNT_LIMIT_WEEK")
        elseif limitData.RefreshType == 5 or limitData.RefreshType == 6 then
            self.Parameter.title.LabText = Common.Utils.Lang("COUNT_LIMIT_MONTH")
        end
        if data.left_time == 0 then
            self.Parameter.lock:SetActiveEx(true)
        end
    end
    self.Parameter.Limit:SetActiveEx(l_data.PurchaseTimesLimit ~= 0)
    self.Parameter.ItemName.LabText = TableUtil.GetItemTable().GetRowByItemID(l_data.ItemId).ItemName
end --func end
--next--
--lua functions end

--lua custom scripts
function CarryShopTem:OnSelect()
    self.Parameter.Select:SetActiveEx(true)
end
function CarryShopTem:OnDeselect()
    self.Parameter.Select:SetActiveEx(false)
end
--lua custom scripts end
return CarryShopTem