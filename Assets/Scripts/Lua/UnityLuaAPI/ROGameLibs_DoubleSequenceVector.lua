---@class ROGameLibs.DoubleSequenceVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.DoubleSequenceVector
ROGameLibs.DoubleSequenceVector = { }
---@overload fun(): ROGameLibs.DoubleSequenceVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.DoubleSequenceVector
---@overload fun(other:ROGameLibs.DoubleSequenceVector): ROGameLibs.DoubleSequenceVector
---@overload fun(capacity:number): ROGameLibs.DoubleSequenceVector
---@return ROGameLibs.DoubleSequenceVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.DoubleSequenceVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.DoubleSequenceVector:ReturnPool() end
---@return ROGameLibs.DoubleSequenceVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.DoubleSequenceVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.DoubleSequenceVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.DoubleSequenceVector:getPtr() end
function ROGameLibs.DoubleSequenceVector:Dispose() end
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t[]): void
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t[]
---@param arrayIndex number
---@param count number
function ROGameLibs.DoubleSequenceVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.DoubleSequenceVector.DoubleSequenceVectorEnumerator
function ROGameLibs.DoubleSequenceVector:GetEnumerator() end
function ROGameLibs.DoubleSequenceVector:Clear() end
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t
function ROGameLibs.DoubleSequenceVector:Add(x) end
---@param values ROGameLibs.DoubleSequenceVector
function ROGameLibs.DoubleSequenceVector:AddRange(values) end
---@return ROGameLibs.DoubleSequenceVector
---@param index number
---@param count number
function ROGameLibs.DoubleSequenceVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t
function ROGameLibs.DoubleSequenceVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.DoubleSequenceVector
function ROGameLibs.DoubleSequenceVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.DoubleSequenceVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.DoubleSequenceVector:RemoveRange(index, count) end
---@return ROGameLibs.DoubleSequenceVector
---@param value ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t
---@param count number
function ROGameLibs.DoubleSequenceVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.DoubleSequenceVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.DoubleSequenceVector
function ROGameLibs.DoubleSequenceVector:SetRange(index, values) end
---@return MoonCommonLib.MSeqList_System.Double
function ROGameLibs.DoubleSequenceVector:SequenceVectorToMSeqList() end
return ROGameLibs.DoubleSequenceVector
