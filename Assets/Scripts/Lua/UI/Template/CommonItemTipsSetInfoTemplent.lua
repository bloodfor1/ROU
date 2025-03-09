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
---@class CommonItemTipsSetInfoTemplentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field CommonItemTipsSetInfoComponent MoonClient.MLuaUICom
---@field CountDescriptionText MoonClient.MLuaUICom
---@field CoinIcon MoonClient.MLuaUICom
---@field CountCount MoonClient.MLuaUICom
---@field BtnTips MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field CloseExplainPanelButton MoonClient.MLuaUICom
---@field TextMessage MoonClient.MLuaUICom

---@class CommonItemTipsSetInfoTemplent : BaseUITemplate
---@field Parameter CommonItemTipsSetInfoTemplentParameter

CommonItemTipsSetInfoTemplent = class("CommonItemTipsSetInfoTemplent", super)
--lua class define end

--lua functions
function CommonItemTipsSetInfoTemplent:Init()
	
	    super.Init(self)
	
end --func end
--next--
function CommonItemTipsSetInfoTemplent:OnDestroy()
	
	
end --func end
--next--
function CommonItemTipsSetInfoTemplent:OnSetData(data)
	
	
end --func end
--next--
function CommonItemTipsSetInfoTemplent:OnDeActive()
	
	
end --func end
--next--
function CommonItemTipsSetInfoTemplent:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
CommonItemTipsSetInfoTemplent.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsSetInfoComponent"

--参数 1 字符串显示的内容
--参数 2 初始化数值
--参数 3 字符串显示的颜色
--参数 4 字符串显示的颜色
--参数 5 显示Coin的图标信息
--参数 6 显示Tips相关
function CommonItemTipsSetInfoTemplent:SetInfo(cSetNumTxt,cCountValue,cSetInfoTxtColor,cSetInfoColor,CoinIconData,TipsData)
	self.Parameter.CountDescriptionText.LabText = cSetNumTxt
	self.Parameter.CountCount.LabText = tostring(cCountValue)
	if cSetInfoTxtColor then
		self.Parameter.CountDescriptionText.LabColor = cSetInfoTxtColor
	end
	if cSetInfoColor then
		self.Parameter.CountCount.LabColor = cSetInfoColor
	end
	
	if CoinIconData then
		if CoinIconData.ItemAtlas and CoinIconData.ItemIcon then
			self.Parameter.CoinIcon:SetSprite(CoinIconData.ItemAtlas, CoinIconData.ItemIcon,true)
			MLuaCommonHelper.SetLocalScale(self.Parameter.CoinIcon.gameObject,0.38,0.38,0.38)
		else
			logError("数据传输有误::CoinIconData.ItemAtlas or CoinIconData.ItemIcon")
		end
		if CoinIconData.ItemID then
			self.bindItemId = CoinIconData.ItemID
			self.Parameter.CountCount.LabText = Common.CommonUIFunc.ShowCoinStatusText(CoinIconData.ItemID,cCountValue)
		end
		self.Parameter.CoinIcon.gameObject:SetActiveEx(true)
	else
		self.Parameter.CoinIcon.gameObject:SetActiveEx(false)
	end
	if TipsData then
		self.Parameter.BtnTips:SetActiveEx(true)
		self.Parameter.BtnTips:AddClick(function ()
			self.Parameter.ExplainPanel:SetActiveEx(true)
			self.Parameter.TextMessage.LabText = TipsData.text
		end)
		self.Parameter.CloseExplainPanelButton:AddClick(function ()
			self.Parameter.ExplainPanel:SetActiveEx(false)
		end)
	else
		self.Parameter.BtnTips:SetActiveEx(false)
	end
end

function CommonItemTipsSetInfoTemplent:SetCountText(value)
	if self.bindItemId then
		self.Parameter.CountCount.LabText = Common.CommonUIFunc.ShowCoinStatusText(self.bindItemId,value)
	else
		self.Parameter.CountCount.LabText = tostring(value)
	end
end

function CommonItemTipsSetInfoTemplent:ResetSetComponent()
	self.Parameter.CountDescriptionText.LabColor = UIDefineColor.SmallTitleColor --UIDefineColor. Color.New(60/255, 60/255, 60/255, 1)
	self.Parameter.CountCount.LabColor = UIDefineColor.SmallTitleColor--Color.New(60/255, 60/255, 60/255, 1)
	self.Parameter.CountDescriptionText.LabText = "Reset_Component"
	self.Parameter.CountCount.LabText = "Reset_Component"
	self.Parameter.CoinIcon.gameObject:SetActiveEx(false)
	self.Parameter.TextMessage.LabText = "Reset_Component"
	self.Parameter.BtnTips:SetActiveEx(false)
	self.Parameter.ExplainPanel:SetActiveEx(false)
	self.bindItemId = nil
end

function CommonItemTipsSetInfoTemplent:GetInfoComponentValue()
	if self.Parameter.CountCount then
		return tonumber(self.Parameter.CountCount.LabText) or 0
	end
	return 0
end
--lua custom scripts end
return CommonItemTipsSetInfoTemplent