--lua model
module("ModuleData.BoliGroupData", package.seeall)
--lua model end

---------------------- 枚举 --------------------------
--UI激活对应函数枚举
EUIOpenType = 
{
    BoliFind = 1,
    BoliIllustration = 2,
    BoliRegion = 3
}
-------------------- END 枚举  ------------------------

---------------------- 变量数据 ---------------------------
--波利发现数据
BoliFindDatas = nil
BoliRegionDatas = nil
BoliTypeDatas = nil
-------------------- END 变量数据  ------------------------

---------------------- 生命周期 ---------------------------
--初始化
function Init( ... )
    InitRegionData()
    InitTypeData()
    InitData()
end

function InitRegionData( ... )
    local l_regionTable = TableUtil.GetRegionTable().GetTable()
    if l_regionTable == nil then
        logError("RegionTable is nil !")
        return  
    end
    BoliRegionDatas = {}
    for i=1,#l_regionTable do
        local l_region = l_regionTable[i]
        local l_regionData = {}
        l_regionData.regionId = l_region.RegionId
        l_regionData.level = l_region.ElfOpenLevel
        l_regionData.name = l_region.Name
        l_regionData.unlockPolly = {}
        l_regionData.awards = {}
        local l_awards = Common.Functions.VectorSequenceToTable(l_region.ElfAward) 

        for i=1,#l_awards do
            local l_award = {}
            l_award.regionId = l_regionData.regionId
            l_award.count = l_awards[i][1]
            l_award.awardId = l_awards[i][2]
            l_award.finish = false
            l_award.gotAward = false
            l_regionData.awards[l_award.count] = l_award
        end

        BoliRegionDatas[l_regionData.regionId] = l_regionData   
    end
end

function InitTypeData( ... )
    local l_elfTypeTable = TableUtil.GetElfTypeTable().GetTable()
    if l_elfTypeTable == nil then
        logError("ElfTypeTable is nil !")
        return  
    end
    BoliTypeDatas = {}
    for i=1,#l_elfTypeTable do
        local l_elfType = l_elfTypeTable[i]
        local l_elfTypeData = {}
        l_elfTypeData.typeId = l_elfType.ID
        l_elfTypeData.unlockCount = 0
        l_elfTypeData.awards = {}
        local l_awards = Common.Functions.VectorSequenceToTable(l_elfType.Award) 

        for i=1,#l_awards do
            local l_award = {}
            l_award.typeId = l_elfTypeData.typeId
            l_award.count = l_awards[i][1]
            l_award.awardId = l_awards[i][2]
            l_award.finish = false
            l_award.gotAward = false
            l_elfTypeData.awards[l_award.count] = l_award
        end

        BoliTypeDatas[l_elfTypeData.typeId] = l_elfTypeData   
    end
end

--登出重置
function Logout( ... )
    InitData()
    ResetData()
end
-------------------- END 生命周期  ------------------------


---------------------- 初始化方法 ---------------------------
--初始化数据
function InitData()
    BoliFindDatas = nil
end


function ResetData( ... )
    if BoliRegionDatas ~= nil then
        for k,v in pairs(BoliRegionDatas) do
            v.unlockPolly = {}     
            local l_awards = v.awards
            if l_awards ~= nil then
                for x,y in pairs(l_awards) do
                    y.finish = false
                    y.gotAward = false
                end
            end
        end
    end

    if BoliTypeDatas ~= nil then
        for k,v in pairs(BoliTypeDatas) do
            v.unlockCount = 0   
            local l_awards = v.awards
            if l_awards ~= nil then
                for x,y in pairs(l_awards) do
                    y.finish = false
                    y.gotAward = false
                end
            end
        end
    end
end

-------------------- END 初始化方法  ------------------------


------------------------------------------ 获取数据  -----------------------------------------------

--todo

--------------------------------------- END 获取数据  -----------------------------------------------



------------------------------------------ 设置数据  -----------------------------------------------
--设置波利团发现记录
function SetBoliFindDatas(boliInfoList)

    --从服务器返回的已发现的数据设置数据
    for i = 1, #boliInfoList do
        local l_row = TableUtil.GetElfTable().GetRowByID(boliInfoList[i].id)
        if l_row then
            UpdateBoliRegionDatas(boliInfoList[i])
            UpdateBoliTypeDatas(boliInfoList[i],l_row.ElfTypeID)
        end
    end

    --初始化波利数据结构
    BoliFindDatas = {}
    --从表中获取Boli全类型
    local l_rows = TableUtil.GetElfTypeTable().GetTable()
    for i = 1, #l_rows do
        local l_temp = {
            typeId = l_rows[i].ID,
            findNum = 0,
            findList = {}
        }
        table.insert(BoliFindDatas, l_temp)
    end
        
    --从服务器返回的已发现的数据设置数据
    for i = 1, #boliInfoList do
        local l_row = TableUtil.GetElfTable().GetRowByID(boliInfoList[i].id)
        if l_row then
            InsertBoliFindDatas(l_row.ElfTypeID, boliInfoList[i].scene_id)
        end
    end
    --根据场景ID的大小对发现记录进行排序
    for i = 1, #BoliFindDatas do
        table.sort(BoliFindDatas[i].findList, function (a, b)
            return a.sceneId < b.sceneId
        end )
    end
