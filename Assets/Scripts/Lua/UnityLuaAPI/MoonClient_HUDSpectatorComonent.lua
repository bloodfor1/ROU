---@class MoonClient.HUDSpectatorComonent : MoonClient.MComponent
---@field public ID number
---@field public RoomVisible boolean
---@field public SceneVisible boolean

---@type MoonClient.HUDSpectatorComonent
MoonClient.HUDSpectatorComonent = { }
---@return MoonClient.HUDSpectatorComonent
function MoonClient.HUDSpectatorComonent.New() end
---@param hostObj MoonClient.MObject
function MoonClient.HUDSpectatorComonent:OnAttachToHost(hostObj) end
function MoonClient.HUDSpectatorComonent:OnDetachFromHost() end
---@param fDeltaT number
function MoonClient.HUDSpectatorComonent:Update(fDeltaT) end
---@param uid uint64
function MoonClient.HUDSpectatorComonent:SetSpectatorInfo(uid) end
return MoonClient.HUDSpectatorComonent
