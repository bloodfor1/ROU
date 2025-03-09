---@class ROGameLibs.LongVectorVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.LongVector
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.LongVectorVector
ROGameLibs.LongVectorVector = { }
---@overload fun(): ROGameLibs.LongVectorVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.LongVectorVector
---@overload fun(other:ROGameLibs.LongVectorVector): ROGameLibs.LongVectorVector
---@overload fun(capacity:number): ROGameLibs.LongVectorVector
---@return ROGameLibs.LongVectorVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.LongVectorVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.LongVectorVector:ReturnPool() end
---@return ROGameLibs.LongVectorVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.LongVectorVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.LongVectorVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.LongVectorVector:getPtr() end
function ROGameLibs.LongVectorVector:Dispose() end
---@overload fun(array:ROGameLibs.LongVector[]): void
---@overload fun(array:ROGameLibs.LongVector[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.LongVector[]
---@param arrayIndex number
---@param count number
function ROGameLibs.LongVectorVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.LongVectorVector.LongVectorVectorEnumerator
function ROGameLibs.LongVectorVector:GetEnumerator() end
function ROGameLibs.LongVectorVector:Clear() end
---@param x ROGameLibs.LongVector
function ROGameLibs.LongVectorVector:Add(x) end
---@param values ROGameLibs.LongVectorVector
function ROGameLibs.LongVectorVector:AddRange(values) end
---@return ROGameLibs.LongVectorVector
---@param index number
---@param count number
function ROGameLibs.LongVectorVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.LongVector
function ROGameLibs.LongVectorVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.LongVectorVector
function ROGameLibs.LongVectorVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.LongVectorVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.LongVectorVector:RemoveRange(index, count) end
---@return ROGameLibs.LongVectorVector
---@param value ROGameLibs.LongVector
---@param count number
function ROGameLibs.LongVectorVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.LongVectorVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.LongVectorVector
function ROGameLibs.LongVectorVector:SetRange(index, values) end
---@return System.Int64_Array[]
function ROGameLibs.LongVectorVector:VectorVectorToVectorList() end
return ROGameLibs.LongVectorVector
