---@class ROGameLibs.UIntSequenceVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.UIntSequenceVector
ROGameLibs.UIntSequenceVector = { }
---@overload fun(): ROGameLibs.UIntSequenceVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.UIntSequenceVector
---@overload fun(other:ROGameLibs.UIntSequenceVector): ROGameLibs.UIntSequenceVector
---@overload fun(capacity:number): ROGameLibs.UIntSequenceVector
---@return ROGameLibs.UIntSequenceVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.UIntSequenceVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.UIntSequenceVector:ReturnPool() end
---@return ROGameLibs.UIntSequenceVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.UIntSequenceVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.UIntSequenceVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.UIntSequenceVector:getPtr() end
function ROGameLibs.UIntSequenceVector:Dispose() end
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t[]): void
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t[]
---@param arrayIndex number
---@param count number
function ROGameLibs.UIntSequenceVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.UIntSequenceVector.UIntSequenceVectorEnumerator
function ROGameLibs.UIntSequenceVector:GetEnumerator() end
function ROGameLibs.UIntSequenceVector:Clear() end
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t
function ROGameLibs.UIntSequenceVector:Add(x) end
---@param values ROGameLibs.UIntSequenceVector
function ROGameLibs.UIntSequenceVector:AddRange(values) end
---@return ROGameLibs.UIntSequenceVector
---@param index number
---@param count number
function ROGameLibs.UIntSequenceVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t
function ROGameLibs.UIntSequenceVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.UIntSequenceVector
function ROGameLibs.UIntSequenceVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.UIntSequenceVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.UIntSequenceVector:RemoveRange(index, count) end
---@return ROGameLibs.UIntSequenceVector
---@param value ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t
---@param count number
function ROGameLibs.UIntSequenceVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.UIntSequenceVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.UIntSequenceVector
function ROGameLibs.UIntSequenceVector:SetRange(index, values) end
---@return MoonCommonLib.MSeqList_System.UInt32
function ROGameLibs.UIntSequenceVector:SequenceVectorToMSeqList() end
return ROGameLibs.UIntSequenceVector
