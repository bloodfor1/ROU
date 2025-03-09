module("UI", package.seeall)

ChatRecordObj = class("ChatRecordObj")

function ChatRecordObj:ctor(name)
    self.name = name

    --最长录音时间
    local l_maxTime = TableUtil.GetSocialGlobalTable().GetRowByName("AudioTimeLimit")
    if l_maxTime ~= nil then
        self.AudioTimeLimit = tonumber(l_maxTime.Value)
    else
        self.AudioTimeLimit = 5
        logError("数据缺损 AudioTimeLimit")
    end

end

function ChatRecordObj:Init(btnObj)
    if btnObj == nil then
        logError("btnObj=nil")
        return
    end

    self.ChatMgr = MgrMgr:GetMgr("ChatMgr")
    self.ChatAudioMgr = MgrMgr:GetMgr("ChatAudioMgr")
    self.ShortcutChatMgr = MgrMgr:GetMgr("ShortcutChatMgr")

    self.btnObj = btnObj
    if self.btnObj then
        local l_lis = MLuaUIListener.Get(self.btnObj.gameObject)
        l_lis.onDown = function(obj,data)
            if self.WaitRecordTime then
                self.WaitRecordTime:Stop()
                self.WaitRecordTime = nil
            end
            self.WaitRecordTime = Timer.New(function()
                self:OnDown(obj,data)
            end,self.ShortcutChatMgr.LongClickTime)
            self.WaitRecordTime:Start()
        end
        l_lis.onUp = function(obj,data)
            if self.WaitRecordTime then
                self.WaitRecordTime:Stop()
                self.WaitRecordTime = nil
            end
            self:OnUp(obj,data)
        end
        l_lis.onEnter = function(obj,data)
            self:OnEnter(obj,data)
        end
        l_lis.onExit = function(obj,data)
            self:OnExit(obj,data)
        end
        l_lis.beginDrag = function(obj,data)
            if self.WaitRecordTime then
                self.WaitRecordTime:Stop()
                self.WaitRecordTime = nil
            end
        end
    end

    self.ChatAudioMgr.EventDispatcher:Add(self.ChatAudioMgr.Event.RecordFinish,self.OnStopRecord,self)
    return self
end
function ChatRecordObj:OnDown(obj,data)
    self:StartRecord()
    if self.OnDownAction then
        self.OnDownAction(obj,data)
    end
end
function ChatRecordObj:OnUp(obj,data)
    self:StopRecord()
end
function ChatRecordObj:OnEnter(obj,data)
    if self.InRecord then 
        self:ChangeEnterState(true)
    end
end
function ChatRecordObj:OnExit(obj,data)
    if self.InRecord then
        self:ChangeEnterState(false)
    end
end

function ChatRecordObj:Unint()
    self:StopRecord()
    if self.WaitRecordTime then
        self.WaitRecordTime:Stop()
        self.WaitRecordTime = nil
    end
    self.ChatAudioMgr.EventDispatcher:Remove(self.ChatAudioMgr.Event.RecordFinish,self)
end

function ChatRecordObj:SetChannel(channel)
    self.Channel = channel
    return self
end

function ChatRecordObj:SetSendAction(func)
    self.SendAction = func
    return self
end

function ChatRecordObj:SetOnDown(func)
    self.OnDownAction = func
    return self
end

--外部驱动
function ChatRecordObj:Update()
    if self.InRecord then
        local l_curTime = Time.unscaledTime - self.RecordTime
        if l_curTime >= self.AudioTimeLimit then
            self:StopRecord()
        end
    end
end

--------------------------------------

--开始录音
function ChatRecordObj:StartRecord()
    if self.Channel == nil then
        logError("未设置 Channel")
        return false
    end
    if self.InRecord then
        logError("已经在录音中")
        return false
    end
    if self.WaitSDKBack then
        logWarn("等待SDK回调返回录音数据,无法启动录音")
        return false
    end
    if not self.ChatMgr.CanSendMsg(self.Channel) then
        return false
    end
    if not self.ChatAudioMgr:StartRecord() then
        --logError("录音启动失败")
        return false
    end

    self.RuningChannel = self.Channel
    self.InRecord = true
    self.RecordTime = Time.unscaledTime
    self:ChangeEnterState(true)
    self:OnStartRecord()
    return true
end

--结束录音
function ChatRecordObj:StopRecord()
    if not self.InRecord then
        return
    end
    self.InRecord = false
    self.WaitSDKBack = true

    if self.ChatAudioMgr:StopRecord() then
        if self.InEnter then
            local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Recording)
            if l_ctrl then
                l_ctrl:ShowSend()
            end
        else
            UIMgr:DeActiveUI(UI.CtrlNames.Recording)
        end
    else
        --SDK结束返回错误
        self.WaitSDKBack = false
        UIMgr:DeActiveUI(UI.CtrlNames.Recording)
    end
end

--
function ChatRecordObj:OnStartRecord()
    --logError("开始录音")
    UIMgr:ActiveUI(UI.CtrlNames.Recording,{needRestart=true})
end

--接收SDK回调消息
function ChatRecordObj:OnStopRecord(code,audioID,translate,time)
    if not self.WaitSDKBack then
        UIMgr:DeActiveUI(UI.CtrlNames.Recording)
        return
    end
    self.WaitSDKBack = false

    if code ~= 0 then
        logWarn("SDK RecordFinish回调异常 => code="..tostring(code))
        self.RecordTime = Time.unscaledTime - self.RecordTime
        if self.RecordTime <= 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatAudio_TooShort"))--"语音时长过短，发送失败"
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatAudio_Microphone"))--未检测到麦克风
        end
        UIMgr:DeActiveUI(UI.CtrlNames.Recording)
        return
    end

    if self.InEnter then
        self.RecordTime = Time.unscaledTime - self.RecordTime
        if self.RecordTime <= 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatAudio_TooShort"))--"语音时长过短，发送失败"
        else
            self:OnMakeSureMsg(audioID,translate,self.RecordTime,self.RuningChannel)
        end
    else
        --手指划出范围,取消发言
        --logError("取消发言")
    end
    UIMgr:DeActiveUI(UI.CtrlNames.Recording)
end

--确认数据发送消息
function ChatRecordObj:OnMakeSureMsg(audioID,translate,time,channel)
    if self.SendAction~=nil then
        self.SendAction(audioID,translate,time,channel)
    else
        self.ChatMgr.SendAudioMsg(MEntityMgr.PlayerEntity.UID, audioID,translate,time,channel)
    end
end

--手指划出范围：抬起取消发言
function ChatRecordObj:ChangeEnterState(b)
    if self.InEnter == b then
        return
    end
    self.InEnter = b

    if self.InRecord then
        local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Recording)
        if l_ctrl ~= nil then
            l_ctrl:SetEnterState(self.InEnter)
        end
    end
end

return ChatRecordObj