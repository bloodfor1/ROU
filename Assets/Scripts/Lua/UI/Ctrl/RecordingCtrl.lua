--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RecordingPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
RecordingCtrl = class("RecordingCtrl", super)

--lua class define end

--lua functions
function RecordingCtrl:ctor()

	super.ctor(self, CtrlNames.Recording, UILayer.Function, nil, ActiveType.Standalone)
    self.WaitCloseTask = nil
    self.WaitAboutTask = nil
end --func end
--next--
function RecordingCtrl:Init()

	self.panel = UI.RecordingPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function RecordingCtrl:Uninit()

    self.WaitCloseTask = nil
    self.WaitAboutTask = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function RecordingCtrl:OnActive()
    if self.uiPanelData~=nil then
        if self.uiPanelData.needRestart then
            self:ReStart()
        end
    end
end --func end
--next--
function RecordingCtrl:OnDeActive()
    self.WaitCloseTask = nil
    self.WaitAboutTask = nil
end --func end
--next--
function RecordingCtrl:Update()
    if self.WaitAboutTask~=nil and self.WaitAboutTask > 0 then
        self.WaitAboutTask = self.WaitAboutTask-Time.deltaTime
        if self.WaitAboutTask <= 0 then
            if not self.Cancel then
                self:ShowAboutRecord()
            end
        end
    end

    if self.WaitCloseTask~=nil and self.WaitCloseTask > 0 then
        self.WaitCloseTask = self.WaitCloseTask-Time.deltaTime
        if self.WaitCloseTask <= 0 then
            UIMgr:DeActiveUI(CtrlNames.Recording)
        end
    end

end --func end



--next--
function RecordingCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function RecordingCtrl:ReStart()
    --最长时间超标会闪烁
    local l_maxTime = TableUtil.GetSocialGlobalTable().GetRowByName("Audiocountdown").Value
    if l_maxTime ~= nil then
        self.WaitAboutTask = tonumber(l_maxTime)
    else
        self.WaitAboutTask = 10
    end
    self.Cancel = false
    self.WaitCloseTask = 0

    if self.InEnetr or self.InEnetr == nil then
        self:ShowRecord()
    else
        self:ShowCancel()
    end
end

function RecordingCtrl:SetEnterState(b)
    self.InEnetr = b
    if self.panel~=nil then
        if self.InEnetr then
            self:ShowRecord()
        else
            self:ShowCancel()
        end
    end
end

--开始录音
function RecordingCtrl:ShowRecord()
    if self.WaitAboutTask~=nil and self.WaitAboutTask<=0 then
        self:ShowAboutRecord()
        return
    end
    self.Cancel = false
    self.panel.CircleAnim.FxAnim:PlayAll()
    self.panel.Halo.gameObject:SetActiveEx(true)
    self.panel.Halo1.gameObject:SetActiveEx(true)

    self.panel.Back.gameObject:SetActiveEx(false)
    self.panel.Send.gameObject:SetActiveEx(false)
    self.panel.Record.gameObject:SetActiveEx(true)
    self.panel.Record.FxAnim:StopAll()

    self.panel.QuanAnim.gameObject:SetActiveEx(true)
    self.panel.QuanAnim.FxAnim:StopAll()

    self.panel.TxtColor:SetSprite("Common","Ui_Chat_RecordTxtBG.png")
    self.panel.Content.LabText = Lang("ChatAudio_Record")--"手指划开可取消发送"

end

--录音时间超过n秒开始闪烁
function RecordingCtrl:ShowAboutRecord()
    self.Cancel = false
    self.panel.Halo.gameObject:SetActiveEx(true)
    self.panel.Halo1.gameObject:SetActiveEx(true)

    self.panel.Back.gameObject:SetActiveEx(false)
    self.panel.Send.gameObject:SetActiveEx(false)
    self.panel.Record.gameObject:SetActiveEx(true)
    self.panel.Record.FxAnim:PlayAll()

    self.panel.QuanAnim.gameObject:SetActiveEx(true)
    self.panel.QuanAnim.FxAnim:StopAll()

    self.panel.TxtColor:SetSprite("Common","Ui_Chat_RecordTxtBG.png")
    self.panel.Content.LabText = Lang("ChatAudio_Record")--"手指划开可取消发送"
end

--正在上传
function RecordingCtrl:ShowSend()
    self.WaitCloseTask = 1

    self.panel.Halo.gameObject:SetActiveEx(false)
    self.panel.Halo1.gameObject:SetActiveEx(false)

    self.panel.Back.gameObject:SetActiveEx(false)
    self.panel.Send.gameObject:SetActiveEx(true)
    self.panel.Record.gameObject:SetActiveEx(false)

    self.panel.QuanAnim.gameObject:SetActiveEx(true)
    self.panel.QuanAnim.FxAnim:PlayAll()

    self.panel.TxtColor:SetSprite("Common","Ui_Chat_RecordTxtBG.png")
    self.panel.Content.LabText = Lang("ChatAudio_Sending")--"正在发送中..."

end

--抬起手指取消发送
function RecordingCtrl:ShowCancel()
    self.Cancel = true
    self.panel.Halo.gameObject:SetActiveEx(false)
    self.panel.Halo1.gameObject:SetActiveEx(false)

    self.panel.Back.gameObject:SetActiveEx(true)
    self.panel.Send.gameObject:SetActiveEx(false)
    self.panel.Record.gameObject:SetActiveEx(false)

    self.panel.QuanAnim.gameObject:SetActiveEx(false)

    self.panel.TxtColor:SetSprite("Common","Ui_Chat_RecordTxtBG1.png")
    self.panel.Content.LabText = Lang("ChatAudio_Cancel")--"手指抬起取消发送"
end
--lua custom scripts end

return RecordingCtrl