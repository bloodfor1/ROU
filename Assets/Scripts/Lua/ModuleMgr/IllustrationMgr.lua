require "TableEx/ProOfflineMap"

---@module ModuleMgr.IllustrationMgr
module("ModuleMgr.IllustrationMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

ILLUSTRATION_SELECT_CARD = "ILLUSTRATION_SELECT_CARD"
ILLUSTRATION_SELECT_EQUIP = "ILLUSTRATION_SELECT_EQUIP"

--可用职业表
local professionNormalTable
--图鉴生成打开状态
local illustrationCreated = {}
--图鉴类型枚举
ILLUSTRATION_TYPE = {
    Monster = 1, --魔物
    Card = 2, --卡片
    Equipment = 3, --装备
}
OpenType = {
    SearchCard = 1,
    SelectCard = 2,
    SelectEquipPart = 3
}

SelectEquipId = nil
SelectTableData = nil

---@param info RoleAllInfo
function OnSelectRoleNtf(info)
    --筛选可用职业表
    if not professionNormalTable then
        professionNormalTable = {}
        local professionTable = TableUtil.GetProfessionTable().GetTable()
        for k, v in pairs(professionTable) do
            if v.ParentProfession ~= -1 then
                table.insert(professionNormalTable, v)
            end
        end
    end
    InitCardHandBook()
    InitEquipHandBook()
end

--恢复值
function ResetValues()
    illustrationCreated = {}
    --card
    ResetCardValues()
    --equip
    ResetEquipValues()
end

--查看是否已经创建过该图鉴
function IsCreateIllustration(type)
    local isCreate = illustrationCreated[type]
    return isCreate
end

function SetIllustrateType(type)
    illustrationCreated[type] = true
end

--生成二级菜单数据
function CreateDropdownStrTable(data)
    local itemList = MoreDropdownItem.CreateList()
    for i, v in ipairs(data) do
        if type(v) == "table" then
            local list = CreateDropdownStrTable(v)
            itemList = MoreDropdownItem.AddInfo(itemList, list)
        elseif type(v) == "string" then
            local info = MoreDropdownItem.CreateInfo(v)
            itemList = MoreDropdownItem.AddInfo(itemList, info)
        end
    end

    return itemList
end

--登出时清空数据
function OnLogout()
    ResetValues()
end

--断线重连
function OnReconnected(reconnectData)
end

--region ----------------------------------卡片----------------------------------
--所有卡片表
local allShowCard = {}
--展示卡片表
local showCardTable
--选中的卡片Id
local selectCardIndex = 1
--卡片菜单数据
local dropdownCardList
--查看魔物卡片ID
local checkMonsterCardId
--卡片属性归类表
local cardAttrListTable = {}
--已选择卡片属性
local cardAttrSelect = {}
--卡片类型选择
local cardTypeSelect = 1
--卡片选中属性数量
local selectAttrNum = 0
--卡片推荐流派表
local cardSchoolTable = {}
--卡片流派选择数量
local cardSelectSchoolNum = 0
--已选择卡片流派
local cardSchoolSelect = {}
--已选择流派对应的卡片
local cardSchoolCardId = {}

--卡片菜单
DROPDOWN_CARD_STR = {
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MAIN"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_ZHUWUQI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_FUSHOU"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_KUIJIA"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_PIFENG"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_XIEZI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_SHIPIN"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_TOUSHI"),
}
--卡片菜单枚举数据
DROPDOWN_CARD_TYPE = { 1, 2, 3, 4, 5, 6, 7, 8 }

