---@class ROGameLibs.UIntSequence

---@type ROGameLibs.UIntSequence
ROGameLibs.UIntSequence = { }
---@overload fun(): ROGameLibs.UIntSequence
---@overload fun(n:number): ROGameLibs.UIntSequence
---@overload fun(seq:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_unsigned_int_t): ROGameLibs.UIntSequence
---@return ROGameLibs.UIntSequence
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.UIntSequence.New(cPtr, cMemoryOwn) end
function ROGameLibs.UIntSequence:ReturnPool() end
---@return ROGameLibs.UIntSequence
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.UIntSequence.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.UIntSequence.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.UIntSequence:getPtr() end
function ROGameLibs.UIntSequence:Dispose() end
---@return number
---@param i number
function ROGameLibs.UIntSequence:GetItem(i) end
---@return number
function ROGameLibs.UIntSequence:Size() end
---@return MoonCommonLib.MSeq_System.UInt32
function ROGameLibs.UIntSequence:SequenceToMSeq() end
return ROGameLibs.UIntSequence
