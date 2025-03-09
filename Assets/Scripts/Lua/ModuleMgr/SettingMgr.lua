---@module ModuleMgr.SettingMgr
module("ModuleMgr.SettingMgr", package.seeall)


EventDispatcher = EventDispatcher.new()

OnPushSwitchInfo="OnPushSwitchInfo" -- 推送数据
OnAllPushSwitchStateChange="OnAllPushSwitchStateChange" -- 总开关状态改变

ENTER_CG_EVENT = "ENTER_CG_EVENT"
EXIST_CG_EVENT = "EXIST_CG_EVENT"

--保存进入省电模式之前的状态
mPowerSavingState = nil
--被动进入省电模式的时间
mPassivePowerSavingTime = MGlobalConfig:GetInt("AutomaticEnterPowerSavingMode")
--主动脱离卡死cd
mFreeStuckCDCountDown = 0
--被动脱离卡死cd
mFreeStuckCDPassiveCountDown = 0
--是否在播放cg
mIsPlayingCG = false
--是否在播放cutscene
mIsPlayingCutScene = false
--上次cg结束的时间
mLastCGEndTime = 0
--上次cutscene结束的时间
mLastCutSceneTime = 0
--是否在loading状态
mIsLoading = false
--上一次loading完的时间
mLastLoadingTime = 0
-- 推送token
mPushToken = ""
-- 当前总推送开关的状态
CurrentAllPushSwitchState = true

function OnInit()
    EventDispatcher:Add(ENTER_CG_EVENT, function()
        mIsPlayingCG = true
    end, ModuleMgr.SettingMgr)
    EventDispatcher:Add(EXIST_CG_EVENT, function()
        mIsPlayingCG = false

        mLastCGEndTime = Time.realtimeSinceStartup
    end, ModuleMgr.SettingMgr)

    GlobalEventBus:Add(EventConst.Names.CutSceneStart, function()
        mIsPlayingCutScene = true
    end, ModuleMgr.SettingMgr)
    GlobalEventBus:Add(EventConst.Names.CutSceneStop, function()
        mIsPlayingCutScene = false

        mLastCutSceneTime = Time.realtimeSinceStartup
    end, ModuleMgr.SettingMgr)

    --loading处理
    MgrMgr:GetMgr("LoadingMgr").EventDispatcher:Add(MgrMgr:GetMgr("LoadingMgr").ON_LOADING_START, function()
        mIsLoading = true
    end, ModuleMgr.SettingMgr)
    MgrMgr:GetMgr("LoadingMgr").EventDispatcher:Add(MgrMgr:GetMgr("LoadingMgr").ON_LOADING_END, function()
        mIsLoading = false

        mLastLoadingTime = Time.realtimeSinceStartup
        --清除状态，loading界面在某些情况下无法退出省电模式，目前还不知道原因
        ExistPowerSaving()
    end, ModuleMgr.SettingMgr)
end


function OnUnInit()
    EventDispatcher:RemoveObjectAllFunc(ENTER_CG_EVENT, ModuleMgr.SettingMgr)
    EventDispatcher:RemoveObjectAllFunc(EXIST_CG_EVENT, ModuleMgr.SettingMgr)

    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.CutSceneStart, ModuleMgr.SettingMgr)
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.CutSceneStop, ModuleMgr.SettingMgr)

    MgrMgr:GetMgr("LoadingMgr").EventDispatcher:RemoveObjectAllFunc(MgrMgr:GetMgr("LoadingMgr").ON_LOADING_START, ModuleMgr.SettingMgr)
    MgrMgr:GetMgr("LoadingMgr").EventDispatcher:RemoveObjectAllFunc(MgrMgr:GetMgr("LoadingMgr").ON_LOADING_END, ModuleMgr.SettingMgr)
end


function OnLogout()

end


function OnUpdate()
    if not mPowerSavingState and CanPowerSaving() then
        local l_lastTime = math.max(MPlayerInfo.LastTouchTime, mLastCGEndTime, mLastCutSceneTime, mLastLoadingTime)

        --mPassivePowerSavingTime = 10
        if Time.realtimeSinceStartup - l_lastTime > mPassivePowerSavingTime then
            --进入省电
            EnterPowerSaving(true)
        end
    end
    ----脱离卡死cd
    --if mFreeStuckCDCountDown > 0 then
    --    mFreeStuckCDCountDown = mFreeStuckCDCountDown - Time.deltaTime
    --    if mFreeStuckCDCountDown < 0 then
    --        mFreeStuckCDCountDown = 0
    --    end
    --end
    --if mFreeStuckCDPassiveCountDown > 0 then
    --    mFreeStuckCDPassiveCountDown = mFreeStuckCDPassiveCountDown - Time.deltaTime
    --    if mFreeStuckCDPassiveCountDown < 0 then
    --        mFreeStuckCDPassiveCountDown = 0
    --    end
    --end
