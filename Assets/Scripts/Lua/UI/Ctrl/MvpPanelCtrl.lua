--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MvpPanelPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MvpPanelCtrl = class("MvpPanelCtrl", super)
--lua class define end

--lua functions
function MvpPanelCtrl:ctor()

    super.ctor(self, CtrlNames.MvpPanel, UILayer.Function, nil, ActiveType.Standalone)

    self.InsertPanelName = UI.CtrlNames.DailyTask
    --self:SetParent(UI.CtrlNames.DailyTask)

end --func end
--next--
function MvpPanelCtrl:Init()
    self.panel = UI.MvpPanelPanel.Bind(self)
    super.Init(self)
    self.mvpMgr = MgrMgr:GetMgr("MvpMgr")

    --遮罩设置
    local l_func = function()
        self:Destroy3DModel()
        UIMgr:DeActiveUI(UI.CtrlNames.MvpPanel)
    end

    self.mask = self:NewPanelMask(BlockColor.Transparent, nil, l_func)

    --self:SetBlockOpt(BlockColor.Transparent, l_func)

    self.lastTime = -1
    self.starTime = Time.realtimeSinceStartup

    --团队奖励
    self.TeamAwardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.normalRewardWrapContent.transform
    })
    --个人奖励
    self.PrivatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.specialRewardWrapContent.transform
    })
    self:OnInit()

end --func end
--next--
function MvpPanelCtrl:Uninit()


    self.TeamAwardPool = nil
    self.PrivatePool = nil
    self:OnUninit()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MvpPanelCtrl:OnActive()


end --func end
--next--
function MvpPanelCtrl:OnDeActive()


end --func end
--next--
function MvpPanelCtrl:Update()
    if self.monsterEntity and self.lastTime > 0 then
        self.lastTime = self.lastTime - (Time.realtimeSinceStartup - self.starTime)
        self.starTime = Time.realtimeSinceStartup
        if self.monsterEntity and self.lastTime <= 0 then
            self.monsterEntity.Ator:OverrideAnim("Idle", self.IdleAnimPath)
        end
    end

end --func end

