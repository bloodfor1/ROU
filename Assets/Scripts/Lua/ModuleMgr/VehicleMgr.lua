---@module ModuleMgr.VehicleMgr
module("ModuleMgr.VehicleMgr", package.seeall)

-- 当前装备的载具
EquipVehicleItemId = 0
EquipVehicleRow = nil

-- 当前装备战斗载具
EquipBattleVehicleItemId = 0

-- 当前搭载的载具（作为乘客时，搭载的和装备的不同）
RideVehicleItemId = 0
RideVehicleRow = nil

--红点功能使用的一个key值,是否上过坐骑
IsGetOnVehicle="IsGetOnVehicle"
IsGetOnBattleVehicle="IsGetOnBattleVehicle"

local l_lastUseRideTime=0  --上一次使用坐骑的时间

EOpenType = {
    AddOfferInfo = "AddOfferInfo",
    SetVehicleInfo = "SetVehicleInfo"
}

function OnLogout()
    EquipVehicleItemId = 0
    EquipVehicleRow = nil
    RideVehicleItemId = 0
    RideVehicleRow = nil
    EquipBattleVehicleItemId = 0
    l_lastUseRideTime=0
end

--检测确认战斗载具 技能需求是否满足
--返回值  是否达标 
--        未达标的技能提示文字
function CheckBattleVehicleSkill()
    --获取当前装备的战斗坐骑
    local l_curBattleVehicle = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.BATTLE_HORSE + 1)
    --当前没有装备战斗载具返回确认失败
    if not l_curBattleVehicle then 
        return false 
    end

    --获取条件限制表数据
    local l_row = TableUtil.GetCartRemouldTable().GetRowByCartID(l_curBattleVehicle.TID)
    --没有限制数据直接返回成功
    if not l_row then
        return true
    end

    --技能等级是否满足判断
    local l_result = true
    local l_tipStr = ""
    for i = 0, l_row.UnlockSkillID.Count - 1 do
        --多条件间隔符添加
        if i > 0 then l_tipStr = l_tipStr .. " " end
        --获取指定技能等级 和 指定技能需求等级
        local l_limitSkillId = l_row.UnlockSkillID[i][0]
        local l_skillLv = MPlayerInfo:GetCurrentSkillInfo(l_limitSkillId).lv
        local l_limitSkillLv = l_row.UnlockSkillID[i][1]
        --如果不达标则获取对应技能名拼接提示文字
        if l_skillLv < l_limitSkillLv then
            l_result = false
            local l_skillConfig = TableUtil.GetSkillTable().GetRowById(l_limitSkillId)
            local l_skillName = l_skillConfig and l_skillConfig.Name or ""
            local l_limitStr = StringEx.Format(Lang("SKILLLEARNING_NEED_PRESKILL"), l_skillName, l_limitSkillLv)
            l_tipStr = l_tipStr .. l_limitStr
        end
    end
    return l_result, l_tipStr
end

function EquipBattleVehicle(itemId)
    EquipBattleVehicleItemId = itemId
end

-- 装备了一个在载具
function EquipVehicle(itemId)
    local player = MEntityMgr.PlayerEntity
    if player and player.VehicleComp then
        player.VehicleComp.VehicleID=itemId
    end

    local isEquip
    local isBattleVehicle
    -- table
    if itemId ~= 0 then
        EquipVehicleRow = TableUtil.GetVehicleTable().GetRowByID(itemId)
        EquipVehicleItemId = itemId
        isEquip=true
    else
        EquipVehicleRow = nil
        isEquip=false
    end
    
    --以下处理第一次装备的红点
    local l_row=TableUtil.GetEquipTable().GetRowById(itemId,true)
    isBattleVehicle = l_row and l_row.EquipId == EquipPos.BATTLE_HORSE

    local isGetOn=PlayerPrefs.GetInt(Common.Functions.GetPlayerPrefsKey(IsGetOnVehicle),0)
    if isGetOn==0 then
        MgrMgr:GetMgr("WeakGuideMgr").ShowRedSign(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.Vehicle,isEquip and not isBattleVehicle)
    end

    local isGetOnBattle=PlayerPrefs.GetInt(Common.Functions.GetPlayerPrefsKey(IsGetOnBattleVehicle),0)
    if isGetOnBattle==0 then
        MgrMgr:GetMgr("WeakGuideMgr").ShowRedSign(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.BattleVehicle,isEquip and isBattleVehicle)
    end
