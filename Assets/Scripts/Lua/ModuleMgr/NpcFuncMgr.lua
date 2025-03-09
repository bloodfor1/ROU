module("ModuleMgr.NpcFuncMgr", package.seeall)

--保持对话不关闭的事件
local keepTalkFunction = { "InfiniteTowerEvent", "EnterDungeonEvent", "OpenWorldMapEvent", "JoinArena", "OnHeroChallengeClick" }
--获取选择内容
function GetNpcFuncSelectInfoList(npcData)

    local ret = {}
    local NpcFunctionId = Common.Functions.VectorToTable(npcData.NpcFunctionId)
    if NpcFunctionId[1] == 0 then
        return ret
    end
    for i = 1, #NpcFunctionId do
        local l_functionId = NpcFunctionId[i]
        local tableData = TableUtil.GetOpenSystemTable().GetRowById(l_functionId)
        if tableData == nil then
            logError("npc表中NpcFunctionId配置错误：" .. tostring(l_functionId))
            return
        end
        local selectInfo = GetButtonEventInfo(tableData)
        if selectInfo then
            table.insert(ret, selectInfo)
        end
    end
    return ret

end
--tableData,OpenSystemTable表数据
--method按钮的方法
--isCloseOnClick点击按钮是否关闭对话
function GetButtonEventInfo(tableData, callback)

    local ret
    local functionEventMgr = MgrMgr:GetMgr("SystemFunctionEventMgr")
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local delegateMgr = MgrMgr:GetMgr("DelegateModuleMgr")
    local id = tableData.Id
    local buttonName = tableData.Title
    local functionName = MgrMgr:GetMgr("SystemFunctionEventMgr").GetFunctionName(tableData)
    local isCloseOnClick = not table.ro_contains(keepTalkFunction, functionName)
    local selectType = MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE.FUNC
    if not functionEventMgr.NpcJudgeSystemFunctionEvent(id, 2) then
        return nil
    end
    --按策划需求，这里判断的是父职业的ID是否与配置的一样，如果后续该需求@陈倪
    local professionLimit = Common.Functions.VectorToTable(tableData.ProfessionLimit)
    if #professionLimit ~= 0 and math.floor(professionLimit[1] / 1000) ~= math.floor(MPlayerInfo.ProfessionId / 1000) then
        return nil
    end

    if openSystemMgr.IsSystemOpen(id) and delegateMgr.IsDelegateOpen(id) then
        local method = function(param)
            functionEventMgr.GetSystemFunctionEvent(id)(param)
            if callback ~= nil then
                callback(param)
            end
        end
        if method ~= nil then
            ret = { buttonName = buttonName, method = method, isCloseOnClick = isCloseOnClick, selectType = selectType }
        end
    else
        if openSystemMgr.IsCanPreview(id) then
            local method = function()
                local h = openSystemMgr.GetOpenSystemTipsInfo(id)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(h)
            end
            ret = { buttonName = buttonName, method = method, isCloseOnClick = isCloseOnClick, selectType = selectType }
        end
    end
    return ret
end

function FocusToNpcByFuncId(funcId)
    local l_npcData
    local l_npcData = Common.CommonUIFunc.GetNpcIdTbByFuncId(funcId)
    if not l_npcData then
        logError("获取npcid失败")
        return
    end

    -- Focus对应npc，相对于对话框需要左移一点，旋转一点
    -- MPlayerInfo:FocusToNpc(self.npcID, 1, 4, 135, 5)
    local l_npcId = nil
    for i, v in ipairs(l_npcData) do
        local l_npcEntity = MNpcMgr:FindNpcInViewport(v)
        if l_npcEntity ~= nil then
            local l_rightVec = l_npcEntity.Model.Rotation * Vector3.right
            local l_temp2 = -0.2
            l_npcId = v
            MPlayerInfo:FocusToOrnamentBarter(l_npcId, l_rightVec.x * l_temp2, 1, l_rightVec.z * l_temp2, 4, 10, 5)
            break
        end
    end
    if not l_npcId then
        logError(StringEx.Format("找不到场景中的npc npcID:{0}", self.npcID))
        return
    end
    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end
end

return NpcFuncMgr