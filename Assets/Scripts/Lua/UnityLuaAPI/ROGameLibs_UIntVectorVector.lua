---@class ROGameLibs.UIntVectorVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.UIntVector
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.UIntVectorVector
ROGameLibs.UIntVectorVector = { }
---@overload fun(): ROGameLibs.UIntVectorVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.UIntVectorVector
---@overload fun(other:ROGameLibs.UIntVectorVector): ROGameLibs.UIntVectorVector
---@overload fun(capacity:number): ROGameLibs.UIntVectorVector
---@return ROGameLibs.UIntVectorVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.UIntVectorVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.UIntVectorVector:ReturnPool() end
---@return ROGameLibs.UIntVectorVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.UIntVectorVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.UIntVectorVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.UIntVectorVector:getPtr() end
function ROGameLibs.UIntVectorVector:Dispose() end
---@overload fun(array:ROGameLibs.UIntVector[]): void
---@overload fun(array:ROGameLibs.UIntVector[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.UIntVector[]
---@param arrayIndex number
---@param count number
function ROGameLibs.UIntVectorVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.UIntVectorVector.UIntVectorVectorEnumerator
function ROGameLibs.UIntVectorVector:GetEnumerator() end
function ROGameLibs.UIntVectorVector:Clear() end
---@param x ROGameLibs.UIntVector
function ROGameLibs.UIntVectorVector:Add(x) end
---@param values ROGameLibs.UIntVectorVector
function ROGameLibs.UIntVectorVector:AddRange(values) end
---@return ROGameLibs.UIntVectorVector
---@param index number
---@param count number
function ROGameLibs.UIntVectorVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.UIntVector
function ROGameLibs.UIntVectorVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.UIntVectorVector
function ROGameLibs.UIntVectorVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.UIntVectorVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.UIntVectorVector:RemoveRange(index, count) end
---@return ROGameLibs.UIntVectorVector
---@param value ROGameLibs.UIntVector
---@param count number
function ROGameLibs.UIntVectorVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.UIntVectorVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.UIntVectorVector
function ROGameLibs.UIntVectorVector:SetRange(index, values) end
---@return System.UInt32_Array[]
function ROGameLibs.UIntVectorVector:VectorVectorToVectorList() end
return ROGameLibs.UIntVectorVector
