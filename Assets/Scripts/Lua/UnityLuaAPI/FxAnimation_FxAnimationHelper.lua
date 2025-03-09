---@class FxAnimation.FxAnimationHelper : UnityEngine.MonoBehaviour
---@field public Helpers FxAnimation.HelperData[]
---@field public Repeat number
---@field public RepeatCheck number
---@field public PlayOnEnable boolean
---@field public IsStatic boolean
---@field public HelperID number
---@field public StateShotDict System.Collections.Generic.Dictionary_UnityEngine.Object_MoonCommonLib.StateShot

---@type FxAnimation.FxAnimationHelper
FxAnimation.FxAnimationHelper = { }
---@return FxAnimation.FxAnimationHelper
function FxAnimation.FxAnimationHelper.New() end
function FxAnimation.FxAnimationHelper:PlayAll() end
function FxAnimation.FxAnimationHelper:PlayAllOnce() end
---@param func (fun():void)
---@param index number
function FxAnimation.FxAnimationHelper:addFinishCallbackByIndex(func, index) end
function FxAnimation.FxAnimationHelper:StopAll() end
---@param helper FxAnimation.HelperData
function FxAnimation.FxAnimationHelper:Stop(helper) end
---@param v number
function FxAnimation.FxAnimationHelper:SetSpeed(v) end
---@param h FxAnimation.HelperData
function FxAnimation.FxAnimationHelper:Play(h) end
---@param time number
function FxAnimation.FxAnimationHelper:SetPlayTime(time) end
---@return number
function FxAnimation.FxAnimationHelper:GetFxAnimTotalPlayTime() end
function FxAnimation.FxAnimationHelper:InitHelper() end
---@return number
---@param helper FxAnimation.HelperData
function FxAnimation.FxAnimationHelper:AddHelper(helper) end
function FxAnimation.FxAnimationHelper:InitData() end
return FxAnimation.FxAnimationHelper
