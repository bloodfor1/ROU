require "Data/Model/BagModel"
require "Common/Bit32"

module("ModuleMgr.SuitMgr", package.seeall)

local l_data

function OnInit()

    l_data = DataMgr:GetData("SuitData")
end

function OnUnInit()

end

-- 返回身上穿戴装备的SecondId集合
local function getEquipmentsSecondId()

    local l_bagModel = Data.BagModel
    local l_getEquipFunc = TableUtil.GetEquipTable().GetRowById

    local l_result = {}
    for k, v in pairs(Data.BagModel.WeapType) do
        local l_propInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, v + 1)
        if l_propInfo then
            local l_equipRow = l_getEquipFunc(l_propInfo.TID)
            if l_equipRow then
                l_result[l_equipRow.EquipSecondId] = true
            end
        end
    end

    return l_result
end

--[[  返还玩家装备套装的详细信息
{
    --套装id
    [suitId] = {
        -- 激活套装
        suits = {
            [2] = true,   代表2件套属性激活
        },
        -- 全部套装信息
        suitsInfo = {
            [2] = "物理攻击+50",  两件套的效果描述
            [3] = "魔法攻击+50",  三件套的效果描述
            ...
        },
        -- 匹配成功列表
        matchInfo = {
            -- 1代表装备
            [1] = {
                itemid,
                itemid,
                ...
            },
            -- 2代表道具
            [2] = {
                itemid,
                itemid,
                ...
            }
        },
        -- component信息
        componentInfo = {
            [1] = {
                itemid,
                itemid,
                ...
            },
            -- 2代表道具
            [2] = {
                itemid,
                itemid,
                ...
            }
        }
    },
    ...
}
]]
function GetEquipedEquipmentSuitInfo(mask)

    mask = mask or l_data.ESuitInfoMask.Simple

    local l_equipsSecondId = getEquipmentsSecondId()
    local l_arrowMgr = MgrMgr:GetMgr("ArrowMgr")

    local l_result = {}
    -- 检查secondid满足
    local function _checkSuitFunc1(id)
        return l_equipsSecondId[id]
    end
    -- 检查箭矢
    local function _checkSuitFunc2(id)
        return l_arrowMgr.HasLoadArrow(id) and Data.BagModel:GetBagItemCountByTid(id) > 0
    end

    local l_outComponentInfo = Common.Bit32.And(mask, l_data.ESuitInfoMask.ComponentID) > 0

    --格式1为装备副ID 2为道具ID 1=20220020=20230020=20230090|2=3900003
    for _, v in ipairs(TableUtil.GetSuitTable().GetTable()) do
        local l_matchCount = 0
        local l_matchInfo = {}
        local l_componentInfo = {}
        for componentListIndex = 0, v.ComponentID.Length - 1 do
            local l_componentList = v.ComponentID[componentListIndex]
            -- list[0] 1=20220020=20230020=20230090
            -- list[1] 2=3900003
            -- 数量小于2不用处理
            if l_componentList.Length >= 2 then
                local l_type = l_componentList[0]
                local l_matchFunc
                if l_type == l_data.ESuitEquipComponentType.EquipSecondID then
                    l_matchFunc = _checkSuitFunc1
                elseif l_type == l_data.ESuitEquipComponentType.ItemID then
                    l_matchFunc = _checkSuitFunc2
                else
                    logError("GetEquipedEquipmentSuitInfo config error, component type error", l_type)
                end

                if l_matchFunc then
                    -- 第一个值为类型
                    for componentIndex = 1, l_componentList.Length - 1 do
                        local l_componentId = l_componentList[componentIndex]
                        local l_flag = l_matchFunc(l_componentId)
                        if l_flag then
                            l_matchCount = l_matchCount + 1
                            l_matchInfo[l_type] = l_matchInfo[l_type] or {}
                            table.insert(l_matchInfo[l_type], l_componentId)
                        end

                        if l_outComponentInfo then
                            l_componentInfo[l_type] = l_componentInfo[l_type] or {}
                            table.insert(l_componentInfo[l_type], l_componentId)
                        end
                    end
                end
            end
        end

        l_result[v.SuitId] = {}

        -- 匹配数量大于1才有套装效果或者是外接主动需求
        if Common.Bit32.And(mask, l_data.ESuitInfoMask.IgnoreMatch) > 0 or l_matchCount >= 2 then
            local l_ret = l_result[v.SuitId]
            l_ret.suitsInfo = {}
            l_ret.suits = {}
            l_ret.matchInfo = l_matchInfo
            -- 遍历处理符合条件的套装属性
            for matchCount, suitKey in pairs(l_data.SuitDescKey) do
                if string.len(v[suitKey]) > 0 then
                    l_ret.suitsInfo[matchCount] = v[suitKey]
                end
                if l_matchCount >= matchCount then
                    l_ret.suits[matchCount] = true
                end
            end
        end

        -- 输出componentid
        if l_outComponentInfo then
            l_result[v.SuitId].componentInfo = l_componentInfo
        end
    end

    -- print(ToString(l_result))
    return l_result
