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
---@class CommonItemTipsSetNumTemplentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field CommonItemTipsSetNumComponent MoonClient.MLuaUICom
---@field CountDescriptionText MoonClient.MLuaUICom
---@field SetNumCount MoonClient.MLuaUICom
---@field SetNumtxt MoonClient.MLuaUICom
---@field CoinIcon MoonClient.MLuaUICom

---@class CommonItemTipsSetNumTemplent : BaseUITemplate
---@field Parameter CommonItemTipsSetNumTemplentParameter

CommonItemTipsSetNumTemplent = class("CommonItemTipsSetNumTemplent", super)
--lua class define end

--lua functions
function CommonItemTipsSetNumTemplent:Init()

	    super.Init(self)

    self.Parameter.SetNumCount.InputNumber.OnAddButtonClick = nil
    self.Parameter.SetNumCount.InputNumber.OnSubtractButtonClick = nil
end --func end
--next--
function CommonItemTipsSetNumTemplent:OnDestroy()


end --func end
--next--
function CommonItemTipsSetNumTemplent:OnSetData(data)


end --func end
--next--
function CommonItemTipsSetNumTemplent:BindEvents()


end --func end
--next--
function CommonItemTipsSetNumTemplent:OnDeActive()


end --func end
--next--
--lua functions end

--lua custom scripts

CommonItemTipsSetNumTemplent.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsSetNumComponent"

--参数 1 字符串显示的内容
--参数 2 初始化数值
--参数 3 初始化最小数值
--参数 4 初始化最大数值
--参数 5 增加间隔
--参数 6 最大回调
--参数 7 字符串显示的颜色
--参数 8 字符串显示的颜色
--参数 9 显示Coin的图标信息
--- InputNumber 当中参数是long类型
function CommonItemTipsSetNumTemplent:SetInfo(cSetNumTxt,cInitValue,cMinValue,cMaxValue,cChangeInterval,cMaxValueMethod,cSetNumTxtColor,cSetNumColor,CoinIconData,isShowButton)
    self.Parameter.CountDescriptionText.LabText = cSetNumTxt
    self.Parameter.SetNumCount.InputNumber.MinValue = cMinValue ~= nil and cMinValue or 1
    self.Parameter.SetNumCount.InputNumber.MaxValue = cMaxValue ~= nil and cMaxValue or 1
    self.Parameter.SetNumCount.InputNumber:SetValue(cInitValue)
    self.Parameter.SetNumCount.InputNumber.ChangeInterval = cChangeInterval ~= nil and cChangeInterval or 1
    if cMaxValueMethod then
        self.Parameter.SetNumCount.InputNumber.OnMaxValueMethod = cMaxValueMethod
    end
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
    if isShowButton ~= nil then
        if not isShowButton then
            self.Parameter.SetNumCount.InputNumber.AddButton.gameObject:SetActiveEx(false)
            self.Parameter.SetNumCount.InputNumber.SubtractButton.gameObject:SetActiveEx(false)
            self.Parameter.SetNumCount.InputNumber.ClickButton.enabled = false
        end
    end
end

function CommonItemTipsSetNumTemplent:SetInputNumListener(cInputNumListener)
    if cInputNumListener then
        self.Parameter.SetNumCount.InputNumber.OnValueChange = cInputNumListener
    end
end

--返回当前设置数值
function CommonItemTipsSetNumTemplent:GetNumComponentValue()
    if self.Parameter.SetNumCount then
        return self.Parameter.SetNumCount.InputNumber:GetValue()
    end
    return 0
end

function CommonItemTipsSetNumTemplent:ResetSetComponent()
    self.Parameter.CountDescriptionText.LabColor = Color.New(60/255, 60/255, 60/255, 1)
    self.Parameter.CountDescriptionText.LabColor = Color.New(60/255, 60/255, 60/255, 1)
    self.Parameter.SetNumCount.InputNumber:SetValue(1)
    self.Parameter.SetNumCount.InputNumber.MinValue = 1
    self.Parameter.SetNumCount.InputNumber.MaxValue = 99999
    self.Parameter.CountDescriptionText.LabText = "Reset_Component"
    self.Parameter.CoinIcon.gameObject:SetActiveEx(false)
    self.Parameter.SetNumCount.InputNumber.OnMaxValueMethod = nil
    self.Parameter.SetNumCount.InputNumber.OnValueChange = nil
    self.Parameter.SetNumCount.InputNumber.ChangeInterval = 1
    self.Parameter.SetNumCount.InputNumber.AddButton.gameObject:SetActiveEx(true)
    self.Parameter.SetNumCount.InputNumber.SubtractButton.gameObject:SetActiveEx(true)
    self.Parameter.SetNumCount.InputNumber.ClickButton.enabled = true
    self.Parameter.SetNumCount.InputNumber:CloseInputNumber()
    self.Parameter.SetNumCount.InputNumber:SetMaxButtonDisplay(false)
end

function CommonItemTipsSetNumTemplent:SetMaxButtonDisplay(visible)
    self.Parameter.SetNumCount.InputNumber:SetMaxButtonDisplay(visible)
end


--lua custom scripts end
return CommonItemTipsSetNumTemplent