--next--
function MvpPanelCtrl:BindEvents()
    local l_awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self:BindEvent(self.mvpMgr.EventDispatcher, self.mvpMgr.GET_MVP_INFO_SUCCESS, function()
        self:InitMvpPanel()
    end)
    self:BindEvent(self.mvpMgr.EventDispatcher, self.mvpMgr.GET_MVP_RANK_INFO_SUCCESS, function()
        if not UIMgr:IsActiveUI(UI.CtrlNames.MvpTeam) then
            UIMgr:ActiveUI(UI.CtrlNames.MvpTeam)
        end
    end)
    self:BindEvent(l_awardPreviewMgr.EventDispatcher, l_awardPreviewMgr.AWARD_PREWARD_MSG .. "MvpReward", function(object, ...)
        self:RefreshMvpPreviewAwards(...)
    end)

    self:BindEvent(l_awardPreviewMgr.EventDispatcher, l_awardPreviewMgr.AWARD_PREWARD_MSG .. "EntityRandomReward", function(object, ...)
        self:RefreshEntityRandomPreviewAwards(...)
    end)

    local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
    self:BindEvent(l_limitMgr.EventDispatcher, l_limitMgr.MVP_REWARD_UPDATE, function(self, type, id)
        self:RefreshMvpRewardCount()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

local l_timer = nil
local m_bossContentInit = true
local curBossItem = {}
local WrapItemInfo = {}
local allBossItem = {}
local allTimerLab = {}
local allTimeValue = {}
local RefrashType = {
    Timing = "1",
    Random = "2"
}
local l_itemSize = Vector2(72, 72)

function MvpPanelCtrl:OnInit()

    self.panel.mvpPanel.gameObject:SetActiveEx(false)
    self.panel.mvpClose:AddClick(function()
        self:Destroy3DModel()
        UIMgr:DeActiveUI(UI.CtrlNames.MvpPanel)
    end)
    MgrMgr:GetMgr("MvpMgr").SendGetMvpInfoReq()
end

function MvpPanelCtrl:OnUninit()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
    self.mvpMgr = nil
    m_bossContentInit = true
    self:Destroy3DModel()
end

function MvpPanelCtrl:InitMvpPanel()
    self.panel.mvpPanel.gameObject:SetActiveEx(true)
    self:Destroy3DModel()
    self:InitBossView()
    self.panel.GoBtn:AddClick(function()
        local info = WrapItemInfo[MgrMgr:GetMgr("MvpMgr").m_mvpInfo[curBossItem.index + 1].id]
        local l_cp = info.sceneInfo.CanAutoPath
        if not l_cp then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_AUTO_PATH"))
            return
        end
        self:Destroy3DModel()
        MTransferMgr:GotoScene(info.mvpInfo.SceneID)
        UIMgr:DeActiveUI(UI.CtrlNames.MvpPanel)
        if UIMgr:IsActiveUI(UI.CtrlNames.DailyTask) then
            UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
        end
        if UIMgr:IsActiveUI(UI.CtrlNames.HeadShop) then
            UIMgr:DeActiveUI(UI.CtrlNames.HeadShop)
        end
        UIMgr:DeActiveUI(UI.CtrlNames.LevelReward)
        UIMgr:DeActiveUI(UI.CtrlNames.Welfare)
    end)
    if MGameContext.IsOpenGM then
        self.panel.Btn_GoDebug:AddClick(function()
            local l_info = WrapItemInfo[MgrMgr:GetMgr("MvpMgr").m_mvpInfo[curBossItem.index + 1].id]
            if MLuaCommonHelper.IsNull(l_info) then
                logError("MVP debugGO MVPTabale info is nil!")
                return
            end
            local l_mvpCommandTxt = "gotomvp " .. l_info.mvpInfo.EventID .. " " .. l_info.mvpInfo.SceneID
            MgrMgr:GetMgr("GmMgr").SendCommand(l_mvpCommandTxt)
            UIMgr:DeActiveUI(UI.CtrlNames.MvpPanel)
            if UIMgr:IsActiveUI(UI.CtrlNames.DailyTask) then
                UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
            end
            if UIMgr:IsActiveUI(UI.CtrlNames.HeadShop) then
                UIMgr:DeActiveUI(UI.CtrlNames.HeadShop)
            end
            UIMgr:DeActiveUI(UI.CtrlNames.LevelReward)
            UIMgr:DeActiveUI(UI.CtrlNames.Welfare)
        end)
    end
    self.panel.Btn_GoDebug:SetActiveEx(MGameContext.IsOpenGM)
end

--init bossItem view
function MvpPanelCtrl:InitBossView()
    self.bossContent = self.panel.bossWrapContent.gameObject:GetComponent("UIWrapContent")
    if m_bossContentInit then
        self.bossContent:InitContent()
        m_bossContentInit = false
    end
    self.bossContent:SetContentCount(0)
    allBossItem = {}
    curBossItem = {}
    curBossItem.index = 0
    self.interval = 0
    allTimerLab = {}
    -------------------------
    local bossItemCount = table.maxn(self.mvpMgr.m_mvpInfo)
    if bossItemCount < 1 then
        return
    end
    for i = 1, bossItemCount do
        local id = self.mvpMgr.m_mvpInfo[i].id
        local l_tempWrapItemInfo = WrapItemInfo[id]
        if l_tempWrapItemInfo == nil then
            local l_mvpInfo = TableUtil.GetMvpTable().GetRowByID(id)
            if l_mvpInfo ~= nil then
                l_tempWrapItemInfo = {}
                l_tempWrapItemInfo.netInfo = self.mvpMgr.m_mvpInfo[i]
                l_tempWrapItemInfo.mvpInfo = l_mvpInfo
                l_tempWrapItemInfo.entityInfo = TableUtil.GetEntityTable().GetRowById(l_mvpInfo.EntityID)
                l_tempWrapItemInfo.sceneInfo = TableUtil.GetSceneTable().GetRowByID(l_mvpInfo.SceneID)
                l_tempWrapItemInfo.rewardOne = l_mvpInfo.WinAward[0]
                l_tempWrapItemInfo.rewardTwo = l_mvpInfo.PartsInAwardPreview
                WrapItemInfo[id] = l_tempWrapItemInfo
            else
                logError("MvpTable error@陈阳，找不到项ID:" .. tostring(id))
            end
        else
            l_tempWrapItemInfo.netInfo = self.mvpMgr.m_mvpInfo[i]--update info
        end
        self:FormatItemTime(id)
    end
    self.bossContent.updateOneItem = function(obj, index)
        local item = obj:GetComponent("MLuaUICom")
        if allBossItem[index] == nil then
            allBossItem[index] = {}
            self:ExportBossItem(allBossItem[index], obj)
        end
        local id = self.mvpMgr.m_mvpInfo[index + 1].id
        self:InitBossItem(allBossItem[index], id)
        item:AddClick(function()
            self:OnBossItemClick(allBossItem[index], index)
        end)
        allBossItem[index].RaycastImage.raycastTarget = false
        if curBossItem.index == index then
            allBossItem[index].Checkmark:SetActiveEx(true)
            curBossItem.targetObj = allBossItem[index]
            allBossItem[index].RaycastImage.raycastTarget = true
        end
        if allTimerLab[obj] == nil then
            allTimerLab[obj] = {}
        end
        allTimerLab[obj].id = id
        allTimerLab[obj].item = allBossItem[index]
    end
    self.bossContent:SetContentCount(bossItemCount)
    self:InitRewardView()
    self.ActiveTimeTiks = self.mvpMgr.m_mvpTimeTiks
    l_timer = self:NewUITimer(function()
        self:UpdateBeat()
    end, 1, -1, true)
    l_timer:Start()
end

function MvpPanelCtrl:InitRewardView()
    local info = WrapItemInfo[self.mvpMgr.m_mvpInfo[curBossItem.index + 1].id]
    if tonumber(info.rewardOne) and tonumber(info.rewardOne) > 0 then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(tonumber(info.rewardOne), MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG .. "MvpReward")
    end

    if info.rewardTwo.Length > 0 then
        local l_num = info.rewardTwo[0]
        if l_num > 0 then
            MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_num, MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG .. "EntityRandomReward")
        end
    end
    self:ShowMonsterModel()
    local l_sprite2 = info.mvpInfo.BgIcon
    local l_atlas2 = info.mvpInfo.BgAtlas
    if l_atlas2 and l_sprite2 then
        self.panel.mvpBg:SetSpriteAsync(tostring(l_atlas2), tostring(l_sprite2))
    end
    self.panel.monsterDesLab.LabText = info.mvpInfo.Des
    self.panel.monsterNameLab.LabText = "——" .. tostring(info.entityInfo.Name)
    self:RefreshMvpRewardCount()

    self.panel.Img_Prompt1:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = Common.Utils.Lang("ACTIVITY_REWARD_DES1"),
            alignment = UnityEngine.TextAnchor.MiddleRight,
            pos = {
                x = 300,
                y = 240,
            },
            width = 400,
        })
    end)
    self.panel.Img_Prompt2:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = Common.Utils.Lang("ACTIVITY_REWARD_DES2"),
            alignment = UnityEngine.TextAnchor.MiddleRight,
            pos = {
                x = 300,
                y = 130,
            },
            width = 400,
        })
    end)
