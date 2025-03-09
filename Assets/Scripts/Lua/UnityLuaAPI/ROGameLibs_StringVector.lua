---@class ROGameLibs.StringVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item string
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.StringVector
ROGameLibs.StringVector = { }
---@overload fun(): ROGameLibs.StringVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.StringVector
---@overload fun(other:ROGameLibs.StringVector): ROGameLibs.StringVector
---@overload fun(capacity:number): ROGameLibs.StringVector
---@return ROGameLibs.StringVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.StringVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.StringVector:ReturnPool() end
---@return ROGameLibs.StringVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.StringVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.StringVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.StringVector:getPtr() end
function ROGameLibs.StringVector:Dispose() end
---@overload fun(array:System.String[]): void
---@overload fun(array:System.String[], arrayIndex:number): void
---@param index number
---@param array System.String[]
---@param arrayIndex number
---@param count number
function ROGameLibs.StringVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.StringVector.StringVectorEnumerator
function ROGameLibs.StringVector:GetEnumerator() end
function ROGameLibs.StringVector:Clear() end
---@param x string
function ROGameLibs.StringVector:Add(x) end
---@param values ROGameLibs.StringVector
function ROGameLibs.StringVector:AddRange(values) end
---@return ROGameLibs.StringVector
---@param index number
---@param count number
function ROGameLibs.StringVector:GetRange(index, count) end
---@param index number
---@param x string
function ROGameLibs.StringVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.StringVector
function ROGameLibs.StringVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.StringVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.StringVector:RemoveRange(index, count) end
---@return ROGameLibs.StringVector
---@param value string
---@param count number
function ROGameLibs.StringVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.StringVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.StringVector
function ROGameLibs.StringVector:SetRange(index, values) end
---@return boolean
---@param value string
function ROGameLibs.StringVector:Contains(value) end
---@return number
---@param value string
function ROGameLibs.StringVector:IndexOf(value) end
---@return number
---@param value string
function ROGameLibs.StringVector:LastIndexOf(value) end
---@return boolean
---@param value string
function ROGameLibs.StringVector:Remove(value) end
---@return System.String[]
function ROGameLibs.StringVector:VectorToArray() end
return ROGameLibs.StringVector
