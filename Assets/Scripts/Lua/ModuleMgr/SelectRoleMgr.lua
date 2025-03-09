---@module ModuleMgr.SelectRoleMgr
module("ModuleMgr.SelectRoleMgr", package.seeall)
require "Data/Model/BagModel"

--------------------------------------------事件定义--Start----------------------------------
-- 随机名事件
ON_GET_RANDOM_NAME = "ON_GET_RANDOM_NAME"
-- Step更改
ON_SELECT_STEP_CHANGE_EVENT = "ON_SELECT_STEP_CHANGE_EVENT"
-- 通知玩家点击模型
ON_SELECT_MODEL_EVENT = "ON_SELECT_MODEL_EVENT"
-- 通知玩家点击tog
ON_SELECT_TOG_EVENT = "ON_SELECT_TOG_EVENT"
-- 更换发型
SELECT_HAIR_STYLE_EVENT = "SELECT_HAIR_STYLE_EVENT"
-- 更换美瞳
SELECT_EYE_STYLE_EVENT = "SELECT_EYE_STYLE_EVENT"
-- 清理
CLEAR_ROLE_STYLE_EVENT = "CLEAR_ROLE_STYLE_EVENT"
-- 入场动画
ON_ENTER_ANIM_EVENT = "ON_ENTER_ANIM_EVENT"
-- 晃动事件
SHAKE_EVENT = "SHAKE_EVENT"
-- 改名事件
ON_MODIFY_NAME = "ON_MODIFY_NAME"
-- 更换角色
CHANGE_ROLE = "CHANGE_ROLE"
-- 数据更新
ON_DATA_CHANGED = "ON_DATA_CHANGED"
--------------------------------------------事件定义--End----------------------------------

local onSelectRoleNotifyMgrList = {}
EventDispatcher = EventDispatcher.new()
-- 控制连续点击重复创角
local createCharWaitServerResponse = false
-- 是否在选角
local isOnSelectRole = false
local l_data
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local _isLogin=false

ForceUpdateCameraPosWhenStageEnter = false

--------------------------------------------生命周期接口--Start----------------------------------
function OnInit()
    l_data = DataMgr:GetData("SelectRoleData")
end

function OnLogout()
    _isLogin=false
    createCharWaitServerResponse = false
end

function IsLogin()
    return _isLogin
end

function OnReconnected(reconnectData)
    l_data.SetPlayerLevelByRoleAllInfo(reconnectData.role_data)
    l_data.SetPlayerExp(reconnectData.role_data)
    createCharWaitServerResponse = false
end

function OnEnterScene(sceneId)

    if isOnSelectRole then
        --选角后当进入场景时，恢复默认视角
        isOnSelectRole = false
        MEventMgr:LuaFireEvent(MEventType.MEvent_RecoverDefaultView, MScene.GameCamera, MPlayerSetting.Is3DViewMode)
    end
end

--------------------------------------------生命周期接口--End----------------------------------

