---@class ROGameLibs.LongSequenceVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.LongSequenceVector
ROGameLibs.LongSequenceVector = { }
---@overload fun(): ROGameLibs.LongSequenceVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.LongSequenceVector
---@overload fun(other:ROGameLibs.LongSequenceVector): ROGameLibs.LongSequenceVector
---@overload fun(capacity:number): ROGameLibs.LongSequenceVector
---@return ROGameLibs.LongSequenceVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.LongSequenceVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.LongSequenceVector:ReturnPool() end
---@return ROGameLibs.LongSequenceVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.LongSequenceVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.LongSequenceVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.LongSequenceVector:getPtr() end
function ROGameLibs.LongSequenceVector:Dispose() end
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t[]): void
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t[]
---@param arrayIndex number
---@param count number
function ROGameLibs.LongSequenceVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.LongSequenceVector.LongSequenceVectorEnumerator
function ROGameLibs.LongSequenceVector:GetEnumerator() end
function ROGameLibs.LongSequenceVector:Clear() end
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t
function ROGameLibs.LongSequenceVector:Add(x) end
---@param values ROGameLibs.LongSequenceVector
function ROGameLibs.LongSequenceVector:AddRange(values) end
---@return ROGameLibs.LongSequenceVector
---@param index number
---@param count number
function ROGameLibs.LongSequenceVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t
function ROGameLibs.LongSequenceVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.LongSequenceVector
function ROGameLibs.LongSequenceVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.LongSequenceVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.LongSequenceVector:RemoveRange(index, count) end
---@return ROGameLibs.LongSequenceVector
---@param value ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t
---@param count number
function ROGameLibs.LongSequenceVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.LongSequenceVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.LongSequenceVector
function ROGameLibs.LongSequenceVector:SetRange(index, values) end
---@return MoonCommonLib.MSeqList_System.Int64
function ROGameLibs.LongSequenceVector:SequenceVectorToMSeqList() end
return ROGameLibs.LongSequenceVector
