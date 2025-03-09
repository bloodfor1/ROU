---@class System.Collections.Generic.List_MoonClient.TeamMemberInfo
---@field public Capacity number
---@field public Count number
---@field public Item MoonClient.TeamMemberInfo

---@type System.Collections.Generic.List_MoonClient.TeamMemberInfo
System.Collections.Generic.List_MoonClient.TeamMemberInfo = { }
---@overload fun(): System.Collections.Generic.List_MoonClient.TeamMemberInfo
---@overload fun(capacity:number): System.Collections.Generic.List_MoonClient.TeamMemberInfo
---@return System.Collections.Generic.List_MoonClient.TeamMemberInfo
---@param collection System.Collections.Generic.IEnumerable_MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo.New(collection) end
---@param item MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Add(item) end
---@param collection System.Collections.Generic.IEnumerable_MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:AddRange(collection) end
---@return System.Collections.ObjectModel.ReadOnlyCollection_MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:AsReadOnly() end
---@overload fun(item:MoonClient.TeamMemberInfo): number
---@overload fun(item:MoonClient.TeamMemberInfo, comparer:System.Collections.Generic.IComparer_MoonClient.TeamMemberInfo): number
---@return number
---@param index number
---@param count number
---@param item MoonClient.TeamMemberInfo
---@param comparer System.Collections.Generic.IComparer_MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:BinarySearch(index, count, item, comparer) end
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Clear() end
---@return boolean
---@param item MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Contains(item) end
---@overload fun(array:MoonClient.TeamMemberInfo[]): void
---@overload fun(array:MoonClient.TeamMemberInfo[], arrayIndex:number): void
---@param index number
---@param array MoonClient.TeamMemberInfo[]
---@param arrayIndex number
---@param count number
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:CopyTo(index, array, arrayIndex, count) end
---@return boolean
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Exists(match) end
---@return MoonClient.TeamMemberInfo
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Find(match) end
---@return System.Collections.Generic.List_MoonClient.TeamMemberInfo
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:FindAll(match) end
---@overload fun(match:(fun(obj:MoonClient.TeamMemberInfo):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.TeamMemberInfo):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:FindIndex(startIndex, count, match) end
---@return MoonClient.TeamMemberInfo
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:FindLast(match) end
---@overload fun(match:(fun(obj:MoonClient.TeamMemberInfo):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.TeamMemberInfo):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:FindLastIndex(startIndex, count, match) end
---@param action (fun(obj:MoonClient.TeamMemberInfo):void)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:ForEach(action) end
---@return System.Collections.Generic.List_MoonClient.TeamMemberInfo.Enumerator
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:GetEnumerator() end
---@return System.Collections.Generic.List_MoonClient.TeamMemberInfo
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:GetRange(index, count) end
---@overload fun(item:MoonClient.TeamMemberInfo): number
---@overload fun(item:MoonClient.TeamMemberInfo, index:number): number
---@return number
---@param item MoonClient.TeamMemberInfo
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:IndexOf(item, index, count) end
---@param index number
---@param item MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Insert(index, item) end
---@param index number
---@param collection System.Collections.Generic.IEnumerable_MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:InsertRange(index, collection) end
---@overload fun(item:MoonClient.TeamMemberInfo): number
---@overload fun(item:MoonClient.TeamMemberInfo, index:number): number
---@return number
---@param item MoonClient.TeamMemberInfo
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:LastIndexOf(item, index, count) end
---@return boolean
---@param item MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Remove(item) end
---@return number
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:RemoveAll(match) end
---@param index number
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:RemoveAt(index) end
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:RemoveRange(index, count) end
---@overload fun(): void
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Reverse(index, count) end
---@overload fun(): void
---@overload fun(comparer:System.Collections.Generic.IComparer_MoonClient.TeamMemberInfo): void
---@overload fun(comparison:(fun(x:MoonClient.TeamMemberInfo, y:MoonClient.TeamMemberInfo):number)): void
---@param index number
---@param count number
---@param comparer System.Collections.Generic.IComparer_MoonClient.TeamMemberInfo
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:Sort(index, count, comparer) end
---@return MoonClient.TeamMemberInfo[]
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:ToArray() end
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:TrimExcess() end
---@return boolean
---@param match (fun(obj:MoonClient.TeamMemberInfo):boolean)
function System.Collections.Generic.List_MoonClient.TeamMemberInfo:TrueForAll(match) end
return System.Collections.Generic.List_MoonClient.TeamMemberInfo
