module("ModuleMgr.SkillDestroyEquipMgr", package.seeall)

SkillDestroyEquipDatas = {}

local _destroyImage = {
    [1] = "UI_CommonIcon_posundewuqi.png",
    [2] = "UI_CommonIcon_posundedunpai.png",
    [3] = "UI_CommonIcon_kaijia.png",
    [4] = "UI_CommonIcon_posundepifeng.png",
    [5] = "UI_CommonIcon_posundexuezi.png",
    [6] = "UI_CommonIcon_posundejiezhi.png",
    [7] = "UI_CommonIcon_posundemaozi.png",
}

--收到装备破坏的事件
function OnSkillDestroyEquipEvent(_, serverEnum, isDestroy, currentTime, totalTime)
    --logGreen("OnSkillDestroyEquipEvent:",serverEnum," isDestroy:",isDestroy," currentTime:",currentTime," totalTime:",totalTime)
    --currentTime=10
    --totalTime=20
    local l_data = {}
    l_data.IsDestroy = isDestroy
    l_data.CurrentTime = currentTime
    l_data.TotalTime = totalTime
    l_data.ReceiveTime = MLuaClientHelper.GetNowTicks()
    SkillDestroyEquipDatas[serverEnum] = l_data

end

--取总时间
function GetTotalTimeWithServerEnum(serverEnum)
    if SkillDestroyEquipDatas[serverEnum] == nil then
        return 0
    end
    return SkillDestroyEquipDatas[serverEnum].TotalTime
end

--取当前时间
function GetCurrentTimeWithServerEnum(serverEnum)
    if SkillDestroyEquipDatas[serverEnum] == nil then
        return 0
    end
    local l_receiveTime = SkillDestroyEquipDatas[serverEnum].ReceiveTime
    local l_nowTime = MLuaClientHelper.GetNowTicks()

    local l_useTime = (l_nowTime - l_receiveTime) / 10000000

    local l_time = MLuaCommonHelper.Float(l_useTime)

    return SkillDestroyEquipDatas[serverEnum].CurrentTime - l_time
end

--是否损坏
function IsDestroyWithServerEnum(serverEnum)
    if SkillDestroyEquipDatas[serverEnum] == nil then
        return false
    end
    return SkillDestroyEquipDatas[serverEnum].IsDestroy
end

---@param itemData ItemData
function IsDestroyWithPropInfo(itemData)
    local l_serverEnum = MgrMgr:GetMgr("BodyEquipMgr").GetEquipServerEnumWithPropInfo(itemData)
    ---@type ItemData
    local l_equipPropInfo = MgrMgr:GetMgr("BodyEquipMgr").GetBodyEquipWithServerEnum(l_serverEnum)
    if l_equipPropInfo == nil then
        return false
    end

    if l_equipPropInfo.UID ~= itemData.UID then
        return false
    end

    return IsDestroyWithServerEnum(l_serverEnum)

end

function GetDestroyImageNameWithServerEnum(serverEnum)
    local l_equipPart = MgrMgr:GetMgr("BodyEquipMgr").GetEquipPartWithServerEnum(serverEnum)
    return GetDestroyImageNameWithEquipPart(l_equipPart)

end

function GetDestroyImageNameWithEquipPart(equipPart)
    local l_name = _destroyImage[equipPart]
    if l_name == nil then
        l_name = _destroyImage[1]
    end
    return l_name

end

function OnLogout()
    SkillDestroyEquipDatas = {}
end

return ModuleMgr.SkillDestroyEquipMgr
