--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ThemeDungeonTeamPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ThemeDungeonTeamCtrl = class("ThemeDungeonTeamCtrl", super)
--lua class define end

--lua functions
function ThemeDungeonTeamCtrl:ctor()

    super.ctor(self, CtrlNames.ThemeDungeonTeam, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function ThemeDungeonTeamCtrl:Init()

    self.panel = UI.ThemeDungeonTeamPanel.Bind(self)
    super.Init(self)
    self.DelagateTip = false
    self:OnInit()
end --func end
--next--
function ThemeDungeonTeamCtrl:Uninit()

    self:OnUninit()
    self.DungeonData = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ThemeDungeonTeamCtrl:OnActive()
    if self.uiPanelData.dungeonID then
        self:SetDungeonInfo(self.uiPanelData.dungeonID)
    elseif self.uiPanelData.sceneID then
        self:SetSceneInfo(self.uiPanelData.sceneID)
    end
end --func end
--next--
function ThemeDungeonTeamCtrl:OnDeActive()
    MgrMgr:GetMgr("DungeonMgr").OnResetTime()

end --func end
--next--
function ThemeDungeonTeamCtrl:Update()


end --func end


--next--
function ThemeDungeonTeamCtrl:OnReconnected()
    super.OnReconnected(self)
    MgrMgr:GetMgr("DungeonMgr").TeamCheckStartTime = nil
    UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
end --func end
--next--
function ThemeDungeonTeamCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("DungeonMgr").EventDispatcher, MgrMgr:GetMgr("DungeonMgr").SYNC_MEMBER_REPLY_ENTER_FB_NTF, function(self, roleId)
        self:SetSelfButtonGray(roleId)
        self:UpdatePanel(roleId)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
local m_time = 10
local m_timer = nil

local m_item = {} ---ui item   第一个为队长

function ThemeDungeonTeamCtrl:OnInit()
    if m_timer ~= nil then
        self:StopUITimer(m_timer)
        m_timer = nil
    end
    self.panel.AgreeBtn:AddClick(function()
        if MgrMgr:GetMgr("DungeonMgr").IsThemeDungeonTeamBtnClicked then
            return
        end
        MgrMgr:GetMgr("DungeonMgr").IsThemeDungeonTeamBtnClicked = true
        MgrMgr:GetMgr("DungeonMgr").SendMemberReplyEnterFBPtc(ReplyType.REPLY_TYPE_AGREE)
    end)
    self.panel.RefusedBtn:AddClick(function()
        if MgrMgr:GetMgr("DungeonMgr").IsThemeDungeonTeamBtnClicked then
            return
        end
        MgrMgr:GetMgr("DungeonMgr").IsThemeDungeonTeamBtnClicked = true
        MgrMgr:GetMgr("DungeonMgr").SendMemberReplyEnterFBPtc(ReplyType.REPLY_TYPE_REFUSE)
    end)
    self.timerSlider = self.panel.ThemeDungeonSlider.Slider
    self.timerSlider.enabled = true
    --if MgrMgr:GetMgr("DungeonMgr").TeamCheckStartTime == nil then
    --    UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
    --    return
    --end
    local l_tp = self.panel.InfoItem.gameObject
    self.panel.InfoItem.gameObject:SetActiveEx(false)
    for k, v in pairs(MgrMgr:GetMgr("DungeonMgr").g_teamInfo) do
        if v.onlineState then
            local l_temp = self:CloneObj(l_tp)
            l_temp.transform:SetParent(l_tp.gameObject.transform.parent)
            l_temp.transform.localScale = l_tp.transform.localScale
            l_temp.transform.gameObject:SetActiveEx(true)
            local l_roleId = v.roleId
            m_item[l_roleId] = {}
            m_item[l_roleId].uiCloneObj = l_temp
            m_item[l_roleId].obj = l_temp:GetComponent("MLuaUICom")
            m_item[l_roleId].Img = m_item[l_roleId].obj.gameObject.transform:Find("Image").gameObject:GetComponent("MLuaUICom")
            m_item[l_roleId].HeadIconBg = m_item[l_roleId].obj.gameObject.transform:Find("HeadBg").gameObject:GetComponent("MLuaUICom")
            m_item[l_roleId].NameLab = MLuaClientHelper.GetOrCreateMLuaUICom(m_item[l_roleId].obj.gameObject.transform:Find("NameLab").gameObject)
            m_item[l_roleId].AgreenLab = m_item[l_roleId].obj.gameObject.transform:Find("StateLab1").gameObject
            m_item[l_roleId].WaitLab = m_item[l_roleId].obj.gameObject.transform:Find("StateLab2").gameObject
            m_item[l_roleId].RefuseLab = m_item[l_roleId].obj.gameObject.transform:Find("StateLab1").gameObject
            m_item[l_roleId].RefuseLab = m_item[l_roleId].obj.gameObject.transform:Find("StateLab1").gameObject
            m_item[l_roleId].obj.gameObject.transform:Find("Mercenaryicon").gameObject:SetActiveEx(false)
            local l_isCaptain = tostring(v.roleId) == tostring(DataMgr:GetData("TeamData").myTeamInfo.captainId)
            m_item[l_roleId].obj.gameObject.transform:Find("LeadFlag").gameObject:SetActiveEx(l_isCaptain)

            m_item[l_roleId].NameLab.LabText = self:GetPlayerNameById(v.roleId) --MgrMgr:GetMgr("TeamMgr").GetNameById(v.roleId)
            local l_imageName = DataMgr:GetData("TeamData").GetProfessionImageById(v.roleType)
            if l_imageName then
                m_item[l_roleId].Img:SetSpriteAsync("Common", l_imageName)
            end

            -- 头像
            if not m_item[l_roleId].head2d then
                m_item[l_roleId].head2d = self:NewTemplate("HeadWrapTemplate", {
                    TemplateParent = m_item[l_roleId].HeadIconBg.transform,
                    TemplatePath = "UI/Prefabs/HeadWrapTemplate"
                })
            end
            local param = {
                EquipData = v.roleHead,
            }
            m_item[l_roleId].head2d:SetData(param)

            m_item[l_roleId].AgreenLab:SetActiveEx(false)
            m_item[l_roleId].WaitLab:SetActiveEx(false)
            m_item[l_roleId].RefuseLab:SetActiveEx(false)
            if v.state == ReplyType.REPLY_TYPE_AGREE then
                m_item[l_roleId].AgreenLab:SetActiveEx(true)
                self:SetSelfButtonGray(l_roleId)
            end
            if v.state == ReplyType.REPLY_TYPE_REFUSE then
                m_item[l_roleId].RefuseLab:SetActiveEx(true)
                self:SetSelfButtonGray(l_roleId)
            end
            if v.state == -1 then
                m_item[l_roleId].WaitLab:SetActiveEx(true)
            end
        end
    end
end

--这个是在打开界面的回掉里面调用的
function ThemeDungeonTeamCtrl:SetDungeonInfo(id)
    local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(id)
    if l_dungeonData == nil then
        logError("不存在的场景DungeonID => " .. tostring(id))
        return
    end
    m_time = MGlobalConfig:GetInt("TeamEnterDungeonConfirmTime") or 10
    self.DungeonData = l_dungeonData
    self.panel.ThemeDungeonNameLab.LabText = Lang("DUNGEONS_WAIT_ENTER", l_dungeonData.DungeonsName)
    self:SetAssist()
    self:SetMercenary(l_dungeonData.SceneID)
    self:SetTimer()
    self:CheckGuildHuntDifficult(id)
    self:SetDelegateInfo(id)

end
function ThemeDungeonTeamCtrl:SetSceneInfo(id)
    local l_sceneData = TableUtil.GetSceneTable().GetRowByID(id)
    if l_sceneData == nil then
        logError("不存在的场景SceneID => " .. tostring(id))
        return
    end
    m_time = MGlobalConfig:GetInt("TeamEnterDungeonConfirmTime") or 10
    self.panel.ThemeDungeonNameLab.LabText = Lang("DUNGEONS_WAIT_ENTER", l_sceneData.Comment)
    self:SetMercenary(id)
    self:SetTimer()
    self.panel.Tip:SetActiveEx(false)
end

function ThemeDungeonTeamCtrl:SetDelegateInfo(id)
    local tip, colorStr = MgrMgr:GetMgr("DelegateModuleMgr").GetDungeonAgreeTip(id)
    self.panel.Tip:SetActiveEx(tip ~= nil)
    self.DelagateTip = tip ~= nil
    if tip then
        self.panel.TipText.LabText = GetColorText(tip, colorStr)
        if colorStr == RoColorTag.Red then
            self.panel.DelegateTipIcon:SetSpriteAsync("Common", "UI_common_Tishi_01.png")
        else
            local itemSdata = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.Certificates)
            self.panel.DelegateTipIcon:SetSpriteAsync(itemSdata.ItemAtlas, itemSdata.ItemIcon)
        end
    end