end

--是否在打开个人设置时定位到隐私部分
local isOpenToPlayerPrivate = false

--是否等级以下陌生人消息不接收
local isPrivateChatLevel
-- 被观战时隐藏外观
local isHideOutlookWhenBeWatched = false

function OnSelectRoleNtf(info)
    local settingInfo = info.temp_record.setup_info
    isPrivateChatLevel = settingInfo.is_chat_level_limit
    if settingInfo.damage_number_show ~= 0 then
        MPlayerSetting.HitNumType = EHitNumType.IntToEnum(settingInfo.damage_number_show)
    end
    if settingInfo.target_choose ~= 0 then
        MPlayerSetting.TargetTabType = ETargetTabType.IntToEnum(settingInfo.target_choose)
    end

    isHideOutlookWhenBeWatched = false
    if info.temp_record.pearsonal_setting then
        isHideOutlookWhenBeWatched = info.temp_record.pearsonal_setting.hit_outlook_when_bewatched 
    end
end

function GetIsPrivateChatLevel()
    return isPrivateChatLevel
end

function SetIsOpenToPlayerPrivate(state)
    isOpenToPlayerPrivate = state
end

function GetIsOpenToPlayerPrivate()
    return isOpenToPlayerPrivate
end


function GetIsHideOutlookWhenBeWatched()
    return isHideOutlookWhenBeWatched
end

function OpenAutoHandler()
    UIMgr:ActiveUI(UI.CtrlNames.Setting,function(ctrl)
        ctrl:SelectOneHandler(UI.HandlerNames.SettingAuto)
    end)
end

-- 打开药品设置
function OpenPotionSetting()
    UIMgr:ActiveUI(UI.CtrlNames.PotionSetting)
end

--进入锁屏
function EnterLockScreen()
    UIMgr:ActiveUI(UI.CtrlNames.Lockscreen,function(ctrl)
        ctrl:EnterPoweringSaving()
    end)

    EnterPowerSaving()
end

--退出锁屏
function ExistLockScreen()
    UIMgr:DeActiveUI(UI.CtrlNames.Lockscreen)
end


--进入省电模式
-- isPassive 是否被动进入
function EnterPowerSaving(isPassive)
    if isPassive then
        UIMgr:ActiveUI(UI.CtrlNames.Powersaving)
    end

    --保存当前设置
    mPowerSavingState = {}
    --画面质量
    mPowerSavingState.qualitySetting = MQualityGradeSetting.GetCurLevel()
    MQualityGradeSetting.SetCustomLevel(0, false)
    --同屏人数
    mPowerSavingState.displayNumSetting = MPlayerSetting:GetQualityDisplayLevel(0)
    MQualityGradeSetting.SetCustomDisplayLevel(0, false)
    --游戏帧数
    mPowerSavingState.frameRateSetting = MPlayerSetting.TargetFrameRate
    MPlayerSetting:SetTargetFrameRateWithoutSaving(30)
    ----屏幕亮度
    --mPowerSavingState.screenBrightnessSetting = Screen.sleepTimeout
    --Screen.sleepTimeout = 0
end

--是否能省电模式
function CanPowerSaving()
    return not mIsPlayingCutScene and not mIsPlayingCG and MStageMgr.IsConcrete and not mIsLoading
end

--退出省电模式
function ExistPowerSaving()
    local l_lockScreen = UIMgr:GetUI(UI.CtrlNames.Lockscreen)
    if l_lockScreen then
        l_lockScreen:ExistPowerSaving()
    end

    UIMgr:DeActiveUI(UI.CtrlNames.Powersaving)


    --还原设置
    if mPowerSavingState then
        MQualityGradeSetting.SetCustomLevel(mPowerSavingState.qualitySetting, false)
        MQualityGradeSetting.SetCustomDisplayLevel(mPowerSavingState.displayNumSetting, false)
        MPlayerSetting:SetTargetFrameRateWithoutSaving(mPowerSavingState.frameRateSetting)
        --Screen.sleepTimeout = mPowerSavingState.screenBrightnessSetting
        mPowerSavingState = nil
    end
