---@class ROGameLibs.BoolSequenceVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.BoolSequenceVector
ROGameLibs.BoolSequenceVector = { }
---@overload fun(): ROGameLibs.BoolSequenceVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.BoolSequenceVector
---@overload fun(other:ROGameLibs.BoolSequenceVector): ROGameLibs.BoolSequenceVector
---@overload fun(capacity:number): ROGameLibs.BoolSequenceVector
---@return ROGameLibs.BoolSequenceVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.BoolSequenceVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.BoolSequenceVector:ReturnPool() end
---@return ROGameLibs.BoolSequenceVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.BoolSequenceVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.BoolSequenceVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.BoolSequenceVector:getPtr() end
function ROGameLibs.BoolSequenceVector:Dispose() end
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t[]): void
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t[]
---@param arrayIndex number
---@param count number
function ROGameLibs.BoolSequenceVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.BoolSequenceVector.BoolSequenceVectorEnumerator
function ROGameLibs.BoolSequenceVector:GetEnumerator() end
function ROGameLibs.BoolSequenceVector:Clear() end
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t
function ROGameLibs.BoolSequenceVector:Add(x) end
---@param values ROGameLibs.BoolSequenceVector
function ROGameLibs.BoolSequenceVector:AddRange(values) end
---@return ROGameLibs.BoolSequenceVector
---@param index number
---@param count number
function ROGameLibs.BoolSequenceVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t
function ROGameLibs.BoolSequenceVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.BoolSequenceVector
function ROGameLibs.BoolSequenceVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.BoolSequenceVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.BoolSequenceVector:RemoveRange(index, count) end
---@return ROGameLibs.BoolSequenceVector
---@param value ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t
---@param count number
function ROGameLibs.BoolSequenceVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.BoolSequenceVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.BoolSequenceVector
function ROGameLibs.BoolSequenceVector:SetRange(index, values) end
---@return MoonCommonLib.MSeqList_System.Boolean
function ROGameLibs.BoolSequenceVector:SequenceVectorToMSeqList() end
return ROGameLibs.BoolSequenceVector
