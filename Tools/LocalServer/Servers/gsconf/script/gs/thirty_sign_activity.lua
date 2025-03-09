declareGlobal("ThirtySignActivity",{})
require("role_script_manager")
require("Table/MouthAttendanceTable")

ThirtySignActivity.SystemId = 11202
ThirtySignActivity.RefreshType = 2 --每天5点刷新
ThirtySignActivity.EndDay = 30 --签到最后一天

function ThirtySignActivity.NotifyClient(role_script_info)
    local thirty_sign_info = role_script_info.thirty_sign_info
    local notify = PtcG2C_ThirtySignActivityUpdateNotify:new_local()
    notify.m_Data:set_cur_reward(thirty_sign_info.cur_reward)
    notify.m_Data:set_max_reward_index(thirty_sign_info.max_reward_index)
    notify.m_Data:set_is_end(thirty_sign_info.is_end)
    role_script_info.role:Send(tolua.cast(notify, "CProtocol"))
end

function ThirtySignActivity.CheckInfo(thirty_sign_info)
    if thirty_sign_info.cur_reward > ThirtySignActivity.EndDay or thirty_sign_info.cur_reward < 0 then
        return false
    end
    if thirty_sign_info.cur_reward >=  thirty_sign_info.max_reward_index then
        local now_time = GameTime.GetTime()
        if GameTime.IsTimeNeedRefresh(ThirtySignActivity.RefreshType, thirty_sign_info.last_refresh_time, now_time) then
            if thirty_sign_info.max_reward_index >= ThirtySignActivity.EndDay and thirty_sign_info.is_end == false then
               thirty_sign_info.is_end = true
               thirty_sign_info.last_refresh_time = now_time
               thirty_sign_info.is_modify = true
               return true
            end
            if thirty_sign_info.cur_reward == thirty_sign_info.max_reward_index and thirty_sign_info.max_reward_index < ThirtySignActivity.EndDay then
               thirty_sign_info.max_reward_index = thirty_sign_info.max_reward_index + 1
            end
            thirty_sign_info.last_refresh_time = now_time
            thirty_sign_info.is_modify = true
            return true
        end
    end
    return false
end

function ThirtySignActivity.Load(role_all_info, role_script_info)
    local thirty_sign_info = role_script_info.thirty_sign_info
    local pb_thirty_sign_info = role_all_info:thirty_sign_info()
    thirty_sign_info.cur_reward = pb_thirty_sign_info:cur_reward()
    thirty_sign_info.max_reward_index = pb_thirty_sign_info:max_reward_index()
    thirty_sign_info.last_refresh_time = pb_thirty_sign_info:last_refresh_time()
    thirty_sign_info.is_end = pb_thirty_sign_info:is_end()
    return true
end

function ThirtySignActivity.SaveToPb(pb_thirty_sign_info, thirty_sign_info)
    pb_thirty_sign_info:Clear()
    pb_thirty_sign_info:set_cur_reward(thirty_sign_info.cur_reward)
    pb_thirty_sign_info:set_max_reward_index(thirty_sign_info.max_reward_index)
    pb_thirty_sign_info:set_last_refresh_time(thirty_sign_info.last_refresh_time)
    pb_thirty_sign_info:set_is_end(thirty_sign_info.is_end)
end

function ThirtySignActivity.Save(role_all_info, role_script_info, changed)
    local thirty_sign_info = role_script_info.thirty_sign_info
    if not thirty_sign_info.is_modify then
        return
    end
    thirty_sign_info.is_modify = false
    local pb_thirty_sign_info = role_all_info:mutable_thirty_sign_info()
    ThirtySignActivity.SaveToPb(pb_thirty_sign_info, thirty_sign_info)
    changed:push_back(tolua.cast(pb_thirty_sign_info, "google::protobuf::MessageLite"))
end

function ThirtySignActivity.SaveByTime(role_all_info, role_script_info, modify_time)
    if not role_script_info.role:CheckSaveModuleByTargetTime(KKSG.kRoleModuleTypeThirtySign, modify_time) then
        return
    end
    ThirtySignActivity.SaveToPb(role_all_info.mutable_thirty_sign_info(), role_script_info.thirty_sign_info)
end

function ThirtySignActivity.Refresh(role_all_info, role_script_info, mark)
    if not GameTime.IsTimeNeedRefresh(mark, ThirtySignActivity.RefreshType) then
        return
    end
    if not role_script_info.role:IsSystemOpen(ThirtySignActivity.SystemId) then
        return
    end
    local thirty_sign_info = role_script_info.thirty_sign_info
    if not ThirtySignActivity.CheckInfo(thirty_sign_info) then
        return
    end
    ThirtySignActivity.NotifyClient(role_script_info)
end

function ThirtySignActivity.GetInfo(role_script_info, arg, res)
    if not role_script_info.role:IsSystemOpen(ThirtySignActivity.SystemId) then
        res:set_error_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    local thirty_sign_info = role_script_info.thirty_sign_info
    ThirtySignActivity.CheckInfo(thirty_sign_info)
    res:set_cur_reward(thirty_sign_info.cur_reward)
    res:set_max_reward_index(thirty_sign_info.max_reward_index)
	res:set_is_end(thirty_sign_info.is_end)
    res:set_error_code(KKSG.ERR_SUCCESS)
end

function ThirtySignActivity.GetReward(role_script_info, arg, res)
    if not role_script_info.role:IsSystemOpen(ThirtySignActivity.SystemId) then
        res:set_err_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    local thirty_sign_info = role_script_info.thirty_sign_info
    ThirtySignActivity.CheckInfo(thirty_sign_info)
    if thirty_sign_info.cur_reward >= thirty_sign_info.max_reward_index then
        res:set_err_code(KKSG.ERR_THIRTY_SIGN_AWARD_ALREADY_GET)
        return
    end
    local attend_table = Table.MouthAttendanceTable.GetRowByDay(thirty_sign_info.cur_reward + 1)
    if not attend_table then
        res:set_err_code(KKSG.ERRO_GET_ROWDATA_FROM_TABLE_FAILED)
        return
    end
--读表
    local award_id = attend_table.Award
    if award_id == nil or  award_id == 0 then
        res:set_err_code(KKSG.ERR_THIRTY_SIGN_AWARD_ID_NOT_EXIST)
        return
    end
--发奖
    local award_result = AwardLogic:ZhuDongGetAward(role_script_info.role, award_id, KKSG.ITEM_REASON_THIRTY_SIGN_IN)
     res:set_err_code(award_result.error)

    if award_result.error ~= KKSG.ERR_SUCCESS then
        return
    end
    thirty_sign_info.cur_reward = thirty_sign_info.cur_reward + 1 
    thirty_sign_info.last_refresh_time = GameTime.GetTime()
    thirty_sign_info.is_modify = true
    ThirtySignActivity.NotifyClient(role_script_info)
end

table.insert(RoleScriptManager.RegisterHandlers, ThirtySignActivity)