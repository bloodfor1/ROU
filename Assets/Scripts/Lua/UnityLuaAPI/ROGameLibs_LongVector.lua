---@class ROGameLibs.LongVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item int64
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.LongVector
ROGameLibs.LongVector = { }
---@overload fun(): ROGameLibs.LongVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.LongVector
---@overload fun(other:ROGameLibs.LongVector): ROGameLibs.LongVector
---@overload fun(capacity:number): ROGameLibs.LongVector
---@return ROGameLibs.LongVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.LongVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.LongVector:ReturnPool() end
---@return ROGameLibs.LongVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.LongVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.LongVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.LongVector:getPtr() end
function ROGameLibs.LongVector:Dispose() end
---@overload fun(array:System.Int64[]): void
---@overload fun(array:System.Int64[], arrayIndex:number): void
---@param index number
---@param array System.Int64[]
---@param arrayIndex number
---@param count number
function ROGameLibs.LongVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.LongVector.LongVectorEnumerator
function ROGameLibs.LongVector:GetEnumerator() end
function ROGameLibs.LongVector:Clear() end
---@param x int64
function ROGameLibs.LongVector:Add(x) end
---@param values ROGameLibs.LongVector
function ROGameLibs.LongVector:AddRange(values) end
---@return ROGameLibs.LongVector
---@param index number
---@param count number
function ROGameLibs.LongVector:GetRange(index, count) end
---@param index number
---@param x int64
function ROGameLibs.LongVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.LongVector
function ROGameLibs.LongVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.LongVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.LongVector:RemoveRange(index, count) end
---@return ROGameLibs.LongVector
---@param value int64
---@param count number
function ROGameLibs.LongVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.LongVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.LongVector
function ROGameLibs.LongVector:SetRange(index, values) end
---@return boolean
---@param value int64
function ROGameLibs.LongVector:Contains(value) end
---@return number
---@param value int64
function ROGameLibs.LongVector:IndexOf(value) end
---@return number
---@param value int64
function ROGameLibs.LongVector:LastIndexOf(value) end
---@return boolean
---@param value int64
function ROGameLibs.LongVector:Remove(value) end
---@return System.Int64[]
function ROGameLibs.LongVector:VectorToArray() end
return ROGameLibs.LongVector
