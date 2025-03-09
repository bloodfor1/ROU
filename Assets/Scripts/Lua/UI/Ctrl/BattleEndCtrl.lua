--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleEndPanel"
require "Common/Utils"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
BattleEndCtrl = class("BattleEndCtrl", super)
--lua class define end

--lua functions
function BattleEndCtrl:ctor()
    super.ctor(self, CtrlNames.BattleEnd, UILayer.Function, nil, ActiveType.Exclusive)
    self.pvpMgr = MgrMgr:GetMgr("PvpMgr")
    self.MaskColor = BlockColor.Dark
    self.GroupMaskType = GroupMaskType.Show
end --func end
--next--
function BattleEndCtrl:Init()
    self.panel = UI.BattleEndPanel.Bind(self)
    super.Init(self)

    ---@type BattleFieldEndSinglePlayerData[]
    self._teamA = nil
    ---@type BattleFieldEndSinglePlayerData[]
    self._teamB = nil
    self:_initConfig()
    self:_initWidgets()
    self:_stopTimer()
    self.canvas.enabled = false
    local l_btn = self.panel.PanelRef.gameObject.transform:Find("btn").gameObject
    local l_duration = 0
    self._timer = self:NewUITimer(function()
        l_duration = l_duration - 1
        if l_duration < 0 then
            self:_stopTimer()
            self.canvas.enabled = true
            self.panel.BG:SetActiveEx(true)
            l_btn:SetActiveEx(true)
            local dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID)
            local l_sec = dungeonData == nil and 15 or dungeonData.TimeToKick
            local fixTime = MGlobalConfig:GetInt("BgCloseDecreaseTime", 15)
            l_sec = l_sec - fixTime
            self:_showResultPanel(MgrMgr:GetMgr("BattleMgr").g_campInfo, l_sec, function()
                self:_onLeaveSceneBtnClick()
            end)
        end
    end, 1, -1, true)
    self._timer:Start()
end --func end
--next--
function BattleEndCtrl:Uninit()
    MPlayerInfo:FocusToMyPlayer()
    self:_stopTimer()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function BattleEndCtrl:OnActive()
    -- do nothing
end --func end
--next--
function BattleEndCtrl:OnDeActive()
    self:_stopTimer()
end --func end
--next--
function BattleEndCtrl:Update()
    -- do nothing
