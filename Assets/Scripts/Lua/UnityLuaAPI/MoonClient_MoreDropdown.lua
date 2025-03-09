---@class MoonClient.MoreDropdown : UnityEngine.MonoBehaviour
---@field public mainButton UnityEngine.UI.Button
---@field public dropdownPanel UnityEngine.UI.Image
---@field public dropdownGrid UnityEngine.UI.Image
---@field public dropdownItem UnityEngine.UI.Button
---@field public dropdownItemRT UnityEngine.RectTransform
---@field public hideBG UnityEngine.UI.Button
---@field public onCreateDropdown (fun():void)
---@field public onClickItem (fun(arg1:string, arg2:string):void)

---@type MoonClient.MoreDropdown
MoonClient.MoreDropdown = { }
---@return MoonClient.MoreDropdown
function MoonClient.MoreDropdown.New() end
---@param _allInfo System.Collections.Generic.List_MoonClient.IMoreDropdownInfo
function MoonClient.MoreDropdown.SetAllInfo(_allInfo) end
return MoonClient.MoreDropdown
