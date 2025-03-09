---@class MoonClient.MLuaUIGroup : UnityEngine.MonoBehaviour
---@field public Name string
---@field public ClassName string
---@field public IsGenerateCodeInUpper boolean
---@field public IsCreateTemplateWithCreatePanel boolean
---@field public ComRefs MoonClient.MLuaUICom[]
---@field public Canvases UnityEngine.Canvas[]
---@field public Raycasters MoonClient.MGraphicRaycaster[]
---@field public Groups MoonClient.MLuaUIGroup[]
---@field public RectTransform UnityEngine.RectTransform

---@type MoonClient.MLuaUIGroup
MoonClient.MLuaUIGroup = { }
---@return MoonClient.MLuaUIGroup
function MoonClient.MLuaUIGroup.New() end
---@param isVisible boolean
function MoonClient.MLuaUIGroup:SetVisible(isVisible) end
function MoonClient.MLuaUIGroup:ClearAllComponent() end
---@param isEnabled boolean
function MoonClient.MLuaUIGroup:SetRaycastersEnabled(isEnabled) end
return MoonClient.MLuaUIGroup