end

--脱离卡死
function FreeStuck(isPassive,onCancel)

    if isPassive == nil then isPassive = false end
    local l_info = ""
    if isPassive then
        l_info = Lang("FREE_STUCK_PASSIVE")
    else
        l_info = Lang("FREE_STUCK")
    end

    if not MEntityMgr.PlayerEntity then
        return
    end

    --状态互斥判定能否脱离卡死
    if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_AI_Detached) then
        return
    end

    if MNavigationMgr:IsPtValid(MEntityMgr.PlayerEntity.Position) then

        local l_txt = Lang("CANNOT_FREE_STUCK")
        CommonUI.Dialog.ShowOKDlg(true, nil, l_txt, function() end)
        return
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_info, function()
        ---@type RoleDetachedArg
        local l_sendInfo = GetProtoBufSendTable("RoleDetachedArg")
        l_sendInfo.is_passive = isPassive
        Network.Handler.SendRpc(Network.Define.Rpc.RoleDetached, l_sendInfo)
    end,onCancel)
end

-------------------------------Ptc----------------------------------------
--是否等级以下陌生人消息不接收
function RequestIsPrivateChatLevel(state)
    isPrivateChatLevel = state
    SaveRoleSetupInfo()
end

--设置目标
function RequestTargetSelectType(targetSelectType)
    MPlayerSetting.TargetTabType = targetSelectType
    SaveRoleSetupInfo()
end

--伤害数字显示
function RequestHitNumType(hitNumType)
    MPlayerSetting.HitNumType = hitNumType
    SaveRoleSetupInfo()
end

function SaveRoleSetupInfo()
    local l_msgId = Network.Define.Ptc.SaveRoleSetupInfoNtf
    ---@type SetupInfoData
    local l_sendInfo = GetProtoBufSendTable("SetupInfoData")
    l_sendInfo.is_chat_level_limit = isPrivateChatLevel
    l_sendInfo.damage_number_show = MPlayerSetting.HitNumType:ToInt()
    l_sendInfo.target_choose = MPlayerSetting.TargetTabType:ToInt()
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

-------------------------------Rpc----------------------------------------
function SavePearsonalSetting(hit_outlook_when_bewatched)

    if isHideOutlookWhenBeWatched == hit_outlook_when_bewatched then
        log("SavePearsonalSetting do not need change")
        return
    end

    local l_msgId = Network.Define.Rpc.SavePearsonalSetting
    ---@type PearsonalSetting
    local l_sendInfo = GetProtoBufSendTable("PearsonalSetting")
    l_sendInfo.hit_outlook_when_bewatched = hit_outlook_when_bewatched
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnSavePearsonalSetting(msg, args)
    ---@type NullRes
    local l_info = ParseProtoBufToTable("NullRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    isHideOutlookWhenBeWatched = args.hit_outlook_when_bewatched
end

function OnRoleDetached(msg, args)
    ---@type RoleDetachedRes
    local l_info = ParseProtoBufToTable("RoleDetachedRes", msg)
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_DETACHED_IN_CD then
            if args.is_passive then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("FREE_STUCK_CD_PASSIVE", math.ceil(l_info.the_rest_time)))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("FREE_STUCK_CD", math.ceil(l_info.the_rest_time)))
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
        return
    end
end

-----------------------------推送相关 start-------------------------------
function SetSDKPushToken(token)
    mPushToken = token
    MTracker.SetPushToken(CJson.encode({token = token}))
end

function PushMsgTokenToMs()
    logGreen("PushMsgTokenToMs: " .. mPushToken)
    if mPushToken ~= "" then
        local l_msgId = Network.Define.Ptc.PushMsgTokenToMs
        ---@type PushMsgTokenData
        local l_sendInfo = GetProtoBufSendTable("PushMsgTokenData")
        l_sendInfo.account_id = game:GetAuthMgr().AuthData.GetAccountInfo().account
        l_sendInfo.push_token = mPushToken
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end
end

