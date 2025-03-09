---@class ROGameLibs.BoolVectorVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.BoolVector
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.BoolVectorVector
ROGameLibs.BoolVectorVector = { }
---@overload fun(): ROGameLibs.BoolVectorVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.BoolVectorVector
---@overload fun(other:ROGameLibs.BoolVectorVector): ROGameLibs.BoolVectorVector
---@overload fun(capacity:number): ROGameLibs.BoolVectorVector
---@return ROGameLibs.BoolVectorVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.BoolVectorVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.BoolVectorVector:ReturnPool() end
---@return ROGameLibs.BoolVectorVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.BoolVectorVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.BoolVectorVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.BoolVectorVector:getPtr() end
function ROGameLibs.BoolVectorVector:Dispose() end
---@overload fun(array:ROGameLibs.BoolVector[]): void
---@overload fun(array:ROGameLibs.BoolVector[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.BoolVector[]
---@param arrayIndex number
---@param count number
function ROGameLibs.BoolVectorVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.BoolVectorVector.BoolVectorVectorEnumerator
function ROGameLibs.BoolVectorVector:GetEnumerator() end
function ROGameLibs.BoolVectorVector:Clear() end
---@param x ROGameLibs.BoolVector
function ROGameLibs.BoolVectorVector:Add(x) end
---@param values ROGameLibs.BoolVectorVector
function ROGameLibs.BoolVectorVector:AddRange(values) end
---@return ROGameLibs.BoolVectorVector
---@param index number
---@param count number
function ROGameLibs.BoolVectorVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.BoolVector
function ROGameLibs.BoolVectorVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.BoolVectorVector
function ROGameLibs.BoolVectorVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.BoolVectorVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.BoolVectorVector:RemoveRange(index, count) end
---@return ROGameLibs.BoolVectorVector
---@param value ROGameLibs.BoolVector
---@param count number
function ROGameLibs.BoolVectorVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.BoolVectorVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.BoolVectorVector
function ROGameLibs.BoolVectorVector:SetRange(index, values) end
---@return System.Boolean_Array[]
function ROGameLibs.BoolVectorVector:VectorVectorToVectorList() end
return ROGameLibs.BoolVectorVector
