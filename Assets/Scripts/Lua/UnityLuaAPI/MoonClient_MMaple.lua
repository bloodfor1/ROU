---@class MoonClient.MMaple

---@type MoonClient.MMaple
MoonClient.MMaple = { }
---@param jsondata string
function MoonClient.MMaple.MapleInit(jsondata) end
---@param jsondata string
function MoonClient.MMaple.MapleQueryTree(jsondata) end
---@param jsondata string
function MoonClient.MMaple.MapleQueryLeaf(jsondata) end
---@return System.Object
function MoonClient.MMaple.IsMapleConnected() end
return MoonClient.MMaple
