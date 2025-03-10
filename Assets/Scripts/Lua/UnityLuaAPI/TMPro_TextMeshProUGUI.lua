---@class TMPro.TextMeshProUGUI : TMPro.TMP_Text
---@field public materialForRendering UnityEngine.Material
---@field public autoSizeTextContainer boolean
---@field public mesh UnityEngine.Mesh
---@field public canvasRenderer UnityEngine.CanvasRenderer
---@field public maskOffset UnityEngine.Vector4

---@type TMPro.TextMeshProUGUI
TMPro.TextMeshProUGUI = { }
---@return TMPro.TextMeshProUGUI
function TMPro.TextMeshProUGUI.New() end
function TMPro.TextMeshProUGUI:CalculateLayoutInputHorizontal() end
function TMPro.TextMeshProUGUI:CalculateLayoutInputVertical() end
function TMPro.TextMeshProUGUI:SetVerticesDirty() end
function TMPro.TextMeshProUGUI:SetLayoutDirty() end
function TMPro.TextMeshProUGUI:SetMaterialDirty() end
function TMPro.TextMeshProUGUI:SetAllDirty() end
---@param update number
function TMPro.TextMeshProUGUI:Rebuild(update) end
---@return UnityEngine.Material
---@param baseMaterial UnityEngine.Material
function TMPro.TextMeshProUGUI:GetModifiedMaterial(baseMaterial) end
function TMPro.TextMeshProUGUI:RecalculateClipping() end
function TMPro.TextMeshProUGUI:RecalculateMasking() end
---@param clipRect UnityEngine.Rect
---@param validRect boolean
function TMPro.TextMeshProUGUI:Cull(clipRect, validRect) end
function TMPro.TextMeshProUGUI:UpdateMeshPadding() end
---@overload fun(): void
---@param ignoreInactive boolean
function TMPro.TextMeshProUGUI:ForceMeshUpdate(ignoreInactive) end
---@return TMPro.TMP_TextInfo
---@param text string
function TMPro.TextMeshProUGUI:GetTextInfo(text) end
function TMPro.TextMeshProUGUI:ClearMesh() end
---@param mesh UnityEngine.Mesh
---@param index number
function TMPro.TextMeshProUGUI:UpdateGeometry(mesh, index) end
---@overload fun(): void
---@param flags number
function TMPro.TextMeshProUGUI:UpdateVertexData(flags) end
function TMPro.TextMeshProUGUI:UpdateFontAsset() end
return TMPro.TextMeshProUGUI