end

function MvpPanelCtrl:RefreshMvpRewardCount()
    local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_target = MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[MgrMgr:GetMgr("LimitBuyMgr").g_limitType.MVP_REWARD]
    local l_count1 = l_limitMgr.GetItemCount(l_limitMgr.g_limitType.MVP_REWARD,1)
    local l_count2 = l_limitMgr.GetItemLimitCount(l_limitMgr.g_limitType.MVP_REWARD,1)
    local l_count3 = l_limitMgr.GetItemCount(l_limitMgr.g_limitType.MVP_REWARD,2)
    local l_count4 = l_limitMgr.GetItemLimitCount(l_limitMgr.g_limitType.MVP_REWARD,2)
    if not l_target then
        logError("[ActivityCtrl]没有找到剩余次数@陈阳@徐飞")
    end
    self.panel.Number1.LabText = tostring(l_count1) .. "/" .. tostring(l_count2)
    self.panel.Number2.LabText = tostring(l_count3) .. "/" .. tostring(l_count4)
end

function MvpPanelCtrl:RefreshMvpPreviewAwards(...)
    local awardPreviewRes = ...
    local awardList = awardPreviewRes and awardPreviewRes.award_list
    local previewCount = awardPreviewRes.preview_count == -1 and #awardList or awardPreviewRes.preview_count
    local rewardInfo = {}
    for i, v in ipairs(awardList) do
        table.insert(rewardInfo, {
            itemInfo = TableUtil.GetItemTable().GetRowByItemID(v.item_id),
            itemCount = v.count,
            ID = v.item_id,
            IsShowCount = false,
        })
        if i >= previewCount then
            break
        end
    end
    if self.TeamAwardPool then
        self.TeamAwardPool:ShowTemplates({ Datas = rewardInfo })
    end
