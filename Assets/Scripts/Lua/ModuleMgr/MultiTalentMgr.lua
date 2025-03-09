---@module ModuleMgr.MultiTalentMgr
module("ModuleMgr.MultiTalentMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
ReceiveRenameMultiTalentEvent = "ReceiveRenameMultiTalentEvent"
ReceiveOpenMultiTalentEvent = "ReceiveOpenMultiTalentEvent"
ReceiveChangeMultiTalentEvent = "ReceiveChangeMultiTalentEvent"

l_skillMultiTalent = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.SkillMultiTalent --技能双天赋Id
l_attrMultiTalent = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.AttrMultiTalent   --属性双天赋Id
l_equipMultiTalent = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipMultiTalent --装备双天赋Id

-- todo 搭配界面双天赋 id
-- todo 只有这个文件在用，还不知道是什么
l_collocationSysId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Collocation

l_multiTalentIdTable = {
    l_equipMultiTalent,
    l_attrMultiTalent,
    l_skillMultiTalent,
}

l_multiTalentTableData = nil
l_timer = {}

--- 标注一下，现在mgr不是用class做的，所以没有传self
---@type function
OnOpenMultiTalentFunc = nil

--配置信息初始化
function SetAllMultiTableData()
    if l_multiTalentTableData then
        return l_multiTalentTableData
    end

    l_multiTalentTableData = {}

    local tableDataList=TableUtil.GetMultiTalentTable().GetTable()

    for i = 1, #tableDataList do
        local cData = tableDataList[i]
        if l_multiTalentTableData[cData.SystemId] == nil then
            l_multiTalentTableData[cData.SystemId] = {}
        end

        l_multiTalentTableData[cData.SystemId][tonumber(cData.ProjectId)] = cData
    end

    return l_multiTalentTableData

end

--根据系统Id 取MultiTanlent表里面改系统的几套方案的数据 排过序列
function GetMultiTableDataBySystemId(systemId)
    local tableData=l_multiTalentTableData[systemId]
    if tableData==nil then
        logError("tableData是空的，systemId："..tostring(systemId))
    end
    return tableData
end

function GetMultiTableDataWithSystemIdAndIndex(systemId, index)
    local l_tableInfos = GetMultiTableDataBySystemId(systemId)
    if l_tableInfos == nil then
        return nil
    end
    return l_tableInfos[index]

end

--给聊天提供 获取多天赋状态  参数系统的Func Id
function GetMultiDataBySystemId(systemId)
    local l_tableInfos = GetMultiTableDataBySystemId(systemId)
    local finTb = {}
    for i, v in ipairs(l_tableInfos) do
        local nowData = {}
        local l_isOpen = IsTalentOpenWithFunctionAndIndex(systemId, v.ProjectId)
        if l_isOpen then
            nowData.index = v.ProjectId
            nowData.name = GetTalentNameWithFunctionAndIndex(systemId, v.ProjectId)
            table.insert(finTb, nowData)
        end
    end
    return finTb

end

--开启某一个多天赋功能
function OpenMultiTalent(systemId, planId)
    local l_msgId = Network.Define.Rpc.OpenMultiTalent
    ---@type OpenMultiTalentArg
    local l_sendInfo = GetProtoBufSendTable("OpenMultiTalentArg")
    l_sendInfo.data.system_id = systemId
    l_sendInfo.data.plan_id = planId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnOpenMultiTalent(msg, sendInfo)
    ---@type OpenMultiTalentRes
    local l_info = ParseProtoBufToTable("OpenMultiTalentRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        if sendInfo.data.system_id == l_equipMultiTalent then
            OnOpenMultiTalentFunc()
        end

        ShowOpenTalentMsg(l_info)
    end

    EventDispatcher:Dispatch(ReceiveOpenMultiTalentEvent, l_info)
end

function ShowOpenTalentMsg(openInfo)
    if openInfo.data.system_id == l_skillMultiTalent then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTI_SKILL", Lang("ATTR_PLAN_"..openInfo.data.plan_id)))
    end

    if openInfo.data.system_id == l_attrMultiTalent then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTI_ATTR", Lang("ATTR_PLAN_"..openInfo.data.plan_id)))
    end

    if openInfo.data.system_id == l_equipMultiTalent then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTI_EQUIP", Lang("ATTR_PLAN_"..openInfo.data.plan_id)))
    end

end

--手动切换多天赋
function ChangeMultiTalent(systemId, planId)
    if not OnChangeMultiTalentCheck(systemId) then
        return
    end

    if systemId == l_equipMultiTalent then
        MgrProxy:GetMultiTalentEquipMgr().WillChangeEquipMultiTalent(planId)
    end

    local l_msgId = Network.Define.Rpc.ChangeMultiTalent
    ---@type ChangeMultiTalentArg
    local l_sendInfo = GetProtoBufSendTable("ChangeMultiTalentArg")
    l_sendInfo.data.system_id = systemId
    l_sendInfo.data.plan_id = planId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnChangeMultiTalent(msg, sendInfo)
    ---@type ChangeMultiTalentRes
    local l_info = ParseProtoBufToTable("ChangeMultiTalentRes", msg)
    if l_info.result ~= 0 then

        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        local l_systemId = sendInfo.data.system_id
        l_timer[l_systemId] = Timer.New(function()
            l_timer[l_systemId] = nil
        end, 15)

        l_timer[l_systemId]:Start()
        --if sendInfo.data.system_id == l_equipMultiTalent then
        --    MgrProxy:GetMultiTalentEquipMgr().SetCurrentPage(sendInfo.data.plan_id)
        --end
    end

    EventDispatcher:Dispatch(ReceiveChangeMultiTalentEvent, sendInfo)
    if l_info.result == 0 then
        ShowChangeTalentMsg(l_info)
    end
end

function ShowChangeTalentMsg(changeInfo)

    local l_textKey
    if changeInfo.data.system_id == l_skillMultiTalent then
        l_textKey = "MULTI_SKILL_CHANGE_SUCCESS"
    end
    if changeInfo.data.system_id == l_attrMultiTalent then
        l_textKey = "MULTI_ATTR_CHANGE_SUCCESS"
    end
    if changeInfo.data.system_id == l_equipMultiTalent then
        l_textKey = "MULTI_EQUIP_CHANGE_SUCCESS"
    end

    if l_textKey == nil then
        return
    end

    local l_name = GetTalentNameWithFunctionAndIndex(changeInfo.data.system_id, changeInfo.data.plan_id)
    if l_name == nil then
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang(l_textKey), l_name))

