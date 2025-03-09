--lua model
module("ModuleData.MedalData", package.seeall)
--lua model end

--lua custom scripts
EMedalOpenType = 
{
    ChooseMedalAttr = 1,
    RefreshShowInfo = 2
}

--勋章枚举
EMedalOperate = 
{
    None = MedalOpType.Medal_Op_None,
    Activate = MedalOpType.Medal_Op_Active,    --激活
    Upgrade = MedalOpType.Medal_Op_Upgrade,    --升级(神圣勋章进阶)
    Reset = MedalOpType.Medal_Op_Reset,        --重置
}

--光辉勋章属性反向表
gloryMedalAttrData = {}
--神圣勋章属性反向表
holyMedalAttrData = {}
--总徽章数据表
medalAllTable = {}
--当前进阶光辉勋章ID
medalAdvanceId = nil
--之前进阶光辉勋章ID
medalAdvanceOldId = nil
--激活神圣勋章的Image
medalAdvanceImage = nil
--光辉勋章总等级
gloryMedalLevelNum = 0
--光辉勋章晋升消耗表
gloryMedalUpgradeCostTable = {}
--勋章一次进阶的次数
medalUpdateTimes = 1

medalConsumeTable = {}

--Require c初始化全局数据 
function Init( ... )
    InitMedalConsumeData()
    InitGloaryMedalAttrData()
    InitHolyMedalAttrData()
    InitGloryMedalUpgradeCostData()
    IntegrationAllMedalData()
end

--Logout重置动态数据
function Logout( ... )
	CleanUpMedalData()
end


--MedalConsumeTable
function InitMedalConsumeData()
    local l_medalConsumeTb = TableUtil.GetMedalConsumeTable().GetTable()
    for k, v in ipairs(l_medalConsumeTb) do
        if not medalConsumeTable[v.MedalId] then
            medalConsumeTable[v.MedalId] = {}
        end
        if not medalConsumeTable[v.MedalId][v.MedalLv] then
            medalConsumeTable[v.MedalId][v.MedalLv] = {}
        end
        medalConsumeTable[v.MedalId][v.MedalLv].TotalCost = v.TotalCost
        medalConsumeTable[v.MedalId][v.MedalLv].OnceConsume = v.OnceConsume
        medalConsumeTable[v.MedalId][v.MedalLv].OnceConsumeZeny = v.OnceConsumeZeny
    end
end

--获取某个勋章的 某个等级的消耗数据
function GetMedalConsumeData(medalId)
    if #medalConsumeTable == 0 then
        InitMedalConsumeData()
    end
    return medalConsumeTable[medalId]
end

--初始化光辉勋章属性反向表
function InitGloaryMedalAttrData( ... )
    if #gloryMedalAttrData == 0 then
        local medalAttrTable = TableUtil.GetMedalAttrTable().GetTable()
        for k, v in ipairs(medalAttrTable) do
            if not gloryMedalAttrData[v.MedalId] then
                gloryMedalAttrData[v.MedalId] = {}
            end
            local myProfessionAttribute = GetGloryMedalAttrByParentProfession(v)
            local baseAttribute = string.ro_split(myProfessionAttribute, "|")
            local baseData = {}
            for k, v in ipairs(baseAttribute) do
                table.insert(baseData, string.ro_split(v, "="))
            end
            gloryMedalAttrData[v.MedalId][v.level] = baseData
            gloryMedalAttrData[v.MedalId][v.level].dec = v.dec
        end
    end
end

--初始化神圣勋章属性反向表
function InitHolyMedalAttrData( ... )
    if #holyMedalAttrData == 0 then
        local superMedalAttrTable = TableUtil.GetSuperMedalAttrTable().GetTable()
        for k, v in ipairs(superMedalAttrTable) do
            if not holyMedalAttrData[v.MedalId] then
                holyMedalAttrData[v.MedalId] = {}
            end
            if not holyMedalAttrData[v.MedalId][v.Profession[0]] then
                holyMedalAttrData[v.MedalId][v.Profession[0]] = {}
            end
            holyMedalAttrData[v.MedalId][v.Profession[0]][v.AttrPos+1] = {BuffId = v.BuffId, BuffText = v.BuffText}
        end
    end
end

