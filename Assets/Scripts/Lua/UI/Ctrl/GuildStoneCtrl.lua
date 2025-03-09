--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildStonePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local fxEndPath = "Effects/Prefabs/Creature/Ui/Fx_Ui_DiaoZhuo_end"
local fxIngPath = "Effects/Prefabs/Creature/Ui/Fx_Ui_DiaoZhuo_ing"
--next--
--lua fields end

--lua class define
GuildStoneCtrl = class("GuildStoneCtrl", super)
--lua class define end

--lua functions
function GuildStoneCtrl:ctor()

    super.ctor(self, CtrlNames.GuildStone, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

    --self.GroupMaskType = GroupMaskType.Show
    --self.MaskColor = BlockColor.Transparent
    --self.ClosePanelNameOnClickMask = UI.CtrlNames.GuildStone

end --func end
--next--
function GuildStoneCtrl:Init()

    self.panel = UI.GuildStonePanel.Bind(self)
    super.Init(self)

    self.effect = {}
    self.mgr = MgrMgr:GetMgr("StoneSculptureMgr")
    self.data = DataMgr:GetData("GuildData")
    self.panel.BtnClose:AddClick(function()
        local l_ui = UIMgr:GetUI(UI.CtrlNames.GuildStoneDetail)
        if l_ui then
            self.mgr.SendGetCobblestoneInfo(MPlayerInfo.UID)
        end
        UIMgr:DeActiveUI(CtrlNames.GuildStone)
    end, true)

    self.panel.Describe.LabText = Lang("Stone_UI_Text")
    self.panel.BtnHelp:AddClick(function()
        self.mgr.SendAskForCarveStone()
    end, true)
    self.panel.BtnDetail:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.GuildStoneDetail)
        UIMgr:ActiveUI(CtrlNames.GuildStoneDetail)
    end, true)
    self.panel.BtnGift:AddClick(function()
        if tostring(MPlayerInfo.UID) == tostring(self.mgr.StoneData.roleId) then
            if self.mgr.StoneHelpData.giftNum == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STONE_GIFT_NO_ENOUGH"))
                return
            end
            UIMgr:ActiveUI(CtrlNames.GuildStoneHelp)
        else
            self.mgr.SendGetCobblestoneInfo(MPlayerInfo.UID)
        end
    end, true)
    self.redSign = self:NewRedSign({
        Key = eRedSignKey.GuildStone,
        RedSignParent = self.panel.BtnGift.Transform
    })
    self.head2D = {}
    for i = 1, 2, 1 do
        self.head2D[i] = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.panel.Head[i].transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    self.panel.StoneQuestion.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_STONE_LONG_DESCRIBE"), ed, Vector2(0, 1), false)
    end
    self.mgr.GetGuildStoneHelper()

end --func end
--next--
function GuildStoneCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self:InitAllEffect()
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    self.redSign = nil
    self.effect = nil
    for i = 1, 2, 1 do
        self.head2D[i] = nil
    end
    self.head2D = nil

end --func end

--next--
function GuildStoneCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == self.data.EUIOpenType.GuildStone then
            local roleId = self.uiPanelData.roleId and self.uiPanelData.roleId or MPlayerInfo.UID
            self.mgr.SendGetCobblestoneInfo(roleId)
        end
    end

    self.panel.Describe:SetActiveEx(false)
    self.panel.BtnHelp:SetActiveEx(false)
    self.panel.BtnGift:SetActiveEx(false)
    self.panel.BtnDetail:SetActiveEx(false)
    for i = 1, #self.panel.RawImage do
        self.panel.RawImage[i].gameObject:SetActiveEx(false)
    end

end --func end
--next--
function GuildStoneCtrl:OnDeActive()

end --func end
--next--
function GuildStoneCtrl:Update()


end --func end

--next--
function GuildStoneCtrl:BindEvents()

    --刷新所有数据
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.StoneData, function(self)
        self:Refresh()
    end)

    self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.HelperData, function(self)
        self:RefreshGiftButton()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildStoneCtrl:NowStone(data)

    local num = data.coin
    if data.count < self.mgr.ProgressMax or (data.count == self.mgr.ProgressMax and (not data.hasGiftNormal)) then
        num = num + 1
    end
    return num

