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
---@class PaymentInstructionsTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Content MoonClient.MLuaUICom
---@field BtnDetail MoonClient.MLuaUICom

---@class PaymentInstructionsTemplate : BaseUITemplate
---@field Parameter PaymentInstructionsTemplateParameter

PaymentInstructionsTemplate = class("PaymentInstructionsTemplate", super)
--lua class define end

--lua functions
function PaymentInstructionsTemplate:Init()
	
	super.Init(self)
	self.Parameter.BtnDetail:AddClickWithLuaSelf(self.OnBtnDetail, self)
	
end --func end
--next--
function PaymentInstructionsTemplate:BindEvents()

end --func end
--next--
function PaymentInstructionsTemplate:OnDestroy()
	
end --func end
--next--
function PaymentInstructionsTemplate:OnDeActive()
	
end --func end
--next--
function PaymentInstructionsTemplate:OnSetData(data)
	self.Parameter.Content.LabText =  Common.Utils.Lang("Refund_Instructions_Tip")
end --func end
--next--
--lua functions end

--lua custom scripts
--PaymentInstructionsTemplate.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsPaymentInstructions"

function PaymentInstructionsTemplate:OnBtnDetail()
	Application.OpenURL(TableUtil.GetGlobalTable().GetRowByName("RefundInstructionsURL").Value)
end

--lua custom scripts end
return PaymentInstructionsTemplate