end

--确认公会狩猎难度  简单难度需要单独提示
function ThemeDungeonTeamCtrl:CheckGuildHuntDifficult(id)
    local l_easyIdsStr = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingEasyDungeon").Value
    local l_easyIds = string.ro_split(l_easyIdsStr, "|")
    for i = 1, #l_easyIds do
        if tonumber(l_easyIds[i]) == id then
            self.panel.Tip:SetActiveEx(true)
            self.panel.TipText.LabText = Lang("GUILD_HUNT_DUNGEONS_EASY_TIP")
            return
        end
    end
end

function ThemeDungeonTeamCtrl:SetTimer()
    local time = MgrMgr:GetMgr("DungeonMgr").TeamCheckStartTime
    time = time and time or Time.realtimeSinceStartup
    self.index = Time.realtimeSinceStartup - time
    self.timerSlider.value = (m_time - self.index) / m_time
    if m_timer ~= nil then
        self:StopUITimer(m_timer)
        m_timer = nil
    end
    m_timer = self:NewUITimer(function()
        self.index = self.index + 0.1
        self.timerSlider.value = (m_time - self.index) / m_time
        if m_time < self.index then
            MgrMgr:GetMgr("DungeonMgr").TeamCheckStartTime = nil
            self:OnTimeFinish()
        end
    end, 0.1, -1, true)
    m_timer:Start()