function InitCardHandBook()

    if #allShowCard == 0 then
        --获取
        local equipCardTable = TableUtil.GetEquipCardTable().GetTable()
        for k, v in pairs(equipCardTable) do
            if v.IsShowInHandBook == 1 then
                v.attrFitNum = 0
                local professionText = {}
                local recommendSchool = v.RecommendSchool
                if recommendSchool.Length > 0 then
                    for k = 0, recommendSchool.Length - 1 do
                        if recommendSchool[k][0] == 0 then
                            local professionName = TableUtil.GetProfessionTable().GetRowById(recommendSchool[k][1]).Name
                            local info = { type = 0, str = StringEx.Format(Common.Utils.Lang("ILLUSTRATION_CARD_PROFESSION"), professionName) }
                            table.insert(professionText, info)
                        elseif recommendSchool[k][0] == 1 then
                            local schoolName = TableUtil.GetProfessionTextTable().GetRowByNAME(recommendSchool[k][1]).SchoolName
                            local info = { type = 1, str = StringEx.Format(Common.Utils.Lang("ILLUSTRATION_CARD_SCHOOL"), schoolName) }
                            table.insert(professionText, info)
                        end
                    end
                end
                v.professionText = professionText
                local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(v.ID)
                if l_itemTableInfo then
                    v.ItemQuality = l_itemTableInfo.ItemQuality
                    v.ItemName = l_itemTableInfo.ItemName
                    table.insert(allShowCard, v)
                end
            end
        end

        --排序
        table.sort(allShowCard, function(a, b)
            if a.ItemQuality < b.ItemQuality then
                return true
            elseif a.ItemQuality > b.ItemQuality then
                return false
            else
                if a.ID < b.ID then
                    return true
                elseif a.ID >= b.ID then
                    return false
                end
            end
        end)
    end

    local skillMgr = DataMgr:GetData("SkillData")
    skillMgr.UnionClear()

    for k1, v1 in ipairs(professionNormalTable) do
        if v1.ParentProfession ~= 1000 and v1.ParentProfession ~= 0 then
            skillMgr.UnionConnect(v1.Id, v1.ParentProfession)
        end
    end

    if #cardSchoolTable == 0 then
        cardSchoolTable[1000] = {}
        local professionSingleTree = {}
        for j, v in ipairs(DROPDOWN_EQUIP_PROFESSION_TYPE) do
            for k1, v1 in ipairs(professionNormalTable) do
                if skillMgr.UnionFind(v1.Id) == skillMgr.UnionFind(v) then
                    table.insert(professionSingleTree, v1.Id)
                end
            end
            cardSchoolTable[professionSingleTree[1]] = {}
            for i = 2, #professionSingleTree do
                local proDetailTable = TableUtil.GetAutoAddSkillPointTable().GetRowByProfessionId(professionSingleTree[i])
                if proDetailTable then
                    local proDetailId = proDetailTable.ProDetailId
                    cardSchoolTable[professionSingleTree[i]] = {}
                    for k = 0, proDetailId.Length - 1 do
                        if i == 2 then
                            table.insert(cardSchoolTable[1000], proDetailId[k])
                        end
                        table.insert(cardSchoolTable[professionSingleTree[i]], proDetailId[k])
                        table.insert(cardSchoolTable[professionSingleTree[1]], proDetailId[k])
                    end
                else
                    logError("没有配置流派 professionId => " .. professionSingleTree[i])
                end
            end
            cardSchoolTable[professionSingleTree[1]] = table.ro_unique(cardSchoolTable[professionSingleTree[1]])
            professionSingleTree = {}
        end
    end

    if #cardAttrListTable == 0 then
        InitCardAttrList()
    end

    --生成卡片菜单数据
    if not dropdownCardList then
        dropdownCardList = CreateDropdownStrTable(DROPDOWN_CARD_STR)
    end

end

function GetTypeShowCard(type, arg)
    --type 0全部 1搜索 2装备部位类型 3属性筛选 4流派
    showCardTable = {}
    for k, v in ipairs(allShowCard) do
        local isInto = true
        if type == 0 then
            --不处理
        elseif type == 1 then
            cardTypeSelect = 1
            if string.find(v.ItemName, arg) == nil then
                isInto = false
            end
        elseif type == 2 then
            cardTypeSelect = DROPDOWN_CARD_TYPE[tonumber(arg)]
            isInto = IsCardTypeAndAttrSearch(v)
        elseif type == 3 then
            isInto = IsCardTypeAndAttrSearch(v)
        elseif type == 4 then
            if cardSelectSchoolNum ~= 0 then
                if (cardSchoolCardId[v.ID] == nil) or (cardSchoolCardId[v.ID] == 0) then
                    isInto = false
                end
            end
        end
        if checkMonsterCardId and (v.ID == checkMonsterCardId) then
            selectCardIndex = #showCardTable + 1
        end

        if selectAttrNum == 0 then
            v.attrFitNum = 0
        end

        --生成显示表
        if isInto then
            table.insert(showCardTable, v)
        end
    end

    --排序
    if selectAttrNum ~= 0 then
        if (type == 2 or type == 3) then
            table.sort(showCardTable, function(a, b)
                if a.attrFitNum > b.attrFitNum then
                    return true
                elseif a.attrFitNum <= b.attrFitNum then
                    return false
                end
            end)
        end
    else
        table.sort(showCardTable, function(a, b)
            if a.ItemQuality < b.ItemQuality then
                return true
            elseif a.ItemQuality > b.ItemQuality then
                return false
            else
                if a.ID < b.ID then
                    return true
                elseif a.ID >= b.ID then
                    return false
                end
            end
        end)
    end

    return showCardTable
