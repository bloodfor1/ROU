---@class ROGameLibs.IntVectorVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.IntVector
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.IntVectorVector
ROGameLibs.IntVectorVector = { }
---@overload fun(): ROGameLibs.IntVectorVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.IntVectorVector
---@overload fun(other:ROGameLibs.IntVectorVector): ROGameLibs.IntVectorVector
---@overload fun(capacity:number): ROGameLibs.IntVectorVector
---@return ROGameLibs.IntVectorVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.IntVectorVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.IntVectorVector:ReturnPool() end
---@return ROGameLibs.IntVectorVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.IntVectorVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.IntVectorVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.IntVectorVector:getPtr() end
function ROGameLibs.IntVectorVector:Dispose() end
---@overload fun(array:ROGameLibs.IntVector[]): void
---@overload fun(array:ROGameLibs.IntVector[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.IntVector[]
---@param arrayIndex number
---@param count number
function ROGameLibs.IntVectorVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.IntVectorVector.IntVectorVectorEnumerator
function ROGameLibs.IntVectorVector:GetEnumerator() end
function ROGameLibs.IntVectorVector:Clear() end
---@param x ROGameLibs.IntVector
function ROGameLibs.IntVectorVector:Add(x) end
---@param values ROGameLibs.IntVectorVector
function ROGameLibs.IntVectorVector:AddRange(values) end
---@return ROGameLibs.IntVectorVector
---@param index number
---@param count number
function ROGameLibs.IntVectorVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.IntVector
function ROGameLibs.IntVectorVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.IntVectorVector
function ROGameLibs.IntVectorVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.IntVectorVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.IntVectorVector:RemoveRange(index, count) end
---@return ROGameLibs.IntVectorVector
---@param value ROGameLibs.IntVector
---@param count number
function ROGameLibs.IntVectorVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.IntVectorVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.IntVectorVector
function ROGameLibs.IntVectorVector:SetRange(index, values) end
---@return System.Int32_Array[]
function ROGameLibs.IntVectorVector:VectorVectorToVectorList() end
return ROGameLibs.IntVectorVector
