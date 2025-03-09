---@class ROGameLibs.FloatVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item number
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.FloatVector
ROGameLibs.FloatVector = { }
---@overload fun(): ROGameLibs.FloatVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.FloatVector
---@overload fun(other:ROGameLibs.FloatVector): ROGameLibs.FloatVector
---@overload fun(capacity:number): ROGameLibs.FloatVector
---@return ROGameLibs.FloatVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.FloatVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.FloatVector:ReturnPool() end
---@return ROGameLibs.FloatVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.FloatVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.FloatVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.FloatVector:getPtr() end
function ROGameLibs.FloatVector:Dispose() end
---@overload fun(array:System.Single[]): void
---@overload fun(array:System.Single[], arrayIndex:number): void
---@param index number
---@param array System.Single[]
---@param arrayIndex number
---@param count number
function ROGameLibs.FloatVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.FloatVector.FloatVectorEnumerator
function ROGameLibs.FloatVector:GetEnumerator() end
function ROGameLibs.FloatVector:Clear() end
---@param x number
function ROGameLibs.FloatVector:Add(x) end
---@param values ROGameLibs.FloatVector
function ROGameLibs.FloatVector:AddRange(values) end
---@return ROGameLibs.FloatVector
---@param index number
---@param count number
function ROGameLibs.FloatVector:GetRange(index, count) end
---@param index number
---@param x number
function ROGameLibs.FloatVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.FloatVector
function ROGameLibs.FloatVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.FloatVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.FloatVector:RemoveRange(index, count) end
---@return ROGameLibs.FloatVector
---@param value number
---@param count number
function ROGameLibs.FloatVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.FloatVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.FloatVector
function ROGameLibs.FloatVector:SetRange(index, values) end
---@return boolean
---@param value number
function ROGameLibs.FloatVector:Contains(value) end
---@return number
---@param value number
function ROGameLibs.FloatVector:IndexOf(value) end
---@return number
---@param value number
function ROGameLibs.FloatVector:LastIndexOf(value) end
---@return boolean
---@param value number
function ROGameLibs.FloatVector:Remove(value) end
---@return System.Single[]
function ROGameLibs.FloatVector:VectorToArray() end
return ROGameLibs.FloatVector
