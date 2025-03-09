--lua model
module("ModuleData.AdventureDiaryData", package.seeall)
--lua model end

---------------------- 枚举 --------------------------
--UI激活对应函数枚举
EUIOpenType = 
{
    AdventureDiaryByAimIndex = 1,   --依据指定索引打开冒险日记界面
    AdventureDiaryTask = 2,         --冒险日记任务详细界面
    AdventureDiarySectionAward = 3, --冒险日记章节奖励预览界面
}
-------------------- END 枚举  ------------------------

---------------------- 变量数据 ---------------------------
getedAwardMissionIds = nil  --已获得奖励的冒险日记子任务id列表
getedAwardSectionIds = nil  --已获得奖励的冒险日记章节id列表
isGetChapterAward = nil  --是否已领取章节奖励
missionFinishCheckTaskIdList = nil  --全子任务ID

adventureDiaryInfo = nil  --冒险日记数据
chapterAwardIdCount = 0  --领取章节奖励需求的总任务数
chapterAwardIdFinishCount = 0  --领取章节奖励已完成的任务数
chapterAwardLimitChapter = 40  --章节奖励的章节数限制
-------------------- END 变量数据  ------------------------

---------------------- 生命周期 ---------------------------
--初始化
function Init( ... )
    InitData()
end

--登出重置
function Logout( ... )
    InitData()
end
-------------------- END 生命周期  ------------------------


---------------------- 初始化方法 ---------------------------
--初始化数据
function InitData()
    getedAwardMissionIds = nil
    getedAwardSectionIds = nil 
    isGetChapterAward = nil  
    missionFinishCheckTaskIdList = nil
    ReleaseAdventureData()
end

-------------------- END 初始化方法  ------------------------


------------------------------------------ 获取数据  -----------------------------------------------

--获取是否已领取章节奖励
function GetIsChapterAwardGeted()
    --cbt2 临时修改 返回恒为true
    --return isGetChapterAward == 1
    return true
end

--初始化冒险日记数据
function InitAdventureData()
    
    --任务完成监听列表重置
    missionFinishCheckTaskIdList = {}
    --章节奖励的章节数限制
    chapterAwardLimitChapter = MGlobalConfig:GetInt("PostcardRewardCondition")  
    --总奖励需求完成任务数重置
    chapterAwardIdCount = 0

    --初始化冒险日记的章节数据
    adventureDiaryInfo = {}
    local l_sectionTable = TableUtil.GetPostcardStringTable().GetTable()
    for i = 1, #l_sectionTable do
        local l_section = {}
        l_section.sectionData = l_sectionTable[i]
        l_section.missionInfos = {}
        table.insert(adventureDiaryInfo, l_section)
    end

    --获取子任务数据并填充进章节数据
    local l_missionDatas = TableUtil.GetPostcardDisplayTable().GetTable()
    for i = 1, #l_missionDatas do
        --将子任务数据插入对应章节
        local l_mission = {}
        l_mission.missionData = l_missionDatas[i]
        l_mission.isFinish = false
        l_mission.isGetAward = false
        l_mission.finishTime = 0  --完成时间 预留暂时不用
        table.insert(adventureDiaryInfo[l_mission.missionData.Chapter].missionInfos, l_mission)
        --设置完成任务监听列表
        missionFinishCheckTaskIdList[l_mission.missionData.FinishTaskId] = true
        --统计章节奖励总数
        if l_mission.missionData.Chapter <= chapterAwardLimitChapter then 
            chapterAwardIdCount = chapterAwardIdCount + 1
        end
    end
end

