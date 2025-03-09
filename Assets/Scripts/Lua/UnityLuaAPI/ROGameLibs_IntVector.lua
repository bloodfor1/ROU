---@class ROGameLibs.IntVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item number
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.IntVector
ROGameLibs.IntVector = { }
---@overload fun(): ROGameLibs.IntVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.IntVector
---@overload fun(other:ROGameLibs.IntVector): ROGameLibs.IntVector
---@overload fun(capacity:number): ROGameLibs.IntVector
---@return ROGameLibs.IntVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.IntVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.IntVector:ReturnPool() end
---@return ROGameLibs.IntVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.IntVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.IntVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.IntVector:getPtr() end
function ROGameLibs.IntVector:Dispose() end
---@overload fun(array:System.Int32[]): void
---@overload fun(array:System.Int32[], arrayIndex:number): void
---@param index number
---@param array System.Int32[]
---@param arrayIndex number
---@param count number
function ROGameLibs.IntVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.IntVector.IntVectorEnumerator
function ROGameLibs.IntVector:GetEnumerator() end
function ROGameLibs.IntVector:Clear() end
---@param x number
function ROGameLibs.IntVector:Add(x) end
---@param values ROGameLibs.IntVector
function ROGameLibs.IntVector:AddRange(values) end
---@return ROGameLibs.IntVector
---@param index number
---@param count number
function ROGameLibs.IntVector:GetRange(index, count) end
---@param index number
---@param x number
function ROGameLibs.IntVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.IntVector
function ROGameLibs.IntVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.IntVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.IntVector:RemoveRange(index, count) end
---@return ROGameLibs.IntVector
---@param value number
---@param count number
function ROGameLibs.IntVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.IntVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.IntVector
function ROGameLibs.IntVector:SetRange(index, values) end
---@return boolean
---@param value number
function ROGameLibs.IntVector:Contains(value) end
---@return number
---@param value number
function ROGameLibs.IntVector:IndexOf(value) end
---@return number
---@param value number
function ROGameLibs.IntVector:LastIndexOf(value) end
---@return boolean
---@param value number
function ROGameLibs.IntVector:Remove(value) end
---@return System.Int32[]
function ROGameLibs.IntVector:VectorToArray() end
return ROGameLibs.IntVector
