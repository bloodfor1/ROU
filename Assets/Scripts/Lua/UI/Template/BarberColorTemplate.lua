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
---@class BarberColorTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Image MoonClient.MLuaUICom

---@class BarberColorTemplate : BaseUITemplate
---@field Parameter BarberColorTemplateParameter

BarberColorTemplate = class("BarberColorTemplate", super)
--lua class define end

--lua functions
function BarberColorTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function BarberColorTemplate:OnDestroy()
	
	
end --func end
--next--
function BarberColorTemplate:OnDeActive()
	
	
end --func end
--next--
function BarberColorTemplate:OnSetData(data)
	
	    self:CustomSetData(data)
	
end --func end
--next--
function BarberColorTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
local Str2Color = RoColor.Hex2Color
local l_colorConfig = {
    Str2Color("FFAA44FF"), -- 1  黄
    Str2Color("529A50FF"), -- 2  绿
    Str2Color("B31C32FF"), -- 3  红
    Str2Color("AB7B70FF"), -- 4  浅褐
    Str2Color("7650B5FF"), -- 5  紫
    Str2Color("A8A5A0FF"), -- 6  奶奶灰
    Str2Color("2B2B2BFF"), -- 7  黑
    Str2Color("DBBD9CFF"), -- 8  浅黄
    Str2Color("748964FF"), -- 9  浅绿
    Str2Color("513F44FF"), -- 10 褐
    Str2Color("5EA7F0FF"), -- 11 浅蓝
    Str2Color("E9B295FF"), -- 12 橙
    Str2Color("FFACECFF"), -- 13 浅粉
    Str2Color("9B86BDFF"), -- 14 浅紫
    Str2Color("F3E7F4FF"), -- 15 白
    Str2Color("6167A7FF"), -- 16 蓝
    Str2Color("E874B0FF"), -- 17 粉
    Str2Color("FF9499FF"), -- 18 浅红
}

-- local l_hairConfig = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
-- local l_eyeConfig = {1, 2, 3, 10, 17, 7, 16, 5, 15, 16}

function BarberColorTemplate:CustomSetData(data)

    self.Parameter.Image.Img.color = l_colorConfig[data.colorIndex]
    MLuaCommonHelper.SetRectTransformPos(self.Parameter.Image.gameObject, 25 + (data.index - 1) * 54, -27.5)
end
--lua custom scripts end
return BarberColorTemplate