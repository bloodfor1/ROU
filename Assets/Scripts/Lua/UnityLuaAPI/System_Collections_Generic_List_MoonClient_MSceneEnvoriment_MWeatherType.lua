---@class System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
---@field public Capacity number
---@field public Count number
---@field public Item number

---@type System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType = { }
---@overload fun(): System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
---@overload fun(capacity:number): System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
---@return System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneEnvoriment.MWeatherType
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType.New(collection) end
---@param item number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Add(item) end
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneEnvoriment.MWeatherType
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:AddRange(collection) end
---@return System.Collections.ObjectModel.ReadOnlyCollection_MoonClient.MSceneEnvoriment.MWeatherType
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:AsReadOnly() end
---@overload fun(item:number): number
---@overload fun(item:number, comparer:System.Collections.Generic.IComparer_MoonClient.MSceneEnvoriment.MWeatherType): number
---@return number
---@param index number
---@param count number
---@param item number
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSceneEnvoriment.MWeatherType
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:BinarySearch(index, count, item, comparer) end
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Clear() end
---@return boolean
---@param item number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Contains(item) end
---@overload fun(array:MoonClient.MSceneEnvoriment.MWeatherType[]): void
---@overload fun(array:MoonClient.MSceneEnvoriment.MWeatherType[], arrayIndex:number): void
---@param index number
---@param array MoonClient.MSceneEnvoriment.MWeatherType[]
---@param arrayIndex number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:CopyTo(index, array, arrayIndex, count) end
---@return boolean
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Exists(match) end
---@return number
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Find(match) end
---@return System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:FindAll(match) end
---@overload fun(match:(fun(obj:number):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:number):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:FindIndex(startIndex, count, match) end
---@return number
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:FindLast(match) end
---@overload fun(match:(fun(obj:number):boolean)): number
---@overload fun(startIndex:number, match:(fun(obj:number):boolean)): number
---@return number
---@param startIndex number
---@param count number
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:FindLastIndex(startIndex, count, match) end
---@param action (fun(obj:number):void)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:ForEach(action) end
---@return System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType.Enumerator
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:GetEnumerator() end
---@return System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:GetRange(index, count) end
---@overload fun(item:number): number
---@overload fun(item:number, index:number): number
---@return number
---@param item number
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:IndexOf(item, index, count) end
---@param index number
---@param item number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Insert(index, item) end
---@param index number
---@param collection System.Collections.Generic.IEnumerable_MoonClient.MSceneEnvoriment.MWeatherType
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:InsertRange(index, collection) end
---@overload fun(item:number): number
---@overload fun(item:number, index:number): number
---@return number
---@param item number
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:LastIndexOf(item, index, count) end
---@return boolean
---@param item number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Remove(item) end
---@return number
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:RemoveAll(match) end
---@param index number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:RemoveAt(index) end
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:RemoveRange(index, count) end
---@overload fun(): void
---@param index number
---@param count number
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Reverse(index, count) end
---@overload fun(): void
---@overload fun(comparer:System.Collections.Generic.IComparer_MoonClient.MSceneEnvoriment.MWeatherType): void
---@overload fun(comparison:(fun(x:number, y:number):number)): void
---@param index number
---@param count number
---@param comparer System.Collections.Generic.IComparer_MoonClient.MSceneEnvoriment.MWeatherType
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:Sort(index, count, comparer) end
---@return MoonClient.MSceneEnvoriment.MWeatherType[]
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:ToArray() end
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:TrimExcess() end
---@return boolean
---@param match (fun(obj:number):boolean)
function System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType:TrueForAll(match) end
return System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
