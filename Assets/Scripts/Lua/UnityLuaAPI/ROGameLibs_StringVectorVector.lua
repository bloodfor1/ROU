---@class ROGameLibs.StringVectorVector
---@field public IsFixedSize boolean
---@field public IsReadOnly boolean
---@field public Item ROGameLibs.StringVector
---@field public Capacity number
---@field public Count number
---@field public IsSynchronized boolean

---@type ROGameLibs.StringVectorVector
ROGameLibs.StringVectorVector = { }
---@overload fun(): ROGameLibs.StringVectorVector
---@overload fun(c:System.Collections.ICollection): ROGameLibs.StringVectorVector
---@overload fun(other:ROGameLibs.StringVectorVector): ROGameLibs.StringVectorVector
---@overload fun(capacity:number): ROGameLibs.StringVectorVector
---@return ROGameLibs.StringVectorVector
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.StringVectorVector.New(cPtr, cMemoryOwn) end
function ROGameLibs.StringVectorVector:ReturnPool() end
---@return ROGameLibs.StringVectorVector
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.StringVectorVector.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.StringVectorVector.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.StringVectorVector:getPtr() end
function ROGameLibs.StringVectorVector:Dispose() end
---@overload fun(array:ROGameLibs.StringVector[]): void
---@overload fun(array:ROGameLibs.StringVector[], arrayIndex:number): void
---@param index number
---@param array ROGameLibs.StringVector[]
---@param arrayIndex number
---@param count number
function ROGameLibs.StringVectorVector:CopyTo(index, array, arrayIndex, count) end
---@return ROGameLibs.StringVectorVector.StringVectorVectorEnumerator
function ROGameLibs.StringVectorVector:GetEnumerator() end
function ROGameLibs.StringVectorVector:Clear() end
---@param x ROGameLibs.StringVector
function ROGameLibs.StringVectorVector:Add(x) end
---@param values ROGameLibs.StringVectorVector
function ROGameLibs.StringVectorVector:AddRange(values) end
---@return ROGameLibs.StringVectorVector
---@param index number
---@param count number
function ROGameLibs.StringVectorVector:GetRange(index, count) end
---@param index number
---@param x ROGameLibs.StringVector
function ROGameLibs.StringVectorVector:Insert(index, x) end
---@param index number
---@param values ROGameLibs.StringVectorVector
function ROGameLibs.StringVectorVector:InsertRange(index, values) end
---@param index number
function ROGameLibs.StringVectorVector:RemoveAt(index) end
---@param index number
---@param count number
function ROGameLibs.StringVectorVector:RemoveRange(index, count) end
---@return ROGameLibs.StringVectorVector
---@param value ROGameLibs.StringVector
---@param count number
function ROGameLibs.StringVectorVector.Repeat(value, count) end
---@overload fun(): void
---@param index number
---@param count number
function ROGameLibs.StringVectorVector:Reverse(index, count) end
---@param index number
---@param values ROGameLibs.StringVectorVector
function ROGameLibs.StringVectorVector:SetRange(index, values) end
---@return System.String_Array[]
function ROGameLibs.StringVectorVector:VectorVectorToVectorList() end
return ROGameLibs.StringVectorVector
