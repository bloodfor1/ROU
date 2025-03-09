---@class ROGameLibs.IntSequenceVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.IntSequenceVector
ROGameLibs.IntSequenceVector = { }
---@overload fun(): ROGameLibs.IntSequenceVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.IntSequenceVector
---@overload fun(other:ROGameLibs.IntSequenceVector): ROGameLibs.IntSequenceVector
---@overload fun(capacity:number): ROGameLibs.IntSequenceVector
---@return ROGameLibs.IntSequenceVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.IntSequenceVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.IntSequenceVector:ReturnPool() end
---@return ROGameLibs.IntSequenceVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.IntSequenceVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.IntSequenceVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.IntSequenceVector:getPtr() end
function ROGameLibs.IntSequenceVector:Dispose() end
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t[]): void
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t[]
---@param arrayIndex number
---@param count number
function ROGameLibs.IntSequenceVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.IntSequenceVector.IntSequenceVectorEnumerator
function ROGameLibs.IntSequenceVector:GetEnumerator() end
function ROGameLibs.IntSequenceVector:Clear() end
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t
function ROGameLibs.IntSequenceVector:Add(x) end
---@param values ROGameLibs.IntSequenceVector
function ROGameLibs.IntSequenceVector:AddRange(values) end
---@return ROGameLibs.IntSequenceVector
---@param index number
---@param count number
function ROGameLibs.IntSequenceVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t
function ROGameLibs.IntSequenceVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.IntSequenceVector
function ROGameLibs.IntSequenceVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.IntSequenceVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.IntSequenceVector:RemoveRange(index, count) end
---@return ROGameLibs.IntSequenceVector
---@param value ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t
---@param count number
function ROGameLibs.IntSequenceVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.IntSequenceVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.IntSequenceVector
function ROGameLibs.IntSequenceVector:SetRange(index, values) end
---@return MoonCommonLib.MSeqList_System.Int32
function ROGameLibs.IntSequenceVector:SequenceVectorToMSeqList() end
return ROGameLibs.IntSequenceVector
