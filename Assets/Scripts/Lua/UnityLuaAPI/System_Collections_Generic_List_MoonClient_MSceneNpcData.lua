---@class System.Collections.Generic.List_MoonClient.MSceneNpcData
---@field public Capacity number
---@field public Count number
---@field public Item MoonClient.MSceneNpcData

---@type System.Collections.Generic.List_MoonClient.MSceneNpcData
System.Collections.Generic.List_MoonClient.MSceneNpcData = { }
---@overload fun(): System.Collections.Generic.List_MoonClient.MSceneNpcData
---@overload fun(capacity:number): System.Collections.Generic.List_MoonClient.MSceneNpcData
---@return System.Collections.Generic.List_MoonClient.MSceneNpcData
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData.New(collection) end
---@param item MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Add(item) end
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:AddRange(collection) end
---@return System.Collections.ObjectModel.ReadOnlyCollection_MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:AsReadOnly() end
---@overload fun(item:MoonClient.MSceneNpcData): number
---@overload fun(item:MoonClient.MSceneNpcData, comparer:System.Collections.Generic.IComparer_MoonClient.MSceneNpcData): number
---@return number
---@param index number
---@param count number
---@param item MoonClient.MSceneNpcData
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:BinarySearch(index, count, item, comparer) end
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Clear() end
---@return boolean
---@param item MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Contains(item) end
---@overload fun(array:MoonClient.MSceneNpcData[]): void
---@overload fun(array:MoonClient.MSceneNpcData[], arrayIndex:number): void
---@param index number
---@param array MoonClient.MSceneNpcData[]
---@param arrayIndex number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneNpcData:CopyTo(index, array, arrayIndex, count) end
---@return boolean
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Exists(match) end
---@return MoonClient.MSceneNpcData
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Find(match) end
---@return System.Collections.Generic.List_MoonClient.MSceneNpcData
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:FindAll(match) end
---@overload fun(match:(fun(obj:MoonClient.MSceneNpcData):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.MSceneNpcData):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:FindIndex(startIndex, count, match) end
---@return MoonClient.MSceneNpcData
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:FindLast(match) end
---@overload fun(match:(fun(obj:MoonClient.MSceneNpcData):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.MSceneNpcData):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:FindLastIndex(startIndex, count, match) end
---@param action (fun(obj:MoonClient.MSceneNpcData):void)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:ForEach(action) end
---@return System.Collections.Generic.List_MoonClient.MSceneNpcData.Enumerator
function System.Collections.Generic.List_MoonClient.MSceneNpcData:GetEnumerator() end
---@return System.Collections.Generic.List_MoonClient.MSceneNpcData
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneNpcData:GetRange(index, count) end
---@overload fun(item:MoonClient.MSceneNpcData): number
---@overload fun(item:MoonClient.MSceneNpcData, index:number): number
---@return number
---@param item MoonClient.MSceneNpcData
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneNpcData:IndexOf(item, index, count) end
---@param index number
---@param item MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Insert(index, item) end
---@param index number
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:InsertRange(index, collection) end
---@overload fun(item:MoonClient.MSceneNpcData): number
---@overload fun(item:MoonClient.MSceneNpcData, index:number): number
---@return number
---@param item MoonClient.MSceneNpcData
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneNpcData:LastIndexOf(item, index, count) end
---@return boolean
---@param item MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Remove(item) end
---@return number
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:RemoveAll(match) end
---@param index number
function System.Collections.Generic.List_MoonClient.MSceneNpcData:RemoveAt(index) end
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneNpcData:RemoveRange(index, count) end
---@overload fun(): void
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Reverse(index, count) end
---@overload fun(): void
---@overload fun(comparer:System.Collections.Generic.IComparer_MoonClient.MSceneNpcData): void
---@overload fun(comparison:(fun(x:MoonClient.MSceneNpcData, y:MoonClient.MSceneNpcData):number)): void
---@param index number
---@param count number
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSceneNpcData
function System.Collections.Generic.List_MoonClient.MSceneNpcData:Sort(index, count, comparer) end
---@return MoonClient.MSceneNpcData[]
function System.Collections.Generic.List_MoonClient.MSceneNpcData:ToArray() end
function System.Collections.Generic.List_MoonClient.MSceneNpcData:TrimExcess() end
---@return boolean
---@param match (fun(obj:MoonClient.MSceneNpcData):boolean)
function System.Collections.Generic.List_MoonClient.MSceneNpcData:TrueForAll(match) end
return System.Collections.Generic.List_MoonClient.MSceneNpcData
