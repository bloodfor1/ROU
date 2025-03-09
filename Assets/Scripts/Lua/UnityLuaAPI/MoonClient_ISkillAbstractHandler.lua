---@class MoonClient.ISkillAbstractHandler
---@field public qteEffDict System.Collections.Generic.Dictionary_System.Int32_MoonClient.QteEffectInfo
---@field public SkillState number

---@type MoonClient.ISkillAbstractHandler
MoonClient.ISkillAbstractHandler = { }
---@return MoonClient.ISkillAbstractHandler
function MoonClient.ISkillAbstractHandler.New() end
---@param idx number
---@param slotCom MoonClient.MCsUICom
---@param nextQueue boolean
function MoonClient.ISkillAbstractHandler:initSkillSlot(idx, slotCom, nextQueue) end
---@param nextQueue boolean
function MoonClient.ISkillAbstractHandler:refreshSlots(nextQueue) end
function MoonClient.ISkillAbstractHandler:refreshCDs() end
---@param force boolean
function MoonClient.ISkillAbstractHandler:refreshCastingSkill(force) end
function MoonClient.ISkillAbstractHandler:clearCastingSkill() end
---@param skillCtrl MoonClient.UISkillController
function MoonClient.ISkillAbstractHandler:setSkillControl(skillCtrl) end
---@return MoonClient.MCsUICom
---@param index number
function MoonClient.ISkillAbstractHandler:getSlotCom(index) end
function MoonClient.ISkillAbstractHandler:initSpecialUI() end
function MoonClient.ISkillAbstractHandler:ClearWaitSkillEff() end
function MoonClient.ISkillAbstractHandler:InitQueueSlot() end
---@param go UnityEngine.GameObject
---@param isMain boolean
function MoonClient.ISkillAbstractHandler:QueueIdotObj(go, isMain) end
function MoonClient.ISkillAbstractHandler:ClearEnergy() end
function MoonClient.ISkillAbstractHandler:Clear() end
function MoonClient.ISkillAbstractHandler:ClearQte() end
---@param slotCom MoonClient.MCsUICom
function MoonClient.ISkillAbstractHandler:hideSkillTip(slotCom) end
---@return number
---@param slot MoonClient.MCsUICom
function MoonClient.ISkillAbstractHandler:GetSlotIdxBySlotCom(slot) end
return MoonClient.ISkillAbstractHandler
