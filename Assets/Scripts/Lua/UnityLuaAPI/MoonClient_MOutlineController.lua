---@class MoonClient.MOutlineController
---@field public Deprecated boolean
---@field public IgnoreOutline boolean
---@field public ForceGeometryOutline boolean

---@type MoonClient.MOutlineController
MoonClient.MOutlineController = { }
---@return MoonClient.MOutlineController
function MoonClient.MOutlineController.New() end
---@param renderer UnityEngine.Renderer
---@param colorTypePosID number
---@param keyWord string
function MoonClient.MOutlineController:AddRendererToOutlineBuffer(renderer, colorTypePosID, keyWord) end
return MoonClient.MOutlineController
