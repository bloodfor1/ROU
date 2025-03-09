require "TableEx/MonsterBookOffLine"

---@module ModuleData.IllustrationMonsterData
module("ModuleData.IllustrationMonsterData", package.seeall)

--- 2020.6.1从IllustrationMgr挪出代码，若有问题无法在本脚本当前代码中获得答案请Blame原写法

ILLUSTRATION_MONSTER_KILL = "ILLUSTRATION_MONSTER_KILL"
ILLUSTRATION_MONSTER_REWARD = "ILLUSTRATION_MONSTER_REWARD"
ILLUSTRATION_SELECT_MONSTER = "ILLUSTRATION_SELECT_MONSTER"
ILLUSTRATION_UNLOCK_MONSTER = "ILLUSTRATION_UNLOCK_MONSTER"
REWARD_BOOK_PAGE_REFRESH = "REWARD_BOOK_PAGE_REFRESH"

--显示魔物表
local allShowMonster
--魔物等级奖励表
---@type table<number, table<number, SingleMonsterFullData[]>>
local allRewardMonster
--魔物解锁状态表
local monsterStateTable = {}
--魔物等级数据
local monsterLevelLimit = MGlobalConfig:GetInt("MonsterListLevelSection")
--魔物击杀数量
local monsterKillNum = {}
--魔物研究进度奖励
local monsterReward = {}
--分组领取进度
local rewardGroupInfo = {}
--总领取进度
local rewardMainInfo = ""
local storageCabineDollInfo
local storageCabineElementInfo
--奖励界面选择类型
local rewardBookSelectType = 0

--魔物模型缩放数据
local monsterModelScale = TableUtil.GetGlobalTable().GetRowByName("MonsterModelScale").Value

local entityHandBookTable = TableUtil.GetEntityHandBookTable()
--图鉴状态
ILLUSTRATION_STATE = {
    None = 0, --未解锁
    First = 1, --待解锁
    Already = 2, --已解锁
}

ECarryShopTypes = {
    None = 0,
    LeftTime = 1,
    NoMoney = 2
}

--魔物二级菜单数据
local dropdownMonsterList
--魔物MVP表
---@type MvpTable[]
local monsterMvpTable
--特殊魔物模型缩放表
local monsterModelScaleTable
--记录选中魔物的里层位置
local monsterCellTemplateIndex = 1
--记录选中魔物的外层位置
local monsterListTemplateIndex = 2
--魔物等级框图片名
local monsterLvlHeadSpriteNames = {}

MonsterOpenType = {
    ShowMvp = 1,
    ShowMini = 2,
    SearchMonster = 3,
}

--魔物属性
YUANSU_STR = {
    [1] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_WU"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_FENG"),
    [3] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DI"),
    [4] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_HUO"),
    [5] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHUI"),
    [6] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DU"),
    [7] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHENG"),
    [8] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_AN"),
    [9] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_NIAN"),
    [10] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_BUSI"),
}

--魔物二级菜单文字数据
DROPDOWN_MONSTER_STR = {
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MAIN"),
    {
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_WU"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_FENG"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DI"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_HUO"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHUI"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DU"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHENG"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_AN"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_NIAN"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_BUSI"),
    },
    {
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_DONGWU"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_RENXING"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_EMO"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_BUSI"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_ZHIWU"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_KUNCHONG"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_YUBEI"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_WUXING"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_TIANSHI"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_ZHONGZU_LONGZU"),
    },
    {
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_TIXING"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_TIXING_XIAOXING"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_TIXING_ZHONGXING"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_TIXING_DAXING"),
    },
    {
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_LEIXING"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_LEIXING_NORMAL"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_LEIXING_MVP"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_LEIXING_MINI"),
    },
}

--魔物二级菜单枚举数据
DROPDOWN_MONSTER_TYPE = {
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
    { 0, 1, 2, 4, 3, 8, 6, 5, 7, 9 },
    { 2, 0, 1 },
    { 0, 5, 4 },
}

