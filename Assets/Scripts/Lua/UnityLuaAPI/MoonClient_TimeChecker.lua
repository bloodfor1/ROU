---@class MoonClient.TimeChecker

---@type MoonClient.TimeChecker
MoonClient.TimeChecker = { }
---@overload fun(): MoonClient.TimeChecker
---@overload fun(givenTime:number): MoonClient.TimeChecker
---@return MoonClient.TimeChecker
---@param givenTime int64
function MoonClient.TimeChecker.New(givenTime) end
function MoonClient.TimeChecker:Start() end
---@overload fun(): boolean
---@overload fun(givenTime:number): boolean
---@return boolean
---@param givenTime int64
function MoonClient.TimeChecker:IsBeyondGivenTime(givenTime) end
return MoonClient.TimeChecker