end --func end
--next--
function BattleEndCtrl:BindEvents()
    --- 结算数据下发过程中是不含有任何表现数据的，表现数据需要向服务器额外请求；当时数据完成请求之后，才会开启界面
    self:BindEvent(MgrMgr:GetMgr("HeadMgr").EventDispatcher, EventConst.Names.HEAD_SET_HEDA, self._onHeadDataUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts

function BattleEndCtrl:_initConfig()
    self._leftPlayerListConfig = {
        TemplateClassName = "BtnPlayerLeft",
        TemplatePrefab = self.panel.BtnPlayerLeft.gameObject,
        ScrollRect = self.panel.ScrollViewBlue.LoopScroll,
    }

    self._rightPlayerListConfig = {
        TemplateClassName = "BtnPlayerRight",
        TemplatePrefab = self.panel.BtnPlayerRight.gameObject,
        ScrollRect = self.panel.ScrollViewRed.LoopScroll,
    }
end

function BattleEndCtrl:_initWidgets()
    self._blueList = self:NewTemplatePool(self._leftPlayerListConfig)
    self._redList = self:NewTemplatePool(self._rightPlayerListConfig)
    local battleMgr = MgrMgr:GetMgr("BattleMgr")
    local killAtlas, killSP = battleMgr.GetPlayerTag(GameEnum.EBattleFieldTagType.MostKill)
    self.panel.ImageMostKill:SetSpriteAsync(killAtlas, killSP)
    local assistAtlas, assistSp = battleMgr.GetPlayerTag(GameEnum.EBattleFieldTagType.MostAssist)
    self.panel.ImageMostAssist:SetSpriteAsync(assistAtlas, assistSp)
    local healAtlas, healSp = battleMgr.GetPlayerTag(GameEnum.EBattleFieldTagType.MostHeal)
    self.panel.ImageMostHeal:SetSpriteAsync(healAtlas, healSp)
    local damageAtlas, damageSp = battleMgr.GetPlayerTag(GameEnum.EBattleFieldTagType.MostDamage)
    self.panel.ImageMostDamage:SetSpriteAsync(damageAtlas, damageSp)
    self.panel.TxtMostKill.LabText = Common.Utils.Lang("C_MOST_KILL")
    self.panel.TxtMostAssist.LabText = Common.Utils.Lang("C_MOST_ASSIST")
    self.panel.TxtMostDamage.LabText = Common.Utils.Lang("C_MOST_DAMAGE")
    self.panel.TxtMostHeal.LabText = Common.Utils.Lang("C_MOST_HEAL")
end

---@param info BattleFieldResultDataPack
---@param sec number
---@param clickCallBack function
function BattleEndCtrl:_showResultPanel(info, sec, clickCallBack)
    local l_head = {}
    for i, v in pairs(info.teamA) do
        table.insert(l_head, v.id)
    end

    for i, v in pairs(info.teamB) do
        table.insert(l_head, v.id)
    end

    self:_setPlayerData(info)
    self.panel.RawImage.RawImg.texture = self.pvpMgr.g_BattleTex
    self.panel.RawImage.gameObject:SetActiveEx(true)
    self.panel.Title.gameObject:SetActiveEx(true)
    self.panel.btn.gameObject:SetActiveEx(true)
    local l_mgr = MgrMgr:GetMgr("BattleMgr")
    if l_mgr.DidBattleWin() then
        self.panel.win.gameObject:SetActiveEx(true)
        self.panel.lose.gameObject:SetActiveEx(false)
    else
        self.panel.win.gameObject:SetActiveEx(false)
        self.panel.lose.gameObject:SetActiveEx(true)
    end

    self:_setHeadIconThroughSvr(l_head)
    self.panel.btn:AddClick(clickCallBack)
    self:_showLeftTimer(sec, clickCallBack)
    self.hidePanel = false
    self.panel.HideBtn:AddClickWithLuaSelf(self._onHidePanel, self)
    self.panel.SavaBtn:AddClickWithLuaSelf(self._onSaveToPhoneClick, self)
    self.panel.MobileBtn:AddClickWithLuaSelf(self._onSaveToAlbumClick, self)
end

--- 设置结算界面当中玩家的数据
---@param info BattleFieldResultDataPack
function BattleEndCtrl:_setPlayerData(info)
    if nil == info then
        logError("[BattleEndCtrl] invalid param")
        return
    end

    local tagMap = self:_buildPlayerTagMap(info)
    self._teamA = self:_parseDataParam(info.teamA, true)
    self._teamB = self:_parseDataParam(info.teamB, false)
    self:_setTagList(self._teamA, tagMap)
    self:_setTagList(self._teamB, tagMap)
end

---@param paramList BattleFieldEndSinglePlayerData[]
---@param tagMap table<uint64, number[]>
function BattleEndCtrl:_setTagList(paramList, tagMap)
    if nil == paramList or nil == tagMap then
        logError("[BattleEndCtrl] invalid param")
        return
    end

    for i = 1, #paramList do
        local singleData = paramList[i]
        if nil ~= tagMap[singleData.PlayerUID] then
            singleData.TagList = tagMap[singleData.PlayerUID]
        end
    end
end

---@param info BattleFieldResultDataPack
---@return table<uint64, number[]>
function BattleEndCtrl:_buildPlayerTagMap(info)
    if nil == info then
        logError("[BattleEndCtrl] invalid param")
        return {}
    end

    local fullList = {}
    table.ro_insertRange(fullList, info.teamA)
    table.ro_insertRange(fullList, info.teamB)
    local mostKillUID = self:_getTagUidByType(GameEnum.EBattleFieldTagType.MostKill, fullList)
    local mostAssistUID = self:_getTagUidByType(GameEnum.EBattleFieldTagType.MostAssist, fullList)
    local mostDamageUID = self:_getTagUidByType(GameEnum.EBattleFieldTagType.MostDamage, fullList)
    local mostHealUID = self:_getTagUidByType(GameEnum.EBattleFieldTagType.MostHeal, fullList)
    local typeUIDMap = {
        [GameEnum.EBattleFieldTagType.MostKill] = mostKillUID,
        [GameEnum.EBattleFieldTagType.MostAssist] = mostAssistUID,
        [GameEnum.EBattleFieldTagType.MostDamage] = mostDamageUID,
        [GameEnum.EBattleFieldTagType.MostHeal] = mostHealUID,
    }

    local ret = {}
    for k, v in pairs(typeUIDMap) do
        if nil == ret[v] then
            ret[v] = {}
        end

        table.insert(ret[v], k)
    end

    --- 为了保证标签中的内容是固定顺序的，这边需要做个排序
    for k, v in pairs(ret) do
        table.sort(ret[k])
    end

    return ret
end

--- 根据标记的类型获取标记的UID
---@param fullList BattleFieldResultDataPack
---@return uint64
function BattleEndCtrl:_getTagUidByType(tagType, fullList)
    local C_TYPE_PARAM_NAME_MAP = {
        [GameEnum.EBattleFieldTagType.MostKill] = "kill",
        [GameEnum.EBattleFieldTagType.MostAssist] = "help",
        [GameEnum.EBattleFieldTagType.MostDamage] = "damage",
        [GameEnum.EBattleFieldTagType.MostHeal] = "heal",
    }

    local ret = 0
    local mostValue = 0
    local paramKey = C_TYPE_PARAM_NAME_MAP[tagType]
    for i = 1, #fullList do
        local singleValue = fullList[i][paramKey]
        if nil ~= singleValue and singleValue > mostValue then
            mostValue = singleValue
            ret = fullList[i].id
        end
    end

    return ret
end

---@param infoList BattleFieldResultData[]
---@param showMvp boolean
---@return BattleFieldEndSinglePlayerData[]
function BattleEndCtrl:_parseDataParam(infoList, showMvp)
    if nil == infoList then
        logError("[BattleEndCtrl] invalid param, return empty table")
        return {}
    end

    local ret = {}
    for i = 1, #infoList do
        local singleData = infoList[i]
        ---@type BattleFieldEndSinglePlayerData
        local param = {
            PlayerUID = singleData.id,
            Score = singleData.score,
            KillNum = singleData.kill,
            AssistNum = singleData.help,
            OnAddFriendClick = self._onAddFriendClick,
            OnAddFriendClickSelf = self,
            OnLikeClick = self._onLikeClick,
            OnLikeClickSelf = self,
            IsMvp = showMvp and 1 == i
        }

        table.insert(ret, param)
    end

    return ret
end

function BattleEndCtrl:_showLeftTimer(sec, clickCallBack)
    local l_seconds = sec % 60
    local l_mins = math.floor(sec / 60)
    self.panel.Text.LabText = StringEx.Format("{0:00}:{1:00}", l_mins, l_seconds)
    self:_stopTimer()
    local l_duration = sec
    self._timer = self:NewUITimer(function()
        l_duration = l_duration - 1
        local l_seconds = l_duration % 60
        local l_mins = math.floor(l_duration / 60)
        self.panel.Text.LabText = StringEx.Format("{0:00}:{1:00}", l_mins, l_seconds) .. Common.Utils.Lang("BATTLE_EXIT")
        if l_duration < 1 then
            self:_stopTimer()
            if clickCallBack then
                clickCallBack()
            end
        end
    end, 1, -1, true)
    self._timer:Start()
end

function BattleEndCtrl:_onHidePanel()
    self.panel.btn.gameObject:SetActiveEx(self.hidePanel)
    self.panel.Title.gameObject:SetActiveEx(self.hidePanel)
    self.panel.BG:SetActiveEx(self.hidePanel)
    self.hidePanel = not self.hidePanel
end

function BattleEndCtrl:_onSaveToPhoneClick()
    self.pvpMgr.Save2Phone()
end

function BattleEndCtrl:_onSaveToAlbumClick()
    self.pvpMgr.Save2Photo()
end

function BattleEndCtrl:_onLikeClick(roleId, name)
    if MPlayerInfo.UID == roleId then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CANNOT_PRAISE_SELF"))
        return
    end

    local l_name = name
    local l_showTxt = Lang("PRAISE_FORMAT", l_name)
    local l_delayTime = MGlobalConfig:GetFloat("PraiseStayTime")
    CommonUI.Dialog.ShowPraiseDlg(tostring(roleId), nil, l_showTxt, l_delayTime)
end

function BattleEndCtrl:_onAddFriendClick(roleId)
    MgrMgr:GetMgr("FriendMgr").RequestAddFriend(roleId)
end

--- 像服务器发消息来更新角色头像
function BattleEndCtrl:_setHeadIconThroughSvr(roleIdList)
    MgrMgr:GetMgr("HeadMgr").SetHead(roleIdList)
end

function BattleEndCtrl:_onLeaveSceneBtnClick()
    MgrMgr:GetMgr("DungeonMgr").LeaveDungeon()
end

function BattleEndCtrl:_stopTimer()
    if nil == self._timer then
        return
    end

    self:StopUITimer(self._timer)
    self._timer = nil
end

--- 获取道角色数据之后，补全数据，再显示UI
--- 需要注意的是这里不能通过单个template接收消息来更新，因为有可能出现template接收到了消息，但是本身并没有被创建出来的情况，这个时候会丢失数据
function BattleEndCtrl:_onHeadDataUpdate(headInfos, roleIdList)
    self:_completeSingleList(self._teamA, headInfos)
    self:_completeSingleList(self._teamB, headInfos)
    self._blueList:ShowTemplates({ Datas = self._teamA })
    self._redList:ShowTemplates({ Datas = self._teamB })
end

---@param playerDataList BattleFieldEndSinglePlayerData[]
function BattleEndCtrl:_completeSingleList(playerDataList, headInfoMap)
    if nil == playerDataList or nil == headInfoMap then
        logError("[BattleEndCtrl] invalid param")
        return
    end

    for i = 1, #playerDataList do
        local singleData = playerDataList[i]
        local targetData = headInfoMap[tostring(singleData.PlayerUID)]
        if nil ~= targetData then
            singleData.PlayerEquipData = targetData.attr.EquipData
            singleData.PlayerPro = targetData.player.role_type
            singleData.PlayerName = targetData.player.name
        end
    end
end

--lua custom scripts end
return BattleEndCtrl
