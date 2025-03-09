
module("ModuleMgr.TaskGuideNpcMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

local l_cachedSearchInfo
local l_cachedTodoCommandInfo = {}

local l_takedState

function OnInit()

    GlobalEventBus:Add(EventConst.Names.TaskStatusUpdate, OnTaskStatusUpdate)
end

function OnUnInit()

    GlobalEventBus:Remove(EventConst.Names.TaskStatusUpdate, OnTaskStatusUpdate)
end

function OnSelectRoleNtf()

end

local function _initCacheInfo()
    l_cachedSearchInfo = {}

    l_takedState = MgrMgr:GetMgr("TaskMgr").ETaskStatus.Taked

    local l_tableData = TableUtil.GetTaskGuideNpcTable().GetTable()
    for _, row in ipairs(l_tableData) do
        local npcId = row.NPCid
        local vectorVec = Common.Functions.VectorVectorToTable(row.NpcDate)
        for i, vec in ipairs(vectorVec) do
            if #vec < 10 then
                logError("TaskGuideNpcTable error, npcId", npcId)
            else
                local l_finalParam = tonumber(vec[2]) == l_takedState and vec[3] or 0
                local l_key = StringEx.Format("{0}_{1}_{2}", vec[1], vec[2], l_finalParam)
                if not l_cachedSearchInfo[l_key] then
                    l_cachedSearchInfo[l_key] = {}
                end
                table.insert(l_cachedSearchInfo[l_key], {
                    npcId = npcId,
                    configs = vec,
                })
            end
        end
    end
end

local function _getNpcIdByTaskStatus(taskId, taskState, taskStep)

    if not l_cachedSearchInfo then
        _initCacheInfo()
    end

    local l_finalParam = taskState == l_takedState and taskStep or 0
    local l_key = StringEx.Format("{0}_{1}_{2}", taskId, taskState, l_finalParam)
    return l_cachedSearchInfo[l_key]
end

function _doCommand(commandId, commandTag, callback)

    local l_block = CommandBlock.OpenAndRunBlock("CommandScript/NPC/" .. commandId, commandTag)
    if l_block ~= nil then
        l_block:SetCallback(function(block)
            if callback then callback() end
        end)
    end
end

function _saveCommand(commandId, commandTag, sceneId, position, face, callback)

    if not l_cachedTodoCommandInfo[sceneId] then
        l_cachedTodoCommandInfo[sceneId] = {}
    end
    table.insert(l_cachedTodoCommandInfo[sceneId], {
        commandId = commandId,
        commandTag = commandTag,
        position = position,
        face = face,
        callback = callback,
    })
end

function OnEnterScene(sceneId)
    if not l_cachedTodoCommandInfo[sceneId] then
        return
    end

    for i, v in ipairs(l_cachedTodoCommandInfo[sceneId]) do
        _doCommand(v.commandId, v.commandTag, v.callback)
    end

    l_cachedTodoCommandInfo[sceneId] = nil
end

function OnTaskInit( taskId, taskStatus, taskStep )
    -- logYellow("OnTaskInit taskId:"..taskId..",taskStatus:"..taskStatus..",step:"..taskStep)
    local l_info = _getNpcIdByTaskStatus(taskId, taskStatus, taskStep)
    if not l_info then return end
    local l_curSceneId = MScene.SceneID
    for i, v in ipairs(l_info) do
        local l_sceneId = tonumber(v.configs[6])
        local l_position = Vector3(tonumber(v.configs[7]),tonumber(v.configs[8]), tonumber(v.configs[9]))
        local l_face = tonumber(v.configs[10])
        local l_npcId = v.npcId
        MNpcMgr:UpdateLocalNpc(l_sceneId,l_npcId,l_position,l_face,taskId)
    end
end

function OnTaskStatusUpdate(taskId, taskStatus, taskStep)
    -- logRed("OnTaskStatusUpdate taskId:"..taskId..",taskStatus:"..taskStatus..",step:"..taskStep)
    local l_info = _getNpcIdByTaskStatus(taskId, taskStatus, taskStep)
    if not l_info then return end
    local l_curSceneId = MScene.SceneID
    for i, v in ipairs(l_info) do
        local l_commandId = v.configs[4]
        local l_commandTag = v.configs[5]
        local l_sceneId = tonumber(v.configs[6])
        local l_position = Vector3(tonumber(v.configs[7]),tonumber(v.configs[8]), tonumber(v.configs[9]))
        local l_face = tonumber(v.configs[10])
        local l_npcId = v.npcId
        local l_callback = function()
            MNpcMgr:UpdateLocalNpc(l_sceneId,l_npcId,l_position,l_face,taskId)
        end
        if l_sceneId ~= l_curSceneId then
            _saveCommand(l_commandId, l_commandTag, l_sceneId, l_position, l_face, l_callback)
        else
            -- logYellow("commandId:"..l_commandId..",tag:"..l_commandTag)
            _doCommand(l_commandId, l_commandTag, l_callback)
        end
    end
end



return ModuleMgr.TaskGuideNpcMgr