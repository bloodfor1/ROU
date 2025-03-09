---@class MoonClient.SpriteFrameAnimationImage : UnityEngine.UI.Image
---@field public Size number
---@field public TailShort boolean
---@field public AddIndex number

---@type MoonClient.SpriteFrameAnimationImage
MoonClient.SpriteFrameAnimationImage = { }
---@return MoonClient.SpriteFrameAnimationImage
function MoonClient.SpriteFrameAnimationImage.New() end
---@param atlasName string
---@param spriteName string
---@param spriteNumber number
---@param interval number
function MoonClient.SpriteFrameAnimationImage:SetAnimation(atlasName, spriteName, spriteNumber, interval) end
function MoonClient.SpriteFrameAnimationImage:StopAnimation() end
---@param atlasName string
---@param spriteName string
---@param setNativeSize boolean
---@param cb (fun(arg1:MoonClient.SpriteFrameAnimationImage, arg2:System.Object):void)
---@param data System.Object
function MoonClient.SpriteFrameAnimationImage:SetImageAsync(atlasName, spriteName, setNativeSize, cb, data) end
---@param atlasName string
---@param spriteName string
---@param setNativeSize boolean
function MoonClient.SpriteFrameAnimationImage:SetImage(atlasName, spriteName, setNativeSize) end
return MoonClient.SpriteFrameAnimationImage
