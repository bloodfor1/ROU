---@class MoonClient.MSceneCommonSliderHUD
---@field public billBoardPath string
---@field public IsPlaying boolean
---@field public MType number
---@field public SliderObj MoonClient.MGameObject
---@field public IsInit boolean
---@field public SliderEndFuc (fun():void)
---@field public BindGameObject UnityEngine.GameObject

---@type MoonClient.MSceneCommonSliderHUD
MoonClient.MSceneCommonSliderHUD = { }
---@return MoonClient.MSceneCommonSliderHUD
function MoonClient.MSceneCommonSliderHUD.New() end
---@param cTotalTime number
---@param cPlayTime number
---@param cType number
function MoonClient.MSceneCommonSliderHUD:Init(cTotalTime, cPlayTime, cType) end
---@param cTotalTime number
---@param cStartTime number
function MoonClient.MSceneCommonSliderHUD:SetBarAndPlay(cTotalTime, cStartTime) end
---@param txt string
---@param atlasName string
---@param iconName string
function MoonClient.MSceneCommonSliderHUD:SetCircularbarIconAndTxt(txt, atlasName, iconName) end
function MoonClient.MSceneCommonSliderHUD:setCircularbarIcon() end
---@param pos UnityEngine.Vector3
---@param isShow boolean
function MoonClient.MSceneCommonSliderHUD:SetSliderPos(pos, isShow) end
---@param pos UnityEngine.Vector2
---@param isShow boolean
function MoonClient.MSceneCommonSliderHUD:SetSliderPosByV2(pos, isShow) end
function MoonClient.MSceneCommonSliderHUD:BarPlayEnd() end
function MoonClient.MSceneCommonSliderHUD:StopPlay() end
function MoonClient.MSceneCommonSliderHUD:Release() end
---@param fDelta number
function MoonClient.MSceneCommonSliderHUD:Update(fDelta) end
function MoonClient.MSceneCommonSliderHUD:SetPos() end
return MoonClient.MSceneCommonSliderHUD
