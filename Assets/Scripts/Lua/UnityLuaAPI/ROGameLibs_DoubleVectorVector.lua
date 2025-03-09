---@class ROGameLibs.DoubleVectorVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.DoubleVector
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.DoubleVectorVector
ROGameLibs.DoubleVectorVector = { }
---@overload fun(): ROGameLibs.DoubleVectorVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.DoubleVectorVector
---@overload fun(other:ROGameLibs.DoubleVectorVector): ROGameLibs.DoubleVectorVector
---@overload fun(capacity:number): ROGameLibs.DoubleVectorVector
---@return ROGameLibs.DoubleVectorVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.DoubleVectorVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.DoubleVectorVector:ReturnPool() end
---@return ROGameLibs.DoubleVectorVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.DoubleVectorVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.DoubleVectorVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.DoubleVectorVector:getPtr() end
function ROGameLibs.DoubleVectorVector:Dispose() end
---@overload fun(array:ROGameLibs.DoubleVector[]): void
---@overload fun(array:ROGameLibs.DoubleVector[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.DoubleVector[]
---@param arrayIndex number
---@param count number
function ROGameLibs.DoubleVectorVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.DoubleVectorVector.DoubleVectorVectorEnumerator
function ROGameLibs.DoubleVectorVector:GetEnumerator() end
function ROGameLibs.DoubleVectorVector:Clear() end
---@param x ROGameLibs.DoubleVector
function ROGameLibs.DoubleVectorVector:Add(x) end
---@param values ROGameLibs.DoubleVectorVector
function ROGameLibs.DoubleVectorVector:AddRange(values) end
---@return ROGameLibs.DoubleVectorVector
---@param index number
---@param count number
function ROGameLibs.DoubleVectorVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.DoubleVector
function ROGameLibs.DoubleVectorVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.DoubleVectorVector
function ROGameLibs.DoubleVectorVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.DoubleVectorVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.DoubleVectorVector:RemoveRange(index, count) end
---@return ROGameLibs.DoubleVectorVector
---@param value ROGameLibs.DoubleVector
---@param count number
function ROGameLibs.DoubleVectorVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.DoubleVectorVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.DoubleVectorVector
function ROGameLibs.DoubleVectorVector:SetRange(index, values) end
---@return System.Double_Array[]
function ROGameLibs.DoubleVectorVector:VectorVectorToVectorList() end
return ROGameLibs.DoubleVectorVector
