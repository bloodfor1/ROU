---@class ROGameLibs.UIntVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item number
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.UIntVector
ROGameLibs.UIntVector = { }
---@overload fun(): ROGameLibs.UIntVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.UIntVector
---@overload fun(other:ROGameLibs.UIntVector): ROGameLibs.UIntVector
---@overload fun(capacity:number): ROGameLibs.UIntVector
---@return ROGameLibs.UIntVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.UIntVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.UIntVector:ReturnPool() end
---@return ROGameLibs.UIntVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.UIntVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.UIntVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.UIntVector:getPtr() end
function ROGameLibs.UIntVector:Dispose() end
---@overload fun(array:System.UInt32[]): void
---@overload fun(array:System.UInt32[], arrayIndex:number): void
---@param index number
---@param array System.UInt32[]
---@param arrayIndex number
---@param count number
function ROGameLibs.UIntVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.UIntVector.UIntVectorEnumerator
function ROGameLibs.UIntVector:GetEnumerator() end
function ROGameLibs.UIntVector:Clear() end
---@param x number
function ROGameLibs.UIntVector:Add(x) end
---@param values ROGameLibs.UIntVector
function ROGameLibs.UIntVector:AddRange(values) end
---@return ROGameLibs.UIntVector
---@param index number
---@param count number
function ROGameLibs.UIntVector:GetRange(index, count) end
---@param index number
---@param x number
function ROGameLibs.UIntVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.UIntVector
function ROGameLibs.UIntVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.UIntVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.UIntVector:RemoveRange(index, count) end
---@return ROGameLibs.UIntVector
---@param value number
---@param count number
function ROGameLibs.UIntVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.UIntVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.UIntVector
function ROGameLibs.UIntVector:SetRange(index, values) end
---@return boolean
---@param value number
function ROGameLibs.UIntVector:Contains(value) end
---@return number
---@param value number
function ROGameLibs.UIntVector:IndexOf(value) end
---@return number
---@param value number
function ROGameLibs.UIntVector:LastIndexOf(value) end
---@return boolean
---@param value number
function ROGameLibs.UIntVector:Remove(value) end
---@return System.UInt32[]
function ROGameLibs.UIntVector:VectorToArray() end
return ROGameLibs.UIntVector