end

function GuildStoneCtrl:RefreshGiftButton()

    self.panel.BtnGift:SetGray(self.mgr.StoneHelpData.giftNum == 0 and
            tostring(MPlayerInfo.UID) == tostring(self.mgr.StoneData.roleId))

end

function GuildStoneCtrl:InitAllEffect()

    for k, v in pairs(self.effect) do
        if v ~= nil then
            self:DestroyUIEffect(v)
        end
    end
    self.effect = {}

end

function GuildStoneCtrl:Refresh()

    local l_beginnerGuideChecks = {"SouvenirStoneGuide1"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())

    for i = 1, #self.panel.Stone do
        self.panel.Stone[i]:AddClick(function()                       --雕刻原石
            local data = self.mgr.StoneData
            if i == self:NowStone(data) then
                if data.count < self.mgr.ProgressMax then           --原石雕刻未完成
                    self.mgr.SendCarveStone(data.roleId)
                else
                    if tostring(MPlayerInfo.UID) == tostring(data.roleId) then
                        if data.coin < self.mgr.PerfectStoneNum then          --你还未达到周上限
                            self.mgr.SendMakeStone()                            --制作原石
                        else
                            self.mgr.SendMakeSouvenirStone()                    --制作精致的纪念币
                        end
                    else
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STONE_CARVE_FULL"))       --该纪念原石已完成雕刻
                    end
                end
            elseif i > self:NowStone(data) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STONE_CARVE_NO_PREPARE"))       --该纪念原石还未开始雕刻哦，请先完成前面的原石雕刻
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STONE_CARVE_FULL"))       --该纪念原石已完成雕刻
            end
        end, true)
    end

    local data = self.mgr.StoneData
    self:InitAllEffect()
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    if (not data.roleId) or data.roleId == -1 then
        UIMgr:DeActiveUI(CtrlNames.GuildStone)                              --获取原石数据失败
        return
    end

    for i = 1, #self.panel.Stone do
        if i < self:NowStone(data) then
            self:InitSingleStone((i - 1) * self.mgr.ProgressMax, self.mgr.ProgressMax)
        elseif i == self:NowStone(data) then
            self:InitSingleStone((i - 1) * self.mgr.ProgressMax, data.count)
            self:UpdateLeftPanel(data, i)
        else
            self:InitSingleStone((i - 1) * self.mgr.ProgressMax, 0)
        end
    end
    self.panel.StoneSliderTxt.LabText = StringEx.Format("{0}/{1}", data.count, self.mgr.ProgressMax)
    self.panel.StoneSliderImg.RectTransform.sizeDelta = Vector2(242 * (data.count / self.mgr.ProgressMax), 14)
    if data.coin == self.mgr.PerfectStoneNum then
        l_beginnerGuideChecks = {"SouvenirStoneGuide2"}
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end

end

function GuildStoneCtrl:InitSingleStone(index, count)

    for i = index + 1, index + self.mgr.ProgressMax do
        self.panel.Patch[i]:SetActiveEx(i - index <= count)
    end
    self.panel.Perfect[index / 10 + 1]:SetActiveEx(count == self.mgr.ProgressMax)

end

