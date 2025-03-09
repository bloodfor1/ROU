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
---@class CommonItemTipsDiscountsParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field OriginalIcon MoonClient.MLuaUICom
---@field OriginalNum MoonClient.MLuaUICom
---@field CurIcon MoonClient.MLuaUICom
---@field CurNum MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Discounts MoonClient.MLuaUICom

---@class CommonItemTipsDiscounts : BaseUITemplate
---@field Parameter CommonItemTipsDiscountsParameter

CommonItemTipsDiscounts = class("CommonItemTipsDiscounts", super)
--lua class define end

--lua functions
function CommonItemTipsDiscounts:Init()
	
	    super.Init(self)
		self.layoutComponent = self.Parameter.CommonItemTipsDiscounts:GetComponent("LayoutElement")
end --func end
--next--
function CommonItemTipsDiscounts:OnDestroy()
	
	
end --func end
--next--
function CommonItemTipsDiscounts:OnDeActive()

	
end --func end
--next--
function CommonItemTipsDiscounts:OnSetData(data)
	
	local l_coinData = TableUtil.GetItemTable().GetRowByItemID(data.priceID)
	    if not l_coinData then
	        logError("找不到出售道具id:" .. tostring(data.priceID))
	    end
	self.Parameter.OriginalNum.LabText = tostring(data.priceOriginal)
	self.Parameter.CurNum.LabText = tostring(data.priceNum)
	if l_coinData then
		self.Parameter.OriginalIcon:SetSprite(l_coinData.ItemAtlas,l_coinData.ItemIcon)
		self.Parameter.CurIcon:SetSprite(l_coinData.ItemAtlas,l_coinData.ItemIcon)
	end
	self.Parameter.Time.transform.parent.gameObject:SetActiveEx(data.discountsTime~=nil)
	if data.discountsTime then
		local l_time = data.discountsTime
		local l_day = math.floor(l_time / 86400)
		l_time = l_time - l_day * 86400
		local l_hour = math.floor(l_time / 3600)
		l_time = l_time - l_hour * 3600
		local l_min = math.max(1,math.floor(l_time / 60))
		if l_day > 0 then
			self.Parameter.Time.LabText = StringEx.Format(Lang("TipsDiscounts_Day"),l_day,l_hour)--剩余：{0}天{1}小时
		elseif l_hour > 0 then
			self.Parameter.Time.LabText = StringEx.Format(Lang("TipsDiscounts_Hour"),l_hour,l_min)--剩余：{0}小时{1}分钟
		else
			self.Parameter.Time.LabText = StringEx.Format(Lang("TipsDiscounts_Min"),math.max(1,l_min))--剩余：{0}分钟
		end
	end
	self.Parameter.Discounts:SetActiveEx(data.discounts~=nil)
	self.Parameter.Discount.gameObject:SetActiveEx(data.discounts~=nil)
	if data.discounts then
		self.Parameter.Discounts.LabText = Common.CommonUIFunc.GetDiscountFormat(data.discounts)--"{0:.#}折"
	end
	if self.layoutComponent then
		if data.discounts == nil then
			self.layoutComponent.preferredHeight = 30
		else
			self.layoutComponent.preferredHeight = 70
		end
	end
end --func end
--next--
function CommonItemTipsDiscounts:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
CommonItemTipsDiscounts.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsDiscounts"
function CommonItemTipsDiscounts:ResetSetComponent()
	self.layoutComponent.preferredHeight = 70
end
--lua custom scripts end
return CommonItemTipsDiscounts