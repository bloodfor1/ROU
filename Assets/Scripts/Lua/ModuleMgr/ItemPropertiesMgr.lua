module("ModuleMgr.ItemPropertiesMgr", package.seeall)

AttrTypeBuff = 1 -- 属性是BUFF类型

AttrShowTypeNormalAdd = 0  --显示数值，正数会显示+
AttrShowTypePercentAdd = 1 --显示百分比，正数会显示+
AttrShowTypeNormal = 2     --显示数值
AttrShowTypePercent = 3    --显示百分比
AttrShowTypeElement = 4 --元素

--从表里取基础属性数据
function GetEquipBasicAttrInfoWithTableData(equipTableData)
    if equipTableData == nil then
        return {}
    end
    return GetAttrsWithTableData(equipTableData.BaseAttributes)
end

function GetAttrsWithTableData(data)

    local l_attrs = {}
    local l_perData = nil
    local l_perDataCount = 0

    for i = 1, data.Length do

        l_perData = data[i - 1]
        l_perDataCount = l_perData.Length

        if l_perDataCount > 2 then
            local attr = {}
            attr.type = l_perData[0]
            attr.id = l_perData[1]
            if l_perDataCount == 3 then
                attr.val = l_perData[2]
            else
                attr.val = l_perData[3]
            end

            table.insert(l_attrs, attr)
        end

    end
    return l_attrs
end

--从表里取到词条属性数据
function GetEquipEntryAttrInfoWithTableData(equipTableData)
    local l_attrs = {}

    local l_entryTableDatas = string.ro_split(equipTableData.EntryAttributeOne, '|')
    for i = 1, #l_entryTableDatas do
        local l_perEntryTableDatas = string.ro_split(l_entryTableDatas[i], '=')
        local l_entryAttr = {}
        l_entryAttr.type = tonumber(l_perEntryTableDatas[1])
        l_entryAttr.id = tonumber(l_perEntryTableDatas[2])
        if l_entryAttr.type == 0 then
            if #l_perEntryTableDatas == 4 then
                l_entryAttr.val = tonumber(l_perEntryTableDatas[4])
            else
                l_entryAttr.val = tonumber(l_perEntryTableDatas[3])
            end
        else
            l_entryAttr.extra_param = {}
            for i = 3, #l_perEntryTableDatas, 3 do
                local l_param = {}
                local l_equipMapStringIntTableInfo = TableUtil.GetEquipMapStringInt().GetRowByParamName(l_perEntryTableDatas[i], true)
                if l_equipMapStringIntTableInfo then
                    l_param.key = l_equipMapStringIntTableInfo.Value
                else
                    l_param.key = 0
                end
                l_param.value = tonumber(l_perEntryTableDatas[i + 2])
                table.insert(l_entryAttr.extra_param, l_param)

            end
        end

        table.insert(l_attrs, l_entryAttr)
    end

    return l_attrs
end

--取表里的数据
--得到装备的基础属性和词条属性的描述
function GetAllEquipAttrTextWithId(propId, valueColor)
    local l_texts = {}
    local l_equipTableInfo = TableUtil.GetEquipTable().GetRowById(propId)
    if l_equipTableInfo == nil then
        return l_texts
    end

    local l_attrs = GetEquipBasicAttrInfoWithTableData(l_equipTableInfo)
    for i = 1, #l_attrs do
        local l_text = MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(l_attrs[i], valueColor)
        table.insert(l_texts, l_text)
    end

    l_attrs = GetEquipEntryAttrInfoWithTableData(l_equipTableInfo)
    local l_text = GetEquipEntryAttrsText(l_equipTableInfo.EquipText, l_attrs, valueColor)
    table.insert(l_texts, l_text)

    return l_texts
end

--得到装备的词条属性描述
--equipTextId 文本ID
--attrDatas 流派词条属性
--valueColor 数值颜色
function GetEquipEntryAttrsText(equipTextId, attrDatas, valueColor)
    local l_textList = GetEquipEntryAttrsTextList(equipTextId, attrDatas, valueColor)
    local l_text = ""
    for i = 1, #l_textList do
        if i == 1 then
            l_text = l_textList[i]
        else
            l_text = l_text .. "; " .. l_textList[i]
        end
    end

    return l_text
end

