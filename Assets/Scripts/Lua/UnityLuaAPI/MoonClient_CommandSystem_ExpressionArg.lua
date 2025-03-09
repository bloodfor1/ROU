---@class MoonClient.CommandSystem.ExpressionArg : MoonClient.CommandSystem.CommandBlockArg
---@field public Value string

---@type MoonClient.CommandSystem.ExpressionArg
MoonClient.CommandSystem.ExpressionArg = { }
---@return MoonClient.CommandSystem.ExpressionArg
function MoonClient.CommandSystem.ExpressionArg.New() end
---@return MoonClient.CommandSystem.ExpressionArg
---@param expression string
function MoonClient.CommandSystem.ExpressionArg:Init(expression) end
function MoonClient.CommandSystem.ExpressionArg:Release() end
---@return System.Object
function MoonClient.CommandSystem.ExpressionArg:Clone() end
return MoonClient.CommandSystem.ExpressionArg
