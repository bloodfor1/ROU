---@class MoonClient.MBuffLuaInfo
---@field public _id uint64
---@field public _appendCount number
---@field public _leftTime number
---@field public _updateTime int64
---@field public _remainTime number
---@field public _totalTime number
---@field public _buffId number
---@field public _couldCancel boolean
---@field public _buffStateType number
---@field public _buffAttrDecision System.Collections.Generic.Dictionary_System.Int32_System.Int32

---@type MoonClient.MBuffLuaInfo
MoonClient.MBuffLuaInfo = { }
---@return MoonClient.MBuffLuaInfo
function MoonClient.MBuffLuaInfo.New() end
---@param id uint64
---@param buff MoonClient.MBuff
function MoonClient.MBuffLuaInfo:Init(id, buff) end
return MoonClient.MBuffLuaInfo
