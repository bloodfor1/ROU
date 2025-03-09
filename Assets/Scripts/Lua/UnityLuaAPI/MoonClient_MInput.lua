---@class MoonClient.MInput : MoonCommonLib.MSingleton_MoonClient.MInput
---@field public needSendScrollInfoToLua boolean

---@type MoonClient.MInput
MoonClient.MInput = { }
---@return MoonClient.MInput
function MoonClient.MInput.New() end
function MoonClient.MInput:Update() end
---@param stopMove boolean
function MoonClient.MInput:Reset(stopMove) end
---@return number
function MoonClient.MInput:GetTouchCount() end
function MoonClient.MInput:UpdateKeyboard() end
return MoonClient.MInput
