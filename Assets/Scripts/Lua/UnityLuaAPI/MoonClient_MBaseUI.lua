---@class MoonClient.MBaseUI
---@field public AutoUnload boolean
---@field public TweenTime number
---@field public TweenDelta number
---@field public LayerType number
---@field public IgnoreHideUINames System.Collections.Generic.HashSet_System.String
---@field public ForceHideUINames System.Collections.Generic.HashSet_System.String
---@field public TweenType number
---@field public IsInited boolean
---@field public UIName string
---@field public IsTweening boolean
---@field public IsActived boolean
---@field public IsHided boolean
---@field public IsShowing boolean
---@field public ActiveType number
---@field public IgnoreWhenDeActiveAll boolean
---@field public MObj MoonClient.MUIGameObject

---@type MoonClient.MBaseUI
MoonClient.MBaseUI = { }
---@return MoonClient.MBaseUI
---@param uiName string
---@param layer number
function MoonClient.MBaseUI.New(uiName, layer) end
function MoonClient.MBaseUI:Init() end
function MoonClient.MBaseUI:Uninit() end
---@param deltaTime number
function MoonClient.MBaseUI:Update(deltaTime) end
---@param deltaTime number
function MoonClient.MBaseUI:LateUpdate(deltaTime) end
function MoonClient.MBaseUI:OnLogout() end
---@param touch MoonClient.MTouchItem
function MoonClient.MBaseUI:UpdateTouch(touch) end
---@return UnityEngine.GameObject
---@param go UnityEngine.GameObject
function MoonClient.MBaseUI:CloneObj(go) end
---@param stepId number
function MoonClient.MBaseUI:ShowBeginnerGuide(stepId) end
---@param isForce boolean
function MoonClient.MBaseUI:CloseBeginnerGuideArrow(isForce) end
function MoonClient.MBaseUI:SetAsLastSibling() end
return MoonClient.MBaseUI
