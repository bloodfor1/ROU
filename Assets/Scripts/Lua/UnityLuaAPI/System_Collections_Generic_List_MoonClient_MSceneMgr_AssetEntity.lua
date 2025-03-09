---@class System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@field public Capacity number
---@field public Count number
---@field public Item MoonClient.MSceneMgr.AssetEntity

---@type System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity = { }
---@overload fun(): System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@overload fun(capacity:number): System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@return System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity.New(collection) end
---@param item MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Add(item) end
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:AddRange(collection) end
---@return System.Collections.ObjectModel.ReadOnlyCollection_MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:AsReadOnly() end
---@overload fun(item:MoonClient.MSceneMgr.AssetEntity): number
---@overload fun(item:MoonClient.MSceneMgr.AssetEntity, comparer:System.Collections.Generic.IComparer_MoonClient.MSceneMgr.AssetEntity): number
---@return number
---@param index number
---@param count number
---@param item MoonClient.MSceneMgr.AssetEntity
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:BinarySearch(index, count, item, comparer) end
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Clear() end
---@return boolean
---@param item MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Contains(item) end
---@overload fun(array:MoonClient.MSceneMgr.AssetEntity[]): void
---@overload fun(array:MoonClient.MSceneMgr.AssetEntity[], arrayIndex:number): void
---@param index number
---@param array MoonClient.MSceneMgr.AssetEntity[]
---@param arrayIndex number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:CopyTo(index, array, arrayIndex, count) end
---@return boolean
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Exists(match) end
---@return MoonClient.MSceneMgr.AssetEntity
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Find(match) end
---@return System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:FindAll(match) end
---@overload fun(match:(fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:FindIndex(startIndex, count, match) end
---@return MoonClient.MSceneMgr.AssetEntity
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:FindLast(match) end
---@overload fun(match:(fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:FindLastIndex(startIndex, count, match) end
---@param action (fun(obj:MoonClient.MSceneMgr.AssetEntity):void)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:ForEach(action) end
---@return System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity.Enumerator
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:GetEnumerator() end
---@return System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:GetRange(index, count) end
---@overload fun(item:MoonClient.MSceneMgr.AssetEntity): number
---@overload fun(item:MoonClient.MSceneMgr.AssetEntity, index:number): number
---@return number
---@param item MoonClient.MSceneMgr.AssetEntity
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:IndexOf(item, index, count) end
---@param index number
---@param item MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Insert(index, item) end
---@param index number
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:InsertRange(index, collection) end
---@overload fun(item:MoonClient.MSceneMgr.AssetEntity): number
---@overload fun(item:MoonClient.MSceneMgr.AssetEntity, index:number): number
---@return number
---@param item MoonClient.MSceneMgr.AssetEntity
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:LastIndexOf(item, index, count) end
---@return boolean
---@param item MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Remove(item) end
---@return number
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:RemoveAll(match) end
---@param index number
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:RemoveAt(index) end
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:RemoveRange(index, count) end
---@overload fun(): void
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Reverse(index, count) end
---@overload fun(): void
---@overload fun(comparer:System.Collections.Generic.IComparer_MoonClient.MSceneMgr.AssetEntity): void
---@overload fun(comparison:(fun(x:MoonClient.MSceneMgr.AssetEntity, y:MoonClient.MSceneMgr.AssetEntity):number)): void
---@param index number
---@param count number
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSceneMgr.AssetEntity
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:Sort(index, count, comparer) end
---@return MoonClient.MSceneMgr.AssetEntity[]
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:ToArray() end
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:TrimExcess() end
---@return boolean
---@param match (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
function System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity:TrueForAll(match) end
return System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
