---@class MoonClient.MVirtualTab : MoonCommonLib.MSingleton_MoonClient.MVirtualTab
---@field public MOVE_TOUCH_TIME number
---@field public MAX_DISTANCE number
---@field public FingerId number
---@field public IsMoving boolean

---@type MoonClient.MVirtualTab
MoonClient.MVirtualTab = { }
---@return MoonClient.MVirtualTab
function MoonClient.MVirtualTab.New() end
---@return boolean
---@param pos UnityEngine.Vector2
function MoonClient.MVirtualTab:InActiveRange(pos) end
---@return boolean
function MoonClient.MVirtualTab:Init() end
function MoonClient.MVirtualTab:Clear() end
function MoonClient.MVirtualTab:RmPause() end
function MoonClient.MVirtualTab:Pause() end
---@param touch MoonClient.MTouchItem
function MoonClient.MVirtualTab:Feed(touch) end
---@param dir UnityEngine.Vector3
function MoonClient.MVirtualTab:MoveByDir(dir) end
return MoonClient.MVirtualTab