function GuildStoneCtrl:UpdateLeftPanel(data, index)

    self.panel.BtnGift:SetActiveEx(true)
    self:RefreshGiftButton()
    if tostring(MPlayerInfo.UID) == tostring(self.mgr.StoneData.roleId) then
        self.panel.Describe:SetActiveEx(true)
        self.panel.BtnHelp:SetActiveEx(true)
        self.panel.BtnDetail:SetActiveEx(true)
        self.panel.HelpBG:SetActiveEx(true)
        self:InitHelpBG(self.mgr.StoneData.show)
        self.panel.BtnGiftText.LabText = Lang("GIFTSTONE_GIVE")
        if data.count < self.mgr.ProgressMax then
            if data.hasCarved ~= 0 then
                self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_2")            --自己的纪念币/未完成/已经雕琢：本次已经雕琢
            else
                self:CreateEffects(fxIngPath, index)
                self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_1")            --自己的纪念币/未完成/还未雕琢：点击进行雕琢
            end
        else
            if data.coin < self.mgr.PerfectStoneNum then
                self:CountDownStart(data.cd, self.panel.StoneLeftDes, "STONE_CARVE_HINT_8")   --自己的纪念币/未完成5次：{0:00}:{1:00}后进入下一阶段
                if not data.hasGiftNormal then
                    self:CreateEffects(fxEndPath, index)
                end
            else
                if not data.hasGiftPerfect then
                    self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_7")            --自己的纪念币/已完成5次：领取之后进入下一轮雕琢
                    self:CreateEffects(fxEndPath, index)
                else
                    self:CountDownStart(data.cd, self.panel.StoneLeftDes, "STONE_CARVE_HINT_9")  --自己的纪念币/已完成5次：{0:00}:{1:00}后进入下一轮雕琢
                end
            end
        end
    else
        self.panel.BtnGiftText.LabText = Lang("MYGUILDSTONE")
        self.panel.HelpBG:SetActiveEx(false)
        if data.count < self.mgr.ProgressMax then
            if data.hasCarved == 1 then
                self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_3")            --别人的纪念币/未完成/已经雕琢：已经帮TA雕琢
            elseif data.hasCarved == 2 then
                self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_10")           --别人的纪念币/未完成/还未雕琢但是你的次数不足：当日雕刻次数已达上限
            elseif data.hasCarved == 0 then
                self:CreateEffects(fxIngPath, index)
                self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_1")            --别人的纪念币/未完成/还未雕琢：点击帮助TA雕琢
            end
        else
            if data.coin < self.mgr.PerfectStoneNum then
                self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_5")            --别人的纪念币/已完成/未完成5次：已完成的纪念币
            else
                self.panel.StoneLeftDes.LabText = Lang("STONE_CARVE_HINT_6")            --别人的纪念币/已完成5次：已完成的精致纪念币
            end
        end
    end

end

function GuildStoneCtrl:InitHelpBG(player)

    self.panel.Player[1]:SetActiveEx(player and player[1] ~= nil)
    self.panel.Player[2]:SetActiveEx(player and player[2] ~= nil)
    if player and player[1] ~= nil then
        player[1].equip_ids = {}
        self.panel.HelpName[1].LabText = player[1].carver_name
        local param = {
            OnClick = function() Common.CommonUIFunc.RefreshPlayerMenuLByUid(player[1].carver_id) end,
            OnClickSelf = self,
            ShowProfession = true,
            Profession = player[1].profession,
            EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(player[1])
        }
        self.head2D[1]:SetData(param)
    end
    if player and player[2] ~= nil then
        player[2].equip_ids = {}
        self.panel.HelpName[2].LabText = player[2].carver_name
        local param = {
            OnClick = function() Common.CommonUIFunc.RefreshPlayerMenuLByUid(player[2].carver_id) end,
            OnClickSelf = self,
            ShowProfession = true,
            Profession = player[2].profession,
            EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(player[2])
        }
        self.head2D[2]:SetData(param)
    end

end

function GuildStoneCtrl:CreateEffects(fxPath, index)

    if self.effect[index] ~= nil then
        self:DestroyUIEffect(self.effect[index])
        self.effect[index] = nil
    end

    local l_fxViewCom = self.panel.RawImage[index]
    local l_fxPath = fxPath
    local l_fxData_effect = {}
    l_fxData_effect.rawImage = l_fxViewCom.RawImg
    l_fxData_effect.loadedCallback = function()
        l_fxViewCom.gameObject:SetActiveEx(true)
    end
    l_fxData_effect.destroyHandler = function()
        self.effect[index] = nil
    end
    self.effect[index] = self:CreateUIEffect(l_fxPath, l_fxData_effect)
end

function GuildStoneCtrl:CountDownStart(time, ui, str)

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    ui.LabText = Lang(str, math.floor(time / 3600), math.floor(time / 60) % 60)
    self.timer = self:NewUITimer(function()
        time = time - 1
        if time >= 0 then
            ui.LabText = Lang(str, math.floor(time / 3600), math.floor(time / 60) % 60)
        end
    end, 1, -1)
    self.timer:Start()

end
--lua custom scripts end
return GuildStoneCtrl