end

function MvpPanelCtrl:RefreshEntityRandomPreviewAwards(...)
    local awardPreviewRes = ...
    if awardPreviewRes==nil then
        logError("RefreshEntityRandomPreviewAwards 数据为null!")
        return
    end
    local awardList = awardPreviewRes and awardPreviewRes.award_list
    local previewCount = awardPreviewRes.preview_count == -1 and #awardList or awardPreviewRes.preview_count
    local rewardInfo = {}
    for i, v in ipairs(awardList) do
        table.insert(rewardInfo, {
            itemInfo = TableUtil.GetItemTable().GetRowByItemID(v.item_id),
            itemCount = v.count,
            ID = v.item_id,
            IsShowCount = false,
        })
        if i >= previewCount then
            break
        end
    end
    self.PrivatePool:ShowTemplates({ Datas = rewardInfo })
end

function MvpPanelCtrl:ShowMonsterModel()
    self.lastTime = -1
    self.starTime = Time.realtimeSinceStartup

    local id = self.mvpMgr.m_mvpInfo[curBossItem.index + 1].id
    local info = WrapItemInfo[id]
    local entityId = info.mvpInfo.EntityID
    local l_tableInfo = info.mvpInfo

    self.panel.ModelImage.gameObject:SetActiveEx(false)
    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitMonsterAttr(l_tempId, "49722", entityId)
    self.IdleAnimPath = l_attr.CommonIdleAnimPath
    self.ShowAnimPath = "Anims/Monster/" .. info.mvpInfo.ClickAction
    local l_modelPos = Vector3.New(l_tableInfo.Postion[0], l_tableInfo.Postion[1], l_tableInfo.Postion[2])
    local l_modelScale = Vector3.New(l_tableInfo.Scale[0], l_tableInfo.Scale[1], l_tableInfo.Scale[2])
    local l_modelRotation = Vector3.New(l_tableInfo.Rotation[0], l_tableInfo.Rotation[1], l_tableInfo.Rotation[2])

    self.panel.ModelImage:PlayDynamicEffect(1, {
        attr = l_attr,
        defaultAnim = self.IdleAnimPath,
        position = l_modelPos,
        scale = l_modelScale,
        rotation = l_modelRotation,
        modelLoadCallback = function(mModel)
            self.monsterEntity = mModel
            self.panel.ModelImage:AddClick(function()
                if self.lastTime > 0 then
                    return
                end
                local l_clicp = mModel.Ator:OverrideAnim("Idle", self.ShowAnimPath)
                mModel.Ator:Play("Idle", 0)
                self.lastTime = l_clicp.Length
                self.starTime = Time.realtimeSinceStartup

            end)
            self.panel.ModelImage.gameObject:SetActiveEx(true)
            mModel.Ator:OverrideAnim("Idle", self.IdleAnimPath)
        end,
    })
