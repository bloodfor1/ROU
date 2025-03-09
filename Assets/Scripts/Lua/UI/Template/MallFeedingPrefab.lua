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
---@class MallFeedingPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SellOut MoonClient.MLuaUICom
---@field Recommend MoonClient.MLuaUICom
---@field PriceNum MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field AddtionNode MoonClient.MLuaUICom
---@field Addtion MoonClient.MLuaUICom

---@class MallFeedingPrefab : BaseUITemplate
---@field Parameter MallFeedingPrefabParameter

MallFeedingPrefab = class("MallFeedingPrefab", super)
--lua class define end

--lua functions
function MallFeedingPrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MallFeedingPrefab:OnDestroy()
	
	
end --func end
--next--
function MallFeedingPrefab:OnDeActive()
	
	
end --func end
--next--
function MallFeedingPrefab:OnSetData(data)
	
	self.data = data
	self.Parameter.Name.LabText = tostring(data.Name)
	self.Parameter.PriceNum.LabText = game:GetPayMgr():GetPaymentCurrencyFormatByProductId(data.PaymentID)
	self.Parameter.Icon:SetSprite(data.Atlas, data.Icon, true)
	self.Parameter.Bg:SetSprite("Shopping", data.Recommend and "UI_Shopping_Bg_Icon_03.png" or "UI_Shopping_Bg_Icon_02.png")
	self.Parameter.Recommend.gameObject:SetActiveEx(data.Recommend)
	self.Parameter.Btn:AddClick(function()
		if self.MethodCallback then
			self.MethodCallback(self)
		end
	end,true)
	
	self:UpdateLimitPayState()
end --func end
--next--
function MallFeedingPrefab:BindEvents()
	
	self:BindEvent(MgrMgr:GetMgr("TimeLimitPayMgr").EventDispatcher, MgrMgr:GetMgr("TimeLimitPayMgr").ON_ACTIVITY_CHANGE, self.UpdateLimitPayState)
end --func end
--next--
--lua functions end

--lua custom scripts
function MallFeedingPrefab:Select()
	self.Parameter.Light:SetActiveEx(true)
end

function MallFeedingPrefab:Deselect()
	self.Parameter.Light:SetActiveEx(false)
end

function MallFeedingPrefab:UpdateLimitPayState()
	
	local l_limitPayMgr = MgrMgr:GetMgr("TimeLimitPayMgr")
	local l_open = l_limitPayMgr.IsSystemOpen()
	if l_open then
		if self.data.OpenSystemID > 0 then
			l_open = false
		end
	end

	if l_open then
		local l_row = TableUtil.GetPaymentTable().GetRowByProductId(self.data.PaymentID)
		local l_count = l_limitPayMgr.GetAddtionCountByAwardId(l_row.AwardId[1])
		self.Parameter.Addtion.LabText = math.ceil(l_count * l_limitPayMgr.GetRatio() / 10000)

		if l_count <= 0 then
			l_open = false
		end
	end

	self.Parameter.AddtionNode.gameObject:SetActiveEx(l_open)
end

--lua custom scripts end
return MallFeedingPrefab