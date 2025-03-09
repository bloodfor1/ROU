---@class MoonClient.UISkillController : MoonClient.MBaseUI
---@field public FX_CLASSICS_CHOOSE_ID number
---@field public FX_CLASSICS_CACHE_ID number
---@field public FX_QTE_SKILL_ID number
---@field public FX_DOUBLE_RELEASE_ID number
---@field public FX_COMMON_COOLDOWN_ID number
---@field public FX_COMMON_SWAP_ID number
---@field public FX_QTE_COOLDOWN string
---@field public FX_CD_FINISHED string
---@field public MAX_CTRL_THUMB_DIS number
---@field public MIN_CTRL_THUMB_DIS number
---@field public MAX_CTRL_SKILL_RANGE number
---@field public MIN_CTRL_SKILL_RANGE number
---@field public SLOT_PAGE_COUNT number
---@field public MAX_SLOT_PAGE number
---@field public HasShowTip boolean
---@field public SlotScale System.Single[]
---@field public SLOT_PAGE_PLAYERPREFS string
---@field public Panel MoonClient.SkillControllerPanel
---@field public SlotPage number
---@field public CastingSkill MoonClient.MSkillCore
---@field public CastingOffset UnityEngine.Vector3
---@field public EffectOffset UnityEngine.Vector3
---@field public EffectLockCenter boolean
---@field public ThumbDownPos UnityEngine.Vector3
---@field public EffectLockTarget boolean
---@field public CastSlot MoonClient.MCsUICom
---@field public CastSkillInfo MoonClient.MSkillInfo
---@field public SkillHandler MoonClient.ISkillAbstractHandler

---@type MoonClient.UISkillController
MoonClient.UISkillController = { }
---@return MoonClient.UISkillController
function MoonClient.UISkillController.New() end
function MoonClient.UISkillController:Init() end
function MoonClient.UISkillController:Uninit() end
---@param deltaTime number
function MoonClient.UISkillController:Update(deltaTime) end
function MoonClient.UISkillController:OnLogout() end
---@param idx number
---@param amount number
function MoonClient.UISkillController:setSkillEnergy(idx, amount) end
---@param obj UnityEngine.GameObject
---@param fxId number
---@param userData System.Object
function MoonClient.UISkillController.SetEffObj(obj, fxId, userData) end
---@return MoonClient.MEntity
---@param castingSkill MoonClient.MSkillCore
---@param target MoonClient.MEntity
function MoonClient.UISkillController:GetTargetFilterSkill(castingSkill, target) end
---@return MoonClient.MEntity
---@param castingSkill MoonClient.MSkillCore
---@param target MoonClient.MEntity
function MoonClient.UISkillController:GetTargetFilterSkillIncludeAISelcetCache(castingSkill, target) end
---@return UnityEngine.Vector3
---@param index number
function MoonClient.UISkillController:GetSlotPosition(index) end
---@return number
---@param uiCom MoonClient.MCsUICom
function MoonClient.UISkillController:GetSlotIdx(uiCom) end
---@param stepId number
function MoonClient.UISkillController:ShowBeginnerGuide(stepId) end
---@return UnityEngine.GameObject
---@param skillId number
function MoonClient.UISkillController:GetSkillSlotGameObjectBySkillId(skillId) end
---@param page number
function MoonClient.UISkillController:SetSlotPage(page) end
return MoonClient.UISkillController
