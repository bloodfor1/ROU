---@class MoonClient.MUIManager : MoonCommonLib.MSingleton_MoonClient.MUIManager
---@field public SKILL_CONTORLLER string
---@field public MOVE_CONTROLLER string
---@field public SCENE_OBJ_CONTROLLER string
---@field public CUTSCENEJUMP_CONTROLLER string
---@field public CUTSCENECV_CONTROLLER string
---@field public STORY_WORD_CONTROLLER string
---@field public CUTSCENEIMAGE_CONTROLLER string
---@field public CUTSCENEFULLSCREENVIDEO_CONTROLLER string
---@field public UIEmptyMat UnityEngine.Material
---@field public UIMat UnityEngine.Material
---@field public UICamera UnityEngine.Camera
---@field public UIRoot UnityEngine.GameObject
---@field public IsMatchHeight boolean
---@field public EventSystem UnityEngine.EventSystems.EventSystem
---@field public RectTransformuiRoot UnityEngine.RectTransform
---@field public TransHUD UnityEngine.Transform
---@field public RectTransHUD UnityEngine.RectTransform
---@field public TransNormal UnityEngine.Transform
---@field public RectTransNormal UnityEngine.RectTransform
---@field public TransFunction UnityEngine.Transform
---@field public RectTransFunction UnityEngine.RectTransform
---@field public TransTips UnityEngine.Transform
---@field public RectTransTips UnityEngine.RectTransform
---@field public TransGuiding UnityEngine.Transform
---@field public RectTransGuiding UnityEngine.RectTransform
---@field public TransTop UnityEngine.Transform
---@field public RectTransTop UnityEngine.RectTransform
---@field public TransBubbleHUD UnityEngine.Transform
---@field public UIWorldRoot UnityEngine.GameObject
---@field public ChatRoomRoot UnityEngine.GameObject
---@field public TransWorldRoot UnityEngine.Transform
---@field public SpectatorRoot UnityEngine.GameObject
---@field public HasExclusive boolean
---@field public LastClickTime number
---@field public IsHideAllUI boolean

---@type MoonClient.MUIManager
MoonClient.MUIManager = { }
---@return MoonClient.MUIManager
function MoonClient.MUIManager.New() end
---@param time number
function MoonClient.MUIManager:CrossFadeIn(time) end
---@param time number
function MoonClient.MUIManager:CrossFadeOut(time) end
---@return boolean
function MoonClient.MUIManager:Init() end
---@param scaler UnityEngine.UI.CanvasScaler
function MoonClient.MUIManager:UpdatedMatchWidthOrHeight(scaler) end
---@return UnityEngine.Vector2
function MoonClient.MUIManager:GetCanvasScalerReferenceResolution() end
---@param pixelDragThreshold number
function MoonClient.MUIManager:SetPixelDragThreshold(pixelDragThreshold) end
function MoonClient.MUIManager:Uninit() end
---@return MoonClient.MBaseUI
---@param uiName string
---@param useTween boolean
function MoonClient.MUIManager:ShowUI(uiName, useTween) end
---@return MoonClient.MBaseUI
---@param uiName string
---@param useTween boolean
function MoonClient.MUIManager:HideUI(uiName, useTween) end
---@return MoonClient.MBaseUI
---@param uiName string
---@param ignoreTween boolean
function MoonClient.MUIManager:ActiveUI(uiName, ignoreTween) end
---@return MoonClient.MBaseUI
---@param uiName string
---@param ignoreTween boolean
function MoonClient.MUIManager:DeActiveUI(uiName, ignoreTween) end
function MoonClient.MUIManager:DeActiveAll() end
---@return MoonClient.MBaseUI
---@param uiName string
function MoonClient.MUIManager:GetUI(uiName) end
---@param fDeltaT number
function MoonClient.MUIManager:Update(fDeltaT) end
---@param touch MoonClient.MTouchItem
function MoonClient.MUIManager:UpdateTouch(touch) end
function MoonClient.MUIManager:LateUpdate() end
---@param clearAccountData boolean
function MoonClient.MUIManager:OnLogout(clearAccountData) end
function MoonClient.MUIManager:RefreshSafeArea() end
---@param hideNomrals boolean
function MoonClient.MUIManager:RefreshUILayerInfo(hideNomrals) end
---@return number
---@param size UnityEngine.Vector2
function MoonClient.MUIManager:GetFullScreenScale(size) end
---@return UnityEngine.Vector2
function MoonClient.MUIManager:GetUIScreenSize() end
---@return boolean
---@param worldPos UnityEngine.Vector3
function MoonClient.MUIManager:IsWorldPosInScreen(worldPos) end
---@return boolean
function MoonClient.MUIManager:IsWorldHudVisible() end
---@param uiName string
function MoonClient.MUIManager:AddIgnoreHideUI(uiName) end
---@param uiName string
function MoonClient.MUIManager:RemoveIgnoreHideUI(uiName) end
---@param uiName string
function MoonClient.MUIManager:AddForceHideUI(uiName) end
---@param uiName string
function MoonClient.MUIManager:RemoveForceHideUI(uiName) end
return MoonClient.MUIManager
