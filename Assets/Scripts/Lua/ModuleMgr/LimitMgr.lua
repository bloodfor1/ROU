module("ModuleMgr.LimitMgr", package.seeall)

ELimitType = {
    LEVEL_LIMIT = 0,
    ENTITY_LIMIT = 1,
    COLLECTION_LIMIT = 2,
    ACHIEVEMENT_LIMIT = 3,
    ACHIEVEMENTPOINT_LIMIT = 4,
    TASK_LIMIT = 5,
    ACHIEVEMENTLEVEL_LIMIT = 6,
    UESITEM_LIMIT = 7,
}
FashionRecord = {}
-- message: FashionRecord
function OnSelectRoleNtf(info)
    local pbFashionRecord = info.fashion.ro_fashion
    --logError("OnSelectRoleNtf pbFashionRecord.own_hairs : "..tostring(#pbFashionRecord.own_hairs))
    --logError("OnSelectRoleNtf pbFashionRecord.own_hairs : "..tostring(#pbFashionRecord.own_eyes))
    FashionRecord.own_hairs = pbFashionRecord.own_hairs
    FashionRecord.own_eyes = pbFashionRecord.own_eyes
    --if FashionRecord.own_hairs ~= nil then
    --    for i = 1,#FashionRecord.own_hairs do
    --        logError("OnSelectRoleNtf FashionRecord.own_hairs : "..tostring(FashionRecord.own_hairs[i]))
    --    end
    --    return
    --else
    --    logError("OnSelectRoleNtf FashionRecord.own_hairs : "..tostring("no"))
    --end
    --if FashionRecord.own_eyes ~= nil then
    --    for i = 1,#FashionRecord.own_eyes do
    --        logError("OnSelectRoleNtf FashionRecord.own_eyes : "..tostring(FashionRecord.own_eyes[i]))
    --    end
    --    return
    --else
    --    logError("OnSelectRoleNtf FashionRecord.own_eyes : "..tostring("no"))
    --end
end

function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    OnSelectRoleNtf(l_roleAllInfo)
end
function AddInhairs(id)
    if FashionRecord.own_hairs == nil then
        FashionRecord.own_hairs = {}
        FashionRecord.own_hairs[#FashionRecord.own_hairs + 1] = id
        return
    end
    FashionRecord.own_hairs[#FashionRecord.own_hairs + 1] = id
end
function AddInEye(id)
    if FashionRecord.own_eyes == nil then
        FashionRecord.own_eyes = {}
        FashionRecord.own_eyes[#FashionRecord.own_eyes + 1] = id
        return
    end
    FashionRecord.own_eyes[#FashionRecord.own_eyes + 1] = id
end
function CheckCollectionScoreLimit( number )
    local result = false
    if MgrProxy:GetGarderobeMgr().FashionRecord ~= nil then
        if MgrProxy:GetGarderobeMgr().FashionRecord.fashion_count >= number then
            result = true
        end
    end
    return result
end

function CheckUseItemLimitInhairs( useitem )
    if FashionRecord.own_hairs == nil then
        return false
    end
    for i = 1,#FashionRecord.own_hairs do
        if useitem == FashionRecord.own_hairs[i] then
            return true
        end
    end
    return false
end
function CheckUseItemLimitIneye( useitem )
    if FashionRecord.own_eyes == nil then
        return false
    end
    for i = 1,#FashionRecord.own_eyes do
        if useitem == FashionRecord.own_eyes[i] then
            return true
        end
    end
    return false
end

function CheckAchievementPointLimit( achievementPoint )
    local result = false
    if MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint >= achievementPoint then
        result = true
    end
    return result
end

function CheckAchievementLimit( achievementId )
    local result = false
    if MgrMgr:GetMgr("AchievementMgr").IsFinishWithId(achievementId) then
        result = true
    end
    return result
end

function CheckTaskLimit( taskId )
    local result = false
    if MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(taskId) then
        result = true
    end
    return result
end

function CheckAchievementLevelLimit( achievementLevelLimit )
    local row = TableUtil.GetAchievementBadgeTable().GetRowByLevel(achievementLevelLimit)
    local result = false
    if row ~= nil then
        if MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint >= row.Point then
            result = true
        end
    end
    return result
end

return ModuleMgr.LimitMgr