---@class MoonClient.MUICutSceneJumpMgr : MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr
---@field public jumpType number
---@field public jumpCallback (fun():void)

---@type MoonClient.MUICutSceneJumpMgr
MoonClient.MUICutSceneJumpMgr = { }
---@return MoonClient.MUICutSceneJumpMgr
function MoonClient.MUICutSceneJumpMgr.New() end
function MoonClient.MUICutSceneJumpMgr:JumpCallback() end
return MoonClient.MUICutSceneJumpMgr