end

--判断装备类型和属性是否都正确
function IsCardTypeAndAttrSearch(data)
    --装备判断
    local isEquipTypeFit = true
    if (data.CanUsePosition[0] ~= tonumber(cardTypeSelect) - 1) and (tonumber(cardTypeSelect) - 1 > 0) then
        isEquipTypeFit = false
    end
    --属性判断
    local isAttrFit = false
    if selectAttrNum > 0 then
        for k1 = 0, data.CardAttributes.Length - 1 do
            for k2, v2 in pairs(cardAttrSelect) do
                for k3, v3 in pairs(v2) do
                    if v3 then
                        for k4, v4 in pairs(cardAttrListTable[k2][k3].cardAttrId) do
                            if data.CardAttributes[k1][1] == v4 then
                                isAttrFit = true
                                data.attrFitNum = data.attrFitNum + 1
                            end
                        end
                    end
                end
            end
        end
    end

    if selectAttrNum == 0 then
        return isEquipTypeFit
    else
        return isEquipTypeFit and isAttrFit
    end
end

--选中的卡片Id
function SetSelectCardIndex(index)
    selectCardIndex = index
end

--选中的卡片Id
function GetSelectCardIndex()
    return selectCardIndex
end

--查看魔物卡片ID
function SetCheckMonsterCardId(id)
    checkMonsterCardId = id
end

--查看魔物卡片ID
function GetCheckMonsterCardId()
    return checkMonsterCardId
end

--卡片类型选择
function SetCardTypeSelect(type)
    cardTypeSelect = type
end

--流派反向表
function GetCardSchoolTableByProId(proId)
    return cardSchoolTable[proId]
end

--卡片菜单数据
function GetDropdownCardStrList()
    return dropdownCardList
end

--预处理卡片属性归类表
function InitCardAttrList()
    local equipCardAttrListTable = TableUtil.GetCardAttrListTable().GetTable()
    local equipCardAttrTable = TableUtil.GetCardAttrTable().GetTable()
    local cardAttrIds = {}
    for i, v in ipairs(equipCardAttrTable) do
        for j = 0, v.TypeID.Length - 1 do
            local curTypeID = v.TypeID[j]
            if not cardAttrIds[curTypeID] then
                cardAttrIds[curTypeID] = {}
            end
            table.insert(cardAttrIds[curTypeID], v.ID)
        end
    end
    for k, v in pairs(equipCardAttrListTable) do
        local curCategoryTab = v.CategoryTab
        if not cardAttrListTable[curCategoryTab] then
            cardAttrListTable[curCategoryTab] = {}
        end
        v.cardAttrId = cardAttrIds[v.TypeID] or {}
        table.insert(cardAttrListTable[curCategoryTab], v)
    end
end

--获取卡片属性归类
function GetCardAttrListTable()
    return cardAttrListTable
end

--已选择卡片属性
function SetCardAttrSelect(type, index, isSelect)
    if not cardAttrSelect[type] then
        cardAttrSelect[type] = {}
    end
    cardAttrSelect[type][index] = isSelect

    if isSelect then
        selectAttrNum = selectAttrNum + 1
    else
        selectAttrNum = selectAttrNum - 1
    end
end

--已选择卡片属性数
function GetCardSelectAttrNum()
    return selectAttrNum
end

--已选择卡片属性
function GetCardAttrSelect()
    return cardAttrSelect
end

--清空已选择卡片属性
function ClearCardAttrSelect()
    selectAttrNum = 0
    cardAttrSelect = {}
end

