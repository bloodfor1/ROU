--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainRoleInfoPanel"
require "Data/Model/PlayerInfoModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MainRoleInfoCtrl = class("MainRoleInfoCtrl", super)

local l_showTips = true
local l_buffMgr = MgrMgr:GetMgr("BuffMgr")
local l_buffAddNum = 6
local l_buffReduce = 12
local l_buffAddItem = {}  ----7个增益buff
local l_buffReduceItem = {}  ----14个减益buff
local l_buffAddTips = {}  ----7个增益buff提示信息
local l_buffAffixTips = {} ----词缀Buff
local l_buffReduceTips = {}  ---14个减益buff提示信息
local l_refreshItem = {}   ----需要刷新计时的buff item
local l_refreshTips = {}   ----需要刷新计时的buff tips
local l_itemTimer = nil    ----两个计时器分开是因为tip是公共的
local l_tipsTimer = nil
local l_width = 437.5
local l_height = 320
local l_curBuff = {}
--lua class define end

--lua functions
function MainRoleInfoCtrl:ctor()

    super.ctor(self, CtrlNames.MainRoleInfo, UILayer.Normal, UITweenType.Right, ActiveType.Normal)
    self.overrideSortLayer = UILayerSort.Normal + 1
    self.cacheGrade = EUICacheLv.VeryLow
    self.targetUID = 0

end --func end
--next--
newPlayerDungonId = 1004
function MainRoleInfoCtrl:Init()
    self.panel = UI.MainRoleInfoPanel.Bind(self)
    super.Init(self)

    self:OnBuffInit()
    --目标
    self.panel.BtnCloseTarget:AddClick(function()
        if MEntityMgr.PlayerEntity ~= nil then
            MEntityMgr.PlayerEntity.Target = nil
            self.panel.Target.gameObject:SetActiveEx(false)
        end
    end)

    --红点
    self.RedSignProcessor = self:NewRedSign({
        Key = eRedSignKey.MainRoleInfoStatusPoint,
        ClickButton = self.panel.RedParent
    })

    -- 头像
    self.PlayerHead2D = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.panel.HeadIconImg.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    self.TargetHead2D = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.panel.TargetIcon.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function MainRoleInfoCtrl:Uninit()

    -- 头像
    self.PlayerHead2D = nil
    self.TargetHead2D = nil
    self.RedSignProcessor = nil

    self:OnBuffUnInit()

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function MainRoleInfoCtrl:OnActive()
    if self.targetUID ~= 0 then
        self:RefreshTargetUI()
    else
        self.panel.Target.gameObject:SetActiveEx(false)
    end

    l_buffMgr.UpdateBuffInfo(MPlayerInfo.UID)
    self:RefreshRoleInfo()
end --func end
--next--
function MainRoleInfoCtrl:OnDeActive()
    self.panel.Target.gameObject:SetActiveEx(false)
end --func end
--next--
function MainRoleInfoCtrl:Update()
    -- do nothing
end --func end

function MainRoleInfoCtrl:OnShow()
    self:RefreshHead()
    self:RefreshProfession()
end

--next--
function MainRoleInfoCtrl:OnLogout()
    self:ResetTarget()
end --func end
--next--
function MainRoleInfoCtrl:OnReconnected()
    super.OnReconnected(self)
    self.panel.TxtBaseLv.LabText = tostring(MPlayerInfo.Lv)
    self:SetRoleLevel()
