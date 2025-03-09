---@class MoonClient.MSceneFirstInMgr : MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr

---@type MoonClient.MSceneFirstInMgr
MoonClient.MSceneFirstInMgr = { }
---@return MoonClient.MSceneFirstInMgr
function MoonClient.MSceneFirstInMgr.New() end
---@return boolean
function MoonClient.MSceneFirstInMgr:Init() end
function MoonClient.MSceneFirstInMgr:Uninit() end
function MoonClient.MSceneFirstInMgr:FadeCallback() end
---@return boolean
function MoonClient.MSceneFirstInMgr:NeedRun() end
---@param rotX number
---@param rotY number
function MoonClient.MSceneFirstInMgr:OnSceneLoaded(rotX, rotY) end
---@param fDeltaT number
function MoonClient.MSceneFirstInMgr:Update(fDeltaT) end
return MoonClient.MSceneFirstInMgr
