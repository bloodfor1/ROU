--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleData.BeiluzCoreData", package.seeall)

professionAttrConfig = nil

--lua model end

--lua functions
function Init()

    InitData()
	
end --func end
--next--
function Logout()

    professionAttrConfig = nil
	
end --func end
--next--
--lua functions end
function InitData()
    maxWeight = getMaxWeight()
    maxLife = getMaxLife()
    warningTime = getWarningTime()
    addLifeConfig = getAddLifeConfig()
    coreLubricantPair = getCoreLubricantPair()
    lowWeightConfig = getLowWeightConfig()
    dayToSeconds = 86400			-- 天转秒
    hourToMillisecond = 3600			-- 小时转秒
end

-- 最大负重
function getMaxWeight()
    return MGlobalConfig:GetInt("WheelTotalWeight")
end

-- 齿轮最大寿命
function getMaxLife()
    local configStr = TableUtil.GetGlobalTable().GetRowByName("WheelMaxLifeValue")
    if not configStr then return {} end
    local config = parseKVPairs(configStr.Value)
    return config
end

-- 不足多少天时提示
function getWarningTime()
    return MGlobalConfig:GetInt("WheelWarningLifeValue")
end

-- 润滑剂增加寿命配置
function getAddLifeConfig()
    local configStr = TableUtil.GetGlobalTable().GetRowByName("LubricantEffect")
    if not configStr then return {} end
    local config = parseKVPairs(configStr.Value)
    return config
end

-- 齿轮消耗润滑剂配置
function getCoreLubricantPair()
    local config = {}
    for _,v in ipairs(TableUtil.GetWheelResetConsume().GetTable()) do
        config[v.WheelId] = {id = v.WheelLifeCost[0][0],count = v.WheelLifeCost[0][1]}
    end
    return config
end

function parseKVPairs(str)
    local result = {}
    if str and str ~= nil then
        local pairs = string.ro_split(str,'|')
        for _,pair in ipairs(pairs) do
            local kv = string.ro_split(pair,'=')
            if kv[1] == nil or kv[2] == nil then
                logError("@策划 解析配置错误 str="..str)
            else
                result[tonumber(kv[1])] = tonumber(kv[2])
            end
        end
    end
    return result
end

-- 极品负重配置
function getLowWeightConfig()
    local configStr = TableUtil.GetGlobalTable().GetRowByName("WheelRareWeight")
    if not configStr then return {} end
    local result = {}
    local pairs = string.ro_split(configStr.Value,'|')
    for _,pair in ipairs(pairs) do
        local kv = string.ro_split(pair,'=')
        if kv[1] == nil or kv[2] == nil then
            logError("@策划 解析配置错误 str="..str)
        else
            local tTable = {}
            for i = 2,#kv do
                tTable[tonumber(kv[i])] = true
            end
            result[tonumber(kv[1])] = tTable
        end
    end
    return result
end

-- 职业推荐技能
function GetProfessionAttrConfig()
    local result = {}
    local size = TableUtil.GetWheelSkillTable().GetTableSize()
    for i=1,size do
        local singleCfg = TableUtil.GetWheelSkillTable().GetRow(i)
        local profession = singleCfg.profession
        for j=0,profession.Length-1 do
            if result[profession[j]] == nil then
                result[profession[j]] = {}
            end
            result[profession[j]][singleCfg.BuffId] = true
        end
    end
    return result
end

--lua custom scripts

--lua custom scripts end
return ModuleData.BeiluzCoreData