---@class MoonClient.HUDMesh.MHUDMapTxtMesh
---@field public FontPercentWidth number
---@field public AutoAdaptBorderTxtPos boolean
---@field public meshRenderer UnityEngine.MeshRenderer

---@type MoonClient.HUDMesh.MHUDMapTxtMesh
MoonClient.HUDMesh.MHUDMapTxtMesh = { }
---@return MoonClient.HUDMesh.MHUDMapTxtMesh
---@param meshName string
function MoonClient.HUDMesh.MHUDMapTxtMesh.New(meshName) end
function MoonClient.HUDMesh.MHUDMapTxtMesh:Init() end
---@param size number
function MoonClient.HUDMesh.MHUDMapTxtMesh:SetRtSize(size) end
---@return MoonClient.MDoublyList_MoonClient.HUDMesh.MTextData.ListNode
function MoonClient.HUDMesh.MHUDMapTxtMesh:GetTxtData() end
---@param node MoonClient.MDoublyList.ListNode_MoonClient.HUDMesh.MTextData
function MoonClient.HUDMesh.MHUDMapTxtMesh:ReleaseTxtData(node) end
function MoonClient.HUDMesh.MHUDMapTxtMesh:OnDraw() end
function MoonClient.HUDMesh.MHUDMapTxtMesh:OnRelease() end
return MoonClient.HUDMesh.MHUDMapTxtMesh