end

function MvpPanelCtrl:Destroy3DModel()
    self.panel.ModelImage:StopDynamicEffect()
    self.monsterEntity = nil
end
--export boss item
function MvpPanelCtrl:ExportBossItem(element, Object)
    element.ui = Object.gameObject
    element.Checkmark = element.ui.transform:Find("Checkmark").gameObject
    element.NameLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Team"))
    element.RaycastImage = element.ui.transform:Find("Img_RayCaster"):GetComponent("RaycastImage")
    element.RaycastImage.raycastTarget = false
    element.headIcon = element.ui.transform:Find("Icon_Bg/Icon_Head"):GetComponent("MLuaUICom")
    element.LvLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Icon_Bg/Img_LvBG/Txt_LvLab"))
    element.TimeLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("TimeLab"))
    element.ServerLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ServerLab"))
    element.Checkmark:SetActiveEx(false)
end
--init boss item
function MvpPanelCtrl:InitBossItem(item, id)
    local info = WrapItemInfo[id]
    item.Checkmark:SetActiveEx(false)
    if info.netInfo.has_final_killer then
        item.NameLab.LabText = tostring(info.netInfo.best_name)
        item.NameLab.gameObject:GetComponent("MLuaUICom"):AddClick(function()
            self.mvpMgr.SendGetMVPRankInfoReq(info, id)
        end)
    else
        item.NameLab.LabText = "----"
        item.NameLab.gameObject:GetComponent("MLuaUICom"):AddClick(function()
        end)
    end
    item.LvLab.LabText = "Lv" .. tostring(info.entityInfo.UnitLevel)
    item.TimeLab.LabText = self:GetItemTime(id)
    item.ServerLab.LabText = tostring(info.sceneInfo.MiniMap)
    local l_sprite = info.mvpInfo.HeadIcon
    local l_atlas = info.mvpInfo.HeadAtlas
    if l_atlas and l_sprite then
        item.headIcon:SetSpriteAsync(tostring(l_atlas), tostring(l_sprite))
    end
end
--on boss item click
function MvpPanelCtrl:OnBossItemClick(item, index)
    if curBossItem.index == index then
        return
    end
    curBossItem.targetObj.Checkmark:SetActiveEx(false)
    curBossItem.targetObj.RaycastImage.raycastTarget = false
    curBossItem.targetObj = item
    curBossItem.targetObj.Checkmark:SetActiveEx(true)
    curBossItem.targetObj.RaycastImage.raycastTarget = true
    curBossItem.index = index
    self:InitRewardView()
end
--export reward item
function MvpPanelCtrl:ExportRewardItem(element, Object)
    element.ui = Object.gameObject
    element.icon = element.ui.transform:Find("Background/Image"):GetComponent("MLuaUICom")
    element.background = element.ui.transform:Find("Background"):GetComponent("MLuaUICom")
    element.mark = element.ui.transform:Find("Background/Mark"):GetComponent("MLuaUICom")
    element.flagIcon = element.ui.transform:Find("Background/Biaoshi_Mvp"):GetComponent("Biaoshi_Mvp")
    element.btn = Object.gameObject:GetComponent("MLuaUICom")
