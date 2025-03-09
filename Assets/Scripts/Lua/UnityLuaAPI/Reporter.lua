---@class Reporter : UnityEngine.MonoBehaviour
---@field public show boolean
---@field public UserData string
---@field public fps number
---@field public fpsText string
---@field public images Images
---@field public size UnityEngine.Vector2
---@field public maxSize number
---@field public numOfCircleToShow number
---@field public Initialized boolean
---@field public TotalMemUsage number
---@field public Instance Reporter

---@type Reporter
Reporter = { }
---@return Reporter
function Reporter.New() end
---@return boolean
function Reporter:DoShow() end
function Reporter:Initialize() end
function Reporter:OnGUIDraw() end
return Reporter