end --func end
--next--
function MainRoleInfoCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnIconFrameUpdate, self.RefreshHead)
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBattleFieldKDAUpdated, self._updatePlayerKDA)
    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher, l_logoutMgr.OnLogoutEvent, self.OnLogout)
    local l_buffMgr = MgrMgr:GetMgr("BuffMgr")
    self:BindEvent(GlobalEventBus, EventConst.Names.PlayerOutLookChange, self.RefreshHead)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, self.RefreshHead)
    self:BindEvent(MgrMgr:GetMgr("SelectRoleMgr").EventDispatcher, MgrMgr:GetMgr("SelectRoleMgr").ON_DATA_CHANGED, function(self)
        self:RefreshRoleInfo()
    end)
    self:BindEvent(MgrMgr:GetMgr("ProfessionMgr").EventDispatcher, MgrMgr:GetMgr("ProfessionMgr").ON_PROFESSION_CHANGE, function(self)
        self:SetRoleLevel()
    end)
    self:BindEvent(l_buffMgr.EventDispatcher, l_buffMgr.BUFF_UPDATE_EVENT, function(self, roleId)
        if tostring(roleId) == tostring(MPlayerInfo.UID) then
            self:ShowBuff()
        end

        if l_showTips and (self.curId == 0 or self.curId == roleId) then
            self:ShowBuffTips(roleId)
        end
    end)
    self:BindEvent(l_buffMgr.EventDispatcher, l_buffMgr.TARGET_BUFF_TIPS_OPEN, function()
        self:HideBuffTips()
        l_showTips = true
    end)
    local l_autoFightItemMgr = MgrMgr:GetMgr("AutoFightItemMgr")
    self:BindEvent(l_autoFightItemMgr.EventDispatcher, l_autoFightItemMgr.EventType.DaBaoTangRefresh, function()
        MgrMgr:GetMgr("BuffMgr").UpdateBuffInfo(MPlayerInfo.UID)
        self:ShowBuff()
    end)

    local l_func = function(sliderCom, num)
        local res = tonumber(num)
        if res == nil or sliderCom == nil then
            return
        end
        if res ~= sliderCom.Slider.value then
            sliderCom.Slider.value = res
        end
    end
    self:BindEvent(Data.PlayerInfoModel.HPPERCENT, Data.onDataChange, function(self, number)
        l_func(self.panel.SliderHP, number)
    end)
    self:BindEvent(Data.PlayerInfoModel.MPPERCENT, Data.onDataChange, function(self, number)
        l_func(self.panel.SliderMP, number)
    end)
    self:BindEvent(Data.PlayerInfoModel.BASELV, Data.onDataChange, function(self, txt)
        self.panel.TxtBaseLv.LabText = tostring(txt) or ""
    end)
    self:BindEvent(Data.PlayerInfoModel.JOBLV, Data.onDataChange, function(self, txt)
        self:SetRoleLevel()
    end)
    local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.ON_TRANS_FIGURE, self.setBaseLvText)
end --func end
--next--
--lua functions end

--lua custom scripts

function MainRoleInfoCtrl:_onTargetClick()
    if self.targetUID ~= 0 and self.targetIsRole then
        MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.targetUID)
    end
end

function MainRoleInfoCtrl:_onRoleIconClick()
    --新手副本特判 不可点击
    if MScene.SceneID == newPlayerDungonId then
        return
    end
    --三转试炼副本 特判断不可点击
    if MgrMgr:GetMgr("RoleInfoMgr").GetIsNewUserTransferDungeon() then
        if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.IsTransfigured and MEntityMgr.PlayerEntity.AttrComp.TransfigureID then
            return
        end
    end

    MgrMgr:GetMgr("RoleInfoMgr").OnShowRoleInfo()
end

--在特殊副本 如果出现变身的 则设置等级
function MainRoleInfoCtrl:setBaseLvText()
    if MgrMgr:GetMgr("RoleInfoMgr").GetIsNewUserTransferDungeon() then
        if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.IsTransfigured and MEntityMgr.PlayerEntity.AttrComp.TransfigureID then
            local l_entityInfo = TableUtil.GetEntityTable().GetRowById(MEntityMgr.PlayerEntity.AttrComp.TransfigureID)
            if l_entityInfo then
                self.panel.TxtBaseLv.LabText = l_entityInfo.UnitLevel
                self.panel.TxtJobLv.LabText = l_entityInfo.UnitLevel
            end
        end
    end
end

function MainRoleInfoCtrl:InitBasicInfo(...)
    self.panel.SliderHP.Slider.value = Data.PlayerInfoModel:getHPPercent() or 0
    self.panel.SliderMP.Slider.value = Data.PlayerInfoModel:getMPPercent() or 0
    self.panel.TxtBaseLv.LabText = Data.PlayerInfoModel:getBaseLv() or 0
    self:SetRoleLevel()
end

function MainRoleInfoCtrl:OnProfessionChange()
    self:RefreshHead()
    self:RefreshProfession()
end