end
--init reward item
function MvpPanelCtrl:InitRewardItem(item, itemData)
    local l_atlas = itemData.itemInfo.ItemAtlas
    local l_sprite = itemData.itemInfo.ItemIcon
    local itemType = itemData.itemInfo.TypeTab
    local probInfo = { type = itemType, propId = itemData.itemInfo.ItemID }
    item.icon:SetSprite(tostring(l_atlas), tostring(l_sprite), true)
    item.background:SetSprite("Common", Data.BagModel:getItemBg(probInfo))
    if itemType == Data.BagModel.PropType.Card then
        local cardSize = l_itemSize:Clone():Mul(Data.BagModel:getCardScale())
        item.background.RectTransform.sizeDelta = Vector2(cardSize.x, l_itemSize.y)
        local l_atlas, l_sprite = Data.BagModel:getCardPosInfo(probInfo.TID)
        item.mark:SetSprite(l_atlas, l_sprite)
    else
        item.background.RectTransform.sizeDelta = l_itemSize
    end
    item.mark.UObj:SetActiveEx(itemType == Data.BagModel.PropType.Card)
    item.btn:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemData.itemInfo.ItemID, item.ui.transform)
    end)
end

--timer
function MvpPanelCtrl:UpdateBeat()
    local nowInterval = Time.realtimeSinceStartup - self.ActiveTimeTiks
    if nowInterval - self.interval >= 1 then
        --update
        self.interval = self.interval + 1
        self:UpdateTimer()
    end
end
--timer coming
function MvpPanelCtrl:UpdateTimer()
    for k, v in pairs(allTimerLab) do
        local id = allTimerLab[k].id
        if allTimerLab[k] and allTimerLab[k].item and
                (not MLuaCommonHelper.IsNull(allTimerLab[k].item.TimeLab)) then
            allTimerLab[k].item.TimeLab.LabText = self:GetItemTime(id)
        end
    end
end
-- format time info
function MvpPanelCtrl:FormatItemTime(id)
    if allTimeValue[id] == nil then
        allTimeValue[id] = {}
    end
    local l_wrapItemInfo = WrapItemInfo[id]
    if l_wrapItemInfo == nil or l_wrapItemInfo.mvpInfo == nil then
        return
    end
    allTimeValue[id].isRefresh = l_wrapItemInfo.netInfo.is_refresh

    if l_wrapItemInfo.mvpInfo.Type == 1 then
        allTimeValue[id].refreshType = RefrashType.Timing
        local intTime = l_wrapItemInfo.netInfo.refresh_time
        local temp
        allTimeValue[id].m, temp = math.modf(intTime / 60)
        allTimeValue[id].s = intTime - allTimeValue[id].m * 60
    end
    if l_wrapItemInfo.mvpInfo.Type == 2 then
        allTimeValue[id].refreshType = RefrashType.Random
    end
end

function MvpPanelCtrl:GetItemTime(id)
    if allTimeValue[id] == nil then
        return "----"
    end
    if allTimeValue[id].refreshType == RefrashType.Random then
        if allTimeValue[id].isRefresh then
            return Common.Utils.Lang("HAVE_UPDATE")
        else
            return Common.Utils.Lang("NOT_UPDATE")
        end
    end
    if allTimeValue[id].refreshType == RefrashType.Timing then
        if allTimeValue[id].isRefresh then
            return Common.Utils.Lang("HAVE_UPDATE")
        end
        local remain = allTimeValue[id].m * 60 + allTimeValue[id].s - self.interval
        if remain < 1 then
            return Common.Utils.Lang("HAVE_UPDATE")
        end
        if remain < 60 then
            if remain < 10 then
                return "00:0" .. tostring(remain)
            else
                return "00:" .. tostring(remain)
            end
        end
        local l_m, temp = math.modf(remain / 60)
        local l_s = remain - l_m * 60
        local l_mstr
        local l_sStr
        if l_m < 10 then
            l_mstr = "0" .. tostring(l_m)
        else
            l_mstr = tostring(l_m)
        end
        if l_s < 10 then
            l_sStr = "0" .. tostring(l_s)
        else
            l_sStr = tostring(l_s)
        end
        return l_mstr .. ":" .. l_sStr
    end
end

--lua custom scripts end
return MvpPanelCtrl