--------------------------------------------协议接口--Start----------------------------------
-- 选角消息回调
function OnSelectRoleNtf(msg)
    --  选角成功之后 上传 sdk 推送token
    MgrMgr:GetMgr("SettingMgr").PushMsgTokenToMs()
    MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.GameStart)
    ---@type SelectRoleNtfData
    local l_selectRoleNtfData = ParseProtoBufToTable("SelectRoleNtfData", msg)
    local l_info = l_selectRoleNtfData.roleData
    _isLogin=true
    -- 0收益处理
    handleZeroProfitTime(l_info)
    -- 追缴处理
    handleRecoverInfo(l_info)
    MgrMgr:GetMgr("KplFunctionMgr").l_reviveSceneId = l_info.brief.record_scene_id
    -- 角色信息
    l_data.SetPlayerInfo(l_info)
    MNetClient.NetLoginStep = ENetLoginStep.GameEntered

    -- 背包数据 obsolete
    Data.BagModel:OnSelectRoleNtf(l_info)

    --- 同步道具数据之前要先清空所有的缓存数据
    Data.BagDataModel:Clear()
    Data.BagDataModel:Sync(l_info)

    MgrProxy:GetCommonBroadcastMgr().OnSelectRoleNtf(l_info)
    -- 加载配置
    MPlayerSetting:LoadPlayerSetting(MPlayerInfo.UID)
    -- 逻辑通知
    handleMgrNotify(l_selectRoleNtfData)
    game:GetPayMgr():Init()
    ExtensionByQX.TimeHelper.CheckIsHaveOneDay()
    -- 更新相机深度
    MPlayerSetting:UpdateCamDefaultDisKey()
    isOnSelectRole = true
    MEventMgr:LuaFireEvent(MEventType.MEvent_RecoverDefaultView, MScene.GameCamera, MPlayerSetting.Is3DViewMode)
    MStatistics.DoStatistics(CJson.encode({
        tag = MLuaCommonHelper.Enum2Int(TagPoint.EnterGame),
        status = true,
        msg = "",
        authorize = false,
        finish = true
    }))

    EventDispatcher:Dispatch(ON_DATA_CHANGED)
    gameEventMgr.RaiseEvent(gameEventMgr.OnPlayerDataSync, l_info)
    MgrMgr:GetMgr("WorldPveMgr").OnAfterSelectRole()
    MgrMgr:GetMgr("RoleInfoMgr").OnAfterSelectRole()
end

-- 返回角色随机名
function OnGetRoleRandomName(msg)
    ---@type GetValidNameRes
    local l_resInfo = ParseProtoBufToTable("GetValidNameRes", msg)
    EventDispatcher:Dispatch(ON_GET_RANDOM_NAME, l_resInfo.name)
end

-- 修改名字
function OnModifyName(msg)
    ---@type ChangeRoleNameRes
    local l_resInfo = ParseProtoBufToTable("ChangeRoleNameRes", msg)
    local l_errorCode = l_resInfo.errcode or ErrorCode.ERR_SUCCESS
    if l_errorCode == ErrorCode.ERR_SUCCESS then
        l_data.OnModifyName(l_resInfo.newrolename)
        EventDispatcher:Dispatch(ON_MODIFY_NAME)
    elseif l_errorCode == ErrorCode.ERR_ROLE_ALREADY_CHANAGE_NAME then
        UIMgr:DeActiveUI(UI.CtrlNames.ModifyCharacterName)
    else
        local l_s = Common.Functions.GetErrorCodeStr(l_errorCode)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
    end
end

-- 其他人修改名字
function OnSomeOneNameModified(msg)
    -- body
    ---@type RoleNameChangeNtf
    local l_resInfo = ParseProtoBufToTable("RoleNameChangeNtf", msg)
    local l_entity = MEntityMgr:GetEntity(l_resInfo.roleid)
    if tostring(l_resInfo.roleid) == tostring(MPlayerInfo.UID) then
        l_entity = MEntityMgr.PlayerEntity
    end
    MEventMgr:LuaFireEvent(MEventType.MEvent_RoleName_Change, l_entity, l_resInfo.newrolename)
end

-- 选角
function RequestSelectRole()
    local l_msgId = Network.Define.Rpc.SelectRole
    ---@type SelectRoleArg
    local l_sendInfo = GetProtoBufSendTable("SelectRoleArg")
    l_sendInfo.index = l_data.RoleSelectedIndex
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    log("RequestSelectRole" .. tostring(l_sendInfo.index))
    CommonUI.Dialog.ShowWaiting(g_Globals.NETWORK_DELAYTIME)
end

