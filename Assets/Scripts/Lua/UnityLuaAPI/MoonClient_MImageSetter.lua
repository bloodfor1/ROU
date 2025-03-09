---@class MoonClient.MImageSetter
---@field public Img UnityEngine.UI.Image

---@type MoonClient.MImageSetter
MoonClient.MImageSetter = { }
---@return MoonClient.MImageSetter
function MoonClient.MImageSetter.New() end
---@param img UnityEngine.UI.Image
function MoonClient.MImageSetter:Init(img) end
function MoonClient.MImageSetter:Uninit() end
function MoonClient.MImageSetter:ResetSprite() end
---@param atlasName string
---@param spriteName string
---@param callback (fun():void)
---@param setNativeSize boolean
function MoonClient.MImageSetter:SetSpriteAsync(atlasName, spriteName, callback, setNativeSize) end
return MoonClient.MImageSetter
