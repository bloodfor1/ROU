---@class MoonClient.MComponent
---@field public Player MoonClient.MPlayer
---@field public ComType string
---@field public ID number
---@field public Enabled boolean
---@field public Detached boolean
---@field public Host MoonClient.MObject
---@field public SceneObj MoonClient.MSceneObject
---@field public Entity MoonClient.MEntity
---@field public Role MoonClient.MRole
---@field public Monster MoonClient.MMonster
---@field public Dummy MoonClient.MDummy
---@field public Collection MoonClient.MCollection
---@field public Drop MoonClient.MDrop

---@type MoonClient.MComponent
MoonClient.MComponent = { }
---@param hostObj MoonClient.MObject
function MoonClient.MComponent:OnAttachToHost(hostObj) end
function MoonClient.MComponent:OnDetachFromHost() end
function MoonClient.MComponent:Attached() end
---@param fDeltaT number
function MoonClient.MComponent:Update(fDeltaT) end
---@param fDeltaT number
function MoonClient.MComponent:LateUpdate(fDeltaT) end
function MoonClient.MComponent:AsyncAttached() end
return MoonClient.MComponent
