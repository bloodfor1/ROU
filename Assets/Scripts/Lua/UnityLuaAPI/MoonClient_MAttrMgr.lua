---@class MoonClient.MAttrMgr : MoonCommonLib.MSingleton_MoonClient.MAttrMgr
---@field public PlayerAttr MoonClient.MAttrPlayer

---@type MoonClient.MAttrMgr
MoonClient.MAttrMgr = { }
---@return MoonClient.MAttrMgr
function MoonClient.MAttrMgr.New() end
---@return MoonClient.MAttrComponent
function MoonClient.MAttrMgr:InitDefaultAttr() end
---@return MoonClient.MAttrCollection
---@param uid uint64
---@param collectionId number
function MoonClient.MAttrMgr:InitCollectAttr(uid, collectionId) end
---@return MoonClient.MAttrNPC
---@param uid uint64
---@param name string
---@param npcID number
function MoonClient.MAttrMgr:InitNpcAttr(uid, name, npcID) end
---@return MoonClient.MAttrRole
---@param uid uint64
---@param name string
---@param professionID number
---@param isMale boolean
---@param isSelfMgrEntity boolean
---@param guildId int64
---@param guildName string
---@param guildPositionId number
---@param guildPositionName string
---@param guildIconId number
function MoonClient.MAttrMgr:InitRoleAttr(uid, name, professionID, isMale, isSelfMgrEntity, guildId, guildName, guildPositionId, guildPositionName, guildIconId) end
---@return MoonClient.MAttrMonster
---@param uid uint64
---@param name string
---@param entityId number
function MoonClient.MAttrMgr:InitMonsterAttr(uid, name, entityId) end
---@return MoonClient.MAttrPlayer
---@param uid uint64
---@param name string
---@param professionID number
---@param isMale boolean
---@param skills System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@param buffSkills System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
function MoonClient.MAttrMgr:InitPlayerAttr(uid, name, professionID, isMale, skills, buffSkills) end
---@return MoonClient.MAttrMirrorRole
---@param uid uint64
---@param name string
---@param professionID number
---@param isMale boolean
---@param guildId int64
---@param guildName string
---@param guildPositionId number
---@param guildPositionName string
---@param guildIconId number
function MoonClient.MAttrMgr:InitMirrorRoleAttr(uid, name, professionID, isMale, guildId, guildName, guildPositionId, guildPositionName, guildIconId) end
---@return MoonClient.MAttrMercenary
---@param uid uint64
---@param name string
---@param mercenaryId number
function MoonClient.MAttrMgr:InitMercenaryAttr(uid, name, mercenaryId) end
---@param attr MoonClient.MAttrComponent
function MoonClient.MAttrMgr:ReturnAttr(attr) end
return MoonClient.MAttrMgr
