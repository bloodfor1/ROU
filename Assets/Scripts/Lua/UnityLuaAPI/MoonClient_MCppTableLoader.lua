---@class MoonClient.MCppTableLoader : MoonCommonLib.MSingleton_MoonClient.MCppTableLoader

---@type MoonClient.MCppTableLoader
MoonClient.MCppTableLoader = { }
---@return MoonClient.MCppTableLoader
function MoonClient.MCppTableLoader.New() end
---@param fileName string
---@param forceReload boolean
function MoonClient.MCppTableLoader:ReadFile(fileName, forceReload) end
---@param fileName string
function MoonClient.MCppTableLoader:UnloadTable(fileName) end
function MoonClient.MCppTableLoader:UnloadAllTable() end
function MoonClient.MCppTableLoader:ReloadAllTable() end
---@param name string
---@param tb MoonClient.IMCppTable
function MoonClient.MCppTableLoader:RegistTableSingleton(name, tb) end
return MoonClient.MCppTableLoader
