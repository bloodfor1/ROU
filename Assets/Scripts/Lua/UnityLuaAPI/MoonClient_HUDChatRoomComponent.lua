---@class MoonClient.HUDChatRoomComponent : MoonClient.MComponent
---@field public ID number

---@type MoonClient.HUDChatRoomComponent
MoonClient.HUDChatRoomComponent = { }
---@return MoonClient.HUDChatRoomComponent
function MoonClient.HUDChatRoomComponent.New() end
---@param hostObj MoonClient.MObject
function MoonClient.HUDChatRoomComponent:OnAttachToHost(hostObj) end
function MoonClient.HUDChatRoomComponent:OnDetachFromHost() end
---@param fDeltaT number
function MoonClient.HUDChatRoomComponent:Update(fDeltaT) end
---@param uid uint64
---@param content string
---@param hasCode boolean
---@param isCaptain boolean
function MoonClient.HUDChatRoomComponent:SetRoomInfo(uid, content, hasCode, isCaptain) end
---@return UnityEngine.Vector3
function MoonClient.HUDChatRoomComponent:GetTopPoint() end
return MoonClient.HUDChatRoomComponent
