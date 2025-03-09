--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildRankPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl

local ELuaBaseType = GameEnum.ELuaBaseType
local guildRankMgr = MgrMgr:GetMgr("GuildRankMgr")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

--- 下拉列表上显示的内容
local C_DROP_DOWN_OPTIONS = {
    Lang("C_GUILD_TOTAL"),
    Lang("C_GUILD_ACT_HUNT"),
    Lang("C_GUILD_ACT_COOK"),
    Lang("C_GUILD_ACT_ELITE_MATCH"),
    -- Lang("C_GUILD_ACT_GVG"),
}

--- 页面上选中的下拉列表的需要和类型的映射
local C_IDX_TYPE_MAP = {
    [0] = GameEnum.EGuildScoreType.Total,
    [1] = GameEnum.EGuildScoreType.GuildHunt,
    [2] = GameEnum.EGuildScoreType.GuildCooking,
    [3] = GameEnum.EGuildScoreType.GuildEliteMatch,
    -- [1] = GameEnum.EGuildScoreType.GVG,
}
--lua fields end

--lua class define
GuildRankCtrl = class("GuildRankCtrl", super)
--lua class define end

--lua functions
function GuildRankCtrl:ctor()
    super.ctor(self, CtrlNames.GuildRank, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function GuildRankCtrl:Init()
    self.panel = UI.GuildRankPanel.Bind(self)
    super.Init(self)
    self:_initTemplatePoolConfig()
    self:_initWidgets()

    self._countDown = Common.CommonCountDownUtil.new()
end --func end
--next--
function GuildRankCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GuildRankCtrl:OnActive()
    self:_resetPageState()

    ---@type CountDownUtilParam
    local param = {
        totalTime = guildRankMgr.GetRemainSeconds(),
        clearCallback = self._onTimeOut,
        clearCallbackSelf = self,
    }

    self._countDown:Init(param)
    self._countDown:Start()
end --func end
--next--
function GuildRankCtrl:OnDeActive()

end --func end
--next--
function GuildRankCtrl:Update()
    self._countDown:OnUpdate()
end --func end
--next--
function GuildRankCtrl:BindEvents()
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnRefreshGuildRank, self._onRefreshGuildRank)
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.ForceRefreshGuildRank, self._onForceRefresh)
end --func end
--next--
--lua functions end

--lua custom scripts
--- 如果时间到了
function GuildRankCtrl:_onTimeOut()
    guildRankMgr.ForceRefreshAll()
end

function GuildRankCtrl:_initTemplatePoolConfig()
    self._rankInfoConfig = {
        TemplateClassName = "GuildFullInfoRankTemplate",
        TemplatePath = "UI/Prefabs/GuildFullInfoRankTemplate",
        ScrollRect = self.panel.LoopScroll_RankInfo.LoopScroll,
        GetDatasMethod = function()
            return self:_getTemplateDataList()
        end,
    }
end

---@return GuildRankDataWrap[]
function GuildRankCtrl:_getTemplateDataList()
    local rankDataList = guildRankMgr.GetGuildRankListByType(self._pageType, self._filtrateType, true)

    ---@type GuildRankDataWrap[]
    local param = {}
    for i = 1, #rankDataList do
        ---@type GuildRankDataWrap
        local data = {}
        data.onSetDataCb = self._onTemplateShow
        data.onSetDataSelf = self
        data.guildRankData = rankDataList[i]
        table.insert(param, data)
    end

    return param
end

function GuildRankCtrl:_initWidgets()
    ---@type UI_TemplatePoolCommon
    self._guildInfoTemplates = self:NewTemplatePool(self._rankInfoConfig)
    self.panel.Btn_Close:AddClick(guildRankMgr.OnRankPanelClose)
    self.panel.Dropdown:SetDropdownOptions(C_DROP_DOWN_OPTIONS)
    local onDropDownValueChanged = function(index)
        self:_onDropDownValueChange(index)
    end

    local onEliteToggleOn = function(on)
        self:_onToggleEliteOn(on)
    end

    local onNormalToggleOn = function(on)
        self:_onToggleNormalOn(on)
    end

    self.panel.Dropdown.DropDown.onValueChanged:AddListener(onDropDownValueChanged)
    self.panel.Tog_EliteRank:OnToggleExChanged(onEliteToggleOn)
    self.panel.Tog_HonorRank:OnToggleExChanged(onNormalToggleOn)
    self.panel.Btn_Hint.Listener.onDown = self._onHintClick
end

