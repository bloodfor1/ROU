---@class System.Collections.Generic.List_MoonClient.MSkillInfo
---@field public Capacity number
---@field public Count number
---@field public Item MoonClient.MSkillInfo

---@type System.Collections.Generic.List_MoonClient.MSkillInfo
System.Collections.Generic.List_MoonClient.MSkillInfo = { }
---@overload fun(): System.Collections.Generic.List_MoonClient.MSkillInfo
---@overload fun(capacity:number): System.Collections.Generic.List_MoonClient.MSkillInfo
---@return System.Collections.Generic.List_MoonClient.MSkillInfo
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo.New(collection) end
---@param item MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:Add(item) end
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:AddRange(collection) end
---@return System.Collections.ObjectModel.ReadOnlyCollection_MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:AsReadOnly() end
---@overload fun(item:MoonClient.MSkillInfo): number
---@overload fun(item:MoonClient.MSkillInfo, comparer:System.Collections.Generic.IComparer_MoonClient.MSkillInfo): number
---@return number
---@param index number
---@param count number
---@param item MoonClient.MSkillInfo
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:BinarySearch(index, count, item, comparer) end
function System.Collections.Generic.List_MoonClient.MSkillInfo:Clear() end
---@return boolean
---@param item MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:Contains(item) end
---@overload fun(array:MoonClient.MSkillInfo[]): void
---@overload fun(array:MoonClient.MSkillInfo[], arrayIndex:number): void
---@param index number
---@param array MoonClient.MSkillInfo[]
---@param arrayIndex number
---@param count number
function System.Collections.Generic.List_MoonClient.MSkillInfo:CopyTo(index, array, arrayIndex, count) end
---@return boolean
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:Exists(match) end
---@return MoonClient.MSkillInfo
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:Find(match) end
---@return System.Collections.Generic.List_MoonClient.MSkillInfo
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:FindAll(match) end
---@overload fun(match:(fun(obj:MoonClient.MSkillInfo):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.MSkillInfo):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:FindIndex(startIndex, count, match) end
---@return MoonClient.MSkillInfo
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:FindLast(match) end
---@overload fun(match:(fun(obj:MoonClient.MSkillInfo):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.MSkillInfo):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:FindLastIndex(startIndex, count, match) end
---@param action (fun(obj:MoonClient.MSkillInfo):void)
function System.Collections.Generic.List_MoonClient.MSkillInfo:ForEach(action) end
---@return System.Collections.Generic.List_MoonClient.MSkillInfo.Enumerator
function System.Collections.Generic.List_MoonClient.MSkillInfo:GetEnumerator() end
---@return System.Collections.Generic.List_MoonClient.MSkillInfo
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSkillInfo:GetRange(index, count) end
---@overload fun(item:MoonClient.MSkillInfo): number
---@overload fun(item:MoonClient.MSkillInfo, index:number): number
---@return number
---@param item MoonClient.MSkillInfo
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSkillInfo:IndexOf(item, index, count) end
---@param index number
---@param item MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:Insert(index, item) end
---@param index number
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:InsertRange(index, collection) end
---@overload fun(item:MoonClient.MSkillInfo): number
---@overload fun(item:MoonClient.MSkillInfo, index:number): number
---@return number
---@param item MoonClient.MSkillInfo
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSkillInfo:LastIndexOf(item, index, count) end
---@return boolean
---@param item MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:Remove(item) end
---@return number
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:RemoveAll(match) end
---@param index number
function System.Collections.Generic.List_MoonClient.MSkillInfo:RemoveAt(index) end
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSkillInfo:RemoveRange(index, count) end
---@overload fun(): void
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSkillInfo:Reverse(index, count) end
---@overload fun(): void
---@overload fun(comparer:System.Collections.Generic.IComparer_MoonClient.MSkillInfo): void
---@overload fun(comparison:(fun(x:MoonClient.MSkillInfo, y:MoonClient.MSkillInfo):number)): void
---@param index number
---@param count number
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSkillInfo
function System.Collections.Generic.List_MoonClient.MSkillInfo:Sort(index, count, comparer) end
---@return MoonClient.MSkillInfo[]
function System.Collections.Generic.List_MoonClient.MSkillInfo:ToArray() end
function System.Collections.Generic.List_MoonClient.MSkillInfo:TrimExcess() end
---@return boolean
---@param match (fun(obj:MoonClient.MSkillInfo):boolean)
function System.Collections.Generic.List_MoonClient.MSkillInfo:TrueForAll(match) end
return System.Collections.Generic.List_MoonClient.MSkillInfo