function Logout()

    ResetAll()
end

function ResetAll()
    rewardMainInfo = ""
    storageCabineDollInfo = nil
    storageCabineElementInfo = nil
    monsterStateTable = {}
    monsterKillNum = {}
    monsterReward = {}
    rewardGroupInfo = {}
    ResetMonsterValues()
end

function ResetMonsterValues()
    monsterListTemplateIndex = 2
    monsterCellTemplateIndex = 1
end

function InitMonsterHandBook()
    --查图鉴魔物
    if not allShowMonster then
        allShowMonster = {}
        local entityHandbookTable = TableUtil.GetEntityHandBookTable().GetTable()
        local entityTable = TableUtil.GetEntityTable()
        for k, v in pairs(entityHandbookTable) do
            local single = entityTable.GetRowById(v.ID)
            single.needNil = false
            single.isRewardPanel = false
            table.insert(allShowMonster, single)
        end

        --魔物排序
        table.sort(allShowMonster, function(a, b)
            --等级排序
            if a.UnitLevel ~= b.UnitLevel then
                return a.UnitLevel < b.UnitLevel
            end

            --魔物类别排序
            if a.UnitTypeLevel ~= b.UnitTypeLevel then
                return a.UnitTypeLevel < b.UnitTypeLevel
            end

            --ID排序
            return a.Id < b.Id
        end)
    end

    --生成特殊魔物模型缩放表
    if not monsterModelScaleTable then
        monsterModelScaleTable = {}
        for k, v in ipairs(string.ro_split(monsterModelScale, "|")) do
            local modelScale = string.ro_split(v, "=")
            monsterModelScaleTable[tonumber(modelScale[1])] = tonumber(modelScale[2])
        end
    end

    --生成魔物二级菜单数据
    if not dropdownMonsterList then
        dropdownMonsterList = MgrMgr:GetMgr("IllustrationMgr").CreateDropdownStrTable(DROPDOWN_MONSTER_STR)
    end
end

function InitSpriteNames()
    local sprites = MGlobalConfig:GetVectorSequence("HandBookMonsterFrame")
    monsterLvlHeadSpriteNames = {}
    for i = 0, sprites.Length - 1 do
        monsterLvlHeadSpriteNames[tonumber(sprites[i][0])] = sprites[i][1]
    end
end

function InitMonsterRewardBook()
    if not allRewardMonster then
        allRewardMonster = table.ro_deepCopy(MonsterBookFullData)
        for k, v in pairs(allRewardMonster) do
            for innerKey, innerValue in pairs(v) do
                for i = 1, #innerValue do
                    local singleData = innerValue[i]
                    innerValue[i].lvl = GetMonsterRewardLevelById(singleData.Id)
                end
            end
        end
    end
end

--根据属性获取魔物研究数据
function GetMonsterRewardBookDataByType(type)
    if not allRewardMonster then
        InitMonsterRewardBook()
    end
    return allRewardMonster[type - 1]
end
--根据ID获取魔物研究数据
function GetMonsterRewardBookDataByID(id)
    local entityHandbookinfo = TableUtil.GetEntityHandBookTable().GetRowByID(id)
    local entityInfo = TableUtil.GetEntityTable().GetRowById(id)
    local l_infoGroup = GetMonsterRewardBookDataByType(entityInfo.UnitAttrType + 1)
    if l_infoGroup[entityHandbookinfo.Group] then
        for _, v in ipairs(l_infoGroup[entityHandbookinfo.Group]) do
            if v.Id == id then
                return v
            end
        end
    end
    return nil
end