end

-- 给C#调用，放技能前下载具
function RequestUnRideVehicle()
    RequestTakeVehicle(false)
end

-- C#和lua调用，隐藏或展示自动战斗和技能面板
function RefreshMainUI(isRide)
    -- 自动战斗按钮
    local main_ui = UIMgr:GetUI(UI.CtrlNames.Main)
    if main_ui ~= nil then
        main_ui:CheckSpecialState()
    end
    -- 技能面板
    --MUIManager:RefreshSkillUI()
    MgrMgr:GetMgr("SkillControllerMgr").RefreshSkillUI()
    MgrMgr:GetMgr("MainUIMgr").ShowSkill(true)
end

-- 搭载装备的载具
function RideVehicle()
    local player = MEntityMgr.PlayerEntity
    local isRide = player and player.IsRideVehicle or false
    local isFly = player and player.IsFly or false
    local itemId = 0

    if isFly then
        MgrMgr:GetMgr("FightAutoMgr").CloseFightAuto()
    end

    if player ~= nil and player.IsRideVehicle then
        itemId = player.VehicleCtrlComp.VehicleID
    end
    
    -- table
    RideVehicleItemId = itemId
    if itemId ~= 0 then
        RideVehicleRow = TableUtil.GetVehicleTable().GetRowByID(itemId)
    else
        RideVehicleRow = nil
    end

    -- ui
    local l_ui = UIMgr:GetUI(UI.CtrlNames.Vehicle)
    if l_ui ~= nil then
        l_ui:RefreshVehicle()
    end
    -- 刷新主界面UI
    RefreshMainUI(isRide)
end

-- 作为乘客，搭载别人的载具
function PassangerRideVehicle()
    local player = MEntityMgr.PlayerEntity
    local itemId = 0
    if player ~= nil and player.IsRideVehicle then
        itemId = player.VehicleCtrlComp.VehicleID
    end
    -- table
    RideVehicleItemId = itemId
    if itemId ~= 0 then
        RideVehicleRow = TableUtil.GetVehicleTable().GetRowByID(itemId)
    else
        RideVehicleRow = nil
    end
    -- ui
    local l_ui = nil
    if UIMgr:IsActiveUI(UI.CtrlNames.Vehicle) then
        l_ui = UIMgr:GetUI(UI.CtrlNames.Vehicle)
    end
    if l_ui ~= nil then
        l_ui:RefreshVehicle()
    end
    -- 刷新主界面UI
    RefreshMainUI(true)
end
function OnSelectRoleNtf(info)
    local vehicleData = info.vehicle
    if vehicleData == nil then
        return
    end
    if tostring(vehicleData.driver_uuid) == tostring(MPlayerInfo.UID) and vehicleData.is_get_on then
        MPlayerInfo.VehicleItemID = vehicleData.vehicle_id
    end
end
function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data 
    if not rawget(l_roleAllInfo, "vehicle") then
        return
    end
    local info = l_roleAllInfo.vehicle
    OnSelectRoleNtf(l_roleAllInfo)
    local player = MEntityMgr.PlayerEntity
    if player.IsRideVehicle then
        player.VehicleComp:UnRideVehicle()
    end
    if info.is_get_on then
        if tostring(info.driver_uuid) == tostring(MPlayerInfo.UID) then
            local l_vehicleData = MgrMgr:GetMgr("VehicleInfoMgr").TryGetValidVehicle(MPlayerInfo.VehicleItemID)
            if l_vehicleData~=nil then
                player.VehicleComp:DriverRide(MPlayerInfo.VehicleItemID,l_vehicleData.ornamentIds.cur_equip,l_vehicleData.dyeIds.cur_equip)
            end
        elseif tostring(info.passenger_uuid) == tostring(MPlayerInfo.UID) then
            local driver = MEntityMgr:GetEntity(info.driver_uuid)
            if driver ~= nil then
                player.VehicleComp:PassengerRide(driver, info.vehicle_id)
            end
        end
    end
end


