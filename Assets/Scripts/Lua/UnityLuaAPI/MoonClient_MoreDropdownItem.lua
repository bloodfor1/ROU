---@class MoonClient.MoreDropdownItem

---@type MoonClient.MoreDropdownItem
MoonClient.MoreDropdownItem = { }
---@return MoonClient.MoreDropdownItem
function MoonClient.MoreDropdownItem.New() end
---@return MoonClient.IMoreDropdownInfo
---@param str string
function MoonClient.MoreDropdownItem.CreateInfo(str) end
---@return System.Collections.Generic.List_MoonClient.IMoreDropdownInfo
function MoonClient.MoreDropdownItem.CreateList() end
---@overload fun(_list:System.Collections.Generic.List_MoonClient.IMoreDropdownInfo, _info:MoonClient.IMoreDropdownInfo): System.Collections.Generic.List_MoonClient.IMoreDropdownInfo
---@return System.Collections.Generic.List_MoonClient.IMoreDropdownInfo
---@param _list System.Collections.Generic.List_MoonClient.IMoreDropdownInfo
---@param _info System.Collections.Generic.List_MoonClient.IMoreDropdownInfo
function MoonClient.MoreDropdownItem.AddInfo(_list, _info) end
return MoonClient.MoreDropdownItem