--初始化光辉勋章的消耗数据
function InitGloryMedalUpgradeCostData( ... )
    if gloryMedalUpgradeCostTable == nil or #gloryMedalUpgradeCostTable == 0 then
        local l_MedalData = TableUtil.GetMedalTable().GetTable()
        for k, v in ipairs(l_MedalData) do
            if gloryMedalUpgradeCostTable[v.MedalId] == nil then
                gloryMedalUpgradeCostTable[v.MedalId] = {}
            end
            local l_consumeData = GetMedalConsumeData(v.MedalId)
            --这里的Key == MedalLevel
            for key, value in pairs(l_consumeData) do
                if gloryMedalUpgradeCostTable[v.MedalId][key] == nil then
                    gloryMedalUpgradeCostTable[v.MedalId][key] = {}
                end
                gloryMedalUpgradeCostTable[v.MedalId][key].OnceConsume = value.OnceConsume
                gloryMedalUpgradeCostTable[v.MedalId][key].OnceConsumeZeny = value.OnceConsumeZeny
                gloryMedalUpgradeCostTable[v.MedalId][key].TotalCost = value.TotalCost
            end
        end
    end
end

--初始化并整合所有勋章表数据
function IntegrationAllMedalData( ... )
    if #medalAllTable == 0 then
        --光辉勋章
        local gloryMedalData = TableUtil.GetMedalTable().GetTable()
        medalAllTable[1] = {}
        for k, v in ipairs(gloryMedalData) do
            v.isActivate = false
            v.level = 0
            v.attrPos = 0
            v.prestigeProgress = 0
            v.activeProgress = 0
            v.type = 1
            v.attrInfo = gloryMedalAttrData[v.MedalId]
            table.insert(medalAllTable[1], v)
        end
        --神圣勋章
        local holyMedalData = TableUtil.GetSuperMedalTable().GetTable()
        medalAllTable[2] = {}
        for k, v in ipairs(holyMedalData) do
            v.isActivate = false
            v.level = 0
            v.attrPos = 0
            v.prestigeProgress = 0
            v.activeProgress = 0
            v.type = 2
            v.attrInfo = holyMedalAttrData[v.MedalId]
            table.insert(medalAllTable[2], v)
        end
    end
    medalUpdateTimes = MGlobalConfig:GetInt("BatchUseTimes") or 1
end

--登录协议数据解析
function SelectRolePbParse(info)
    --生成
    InitGloryMedalUpgradeCostData()
    --服务器进阶光辉勋章ID'
    medalAdvanceId = info.medal.advance_id
    --服务器勋章数据
    for k, v in ipairs(info.medal.medals) do
        if medalAllTable[v.medal_type] and medalAllTable[v.medal_type][v.medal_id] then
            medalAllTable[v.medal_type][v.medal_id].isActivate = v.is_activate
            medalAllTable[v.medal_type][v.medal_id].level = v.level
            medalAllTable[v.medal_type][v.medal_id].attrPos = v.attr_pos
            medalAllTable[v.medal_type][v.medal_id].prestigeProgress = v.prestige_progress
            medalAllTable[v.medal_type][v.medal_id].activeProgress = v.active_progress
            gloryMedalLevelNum = gloryMedalLevelNum + v.level
        end
    end
end

--操作勋章数据解析
function MedalOperatePbParse(info,arg)
    medalAdvanceOldId = medalAdvanceId
    local medalData = info.changed_medals
    local medalOperate = arg.op_type
    local isGloryLevelUp = false
    if medalData.medal_type then
        if medalOperate == EMedalOperate.UPGRADE then
            --重新计算总光辉勋章等级
            if medalData.medal_type == 1 then
                if medalAllTable[medalData.medal_type][medalData.medal_id].level ~= medalData.level then
                    isGloryLevelUp = true
                    gloryMedalLevelNum = gloryMedalLevelNum - medalAllTable[medalData.medal_type][medalData.medal_id].level + medalData.level
                end
            end
        end
        medalAllTable[medalData.medal_type][medalData.medal_id].isActivate = medalData.is_activate
        medalAllTable[medalData.medal_type][medalData.medal_id].level = medalData.level
        medalAllTable[medalData.medal_type][medalData.medal_id].attrPos = medalData.attr_pos
        medalAllTable[medalData.medal_type][medalData.medal_id].prestigeProgress = medalData.prestige_progress
        medalAllTable[medalData.medal_type][medalData.medal_id].activeProgress = medalData.active_progress
        medalData = medalAllTable[medalData.medal_type][medalData.medal_id]
    end
    return medalData,isGloryLevelUp
end

