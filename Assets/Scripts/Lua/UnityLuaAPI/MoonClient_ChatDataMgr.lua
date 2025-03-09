---@class MoonClient.ChatDataMgr

---@type MoonClient.ChatDataMgr
MoonClient.ChatDataMgr = { }
---@return MoonClient.ChatDataMgr
function MoonClient.ChatDataMgr.New() end
function MoonClient.ChatDataMgr:Open() end
function MoonClient.ChatDataMgr:Close() end
---@param tableName string
function MoonClient.ChatDataMgr:CreateTable(tableName) end
---@param data MoonClient.ChatDataMgr.ChatData
function MoonClient.ChatDataMgr:SaveData(data) end
---@return System.Collections.Generic.List_MoonClient.ChatDataMgr.ChatData
function MoonClient.ChatDataMgr:GetDatas() end
function MoonClient.ChatDataMgr:DeleteDatas() end
return MoonClient.ChatDataMgr