--已选择卡片流派
function SetCardSchoolSelect(schoolId, isSelect)
    cardSchoolSelect[schoolId] = isSelect
    --存储要显示的流派
    local cardIds = TableUtil.GetSkillClassRecommandTable().GetRowById(schoolId).CardIds
    for k = 0, cardIds.Length - 1 do
        if cardSchoolCardId[cardIds[k]] == nil then
            cardSchoolCardId[cardIds[k]] = 0
        end
        if isSelect then
            cardSchoolCardId[cardIds[k]] = cardSchoolCardId[cardIds[k]] + 1
        else
            cardSchoolCardId[cardIds[k]] = cardSchoolCardId[cardIds[k]] - 1
        end
    end

    if isSelect then
        cardSelectSchoolNum = cardSelectSchoolNum + 1
    else
        cardSelectSchoolNum = cardSelectSchoolNum - 1
    end
end

--已选择卡片流派
function GetCardSchoolSelectBySchoolId(schoolId)
    return cardSchoolSelect[schoolId]
end

--卡片流派选择数量
function GetCardSelectSchoolNum()
    return cardSelectSchoolNum
end

--清空已选择卡片流派
function ClearCardSchoolSelect()
    cardSelectSchoolNum = 0
    cardSchoolSelect = {}
    cardSchoolCardId = {}
end

function ResetCardValues()
    selectCardIndex = 1
    cardAttrSelect = {}
    cardTypeSelect = 1
    selectAttrNum = 0
    cardSelectSchoolNum = 0
    cardSchoolSelect = {}
    cardSchoolCardId = {}
    checkMonsterCardId = nil
end
--endregion ----------------------------------卡片END----------------------------------

--region ----------------------------------装备----------------------------------
--显示装备表
local allShowEquip
--显示装备等级段表
local equipTable = {}
--装备等级段数据
local equipLimitLevel
--装备点击外层Index
local equipListTemplateIndex = 2
--装备点击内层Index
local equipCellTemplateIndex = 1
--装备部位菜单数据
local dropdownEquipTypeList
--装备职业菜单数据
local dropdownEquipProfessionList
--记录部位菜单ID
local equipSearchTypeID
--记录职业菜单ID
local equipSearchProfessionID
--装备职业表
local equipProfessionTable
--装备职业反向查询表
local equipAllProfessionTable = {}
--装备菜单枚举数据反向表
local equipDropdownProfessionTable = {}
--人物等级对应的装备等级段
local equipShowLevelLimit
--筛选装备条件记录表
---@type checkIsProfessionEquipByIDInfo[]
local checkIsProfessionEquipByID = {}
--装备部位菜单
DROPDOWN_EQUIP_TYPE_STR = {
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_ALL"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_WUQI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_FUSHOU"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_KUIJIA"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_PIFENG"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_XIEZI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_SHIPIN"),
    -- Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_TOUBU"),
}
--装备菜单枚举数据
DROPDOWN_EQUIP_TYPE_TYPE = { 1, 2, 3, 4, 5, 6, 7 }
--装备职业菜单
DROPDOWN_EQUIP_PROFESSION_STR = {
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_ALL"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_JIANSHI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_MOFASHI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_GONGJIANSHOU"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_FUSHI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_DAOZEI"),
    Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_SHANGREN"),
}
--装备菜单枚举数据
-- 1000 初心者
-- 2000 剑士
-- 3000 复试
-- 4000 魔法师
-- 5000 盗贼
-- 6000 商人
-- 7000 弓箭手
DROPDOWN_EQUIP_PROFESSION_TYPE = {
    [0] = 1000,
    [1] = 2000,
    [2] = 4000,
    [3] = 7000,
    [4] = 3000,
    [5] = 5000,
    [6] = 6000 }

--职业id ==> 名称
ProIdToProName = {
    [1000] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_ALL"),
    [2000] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_JIANSHI"),
    [4000] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_MOFASHI"),
    [7000] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_GONGJIANSHOU"),
    [3000] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_FUSHI"),
    [5000] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_DAOZEI"),
    [6000] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_PROFESSION_SHANGREN"),
}
function GetSuitMapTable()
    local l_result = {}
    for _, v in ipairs(TableUtil.GetSuitTable().GetTable()) do
        for componentListIndex = 0, v.ComponentID.Length - 1 do
            local l_componentList = v.ComponentID[componentListIndex]
            if l_componentList.Length >= 2 then
                local l_type = l_componentList[0]
                if l_type == 1 then
                    for componentIndex = 1, l_componentList.Length - 1 do
                        local l_componentId = l_componentList[componentIndex]
                        l_result[l_componentId] = v.SuitId
                    end
                end
            end
        end
    end

    return l_result