end

function SetBoliRegionAwardDatas(awards)
    for i=1,#awards do
        local l_data = awards[i]
        local l_regionData = BoliRegionDatas[l_data.id]
        if l_regionData ~= nil then
            local l_awards = l_regionData.awards
            local l_awardData = l_awards[l_data.count]
            if l_awardData ~= nil then
                l_awardData.finish = true
                l_awardData.gotAward = l_data.is_award
            end
        end
    end
end

function SetBoliTypeAwardDatas(awards)
    for i=1,#awards do
        local l_data = awards[i]
        local l_elfTypeData = BoliTypeDatas[l_data.id]
        if l_elfTypeData ~= nil then
            local l_awards = l_elfTypeData.awards
            local l_awardData = l_awards[l_data.count]
            if l_awardData ~= nil then
                l_awardData.finish = true
                l_awardData.gotAward = l_data.is_award
            end
        end
    end
end

--插入一条发现记录
function InsertBoliFindDatas(elfTypeId, findSceneId)
    for i = 1, #BoliFindDatas do
        --找到归属的类型记录
        local l_typeData = BoliFindDatas[i]
        if l_typeData.typeId == elfTypeId then
            l_typeData.findNum = l_typeData.findNum + 1
            --查找目标类型的目标场景发现记录
            local l_hasRecord = false
            for j = 1, #l_typeData.findList do
                local l_findRecord = l_typeData.findList[j]
                if l_findRecord.sceneId == findSceneId then
                    l_findRecord.num = l_findRecord.num + 1
                    l_hasRecord = true
                    break
                end
            end
            --如果之间没有目标场景的发现记录则新增一个
            if not l_hasRecord then
                local l_temp = {
                    sceneId = findSceneId,
                    num = 1
                }
                table.insert(l_typeData.findList, l_temp)
            end
            --返回索引用于插入单条数据插入后 仅维护单条数据的发现场景排序
            return i
        end
    end
end

function UpdateBoliRegionDatas(boliInfo)
    local l_regionId = boliInfo.region_id
    local l_regionData = BoliRegionDatas[l_regionId]
    if l_regionData ~= nil then
        local l_pollyData = {}
        l_pollyData.id = boliInfo.id
        l_pollyData.sceneId = boliInfo.scene_id
        l_pollyData.time = boliInfo.discover_time
        l_pollyData.gotAward = boliInfo.is_award
        l_regionData.unlockPolly[l_pollyData.id] = l_pollyData
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.PollySingleAward)
    end
end

function UpdateBoliTypeDatas(boliInfo,typeId)
    local l_elfTypeData = BoliTypeDatas[typeId]
    if l_elfTypeData ~= nil then
        l_elfTypeData.unlockCount = l_elfTypeData.unlockCount + 1
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.PollyTypeAward)
    end
end

function UpdatePollyAwardSingle(id)
    for k,v in pairs(BoliRegionDatas) do
        local l_polly = v.unlockPolly[id]
        if l_polly ~= nil then
            l_polly.gotAward = true
        end
    end
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.PollySingleAward)
end

function UpdatePollyAwardRegion(id,count,isNew)
    --logRed("id:"..tostring(id)..",count:"..tostring(count))
    local l_regionData = BoliRegionDatas[id]
    if l_regionData == nil then
        return 
    end
    local l_regionAward = l_regionData.awards[count]
    if l_regionAward == nil then
        return 
    end
    if isNew then
        l_regionAward.gotAward = false
        l_regionAward.finish = true
    else
        l_regionAward.gotAward = true
    end
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.PollyRegionAward)
end

function UpdatePollyAwardType(id,count,isNew)
    --logRed("id:"..tostring(id)..",count:"..tostring(count))
    local l_elfTypeData = BoliTypeDatas[id]
    if l_elfTypeData == nil then
        return 
    end
    local l_elfTypeAward = l_elfTypeData.awards[count]
    if l_elfTypeAward == nil then
        return 
    end
    if isNew then
        l_elfTypeAward.gotAward = false
        l_elfTypeAward.finish = true
    else
        l_elfTypeAward.gotAward = true
    end
    
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.PollyTypeAward)
end

--------------------------------------- END 设置数据  -----------------------------------------------






return ModuleData.BoliGroupData