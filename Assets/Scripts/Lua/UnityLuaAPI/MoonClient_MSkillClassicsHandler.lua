---@class MoonClient.MSkillClassicsHandler : MoonClient.ISkillAbstractHandler

---@type MoonClient.MSkillClassicsHandler
MoonClient.MSkillClassicsHandler = { }
---@return MoonClient.MSkillClassicsHandler
function MoonClient.MSkillClassicsHandler.New() end
function MoonClient.MSkillClassicsHandler:Clear() end
function MoonClient.MSkillClassicsHandler:ClearWaitSkillEff() end
---@param skillCtrl MoonClient.UISkillController
function MoonClient.MSkillClassicsHandler:setSkillControl(skillCtrl) end
---@return MoonClient.MCsUICom
---@param index number
function MoonClient.MSkillClassicsHandler:getSlotCom(index) end
function MoonClient.MSkillClassicsHandler:InitQueueSlot() end
function MoonClient.MSkillClassicsHandler:initSpecialUI() end
---@param idx number
---@param slotCom MoonClient.MCsUICom
---@param nextQueue boolean
function MoonClient.MSkillClassicsHandler:initSkillSlot(idx, slotCom, nextQueue) end
---@param nextQueue boolean
function MoonClient.MSkillClassicsHandler:refreshSlots(nextQueue) end
function MoonClient.MSkillClassicsHandler:refreshCDs() end
function MoonClient.MSkillClassicsHandler:clearCastingSkill() end
---@param force boolean
function MoonClient.MSkillClassicsHandler:refreshCastingSkill(force) end
---@param go UnityEngine.GameObject
---@param isMain boolean
function MoonClient.MSkillClassicsHandler:QueueIdotObj(go, isMain) end
return MoonClient.MSkillClassicsHandler
