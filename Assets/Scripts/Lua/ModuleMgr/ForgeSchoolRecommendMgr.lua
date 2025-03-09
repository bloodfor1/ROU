---@module ModuleMgr.ForgeSchoolRecommendMgr
module("ModuleMgr.ForgeSchoolRecommendMgr", package.seeall)

--- 枚举和名字映射
local C_SCHOOL_FEATURE_TYPE_NAME_MAP = {
    [GameEnum.ESchoolFeatureType.Support] = Common.Utils.Lang("C_SUPPORT"),
    [GameEnum.ESchoolFeatureType.Attack] = Common.Utils.Lang("C_ATTACK"),
    [GameEnum.ESchoolFeatureType.Defence] = Common.Utils.Lang("C_DEFEND"),
}

currentSelectedSchoolID = 0

--- 返回所有的流派推荐表的数据
---@return ProfessionTextTable[]
function GetForgeRecommendSchoolList()
    return _getProMatchStyles()
end

--- 获取指定流派的名字
---@return string
function GetFeatureNameByType(featureID)
    if nil == featureID then
        logError("[ForgeSchoolRecommendMgr] invalid param")
        return nil
    end

    local targetName = C_SCHOOL_FEATURE_TYPE_NAME_MAP[featureID]
    return targetName
end

function GetSelectID()
    return currentSelectedSchoolID
end

function SetSelectedSchoolID(id)
    currentSelectedSchoolID = id
end

function ClearSelectedID()
    currentSelectedSchoolID = 0
end

--- 获取玩家加点匹配到的流派ID
---@return number
function GetPlayerAttrMatchID()
    local playerLv = MPlayerInfo.Lv
    local configList = _getProMatchStyles()
    local C_ATTR_MATCH_MAP = {
        [AttrType.ATTR_BASIC_STR] = 1,
        [AttrType.ATTR_BASIC_INT] = 1,
        [AttrType.ATTR_BASIC_AGI] = 1,
        [AttrType.ATTR_BASIC_VIT] = 1,
        [AttrType.ATTR_BASIC_DEX] = 1,
        [AttrType.ATTR_BASIC_LUK] = 1,
    }

    local roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
    for i = 1, #configList do
        local singleConfig = configList[i]
        local id = singleConfig.NAME
        local tableKey = _genPlayerStyleAttrKey(playerLv, id)
        local config = TableUtil.GetAttraddMatchTable().GetRowByProfession(tableKey, true)
        if nil ~= config then
            local match = true
            for attrID, value in pairs(C_ATTR_MATCH_MAP) do
                local standardValue = _getStandardValue(attrID, config)
                local currentValue = roleInfoMgr.GetRoleBasicAttr(attrID)
                if standardValue > currentValue then
                    match = false
                    break
                end
            end

            if match then
                return id
            end
        end
    end

    return 0
end

--- 获取玩家技能匹配到的流派ID
---@return number
function GetPlayerSkillMatchID()
    local skillConfigList = TableUtil.GetSkillMatchTable().GetTable()
    local playerLv = MPlayerInfo.Lv
    local idHash = _genStyleHash()
    ---@type SkillMatchTable
    local ret = nil
    for i = 1, #skillConfigList do
        local singleConfig = skillConfigList[i]
        local lvValid = playerLv >= singleConfig.MinLv and playerLv < singleConfig.MaxLv
        local idValid = nil ~= idHash[singleConfig.Profession]
        local skillValid = _skillConfigMatch(singleConfig)
        if lvValid and idValid and skillValid then
            ret = singleConfig
        end
    end

    if nil == ret then
        return 0
    end

    return ret.Profession
end

--- 返回配置是否满足技能加点情况
---@param config SkillMatchTable
---@return boolean
function _skillConfigMatch(config)
    if nil == config then
        logError("[ForgeRecommend] invalid param")
        return false
    end

    local C_MAX_SKILL_COUNT = 5
    for i = 1, C_MAX_SKILL_COUNT do
        local skillID, skillLv = _getSkillConfigByIdx(i, config)
        local result = _skillMatch(skillID, skillLv)
        if not result then
            return false
        end
    end

    return true
