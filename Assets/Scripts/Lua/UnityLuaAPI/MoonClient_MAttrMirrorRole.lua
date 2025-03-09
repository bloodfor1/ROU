---@class MoonClient.MAttrMirrorRole : MoonClient.MAttrComponent
---@field public OwnerUID uint64
---@field public ProfessionID number
---@field public ProfessionData MoonClient.ProfessionTable.RowData
---@field public GuildId int64
---@field public GuildName string
---@field public GuildPositionId number
---@field public GuildPositionName string
---@field public GuildIconId number
---@field public WatchRoomId number
---@field public TitleId number

---@type MoonClient.MAttrMirrorRole
MoonClient.MAttrMirrorRole = { }
---@return MoonClient.MAttrMirrorRole
function MoonClient.MAttrMirrorRole.New() end
function MoonClient.MAttrMirrorRole:Reset() end
return MoonClient.MAttrMirrorRole
