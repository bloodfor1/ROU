module("ModuleData.RoleTagData", package.seeall)

---@type RoleTagMgr
roleTagMgr = MgrMgr:GetMgr("RoleTagMgr")


--自身的标签
roleTagInfos = {}


-- 初始化
function Init( ... )
    ResetData()
end

-- Logout重置动态数据
function Logout( ... )
    ResetData()
end


-- 重置数据状态
function ResetData()
    -- 初始化标签数据
    roleTags = {}
    for _, labelRow in pairs(TableUtil.GetLabelTable().GetTable()) do
        roleTagInfos[labelRow.LabelId] = {
            id = labelRow.LabelId,
            tableInfo = labelRow,
            isActive = false
        }
    end
end

-- 是否是萌新玩家
function IsMengXin()
    --for _, v in pairs(roleTagInfos) do
    --    if v.isActive and v.id == 1001 then
    --        return true
    --    end
    --end
    --return false
    return true
end

-- 获取生效的标签，没有返回0
function GetActiveTagId()
    local l_tags = {}
    for _, v in pairs(roleTagInfos) do
        if v.isActive then
            table.insert(l_tags, v)
        end
    end
    table.sort(l_tags, function(a, b)
        return a.tableInfo.SortId < b.tableInfo.SortId
    end)
    if l_tags[1] then
        return l_tags[1].id
    end
    return 0
end

function GetTagInfoById(tagId)
    return roleTagInfos[tagId]
end

return ModuleData.RoleTagData