end

--- 判断玩家已经有的技能是否满足情况
---@return boolean
function _skillMatch(skillID, skillLv)
    if nil == skillID or nil == skillLv then
        logError("[ForgeRecommend] invalid param")
        return false
    end

    if 0 == skillID then
        return true
    end

    local skillData = DataMgr:GetData("SkillData")
    local currentSkillLv = skillData.GetAddedSkillPoint(skillID, false)
    return currentSkillLv >= skillLv
end

---@param config SkillMatchTable
---@return number, number
function _getSkillConfigByIdx(idx, config)
    if nil == idx or nil == config then
        logError("[ForgeRecommend] invalid param")
        return 0, 0
    end

    if 1 == idx then
        return config.Skill_Id_0, config.Skill_Lv_0
    elseif 2 == idx then
        return config.Skill_Id_1, config.Skill_Lv_1
    elseif 3 == idx then
        return config.Skill_Id_2, config.Skill_Lv_2
    elseif 4 == idx then
        return config.Skill_Id_3, config.Skill_Lv_3
    elseif 5 == idx then
        return config.Skill_Id_4, config.Skill_Lv_4
    else
        logError("[ForgeRecommend] invalid idx: " .. tostring(idx))
    end

    return 0, 0
end

---@param attrID number
---@param config AttraddMatchTable
function _getStandardValue(attrID, config)
    if nil == config or nil == attrID then
        logError("[ForgeRecommend] invalid param")
        return -1
    end

    if AttrType.ATTR_BASIC_STR == attrID then
        return config.STR
    elseif AttrType.ATTR_BASIC_INT == attrID then
        return config.INT
    elseif AttrType.ATTR_BASIC_AGI == attrID then
        return config.AGI
    elseif AttrType.ATTR_BASIC_VIT == attrID then
        return config.VIT
    elseif AttrType.ATTR_BASIC_DEX == attrID then
        return config.DEX
    elseif AttrType.ATTR_BASIC_LUK == attrID then
        return config.LUK
    else
        -- do nothing
    end

    return -1
end

--- 返回所有的流派推荐表的数据
---@return ProfessionTextTable[]
function _getProMatchStyles()
    local styleHash = _genStyleHash()
    local schoolTableList = TableUtil.GetProfessionTextTable().GetTable()
    local ret = {}
    for i = 1, #schoolTableList do
        local singleConfig = schoolTableList[i]
        if nil ~= styleHash[singleConfig.NAME] then
            table.insert(ret, singleConfig)
        end
    end

    return ret
end

---@return table<number, number>
function _genStyleHash()
    local playerProfession = MPlayerInfo.ProID
    local professionConfigList = TableUtil.GetProfessionTable().GetRowById(playerProfession)
    local styleHash = {}
    if nil == professionConfigList then
        logError("[ForgeRecommend] invalid pro id: " .. tostring(playerProfession))
        return styleHash
    end

    local recommendArray = _parseProfessionRecommendStyles(professionConfigList.AttrRecommend)
    for i = 1, #recommendArray do
        local singleStyleID = recommendArray[i]
        styleHash[singleStyleID] = 1
    end

    return styleHash
end

function _parseProfessionRecommendStyles(str)
    if nil == str then
        return {}
    end

    local C_SPLIT_SYMBOL = "|"
    local ret = {}
    local strArray = string.ro_split(str, C_SPLIT_SYMBOL)
    for i = 1, #strArray do
        local num = tonumber(strArray[i])
        table.insert(ret, num)
    end

    return ret
end

---@param lv number
---@param styleID number
---@return string
function _genPlayerStyleAttrKey(lv, styleID)
    local C_KEY_FORMAT = "{0}|{1}"
    local ret = StringEx.Format(C_KEY_FORMAT, lv, styleID)
    return ret
end

return ModuleMgr.ForgeSchoolRecommendMgr