---@class System.Collections.Generic.List_KKSG.WorldEventDB
---@field public Capacity number
---@field public Count number
---@field public Item KKSG.WorldEventDB

---@type System.Collections.Generic.List_KKSG.WorldEventDB
System.Collections.Generic.List_KKSG.WorldEventDB = { }
---@overload fun(): System.Collections.Generic.List_KKSG.WorldEventDB
---@overload fun(capacity:number): System.Collections.Generic.List_KKSG.WorldEventDB
---@return System.Collections.Generic.List_KKSG.WorldEventDB
---@param collection System.Collections.Generic.IEnumerable_KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB.New(collection) end
---@param item KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:Add(item) end
---@param collection System.Collections.Generic.IEnumerable_KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:AddRange(collection) end
---@return System.Collections.ObjectModel.ReadOnlyCollection_KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:AsReadOnly() end
---@overload fun(item:KKSG.WorldEventDB): number
---@overload fun(item:KKSG.WorldEventDB, comparer:System.Collections.Generic.IComparer_KKSG.WorldEventDB): number
---@return number
---@param index number
---@param count number
---@param item KKSG.WorldEventDB
---@param comparer System.Collections.Generic.IComparer_KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:BinarySearch(index, count, item, comparer) end
function System.Collections.Generic.List_KKSG.WorldEventDB:Clear() end
---@return boolean
---@param item KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:Contains(item) end
---@overload fun(array:KKSG.WorldEventDB[]): void
---@overload fun(array:KKSG.WorldEventDB[], arrayIndex:number): void
---@param index number
---@param array KKSG.WorldEventDB[]
---@param arrayIndex number
---@param count number
function System.Collections.Generic.List_KKSG.WorldEventDB:CopyTo(index, array, arrayIndex, count) end
---@return boolean
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:Exists(match) end
---@return KKSG.WorldEventDB
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:Find(match) end
---@return System.Collections.Generic.List_KKSG.WorldEventDB
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:FindAll(match) end
---@overload fun(match:(fun(obj:KKSG.WorldEventDB):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:KKSG.WorldEventDB):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:FindIndex(startIndex, count, match) end
---@return KKSG.WorldEventDB
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:FindLast(match) end
---@overload fun(match:(fun(obj:KKSG.WorldEventDB):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:KKSG.WorldEventDB):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:FindLastIndex(startIndex, count, match) end
---@param action (fun(obj:KKSG.WorldEventDB):void)
function System.Collections.Generic.List_KKSG.WorldEventDB:ForEach(action) end
---@return System.Collections.Generic.List_KKSG.WorldEventDB.Enumerator
function System.Collections.Generic.List_KKSG.WorldEventDB:GetEnumerator() end
---@return System.Collections.Generic.List_KKSG.WorldEventDB
---@param index number
---@param count number
function System.Collections.Generic.List_KKSG.WorldEventDB:GetRange(index, count) end
---@overload fun(item:KKSG.WorldEventDB): number
---@overload fun(item:KKSG.WorldEventDB, index:number): number
---@return number
---@param item KKSG.WorldEventDB
---@param index number
---@param count number
function System.Collections.Generic.List_KKSG.WorldEventDB:IndexOf(item, index, count) end
---@param index number
---@param item KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:Insert(index, item) end
---@param index number
---@param collection System.Collections.Generic.IEnumerable_KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:InsertRange(index, collection) end
---@overload fun(item:KKSG.WorldEventDB): number
---@overload fun(item:KKSG.WorldEventDB, index:number): number
---@return number
---@param item KKSG.WorldEventDB
---@param index number
---@param count number
function System.Collections.Generic.List_KKSG.WorldEventDB:LastIndexOf(item, index, count) end
---@return boolean
---@param item KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:Remove(item) end
---@return number
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:RemoveAll(match) end
---@param index number
function System.Collections.Generic.List_KKSG.WorldEventDB:RemoveAt(index) end
---@param index number
---@param count number
function System.Collections.Generic.List_KKSG.WorldEventDB:RemoveRange(index, count) end
---@overload fun(): void
---@param index number
---@param count number
function System.Collections.Generic.List_KKSG.WorldEventDB:Reverse(index, count) end
---@overload fun(): void
---@overload fun(comparer:System.Collections.Generic.IComparer_KKSG.WorldEventDB): void
---@overload fun(comparison:(fun(x:KKSG.WorldEventDB, y:KKSG.WorldEventDB):number)): void
---@param index number
---@param count number
---@param comparer System.Collections.Generic.IComparer_KKSG.WorldEventDB
function System.Collections.Generic.List_KKSG.WorldEventDB:Sort(index, count, comparer) end
---@return KKSG.WorldEventDB[]
function System.Collections.Generic.List_KKSG.WorldEventDB:ToArray() end
function System.Collections.Generic.List_KKSG.WorldEventDB:TrimExcess() end
---@return boolean
---@param match (fun(obj:KKSG.WorldEventDB):boolean)
function System.Collections.Generic.List_KKSG.WorldEventDB:TrueForAll(match) end
return System.Collections.Generic.List_KKSG.WorldEventDB
