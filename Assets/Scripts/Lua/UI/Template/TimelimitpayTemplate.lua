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
---@class TimelimitpayTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TimelimitpayPrefab MoonClient.MLuaUICom
---@field Present MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Gift MoonClient.MLuaUICom

---@class TimelimitpayTemplate : BaseUITemplate
---@field Parameter TimelimitpayTemplateParameter

TimelimitpayTemplate = class("TimelimitpayTemplate", super)
--lua class define end

--lua functions
function TimelimitpayTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function TimelimitpayTemplate:OnDestroy()
	
	
end --func end
--next--
function TimelimitpayTemplate:OnDeActive()
	
	
end --func end
--next--
function TimelimitpayTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function TimelimitpayTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function TimelimitpayTemplate:CustomSetData(data)
    local l_row = TableUtil.GetRechargeTable().GetRowById(data.id)
    self.Parameter.Icon:SetSpriteAsync("Shopping", "UI_Shopping_Icon_0" .. data.level .. ".png", nil, true)
    
    self.Parameter.Number.LabText = data.money
    self.Parameter.ItemName.LabText = l_row.Name

    if data.giftCount > 0 then
        self.Parameter.Present.LabText = tostring(data.giftCount)
        self.Parameter.Gift.gameObject:SetActiveEx(true)
    else
        self.Parameter.Gift.gameObject:SetActiveEx(false)
    end

    self.Parameter.TimelimitpayPrefab:AddClick(function()
        if DataMgr:GetData("TimeLimitPayData").ActivityState ~= LimitedOfferStatusType.LIMITED_OFFER_START then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_IS_ALREADY_OVER"))
            return
        end
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(data.itemId)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TIMELIMIT_ACTIVITY_TIPS", data.itemCount, l_itemRow.ItemName, data.giftCount))    
    end)
end
--lua custom scripts end
return TimelimitpayTemplate