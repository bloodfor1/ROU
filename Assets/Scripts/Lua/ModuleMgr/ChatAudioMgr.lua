module("ModuleMgr.ChatAudioMgr", package.seeall)


local ChatMgr = MgrMgr:GetMgr("ChatMgr")
local chatDataMgr =DataMgr:GetData("ChatData")

EventDispatcher = EventDispatcher.new()
Event={
    Play="Play",
    PlayFinish="PlayFinish",
    Record="Record",
    RecordFinish="RecordFinish",
}

-- PlayList 维护的是自动播放的队列
PlayList = Common.list.ArrayList.create()
PlayingPack = nil
Recording = false

function OnInit()

    if not MDevice.EnableSDKInterface("GVoice") then
        return
    end

    GlobalEventBus:Add(EventConst.Names.NewChatMsg,OnChatMsg)
    GlobalEventBus:Add(EventConst.Names.ChatAudioChanged,OnVolumeChanged)

    --自动播放的上限
    local l_maxTime = TableUtil.GetSocialGlobalTable().GetRowByName("AutoAudioSaveNum")
    if l_maxTime ~= nil then
        PlayListMaxCount = tonumber(l_maxTime.Value)
    else
        logError("数据缺损 PlayListMaxCount")
        PlayListMaxCount = 10
    end

    --最多翻译数
    local l_maxTime = TableUtil.GetSocialGlobalTable().GetRowByName("AudioMaxNumLimit")
    if l_maxTime ~= nil then
        AudioMaxNumLimit = tonumber(l_maxTime.Value)
    else
        logError("数据缺损 AudioMaxNumLimit")
        AudioMaxNumLimit = 10
    end
    OnVolumeChanged()
    MVoice.RegisterCallBack(OnSDKRecordFinish, OnSDKPlayFinish)
end

function OnUnInit()
    GlobalEventBus:Remove(EventConst.Names.NewChatMsg,OnChatMsg)
    GlobalEventBus:Remove(EventConst.Names.ChatAudioChanged,OnVolumeChanged)
end

function OnLogout()
    Clear()
    Stop()
    if Recording then
        StopRecord()
    end
end

function OnUpdate()
    if PlayingPack~=nil then
        if PlayingPack.PlayTime then
            local l_lenght = Time.time - PlayingPack.PlayTime
            if l_lenght > PlayingPack.Duration + 5 then
                Stop()
                TryMoveQueue()
            end
        end
    end
end

function GetAudioObj(ID,Text,Duration,Channel)
    return {
        ID = ID,                --key = string
        Text = Text,            --翻译 = string
        Duration = Duration,    --时长 = float
        Channel = Channel,      --频道 -队伍/公会

        PlayOver = false,   --已经播放过了
        PlayTime = 0,       --播放时间
        PlayFunc = nil,     --开始播放回调
        StopFunc = nil,     --停止播放回调
    }
end

-------------------------------------播放录音
--接收聊天消息
function OnChatMsg(msgPack)
    --不是语音聊天丢弃
    if msgPack.AudioObj==nil or msgPack.playerInfo==nil then
        return
    end

    local l_openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_chatVoiceOpen = l_openMgr.IsSystemOpen(l_openMgr.eSystemId.ChatVoice)
    --聊天语音未开放丢弃
    if not l_chatVoiceOpen then
        return
    end

    --自己的聊天语音消息丢弃
    if msgPack.playerInfo.isSelf then
        return
    end

    --已经播完的
    if msgPack.AudioObj.PlayOver then
        return
    end

    --仅在wifi下自动播放
    if MPlayerSetting.soundChatData.ChatWifiAutoState then
        if Application.internetReachability ~= NetworkReachability.ReachableViaLocalAreaNetwork then
            return
        end
    end

    --世界聊天不自动播放
    if not MPlayerSetting.soundChatData.ChatWorldState then
        if msgPack.channel == chatDataMgr.EChannel.WorldChat then
            return
        end
    end

    --组队聊天不自动播放
    if not MPlayerSetting.soundChatData.ChatTeamState then
        if msgPack.channel == chatDataMgr.EChannel.TeamChat then
            return
        end
    end

    --公会聊天不自动播放
    if not MPlayerSetting.soundChatData.ChatGuildState then
        if msgPack.channel == chatDataMgr.EChannel.GuildChat then
            return
        end
    end

    --附近聊天不自动播放
    if not MPlayerSetting.soundChatData.ChatCurrentState then
        if msgPack.channel == chatDataMgr.EChannel.CurSceneChat then
            return
        end
    end

    log("语音入列")
    msgPack.AudioObj.Channel = msgPack.channel
    -- 添加字段autoPlay 是否进入自动播放队列
    msgPack.AudioObj.autoPlay = true
    PlayList:add(msgPack.AudioObj)
    if PlayList:size() > PlayListMaxCount then
        PlayList:removeAt(0)
    end
    TryMoveQueue()
