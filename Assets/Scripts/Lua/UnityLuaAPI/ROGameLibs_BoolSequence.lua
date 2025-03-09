---@class ROGameLibs.BoolSequence

---@type ROGameLibs.BoolSequence
ROGameLibs.BoolSequence = { }
---@overload fun(): ROGameLibs.BoolSequence
---@overload fun(n:number): ROGameLibs.BoolSequence
---@overload fun(seq:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_bool_t): ROGameLibs.BoolSequence
---@return ROGameLibs.BoolSequence
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.BoolSequence.New(cPtr, cMemoryOwn) end
function ROGameLibs.BoolSequence:ReturnPool() end
---@return ROGameLibs.BoolSequence
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.BoolSequence.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.BoolSequence.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.BoolSequence:getPtr() end
function ROGameLibs.BoolSequence:Dispose() end
---@return boolean
---@param i number
function ROGameLibs.BoolSequence:GetItem(i) end
---@return number
function ROGameLibs.BoolSequence:Size() end
---@return MoonCommonLib.MSeq_System.Boolean
function ROGameLibs.BoolSequence:SequenceToMSeq() end
return ROGameLibs.BoolSequence
