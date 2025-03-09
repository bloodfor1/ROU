---@class MoonClient.MUISlider : UnityEngine.UI.Slider
---@field public IsColorReverse boolean

---@type MoonClient.MUISlider
MoonClient.MUISlider = { }
---@return MoonClient.MUISlider
function MoonClient.MUISlider.New() end
function MoonClient.MUISlider:TestSliderAdd() end
function MoonClient.MUISlider:TestSliderDec() end
---@param targetValue number
---@param tweenTime number
function MoonClient.MUISlider:SetSlider(targetValue, tweenTime) end
function MoonClient.MUISlider:SetSliderColorImg() end
---@param atName string
---@param spName string
function MoonClient.MUISlider:SetImg(atName, spName) end
return MoonClient.MUISlider
