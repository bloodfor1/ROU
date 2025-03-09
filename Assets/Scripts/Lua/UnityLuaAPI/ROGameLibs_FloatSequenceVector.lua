---@class ROGameLibs.FloatSequenceVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.FloatSequenceVector
ROGameLibs.FloatSequenceVector = { }
---@overload fun(): ROGameLibs.FloatSequenceVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.FloatSequenceVector
---@overload fun(other:ROGameLibs.FloatSequenceVector): ROGameLibs.FloatSequenceVector
---@overload fun(capacity:number): ROGameLibs.FloatSequenceVector
---@return ROGameLibs.FloatSequenceVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.FloatSequenceVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.FloatSequenceVector:ReturnPool() end
---@return ROGameLibs.FloatSequenceVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.FloatSequenceVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.FloatSequenceVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.FloatSequenceVector:getPtr() end
function ROGameLibs.FloatSequenceVector:Dispose() end
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t[]): void
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t[]
---@param arrayIndex number
---@param count number
function ROGameLibs.FloatSequenceVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.FloatSequenceVector.FloatSequenceVectorEnumerator
function ROGameLibs.FloatSequenceVector:GetEnumerator() end
function ROGameLibs.FloatSequenceVector:Clear() end
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t
function ROGameLibs.FloatSequenceVector:Add(x) end
---@param values ROGameLibs.FloatSequenceVector
function ROGameLibs.FloatSequenceVector:AddRange(values) end
---@return ROGameLibs.FloatSequenceVector
---@param index number
---@param count number
function ROGameLibs.FloatSequenceVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t
function ROGameLibs.FloatSequenceVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.FloatSequenceVector
function ROGameLibs.FloatSequenceVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.FloatSequenceVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.FloatSequenceVector:RemoveRange(index, count) end
---@return ROGameLibs.FloatSequenceVector
---@param value ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t
---@param count number
function ROGameLibs.FloatSequenceVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.FloatSequenceVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.FloatSequenceVector
function ROGameLibs.FloatSequenceVector:SetRange(index, values) end
---@return MoonCommonLib.MSeqList_System.Single
function ROGameLibs.FloatSequenceVector:SequenceVectorToMSeqList() end
return ROGameLibs.FloatSequenceVector
