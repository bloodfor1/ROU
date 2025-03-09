
module("ModuleData.TowerDefenseModuleData", package.seeall)

ESkillType={
    DungeonSkill=1,
    AttackBless=2,
    DefenseBless=3
}

EMagicChangeType={
    --怪物掉落
    Drop=3,
    --跳过等待时间
    Skip=4
}

TowerDefenseMagicPowerData=nil
TowerDefenseSyncMonsterData=nil
TDAwardDatas=nil
CurrentWaveData=nil

local l_attackBlessSkillI=0
local l_defenseBlessSkillId=0
local l_getAwardIds={}
local l_awardTaskProgress={}
local l_currentWaveTableDatas=nil

function ClearAllData()
    TowerDefenseMagicPowerData=nil
    TowerDefenseSyncMonsterData=nil
    TDAwardDatas=nil
    CurrentWaveData=nil
    l_currentWaveTableDatas=nil
end

function Logout()
    ClearAllData()
    l_attackBlessSkillI=0
    l_defenseBlessSkillId=0
    l_getAwardIds={}
    l_awardTaskProgress={}
end

--得到死的怪物的数量
function GetDeadMonsterCount()
    if TowerDefenseSyncMonsterData == nil then
        return 0
    end
    return TowerDefenseSyncMonsterData.dead_monster_count
end

--得到总怪物数量
function GetTotalMonsterCount()
    if TowerDefenseSyncMonsterData == nil then
        return 0
    end
    return TowerDefenseSyncMonsterData.total_monster_count
end

--根据类型得到技能数据
function GetSkillTableInfoWithType(skillType)
    local l_TableInfos= TableUtil.GetTdOrderTable().GetTable()
    
    local l_skillInfos={}

    for i = 1, #l_TableInfos do
        if l_TableInfos[i].Type == skillType then
            table.insert(l_skillInfos,l_TableInfos[i])
        end
    end

    return l_skillInfos
end

function SetAttackBlessSkillId(attackBlessSkillI)
    l_attackBlessSkillI=attackBlessSkillI
end

function SetDefenseBlessSkillId(defenseBlessSkillId)
    l_defenseBlessSkillId=defenseBlessSkillId
end

function GetAttackBlessSkillId()
    return l_attackBlessSkillI
end

function GetDefenseBlessSkillId()
    return l_defenseBlessSkillId
end

--设置是否领奖
--type是任务的类型
--isGetAward每一位都对应了表id的个位
function SetIsGetAwardWithType(type,isGetAward)
    l_getAwardIds[type]=isGetAward
end

--是否已领奖
function IsGetAwardWithId(id,type)

    local l_tableIdIndex=id%10
    local l_isGetAward= l_getAwardIds[type]
    if l_isGetAward == nil then
        return false
    end

    --logGreen("id:"..tostring(id))
    --logGreen("l_isGetAward:"..tostring(l_isGetAward))
    --logGreen("l_tableIdIndex:"..tostring(l_tableIdIndex))
    --logGreen("isGetAward:"..tostring(ExtensionByQX.MathHelper.IsLogicContainBitWithIndex(l_isGetAward,l_tableIdIndex)))
    return ExtensionByQX.MathHelper.IsLogicContainBitWithIndex(l_isGetAward,l_tableIdIndex)
end

--设置每周奖励任务的进度
function SetAwardTaskProgress(type,progress)
    --logGreen("progress:"..tostring(progress))
    l_awardTaskProgress[type]=progress
end

--得到每周奖励任务的进度
function GetAwardTaskProgressWithType(type)
    local l_progress=l_awardTaskProgress[type]
    if l_progress == nil then
        return 0
    end
    return l_awardTaskProgress[type]
end

--设置奖励预览的数据
function SetTDAwardDatas(result)
    if result == nil then
        return
    end
    TDAwardDatas={}
    for i = 1, #result do
        TDAwardDatas[result[i].award_id] = result[i].award_list
    end
end

--取奖励预览的数据
function GetTDAwardDataWithAwardId(awardId)
    if TDAwardDatas == nil then
        return nil
    end
    return TDAwardDatas[awardId]
end

--得到技能CD
function GetSkillCdWithId(id)
    if TowerDefenseMagicPowerData == nil then
        return 0
    end
    local l_cdList=TowerDefenseMagicPowerData.cmd_cd_list
    if l_cdList == nil then
        return 0
    end
    local l_cdListCount=#l_cdList
    if l_cdListCount == 0 then
        return 0
    end

    local l_fightSkillTime
    for i = 1, l_cdListCount do
        if l_cdList[i].cmd == id then
            l_fightSkillTime= l_cdList[i].cmd_timestamp
            break
        end
    end

    if l_fightSkillTime == nil then
        return 0
    end
    l_fightSkillTime=MLuaCommonHelper.Long2Int(l_fightSkillTime)
    local l_currentTime = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
    local l_OrderTableInfo = TableUtil.GetTdOrderTable().GetRowByID(id)

    local l_cd=l_OrderTableInfo.CoolDown-(l_currentTime-l_fightSkillTime)
    if l_cd < 0 then
        return 0
    end
    return l_cd
end

--得到总的完成波数
function GetTotalFinishWaveCount()
    if CurrentWaveData == nil then
        return 0
    end
    return CurrentWaveData.finish_wave_count
end

--得到普通模式的完成波数
function GetNormalModeFinishWaveCount()
    local l_finishWaveCount=GetTotalFinishWaveCount()
    local l_maxWaveCount=GetMaxWaveCount()
    if l_finishWaveCount<l_maxWaveCount then
        return l_finishWaveCount
    end
    return l_maxWaveCount
end

--当前副本的Wave表数据
function GetCurrentWaveTableDatas()
    if l_currentWaveTableDatas == nil then
        l_currentWaveTableDatas={}
        local l_TdWaveTable= TableUtil.GetTdWaveTable().GetTable()
        for i = 1, #l_TdWaveTable do
            if l_TdWaveTable[i].DungeonID == MPlayerDungeonsInfo.DungeonID then
                if l_TdWaveTable[i].Wave>0 then
                    l_currentWaveTableDatas[l_TdWaveTable[i].Wave]=l_TdWaveTable[i]
                end
            end
        end
    end
    return l_currentWaveTableDatas
end

--得到总关数
function GetMaxWaveCount()
    local l_currentWave=GetCurrentWaveTableDatas()
    if l_currentWave==nil then
        return 0
    end
    return table.ro_size(l_currentWave)
end

--得到相应波数的表数据
function GetWaveTableDataWithIndex(index)
    local l_currentWave=GetCurrentWaveTableDatas()
    if l_currentWave==nil then
        return nil
    end
    return l_currentWave[index]
end

