--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GameHelpPanel"
require "UI/Template/GameHelpItem"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GameHelpCtrl = class("GameHelpCtrl", super)
--lua class define end

--lua functions
function GameHelpCtrl:ctor()
    super.ctor(self, CtrlNames.GameHelp, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function GameHelpCtrl:Init()
    self.panel = UI.GameHelpPanel.Bind(self)
    super.Init(self)
    self:_initConfig()
    self:OnInitialize()
end --func end
--next--
function GameHelpCtrl:Uninit()
    self:UnInitialize()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GameHelpCtrl:OnActive()
    local targetData = self.uiPanelData.type
    local configData = self.C_TYPE_CONFIG_MAP[targetData]
    if nil == configData then
        logError("[GameHelper] invalid type: " .. tostring(targetData))
        return
    end

    --- 新手引导，这个界面当中目前只有战场说明需要添加新手引导，如果其他类型的说明也需要添加新手引导；则添加到配置表当中
    if MStageEnum.Battle == targetData or MStageEnum.BattlePre == targetData then
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "BattleFieldGuideHint" })
    end

    self:_setPanelInfo(configData.title, configData.content, configData.btnName, configData.onClick)
end --func end
--next--
function GameHelpCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function GameHelpCtrl:Update()
    -- do nothing
end --func end

--next--
function GameHelpCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts
function GameHelpCtrl:_initConfig()
    ---@type table<number, GameHelpData>
    self.C_TYPE_CONFIG_MAP = {
        [MStageEnum.RingPre] = { title = Common.Utils.Lang("ARENA_HELP_INTRODUCE"), content = Common.Utils.Lang("ARENA_INFO_TIPS"), btnName = Common.Utils.Lang("ARENA_INTRODUCE_VIDEO"), onClick = nil },
        [MStageEnum.Ring] = { title = Common.Utils.Lang("ARENA_HELP_INTRODUCE"), content = Common.Utils.Lang("ARENA_INFO_TIPS"), btnName = Common.Utils.Lang("ARENA_INTRODUCE_VIDEO"), onClick = nil },
        [MStageEnum.BattlePre] = { title = Common.Utils.Lang("BATTLE_HELP_INTRODUCE"), content = Common.Utils.Lang("BATTLE_INFO_TIPS"), btnName = Common.Utils.Lang("BATTLE_INTRODUCE_VIDEO"), onClick = self._playBattleFieldIntroVideo },
        [MStageEnum.Battle] = { title = Common.Utils.Lang("BATTLE_HELP_INTRODUCE"), content = Common.Utils.Lang("BATTLE_INFO_TIPS"), btnName = Common.Utils.Lang("BATTLE_INTRODUCE_VIDEO"), onClick = self._playBattleFieldIntroVideo },
        [MStageEnum.MatchPre] = { title = Common.Utils.Lang("GUILDMATCH_INFO_TITLE"), content = Common.Utils.Lang("GUILDMATCH_INFO_MAINTXT"), btnName = Common.Utils.Lang("BATTLE_INTRODUCE_VIDEO"), onClick = nil },
        [MStageEnum.Match] = { title = Common.Utils.Lang("GUILDMATCH_INFO_TITLE"), content = Common.Utils.Lang("GUILDMATCH_INFO_MAINTXT"), btnName = Common.Utils.Lang("BATTLE_INTRODUCE_VIDEO"), onClick = nil },
    }
end

function GameHelpCtrl:OnInitialize()
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GameHelp)
    end)

    self.HelperTems = self:NewTemplatePool({
        ScrollRect = self.panel.ScrollView.LoopScroll,
        UITemplateClass = UITemplate.GameHelpItem,
        TemplatePrefab = self.panel.GameHelpItem.LuaUIGroup.gameObject
    })
end

function GameHelpCtrl:UnInitialize()
    self.HelperTems = nil
end

function GameHelpCtrl:_setPanelInfo(title, info, btnName, btnFunc)
    self.panel.Title.LabText = title
    self.panel.BtnText.LabText = btnName
    self.panel.NextBtn.gameObject:SetActiveEx(nil ~= btnFunc)
    if nil ~= btnFunc then
        self.panel.NextBtn:AddClickWithLuaSelf(btnFunc, self)
    end

    local l_data = {}
    local l_info = string.ro_split(info, "&")
    if #l_info > 0 then
        local l_index = #l_data + 1
        l_data[l_index] = {}
        for i = 1, #l_info do
            local l_target = l_info[i]
            local imageInfo = string.ro_split(l_target, "%$")
            if #imageInfo == 2 then
                l_data[l_index].img = imageInfo
                l_index = #l_data + 1
                l_data[l_index] = {}
            end
            if #imageInfo ~= 2 then
                if l_data[l_index].str then
                    l_index = #l_data + 1
                    l_data[l_index] = {}
                end
                l_data[l_index].str = l_target
            end
        end
    end

    if #l_data then
        self.HelperTems:ShowTemplates({ Datas = l_data })
    end
end

--- 播放战场介绍视频
function GameHelpCtrl:_playBattleFieldIntroVideo()
    UIMgr:ActiveUI(UI.CtrlNames.CommonVideo, { type = GameEnum.EPvPLuaType.BattleField })
end

--lua custom scripts end