end

function OnVolumeChanged()
    if not MDevice.EnableSDKInterface("GVoice") then
        logWarn("OnVolumeChanged GVoice==nil!!!")
        return
    end
    local l_volume=0
    if MPlayerSetting.soundVolumeData.SoundMainVolumeState and MPlayerSetting.soundVolumeData.SoundChatVolumeState then
        l_volume=MPlayerSetting.soundVolumeData.SoundChatVolume
    end
    MVoice.SetSpeakerVolume(CJson.encode({volume = l_volume}))
end

function TryMoveQueue()
    if PlayingPack ~= nil then
        return
    end
    if PlayList:size() <= 0 then
        return
    end

    Play(PlayList:get(0))
end

--播放语音
function Play(AudioObj)
    if not MDevice.EnableSDKInterface("GVoice") then
        return false
    end
    if AudioObj == nil then
        return false
    end

    Stop()
    -- PlayList 维护的是自动播放的队列 所以只有进入队列的语音数据才需要移除
    if AudioObj.autoPlay then
        AudioObj.autoPlay = false
        PlayList:remove(AudioObj)
    end

    MAudioMgr.IsPaused = true
    local l_code = MVoice.PlayRecordedFile(CJson.encode({fileid = AudioObj.ID, uin = 0}))
    log("播放语音 => code="..tostring(l_code))
    if l_code ~= 0 then
        logError("SDK PlayRecord返回异常 => code="..tostring(l_code))
        TryMoveQueue()
        return false
    end

    PlayingPack = AudioObj
    AudioObj.PlayOver = true
    AudioObj.PlayTime = Time.time

    if AudioObj.PlayFunc ~= nil then
        AudioObj.PlayFunc(AudioObj.ID,AudioObj)
    end
    EventDispatcher:Dispatch(Event.Play,AudioObj.ID,AudioObj)
end

function CanPlaying(audioObj)
    if audioObj~=nil and PlayingPack~=nil then
        return audioObj.ID == PlayingPack.ID
    end
    return PlayingPack~=nil
end

--停止播放
function Stop()
    if not MDevice.EnableSDKInterface("GVoice") then
        return
    end
    if PlayingPack == nil then
        return true
    end
    log("停止播放语音")
    local l_AudioObj = PlayingPack
    PlayingPack = nil

    if l_AudioObj.StopFunc ~= nil then
        l_AudioObj.StopFunc(l_AudioObj.ID,l_AudioObj)
    end
    EventDispatcher:Dispatch(Event.PlayFinish,l_AudioObj.ID,l_AudioObj)
    local l_res = MVoice.StopPlayFile() == 0
    MAudioMgr.IsPaused = false
    return l_res
end

--语音包的回调
function SetCallBack(AudioObj,playCall,stopCall)
    if AudioObj~=nil then
        AudioObj.PlayFunc = playCall
        AudioObj.StopFunc = stopCall
    end
end

--清理回调
function ClearCallBack(AudioObj)
    if AudioObj~=nil then
        AudioObj.PlayFunc = nil
        AudioObj.StopFunc = nil
    end
end

function Clear()
    PlayList:resize(0)
end

-------------------------------------录音-----------------------
function StartRecord()
    if not MDevice.EnableSDKInterface("GVoice") then
        return false
    end
    if Recording then
        return false
    end
    Clear()
    Stop()

    MAudioMgr.IsPaused = true
    local l_code = MVoice.StartRecording()
    if l_code ~= 0 then
        logError("SDK StartRecord返回异常 => code="..tostring(l_code))
        return false
    end
    Recording = true
    return true
end

function StopRecord()
    if not MDevice.EnableSDKInterface("GVoice") then
        return false
    end
    local l_code = MVoice.StopRecording()
    MAudioMgr.IsPaused = false
    if l_code ~= 0 then
        logError("SDK StopRecord返回异常 => code="..tostring(l_code))
        return false
    end
    --OnSDKRecordFinish(0,"audioID","语音翻译...",5)
    return true
end

-------------------------------------SDK回调---------------
function OnSDKRecordFinish(code,audioID,translate,time)
    if AudioMaxNumLimit>0 and translate~=nil then
        if string.ro_len(translate)>AudioMaxNumLimit then
            translate=string.ro_cut(translate,AudioMaxNumLimit);
        end
    end

    Recording = false
    EventDispatcher:Dispatch(Event.RecordFinish,code,audioID,translate,time)
end

function OnSDKPlayFinish(audioID) --audioID参数sdk暂缺
    log("语音SDK播放回调")
    Stop()
    TryMoveQueue()
end

return ChatAudioMgr

