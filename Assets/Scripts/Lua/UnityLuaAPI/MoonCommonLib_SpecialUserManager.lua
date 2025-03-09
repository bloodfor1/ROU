---@class MoonCommonLib.SpecialUserManager
---@field public CurrentPlayerTag number

---@type MoonCommonLib.SpecialUserManager
MoonCommonLib.SpecialUserManager = { }
---@overload fun(tag:number): boolean
---@return boolean
---@param tag number
function MoonCommonLib.SpecialUserManager.InitUser(tag) end
---@overload fun(userType:number): boolean
---@return boolean
---@param userTag number
---@param userType number
function MoonCommonLib.SpecialUserManager.MatchUserTag(userTag, userType) end
---@return MoonCommonLib.ISpecialUser
---@param t number
function MoonCommonLib.SpecialUserManager.GetUserHandler(t) end
return MoonCommonLib.SpecialUserManager