end

function ThemeDungeonTeamCtrl:SetMercenary(Id)
    local l_showMercenaryText = 0
    local l_sceneData = TableUtil.GetSceneTable().GetRowByID(Id, true)
    l_showMercenaryText = l_sceneData and l_sceneData.MerceneryNotAllow or 0
    local showMercenary = l_showMercenaryText ~= 1
    self.panel.MercenaryPanel.gameObject:SetActiveEx(not showMercenary)
    local l_mercenaryList = DataMgr:GetData("TeamData").myTeamInfo.mercenaryList
    if showMercenary and l_mercenaryList then
        local l_tp = self.panel.InfoItem.gameObject
        for k, v in pairs(l_mercenaryList) do
            local l_temp = self:CloneObj(l_tp)
            l_temp.transform:SetParent(l_tp.gameObject.transform.parent)
            l_temp.transform.localScale = l_tp.transform.localScale
            l_temp.transform.gameObject:SetActiveEx(true)
            m_item[v.Id] = {}
            m_item[v.Id].uiCloneObj = l_temp
            local l_tempCom = l_temp:GetComponent("MLuaUICom")
            local l_row = TableUtil.GetMercenaryTable().GetRowById(v.Id)
            local l_imageName = DataMgr:GetData("TeamData").GetProfessionImageById(l_row.Profession)
            if l_imageName then
                l_tempCom.gameObject.transform:Find("Image").gameObject:GetComponent("MLuaUICom"):SetSpriteAsync("Common", l_imageName)
            end
            l_tempCom.gameObject.transform:Find("StateLab1").gameObject:SetActiveEx(true)
            MLuaClientHelper.GetOrCreateMLuaUICom(l_tempCom.gameObject.transform:Find("NameLab").gameObject).LabText = Lang("TEAM_MERCENARY", l_row.Name)
            l_tempCom.gameObject.transform:Find("Mercenaryicon").gameObject:SetActiveEx(true)
            local l_headIconBg = l_tempCom.gameObject.transform:Find("HeadBg").gameObject:GetComponent("MLuaUICom")
            local l_attr = MUIModelManagerEx:GetAttrByData(l_row.DefaultEquipID, l_row.PresentID)
            -- 头像
            if not m_item[v.Id].head2d then
                m_item[v.Id].head2d = self:NewTemplate("HeadWrapTemplate", {
                    TemplateParent = l_headIconBg.transform,
                    TemplatePath = "UI/Prefabs/HeadWrapTemplate"
                })
            end
            local param = {
                EquipData = l_attr.EquipData,
            }
            m_item[v.Id].head2d:SetData(param)
        end
    end
end

--助战相关信息设置
function ThemeDungeonTeamCtrl:SetAssist()
    if self.DungeonData then
        --策划需求主体副本显示助战
        local assistDungonTypeTb = MGlobalConfig:GetSequenceOrVectorInt("AssistDungeonTypeList")
        local dayMax, weekMax, showLab = self:CheckAssistMaxState()
        local needShowAssist = false
        local needShowAssistTips = false
        for i = 1, assistDungonTypeTb.Length do
            if assistDungonTypeTb[i - 1] == self.DungeonData.DungeonsType then
                needShowAssist = true
                break
            end
        end

        --大秘境逻辑 暂时注释
        --[[
        if dayMax or weekMax then
            needShowAssist = false
            needShowAssistTips = true
        end
        ]]--

        self.panel.AssistPanel:SetActiveEx(needShowAssist or needShowAssist)
        self.panel.TglAssist:SetActiveEx(needShowAssist)
        self.panel.AssistLabTips:SetActiveEx(needShowAssistTips)

        if needShowAssist then

            m_time = m_time + self:GetAssistAdditionalTime()
            self.panel.TglAssist.Tog.onValueChanged:AddListener(function(value)
                if (dayMax or weekMax) and value then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(showLab)
                end
                MgrMgr:GetMgr("DungeonMgr").SetIsAssist(value)
                self.panel.Tip:SetActiveEx(self.DelagateTip and not value)
            end)
            --默认设置
            if MgrMgr:GetMgr("DungeonMgr").DefaultAssist then
                self.panel.AssistLab.LabText = Lang("AssistLimitLableText")
                self.panel.Tip:SetActiveEx(false)
            else
                self.panel.AssistLab.LabText = Lang("AssistLableText")
            end
            self.panel.TglAssist.Tog.isOn = MgrMgr:GetMgr("DungeonMgr").DefaultAssist
            self.panel.TglAssist.Tog.enabled = not MgrMgr:GetMgr("DungeonMgr").DefaultAssist
        end

        if needShowAssistTips then
            self.panel.AssistLabTips.LabText = showLab
            MgrMgr:GetMgr("DungeonMgr").SetIsAssist(true)
        end
    else
        self.panel.AssistPanel.gameObject:SetActiveEx(false)
    end
