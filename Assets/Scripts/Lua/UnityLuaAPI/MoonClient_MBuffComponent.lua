---@class MoonClient.MBuffComponent : MoonClient.MComponent
---@field public BuffAutoFishUid uint64
---@field public NOT_CONTAIN_IN_SKILL_INFO number
---@field public ID number
---@field public BuffDict System.Collections.Generic.Dictionary_System.UInt64_MoonClient.MBuff
---@field public AutoFishLeftTime number

---@type MoonClient.MBuffComponent
MoonClient.MBuffComponent = { }
---@return MoonClient.MBuffComponent
function MoonClient.MBuffComponent.New() end
---@param fDeltaT number
function MoonClient.MBuffComponent:Update(fDeltaT) end
function MoonClient.MBuffComponent:OnDetachFromHost() end
---@param hostObj MoonClient.MObject
function MoonClient.MBuffComponent:OnAttachToHost(hostObj) end
function MoonClient.MBuffComponent:Clear() end
---@param visibleList System.Collections.Generic.List_System.UInt64
function MoonClient.MBuffComponent:UpdateVisibleHiding(visibleList) end
---@return boolean
---@param entityId uint64
function MoonClient.MBuffComponent:IsExistInVisibleList(entityId) end
---@return boolean
function MoonClient.MBuffComponent:IsBuffStateMutex() end
---@param uuid uint64
---@param id number
---@param playBeginFx boolean
---@param appendCount number
---@param leftTime number
---@param firer_uuid uint64
---@param totalTime number
---@param RelatedEntityUuids System.Collections.Generic.List_System.UInt64
---@param buffAttrDecision System.Collections.Generic.Dictionary_System.Int32_System.Int32
function MoonClient.MBuffComponent:OnBuffAdd(uuid, id, playBeginFx, appendCount, leftTime, firer_uuid, totalTime, RelatedEntityUuids, buffAttrDecision) end
---@return MoonClient.MBuff
---@param uuid uint64
function MoonClient.MBuffComponent:TryGetBuff(uuid) end
---@param uuid uint64
---@param ignoreDestroyFx boolean
function MoonClient.MBuffComponent:OnBuffRemove(uuid, ignoreDestroyFx) end
---@return boolean
---@param stateTypeStart number
---@param stateTypeEnd number
function MoonClient.MBuffComponent:HasBuffStateInTheRange(stateTypeStart, stateTypeEnd) end
---@return boolean
---@param skill_type number
function MoonClient.MBuffComponent:HasDeControlBuff(skill_type) end
---@return boolean
---@param buff_id number
function MoonClient.MBuffComponent:HasBuff(buff_id) end
---@return MoonClient.MBuff
---@param buff_id number
function MoonClient.MBuffComponent:GetBuff(buff_id) end
---@param buff_id uint64
function MoonClient.MBuffComponent:CancelBuff(buff_id) end
---@return number
---@param core MoonClient.MSkillCore
function MoonClient.MBuffComponent:GetSkillOriginID(core) end
---@return number
---@param t number
---@param skill_id number
function MoonClient.MBuffComponent:TryGetSkillInfo(t, skill_id) end
---@return number
---@param t number
---@param skill_id number
function MoonClient.MBuffComponent:GetSkillInfo(t, skill_id) end
---@param t number
---@param skill_id number
---@param t number
function MoonClient.MBuffComponent:AfterSetSkillInfo(t, skill_id, t) end
---@param t number
---@param skill_id number
---@param t number
function MoonClient.MBuffComponent:SetSkillInfoChange(t, skill_id, t) end
---@return DG.Tweening.Tween
---@param time number
---@param intensityBegin number
---@param intensityEnd number
---@param color UnityEngine.Color
---@param roundness number
function MoonClient.MBuffComponent:DoGradient(time, intensityBegin, intensityEnd, color, roundness) end
---@param buff MoonClient.MBuff
---@param val MoonClient.MBuffEffectDarknessData
function MoonClient.MBuffComponent:AddBuffEffectDarkness(buff, val) end
---@param equipPos number
---@param buff MoonClient.MBuff
function MoonClient.MBuffComponent:AddDisableEquipPos(equipPos, buff) end
---@param equipPos number
function MoonClient.MBuffComponent:RemoveDisableEquipPos(equipPos) end
---@return boolean
---@param equipPos number
function MoonClient.MBuffComponent:IsEquipDisableByBuff(equipPos) end
---@param buff MoonClient.MBuff
function MoonClient.MBuffComponent:RemoveBuffEffectDarkness(buff) end
---@param buffUid uint64
---@param isAdd boolean
function MoonClient.MBuffComponent:ChangeBuffEffectStateMutex(buffUid, isAdd) end
---@return number
function MoonClient.MBuffComponent:GetBuffEffectDarknessRadius() end
---@param itemId number
function MoonClient.MBuffComponent:OnAddBuffEffectVehicle(itemId) end
function MoonClient.MBuffComponent:OnRemoveBuffEffectVehicle() end
---@return number
function MoonClient.MBuffComponent:GetBuffEffectVehicleId() end
---@return System.Collections.Generic.Dictionary_System.UInt64_MoonClient.MBuffLuaInfo
function MoonClient.MBuffComponent:GetBuffInfoByLua() end
return MoonClient.MBuffComponent
