---@class MoonClient.MTouchItem
---@field public Fake boolean
---@field public touch UnityEngine.Touch
---@field public faketouch MoonClient.MFakeTouch
---@field public DeltaTime number
---@field public FingerId number
---@field public Phase number
---@field public Position UnityEngine.Vector2
---@field public RawPosition UnityEngine.Vector2
---@field public DeltaPosition UnityEngine.Vector2
---@field public TapCount number
---@field public IsOutOfScreen boolean

---@type MoonClient.MTouchItem
MoonClient.MTouchItem = { }
---@return MoonClient.MTouchItem
function MoonClient.MTouchItem.New() end
---@param phase number
function MoonClient.MTouchItem:ConvertToFakeTouch(phase) end
return MoonClient.MTouchItem
