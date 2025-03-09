---@class MoonClient.MSkillTargetMgr : MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr

---@type MoonClient.MSkillTargetMgr
MoonClient.MSkillTargetMgr = { }
---@return MoonClient.MSkillTargetMgr
function MoonClient.MSkillTargetMgr.New() end
---@return MoonClient.MEntity
function MoonClient.MSkillTargetMgr:GetAICacheShowPlayerTarget() end
---@return MoonClient.MEntity
function MoonClient.MSkillTargetMgr:GetLastTarget() end
---@return boolean
function MoonClient.MSkillTargetMgr:Init() end
function MoonClient.MSkillTargetMgr:Uninit() end
function MoonClient.MSkillTargetMgr:Update() end
function MoonClient.MSkillTargetMgr:UpdateToCheckTarget() end
---@param uid uint64
---@param isCallBack boolean
function MoonClient.MSkillTargetMgr:EnemyAim(uid, isCallBack) end
---@param monsterType number
function MoonClient.MSkillTargetMgr:FindEnemyByAimBtn(monsterType) end
---@return MoonClient.MEntity
---@param findEnemy boolean
---@param condition (fun(arg:MoonClient.MEntity):boolean)
function MoonClient.MSkillTargetMgr:FindEnemyBySkillBtn(findEnemy, condition) end
---@param uid uint64
function MoonClient.MSkillTargetMgr:FindTargetById(uid) end
---@param target MoonClient.MEntity
---@param isSelectTarget boolean
function MoonClient.MSkillTargetMgr:ResetTarget(target, isSelectTarget) end
---@return boolean
---@param target MoonClient.MEntity
function MoonClient.MSkillTargetMgr:OnSelectTarget(target) end
return MoonClient.MSkillTargetMgr
