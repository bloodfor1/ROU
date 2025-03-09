---@class MoonClient.DropdownEx.OptionData
---@field public text string
---@field public image UnityEngine.Sprite

---@type MoonClient.DropdownEx.OptionData
MoonClient.DropdownEx.OptionData = { }
---@overload fun(): MoonClient.DropdownEx.OptionData
---@overload fun(text:string): MoonClient.DropdownEx.OptionData
---@overload fun(image:UnityEngine.Sprite): MoonClient.DropdownEx.OptionData
---@return MoonClient.DropdownEx.OptionData
---@param text string
---@param image UnityEngine.Sprite
function MoonClient.DropdownEx.OptionData.New(text, image) end
return MoonClient.DropdownEx.OptionData