--勋章变化Pb数据解析
function MedalChangedNtfPbParse(info)
    local medalData = info.medal_info
    if medalAllTable[medalData.medal_type] == nil then logError("medalAllTable is nil Type : medalData.medal_type: "..medalData.medal_type) return end
    if medalAllTable[medalData.medal_type][medalData.medal_id] == nil then logError("medalAllTable is nil Type : medalData.medal_id: "..medalData.medal_id) return end
    --光辉勋章总等级
    gloryMedalLevelNum = gloryMedalLevelNum - medalAllTable[medalData.medal_type][medalData.medal_id].level + medalData.level
    --覆盖数据
    medalAllTable[medalData.medal_type][medalData.medal_id].isActivate = medalData.is_activate
    medalAllTable[medalData.medal_type][medalData.medal_id].level = medalData.level
    medalAllTable[medalData.medal_type][medalData.medal_id].attrPos = medalData.attr_pos
    medalAllTable[medalData.medal_type][medalData.medal_id].prestigeProgress = medalData.prestige_progress
    medalAllTable[medalData.medal_type][medalData.medal_id].activeProgress = medalData.active_progress
    return medalData
end

--重新加载光辉勋章数据
function ReInintGloaryData( ... )
    local gloryMedalDataTemp = {}
    local medalAttrTable = TableUtil.GetMedalAttrTable().GetTable()
    for k, v in ipairs(medalAttrTable) do
        if not gloryMedalDataTemp[v.MedalId] then
            gloryMedalDataTemp[v.MedalId] = {}
        end
        local myProfessionAttribute = GetGloryMedalAttrByParentProfession(v)
        local baseAttribute = string.ro_split(myProfessionAttribute, "|")
        local baseData = {}
        for k, v in ipairs(baseAttribute) do
            table.insert(baseData, string.ro_split(v, "="))
        end
        gloryMedalDataTemp[v.MedalId][v.level] = baseData
    end
    
    --光辉勋章
    local gloryMedalData = TableUtil.GetMedalTable().GetTable()
    for k, v in ipairs(gloryMedalData) do
        if medalAllTable[1][k] then
            medalAllTable[1][k].attrInfo = gloryMedalDataTemp[v.MedalId]
        end
    end
end

--清理勋章数据
function CleanUpMedalData()
    -- gloryMedalLevelNum = 0
    -- gloryMedalAttrData = {}
    -- holyMedalAttrData = {}
    -- medalAllTable = {}
    -- medalAdvanceId = 0
    -- medalAdvanceOldId = 0
    -- gloryMedalUpgradeCostTable = {}
end

--根据玩家当前职业 获取玩家副职业的属性值
function GetGloryMedalAttrByParentProfession(rowData)
    if rowData == nil then
        logError("rowData nil on GetGloryMedalAttrByParentProfession")
        return
    end
    local parentId = Common.CommonUIFunc.GetParentIdByCurProfessionId(MPlayerInfo.ProID)
    if Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID,2000) then
        return rowData.BaseAtttibuteSwordman
    elseif Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID,3000) then
        return rowData.BaseAtttibuteAcolyte
    elseif Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID,4000) then
        return rowData.BaseAtttibuteMagician
    elseif Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID,5000) then
        return rowData.BaseAtttibuteThief
    elseif Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID,6000) then
        return rowData.BaseAtttibuteMerchant
    elseif Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID,7000) then
        return rowData.BaseAtttibuteArcher
    end
    return nil
end

--------------------------------------------对外提供勋章数据的接口--Start--------------------------

--获取光辉勋章数据表
function GetGloryMedalData()
    return medalAllTable[1]
end

--获取神圣勋章数据表
function GetHolyMedalData()
    return medalAllTable[2]
end

--获取当前进阶光辉勋章ID
function GetMedalAdvanceId()
    return medalAdvanceId
end

--之前进阶光辉勋章ID
function GetMedalAdvanceOldId()
    return medalAdvanceOldId
end

--获得激活神圣勋章的Image
function GetMedalAdvanceImage()
    return medalAdvanceImage
end

--获取光辉勋章总等级
function GetGloryMedalLevelNum()
    return gloryMedalLevelNum
end

--返回勋章的一次升级的总次数
function GetMedalUpdateTimes()
    return medalUpdateTimes
end

--获取光辉勋章晋升消耗 --0 代表勋章 1代表Zeny [level][0]
function GetGloryMedalUpgradeCostByLevel(medalId,level)
    return gloryMedalUpgradeCostTable[medalId][level].OnceConsume
end

function GetGloryZenyUpgradeCostByLevel(medalId,level)
    return gloryMedalUpgradeCostTable[medalId][level].OnceConsumeZeny
end

function GetGloryUpgradeTotalCostByLevel(medalId,level)
    return gloryMedalUpgradeCostTable[medalId][level].TotalCost
end

--------------------------------------------对外读取勋章数据的接口--End---------------------------------

return ModuleData.MedalData