end

--显示装备表
function InitEquipHandBook()
    --处理所有要显示的装备
    if not allShowEquip then
        allShowEquip = {}
        local l_suitMapInfo = GetSuitMapTable()
        local allEquipTable = TableUtil.GetEquipTable().GetTable()
        for k, v in ipairs(allEquipTable) do
            if v.IsShowInHandBook == 1 then
                local equipItem = TableUtil.GetItemTable().GetRowByItemID(v.Id)
                if equipItem == nil then
                    logError("ItemTable中找不到 id => " .. v.Id)
                else
                    v.LevelLimit = equipItem.LevelLimit[0]
                    v.ItemAtlas = equipItem.ItemAtlas
                    v.ItemIcon = equipItem.ItemIcon
                    v.SortID = equipItem.SortID
                    if l_suitMapInfo[v.EquipSecondId] then
                        v.SuitID = l_suitMapInfo[v.EquipSecondId]
                    else
                        v.SuitID = 0
                    end
                    table.insert(allShowEquip, v)
                end
            end
        end
        --排序
        table.sort(allShowEquip, function(a, b)
            if a.LevelLimit < b.LevelLimit then
                return true
            elseif a.LevelLimit > b.LevelLimit then
                return false
            elseif a.LevelLimit == b.LevelLimit then
                if a.SortID < b.SortID then
                    return true
                else
                    return false
                end
            end
        end)
    end

    --生成装备职业表
    if not equipProfessionTable then
        equipProfessionTable = {}
        for k, v in ipairs(DROPDOWN_EQUIP_PROFESSION_TYPE) do
            equipProfessionTable[v] = {}
            equipDropdownProfessionTable[v] = k
        end
        for k, v in pairs(professionNormalTable) do
            if v.ParentProfession ~= 0 then
                equipAllProfessionTable[v.Id] = v.ParentProfession
            end
        end
        for k, v in pairs(equipAllProfessionTable) do
            if equipProfessionTable[k] then
                table.insert(equipProfessionTable[k], k)
            end
            if equipProfessionTable[v] then
                table.insert(equipProfessionTable[v], k)
            end
        end
    end

    --生成等级段数据
    if not equipLimitLevel then
        local equipListLevelSection = TableUtil.GetGlobalTable().GetRowByName("EquipListLevelSection").Value
        equipLimitLevel = string.ro_split(equipListLevelSection, "|")
    end

    --生成装备职业菜单数据
    if not dropdownEquipProfessionList then
        dropdownEquipProfessionList = CreateDropdownStrTable(DROPDOWN_EQUIP_PROFESSION_STR)
    end

    --生成装备部位菜单数据
    if not dropdownEquipTypeList then
        dropdownEquipTypeList = CreateDropdownStrTable(DROPDOWN_EQUIP_TYPE_STR)
    end
    checkIsProfessionEquipByID = {}
    for k, v in pairs(allShowEquip) do
        checkIsProfessionEquipByID[v.Id] = {}
        ---@class checkIsProfessionEquipByIDInfo
        ---@field index number
        ---@field isType boolean
        ---@field isProfession boolean
        ---@field professions boolean[]
        local oneLua = {}
        oneLua.index = k
        oneLua.isType = v.EquipId == GameEnum.EEquipSlotType.HeadWear or v.EquipId == GameEnum.EEquipSlotType.FaceGear or v.EquipId == GameEnum.EEquipSlotType.MouthGear
        oneLua.isProfession = false
        oneLua.professions = {}
        local itemData = TableUtil.GetItemTable().GetRowByItemID(v.Id)
        for i = 0, itemData.Profession.Length - 1 do
            if itemData.Profession[i][0] == 0 then
                oneLua.isProfession = true
                break
            end
            oneLua.professions[itemData.Profession[i][0]] = true
        end
        checkIsProfessionEquipByID[v.Id] = oneLua
    end
end