-- 选角回调
function OnSelectRole(msg)
    CommonUI.Dialog.HideWaiting()
    ---@type SelectRoleRes
    local l_info = ParseProtoBufToTable("SelectRoleRes", msg)

    local l_errorCode = l_info.result or ErrorCode.ERR_SUCCESS
    if l_errorCode == ErrorCode.ERR_SUCCESS then
        --  选角成功之后 上传 sdk 推送token
        MgrMgr:GetMgr("SettingMgr").PushMsgTokenToMs()
        logGreen("SelectRole is success")
        --选角成功时将token重置，因为在选角成功后token就失效了
        game:GetAuthMgr().AuthData.ClearLoginAuthInfo()
    elseif l_errorCode == ErrorCode.ERR_ROLE_BAN then
        if l_info.ban_info ~= nil and l_info.ban_info.endtime ~= nil then
            MgrMgr:GetMgr("PlayerGameStateMgr").ShowPlayerBanInfo(l_info.ban_info, true)
        else
            logError("baninfo is nil or endtime is nil")
        end
    elseif l_errorCode == ErrorCode.ERR_ACCOUNT_NOT_EXIST then
        game:GetAuthMgr():OnEnteringGameDisconnected()
    else
        local l_s = Common.Functions.GetErrorCodeStr(l_errorCode)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
    end
end

-- 创角
function RequestCreateRoleNew(barberId, eyeId, eyeColorId)

    if createCharWaitServerResponse then
        log("RequestCreateRoleNew fail, wait last response")
        return
    end

    local l_msgId = Network.Define.Rpc.CreateRoleNew
    ---@type CreateRoleArg
    local l_sendInfo = GetProtoBufSendTable("CreateRoleArg")
    l_sendInfo.name = Lang("PLAYER_INITIAL_NAME")
    l_sendInfo.sex = l_data.SexSelected
    l_sendInfo.type = 1000
    l_sendInfo.hair_id = barberId
    l_sendInfo.eye.eye_id = eyeId
    l_sendInfo.eye.eye_style_id = eyeColorId
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, resetWaitState, resetWaitState, resetWaitState)

    CommonUI.Dialog.ShowWaiting(g_Globals.NETWORK_DELAYTIME)

    createCharWaitServerResponse = true
end

-- 创角回调
function OnCreateRoleNew(msg, sendArg)
    CommonUI.Dialog.HideWaiting()
    createCharWaitServerResponse = false
    ---@type CreateRoleRes
    local l_info = ParseProtoBufToTable("CreateRoleRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        if l_info.result == ErrorCode.ERR_NAME_EXIST then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_EXIST"))
        elseif l_info.result == ErrorCode.ERR_NAME_TOO_SHORT or l_info.result == ErrorCode.ERR_NAME_TOO_LONG then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_LENGTH"))
        elseif l_info.result == ErrorCode.ERR_INVALID_NAME then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_ILLEGAL"))
        elseif l_info.result == ErrorCode.ERR_NAME_ALLNUM then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_NUMBER"))
        elseif l_info.result == ErrorCode.ERR_CONTAIN_FORBID_WORD then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_ROLE_NAME_BLOCKWORD"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
        statisticsCreateRole(false)
    else
        MNetClient.NetLoginStep = ENetLoginStep.RoleCreated

        l_data.AddRoleData(l_info.roleData, sendArg)
        RequestSelectRole()
        statisticsCreateRole(true)
    end
end

function statisticsCreateRole(success)
    MStatistics.DoStatistics(CJson.encode({
        tag = MLuaCommonHelper.Enum2Int(TagPoint.EndCreateRole),
        status = success,
        msg = "",
        authorize = false,
        finish = false
    }))
    if success then
        MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.CharacterCreate)
    end
end

-- 返回选角
function BackToSelectRole()
    local l_curRoleIndex = l_data.RoleSelectedIndex
    logGreen("BackToSelectRole:", l_curRoleIndex)
    local l_msgId = Network.Define.Rpc.SwitchRole
    ---@type SelectRoleArg
    local l_sendInfo = GetProtoBufSendTable("SelectRoleArg")
    --复用切换角色的接口，传入合法的角色值即可
    l_sendInfo.index = l_curRoleIndex
    Network.Handler.SendRpc(l_msgId, l_sendInfo, function(info)
        l_data.UpdateCurrentRoleInfo()
        ForceUpdateCameraPosWhenStageEnter = true
        MNetClient.NetLoginStep = ENetLoginStep.GateServerLogged
        MCutSceneMgr.AllowStop = true
        EnterCreateRole(info.account_data)
    end)