function MainRoleInfoCtrl:RefreshProfession()
    local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(MPlayerInfo.ProID)
    if imageName and self.panel then
        self.panel.ProfessionImg:SetSpriteAsync("Common", imageName)
    end
end

function MainRoleInfoCtrl:RefreshHead()
    if not self.panel then
        return
    end

    ---@type HeadTemplateParam
    local param = {
        ShowProfession = true,
        IsPlayerSelf = true,
        OnClick = self._onRoleIconClick,
        OnClickSelf = self,
    }

    self.PlayerHead2D:SetData(param)
    local data = DataMgr:GetData("TeamData").myTeamInfo
    local myUid = MPlayerInfo.UID:tostring()
    --设置队长标志
    self.panel.Img_Leader.gameObject:SetActiveEx(myUid == tostring(data.captainId))
end

function MainRoleInfoCtrl:RefreshTargetHead(uid)
    --刷新头像
    local entity = MEntityMgr:GetEntity(uid, true)
    ---@type HeadTemplateParam
    local param = {
        Entity = entity,
        OnClick = self._onTargetClick,
        OnClickSelf = self,
    }

    self.TargetHead2D:SetData(param)
end

function MainRoleInfoCtrl:RefreshTargetInfo(uid, name, lv, isRole, isEnemy)
    self.targetUID = uid
    self.targetIsRole = isRole
    self.targetIsEnemy = isEnemy
    self.targetName = name
    self.targetLv = lv
    self:RefreshTargetUI()
end

function MainRoleInfoCtrl:RefreshTargetUI()
    if self.panel then
        local l_ent = MEntityMgr:GetEntity(self.targetUID)
        if l_ent == nil or not MEntity.ValideEntityIncludeDead(l_ent) then
            self:ResetTarget()
        end
        self.panel.Target.gameObject:SetActiveEx(self.targetUID ~= 0)
        self.panel.TargetName.LabText = self.targetName or ""
        self.panel.TargetLv.LabText = self.targetLv or ""
        if self.targetIsEnemy then
            self.panel.Target:SetSprite("Common", "UI_Common_Mouster_Frame.png")
        else
            self.panel.Target:ResetSprite()
        end
        self:RefreshTargetHead(self.targetUID)
    end
end

function MainRoleInfoCtrl:ResetTarget()
    self.targetUID = 0
    self.targetIsRole = false
    self.targetIsEnemy = false
    self.targetName = ""
    self.targetLv = 0
end

function MainRoleInfoCtrl:SetRoleLevel()
    if MEntityMgr.PlayerEntity then
        local cShowLv, cProNum = Common.CommonUIFunc.GetShowJobLevelAndProByLv(MPlayerInfo.JobLv, MEntityMgr.PlayerEntity.AttrRole.ProfessionID)
        self.panel.TxtJobLv.LabText = cShowLv
    else
        self.panel.TxtJobLv.LabText = MPlayerInfo.JobLv
    end
end

----====================buff============================================================================================
function MainRoleInfoCtrl:OnBuffInit()
    ----buff 显示初始化

    self.panel.buffTip.gameObject:SetActiveEx(false)

    l_buffAddItem = {}
    l_buffReduceItem = {}
    l_buffAddTips = {}
    l_buffAffixTips = {}
    l_buffReduceTips = {}

    self:ClearEffect()

    l_refreshTips = {}

    l_showTips = false
    self.curId = 0

    l_buffMgr.UpdateBuffInfo(MPlayerInfo.UID)

    self.panel.buffListPanel:AddClick(function()
        if not l_showTips then
            l_showTips = true
            l_buffMgr.UpdateBuffInfo(MPlayerInfo.UID)
        end
    end)
    self.panel.buffTipsBtn:AddClick(function()
        self:HideBuffTips()
    end)
end

function MainRoleInfoCtrl:OnBuffUnInit()
    ----
    l_buffAddItem = {}
    l_buffReduceItem = {}
    l_buffAddTips = {}
    l_buffAffixTips = {}
    l_buffReduceTips = {}

    self:ClearEffect()

    l_refreshTips = {}

    l_showTips = false
    self.curId = 0

    if l_itemTimer ~= nil then
        self:StopUITimer(l_itemTimer)
        l_itemTimer = nil
    end

    if l_tipsTimer ~= nil then
        self:StopUITimer(l_tipsTimer)
        l_tipsTimer = nil
    end

    l_curBuff = {}
