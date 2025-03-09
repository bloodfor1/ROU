---@class MoonClient.Theater.MTheaterMgr : MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr
---@field public TheaterFolder string
---@field public TheaterRootName string
---@field public TheaterRoot UnityEngine.GameObject
---@field public IsPlaying boolean

---@type MoonClient.Theater.MTheaterMgr
MoonClient.Theater.MTheaterMgr = { }
---@return MoonClient.Theater.MTheaterMgr
function MoonClient.Theater.MTheaterMgr.New() end
---@return boolean
function MoonClient.Theater.MTheaterMgr:Init() end
function MoonClient.Theater.MTheaterMgr:Uninit() end
function MoonClient.Theater.MTheaterMgr:Update() end
---@param forceExit boolean
function MoonClient.Theater.MTheaterMgr:ClearAssets(forceExit) end
function MoonClient.Theater.MTheaterMgr:Finish() end
---@overload fun(assetName:string): void
---@param theaterId number
---@param callback (fun():void)
function MoonClient.Theater.MTheaterMgr:PlayTheater(theaterId, callback) end
---@return MoonClient.Theater.MTheaterCameraAsset
function MoonClient.Theater.MTheaterMgr:GetNextAsset() end
return MoonClient.Theater.MTheaterMgr
