--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildChangePositionPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildChangePositionCtrl = class("GuildChangePositionCtrl", super)
--lua class define end

local l_guildMgr = nil
local l_guildData = nil
local l_aimPlayerId = 0
local l_aimPlayerName = nil
local l_selectPositionId = 0
local l_viceChairmanMaxNum = 1
local l_directorMaxNum = 4
local l_deaconMaxNum = 6
local l_beautyMaxNum = 4

--lua functions
function GuildChangePositionCtrl:ctor()

    super.ctor(self, CtrlNames.GuildChangePosition, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function GuildChangePositionCtrl:Init()

    self.panel = UI.GuildChangePositionPanel.Bind(self)
    super.Init(self)

    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildData = DataMgr:GetData("GuildData")

    l_selectPositionId = 0
    --管理职位最大数量获取
    l_viceChairmanMaxNum = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NumberOfViceChairman").Value)
    l_directorMaxNum = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NumberOfDirector").Value)
    l_deaconMaxNum = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NumberOfDeacon").Value)
    l_beautyMaxNum = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NumberOfBeauty").Value)

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildChangePosition)
    end)

    --确认按钮点击
    self.panel.BtnSure:AddClick(function()
        --转让会长需要弹对话框提示 未选中的情况在ChangePosition中处理
        if l_selectPositionId == 1 then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, StringEx.Format(Lang("GUILD_TRANSFER_CHAIRMAN_TEXT"), l_aimPlayerName),
                function()
                    self:ChangePosition()
                end)
        else
            self:ChangePosition()
        end
    end)

    --选择框点击事件初始化
    self:InitTogClickEvent()

    --根据自己权限显示可设置的职务
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.Chairmen then --会长以下不显示 会长、副会长、理事和魅力担当
        self.panel.TogGuildChange1.UObj:SetActiveEx(false)
        self.panel.TogGuildChange2.UObj:SetActiveEx(false)
        self.panel.TogGuildChange3.UObj:SetActiveEx(false)
        self.panel.TogGuildChange4.UObj:SetActiveEx(false)
    end
    self.panel.TogGuildChange4.UObj:SetActiveEx(false)      --TODO 暂时屏蔽魅力担当的任命
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman then --副会长以下不显示 执事
        self.panel.TogGuildChange5.UObj:SetActiveEx(false)
    end

end --func end
--next--
function GuildChangePositionCtrl:Uninit()

    l_selectPositionId = 0
    l_guildMgr = nil
    l_guildData = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildChangePositionCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == l_guildData.EUIOpenType.GuildChangePosition then
            self:GuildChangePositionShow(self.uiPanelData.memberData)
        end
    end

end --func end
--next--
function GuildChangePositionCtrl:OnDeActive()

end --func end
--next--
function GuildChangePositionCtrl:Update()

end --func end


--next--
function GuildChangePositionCtrl:BindEvents()
    --dont override this function
end --func end

--next--
--lua functions end

--lua custom scripts
--职位修改界面展示
function GuildChangePositionCtrl:GuildChangePositionShow(memberData)

    self:SetAimPlayerDetail(memberData.baseInfo.roleId, memberData.baseInfo.name, memberData.position)
    UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)

end

--设置目标玩家信息
--playerId 玩家ID
--playerName 玩家名字  （转移会长的时候用）
--positionId 玩家职位ID
function GuildChangePositionCtrl:SetAimPlayerDetail(playerId, playerName, positionId)

    l_aimPlayerId = playerId
    l_aimPlayerName = playerName or ""
    self.panel.TxtCurPosition.LabText = Lang("CURRENT_POSITION_TEXT")..l_guildData.GetPositionName(positionId)
    if positionId == l_guildData.EPositionType.Beauty then
        self.panel["TogGuildChange4"].UObj:SetActiveEx(false)
    elseif positionId == l_guildData.EPositionType.Deacon then      --策划一定要让魅力担当显示在在执事和理事中间，尽管这和权限的等级排序不一致
        self.panel["TogGuildChange5"].UObj:SetActiveEx(false)
    else
        self.panel["TogGuildChange" .. positionId].UObj:SetActiveEx(false)
    end