end

function MainRoleInfoCtrl:ShowBuff()
    -----接口:打开buff显示
    self:InitItemView()
    if l_itemTimer ~= nil then
        self:StopUITimer(l_itemTimer)
        l_itemTimer = nil
    end
    if table.ro_size(l_refreshItem) > 0 then
        l_itemTimer = self:NewUITimer(function()
            for k, v in pairs(l_refreshItem) do
                v.remainTime = v.remainTime - 0.2
                if v.remainTime < 0 then
                    v.remainTime = 0
                end
                if not v.endfx and v.remainTime < 1 then
                    v.endfx = true
                    if v.fx ~= nil then
                        self:DestroyUIEffect(v.fx)
                        v.fx = nil
                    end
                    local l_fxData = {}
                    l_fxData.rawImage = v.effectImg.RawImg
                    v.fx = self:CreateUIEffect(v.effect, l_fxData)

                end
                v.item.fillImg.fillAmount = 1 - v.remainTime / v.l_timeLimit
            end
        end, 0.2, -1, true)
        l_itemTimer:Start()
    end
end

function MainRoleInfoCtrl:DestroyItem(list)
    ----回收
    if #list == 0 then
        return
    end
    for i = 1, #list do
        MResLoader:DestroyObj(list[i].ui)
    end
end

function MainRoleInfoCtrl:ExportItem(obj, item)
    item.ui = obj
    item.icon = item.ui.transform:Find("icon"):GetComponent("MLuaUICom")
    item.fillImg = item.ui.transform:Find("Image"):GetComponent("Image")
    item.timeLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("timeLab"))
    item.effectImg = item.ui.transform:Find("Effect"):GetComponent("MLuaUICom")
end

function MainRoleInfoCtrl:InitItem(item, info, effect, diseffect)
    item.ui:SetActiveEx(true)
    local l_state = false
    for k, v in pairs(l_curBuff) do
        l_state = (v == info.tableInfo.Id)
        if l_state then
            break
        end
    end
    local l_fx = nil
    if not l_state then
        local l_anim = item.ui:GetComponent("DOTweenAnimation")
        l_anim:DORestart()
        l_anim:DOPlayForward()

        local l_fxData = {}
        l_fxData.rawImage = item.effectImg.RawImg
        l_fx = self:CreateUIEffect(effect, l_fxData)

    end
    item.icon:SetSprite(info.tableInfo.IconAtlas, info.tableInfo.Icon)
    local l_timeInfo = Common.Functions.VectorSequenceToTable(info.tableInfo.DestroyTiming)
    local l_timeLimit = info.totalTime
    if l_timeLimit > 0 then
        item.fillImg.fillAmount = 1 - info.remainTime / l_timeLimit
        local l_index = #l_refreshItem + 1
        l_refreshItem[l_index] = {}
        l_refreshItem[l_index].item = item
        l_refreshItem[l_index].remainTime = info.remainTime
        l_refreshItem[l_index].l_timeLimit = l_timeLimit
        l_refreshItem[l_index].fx = l_fx
        l_refreshItem[l_index].effectImg = item.effectImg
        l_refreshItem[l_index].effect = diseffect
    else
        item.fillImg.fillAmount = 0
    end
    item.timeLab.gameObject:SetActiveEx(info.appendCount > 1)
    item.timeLab.LabText = info.appendCount
end

function MainRoleInfoCtrl:ClearEffect()
    if table.ro_size(l_refreshItem) > 0 then
        for k, v in pairs(l_refreshItem) do
            if v.fx ~= nil then
                self:DestroyUIEffect(v.fx)
                v.fx = nil
            end
        end
    end
    l_refreshItem = {}
end