function GetTypeShowMonster(type, arg)
    --type 0不分类 1搜索 2类型
    --分组
    local monsterTable = {}
    local currentStartLevel = 0
    local currentEndLevel = 0
    for k, v in ipairs(allShowMonster) do
        local isInto = true
        if type == 0 then
            --不处理
        elseif type == 1 then
            if string.find(v.Name, arg) == nil then
                isInto = false
            end
        elseif type == 2 then
            local orderTable = string.ro_split(arg, "|")
            local typeId = tonumber(orderTable[1])
            if typeId == 2 then
                --元素
                if v.UnitAttrType % 10 ~= DROPDOWN_MONSTER_TYPE[1][tonumber(orderTable[2])] then
                    isInto = false
                end
            elseif typeId == 3 then
                --种族
                if v.UnitRace ~= DROPDOWN_MONSTER_TYPE[2][tonumber(orderTable[2])] then
                    isInto = false
                end
            elseif typeId == 4 then
                --体型
                if v.UnitSize ~= DROPDOWN_MONSTER_TYPE[3][tonumber(orderTable[2])] then
                    isInto = false
                end
            elseif typeId == 5 then
                --类型
                if v.UnitTypeLevel ~= DROPDOWN_MONSTER_TYPE[4][tonumber(orderTable[2])] then
                    isInto = false
                end
            end
        end

        --生成等级表
        if isInto then
            local itemStartLevel = math.floor((v.UnitLevel - 1) / monsterLevelLimit) * monsterLevelLimit + 1
            local itemEndLevel = itemStartLevel + monsterLevelLimit - 1

            if v.UnitLevel > currentEndLevel then
                monsterTable[#monsterTable + 1] = {
                    isLevelLimitTitle = true,
                    startLevel = itemStartLevel,
                    endLevel = itemEndLevel,
                }
                currentStartLevel = itemStartLevel
                currentEndLevel = itemEndLevel
                monsterTable[#monsterTable + 1] = {}
            end
            if #monsterTable[#monsterTable] == 6 then
                monsterTable[#monsterTable + 1] = {}
            end
            v.tableIndex = #monsterTable
            table.insert(monsterTable[#monsterTable], v)
        end
    end

    return monsterTable
end

--魔物奖励等级
function GetMonsterRewardLevelById(id)
    local config = entityHandBookTable.GetRowByID(id, true)
    if nil == config then
        return 0
    end

    if not monsterKillNum[id] then
        return 0
    end

    for i = 1, config.PointAward.Length do
        if monsterKillNum[id] < config.PointAward[i - 1][1] then
            return i - 1
        end
    end

    return config.PointAward.Length
end

--魔物奖励是否已领取
function CheckMonsterRewardCanPick(id, lv)
    local num2 = tonumber(monsterReward[id]) or 0
    local x
    for i = 1, lv do
        num2 = math.modf(num2 / 2)
    end
    return num2 % 2 == 1
end

--魔物奖励领取至何等级
function GetMonsterRewardNowPickLvl(id)
    local num2 = tonumber(monsterReward[id]) or 0
    for i = 1, 64 do
        if num2 == 0 or num2 == 1 then
            return i
        end
        num2 = math.modf(num2 / 2)
    end
    return 0
end

--魔物组奖励是否已领取
function CheckMonsterGroupRewardCanPick(element, group, lv)
    local num2 = 0
    if rewardGroupInfo[element] and rewardGroupInfo[element][group] then
        num2 = tonumber(rewardGroupInfo[element][group]) or 0
    end
    local x
    for i = 1, lv do
        num2 = math.modf(num2 / 2)
    end
    return num2 % 2 == 1
end

--魔物总奖励是否已领取
function CheckMonsterMainRewardCanPick(lv)
    if lv > #rewardMainInfo then
        return false
    end
    return string.sub(rewardMainInfo, #rewardMainInfo - lv, #rewardMainInfo - lv) == "1"
end

--获取魔物解锁状态
function GetMonsterStateById(id)
    return monsterStateTable[id]
end
--设置解锁魔物解状态
function SetMonsterStateTable(id, value)
    monsterStateTable[id] = value
end

--魔物二级菜单数据
function GetDropdownMonsterStrList()
    return dropdownMonsterList
end

--记录选中魔物的外层位置
function SetMonsterListTemplateIndex(index)
    monsterListTemplateIndex = index
end

--获取选中魔物的外层位置
function GetMonsterListTemplateIndex()
    return monsterListTemplateIndex
end

--记录选中魔物的内层位置
function SetMonsterCellTemplateIndex(index)
    monsterCellTemplateIndex = index
end

--获取选中魔物的内层位置
function GetMonsterCellTemplateIndex()
    return monsterCellTemplateIndex
end

--特殊魔物缩放表
function GetMonsterModelScaleTableById(monsterId)
    return monsterModelScaleTable[monsterId]
end

--MVP魔物数据
function GetMonsterMvpTableById(monsterId)
    if not monsterMvpTable then
        monsterMvpTable = {}
    end
    if not monsterMvpTable[monsterId] then
        local sdata = TableUtil.GetMvpTable().GetRowByEntityID(monsterId)
        monsterMvpTable[monsterId] = sdata
    end
    return monsterMvpTable[monsterId]
end

--魔物属性数据
function GetMonsterAttrData(data)
    local attrData = {}
    --六维
    local polygonData = {}
    --力量
    table.insert(polygonData, data.STR)
    --敏捷
    table.insert(polygonData, data.AGI)
    --灵巧
    table.insert(polygonData, data.DEX)
    --智力
    table.insert(polygonData, data.INT)
    --幸运
    table.insert(polygonData, data.LUK)
    --体质
    table.insert(polygonData, data.VIT)
    --最大值
    local maxValue = 0
    for k, v in ipairs(polygonData) do
        if maxValue < v then
            maxValue = v
        end
    end
    --处理全为0的情况
    if maxValue == 0 then
        maxValue = 1
    end
    polygonData.maxValue = maxValue
    attrData.polygonData = polygonData
    --生命上限
    attrData.hp = data.BaseHP
    if attrData.hp < 0 then
        attrData.hp = 0
    end
    --物理攻击
    attrData.atk = math.floor(data.WEAPON_ATK + 2 * (data.STR + data.DEX / 5 + data.LUK / 5 + data.UnitLevel / 4))
    if attrData.atk < 0 then
        attrData.atk = 0
    end
    --物理防御
    attrData.def = data.DEF
    if attrData.def < 0 then
        attrData.def = 0
    end
    --命中
    attrData.hit = data.HIT + data.DEX + 80
    if attrData.hit < 0 then
        attrData.hit = 0
    end
    --魔法攻击
    attrData.matk = math.floor(data.WEAPON_MATK + data.INT * 1.5 + data.DEX / 5 + data.LUK / 3 + data.UnitLevel / 4)
    if attrData.matk < 0 then
        attrData.matk = 0
    end
    --魔法防御
    attrData.mdef = data.MDEF
    if attrData.mdef < 0 then
        attrData.mdef = 0
    end
    --闪避
    attrData.flee = data.FLEE + data.AGI
    if attrData.flee < 0 then
        attrData.flee = 0
    end

    return attrData
end

--根据类型获取收藏柜物品列表
function GetStorageCabineDataByType(type)
    if storageCabineDollInfo == nil then
        storageCabineDollInfo = {}
        storageCabineElementInfo = {}
        local itemTable = TableUtil.GetItemTable().GetTable()
        for k, v in ipairs(itemTable) do
            if v.Subclass == 1901 then
                table.insert(storageCabineDollInfo, v)
            elseif v.Subclass == 1902 then
                table.insert(storageCabineElementInfo, v)
            end
        end
    end
    if type == 1 then
        return storageCabineDollInfo
    else
        return storageCabineElementInfo
    end
end

--生成魔物二级菜单显示拼接文字
function CreateDropdownShowStr(strOrder)
    local strSplit = string.ro_split(strOrder, "|")
    if #strSplit == 1 then
        return DROPDOWN_MONSTER_STR[1]
    elseif #strSplit == 2 then
        return DROPDOWN_MONSTER_STR[tonumber(strSplit[1])][1] .. "-" .. DROPDOWN_MONSTER_STR[tonumber(strSplit[1])][tonumber(strSplit[2]) + 1]
    end
end
-- 获取杀怪数
function GetMonsterKillNum(id)
    return monsterKillNum[id] or 0
end
-- 设置杀怪数
function SetMonsterKillNum(id, num)
    monsterKillNum[id] = num
end
-- 设置单只怪物奖励领取状态
function SetMonsterReward(id, value)
    monsterReward[id] = value
end

--- 设置组奖励
---@param info MonsterGroupInfo
function UpdateGroupRewardInfo(elementId, groupId, researchSign)
    if not rewardGroupInfo[elementId] then
        rewardGroupInfo[elementId] = {}
    end
    rewardGroupInfo[elementId][groupId] = researchSign
end

---设置总奖励
function SetRewardMainInfo(str)
    rewardMainInfo = str
end
---获取魔物的等级奖励拘束
function GetLvRateByEntityID(entityID)
    local l_tmp = MGlobalConfig:GetVectorSequence("ExpItemAdditionConfig")
    local l_v = tonumber(MPlayerInfo.Lv)
    local l_entityData = TableUtil.GetEntityTable().GetRowById(entityID)
    if l_entityData then
        l_v = tonumber(l_entityData.UnitLevel) - l_v
        for i = 0, l_tmp.Length - 1 do
            local l_vMin = tonumber(l_tmp[i][0])
            local l_vMax = tonumber(l_tmp[i][1])
            local l_vStr = tostring(l_tmp[i][2]) .. "%"
            local l_dropStr = tostring(l_tmp[i][3]) .. "%"
            if (l_v >= l_vMin and l_v <= l_vMax) or (l_v <= l_vMin and l_v >= l_vMax) then
                return l_v > 0, l_vStr, l_dropStr
            end
        end
    else
        l_v = 0
    end
    return l_v > 0, " ", " "
end

function GetLvRateTable()
    local l_tmp = MGlobalConfig:GetVectorSequence("ExpItemAdditionConfig")
    local l_upTable = {}
    local l_downTable = {}
    for i = 0, l_tmp.Length - 1 do
        local l_target = {}
        l_target.vMin = tonumber(l_tmp[i][0])
        l_target.vMax = math.abs(tonumber(l_tmp[i][1]))
        l_target.vStr = tostring(l_tmp[i][2]) .. "%"
        l_target.dropStr = tostring(l_tmp[i][3]) .. "%"
        if l_target.vMin > 0 then
            l_upTable[#l_upTable + 1] = l_target
        else
            l_target.vMin = math.abs(tonumber(l_tmp[i][0]))
            l_downTable[#l_downTable + 1] = l_target
        end
    end
    return l_upTable, l_downTable
end

function SetRewardBookSelectType(type)
    rewardBookSelectType = type
end

function GetRewardBookSelectType()
    return rewardBookSelectType
end

function GetRewardGroupInfo(element, group)
    if rewardGroupInfo[element] and rewardGroupInfo[element][group] then
        return tonumber(rewardGroupInfo[element][group]) or 0
    end
    return 0
end

function GetAllRewardMonster()
    if not allRewardMonster then
        InitMonsterRewardBook()
    end
    return allRewardMonster
end

function GetSpriteName(lv)
    if lv <= 0 then
        return monsterLvlHeadSpriteNames[0]
    end
    if monsterLvlHeadSpriteNames[lv] then
        return monsterLvlHeadSpriteNames[lv]
    end
    return GetSpriteName(lv - 1)
end

return ModuleData.IllustrationMonsterData