--在使用传送类道具的时候添加提示 主要是苍蝇和蝴蝶翅膀
function VehicleUseItemCheck(PropID)
    local l_playerEntity = MEntityMgr.PlayerEntity
    -- if l_playerEntity and l_playerEntity.IsRideVehicle then
    --     if PropID == MgrMgr:GetMgr("PropMgr").ButterflyWingsID or PropID == MgrMgr:GetMgr("PropMgr").FliesWingsID then
    --         MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILL_IN_BATTLE_VEHICLE"))
    --         return true
    --     end
    -- end
    if PropID == MgrMgr:GetMgr("PropMgr").FliesWingsID then
        if l_playerEntity and (l_playerEntity.IsRideAnyVehicle) and (l_playerEntity.VehicleCtrlComp) and (l_playerEntity.VehicleCtrlComp.VehicleID) then
            local vehicleRow = TableUtil.GetVehicleTable().GetRowByID(l_playerEntity.VehicleCtrlComp.VehicleID)
            local rowNum = vehicleRow and vehicleRow.Num or 1
            if rowNum > 1 and l_playerEntity.VehicleCtrlComp.SeatNumLeft <= 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CAN_NOT_USE_FLYING"))
                return true
            end
        end
    end
    return false
end

-- 上自己装备的载具
-- 参数1 上载具 还是下载具
-- 参数2 是否是战斗载具 
function RequestTakeVehicle(_is_get_on,isBattleVehicle)
    if _is_get_on then
        RideVehicel(isBattleVehicle)
    else
        UnRideVehicel(isBattleVehicle)
    end
end

function RideVehicel(isBattleVehicle)
    local player = MEntityMgr.PlayerEntity
    --战斗载具技能需求判定 上战斗坐骑前做技能是否满足判断 下坐骑不拦
    if isBattleVehicle then 
        local l_isCheck, l_tip = CheckBattleVehicleSkill()
        if not l_isCheck then
            if l_tip then MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tip) end
            return
        end
    end
    --互斥判定
    if not VehicleStateExclusion(true,isBattleVehicle) then return end

    if not CheckUseVehicleCD() then return end

    player:WaitServer()
    if isBattleVehicle then    
        local l_msgId = Network.Define.Rpc.TakeBattleVehicle
        ---@type TakeBattleVehicleArg
        local l_req = GetProtoBufSendTable("TakeBattleVehicleArg")
        l_req.is_get_on = true
        l_req.cur_status = TakeVehicleType.Manual:ToInt()
        Network.Handler.SendRpc(l_msgId, l_req)
    else
        local l_msgId = Network.Define.Rpc.TakeVehicle
        ---@type TakeVehicleArg
        local l_req = GetProtoBufSendTable("TakeVehicleArg")
        l_req.is_get_on = true
        l_req.cur_status = TakeVehicleType.Manual:ToInt()
        Network.Handler.SendRpc(l_msgId, l_req)
    end
    
end

function UnRideVehicel(isBattleVehicle)
    local player = MEntityMgr.PlayerEntity
    player:WaitServer()
    --当前骑乘战斗坐骑 那么下战斗坐骑载具
    if isBattleVehicle then
        local l_msgId = Network.Define.Rpc.TakeBattleVehicle
        ---@type TakeBattleVehicleArg
        local l_req = GetProtoBufSendTable("TakeBattleVehicleArg")
        l_req.is_get_on = false
        l_req.cur_status = TakeVehicleType.Manual:ToInt()
        Network.Handler.SendRpc(l_msgId, l_req)
    else
        local l_msgId = Network.Define.Rpc.TakeVehicle
        ---@type TakeVehicleArg
        local l_req = GetProtoBufSendTable("TakeVehicleArg")
        l_req.is_get_on = false
        l_req.cur_status = TakeVehicleType.Manual:ToInt()
        Network.Handler.SendRpc(l_msgId, l_req)
    end
    
end

--响应骑乘载具
function OnTakeVehicle(msg)
    local player = MEntityMgr.PlayerEntity
    player:ServerCallBack()
    ---@type TakeVehicleRes
    local l_info = ParseProtoBufToTable("TakeVehicleRes", msg)
    if l_info.result ~= 0 then
        if l_info.cur_status==TakeVehicleType.NavAuto then
            if l_info.result==ErrorCode.ERR_VEHICLE_CANNOT_USE_VEHICLE then
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
    end
    -- 具体搭乘逻辑在收到SyncUnit广播后处理
end