function MainRoleInfoCtrl:InitItemView()
    ----初始化item面板
    self:ClearEffect()
    for i = 1, #l_buffAddItem do
        l_buffAddItem[i].ui:SetActiveEx(false)
        l_buffAddItem[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    for i = 1, #l_buffReduceItem do
        l_buffReduceItem[i].ui:SetActiveEx(false)
        l_buffReduceItem[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    local l_curCount = 0
    local l_addInfo = l_buffMgr.g_playerAddBuffInfo
    local l_reduce = l_buffMgr.g_playerReduceBuffInfo
    local l_nowBuff = {}
    self.panel.buffList.gameObject:SetActiveEx(#l_addInfo > 0)
    self.panel.debuffList.gameObject:SetActiveEx(#l_reduce > 0)
    if #l_addInfo > 0 then
        for i = 1, #l_addInfo do
            if l_curCount < l_buffAddNum then
                l_curCount = l_curCount + 1
                if l_buffAddItem[i] == nil then
                    self:CreateAddItem(i)
                end
                self:InitItem(l_buffAddItem[i], l_addInfo[i], l_buffMgr.AddStatrEffect, l_buffMgr.AddEndEffect)
                l_buffAddItem[i].ui.transform:SetParent(self.panel.buffList.gameObject.transform)
                l_buffAddItem[i].ui.transform.localScale = self.panel.addBuff.gameObject.transform.localScale
                local l_index = #l_nowBuff
                l_nowBuff[l_index + 1] = l_addInfo[i].tableInfo.Id
            end
        end
    end
    if #l_reduce > 0 then
        for i = 1, #l_reduce do
            if l_curCount < l_buffReduce then
                l_curCount = l_curCount + 1
                if l_buffReduceItem[i] == nil then
                    self:CreateReduceItem(i)
                end
                self:InitItem(l_buffReduceItem[i], l_reduce[i], l_buffMgr.ReduceStatrEffect, l_buffMgr.DebuffEndEffect)
                l_buffReduceItem[i].ui.transform:SetParent(self.panel.debuffList.gameObject.transform)
                l_buffReduceItem[i].ui.transform.transform.localScale = self.panel.reduceBuff.gameObject.transform.localScale
                local l_index = #l_nowBuff
                l_nowBuff[l_index + 1] = l_reduce[i].tableInfo.Id
            end
        end
    end
    l_curBuff = l_nowBuff
end

---=====================================================================================================================

function MainRoleInfoCtrl:ShowBuffTips(roleId)
    ----接口:打开buff tips显示
    self.curId = roleId
    if l_tipsTimer ~= nil then
        self:StopUITimer(l_tipsTimer)
        l_tipsTimer = nil
    end
    self:InitTipsView(roleId)
    if table.ro_size(l_refreshTips) > 0 then
        l_tipsTimer = self:NewUITimer(function()
            for k, v in pairs(l_refreshTips) do
                if not v.isStop then
                    v.remainTime = v.remainTime - 1
                    if v.remainTime < 0 then
                        v.remainTime = 0
                    end
                    v.item.timeLab.LabText = MgrMgr:GetMgr("BuffMgr").GetBuffTimeDes(math.floor(v.remainTime + 0.5))
                    if v.remainTime < 1 then
                        v.item.timeLab.gameObject:SetActiveEx(false)
                    end
                end
            end
        end, 1, -1, true)
        l_tipsTimer:Start()
    end
end

function MainRoleInfoCtrl:ExportTips(obj, item)
    item.ui = obj
    item.icon = item.ui.transform:Find("icon"):GetComponent("MLuaUICom")
    item.deleteBtn = item.ui.transform:Find("Button"):GetComponent("MLuaUICom")
    item.nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("nameLab"))
    item.timeLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("timeLab"))
    item.desLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("desLab"))
end

function MainRoleInfoCtrl:InitTips(item, info, isPlayer)
    item.ui:SetActiveEx(true)
    item.icon:SetSprite(info.tableInfo.IconAtlas, info.tableInfo.Icon)
    item.deleteBtn.gameObject:SetActiveEx(info.couldCancel and isPlayer)
    item.deleteBtn:AddClick(function()
        local l_buffComp = MEntityMgr.PlayerEntity.Buff
        if l_buffComp then
            l_buffComp:CancelBuff(info.uid)
        end
    end)
    local l_des = ""
    if info.appendCount > 1 then
        l_des = " X" .. tostring(info.appendCount)
    end
    item.nameLab.LabText = info.tableInfo.InGameName .. l_des

    if info.buffAttrDecision ~= nil then
        local l_attrDes = ""
        local l_itor = info.buffAttrDecision:GetEnumerator()
        while l_itor:MoveNext() do
            local l_k = l_itor.Current.Key
            local l_v = l_itor.Current.Value
            local l_attrInfo = TableUtil.GetAttrDecision().GetRowById(l_k)
            if l_attrInfo then
                local l_isPercentage = l_attrInfo.TipParaEnum == 1  --是否是百分比数据
                l_v = tonumber(l_v)
                local l_vStr = tostring(l_v)
                if l_v > 0 then
                    l_vStr = l_isPercentage and "+" .. tostring(l_v / 100) .. "%" or "+" .. tostring(l_v)
                end
                --华丽水晶属性可能存在三条 显示不下 需要特判 逗号分隔
                if info.tableInfo and info.tableInfo.Id == DataMgr:GetData("GuildData").GUILD_CRYSTAL_BUFF_ID then
                    l_attrDes = l_attrDes .. StringEx.Format(l_attrInfo.TipTemplate, l_vStr) .. ","
                else
                    l_attrDes = l_attrDes .. StringEx.Format(l_attrInfo.TipTemplate, l_vStr) .. " "
                end
            end
        end

        --华丽水晶属性特判去除末位逗号
        if info.tableInfo and info.tableInfo.Id == DataMgr:GetData("GuildData").GUILD_CRYSTAL_BUFF_ID then
            l_attrDes = StringEx.SubString(l_attrDes, 0, string.ro_len_normalize(l_attrDes) - 1)
        end
        item.desLab.LabText = l_attrDes
    else
        item.desLab.LabText = info.tableInfo.Description
    end
    local l_timeInfo = Common.Functions.VectorSequenceToTable(info.tableInfo.DestroyTiming)
    local l_timeLimit = -1
    for i, v in ipairs(l_timeInfo) do
        if v[1] == 1 then
            l_timeLimit = v[2]
        end
    end
    --if l_timeLimit>0 and info.remainTime>0 then
    if info.remainTime > 0 then
        item.timeLab.gameObject:SetActiveEx(true)
        local l_index = #l_refreshTips + 1
        l_refreshTips[l_index] = {}
        l_refreshTips[l_index].item = item
        l_refreshTips[l_index].remainTime = info.remainTime
        l_refreshTips[l_index].isStop = info.isStop
        l_refreshTips[l_index].l_timeLimit = l_timeLimit > 0 and l_timeLimit or 1000000
    else
        item.timeLab.gameObject:SetActiveEx(false)
    end
    item.timeLab.LabText = MgrMgr:GetMgr("BuffMgr").GetBuffTimeDes(math.floor(info.remainTime + 0.5))
end

function MainRoleInfoCtrl:InitTipsView(roleId)
    ----初始化tips显示
    l_refreshTips = {}
    for i = 1, #l_buffAddTips do
        l_buffAddTips[i].ui:SetActiveEx(false)
        l_buffAddTips[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    for i = 1, #l_buffAffixTips do
        l_buffAffixTips[i].ui:SetActiveEx(false)
        l_buffAffixTips[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    for i = 1, #l_buffReduceTips do
        l_buffReduceTips[i].ui:SetActiveEx(false)
        l_buffReduceTips[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    local l_tragetAffix = {}
    local l_addInfo = {}
    local l_reduce = {}
    local l_isPlayer = tostring(roleId) == tostring(MPlayerInfo.UID)
    if l_isPlayer then
        l_addInfo = l_buffMgr.g_playerAddBuffInfo
        l_reduce = l_buffMgr.g_playerReduceBuffInfo
        self.panel.buffTip.gameObject.transform.transform:SetParent(self.panel.selfTipPos.gameObject.transform)
        self.panel.buffTip.gameObject.transform:SetLocalPosZero()
    else
        l_addInfo = l_buffMgr.g_targetAddBuffInfo
        l_reduce = l_buffMgr.g_targetReduceBuffInfo
        l_tragetAffix = l_buffMgr.g_tragetAffixBuffIdTb
        self.panel.buffTip.gameObject.transform.transform:SetParent(self.panel.otherTipPos.gameObject.transform)
        self.panel.buffTip.gameObject.transform:SetLocalPosZero()
    end
    local l_curCount = 0
    if #l_tragetAffix > 0 then
        for i = 1, #l_tragetAffix do
            --if l_curCount<l_buffAddNum then
            l_curCount = l_curCount + 1
            if l_buffAffixTips[i] == nil then
                self:CreateAddAffixTips(i)
            end
            self:InitTips(l_buffAffixTips[i], l_tragetAffix[i], l_isPlayer)
            l_buffAffixTips[i].ui.transform:SetParent(self.panel.buffInfoGrid.gameObject.transform)
            l_buffAffixTips[i].ui.transform.localScale = self.panel.addBuffInfo.gameObject.transform.localScale
            --end
        end
    end
    if #l_addInfo > 0 then
        for i = 1, #l_addInfo do
            --if l_curCount<l_buffAddNum then
            l_curCount = l_curCount + 1
            if l_buffAddTips[i] == nil then
                self:CreateAddTips(i)
            end
            self:InitTips(l_buffAddTips[i], l_addInfo[i], l_isPlayer)
            l_buffAddTips[i].ui.transform:SetParent(self.panel.buffInfoGrid.gameObject.transform)
            l_buffAddTips[i].ui.transform.localScale = self.panel.addBuffInfo.gameObject.transform.localScale
            --end
        end
    end
    if #l_reduce > 0 then
        for i = 1, #l_reduce do
            --if l_curCount<l_buffReduce then
            l_curCount = l_curCount + 1
            if l_buffReduceTips[i] == nil then
                self:CreateReduceTips(i)
            end
            self:InitTips(l_buffReduceTips[i], l_reduce[i], l_isPlayer)
            l_buffReduceTips[i].ui.transform:SetParent(self.panel.buffInfoGrid.gameObject.transform)
            l_buffReduceTips[i].ui.transform.localScale = self.panel.reduceBuffInfo.gameObject.transform.localScale
            --end
        end
    end
    self:AutoSetPanelSize(l_curCount)
    if l_curCount == 0 then
        self:HideBuffTips()
        return
    end
    self.panel.buffTip.gameObject:SetActiveEx(true)
end

function MainRoleInfoCtrl:HideBuffTips()
    ----隐藏tips
    if self.panel ~= nil then
        self.panel.buffTip.gameObject:SetActiveEx(false)
    end
    if l_tipsTimer ~= nil then
        self:StopUITimer(l_tipsTimer)
        l_tipsTimer = nil
    end
    l_showTips = false
    self.curId = 0
end

function MainRoleInfoCtrl:AutoSetPanelSize(count)
    ----panel 自适应
    if count == 0 then
        return
    end
    local l_bg = self.panel.buffTip.gameObject.transform:Find("Buff"):GetComponent("RectTransform")
    local l_scroll = self.panel.MainScrollView.gameObject:GetComponent("ScrollRect")
    local l_scrollBG = self.panel.MainScrollView.gameObject:GetComponent("RaycastImage")
    local l_mask = self.panel.MainScrollView.gameObject.transform:Find("Viewport"):GetComponent("RaycastImage")
    l_scrollBG.enabled = false
    if count > 6 then
        l_scrollBG.enabled = true
        l_scroll.enabled = true
        l_mask.enabled = true
        l_bg.sizeDelta = Vector2.New(l_width, l_height - 34)
        return
    end
    if count > 4 then
        l_scrollBG.enabled = true
        l_scroll.enabled = true
        l_mask.enabled = true
        l_bg.sizeDelta = Vector2.New(l_width, l_height - 49)
        return
    end
    if count > 2 then
        l_scroll.enabled = false
        l_mask.enabled = false
        l_bg.sizeDelta = Vector2.New(l_width, (l_height / 3) * 2 - 25)
        return
    end
    if count == 2 then
        l_scroll.enabled = false
        l_mask.enabled = false
        l_bg.sizeDelta = Vector2.New(l_width, l_height / 3 - 5)
        return
    end
    if count == 1 then
        l_scroll.enabled = false
        l_mask.enabled = false
        l_bg.sizeDelta = Vector2.New(l_width / 2 + 10, l_height / 3 - 5)
    end
end

function MainRoleInfoCtrl:CreateAddItem(i)
    l_buffAddItem[i] = {}
    local l_item = self:CloneObj(self.panel.addBuff.gameObject)
    local l_trans = l_item.transform
    --l_item.transform:SetParent(self.panel.buffList.gameObject.transform)
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.addBuff.gameObject.transform.localScale
    l_item:SetActiveEx(false)
    self:ExportItem(l_item, l_buffAddItem[i])
end

function MainRoleInfoCtrl:CreateAddTips(i)
    l_buffAddTips[i] = {}
    local l_tips = self:CloneObj(self.panel.addBuffInfo.gameObject)
    local l_trans = l_tips.transform
    --l_tips.transform:SetParent(self.panel.buffInfoGrid.gameObject.transform)
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.addBuffInfo.gameObject.transform.localScale
    l_tips:SetActiveEx(false)
    self:ExportTips(l_tips, l_buffAddTips[i])
end

function MainRoleInfoCtrl:CreateAddAffixTips(i)
    l_buffAffixTips[i] = {}
    local l_tips = self:CloneObj(self.panel.addBuffInfo.gameObject)
    local l_trans = l_tips.transform
    --l_tips.transform:SetParent(self.panel.buffInfoGrid.gameObject.transform)
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.addBuffInfo.gameObject.transform.localScale
    l_tips:SetActiveEx(false)
    self:ExportTips(l_tips, l_buffAffixTips[i])
end

function MainRoleInfoCtrl:CreateReduceItem(i)
    l_buffReduceItem[i] = {}
    local l_item = self:CloneObj(self.panel.reduceBuff.gameObject)
    local l_trans = l_item.transform
    --l_item.transform:SetParent(self.panel.buffList.gameObject.transform)
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.reduceBuff.gameObject.transform.localScale
    l_item:SetActiveEx(false)
    self:ExportItem(l_item, l_buffReduceItem[i])
end

function MainRoleInfoCtrl:CreateReduceTips(i)
    l_buffReduceTips[i] = {}
    local l_tips = self:CloneObj(self.panel.reduceBuffInfo.gameObject)
    --l_tips.transform:SetParent(self.panel.buffInfoGrid.gameObject.transform)
    local l_trans = l_tips.transform
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.reduceBuffInfo.gameObject.transform.localScale
    l_tips:SetActiveEx(false)
    self:ExportTips(l_tips, l_buffReduceTips[i])
end

function MainRoleInfoCtrl:RefreshRoleInfo()
    self:RefreshHead()
    Data.PlayerInfoModel:setBaseLv(MPlayerInfo.Lv)
    Data.PlayerInfoModel:setJobLv(MPlayerInfo.JobLv)
    Data.PlayerInfoModel:setBaseExpData(MPlayerInfo.ExpRate)
    Data.PlayerInfoModel:setJobExpData(MPlayerInfo.JobExpRate)
    Data.PlayerInfoModel:setBaseExpBlessData(MPlayerInfo.BlessExpRate)
    Data.PlayerInfoModel:setJobExpBlessData(MPlayerInfo.BlessJobExpRate)
    self:RefreshProfession()
    self:InitBasicInfo()
    self:_setBattleCompState()
    self:_updatePlayerKDA()
end

--- 设置KDA组件的显隐状态
function MainRoleInfoCtrl:_setBattleCompState()
    local showBattleInfo = ModuleMgr.StageMgr:IsStage(MStageEnum.Battle)
    ---狩猎场由于使用了战场的面板类型，但是不想打开KDA面板，故作此特判
    self.panel.Battle:SetActiveEx(showBattleInfo and MGlobalConfig:GetInt("HuntingGroundSceneID") ~= MScene.SceneID)
end

--- 更新玩家自身KDA
function MainRoleInfoCtrl:_updatePlayerKDA()
    --- 如果UI没开，就不刷新了
    if not self.panel.Battle.gameObject.activeSelf then
        return
    end

    local targetPlayerKDA = MgrMgr:GetMgr("BattleMgr").GetPlayerKDA()
    if nil == targetPlayerKDA then
        logError("[MainRoleCtrl] invalid state")
        return
    end

    self.panel.Txt_KillNum.LabText = tostring(targetPlayerKDA.Kill)
    self.panel.Txt_AssistNum.LabText = tostring(targetPlayerKDA.AssistKill)
    self.panel.Txt_DeathNum.LabText = tostring(targetPlayerKDA.Death)
end

return MainRoleInfoCtrl

--lua custom scripts end
