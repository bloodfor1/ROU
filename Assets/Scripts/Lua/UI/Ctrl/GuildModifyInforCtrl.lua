--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildModifyInforPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildModifyInforCtrl = class("GuildModifyInforCtrl", super)
--lua class define end

local l_guildMgr = nil
local l_guildData = nil
local l_msgModifyType = 1  --修改类型 1公会公告 2招募宣言
local l_noticeTemp = "" -- 修改中的临时公告
local l_wordsTemp = "" -- 修改中的临时宣言
local l_guildNoticeLengthMaxLimit = 80  --公会公告/招募宣言最大长度限制

--lua functions
function GuildModifyInforCtrl:ctor()

    super.ctor(self, CtrlNames.GuildModifyInfor, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent

end --func end
--next--
function GuildModifyInforCtrl:Init()

    self.panel = UI.GuildModifyInforPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    --公会公告/招募宣言最大长度限制
    l_guildNoticeLengthMaxLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NoticeLengthMaxLimit").Value)

    --输入框长度限制
    self.panel.MsgInput.Input.characterLimit = l_guildNoticeLengthMaxLimit

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildModifyInfor)
    end)

    --标签栏切换
    for i=1,2 do
        self.panel.TogModifyType[i]:OnToggleExChanged(function (value)
            if value==true and l_msgModifyType ~= i then
                l_msgModifyType = i
                if l_msgModifyType == 1 then
                    --记录宣言修改 展示公告临时内容
                    l_wordsTemp = self.panel.MsgInput.Input.text
                    self.panel.MsgInput.Input.text = l_noticeTemp
                else
                    --记录公告修改 展示宣言临时内容
                    l_noticeTemp = self.panel.MsgInput.Input.text
                    self.panel.MsgInput.Input.text = l_wordsTemp
                end
            end
        end)
    end

    --确定按钮点击
    self.panel.BtnSure:AddClick(function ()
        self:BtnNoticeModifySureClick()
    end)

    --设置遮罩
    --self:SetBlockOpt(BlockColor.Transparent)

end --func end
--next--
function GuildModifyInforCtrl:Uninit()

    l_guildData = nil
    l_guildMgr = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildModifyInforCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == l_guildData.EUIOpenType.GuildModifyInfor then
            self:SetModifyType(self.uiPanelData.bulletinType)
        end
    end

end --func end
--next--
function GuildModifyInforCtrl:OnDeActive()


end --func end
--next--
function GuildModifyInforCtrl:Update()


end --func end

--next--
function GuildModifyInforCtrl:BindEvents()
    --被踢出回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_KICKOUT,function(self)
        UIMgr.DeActiveUI(UI.CtrlNames.GuildModifyInfor)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--根据当前公告栏的展示类型修改 修改类型 1公告 2宣言
function GuildModifyInforCtrl:SetModifyType(modifyType)

    l_msgModifyType = modifyType
    --announce 公告  declaration 宣言
    l_noticeTemp = l_guildData.guildBaseInfo.announce
    l_wordsTemp = l_guildData.guildBaseInfo.declaration

    if modifyType == 1 then
        self.panel.TogModifyType[1].TogEx.isOn = true
        self.panel.MsgInput.Input.text = l_noticeTemp
    else
        self.panel.TogModifyType[2].TogEx.isOn = true
        self.panel.MsgInput.Input.text = l_wordsTemp
    end

end

--信息修改界面确定按钮点击
function GuildModifyInforCtrl:BtnNoticeModifySureClick()
    local l_newMsg = self.panel.MsgInput.Input.text
    local l_newMsgLength = string.ro_len_normalize(l_newMsg)

    --为空判断
    if l_newMsgLength == 0 then
        if l_msgModifyType == 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_NOTICE_CAN_NOT_EMPTY"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_RECRUITWORDS_CAN_NOT_EMPTY"))
        end
        return
    end

    --过长判断
    if l_newMsgLength > l_guildNoticeLengthMaxLimit then
        if l_msgModifyType == 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_NOTICE_TOO_LONG"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_RECRUITWORDS_TOO_LONG"))
        end
        return
    end

    if l_msgModifyType == 1 then
        l_guildMgr.ReqModifyGuildNotice(l_newMsg)
    else
        l_guildMgr.ReqModifyRecruitWords(l_newMsg)
    end
end
--lua custom scripts end
