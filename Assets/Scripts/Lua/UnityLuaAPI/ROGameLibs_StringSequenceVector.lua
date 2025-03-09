---@class ROGameLibs.StringSequenceVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.StringSequenceVector
ROGameLibs.StringSequenceVector = { }
---@overload fun(): ROGameLibs.StringSequenceVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.StringSequenceVector
---@overload fun(other:ROGameLibs.StringSequenceVector): ROGameLibs.StringSequenceVector
---@overload fun(capacity:number): ROGameLibs.StringSequenceVector
---@return ROGameLibs.StringSequenceVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.StringSequenceVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.StringSequenceVector:ReturnPool() end
---@return ROGameLibs.StringSequenceVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.StringSequenceVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.StringSequenceVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.StringSequenceVector:getPtr() end
function ROGameLibs.StringSequenceVector:Dispose() end
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t[]): void
---@overload fun(array:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t[]
---@param arrayIndex number
---@param count number
function ROGameLibs.StringSequenceVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.StringSequenceVector.StringSequenceVectorEnumerator
function ROGameLibs.StringSequenceVector:GetEnumerator() end
function ROGameLibs.StringSequenceVector:Clear() end
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t
function ROGameLibs.StringSequenceVector:Add(x) end
---@param values ROGameLibs.StringSequenceVector
function ROGameLibs.StringSequenceVector:AddRange(values) end
---@return ROGameLibs.StringSequenceVector
---@param index number
---@param count number
function ROGameLibs.StringSequenceVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t
function ROGameLibs.StringSequenceVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.StringSequenceVector
function ROGameLibs.StringSequenceVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.StringSequenceVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.StringSequenceVector:RemoveRange(index, count) end
---@return ROGameLibs.StringSequenceVector
---@param value ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t
---@param count number
function ROGameLibs.StringSequenceVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.StringSequenceVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.StringSequenceVector
function ROGameLibs.StringSequenceVector:SetRange(index, values) end
---@return MoonCommonLib.MSeqList_System.String
function ROGameLibs.StringSequenceVector:SequenceVectorToMSeqList() end
return ROGameLibs.StringSequenceVector
