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
---@class MallItemPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextTime MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field PriceNum MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LimitText MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Discounts MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class MallItemPrefab : BaseUITemplate
---@field Parameter MallItemPrefabParameter

MallItemPrefab = class("MallItemPrefab", super)
--lua class define end

--lua functions
function MallItemPrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MallItemPrefab:OnDestroy()
	
	self.ItemObj = nil
	
end --func end
--next--
function MallItemPrefab:OnDeActive()
	
	
end --func end
--next--
function MallItemPrefab:OnSetData(data)
	
	self.data = data
	self.mallRow = TableUtil.GetMallTable().GetRowByMajorID(data.seq_id)
	if not self.mallRow then
		return
	end
	--道具显示
	self.itemRow = TableUtil.GetItemTable().GetRowByItemID(self.mallRow.ItemID)
	if self.itemRow then
		self.Parameter.ItemName.LabText = self.itemRow.ItemName
		if not self.ItemObj then
			self.ItemObj = self:NewTemplate("ItemTemplate", {
				TemplateParent = self.Parameter.Item.Transform,
			})
		end
		self.ItemObj:SetData({
			ID = self.itemRow.ItemID,
			-- Count = data.left_times,
			IsBind = data.is_bind,
			IsShowName = false,
			IsShowCount = false,
		})
	else
		logError("不存在的商品道具 => %s", self.mallRow.ItemID)
	end
	--价格
	self.priceRow = TableUtil.GetItemTable().GetRowByItemID(data.money_type)
	if self.priceRow then
		self.Parameter.PriceIcon:SetSprite(self.priceRow.ItemAtlas, self.priceRow.ItemIcon, true)
		self.Parameter.PriceNum.LabText = tostring(data.now_price)
	else
		logError("不存在的货币类型 => %s",data.money_type)
	end
	--优惠
	self.Discounts = nil
	if self.mallRow.Label[0] == 1 then
		self.Discounts = self.mallRow.Label[1] / 10.0
		self.Parameter.Discounts.transform.parent.gameObject:SetActiveEx(true)
		self.Parameter.Discounts.LabText =  Common.CommonUIFunc.GetDiscountFormat(self.Discounts)--"{0:.#}折"
	elseif self.mallRow.Label[0] == 2 then
		self.Parameter.Discounts.transform.parent.gameObject:SetActiveEx(true)
		self.Parameter.Discounts.LabText = Lang("Mall_Time_Limit")--"限时"
	else
		self.Parameter.Discounts.transform.parent.gameObject:SetActiveEx(false)
	end
	local l_notInSell = MgrMgr:GetMgr("EquipMgr").IsEquipNotInSell(self.mallRow.ItemID)
	self.Parameter.Lock.gameObject:SetActiveEx(data.is_bind and (not l_notInSell))
	self.Parameter.Lock:AddClick(function()
		local l_isLastCell = (self.ShowIndex % 4) == 0
		MgrMgr:GetMgr("TipsMgr").ShowTipsInfo({
			content = Common.Utils.Lang("MALL_BIND_ITEMS"),
			relativeTransform = self.Parameter.Lock.transform,
			relativeOffsetX = l_isLastCell and -50 or 0,
			relativeOffsetY = 10,
			hideTitle = true,
			horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize,
		})
	end)	
	--购买按钮
	self.Parameter.Btn:AddClick(function()
		if self.MethodCallback then
			self.MethodCallback(self)
		end
	end,true)
	local l_chooseItem = MgrMgr:GetMgr("MallMgr").chooseItem
	if l_chooseItem ~= nil and data.seq_id == l_chooseItem.MajorID then
		MgrMgr:GetMgr("MallMgr").chooseItem = nil
		if self.MethodCallback then
			self.MethodCallback(self)
		end
	end
	--售罄
	self.Parameter.SellOut:SetActiveEx(data.left_times==0)
	if data.left_times > 0 then
		self.Parameter.LimitText.LabText = Lang("LEFT_BUY_TIME", data.left_times)
	else
		self.Parameter.LimitText.LabText = ""
	end
	if data.left_times > 0 and self.mallRow.ShowCountDown and data.next_refresh_time > 0 then
		local l_timeMgr = Common.TimeMgr
		local l_timeRet = l_timeMgr.GetCountDownDayTimeTable(data.next_refresh_time)
		local l_day = l_timeRet.day or 0
		local l_hour = l_timeRet.hour or 0
		local l_min = l_timeRet.min or 0
		if l_day > 0 then
			self.Parameter.TextTime.LabText = Lang("TipsDiscounts_Day", l_day, l_hour)
		elseif l_hour > 0 then
			self.Parameter.TextTime.LabText = Lang("TipsDiscounts_Hour", l_hour, l_min)
		else
			self.Parameter.TextTime.LabText = StringEx.Format(Lang("TipsDiscounts_Min"), l_min)--剩余：{0}分钟
		end
		self.Parameter.TextTime.gameObject:SetActiveEx(true)
	else
		self.Parameter.TextTime.gameObject:SetActiveEx(false)
	end
	
end --func end
--next--
function MallItemPrefab:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MallItemPrefab:Select()
	self.Parameter.Light:SetActiveEx(true)
end
function MallItemPrefab:Deselect()
	self.Parameter.Light:SetActiveEx(false)
end
--lua custom scripts end
return MallItemPrefab