--类型获得显示装备表
function GetTypeShowEquip(type, arg)
    --type 0全部 2部位 3职业index 4职业ID
    equipTable = {}
    --是否继续生成等级表
    local isContinue = true
    --等级段Index
    local limitLevelIndex = 1
    --当前等级段
    local currentStartLevel = -1
    local currentEndLevel = -1
    --最后一个等级段Index
    local lastLevelLimitIndex = 0
    equipShowLevelLimit = nil
    for k, v in ipairs(allShowEquip) do
        local isInto = true
        if type == 0 then
            --菜单选择还原
            equipSearchTypeID = nil
            equipSearchProfessionID = nil
            --不处理
        elseif type == 2 then
            equipSearchTypeID = tonumber(arg) - 1
            isInto = IsEquipTypeAndProfessionSearch(v)
        elseif type == 3 then
            equipSearchProfessionID = tonumber(arg) - 1
            isInto = IsEquipTypeAndProfessionSearch(v)
        elseif type == 4 then
            equipSearchProfessionID = equipDropdownProfessionTable[arg]
            isInto = IsEquipTypeAndProfessionSearch(v)
        end
        --生成等级表
        if isInto then
            local itemStartLevel = tonumber(equipLimitLevel[limitLevelIndex])
            local itemEndLevel = tonumber(equipLimitLevel[limitLevelIndex + 1])
            --判断是否有下一个等级段
            if itemEndLevel == nil then
                isContinue = false
            else
                itemEndLevel = itemEndLevel - 1
            end
            --超过等级的 找到对应的等级段
            while v.LevelLimit > itemEndLevel do
                limitLevelIndex = limitLevelIndex + 1
                itemStartLevel = tonumber(equipLimitLevel[limitLevelIndex])
                itemEndLevel = tonumber(equipLimitLevel[limitLevelIndex + 1])
                if itemEndLevel == nil then
                    isContinue = false
                    break
                else
                    itemEndLevel = itemEndLevel - 1
                end
            end
            --判断已到达最后一组 结束生成
            if not isContinue then
                break
            end

            --填数据
            if v.LevelLimit > currentEndLevel then
                equipTable[#equipTable + 1] = {
                    isLevelLimitTitle = true,
                    startLevel = itemStartLevel,
                    endLevel = itemEndLevel,
                }
                currentStartLevel = itemStartLevel
                currentEndLevel = itemEndLevel
                --当前等级对应的等级段
                lastLevelLimitIndex = #equipTable

                if not SelectEquipId then
                    local l_currentShowLevel = MPlayerInfo.Lv
                    if (l_currentShowLevel < currentEndLevel) and (l_currentShowLevel > currentStartLevel) then
                        equipShowLevelLimit = lastLevelLimitIndex
                    end
                end

                --五个装备组
                equipTable[#equipTable + 1] = {}
            end

            if #equipTable[#equipTable] == 6 then
                equipTable[#equipTable + 1] = {}
            end

            v.tableIndex = #equipTable
            table.insert(equipTable[#equipTable], v)
        end

        if SelectEquipId then
            --logGreen("v.Id:"..tostring(v.Id))
            if v.Id == SelectEquipId then
                SelectTableData = v
                equipShowLevelLimit = #equipTable
                --logGreen("lastLevelLimitIndex:"..tostring(v.Name))
            end
        end
    end

    if equipShowLevelLimit == nil then
        equipShowLevelLimit = lastLevelLimitIndex
    end

    return equipTable
end

--装备筛选处理
function IsEquipTypeAndProfessionSearch(equipData)
    local isType = true
    local id = equipData.Id
    if equipSearchTypeID then
        isType = false
        if equipSearchTypeID == 0 then
            equipSearchTypeID = nil
            isType = true
        elseif DROPDOWN_EQUIP_TYPE_TYPE[equipSearchTypeID] == 7 then
            if checkIsProfessionEquipByID[id].isProfession then
                isType = true
            end
        else
            if equipSearchTypeID == equipData.EquipId then
                isType = true
            end
        end
        if not isType then
            return isType
        end
    end

    local isProfession = true
    if equipSearchProfessionID then
        isProfession = false
        if equipSearchProfessionID == 0 then
            equipSearchProfessionID = nil
            isProfession = true
        else
            local targetProID = DROPDOWN_EQUIP_PROFESSION_TYPE[equipSearchProfessionID]
            local gProMap = ProOfflineMap
            local subProMap = gProMap[targetProID]
            if nil == ItemProOffLineMap[id] then
                isProfession = true
            elseif nil ~= ItemProOffLineMap[id] and nil ~= subProMap then
                for key, value in pairs(subProMap) do
                    if nil ~= ItemProOffLineMap[id][key] then
                        isProfession = true
                        break
                    end
                end
            end
        end
    end

    local l_ret = isType and isProfession

    -- todo 测试代码
    -- logError("type valid: " .. tostring(isType) .. " profession valid: " .. tostring(isProfession))
    return l_ret
end

function FindRootProfessionId(id)
    return DROPDOWN_EQUIP_PROFESSION_TYPE[id]
end

--装备点   击外层Index
function SetEquipListTemplateIndex(index)
    equipListTemplateIndex = index
end

--装备点击外层Index
function GetEquipListTemplateIndex()
    return equipListTemplateIndex
end

--装备点击内层Index
function SetEquipCellTemplateIndex(index)
    equipCellTemplateIndex = index
end

--装备点击内层Index
function GetEquipCellTemplateIndex()
    return equipCellTemplateIndex
end

--装备部位菜单数据
function GetDropdownEquipTypeStrList()
    return dropdownEquipTypeList
end

--装备职业菜单数据
function GetDropdownEquipProfessionStrList()
    return dropdownEquipProfessionList
end

--装备职业反向查询表
function GetEquipProfessionByProId(proId)
    local id = equipAllProfessionTable[proId]
    if equipProfessionTable[id] then
        return id
    else
        return proId
    end
end

--人物等级对应的装备等级段
function GetEquipShowLevelLimit()
    return equipShowLevelLimit
end

function GetEquipSearchValue()
    return equipSearchTypeID, equipSearchProfessionID
end

-- 设置装备查找参数
function SetEquipSearchValue(partId, professionId)
    if not partId or not professionId then
        return
    end

    if not array.contains(DROPDOWN_EQUIP_TYPE_TYPE, partId) then
        logError("invalid equip search partId: ", partId)
        return
    end

    --- 这个地方用的map当中的key是有0的，所以不能直接contain判断
    local containsID = false
    for key, value in pairs(DROPDOWN_EQUIP_PROFESSION_TYPE) do
        if value == professionId then
            containsID = true
            break
        end
    end

    if not containsID then
        logError("invalid equip search profession: ", professionId)
        return
    end

    equipSearchTypeID = partId
    equipSearchProfessionID = professionId
end

function ResetEquipValues()
    equipListTemplateIndex = 2
    equipCellTemplateIndex = 1
    equipSearchTypeID = nil
    equipSearchProfessionID = nil
    SelectEquipId = nil
end

--endregion ----------------------------------装备END----------------------------------

function GetHandBookSortList()
    if not HandBookSortList then
        HandBookSortList = Common.Functions.VectorToTable(MGlobalConfig:GetSequenceOrVectorInt("HandBookListSort"))
    end
    return HandBookSortList
end

--- 判断图鉴中的装备是否满足指定的配置，比如点击装备位，弹出图鉴
function IsIllustrationEquipCanShow(partId, professionId)
    professionId = MgrMgr:GetMgr("ProfessionMgr").GetBaseProfessionIdWithProfessionId(professionId)
    --装备菜单枚举数据
    local DROPDOWN_EQUIP_PROFESSION_TYPE = {
        [1000] = 1,
        [2000] = 1,
        [3000] = 1,
        [4000] = 1,
        [5000] = 1,
        [6000] = 1,
        [7000] = 1,
    }

    --装备菜单枚举数据
    local DROPDOWN_EQUIP_TYPE_TYPE = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
        [5] = 1,
        [6] = 1,
    }

    if nil == DROPDOWN_EQUIP_TYPE_TYPE[partId] then
        return false
    end

    if nil == DROPDOWN_EQUIP_PROFESSION_TYPE[professionId] then
        local targetTable = ProOfflineReverseMap[professionId]
        if nil ~= targetTable then
            return true
        end

        for k, v in pairs(targetTable) do
            if nil ~= DROPDOWN_EQUIP_PROFESSION_TYPE[k] then
                return true
            end
        end

        return false
    end

    return true
end

return IllustrationMgr

