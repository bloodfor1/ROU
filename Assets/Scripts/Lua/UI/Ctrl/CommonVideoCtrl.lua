--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CommonVideoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
CommonVideoCtrl = class("CommonVideoCtrl", super)
--lua class define end

--lua functions
function CommonVideoCtrl:ctor()
    super.ctor(self, CtrlNames.CommonVideo, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function CommonVideoCtrl:Init()
    self.panel = UI.CommonVideoPanel.Bind(self)
    super.Init(self)

    self:_initData()
    self:_onInitialize()
end --func end
--next--
function CommonVideoCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function CommonVideoCtrl:OnActive()
    VideoPlayerMgr:BindMediaPlayer(self.panel.MoviePanel.gameObject, true)
    self._targetData = self.uiPanelData.type
    self:_playVideoInterface()
end --func end
--next--
function CommonVideoCtrl:OnDeActive()
    VideoPlayerMgr:BindMediaPlayer(self.panel.MoviePanel.gameObject, false)
    VideoPlayerMgr:Stop()
end --func end
--next--
function CommonVideoCtrl:Update()
    -- do nothing
end --func end
--next--
function CommonVideoCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts

function CommonVideoCtrl:_playVideoInterface()
    local configData = self.C_TYPE_VIDEO_DATA_MAP[self._targetData]
    if nil == configData then
        logError("[CommonVideoCtrl] invalid type: " .. tostring(self._targetData))
        return
    end

    self:_playVideo(configData.title, configData.path)
end

function CommonVideoCtrl:_initData()
    ---@type table<number, VideoPlayerData>
    self.C_TYPE_VIDEO_DATA_MAP = {
        -- [GameEnum.EPvPLuaType.Ring] = { title = Common.Utils.Lang("ARENA_INTRODUCE_VIDEO"), path = "BattleVideo.mp4", eventName = "event:/Video/Skill200012" },
        [GameEnum.EPvPLuaType.BattleField] = { title = Common.Utils.Lang("BATTLE_INTRODUCE_VIDEO"), path = "BattleVideo.mp4", eventName = "event:/Video/Skill200012" },
    }
end

function CommonVideoCtrl:_onInitialize()
    self.moviePanel = self.panel.MoviePanel
    self.panel.CloseBtn:AddClickWithLuaSelf(self._onClose, self)
    self.panel.PauseBtn:AddClickWithLuaSelf(self._onPause, self)
    self.panel.PauseBtn.gameObject:SetActiveEx(false)
end

function CommonVideoCtrl:_playVideo(title, location)
    self.panel.Title.LabText = title
    if not location then
        UIMgr:DeActiveUI(UI.CtrlNames.CommonVideo)
        return
    end

    VideoPlayerMgr:Prepare(location, true, nil, nil, function()
        self.panel.PauseBtn.gameObject:SetActiveEx(true)
    end)
end

function CommonVideoCtrl:_onClose()
    UIMgr:DeActiveUI(UI.CtrlNames.CommonVideo)
end

function CommonVideoCtrl:_onPause()
    VideoPlayerMgr:Stop()
    self:_playVideoInterface()
    self.panel.PauseBtn.gameObject:SetActiveEx(false)
end

--lua custom scripts end
return CommonVideoCtrl