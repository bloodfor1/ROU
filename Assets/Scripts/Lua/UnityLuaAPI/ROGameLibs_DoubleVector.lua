---@class ROGameLibs.DoubleVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item number
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.DoubleVector
ROGameLibs.DoubleVector = { }
---@overload fun(): ROGameLibs.DoubleVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.DoubleVector
---@overload fun(other:ROGameLibs.DoubleVector): ROGameLibs.DoubleVector
---@overload fun(capacity:number): ROGameLibs.DoubleVector
---@return ROGameLibs.DoubleVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.DoubleVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.DoubleVector:ReturnPool() end
---@return ROGameLibs.DoubleVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.DoubleVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.DoubleVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.DoubleVector:getPtr() end
function ROGameLibs.DoubleVector:Dispose() end
---@overload fun(array:System.Double[]): void
---@overload fun(array:System.Double[], arrayIndex:number): void
---@param index number
---@param array System.Double[]
---@param arrayIndex number
---@param count number
function ROGameLibs.DoubleVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.DoubleVector.DoubleVectorEnumerator
function ROGameLibs.DoubleVector:GetEnumerator() end
function ROGameLibs.DoubleVector:Clear() end
---@param x number
function ROGameLibs.DoubleVector:Add(x) end
---@param values ROGameLibs.DoubleVector
function ROGameLibs.DoubleVector:AddRange(values) end
---@return ROGameLibs.DoubleVector
---@param index number
---@param count number
function ROGameLibs.DoubleVector:GetRange(index, count) end
---@param index number
---@param x number
function ROGameLibs.DoubleVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.DoubleVector
function ROGameLibs.DoubleVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.DoubleVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.DoubleVector:RemoveRange(index, count) end
---@return ROGameLibs.DoubleVector
---@param value number
---@param count number
function ROGameLibs.DoubleVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.DoubleVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.DoubleVector
function ROGameLibs.DoubleVector:SetRange(index, values) end
---@return boolean
---@param value number
function ROGameLibs.DoubleVector:Contains(value) end
---@return number
---@param value number
function ROGameLibs.DoubleVector:IndexOf(value) end
---@return number
---@param value number
function ROGameLibs.DoubleVector:LastIndexOf(value) end
---@return boolean
---@param value number
function ROGameLibs.DoubleVector:Remove(value) end
---@return System.Double[]
function ROGameLibs.DoubleVector:VectorToArray() end
return ROGameLibs.DoubleVector
