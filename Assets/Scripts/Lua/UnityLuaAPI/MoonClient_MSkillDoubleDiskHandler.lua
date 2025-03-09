---@class MoonClient.MSkillDoubleDiskHandler : MoonClient.ISkillAbstractHandler

---@type MoonClient.MSkillDoubleDiskHandler
MoonClient.MSkillDoubleDiskHandler = { }
---@return MoonClient.MSkillDoubleDiskHandler
function MoonClient.MSkillDoubleDiskHandler.New() end
function MoonClient.MSkillDoubleDiskHandler:Clear() end
---@param skillCtrl MoonClient.UISkillController
function MoonClient.MSkillDoubleDiskHandler:setSkillControl(skillCtrl) end
---@return MoonClient.MCsUICom
---@param index number
function MoonClient.MSkillDoubleDiskHandler:getSlotCom(index) end
---@param idx number
---@param slotCom MoonClient.MCsUICom
---@param nextQueue boolean
function MoonClient.MSkillDoubleDiskHandler:initSkillSlot(idx, slotCom, nextQueue) end
function MoonClient.MSkillDoubleDiskHandler:InitQueueSlot() end
---@return boolean
---@param targetPos UnityEngine.Vector3
---@param effectOffset UnityEngine.Vector3
---@param skillCore MoonClient.MSkillCore
function MoonClient.MSkillDoubleDiskHandler.NeedCanceling(targetPos, effectOffset, skillCore) end
---@return boolean
---@param castPos UnityEngine.Vector3
---@param dir UnityEngine.Vector3
---@param a number
---@param b number
function MoonClient.MSkillDoubleDiskHandler.IsSkillRangeValid(castPos, dir, a, b) end
---@param nextQueue boolean
function MoonClient.MSkillDoubleDiskHandler:refreshSlots(nextQueue) end
function MoonClient.MSkillDoubleDiskHandler:refreshCDs() end
function MoonClient.MSkillDoubleDiskHandler:clearCastingSkill() end
---@param force boolean
function MoonClient.MSkillDoubleDiskHandler:refreshCastingSkill(force) end
---@param go UnityEngine.GameObject
---@param isMain boolean
function MoonClient.MSkillDoubleDiskHandler:QueueIdotObj(go, isMain) end
return MoonClient.MSkillDoubleDiskHandler
