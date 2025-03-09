---@class MoonClient.MUIBlackWordMgr : MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr
---@field public endCallback (fun():void)
---@field public bwTableId number

---@type MoonClient.MUIBlackWordMgr
MoonClient.MUIBlackWordMgr = { }
---@return MoonClient.MUIBlackWordMgr
function MoonClient.MUIBlackWordMgr.New() end
function MoonClient.MUIBlackWordMgr:EndCallBack() end
return MoonClient.MUIBlackWordMgr