end

-- 游戏内切换角色
function SwitchRoleInGame(roleIndex)
    --logError("SwitchRoleInGame:", roleIndex)
    l_data.UpdateCurrentRoleInfo()
    local l_msgId = Network.Define.Rpc.SwitchRole
    ---@type SelectRoleArg
    local l_sendInfo = GetProtoBufSendTable("SelectRoleArg")
    l_sendInfo.index = roleIndex

    Network.Handler.SendRpc(l_msgId, l_sendInfo, function(info)
        MNetClient.NetLoginStep = ENetLoginStep.GateServerLogged
        l_data.UpdateRolesAccountInfo(info.account_data)
        l_data.RoleSelectedIndex = roleIndex

        -- 选择角色
        RequestSelectRole()
        MStatistics.DoStatistics(CJson.encode({
            tag = MLuaCommonHelper.Enum2Int(TagPoint.SelectRole),
            status = true,
            msg = "",
            authorize = false,
            finish = false
        }))
    end)
end

-- 游戏内选角回调
function OnSwitchRoleInGame(msg, args, callback)
    ---@type SelectRoleRes
    local l_info = ParseProtoBufToTable("SelectRoleRes", msg)

    if l_info.result ~= 0 and l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    -- 登出
    game:GetAuthMgr():OnLogoutToGame()

    if callback then
        callback(l_info)
    end

    MEventMgr:LuaFireEvent(MEventType.MEvent_Camera_Refresh_Sky_Photo, MScene.GameCamera)
end

-- 删除角色
function DeleteRole(uid)
    local l_msgId = Network.Define.Rpc.DeleteRole
    ---@type DeleteRoleArg
    local l_sendInfo = GetProtoBufSendTable("DeleteRoleArg")
    l_sendInfo.role_uid = uid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 删除橘色回调
