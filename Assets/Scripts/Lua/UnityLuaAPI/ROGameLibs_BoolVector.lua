---@class ROGameLibs.BoolVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item boolean
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.BoolVector
ROGameLibs.BoolVector = { }
---@overload fun(): ROGameLibs.BoolVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.BoolVector
---@overload fun(other:ROGameLibs.BoolVector): ROGameLibs.BoolVector
---@overload fun(capacity:number): ROGameLibs.BoolVector
---@return ROGameLibs.BoolVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.BoolVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.BoolVector:ReturnPool() end
---@return ROGameLibs.BoolVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.BoolVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.BoolVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.BoolVector:getPtr() end
function ROGameLibs.BoolVector:Dispose() end
---@overload fun(array:System.Boolean[]): void
---@overload fun(array:System.Boolean[], arrayIndex:number): void
---@param index number
---@param array System.Boolean[]
---@param arrayIndex number
---@param count number
function ROGameLibs.BoolVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.BoolVector.BoolVectorEnumerator
function ROGameLibs.BoolVector:GetEnumerator() end
function ROGameLibs.BoolVector:Clear() end
---@param x boolean
function ROGameLibs.BoolVector:Add(x) end
---@param values ROGameLibs.BoolVector
function ROGameLibs.BoolVector:AddRange(values) end
---@return ROGameLibs.BoolVector
---@param index number
---@param count number
function ROGameLibs.BoolVector:GetRange(index, count) end
---@param index number
---@param x boolean
function ROGameLibs.BoolVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.BoolVector
function ROGameLibs.BoolVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.BoolVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.BoolVector:RemoveRange(index, count) end
---@return ROGameLibs.BoolVector
---@param value boolean
---@param count number
function ROGameLibs.BoolVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.BoolVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.BoolVector
function ROGameLibs.BoolVector:SetRange(index, values) end
---@return boolean
---@param value boolean
function ROGameLibs.BoolVector:Contains(value) end
---@return number
---@param value boolean
function ROGameLibs.BoolVector:IndexOf(value) end
---@return number
---@param value boolean
function ROGameLibs.BoolVector:LastIndexOf(value) end
---@return boolean
---@param value boolean
function ROGameLibs.BoolVector:Remove(value) end
---@return System.Boolean[]
function ROGameLibs.BoolVector:VectorToArray() end
return ROGameLibs.BoolVector
