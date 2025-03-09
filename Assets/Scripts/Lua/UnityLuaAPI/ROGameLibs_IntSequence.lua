---@class ROGameLibs.IntSequence

---@type ROGameLibs.IntSequence
ROGameLibs.IntSequence = { }
---@overload fun(): ROGameLibs.IntSequence
---@overload fun(n:number): ROGameLibs.IntSequence
---@overload fun(seq:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_int_t): ROGameLibs.IntSequence
---@return ROGameLibs.IntSequence
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.IntSequence.New(cPtr, cMemoryOwn) end
function ROGameLibs.IntSequence:ReturnPool() end
---@return ROGameLibs.IntSequence
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.IntSequence.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.IntSequence.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.IntSequence:getPtr() end
function ROGameLibs.IntSequence:Dispose() end
---@return number
---@param i number
function ROGameLibs.IntSequence:GetItem(i) end
---@return number
function ROGameLibs.IntSequence:Size() end
---@return MoonCommonLib.MSeq_System.Int32
function ROGameLibs.IntSequence:SequenceToMSeq() end
return ROGameLibs.IntSequence
