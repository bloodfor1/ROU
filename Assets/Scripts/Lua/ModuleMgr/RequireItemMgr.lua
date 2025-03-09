module("ModuleMgr.RequireItemMgr", package.seeall)

function GetRequireItems(requireType)
    local l_RequireItems = {}

    local l_catData = MgrMgr:GetMgr("CatCaravanMgr").GetNeedItemTable()
    for i = 1, #l_catData do
        AddRequireItems(l_RequireItems, l_catData[i].ID, l_catData[i].Count)
    end

    local l_taskData = MgrMgr:GetMgr("TaskMgr").GetTaskItemInfo()
    for i = 1, #l_taskData do
        AddRequireItems(l_RequireItems, l_taskData[i].ID, l_taskData[i].Count)
    end
    return l_RequireItems
end
function AddRequireItems(table, id, count)
    if count <= 0 then
        return false
    end
    for i = 1, #table do
        if table[i].ID == id then
            table[i].Count = table[i].Count + count
            return true
        end
    end
    table[#table + 1] = {
        ID = id,
        Count = count,
    }
    return true
end

function GetNeedItemCountByID(ID)
    local l_catData = MgrMgr:GetMgr("CatCaravanMgr").GetNeedItemTable()
    local l_taskData = MgrMgr:GetMgr("TaskMgr").GetTaskItemInfo()
    local needCount = 0
    if l_catData[ID] then
        needCount = needCount + l_catData[ID]
    end
    if l_taskData[ID] then
        needCount = needCount + l_taskData[ID]
    end
    return needCount
end
