---@class MoonClient.HUDMesh.MHUDMapMesh
---@field public meshRenderer UnityEngine.MeshRenderer
---@field public IsInited boolean

---@type MoonClient.HUDMesh.MHUDMapMesh
MoonClient.HUDMesh.MHUDMapMesh = { }
---@return MoonClient.HUDMesh.MHUDMapMesh
---@param meshName string
---@param atlasName string
---@param initCompleteCb (fun():void)
function MoonClient.HUDMesh.MHUDMapMesh.New(meshName, atlasName, initCompleteCb) end
---@param size number
function MoonClient.HUDMesh.MHUDMapMesh:SetRtSize(size) end
function MoonClient.HUDMesh.MHUDMapMesh:Init() end
function MoonClient.HUDMesh.MHUDMapMesh:BeginDraw() end
---@return MoonSerializable.HUDMesh.SpriteTypeData
---@param spriteName string
function MoonClient.HUDMesh.MHUDMapMesh:GetSpriteData(spriteName) end
---@param spriteName string
---@param position UnityEngine.Vector2
---@param size UnityEngine.Vector2
---@param rotation UnityEngine.Quaternion
function MoonClient.HUDMesh.MHUDMapMesh:AddSprite(spriteName, position, size, rotation) end
function MoonClient.HUDMesh.MHUDMapMesh:OnDraw() end
function MoonClient.HUDMesh.MHUDMapMesh:OnRelease() end
return MoonClient.HUDMesh.MHUDMapMesh
