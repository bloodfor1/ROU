---@class MoonClient.DropdownEx : UnityEngine.UI.Selectable
---@field public template UnityEngine.RectTransform
---@field public captionText UnityEngine.UI.Text
---@field public captionImage UnityEngine.UI.Image
---@field public itemText UnityEngine.UI.Text
---@field public itemImage UnityEngine.UI.Image
---@field public useColorChange boolean
---@field public selectColor UnityEngine.Color
---@field public normalColor UnityEngine.Color
---@field public options System.Collections.Generic.List_MoonClient.DropdownEx.OptionData
---@field public onValueChanged MoonClient.DropdownEx.DropdownEvent
---@field public value number

---@type MoonClient.DropdownEx
MoonClient.DropdownEx = { }
---@return MoonClient.DropdownEx
function MoonClient.DropdownEx.New() end
function MoonClient.DropdownEx:RefreshShownValue() end
---@overload fun(options:System.Collections.Generic.List_MoonClient.DropdownEx.OptionData): void
---@overload fun(options:System.Collections.Generic.List_System.String): void
---@param options System.Collections.Generic.List_UnityEngine.Sprite
function MoonClient.DropdownEx:AddOptions(options) end
function MoonClient.DropdownEx:ClearOptions() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.DropdownEx:OnPointerClick(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.DropdownEx:OnSubmit(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.DropdownEx:OnCancel(eventData) end
function MoonClient.DropdownEx:Show() end
function MoonClient.DropdownEx:Hide() end
return MoonClient.DropdownEx
