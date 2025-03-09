---@class MoonClient.MTransfigureComponent : MoonClient.MComponent
---@field public ID number

---@type MoonClient.MTransfigureComponent
MoonClient.MTransfigureComponent = { }
---@return MoonClient.MTransfigureComponent
function MoonClient.MTransfigureComponent.New() end
function MoonClient.MTransfigureComponent:OnDetachFromHost() end
---@param hostObj MoonClient.MObject
function MoonClient.MTransfigureComponent:OnAttachToHost(hostObj) end
---@param id number
function MoonClient.MTransfigureComponent:Transfigure(id) end
return MoonClient.MTransfigureComponent
