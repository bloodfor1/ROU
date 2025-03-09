---@class MoonClient.MAttrRole : MoonClient.MAttrComponent
---@field public GuildId int64
---@field public GuildName string
---@field public GuildPositionId number
---@field public GuildPositionName string
---@field public GuildIconId number
---@field public Floor number
---@field public TitleId number
---@field public TagId number
---@field public ProfessionID number
---@field public CommonAttackSkillID number
---@field public ProfessionData MoonClient.ProfessionTable.RowData
---@field public RoleSkillMap System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@field public RoleSkillMapTransfigured System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@field public Name string
---@field public RoleBuffSkillMap System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@field public IsHideOutlookWhenBeWatched boolean

---@type MoonClient.MAttrRole
MoonClient.MAttrRole = { }
---@return MoonClient.MAttrRole
function MoonClient.MAttrRole.New() end
function MoonClient.MAttrRole:Reset() end
return MoonClient.MAttrRole
