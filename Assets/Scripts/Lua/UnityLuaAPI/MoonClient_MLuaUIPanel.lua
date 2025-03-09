---@class MoonClient.MLuaUIPanel : UnityEngine.MonoBehaviour
---@field public IsHandler boolean
---@field public IsGenerateOnShow boolean
---@field public ComRefs MoonClient.MLuaUICom[]
---@field public Groups MoonClient.MLuaUIGroup[]
---@field public AtlasNames System.String[]
---@field public HandlerRef MoonClient.MLuaUICom
---@field public Canvases UnityEngine.Canvas[]
---@field public Raycasters MoonClient.MGraphicRaycaster[]
---@field public IsFullScreen boolean

---@type MoonClient.MLuaUIPanel
MoonClient.MLuaUIPanel = { }
---@return MoonClient.MLuaUIPanel
function MoonClient.MLuaUIPanel.New() end
---@param trans UnityEngine.Transform
function MoonClient.MLuaUIPanel.CheckTextNode(trans) end
---@param isVisible boolean
function MoonClient.MLuaUIPanel:SetVisible(isVisible) end
function MoonClient.MLuaUIPanel:ClearAllComponent() end
---@param isEnabled boolean
function MoonClient.MLuaUIPanel:SetRaycastersEnabled(isEnabled) end
return MoonClient.MLuaUIPanel
