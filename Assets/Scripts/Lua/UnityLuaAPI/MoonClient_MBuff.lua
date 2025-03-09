---@class MoonClient.MBuff
---@field public AppendCount number
---@field public TotalTime number
---@field public LeftTime number
---@field public UpdateTime int64
---@field public IsVisible boolean
---@field public IsDebuff boolean
---@field public Data MoonClient.BuffTable.RowData
---@field public BuffID number
---@field public FirerUUID uint64
---@field public IsNeedUpdate boolean
---@field public UID uint64
---@field public IsChangeByNumber boolean
---@field public BuffStateTypeData number
---@field public BuffAttrDecision System.Collections.Generic.Dictionary_System.Int32_System.Int32

---@type MoonClient.MBuff
MoonClient.MBuff = { }
---@return MoonClient.MBuff
function MoonClient.MBuff.New() end
---@return number
---@param fxInfo MoonClient.MBuffFxInfo
function MoonClient.MBuff:playFx(fxInfo) end
---@param fDeltaT number
function MoonClient.MBuff:Update(fDeltaT) end
---@param list System.Collections.Generic.List_System.UInt64
function MoonClient.MBuff:AddRelatedEntityList(list) end
---@return uint64
---@param num number
function MoonClient.MBuff:GetRelatedEntityList(num) end
---@return boolean
---@param id uint64
---@param buffId number
---@param isPvP boolean
---@param entity MoonClient.MEntity
---@param playBeginFx boolean
---@param canPlayFx boolean
---@param appendCount number
---@param leftTime number
---@param firerUID uint64
---@param totalTime number
---@param buffAttrDecision System.Collections.Generic.Dictionary_System.Int32_System.Int32
function MoonClient.MBuff:Init(id, buffId, isPvP, entity, playBeginFx, canPlayFx, appendCount, leftTime, firerUID, totalTime, buffAttrDecision) end
function MoonClient.MBuff:AppendBuffChangeFx() end
---@param nxtFxId number
function MoonClient.MBuff:PlayLoopFx(nxtFxId) end
function MoonClient.MBuff:Uninit() end
---@param ignoreDestroyFx boolean
function MoonClient.MBuff:Stop(ignoreDestroyFx) end
function MoonClient.MBuff:Clear() end
---@return number
function MoonClient.MBuff:GetBuffLevel() end
---@return MoonClient.MBuffEffect
---@param inEffectGroupId number
function MoonClient.MBuff:TryGetBuffEffect(inEffectGroupId) end
---@return boolean
---@param skill_type number
function MoonClient.MBuff:HasDecontrolBuffEffect(skill_type) end
return MoonClient.MBuff
