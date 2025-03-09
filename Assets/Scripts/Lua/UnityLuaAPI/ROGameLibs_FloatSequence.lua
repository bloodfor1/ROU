---@class ROGameLibs.FloatSequence

---@type ROGameLibs.FloatSequence
ROGameLibs.FloatSequence = { }
---@overload fun(): ROGameLibs.FloatSequence
---@overload fun(n:number): ROGameLibs.FloatSequence
---@overload fun(seq:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_float_t): ROGameLibs.FloatSequence
---@return ROGameLibs.FloatSequence
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.FloatSequence.New(cPtr, cMemoryOwn) end
function ROGameLibs.FloatSequence:ReturnPool() end
---@return ROGameLibs.FloatSequence
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.FloatSequence.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.FloatSequence.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.FloatSequence:getPtr() end
function ROGameLibs.FloatSequence:Dispose() end
---@return number
---@param i number
function ROGameLibs.FloatSequence:GetItem(i) end
---@return number
function ROGameLibs.FloatSequence:Size() end
---@return MoonCommonLib.MSeq_System.Single
function ROGameLibs.FloatSequence:SequenceToMSeq() end
return ROGameLibs.FloatSequence
