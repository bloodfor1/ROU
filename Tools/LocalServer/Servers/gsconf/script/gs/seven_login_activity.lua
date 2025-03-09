declareGlobal("SevenLoginActivity",{})
require("role_script_manager")

SevenLoginActivity.SystemId = 11201

    -- 已修改为八日登录
function SevenLoginActivity.CheckInfo(seven_login_info)
    if seven_login_info.cur_reward >= 8 then
        return false
    end
    if seven_login_info.cur_reward ~= 0 then
        local now_time = GameTime.GetTime()
        if not GameTime.IsTimeNeedRefresh(SevenDayAward.RefreshType, seven_login_info.last_refresh_time, now_time) then
            return false
        end
    end
    seven_login_info.cur_reward = seven_login_info.cur_reward + 1
    seven_login_info.last_refresh_time = GameTime.GetTime()
    seven_login_info.is_modify = true
    return true
end

function SevenLoginActivity.Load(role_all_info, role_script_info)
    local seven_login_info = role_script_info.seven_login_info
    local pb_seven_login_info = role_all_info:seven_login_info()
    seven_login_info.cur_reward = pb_seven_login_info:cur_reward()
    for i = 1, pb_seven_login_info:reward_get_list_size() do
        seven_login_info.reward_get_list:push_back(pb_seven_login_info:reward_get_list(i - 1):value())
    end
    seven_login_info.last_refresh_time = pb_seven_login_info:last_refresh_time()
    --SevenLoginActivity.CheckInfo(seven_login_info)
    return true
end

function SevenLoginActivity.SaveToPb(pb_seven_login_info, seven_login_info)
    pb_seven_login_info:Clear()
    pb_seven_login_info:set_cur_reward(seven_login_info.cur_reward)
    for i = 1, seven_login_info.reward_get_list:size() do
        local pb_reward_get = pb_seven_login_info:add_reward_get_list()
        pb_reward_get:set_value(seven_login_info.reward_get_list[i - 1])
    end
    pb_seven_login_info:set_last_refresh_time(seven_login_info.last_refresh_time)
end

function SevenLoginActivity.Save(role_all_info, role_script_info, changed)
    local seven_login_info = role_script_info.seven_login_info
    if not seven_login_info.is_modify then
        return
    end
    seven_login_info.is_modify = false
    local pb_seven_login_info = role_all_info:mutable_seven_login_info()
    SevenLoginActivity.SaveToPb(pb_seven_login_info, seven_login_info)
    changed:push_back(tolua.cast(pb_seven_login_info, "google::protobuf::MessageLite"))
end

function SevenLoginActivity.SaveByTime(role_all_info, role_script_info, modify_time)
    if not role_script_info.role:CheckSaveModuleByTargetTime(KKSG.kRoleModuleTypeSevenLogin, modify_time) then
        return
    end
    SevenLoginActivity.SaveToPb(role_all_info.mutable_seven_login_info(), role_script_info.seven_login_info)
end

function SevenLoginActivity.Refresh(role_all_info, role_script_info, mark)
    if not GameTime.IsTimeNeedRefresh(mark, SevenDayAward.RefreshType) then
        return
    end
    if not role_script_info.role:IsSystemOpen(SevenLoginActivity.SystemId) then
        return
    end
    local seven_login_info = role_script_info.seven_login_info
    if not SevenLoginActivity.CheckInfo(seven_login_info) then
        return
    end
    local notify = PtcG2C_SevenLoginActivityUpdateNotify:new_local()
    notify.m_Data:set_cur_reward(seven_login_info.cur_reward)
    role_script_info.role:Send(tolua.cast(notify, "CProtocol"))
end

function SevenLoginActivity.GetInfo(role_script_info, arg, res)
    if not role_script_info.role:IsSystemOpen(SevenLoginActivity.SystemId) then
        res:set_error_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    local seven_login_info = role_script_info.seven_login_info
    SevenLoginActivity.CheckInfo(seven_login_info)
    res:set_cur_reward(seven_login_info.cur_reward)
    for i = 1, seven_login_info.reward_get_list:size() do
        local pb_reward_get = res:add_reward_get_list()
        pb_reward_get:set_value(seven_login_info.reward_get_list[i - 1])
    end
    res:set_error_code(KKSG.ERR_SUCCESS)
end

function SevenLoginActivity.GetReward(role_script_info, arg, res)
    if not role_script_info.role:IsSystemOpen(SevenLoginActivity.SystemId) then
        res:set_error_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    local seven_login_info = role_script_info.seven_login_info
    SevenLoginActivity.CheckInfo(seven_login_info)
    local id = arg:id()
    if id <= 0 or id > seven_login_info.cur_reward then
        res:set_error_code(KKSG.ERR_SEVEN_LOGIN_REWARD_NOT_EXIST)
        return
    end
    for i = 1, seven_login_info.reward_get_list:size() do
        if id == seven_login_info.reward_get_list[i - 1] then
            res:set_error_code(KKSG.ERR_SEVEN_LOGIN_REWARD_IS_GET)
            return
        end
    end
    local reward = SevenDayAward.GetAwardConfigByDay(id)
    if not reward then
        res:set_error_code(KKSG.ERR_UNKNOWN)
        return
    end
    local reward_item = ItemDesc:new_local()
    reward_item.item_id = reward.itemID
    reward_item.item_count = reward.itemCount
    reward_item.bind_option_for_give = kItemBindIs
    if reward.itemBind == 0 then
        reward_item.bind_option_for_give = kItemBindNo
    end
    local error_code = ItemTransition:GiveItem(role_script_info.role, reward_item, KKSG.ITEM_REASON_SEVEN_LOGIN_REWARD)
    if error_code ~= KKSG.ERR_SUCCESS then
        return
    end
    seven_login_info.reward_get_list:push_back(id)
    seven_login_info.is_modify = true
    res:set_error_code(KKSG.ERR_SUCCESS)
end

table.insert(RoleScriptManager.RegisterHandlers, SevenLoginActivity)