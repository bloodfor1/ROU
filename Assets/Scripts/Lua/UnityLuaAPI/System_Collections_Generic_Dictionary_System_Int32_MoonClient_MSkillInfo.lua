---@class System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@field public Comparer System.Collections.Generic.IEqualityComparer_System.Int32
---@field public Count number
---@field public Keys System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo.KeyCollection
---@field public Values System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo.ValueCollection
---@field public Item MoonClient.MSkillInfo

---@type System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo = { }
---@overload fun(): System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@overload fun(capacity:number): System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@overload fun(comparer:System.Collections.Generic.IEqualityComparer_System.Int32): System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@overload fun(dictionary:System.Collections.Generic.IDictionary_System.Int32_MoonClient.MSkillInfo): System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@overload fun(collection:System.Collections.Generic.IEnumerable_System.Collections.Generic.KeyValuePair_System.Int32_MoonClient.MSkillInfo): System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@overload fun(capacity:number, comparer:System.Collections.Generic.IEqualityComparer_System.Int32): System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@overload fun(dictionary:System.Collections.Generic.IDictionary_System.Int32_MoonClient.MSkillInfo, comparer:System.Collections.Generic.IEqualityComparer_System.Int32): System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@return System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@param collection System.Collections.Generic.IEnumerable_System.Collections.Generic.KeyValuePair_System.Int32_MoonClient.MSkillInfo
---@param comparer System.Collections.Generic.IEqualityComparer_System.Int32
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo.New(collection, comparer) end
---@param key number
---@param value MoonClient.MSkillInfo
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:Add(key, value) end
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:Clear() end
---@return boolean
---@param key number
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:ContainsKey(key) end
---@return boolean
---@param value MoonClient.MSkillInfo
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:ContainsValue(value) end
---@return System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo.Enumerator
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:GetEnumerator() end
---@param info System.Runtime.Serialization.SerializationInfo
---@param context System.Runtime.Serialization.StreamingContext
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:GetObjectData(info, context) end
---@param sender System.Object
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:OnDeserialization(sender) end
---@overload fun(key:number): boolean
---@return boolean
---@param key number
---@param value MoonClient.MSkillInfo
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:Remove(key, value) end
---@return boolean
---@param key number
---@param value MoonClient.MSkillInfo
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:TryGetValue(key, value) end
---@return boolean
---@param key number
---@param value MoonClient.MSkillInfo
function System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo:TryAdd(key, value) end
return System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