function OnDeleteRole(msg)
    ---@type DeleteRoleRes
    local l_info = ParseProtoBufToTable("DeleteRoleRes", msg)
    if l_info.result ~= 0 then
        logWarn("OnDeleteRole ErrorCode:" .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_data.OnDeleteRole(l_info)

    EventDispatcher:Dispatch(ON_DATA_CHANGED)
end

-- 恢复角色
function ResumeRole(uid, roleIndex)
    local l_msgId = Network.Define.Rpc.ResumeRole
    ---@type ResumeRoleArg
    local l_sendInfo = GetProtoBufSendTable("ResumeRoleArg")
    l_sendInfo.role_uid = uid
    l_sendInfo.role_index = roleIndex
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 恢复角色回调
function OnResumeRole(msg)
    ---@type ResumeRoleRes
    local l_info = ParseProtoBufToTable("ResumeRoleRes", msg)
    if l_info.result ~= 0 then
        logWarn("OnResumeRole ErrorCode:" .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_data.OnResumeRole(l_info)

    EventDispatcher:Dispatch(ON_DATA_CHANGED)
end

-- 获取账号信息
function GetAccountRoleData()

    local l_msgId = Network.Define.Rpc.GetAccountRoleData
    ---@type GetAccountRoleDataArg
    local l_sendInfo = GetProtoBufSendTable("GetAccountRoleDataArg")
    l_sendInfo.account = tostring(MPlayerInfo.SessionId)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 账号信息回调
function OnGetAccountRoleData(msg)
    ---@type GetAccountRoleDataRes
    local l_info = ParseProtoBufToTable("GetAccountRoleDataRes", msg)
    if l_info.result ~= 0 then
        logWarn("OnGetAccountRoleData ErrorCode:" .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_data.OnGetAccountRoleData(l_info)
    EventDispatcher:Dispatch(ON_DATA_CHANGED)
end

--------------------------------------------协议接口--End----------------------------------

--------------------------------------------事件广播--Start----------------------------------
-- 选角、创角状态切换
function SelectStepChangeEvent(step)

    EventDispatcher:Dispatch(ON_SELECT_STEP_CHANGE_EVENT, step)
end

-- 选中模型
function SelectModelEvent(male)

    EventDispatcher:Dispatch(ON_SELECT_MODEL_EVENT, male == MALE)
end

-- 选中Tog
function SelectTogEvent()
    EventDispatcher:Dispatch(ON_SELECT_TOG_EVENT)
end

-- 选择发型
function SelectHairStyleEvent(hair)

    EventDispatcher:Dispatch(SELECT_HAIR_STYLE_EVENT, hair)
end

-- 选择美瞳
function SelectEyeStyleEvent(eye, color)

    EventDispatcher:Dispatch(SELECT_EYE_STYLE_EVENT, eye, color)
end

-- 清理造型
function ClearStyleEvent()

    EventDispatcher:Dispatch(CLEAR_ROLE_STYLE_EVENT)
end

-- 晃动事件
function ShakeEvent(left, heavy, callback)

    EventDispatcher:Dispatch(SHAKE_EVENT, left, heavy, callback)
end

-- 播入场动作事件
function DoEnterAnim(...)

    EventDispatcher:Dispatch(ON_ENTER_ANIM_EVENT, ...)
end

-- 更换角色事件
function ChangeRoleEvent(...)

    EventDispatcher:Dispatch(CHANGE_ROLE, ...)
end

--------------------------------------------事件广播--End----------------------------------

--------------------------------------------其他接口--Start----------------------------------
-- 清理等待创角回调状态
function resetWaitState()

    createCharWaitServerResponse = false
end

-- 进入创角界面
function EnterCreateRole(accountData)
    l_data.UpdateRolesAccountInfo(accountData)
    game:SwitchStage(MStageEnum.SelectChar, 46)
end

-- 获取删除角色倒计时
function GetDeletingCountDownTimeFormat(time)

    if time <= 0 then
        return false, "0:00"
    end

    local l_hour = math.floor(time / 3600)
    if l_hour > 0 then
        return true, StringEx.Format("{0}{1}", l_hour, Lang("HOURS"))
    end

    local l_min = math.floor((time - l_hour * 3600) / 60)
    if l_hour > 0 then
        return true, StringEx.Format("{0}:{1:00}", l_hour, l_min)
    else
        local l_sec = math.ceil(time % 60)
        return true, StringEx.Format("{0}:{1:00}", l_min, l_sec)
    end
end


--零收益处理
function handleZeroProfitTime(info)

    logRed("info.ExtraInfo.zero_profit_time", type(info.ExtraInfo.zero_profit_time), info.ExtraInfo.zero_profit_time)
    if info.ExtraInfo.zero_profit_time ~= nil and tostring(info.ExtraInfo.zero_profit_time) ~= '0' then
        local l_reasonText = Lang("IDIP_ZERO_EARNINGS_DES")
        MPlayerInfo.ZeroProfitTime = MoonCommonLib.DateTimeEx.FromCppSecond2CsDateTime(info.ExtraInfo.zero_profit_time)
        MPlayerInfo.ZeroProfitReason = info.ExtraInfo.zero_profit_reason or l_reasonText
        GlobalEventBus:Add(EventConst.Names.EnterScene, function()
            MgrMgr:GetMgr("PlayerGameStateMgr").ShowPlayerZeroProfitDlg()
            GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.EnterScene, MgrMgr:GetMgr("SelectRoleMgr"))
        end, MgrMgr:GetMgr("SelectRoleMgr"))
    end
end

--追缴处理
function handleRecoverInfo(info)

    logRed("info.bag.recover_info.time", type(info.bag.recover_info.time), info.bag.recover_info.time)
    if info.bag.recover_info ~= nil and tostring(info.bag.recover_info.time) ~= '0' then
        GlobalEventBus:Add(EventConst.Names.EnterScene, function()
            MgrMgr:GetMgr("PlayerGameStateMgr").ShowRecoverPayDlg(info.bag.recover_info)
            GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.EnterScene, MgrMgr:GetMgr("SelectRoleMgr"))
        end, MgrMgr:GetMgr("SelectRoleMgr"))
    end
end

-- 通知逻辑层登陆数据
function handleMgrNotify(info)

    --任务及任务触发器处理
    MgrMgr:GetMgr("TaskTriggerMgr").OnTaskTriggerAll(info.task_triggers)
    MgrMgr:GetMgr("TaskMgr").InitTaskInfo(info.roleData.taskrecord)

    local l_mgrList = l_data.ESelectRoleNotify
    local l_roleData = info.roleData
    for i, v in ipairs(l_mgrList) do
        local l_mgr = MgrMgr:GetMgr(v)
        if l_mgr and l_mgr.OnSelectRoleNtf then
            PCallAndDebug(l_mgr.OnSelectRoleNtf,l_roleData)
        end
    end
end

-- 角色属性更改，如称号
function OnRoleAttributeNtf(msg)
    -- body
    local l_resInfo = ParseProtoBufToTable("RoleAttribute", msg)
    local l_entity = MEntityMgr:GetEntity(l_resInfo.role_id)
    if tostring(l_resInfo.role_id) == tostring(MPlayerInfo.UID) then
        l_entity = MEntityMgr.PlayerEntity
    end
    -- 称号更改
    if l_resInfo.attr_id == RoleAttributeId.RoleAttr_TitleId then
        MEventMgr:LuaFireEvent(MEventType.MEvent_RoleTitle_Change, l_entity, l_resInfo.attr_value)
    elseif l_resInfo.attr_id == RoleAttributeId.RoleAttr_Tag then
        -- 标签更改
        MEventMgr:LuaFireEvent(MEventType.MEvent_RoleTag_Change, l_entity, l_resInfo.attr_value)
    elseif l_resInfo.attr_id == RoleAttributeId.RoleAttr_belluze_effectid then
        MPlayerInfo.BeiluzEffectID = l_resInfo.attr_value
        local entity = MEntityMgr:GetEntity(l_resInfo.role_id)
        if entity~= nil and not entity:Equals(nil) and entity.AttrComp and not entity.AttrComp:Equals(nil) then
            entity.AttrComp:SetBeiLuZi(l_resInfo.attr_value)
        end
        MgrProxy:GetGameEventMgr().RaiseEvent(MgrProxy:GetGameEventMgr().OnBeiluzEffectChange)
    end
end

--预注册角色换装
function ChangeStyle(hairId, eyeId, eyeColorId)

    local l_msgId = Network.Define.Rpc.ChangeStyle
    ---@type ChangeStyleArg
    local l_sendInfo = GetProtoBufSendTable("ChangeStyleArg")
    l_sendInfo.hair_id = hairId
    l_sendInfo.eye.eye_id = eyeId
    l_sendInfo.eye.eye_style_id = eyeColorId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnChangeStyle(msg, arg)

    ---@type ChangeStyleRes
    local l_info = ParseProtoBufToTable("ChangeStyleRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    UIMgr:DeActiveUI(UI.CtrlNames.CreateChar)
    MEntityMgr.PlayerEntity.AttrComp:SetHair(arg.hair_id)
    MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(arg.eye.eye_style_id)
    MEntityMgr.PlayerEntity.AttrComp:SetEye(arg.eye.eye_id)

end
--------------------------------------------其他接口--End----------------------------------

function ClearCreateCharCount()

    l_data.CreateCharCount = 0
end

return ModuleMgr.SelectRoleMgr