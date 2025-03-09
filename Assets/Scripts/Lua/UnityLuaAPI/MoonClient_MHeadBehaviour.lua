---@class MoonClient.MHeadBehaviour : UnityEngine.MonoBehaviour
---@field public CombineParent UnityEngine.GameObject
---@field public images UnityEngine.UI.Image[]
---@field public Single UnityEngine.UI.Image
---@field public Frame UnityEngine.UI.Image
---@field public FrameBottom UnityEngine.UI.Image
---@field public mask UnityEngine.UI.Mask
---@field public maskImage UnityEngine.UI.Image

---@type MoonClient.MHeadBehaviour
MoonClient.MHeadBehaviour = { }
---@return MoonClient.MHeadBehaviour
function MoonClient.MHeadBehaviour.New() end
---@param value boolean
function MoonClient.MHeadBehaviour:UseMask(value) end
---@param src MoonClient.MEntity
function MoonClient.MHeadBehaviour:SetHead(src) end
---@overload fun(headID:number): void
---@param equip MoonClient.MEquipData
function MoonClient.MHeadBehaviour:SetRoleHead(equip) end
---@param frame number
function MoonClient.MHeadBehaviour:SetFrame(frame) end
---@param active boolean
function MoonClient.MHeadBehaviour:SetFrameActive(active) end
---@param entityID number
function MoonClient.MHeadBehaviour:SetMonsterHead(entityID) end
---@param npcId number
function MoonClient.MHeadBehaviour:SetNPCHead(npcId) end
---@param destroy boolean
function MoonClient.MHeadBehaviour:ReleaseHead(destroy) end
return MoonClient.MHeadBehaviour
