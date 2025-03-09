---@class ROGameLibs.StringSequence

---@type ROGameLibs.StringSequence
ROGameLibs.StringSequence = { }
---@overload fun(): ROGameLibs.StringSequence
---@overload fun(n:number): ROGameLibs.StringSequence
---@overload fun(seq:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_std__string_t): ROGameLibs.StringSequence
---@return ROGameLibs.StringSequence
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.StringSequence.New(cPtr, cMemoryOwn) end
function ROGameLibs.StringSequence:ReturnPool() end
---@return ROGameLibs.StringSequence
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.StringSequence.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.StringSequence.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.StringSequence:getPtr() end
function ROGameLibs.StringSequence:Dispose() end
---@return string
---@param i number
function ROGameLibs.StringSequence:GetItem(i) end
---@return number
function ROGameLibs.StringSequence:Size() end
---@return MoonCommonLib.MSeq_System.String
function ROGameLibs.StringSequence:SequenceToMSeq() end
return ROGameLibs.StringSequence