function GetEquipEntryAttrsTextList(equipTextId, attrDatas, valueColor)
    local l_textList = {}

    if equipTextId == 0 then
        return l_textList
    end

    if attrDatas == nil then
        logError("属性数据为空")
        return l_textList
    end
    --描述文本
    local l_equipTextTable = TableUtil.GetEquipText().GetRowByID(equipTextId)
    if l_equipTextTable == nil then
        logError("EquipText表没有配这个id：" .. tostring(equipTextId))
        return l_textList
    end

    local l_equipTextInfo = l_equipTextTable.ActTextOne
    if l_equipTextInfo == nil then
        logError("流派词条没有配文本")
        return l_textList
    end

    local l_mapInEntry = nil

    --流派词条块
    for i = 1, #attrDatas do
        local l_text = ""
        if i > l_equipTextInfo.Length then
            logError("属性描述越界，有" .. #attrDatas .. "条属性，但是只配了" .. l_equipTextInfo.Length .. "条文本描述")
            return l_textList
        end

        l_text = l_equipTextInfo[i - 1]

        if l_text == "Nil" then
            l_text = MgrMgr:GetMgr("EquipMgr").GetAttrName(attrDatas[i], valueColor)
        else
            if l_text ~= nil and l_text ~= "" then

                local l_extraParam = attrDatas[i].extra_param

                if l_extraParam then
                    for i = #l_extraParam, 1, -1 do
                        if not _isEquipTextContainParamName(l_text, l_extraParam[i].key) then
                            table.remove(l_extraParam, i)
                        end
                    end

                    --剔除不需要显示的key
                    local l_keyStr = ""
                    for j = 1, #l_extraParam do

                        l_mapInEntry = l_extraParam[j]
                        l_keyStr = TableUtil.GetEquipMapStringInt().GetRowByValue(l_mapInEntry.key).ParamName
                        --找到这个key的索引
                        local l_index = string.find(l_text, l_keyStr)

                        if l_index then
                            --key的长度
                            local l_length = string.len(l_keyStr)
                            --找到key后面的第二个位置判断是不是百分比数值
                            local l_preIndex = l_index + l_length + 1
                            local l_preStr = string.sub(l_text, l_preIndex, l_preIndex)
                            local l_oldStr = ""
                            local l_value = l_mapInEntry.value
                            if l_preStr == "%" then
                                l_value = StringEx.Format("{0:F2}", l_mapInEntry.value / 100)
                                l_oldStr = StringEx.Format("{{{0}}}", l_keyStr)
                            else
                                l_oldStr = StringEx.Format("{{{0}}}", l_keyStr)
                            end
                            --替换key为数值
                            l_text = string.gsub(l_text, l_oldStr, tostring(l_value))
                        end
                    end
                end

            end
        end

        if l_text ~= nil and l_text ~= "" then
            l_text = StringEx.ReplaceSpace(l_text)
            table.insert(l_textList, l_text)
        end

    end

    return l_textList
end

function _isEquipTextContainParamName(equipText, paramKey)
    if paramKey == 0 then
        return false
    end
    local l_equipMapStringInt = TableUtil.GetEquipMapStringInt().GetRowByValue(paramKey)
    if not l_equipMapStringInt then
        return false
    end
    local l_keyStr = l_equipMapStringInt.ParamName
    local l_index = string.find(equipText, l_keyStr)
    if l_index == nil then
        return false
    end
    return true
end

--成就和摆摊里使用，得到道具相关的描述数据等文本
--返回一个字符串，有描述等信息
function GetDetailInfo(id)
    local l_str = ""
    local l_flag = "\n"
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(id)
    if l_itemRow == nil then
        return l_str
    end
    ---====================================================================
    local l_LevelLimit = l_itemRow.LevelLimit
    local l_lowLevel = l_LevelLimit[0]
    local l_heightLevel = l_LevelLimit[1]
    local l_levelStr = ""
    local l_one = Common.Utils.Lang("TRADE_DES_LEVEL")
    if l_lowLevel ~= 0 and l_heightLevel == -1 then
        l_levelStr = l_one .. "：" .. l_lowLevel
        l_str = l_str .. l_levelStr .. l_flag
    end
    if l_lowLevel == 0 and l_heightLevel ~= -1 then
        l_levelStr = l_one .. "：<" .. l_heightLevel
        l_str = l_str .. l_levelStr .. l_flag
    end
    if l_lowLevel ~= 0 and l_heightLevel ~= -1 then
        l_levelStr = l_one .. "：" .. l_lowLevel .. "-" .. l_heightLevel
        l_str = l_str .. l_levelStr .. l_flag
    end
    ---====================================================================
    local l_sexStr = ""
    local l_sexLimit = l_itemRow.SexLimit
    if l_sexLimit == 0 then
        l_sexStr = Common.Utils.Lang("TRADE_DES_SEX_1")
        l_str = l_str .. l_sexStr .. l_flag
    end
    if l_sexLimit == 1 then
        l_sexStr = Common.Utils.Lang("TRADE_DES_SEX_2")
        l_str = l_str .. l_sexStr .. l_flag
    end
    ---====================================================================
    local l_proStr = ""
    local l_proLimit = l_itemRow.Profession
    l_proStr = Common.CommonUIFunc.GetProfessionStr(l_proLimit)

    l_str = l_str .. l_proStr .. l_flag
    ---======================================================================

    local l_equipDes = ""
    if l_itemRow.TypeTab == 1 then
        l_equipDes = "\n" .. table.concat(GetAllEquipAttrTextWithId(id), "\n")
    end

    local l_des = Common.Utils.Lang("TRADE_DES_ITEM") .. "："
    local l_typeStr = l_des .. Common.CommonUIFunc.GetItemTypeNameBySubClssType(l_itemRow.Subclass)
    l_str = l_str .. l_typeStr .. l_equipDes .. l_flag

    if l_itemRow.TypeTab == 4 then
        local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(id)
        if l_cardInfo then
            for i = 0, l_cardInfo.CardAttributes.Length - 1 do
                local attr = {}
                attr.type = l_cardInfo.CardAttributes[i][0]
                attr.id = l_cardInfo.CardAttributes[i][1]
                -- MgrMgr:GetMgr("EquipMgr").SetExtraParmOrValue(attr, l_cardInfo.CardAttributes[i])
                attr.val = l_cardInfo.CardAttributes[i][2]
                l_str = l_str .. MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr) .. l_flag
            end
        end
    end
    local l_des = l_itemRow.ItemDescription == "0" and "" or l_itemRow.ItemDescription
    return Lang(l_str .. l_des)
