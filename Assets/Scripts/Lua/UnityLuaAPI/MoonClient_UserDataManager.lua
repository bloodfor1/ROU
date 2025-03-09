---@class MoonClient.UserDataManager

---@type MoonClient.UserDataManager
MoonClient.UserDataManager = { }
---@param name string
---@param groupName string
---@param txt System.Object
function MoonClient.UserDataManager.SetDataFromLua(name, groupName, txt) end
---@return string
---@param name string
---@param groupName string
---@param defValue string
function MoonClient.UserDataManager.GetStringDataOrDef(name, groupName, defValue) end
---@param name string
---@param groupName string
function MoonClient.UserDataManager.DeleteData(name, groupName) end
---@return boolean
---@param name string
---@param groupName string
function MoonClient.UserDataManager.HasData(name, groupName) end
return MoonClient.UserDataManager
