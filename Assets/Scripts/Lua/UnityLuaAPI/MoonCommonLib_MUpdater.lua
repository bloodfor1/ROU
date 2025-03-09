---@class MoonCommonLib.MUpdater : MoonCommonLib.MSingleton_MoonCommonLib.MUpdater
---@field public UpdateStep number
---@field public IsPause boolean
---@field public IsUpdateDone boolean
---@field public MPlatform MoonCommonLib.IMPlatform

---@type MoonCommonLib.MUpdater
MoonCommonLib.MUpdater = { }
---@return MoonCommonLib.MUpdater
function MoonCommonLib.MUpdater.New() end
---@return boolean
function MoonCommonLib.MUpdater:Init() end
function MoonCommonLib.MUpdater:Uninit() end
function MoonCommonLib.MUpdater:Update() end
function MoonCommonLib.MUpdater:ResetCurrentState() end
function MoonCommonLib.MUpdater:Pause() end
function MoonCommonLib.MUpdater:Resume() end
function MoonCommonLib.MUpdater:ClearAllCaches() end
function MoonCommonLib.MUpdater:ClearCaches() end
return MoonCommonLib.MUpdater
