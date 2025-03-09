---@class MoonClient.MSkillInfo
---@field public id number
---@field public lv number
---@field public currentSkillId number
---@field public currentSkillLv number
---@field public currentSkillEffectId number
---@field public effectId number
---@field public InfoSource number
---@field public LastId number
---@field public LastLv number
---@field public ReplaceSkillId number
---@field public ReplaceSkillLv number
---@field public ReplaceSkillEffectId number
---@field public LastReplaceSkillId number
---@field public LastReplaceLv number

---@type MoonClient.MSkillInfo
MoonClient.MSkillInfo = { }
---@return MoonClient.MSkillInfo
function MoonClient.MSkillInfo.New() end
---@param id number
function MoonClient.MSkillInfo:ReplaceId(id) end
---@param id number
---@param lv number
function MoonClient.MSkillInfo:Replace(id, lv) end
function MoonClient.MSkillInfo:Resume() end
function MoonClient.MSkillInfo:Reset() end
---@param info MoonClient.MSkillInfo
function MoonClient.MSkillInfo:Copy(info) end
return MoonClient.MSkillInfo