--响应骑乘战斗载具
function OnTakeBattleVehicle(msg)
    local player = MEntityMgr.PlayerEntity
    player:ServerCallBack()
    ---@type TakeVehicleRes
    local l_info = ParseProtoBufToTable("TakeVehicleRes", msg)
    if l_info.result ~= 0 then
        if l_info.cur_status == TakeVehicleType.NavAuto then
            if l_info.result==ErrorCode.ERR_VEHICLE_CANNOT_USE_VEHICLE then
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
            end
        else
            if l_info.result==ErrorCode.ERR_VEHICLE_NOT_EQUIP then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CANT_RIDE_BATTLEVEHICLE"))
            else
                --状态互斥会处理提示的Log不要显示出来
                if l_info.result==ErrorCode.ERR_IS_IN_SINGLE_GROUND_VEHICLE or
                    l_info.result==ErrorCode.ERR_IS_IN_SINGLE_FLY_VEHICLE or
                    l_info.result==ErrorCode.ERR_IS_IN_COUPLE_GROUND_VEHICLE or
                    l_info.result==ErrorCode.ERR_IS_IN_COUPLE_FLY_VEHICLE or
                    l_info.result==ErrorCode.ERR_IS_IN_PHOTO or
                    l_info.result==ErrorCode.ERR_IS_IN_NPC_INTERACTIVE or
                    l_info.result==ErrorCode.ERR_IS_IN_PLAYER_INTERACTIVE then
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
                end
            end
        end
    end
    -- 具体搭乘逻辑在收到SyncUnit广播后处理
end

-- 请求搭载别人的载具，或邀请别人搭载自己的载具
function RequestAskTakeVehicle(_driver_uuid, _passenger_uuid,playerName)
    local l_msgId = Network.Define.Rpc.AskTakeVehicle
    ---@type AskTakeVehicleArg
    local l_req = GetProtoBufSendTable("AskTakeVehicleArg")
    l_req.data.driver_uuid = _driver_uuid
    l_req.data.passenger_uuid = _passenger_uuid
    Network.Handler.SendRpc(l_msgId, l_req,playerName)
end

function OnAskTakeVehicle(msg,arg,customData)
    ---@type AskTakeVehicleRes
    local l_info = ParseProtoBufToTable("AskTakeVehicleRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SEND_VEHICLE_INVITE_SUCCESS",customData))
    end
    -- 之后对方会收到AskTakeVehicleNotify的通知
    -- 对方如果不同意，不会有后续。对方如果同意，会发送GetOnVehicleAgree
    -- 然后自己会在SyncUnit收到上车通知
end

-- 同意别人的邀请，或同意别人的请求
function RequestGetOnVehicleAgree(_driver_uuid, _passenger_uuid)
    local l_msgId = Network.Define.Rpc.GetOnVehicleAgree
    ---@type GetOnVehicleAgreeArg
    local l_req = GetProtoBufSendTable("GetOnVehicleAgreeArg")
    l_req.data.driver_uuid = _driver_uuid
    l_req.data.passenger_uuid = _passenger_uuid
    Network.Handler.SendRpc(l_msgId, l_req)
end