end

--直接取EquipText表里的PreText字段来进行显示
function GetPropertyNameWithEquipTextId(id)
    local l_equipTextTable = TableUtil.GetEquipText().GetRowByID(id)
    if l_equipTextTable == nil then
        logError("EquipText表没有配这个id：" .. tostring(id))
        return ""
    end
    local l_text = ""
    for i = 0, l_equipTextTable.PreText.Length - 1 do
        l_text = l_text .. l_equipTextTable.PreText[i]
    end
    return l_text
end

function GetPropertyValueTextWithId(id, value)
    local l_attrTableInfo = TableUtil.GetAttrDecision().GetRowById(id)
    if l_attrTableInfo == nil then
        return value
    end

    return GetPropertyValueText(l_attrTableInfo, value)
end

--显示属性数值
function GetPropertyValueText(attrInfo, value)
    local showType = attrInfo.TipParaEnum

    --特殊处理
    --539固定吟唱 540可变吟唱 542技能动作延迟时间 543冷却时间
    --应为在装备属性配置不支持浮点小数 所以这几个属性配成乘以了10000的 战斗组会除以10000计算 所以前端显示和预览也需要除以10000
    local roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
    if attrInfo.Id == roleInfoMgr.ATTR_BASIC_CT_FIXED
            or attrInfo.Id == roleInfoMgr.ATTR_BASIC_CT_CHANGE
            or attrInfo.Id == roleInfoMgr.ATTR_BASIC_CD_CHANGE
            or attrInfo.Id == roleInfoMgr.ATTR_BASIC_GROUP_CD_CHANGE then
        value = tonumber(StringEx.Format("{0:F2}", value / 10000))
    end

    local num = StringEx.Format("{0:F2}", value)
    if showType == AttrShowTypeNormalAdd then
        if value > 0 then
            num = "+" .. tostring(math.floor(value))
        else
            num = tostring(math.floor(value))
        end
    elseif showType == AttrShowTypeNormal then
        num = tostring(math.floor(value))
    elseif showType == AttrShowTypePercentAdd then
        if value > 0 then
            num = "+" .. GetPercentFormat(value)
        else
            num = GetPercentFormat(value)
        end
    elseif showType == AttrShowTypePercent then
        num = GetPercentFormat(value)
    elseif showType == AttrShowTypeElement then
        num = GetElementNameByIndex(value)
    end

    return num
end

--得到百分比样式的数据
function GetPercentFormat(data)
    local percent = data / 100
    percent = StringEx.Format("{0:F2}%", percent)
    return percent
end
function GetElementNameByIndex(index)
    local ret = "error"
    if elementName[index] then
        ret = elementName[index]
    end

    return ret
end

function GetRequireCountColorText(currentCount, requireCount)
    local l_color
    if currentCount >= requireCount then
        l_color = RoColorTag.Green
    else
        l_color = RoColorTag.Red
    end

    return GetColorText(tostring(currentCount), l_color)
end