end

function ThemeDungeonTeamCtrl:CheckAssistMaxState()
    local leftDayCount = MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ASSISTDAY, '701')
    local leftWeekCount = MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ASSISTWEEK, '701')
    local dayAssistMax = false
    local weekAssistMax = false
    local showLab = ""
    if leftDayCount <= 0 then
        dayAssistMax = true
        --showLab = Common.Utils.Lang("TIPS_ASSIST_DAY_MAX")
    end
    if leftWeekCount <= 0 then
        weekAssistMax = true
        --showLab = Common.Utils.Lang("TIPS_ASSIST_WEEK_MAX")
    end
    return dayAssistMax, weekAssistMax, showLab
end

--获取助战的额外时间
function ThemeDungeonTeamCtrl:GetAssistAdditionalTime()
    return MGlobalConfig:GetInt("AssistAdditionalTime") or 0
end

function ThemeDungeonTeamCtrl:OnTimeFinish()
    --某些副本超时后自动同意
    if self.DungeonData ~= nil and self.DungeonData.AutoConfirmWhenExpired then
        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
        return
    end

    --提示xxx拒绝
    local tips = ""
    for i = 1, #MgrMgr:GetMgr("DungeonMgr").g_teamInfo do
        local l_target = MgrMgr:GetMgr("DungeonMgr").g_teamInfo[i]
        if l_target.state == -1 then
            tips = i ~= #MgrMgr:GetMgr("DungeonMgr").g_teamInfo and tips .. l_target.roleName .. "," or tips .. l_target.roleName
        end
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tips .. Common.Utils.Lang("NO_AGREE_TIPS"))
    UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
end

function ThemeDungeonTeamCtrl:GetPlayerNameById(uid)
    return tostring(uid) == tostring(MPlayerInfo.UID) and
            GetColorText(DataMgr:GetData("TeamData").GetNameById(uid), RoColorTag.Blue) or
            DataMgr:GetData("TeamData").GetNameById(uid)
end

function ThemeDungeonTeamCtrl:SetSelfButtonGray(roleId)
    if tostring(roleId) == tostring(MPlayerInfo.UID) then
        self.panel.AgreeBtn:SetGray(true)
        self.panel.RefusedBtn:SetGray(true)
        self.panel.AgreeBtn:AddClick(function()
        end)
        self.panel.RefusedBtn:AddClick(function()
        end)
    end
end

function ThemeDungeonTeamCtrl:OnUninit()
    if m_timer ~= nil then
        self:StopUITimer(m_timer)
        m_timer = nil
    end
    for key, value in pairs(m_item) do
        if value.uiCloneObj then
            MResLoader:DestroyObj(value.uiCloneObj)
        end
        if value.head2d then
            value.head2d = nil
        end
    end
    m_item = {}
end

function ThemeDungeonTeamCtrl:UpdatePanel(roleId)
    if m_item[roleId] == nil then
        return
    end
    for k, v in pairs(MgrMgr:GetMgr("DungeonMgr").g_teamInfo) do
        if v.roleId == roleId then
            m_item[roleId].AgreenLab:SetActiveEx(false)
            m_item[roleId].WaitLab:SetActiveEx(false)
            m_item[roleId].RefuseLab:SetActiveEx(false)
            if v.state == ReplyType.REPLY_TYPE_AGREE then
                m_item[roleId].AgreenLab:SetActiveEx(true)
                self:SetSelfButtonGray(roleId)
                return
            end
            if v.state == ReplyType.REPLY_TYPE_REFUSE then
                m_item[roleId].RefuseLab:SetActiveEx(true)
                self:SetSelfButtonGray(roleId)
                return
            end
            m_item[roleId].WaitLab:SetActiveEx(true)
        end
    end
end
--lua custom scripts end
return ThemeDungeonTeamCtrl