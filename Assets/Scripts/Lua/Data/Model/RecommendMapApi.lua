--- 由于流派和道具之间的映射比较繁琐，且会出现二义性
--- 所以这里回构建两个映射表，主要负责索引道具和流派之间的映射关系
--- 一个是保存 显示流派ID 和 真实流派ID 之间的映射关系
--- 一个是保存 真实流派ID 和 道具ID 之间的映射关系

module("Data", package.seeall)
RecommendMapApi = class("RecommendMapApi")

--- 对映射表进行初始化
function RecommendMapApi:Init()
    ---@type table<number, number>
    self._schoolMap = {}
    ---@type table<number, table<number, number>>
    self._schoolItemMap = {}

    self:_initSchoolIDMap()
    self:_initItemIDMap()
end

---@param schoolID number @不管是表流派ID还是真是流派ID都可以传参
---@param itemID number @道具TID
---@return boolean
function RecommendMapApi:ItemMatchesSchool(schoolID, itemID)
    if nil == schoolID or nil == itemID then
        logError("[RecommendMapApi] invalid param")
        return false
    end

    local realSchoolID = self._schoolMap[schoolID]
    if nil ~= realSchoolID then
        return self:_itemMatchRealSchoolID(realSchoolID, itemID)
    end

    return self:_itemMatchRealSchoolID(schoolID, itemID)
end

--- 这个方法返回的是匹配到的属性ID，这个方法会先对第一个参数进行遍历，用第一个参数返回的结果来匹配第二个参数
--- 传参的时候尽量将流派较少的参数放在第一个
---@return number[] @返回值是匹配到的流派真实ID列表
function RecommendMapApi:ItemsSameSchool(itemIDLeft, itemIDRight)
    if nil == itemIDLeft or nil == itemIDRight then
        logError("[RecommendMap] invalid param")
        return {}
    end

    local cacheIDs = {}
    for schoolID, map in pairs(self._schoolItemMap) do
        if nil ~= map[itemIDLeft] then
            table.insert(cacheIDs, schoolID)
        end
    end

    local ret = {}
    for i = 1, #cacheIDs do
        local singleCacheID = cacheIDs[i]
        local singleMap = self._schoolItemMap[singleCacheID]
        if nil ~= singleMap[itemIDRight] then
            table.insert(ret, singleCacheID)
        end
    end

    return ret
end

--- 根据真实ID获取映射数据
---@return boolean
function RecommendMapApi:_itemMatchRealSchoolID(realSchoolID, itemID)
    local targetItemMap = self._schoolItemMap[realSchoolID]
    if nil == targetItemMap then
        return false
    end

    local ret = nil ~= targetItemMap[itemID]
    return ret
end

--- 初始化流派映射表
function RecommendMapApi:_initSchoolIDMap()
    local proTxtTable = TableUtil.GetProfessionTextTable().GetTable()
    if nil == proTxtTable then
        logError("[RecommendMap] professionTextTable got nil")
        return
    end

    for i = 1, #proTxtTable do
        local singleConfig = proTxtTable[i]
        self._schoolMap[singleConfig.NAME] = singleConfig.RecommendClass
    end
end

--- 初始化道具ID映射表
function RecommendMapApi:_initItemIDMap()
    local recommendTable = TableUtil.GetSkillClassRecommandTable().GetTable()
    if nil == recommendTable then
        logError("[RecommendMap] SkillClassRecommendTable got nil")
        return
    end

    for i = 1, #recommendTable do
        local singleConfig = recommendTable[i]
        self._schoolItemMap[singleConfig.Id] = {}
        self._addCsListToHashMap(self._schoolItemMap[singleConfig.Id], singleConfig.EquipIds)
        self._addCsListToHashMap(self._schoolItemMap[singleConfig.Id], singleConfig.CardIds)
        self._addCsListToHashMap(self._schoolItemMap[singleConfig.Id], singleConfig.HeadWearIds)
    end

    self:_initEquipMap()
end

--- 初始化装备推荐的数据
function RecommendMapApi:_initEquipMap()
    local equipConfigList = TableUtil.GetEquipTable().GetTable()
    for i = 1, #equipConfigList do
        local singleConfig = equipConfigList[i]
        for j = 0, singleConfig.RecommendSchool.Length - 1 do
            local recommendSchoolID = singleConfig.RecommendSchool[j]
            local realSchoolID = self._schoolMap[recommendSchoolID]
            local equipID = singleConfig.Id
            self._schoolItemMap[realSchoolID][equipID] = 1
        end
    end
end

--- 讲Cs中的数组填到哈希表当中
function RecommendMapApi._addCsListToHashMap(hashMap, csList)
    if nil == hashMap or nil == csList then
        logError("[RecommendMap] invalid param")
        return
    end

    for i = 0, csList.Length - 1 do
        local singleCsValue = csList[i]
        hashMap[singleCsValue] = 1
    end
end