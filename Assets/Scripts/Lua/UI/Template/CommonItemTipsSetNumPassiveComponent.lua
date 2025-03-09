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
---@class CommonItemTipsSetNumPassiveComponentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field CommonItemTipsSetNumComponent MoonClient.MLuaUICom
---@field CountDescriptionText MoonClient.MLuaUICom
---@field Coin MoonClient.MLuaUICom
---@field CoinIcon MoonClient.MLuaUICom
---@field CoinCount MoonClient.MLuaUICom
---@field BtnAdd MoonClient.MLuaUICom
---@field BtnDec MoonClient.MLuaUICom

---@class CommonItemTipsSetNumPassiveComponent : BaseUITemplate
---@field Parameter CommonItemTipsSetNumPassiveComponentParameter

CommonItemTipsSetNumPassiveComponent = class("CommonItemTipsSetNumPassiveComponent", super)
--lua class define end

--lua functions
function CommonItemTipsSetNumPassiveComponent:Init()
	
	    super.Init(self)
	
end --func end
--next--
function CommonItemTipsSetNumPassiveComponent:OnDestroy()
	
	
end --func end
--next--
function CommonItemTipsSetNumPassiveComponent:OnDeActive()
	
	
end --func end
--next--
function CommonItemTipsSetNumPassiveComponent:OnSetData(data)
	
	
end --func end
--next--
function CommonItemTipsSetNumPassiveComponent:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
CommonItemTipsSetNumPassiveComponent.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsSetNumPassiveComponent"

function CommonItemTipsSetNumPassiveComponent:SetInfo(cSetNumTxt,cCoinCount,cBtnAddMethod,cBtnDecMethod,cSetNumTxtColor,cSetNumColor,CoinIconData)
	self.Parameter.CountDescriptionText.LabText = cSetNumTxt
	self.Parameter.CoinCount.LabText = tostring(cCoinCount)
	if cSetNumTxtColor then
		self.Parameter.CountDescriptionText.LabColor = cSetNumTxtColor
	end
	if cSetNumColor then
		self.Parameter.SetNumtxt.LabColor = cSetNumColor
	end
	if CoinIconData then
		if CoinIconData.ItemAtlas and CoinIconData.ItemIcon then
			self.Parameter.CoinIcon:SetSprite(CoinIconData.ItemAtlas, CoinIconData.ItemIcon)
		else
			logError("数据传输有误::CoinIconData.ItemAtlas or CoinIconData.ItemIcon")
		end
		self.Parameter.CoinIcon.gameObject:SetActiveEx(true)
	else
		self.Parameter.CoinIcon.gameObject:SetActiveEx(false)
	end
	if cBtnAddMethod then
		self.Parameter.BtnAdd:AddClick(function ()
			cBtnAddMethod()
		end)
	end
	if cBtnDecMethod then
		self.Parameter.BtnDec:AddClick(function ()
			cBtnDecMethod()
		end)
	end
end


function CommonItemTipsSetNumPassiveComponent:GetNumPassiveComponentValue()
	if self.Parameter.CommonSetNumCount then
		return self.Parameter.CoinCount.LabText
	end
	return 0
end

function CommonItemTipsSetNumPassiveComponent:ResetSetComponent()
	self.Parameter.CountDescriptionText.LabColor = Color.New(60/255, 60/255, 60/255, 1)
	self.Parameter.CoinCount.LabColor = Color.New(60/255, 60/255, 60/255, 1)
	self.Parameter.CountDescriptionText.LabText = "Reset_Component"
	self.Parameter.CoinCount.LabText = "Reset_Component"
	self.Parameter.BtnDec:AddClick(function ()
	end)
	self.Parameter.BtnAdd:AddClick(function ()
	end)
end
--lua custom scripts end
return CommonItemTipsSetNumPassiveComponent