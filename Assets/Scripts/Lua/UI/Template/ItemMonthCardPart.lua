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
---@class ItemMonthCardPartParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Tips MoonClient.MLuaUICom
---@field Txt_Name MoonClient.MLuaUICom
---@field Obj_TipsInfo MoonClient.MLuaUICom
---@field Img_Bg MoonClient.MLuaUICom
---@field Btn_MonthCardTips MoonClient.MLuaUICom

---@class ItemMonthCardPart : BaseUITemplate
---@field Parameter ItemMonthCardPartParameter

ItemMonthCardPart = class("ItemMonthCardPart", super)
--lua class define end

--lua functions
function ItemMonthCardPart:Init()
	
	super.Init(self)
	
end --func end
--next--
function ItemMonthCardPart:BindEvents()
	
	
end --func end
--next--
function ItemMonthCardPart:OnDestroy()
	
	self.Parameter.Obj_TipsInfo:SetActiveEx(false)
	
end --func end
--next--
function ItemMonthCardPart:OnDeActive()
	
	
end --func end
--next--
function ItemMonthCardPart:OnSetData(data)
	self.Parameter.Img_Bg:SetActiveEx(true)
	self.Parameter.Obj_TipsInfo:SetActiveEx(false)
	self.Parameter.Btn_Close:SetActiveEx(false)
	self.Parameter.Btn_MonthCardTips:AddClick(function(go)
		local l_s = MgrMgr:GetMgr("MonthCardMgr").GetMonthCardEntrustTicketRaiseTips()
		self.Parameter.Txt_Tips.LabText = l_s
		self.Parameter.Obj_TipsInfo:SetActiveEx(true)
		self.Parameter.Btn_Close:SetActiveEx(true)
	end)
	self.Parameter.Btn_Close:AddClick(function(go)
		self.Parameter.Obj_TipsInfo:SetActiveEx(false)
		self.Parameter.Btn_Close:SetActiveEx(false)
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts
ItemMonthCardPart.TemplatePath = "UI/Prefabs/ItemPart/ItemMonthCardPart"
--lua custom scripts end
return ItemMonthCardPart