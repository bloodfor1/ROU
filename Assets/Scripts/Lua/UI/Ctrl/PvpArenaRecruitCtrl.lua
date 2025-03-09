--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PvpArenaRecruitPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PvpArenaRecruitCtrl = class("PvpArenaRecruitCtrl", super)
--lua class define end

--lua functions
function PvpArenaRecruitCtrl:ctor()

    super.ctor(self, CtrlNames.PvpArenaRecruit, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function PvpArenaRecruitCtrl:Init()

    self.panel = UI.PvpArenaRecruitPanel.Bind(self)
    super.Init(self)
    self.guildMgr = MgrMgr:GetMgr("GuildMgr")
    self.pvpArenaMgr = MgrMgr:GetMgr("PvpArenaMgr")

end --func end
--next--
function PvpArenaRecruitCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function PvpArenaRecruitCtrl:OnActive()

    self:OnInit()

end --func end
--next--
function PvpArenaRecruitCtrl:OnDeActive()

    self:OnUninit()

end --func end
--next--
function PvpArenaRecruitCtrl:Update()


end --func end





--next--
function PvpArenaRecruitCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function PvpArenaRecruitCtrl:OnInit()
    self.recruit = false
    --self:SetBlockOpt(BlockColor.Dark)
    self.channel = DataMgr:GetData("ChatData").EChannel.GuildChat
    self.str = ""
    self.panel.closeBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaRecruit)
    end)
    self.panel.sendBtn:AddClick(function()
        if self.recruit and self.str ~= "" then
            self.pvpArenaMgr.SendPvpArenaRecruit(self.str, self.channel)
            --UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaRecruit)
            local l_roleID = tostring(MPlayerInfo.UID)
            self.pvpArenaMgr.m_recruitTimeLimit[l_roleID] = Time.realtimeSinceStartup

            self:UpdateTimer()

        end
    end)
    self.panel.firstBtn.TogEx.onValueChanged:AddListener(function()
        if self.panel.firstBtn.TogEx.isOn then
            self.channel = DataMgr:GetData("ChatData").EChannel.GuildChat
            self:UpdateTimer()
        end
    end)
    self.panel.secondeBtn.TogEx.onValueChanged:AddListener(function()
        if self.panel.secondeBtn.TogEx.isOn then
            self.channel = DataMgr:GetData("ChatData").EChannel.WorldChat
            self:UpdateTimer()
        end
    end)
    self.panel.InputField:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        local l_maxLength = DataMgr:GetData("ChatData").GetChatMaxNum(self.channel)
        local l_inputMax = l_maxLength - 25 -- 为啥减25
        if string.ro_len(value) > l_inputMax then
            value = string.ro_cut(value, l_inputMax)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_LIMIT", l_inputMax))
        end
        self.str = value
    end, true)
    self:UpdateTimer()
end

function PvpArenaRecruitCtrl:OnUninit()

    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

end


function PvpArenaRecruitCtrl:UpdateTimer()
    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    local l_roleID = tostring(MPlayerInfo.UID)
    local l_last = self.pvpArenaMgr.m_recruitTimeLimit[l_roleID]
    local l_limit = self.pvpArenaMgr.m_limitTime
    if not l_last or Time.realtimeSinceStartup - l_last > l_limit then
        if (self.channel == DataMgr:GetData("ChatData").EChannel.GuildChat and
        MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild()) or self.channel == DataMgr:GetData("ChatData").EChannel.WorldChat then
            self.recruit = true
            self.panel.sendBtn:SetGray(not self.recruit)
            return
        end
    end
    self.recruit = false
    self.panel.sendBtn:SetGray(not self.recruit)
    if not l_last then
        return
    end
    self.timer = self:NewUITimer(function()
        if Time.realtimeSinceStartup - l_last > l_limit then
            if self.timer then
                self:StopUITimer(self.timer)
                self.timer = nil
            end
            self.recruit = true
            self.panel.sendBtn:SetGray(not self.recruit)
        end
    end, 1, -1, true)
    self.timer:Start()
end

--lua custom scripts end
return PvpArenaRecruitCtrl