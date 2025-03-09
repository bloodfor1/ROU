---@class MoonClient.GradualChangeTextShow : MoonClient.BaseGradualChangeShow
---@field public IsUseDateTimeFormat boolean
---@field public ShowTextFormat string

---@type MoonClient.GradualChangeTextShow
MoonClient.GradualChangeTextShow = { }
---@return MoonClient.GradualChangeTextShow
function MoonClient.GradualChangeTextShow.New() end
---@param currentVelua number
function MoonClient.GradualChangeTextShow:ShowValue(currentVelua) end
return MoonClient.GradualChangeTextShow