end

function OnChangeMultiTalentCheck(systemId)

    if l_timer[systemId] ~= nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHANGE_MULTI_INTIME"))
        return false
    end

    if MEntityMgr.PlayerEntity.InBattle then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHANGE_MULTI_INBATTLE"))
        return false
    end

    local sceneID = MScene.SceneID
    local SceneTable = TableUtil.GetSceneTable().GetRowByID(sceneID)
    if SceneTable.SceneType == 8 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHANGE_MULTI_INPVP"))
        return false
    end

    --装备判断
    if systemId == l_equipMultiTalent then
    end
    return true

end

--重命名某一个天赋
function RenameMultiTalent(systemId, planId, planName)

    --logGreen("RenameMultiTalent:",planName)
    MgrMgr:GetMgr("ForbidTextMgr").RequestJudgeTextForbid(planName, function(checkInfo)
        local l_resultCode = checkInfo.result
        if l_resultCode ~= 0 then
            --判断服务器是否判断失败 如果失败什么都不发生
            if l_resultCode == ErrorCode.ERR_FAILED then
                return
            end
            --含有屏蔽字则提示
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resultCode))
            return
        end

        local l_number = tonumber(planName)
        if l_number then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MultiTalent_CantRenameWithNumber"))
            return
        end

        local l_nameLenMin = MGlobalConfig:GetInt("RoleNameLenMin")
        local l_nameLenMax = MGlobalConfig:GetInt("RoleNameLenMax")
        --判断字符串长度
        local l_nameLength = tonumber(string.ro_len(planName))

        if l_nameLength == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MultiTalent_CantRenameWithEmpty"))
            return
        end

        if l_nameLength < l_nameLenMin or l_nameLength > l_nameLenMax then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MultiTalent_CantRenameWithLength"))
            return
        end
        --判断是否有非法字符
        if string.ro_isLegal(planName) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MultiTalent_CantRenameWithIllegal"))
            return
        end

        local l_msgId = Network.Define.Rpc.RenameMultiTalent
        ---@type RenameMultiTalentArg
        local l_sendInfo = GetProtoBufSendTable("RenameMultiTalentArg")
        l_sendInfo.data.system_id = systemId
        l_sendInfo.data.plan_id = planId
        l_sendInfo.new_plan_name = planName
        Network.Handler.SendRpc(l_msgId, l_sendInfo)

    end)