end

--
function GetEquipmentSuiteInfo(propId)

    local l_matchComponentId = propId
    local type = l_data.ESuitEquipComponentType.ItemID
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(propId)
    local l_equipRow = TableUtil.GetEquipTable().GetRowById(propId, true)
    if l_itemRow and l_itemRow.TypeTab == 1 and l_equipRow then
        type = l_data.ESuitEquipComponentType.EquipSecondID
        l_matchComponentId = l_equipRow.EquipSecondId
    end

    local l_ret = GetEquipedEquipmentSuitInfo(l_data.ESuitInfoMask.IgnoreMatch + l_data.ESuitInfoMask.ComponentID)
    if not l_ret then
        return false
    end
    -- logError("l_matchComponentId", l_matchComponentId)
    local l_result = {}
    for suitId, suitDetail in pairs(l_ret) do
        if suitDetail.componentInfo and suitDetail.componentInfo[type] then
            for i, id in ipairs(suitDetail.componentInfo[type]) do
                -- logError("----------------------------", i, id, propId, l_matchComponentId)
                if id == l_matchComponentId then
                    l_result[suitId] = suitDetail
                end
            end
        end
    end

    return next(l_result) ~= nil, l_result
end

function GetMatchSuitEquipmentInfo(secondIdMap, mathchInfo, ignoreActive)

    local l_getEquipLimitFunc = MgrMgr:GetMgr("EquipMgr").GetEquipLimitLevel

    local l_tmp = {}
    for _, rowData in ipairs(TableUtil.GetEquipTable().GetTable()) do
        if secondIdMap[rowData.EquipSecondId] then
            local l_minLevel = l_getEquipLimitFunc(rowData.Id)
            if not l_tmp[rowData.EquipSecondId] then
                l_tmp[rowData.EquipSecondId] = {
                    minLevel = l_minLevel,
                    id = rowData.Id,
                    name = rowData.Name,
                }
            else
                if l_tmp[rowData.EquipSecondId].minLevel > l_minLevel then
                    l_tmp[rowData.EquipSecondId].minLevel = l_minLevel
                    l_tmp[rowData.EquipSecondId].id = rowData.Id
                    l_tmp[rowData.EquipSecondId].name = rowData.Name
                end
            end
        end
    end
    local l_matchMap = {}
    for i, v in pairs(mathchInfo) do
        l_matchMap[v] = true
    end
    local l_resultTbl = {}
    for k, v in pairs(l_tmp) do
        if ignoreActive or l_matchMap[k] then
            v.active = true
            v.name = RoColor.GetTextWithDefineColor(StringEx.Format("【{0}】", v.name), l_data.SuitActiveColor)
        else
            v.active = false
            v.name = RoColor.GetTextWithDefineColor(StringEx.Format("【{0}】", v.name), l_data.SuitGrayColor)
        end
        table.insert(l_resultTbl, v)
    end

    return l_resultTbl