--- 当页面刚刚打开的时候会将页面置为默认值，默认选择精英组的全积分
function GuildRankCtrl:_resetPageState()
    self._filtrateType = GameEnum.EGuildScoreType.Total
    if guildRankMgr.IsFirstSeason() then
        self._pageType = GameEnum.EGuildRankPageType.Normal
    else
        self._pageType = GameEnum.EGuildRankPageType.Elite
    end

    self._guildInfoTemplates:ShowTemplates({})
    guildRankMgr.TryRefreshRankPage(self._pageType, self._filtrateType, false)
end

--- 收到消息之后会对页面进行强制刷新
function GuildRankCtrl:_onForceRefresh()
    self._guildInfoTemplates:ShowTemplates({})
    guildRankMgr.TryRefreshRankPage(self._pageType, self._filtrateType, true)
end

--- 点击问号获取提示
function GuildRankCtrl._onHintClick(go, eventData)
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("C_GUILD_RANK_PANEL_HINT"), eventData, Vector2(0, 0), true)
end

--- 收到消息刷新页面，这个页面数据是根据消息来刷新的
---@param param GuildRankPageState
function GuildRankCtrl:_onRefreshGuildRank(param)
    if nil == param then
        logError("[GuildRank] event param got nil")
        return
    end

    self._pageType = param.pageState
    self._filtrateType = param.typeState
    local remainTimeStr = StringEx.Format(Lang("C_GUILD_SEASON_TIME"), tostring(guildRankMgr.GetRemainDays()))
    self.panel.Txt_TimeRemaining.LabText = remainTimeStr
    self:_setPageInfo(self._pageType, self._filtrateType, param.needRefresh)
    if GameEnum.EGuildRankPageType.Elite == self._pageType then
        self.panel.Tog_EliteRank.TogEx.isOn = true
        self.panel.Tog_HonorRank.TogEx.isOn = false
    elseif GameEnum.EGuildRankPageType.Normal == self._pageType then
        self.panel.Tog_EliteRank.TogEx.isOn = false
        self.panel.Tog_HonorRank.TogEx.isOn = true
    end

    self.panel.Tog_EliteRank:SetActiveEx(not guildRankMgr.IsFirstSeason())
    self.panel.Tog_HonorRank:SetActiveEx(not guildRankMgr.IsFirstSeason())
end

--- 重置页面数据
function GuildRankCtrl:_setPageInfo(pageState, filtrateState, needRefresh)
    if needRefresh then
        self._guildInfoTemplates:ShowTemplates({})
    else
        local rankDataList = guildRankMgr.GetGuildRankListByType(self._pageType, self._filtrateType, true)
        self.panel.LoopScroll_RankInfo.LoopScroll:ChangeTotalCount(#rankDataList)
    end

    self.panel.Txt_Rank.LabText = guildRankMgr.GetGuildRankStr()
    self.panel.Txt_Score.LabText = tostring(guildRankMgr.GetSelfGuildScoreByType(GameEnum.EGuildScoreType.Total))
end

---滚动的每一条数据出现的时候，都会调用这个方法
--- 每次调用这个方法之后会判断是否已经达到了一定的数量，然后回判断是否要进行扩容
---@param idx number
function GuildRankCtrl:_onTemplateShow(idx)
    guildRankMgr.TryExpendData(self._pageType, self._filtrateType, idx)
end

--- 当下拉列表当中的选项发生了变化，会调用这个方法
function GuildRankCtrl:_onDropDownValueChange(index)
    if ELuaBaseType.Number ~= type(index) then
        logError("[GuildRank] invalid param")
        return
    end

    local targetType = C_IDX_TYPE_MAP[index]
    if nil == targetType then
        logError("[GuildRank] invalid idx: " .. tostring(index))
        return
    end

    guildRankMgr.TryRefreshRankPage(self._pageType, targetType, false)
end

--- 当选中了精英组的时候会触发这个方法
function GuildRankCtrl:_onToggleEliteOn(switchOn)
    if not switchOn then
        return
    end

    guildRankMgr.TryRefreshRankPage(GameEnum.EGuildRankPageType.Elite, self._filtrateType, false)
end

--- 当选中了普通组的时候才会触发这个方法
function GuildRankCtrl:_onToggleNormalOn(switchOn)
    if not switchOn then
        return
    end

    guildRankMgr.TryRefreshRankPage(GameEnum.EGuildRankPageType.Normal, self._filtrateType, false)
end

--lua custom scripts end
return GuildRankCtrl