end

function OnRenameMultiTalent(msg, sendInfo)

    ---@type RenameMultiTalentRes
    local l_info = ParseProtoBufToTable("RenameMultiTalentRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        if sendInfo.data.system_id == l_equipMultiTalent then
            MgrProxy:GetMultiTalentEquipMgr().SetEquipTalentName(sendInfo.data.plan_id, sendInfo.new_plan_name)
        end
    end

    EventDispatcher:Dispatch(ReceiveRenameMultiTalentEvent, l_info, sendInfo)

end

function AcceptTeamInvatationByTeamInfo(teamInfo)
    -- do nothing
end

function OnAcceptTeamInvatation(msg)
    -- do nothing
end

--得到当前启用的方案的index
function GetCurrentTalentIndexWithFunction(functionId)
    if functionId == l_attrMultiTalent then
        return MgrMgr:GetMgr("RoleInfoMgr").l_curPage or 1
    elseif functionId == l_skillMultiTalent then
        return MgrMgr:GetMgr("SkillLearningMgr").GetCurPage()
    elseif functionId == l_equipMultiTalent then
        return MgrProxy:GetMultiTalentEquipMgr().GetCurrentPage()
    end

    return 1
end

--根据天赋类型和index取方案名字
function GetTalentNameWithFunctionAndIndex(functionId, index)
    if functionId == l_attrMultiTalent then
        local l_data = MgrMgr:GetMgr("RoleInfoMgr").l_qualityPointPageInfo
        if l_data and l_data[index] and l_data[index].name then
            return l_data[index].name
        else
            return ""
        end
    elseif functionId == l_skillMultiTalent then
        return MgrMgr:GetMgr("SkillLearningMgr").GetPageName(index)
    elseif functionId == l_equipMultiTalent then
        return MgrProxy:GetMultiTalentEquipMgr().GetEquipTalentNameWithIndex(index)
    end

    return ""
end

--根据天赋类型和index，判断是否开启
function IsTalentOpenWithFunctionAndIndex(functionId, index)
    if functionId == l_attrMultiTalent then
        local l_data = MgrMgr:GetMgr("RoleInfoMgr").l_pageCount
        return l_data >= index
    elseif functionId == l_skillMultiTalent then
        return DataMgr:GetData("SkillData").IsPageOpen(index)
    elseif functionId == l_equipMultiTalent then
        return MgrProxy:GetMultiTalentEquipMgr().IsEquipTalentOpenWithIndex(index)
    end

    return true
end

--根据天赋类型取当前方案名字
function GetTalentNameWithFunction(functionId)

    local curIndex = GetCurrentTalentIndexWithFunction(functionId)
    return GetTalentNameWithFunctionAndIndex(functionId, curIndex) or nil
end

SetAllMultiTableData()

-- 判断双天赋功能开启
function IsMultiTalentMgrOpen(talentType)

    local systemId = -1
    if talentType == GameEnum.MultiTaltentType.Skill then
        systemId = l_skillMultiTalent
    elseif talentType == GameEnum.MultiTaltentType.Attr then
        systemId = l_attrMultiTalent
    elseif talentType == GameEnum.MultiTaltentType.Equip then
        systemId = l_equipMultiTalent
    end
    if systemId > 0 then
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(systemId)
    end

end

function IsCollocationSysOpen(...)
    return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_collocationSysId)
end

return ModuleMgr.MultiTalentMgr