function OnGetOnVehicleAgree(msg)
    ---@type GetOnVehicleAgreeRes
    local l_info = ParseProtoBufToTable("GetOnVehicleAgreeRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    --上车切换到主界面
    game:ShowMainPanel({UI.CtrlNames.SpecialTips, UI.CtrlNames.TipsDlg})
    -- 同意上别人的车，或同意别人上车
    -- 具体搭乘逻辑在收到SyncUnit广播后处理
end

-- 加速
function RequestAccelerateVehicle()
    local l_msgId = Network.Define.Rpc.AccelerateVehicle
    ---@type AccelerateVehicleArg
    local l_req = GetProtoBufSendTable("AccelerateVehicleArg")
    Network.Handler.SendRpc(l_msgId, l_req)
end

function OnAccelerateVehicle(msg)
    ---@type AccelerateVehicleRes
    local l_info = ParseProtoBufToTable("AccelerateVehicleRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    -- ui
    local l_ui = nil
    if UIMgr:IsActiveUI(UI.CtrlNames.Vehicle) then
        l_ui = UIMgr:GetUI(UI.CtrlNames.Vehicle)
    end
    if l_ui ~= nil and RideVehicleRow ~= nil then
        l_ui:OnAccelerateVehicle()
    end
end

-- 被邀请或被请求的通知
function OnAskTakeVehicleNotify(msg)
    ---@type DriverPassenger
    local l_info = ParseProtoBufToTable("DriverPassenger", msg)
    local driver_uuid = l_info.driver_uuid
    local passenger_uuid = l_info.passenger_uuid
    local player = MEntityMgr.PlayerEntity
    if MLuaCommonHelper.IsNull(player) then
        return
    end
    --local player_uuid = tostring(player.UID)
    if player.UID == driver_uuid then
        local l_openData = {
            openType = MgrMgr:GetMgr("VehicleMgr").EOpenType.SetVehicleInfo,
            driverUid = driver_uuid,
            passengerUid = passenger_uuid,
            isDriver = true
        }
        UIMgr:ActiveUI(UI.CtrlNames.VehicleOffer, l_openData)
    elseif player.UID == passenger_uuid then
        local l_openData = {
            openType = MgrMgr:GetMgr("VehicleMgr").EOpenType.SetVehicleInfo,
            driverUid = driver_uuid,
            passengerUid = passenger_uuid,
            isDriver = false
        }
        UIMgr:ActiveUI(UI.CtrlNames.VehicleOffer, l_openData)
    else
        logError("AskTakeVehicleNotify uuid error, driver: " ..tostring(driver_uuid) .. " passenger: " ..tostring(passenger_uuid))
    end
end

-- 上公共载具
function RequestRideCommonVehicle(id)
    local l_msgId = Network.Define.Rpc.RideCommonVehicle
    ---@type RideCommonVehicleArg
    local l_req = GetProtoBufSendTable("RideCommonVehicleArg")
    l_req.vehicle_id = id
    Network.Handler.SendRpc(l_msgId, l_req)
end

function OnRideCommonVehicle(msg)
    ---@type RideCommonVehicleRes
    local l_info = ParseProtoBufToTable("RideCommonVehicleRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end
-- proto end

--检测骑乘CD
function CheckUseVehicleCD()
    local l_vehicleCD= MgrMgr:GetMgr("VehicleInfoMgr").GetVehicleCD()
    local l_currentTimeStamp= Common.TimeMgr.GetNowTimestamp()
    if l_currentTimeStamp-l_lastUseRideTime<l_vehicleCD then
        local l_remainTime=l_vehicleCD-l_currentTimeStamp+l_lastUseRideTime
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("VEHICLE_CD_TIPS"),l_remainTime))
        return false
    end
    l_lastUseRideTime=l_currentTimeStamp
    return true
end
--状态互斥
function VehicleStateExclusion(isShowTips,isBattle)
    local result = CheckIsFlyVecicle(isBattle)
    if result.ground then
        --状态互斥 地面载具
        return StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_B_GroundVehicle,isShowTips)
    elseif result.fight then
        --状态互斥 战斗载具
        return StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_Q_RidingFight,isShowTips)
    elseif result.fly then
        --状态互斥 飞行载具
        return StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_C_FlyVehicle,isShowTips)
    elseif result.coupleground then
        --状态互斥 多人地面载具
        return StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_V_CoupleGroundVehicle,isShowTips)
    elseif result.couplefly then
        --状态互斥 多人飞行载具
        return StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_W_CoupleFlyVehicle,isShowTips)
    end
    return true
end

function CheckIsFlyVecicle(isBattle)

    local result =
    {
        none = false,
        ground = false,         --地面载具
        coupleground = false,   --双人地面载具
        fly = false,            --飞行载具
        couplefly = false,      --双人飞行载具
        fight = false,          --战斗载具
    }

    --获取当前装备的战斗坐骑
    local l_curBattleVehicle = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.BATTLE_HORSE + 1)
    local vehicleItemId = 0 
    if isBattle then
        vehicleItemId = l_curBattleVehicle and l_curBattleVehicle.TID or 0
    else
        vehicleItemId = MPlayerInfo.VehicleItemID
    end
    
    if vehicleItemId ~= 0 then
        local EquipVehicleRow = TableUtil.GetVehicleTable().GetRowByID(vehicleItemId)
        local EquipData = TableUtil.GetEquipTable().GetRowById(vehicleItemId,true)
        if EquipData ~= nil and EquipData.WeaponId == 1 then
            result.fight = true
            return result
        end

        if EquipVehicleRow ~= nil and EquipVehicleRow.VehicleType == 1 then
            if EquipVehicleRow.Num == 1 then
                result.fly = true
            else
                result.couplefly = true
            end
            return result
        else
            if EquipVehicleRow.Num == 1 then
                result.ground = true
            else
                result.coupleground = true
            end
            return result
        end
    end
    result.none = true
    return result
end

return VehicleMgr