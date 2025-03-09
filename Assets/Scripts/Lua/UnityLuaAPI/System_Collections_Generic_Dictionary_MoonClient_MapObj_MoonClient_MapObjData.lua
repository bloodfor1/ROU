---@class System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@field public Comparer System.Collections.Generic.IEqualityComparer_MoonClient.MapObj
---@field public Count number
---@field public Keys System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData.KeyCollection
---@field public Values System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData.ValueCollection
---@field public Item MoonClient.MapObjData

---@type System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData = { }
---@overload fun(): System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@overload fun(capacity:number): System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@overload fun(comparer:System.Collections.Generic.IEqualityComparer_MoonClient.MapObj): System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@overload fun(dictionary:System.Collections.Generic.IDictionary_MoonClient.MapObj_MoonClient.MapObjData): System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@overload fun(collection:System.Collections.Generic.IEnumerable_System.Collections.Generic.KeyValuePair_MoonClient.MapObj_MoonClient.MapObjData): System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@overload fun(capacity:number, comparer:System.Collections.Generic.IEqualityComparer_MoonClient.MapObj): System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@overload fun(dictionary:System.Collections.Generic.IDictionary_MoonClient.MapObj_MoonClient.MapObjData, comparer:System.Collections.Generic.IEqualityComparer_MoonClient.MapObj): System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@return System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@param collection System.Collections.Generic.IEnumerable_System.Collections.Generic.KeyValuePair_MoonClient.MapObj_MoonClient.MapObjData
---@param comparer System.Collections.Generic.IEqualityComparer_MoonClient.MapObj
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData.New(collection, comparer) end
---@param key MoonClient.MapObj
---@param value MoonClient.MapObjData
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:Add(key, value) end
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:Clear() end
---@return boolean
---@param key MoonClient.MapObj
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:ContainsKey(key) end
---@return boolean
---@param value MoonClient.MapObjData
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:ContainsValue(value) end
---@return System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData.Enumerator
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:GetEnumerator() end
---@param info System.Runtime.Serialization.SerializationInfo
---@param context System.Runtime.Serialization.StreamingContext
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:GetObjectData(info, context) end
---@param sender System.Object
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:OnDeserialization(sender) end
---@overload fun(key:MoonClient.MapObj): boolean
---@return boolean
---@param key MoonClient.MapObj
---@param value MoonClient.MapObjData
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:Remove(key, value) end
---@return boolean
---@param key MoonClient.MapObj
---@param value MoonClient.MapObjData
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:TryGetValue(key, value) end
---@return boolean
---@param key MoonClient.MapObj
---@param value MoonClient.MapObjData
function System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData:TryAdd(key, value) end
return System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