--更新冒险日记数据
function UpdateAdventureData()
    --判断原本是否有初始化的数据
    if not adventureDiaryInfo then
        InitAdventureData()
    end

    local l_showRedSign = false  --是否需要展示外部红点
    chapterAwardIdFinishCount = 0   --已完成任务数重置（用于总宝箱计算）

    for sectionIndex, sectionInfo in ipairs(adventureDiaryInfo) do
        sectionInfo.isUnlock = MPlayerInfo.Lv >= sectionInfo.sectionData.UnlockLevel  --是否已解锁
        --如果已解锁更新子任务数据
        if sectionInfo.isUnlock then
            for missionIndex, missionInfo in ipairs(sectionInfo.missionInfos) do
                --如果子任务原本未完成 检查是否目前完成了
                if not missionInfo.isFinish then
                    missionInfo.isFinish = MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(missionInfo.missionData.FinishTaskId)
                end
                --已完成的判断更新完成对应数据
                if missionInfo.isFinish then
                    --无完成时间则重新更新
                    if not missionInfo.finishTime then
                        missionInfo.finishTime = MgrMgr:GetMgr("TaskMgr").GetTaskFinishedTime(missionInfo.missionData.FinishTaskId)
                    end
                    --无领奖记录则重新更新
                    if not missionInfo.isGetAward then
                        missionInfo.isGetAward = CheckMissionIsGetAward(missionInfo.missionData.ID)
                    end
                    --已完成未领奖 则更新外部红点标志
                    if not missionInfo.isGetAward then
                        l_showRedSign = true
                    end
                    --章节奖励完成数统计
                    if missionInfo.missionData.Chapter <= chapterAwardLimitChapter then 
                        chapterAwardIdFinishCount = chapterAwardIdFinishCount + 1
                    end
                end
            end
        end
    end

    --返回手册界面是否需要红点
    return l_showRedSign
end

--根据指定的 完成确认任务ID获取冒险子任务信息
function GetMissionInfoByFinishTaskId(taskId)
    --确认数据已缓存
    if not adventureDiaryInfo then
        UpdateAdventureData()
    end
    --遍历章节
    for sectionIndex = 1, #adventureDiaryInfo do
        local l_sectionInfo = adventureDiaryInfo[sectionIndex]
        --遇到未解锁直接跳出循环
        if not l_sectionInfo.isUnlock then break end
        --遍历章节 判断是否含有目标任务ID是指定taskId的mission并记录
        for missionIndex = 1, #l_sectionInfo.missionInfos do
            local l_missionInfo = l_sectionInfo.missionInfos[missionIndex]
            if l_missionInfo.missionData.FinishTaskId == taskId then
                l_missionInfo.sectionIndex = sectionIndex     --章节索引
                l_missionInfo.missionIndex = missionIndex     --子任务索引
                return l_missionInfo
            end
        end
    end
end

--确认冒险日记子任务是否已领奖
--missionId  子任务id
function CheckMissionIsGetAward(missionId)
    for i = 1, #getedAwardMissionIds do
        if getedAwardMissionIds[i].value == missionId then
            return true
        end
    end
    return false
end

--确认冒险日记小章节宝箱是否已领奖
--sectionInfo  小章节数据
function CheckSectionIsGetAward(sectionInfo)
    for i = 1, #getedAwardSectionIds do
        if getedAwardSectionIds[i] == sectionInfo.sectionData.Chapter then
            return true
        end
    end
    return false
end

--确认冒险日记小章节宝箱是否可领奖
--sectionInfo  小章节数据
function CheckSectionCanGetAward(sectionInfo)
    --获取对应小章节数据
    if not sectionInfo then return false end
    --判断是否可领取
    for k,v in pairs(sectionInfo.missionInfos) do
        if not v.isGetAward then   --存在未领取的子任务奖励则返回不可领取
            return false
        end
    end
    return true
end
--------------------------------------- END 获取数据  -----------------------------------------------



------------------------------------------ 设置数据  -----------------------------------------------
--设置冒险日记数据
function SetAdventureDiaryInfo(info)
    getedAwardMissionIds = info.table_ids or {}
    getedAwardSectionIds = info.chapter_ids or {}
    isGetChapterAward = info.chapter_award
end


--------------------------------------- END 设置数据  -----------------------------------------------


------------------------------------------ 数据释放  -----------------------------------------------
--清理冒险日记数据
function ReleaseAdventureData()
    adventureDiaryInfo = nil
    chapterAwardIdCount = 0 
    chapterAwardIdFinishCount = 0
end

--------------------------------------- END 数据释放  -----------------------------------------------




return ModuleData.AdventureDiaryData