function ReqPushSwitchInfo()
    log("ReqPushSwitchInfo")
    local l_msgId = Network.Define.Rpc.PushInfoSwitchInfo
    ---@type PushSwitchInfoArg
    local l_sendInfo = GetProtoBufSendTable("PushSwitchInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function RspPushSwitchInfo(msg)
    log("RspPushSwitchInfo")
    ---@type PushSwitchInfoRes
    local l_info = ParseProtoBufToTable("PushSwitchInfoRes", msg)
    log(ToString(l_info))
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        EventDispatcher:Dispatch(OnPushSwitchInfo, l_info, "info")
    end
end

function ReqPushSwitchInfoModify(arg)
    log("ReqPushSwitchInfoModify")
    log(ToString(arg))
    local l_msgId = Network.Define.Rpc.PushInfoSwitchModify
    ---@type PushSwitchModifyArg
    local l_sendInfo = GetProtoBufSendTable("PushSwitchModifyArg")
    l_sendInfo.main_switch = arg.main_switch
    l_sendInfo.all_switch_on = arg.all_switch_on
    l_sendInfo.all_switch_off = arg.all_switch_off
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function RspPushSwitchInfoModify(msg)
    log("RspPushSwitchInfoModify")
    ---@type PushSwitchModifyRes
    local l_info = ParseProtoBufToTable("PushSwitchModifyRes", msg)
    log(ToString(l_info))
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        EventDispatcher:Dispatch(OnPushSwitchInfo, l_info, "infomodify")
    end
end

function ChangeLine(line)
    --玩家处于不可切线状态
    if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_P_ChangeLine) then
        return
    end
    local l_msgId = Network.Define.Rpc.ChangeSceneLine
    ---@type ChangeSceneLineArg
    local l_sendInfo = GetProtoBufSendTable("ChangeSceneLineArg")
    l_sendInfo.scene_id = MScene.SceneID
    l_sendInfo.line = line
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    GlobalEventBus:Dispatch(EventConst.Names.UpdateSceneLinesPanel, false)
end

function OnChangeLineRes(msg)
    ---@type ChangeSceneLineRes
    local l_info = ParseProtoBufToTable("ChangeSceneLineRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        -- 加入失败，不关闭分线面板，请求获取新的分线信息
        GlobalEventBus:Dispatch(EventConst.Names.GetStaticSceneLine)
    else
        -- 加入成功，关闭分线信息面板
        GlobalEventBus:Dispatch(EventConst.Names.UpdateSceneLinesPanel, false)
    end
end

---@public
---接收到服务器返回的当前场景分线信息，通知SystemInfoCtrl更改分线栏内容
function OnSceneLinesDataReceived(msg)
    ---@type StaticSceneLineRes
    local res = ParseProtoBufToTable("StaticSceneLineRes", msg)
    if res.result ~= ErrorCode.ERR_SUCCESS then
        -- TODO: clientcode\CSProject\MoonClient\Network\protocol\process\scene\process_rpcc2n_getstaticsceneline.cs line25
        -- 这个C#协议处理已经打印了错误信息，为了防止打印两次先把lua的提示注释掉，下次更新再修改C#协议处理
        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(res.result))
    elseif res.scene_id == MScene.SceneID then
        GlobalEventBus:Dispatch(EventConst.Names.UpdateSceneLinesPanel, true, res.lines)
    else
        logError("[SettingMgr.OnSceneLineDataReceived] res.scene_id={0}, Mscene.SceneID={1} 场景号不匹配",
                res.scene_id, MScene.SceneID)
    end

end

-----------------------------推送相关 end-------------------------------

function GetSoundMainVolume()
    if MPlayerSetting.soundVolumeData.SoundMainVolumeState then
        return MPlayerSetting.soundVolumeData.SoundMainVolume
    else
        return 0
    end
end

function GetSoundBgmVolume()
    if MPlayerSetting.soundVolumeData.SoundBgmVolumeState then
        return MPlayerSetting.soundVolumeData.SoundBgmVolume
    else
        return 0
    end
end

function GetSoundChatVolume()
    if MPlayerSetting.soundVolumeData.SoundChatVolumeState then
        return MPlayerSetting.soundVolumeData.SoundChatVolume
    else
        return 0
    end
end

function GetSoundSeVolume()
    if MPlayerSetting.soundVolumeData.SoundSeVolumeState then
        return MPlayerSetting.soundVolumeData.SoundSeVolume
    else
        return 0
    end
end

function SyncVideoVolume()

    local l_volume = GetSoundMainVolume()

    VideoPlayerMgr:SetVolume(l_volume)

    local l_root = VideoPlayerMgr.gameObject
    if l_root then
        local l_child = MoonCommonLib.GameObjectEx.FindObjectInChild(l_root, "VideoPlayerRoot")
        if l_child then
            local l_com = l_child:GetComponent("MediaPlayer")
            l_com.m_Volume = l_volume
        end
    end

end

return SettingMgr