end

function GetMatchSuitItemInfo(itemIds, matchInfo)
    local l_matchMap = {}
    for i, v in pairs(matchInfo) do
        l_matchMap[v] = true
    end

    local l_resultTbl = {}
    for k, v in pairs(itemIds) do
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v)
        if l_itemRow then
            local l_active = l_matchMap[v] and true or false
            local l_color = l_active and l_data.SuitActiveColor or l_data.SuitGrayColor
            table.insert(l_resultTbl, {
                active = l_active,
                name = RoColor.GetTextWithDefineColor(StringEx.Format("【{0}】", l_itemRow.ItemName), l_color),
                id = v,
            })
        else
            logError("GetMatchSuitItemInfo error itemid", v)
        end
    end

    return l_resultTbl
end

function GetSuitEquipmentNameBySuitDetail(suitDetail, ignoreActive)
    if not suitDetail.componentInfo then
        return
    end

    local l_resultTbl = {}
    local l_secondIds = suitDetail.componentInfo[l_data.ESuitEquipComponentType.EquipSecondID]
    if l_secondIds then
        local l_secondIdMap = {}
        for i, v in pairs(l_secondIds) do
            l_secondIdMap[v] = true
        end

        local l_mathchInfo = suitDetail.matchInfo[l_data.ESuitEquipComponentType.EquipSecondID] or {}
        table.ro_insertRange(l_resultTbl, GetMatchSuitEquipmentInfo(l_secondIdMap, l_mathchInfo, ignoreActive))
    end

    local l_itemIds = suitDetail.componentInfo[l_data.ESuitEquipComponentType.ItemID]
    if l_itemIds then
        local l_mathchInfo = suitDetail.matchInfo[l_data.ESuitEquipComponentType.ItemID] or {}
        table.ro_insertRange(l_resultTbl, GetMatchSuitItemInfo(l_itemIds, l_mathchInfo))
    end

    table.sort(l_resultTbl, function(m, n)
        return n.id > n.id
    end)

    local l_result = {}
    for i, v in ipairs(l_resultTbl) do
        if i > 1 then
            local l_color = (ignoreActive or (l_resultTbl[i - 1].active and v.active)) and l_data.SuitActiveColor or l_data.SuitGrayColor
            table.insert(l_result, RoColor.GetTextWithDefineColor("+", l_color))
        end
        table.insert(l_result, v.name)
    end

    return table.concat(l_result, "")
end

function GetSuitDetailDesc(suitDetail, ignoreActive)
    local l_result = {}
    for i = 2, table.maxn(suitDetail.suitsInfo) do
        local l_info = suitDetail.suitsInfo[i]
        if l_info and string.len(l_info) > 0 then
            local l_baseInfo = Lang("SUIT_DESC_FORMAT1", i, l_info)
            local l_colorDesc
            if ignoreActive or suitDetail.suits[i] == true then
                l_colorDesc = RoColor.GetTextWithDefineColor(l_baseInfo, l_data.SuitActiveColor)
            else
                l_colorDesc = RoColor.GetTextWithDefineColor(l_baseInfo, l_data.SuitGrayColor)
            end
            table.insert(l_result, l_colorDesc)
        end
    end

    return l_result
end

function GetRecommandInfo(recommendSchool)

    local l_result = {}
    for i = 0, recommendSchool.Length - 1 do
        local l_professionTextTable = TableUtil.GetProfessionTextTable().GetRowByNAME(recommendSchool[i])
        table.insert(l_result, l_professionTextTable.SchoolName)
    end

    local l_split = Lang("SUIT_RECOMMAND_SPLIT")
    return table.concat(l_result, l_split)
end

return ModuleMgr.SuitMgr