end
--初始化选择框按钮点击事件
function GuildChangePositionCtrl:InitTogClickEvent()

    --会长
    self.panel.Describe1.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_POSITION_DESCRIBE_1"), ed, Vector2(0, 1), false)
    end
    self.panel.txtPostion1.LabText = Lang("CHAIRMAN_TOGGLE_TITLE")
    self.panel.TogGuildChange1:AddClick(function()
        self.panel.TogGuildChange1.Transform:GetChild(0):GetComponent("Toggle").isOn = true
        l_selectPositionId = 1
    end)

    --副会长
    self.panel.Describe2.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_POSITION_DESCRIBE_2"), ed, Vector2(0, 1), false)
    end
    self.panel.txtPostion2.LabText = StringEx.Format(Lang("VICECHAIRMAN_TOGGLE_TITLE"), tostring(l_guildData.curViceChairmanNum), tostring(l_viceChairmanMaxNum))
    self.panel.TogGuildChange2:AddClick(function()
        if l_guildData.curViceChairmanNum < l_viceChairmanMaxNum then
            self.panel.TogGuildChange2.Transform:GetChild(0):GetComponent("Toggle").isOn = true
            l_selectPositionId = 2
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_IS_FULL"))
        end
    end)

    --理事
    self.panel.Describe3.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_POSITION_DESCRIBE_3"), ed, Vector2(0, 1), false)
    end
    self.panel.txtPostion3.LabText = StringEx.Format(Lang("DIRECTOR_TOGGLE_TITLE"), tostring(l_guildData.curDirectorNum), tostring(l_directorMaxNum))
    self.panel.TogGuildChange3:AddClick(function()
        if l_guildData.curDirectorNum < l_directorMaxNum then
            self.panel.TogGuildChange3.Transform:GetChild(0):GetComponent("Toggle").isOn = true
            l_selectPositionId = 3
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_IS_FULL"))
        end
    end)

    --执事
    self.panel.Describe4.Listener.onClick = function(go, ed)
        local l_timeLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("BeautyJoinTimeLimit").Value)
        local l_actLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("BeautyActiveTimeLimit").Value)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_POSITION_DESCRIBE_4", l_timeLimit, l_actLimit), ed, Vector2(0, 1), false)
    end
    self.panel.txtPostion5.LabText = StringEx.Format(Lang("DEACON_TOGGLE_TITLE"), tostring(l_guildData.curDeaconNum), tostring(l_deaconMaxNum))
    self.panel.TogGuildChange5:AddClick(function()
        if l_guildData.curDeaconNum < l_deaconMaxNum then
            self.panel.TogGuildChange5.Transform:GetChild(0):GetComponent("Toggle").isOn = true
            l_selectPositionId = 4
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_IS_FULL"))
        end
    end)

    --魅力担当
    self.panel.Describe5.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_POSITION_DESCRIBE_5"), ed, Vector2(0, 1), false)
    end
    self.panel.txtPostion4.LabText = StringEx.Format(Lang("BEAUTY_TOGGLE_TITLE"), tostring(l_guildData.curBeautyNum), tostring(l_beautyMaxNum))
    self.panel.TogGuildChange4:AddClick(function()
        if l_guildData.curDeaconNum < l_beautyMaxNum then
            self.panel.TogGuildChange4.Transform:GetChild(0):GetComponent("Toggle").isOn = true
            l_selectPositionId = 5
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_IS_FULL"))
        end
    end)

    --自定义成员 1
    local l_specialName1 = l_guildData.GetPositionName(l_guildData.EPositionType.Special_1)
    if #l_specialName1 > 0 then
        self.panel.txtPostion6.LabText = l_specialName1
        self.panel.TogGuildChange6.CanvasGroup.alpha = 1
        self.panel.TogGuildChange6:AddClick(function()
            self.panel.TogGuildChange6.Transform:GetChild(0):GetComponent("Toggle").isOn = true
            l_selectPositionId = 6
        end)
    else
        self.panel.txtPostion6.LabText = Lang("CUSTOMIZE_GUILD_POSTION_NO_SET").." 1"
        self.panel.TogGuildChange6.CanvasGroup.alpha = 0.36
        self.panel.TogGuildChange6:AddClick(function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_NOT_EDITED"))
        end)
    end

    --自定义成员 2
    local l_specialName2 = l_guildData.GetPositionName(l_guildData.EPositionType.Special_2)
    if #l_specialName2 > 0 then
        self.panel.txtPostion7.LabText = l_specialName2
        self.panel.TogGuildChange7.CanvasGroup.alpha = 1
        self.panel.TogGuildChange7:AddClick(function()
            self.panel.TogGuildChange7.Transform:GetChild(0):GetComponent("Toggle").isOn = true
            l_selectPositionId = 7
        end)
    else
        self.panel.txtPostion7.LabText = Lang("CUSTOMIZE_GUILD_POSTION_NO_SET").." 2"
        self.panel.TogGuildChange7.CanvasGroup.alpha = 0.36
        self.panel.TogGuildChange7:AddClick(function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_NOT_EDITED"))
        end)
    end

    --成员
    self.panel.TogGuildChange8:AddClick(function()
        self.panel.TogGuildChange8.Transform:GetChild(0):GetComponent("Toggle").isOn = true
        l_selectPositionId = 8
    end)

end

--改变职位
function GuildChangePositionCtrl:ChangePosition()

    --有选中职位则请求 无选中则直接关闭
    if l_selectPositionId ~= 0 then
        l_guildMgr.ReqAppoint(l_aimPlayerId, l_selectPositionId)
    end
    UIMgr:DeActiveUI(UI.CtrlNames.GuildChangePosition)

end
--lua custom scripts end
return GuildChangePositionCtrl
