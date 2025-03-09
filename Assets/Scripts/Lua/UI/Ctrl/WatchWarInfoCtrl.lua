--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/WatchWarInfoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
WatchWarInfoCtrl = class("WatchWarInfoCtrl", super)
--lua class define end

--lua functions
function WatchWarInfoCtrl:ctor()
	
	super.ctor(self, CtrlNames.WatchWarInfo, UILayer.Function, UITweenType.Alpha, ActiveType.Normal)
	
end --func end
--next--
function WatchWarInfoCtrl:Init()
	
	self.panel = UI.WatchWarInfoPanel.Bind(self)
	super.Init(self)
	
	self.panel.Anchor.gameObject:SetActiveEx(false)

	self.initialize = nil
	self.lastSpectatorNum = nil
	self.lastBeLikedNum = nil
end --func end
--next--
function WatchWarInfoCtrl:Uninit()
	
	self.initialize = nil
	self.lastSpectatorNum = nil
	self.lastBeLikedNum = nil

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function WatchWarInfoCtrl:OnActive()
	self:CustomRefresh()
end --func end
--next--
function WatchWarInfoCtrl:OnDeActive()
	
	MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_UpdateMapDebugInfoVisible, true)
end --func end
--next--
function WatchWarInfoCtrl:Update()
	
	
end --func end

--next--
function WatchWarInfoCtrl:BindEvents()
	local l_mgr = MgrMgr:GetMgr("WatchWarMgr")
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.ON_MAIN_WATCH_ALL_BRIEF_INFO, self.CustomRefresh)
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.ON_MAIN_ROOM_WATCH_INFO_DATA, self.CustomRefresh)
end --func end
--next--
--lua functions end

--lua custom scripts

function WatchWarInfoCtrl:RefreshDatas()

	local l_mgr = MgrMgr:GetMgr("WatchWarMgr")
	local l_data = DataMgr:GetData("WatchWarData").MainWatchRoomInfo
	if not l_data then
		return
	end

	if l_data.spectators_num == nil or l_data.beliked_times == nil then
		return
	end

	if l_data.spectators_num then
		if (not l_mgr.IsInSpectator()) and (l_data.spectators_num < DataMgr:GetData("WatchWarData").SpectatorMinUiAudience) then
			self.panel.NumberText.LabText = DataMgr:GetData("WatchWarData").SpectatorMinUiAudience
		else
			self.panel.NumberText.LabText = l_data.spectators_num
		end
	end

	if l_data.beliked_times then
		self.panel.FabulousText.LabText = l_data.beliked_times
	end

	return true
end

function WatchWarInfoCtrl:CustomRefresh()
	
	if not self.initialize then
		self.lastSpectatorNum = nil
		self.lastBeLikedNum = nil
		if self:RefreshDatas() then
			if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
				self.panel.Anchor.gameObject:SetActiveEx(true)
				self.initialize = true
				MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_UpdateMapDebugInfoVisible, false)
			else
				local l_data = DataMgr:GetData("WatchWarData").MainWatchRoomInfo
				if l_data.spectators_num >= DataMgr:GetData("WatchWarData").SpectatorInfoCondition then
					self.panel.Anchor.gameObject:SetActiveEx(true)
					MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_UpdateMapDebugInfoVisible, false)
					self.initialize = true
				end
			end
		end
	else
		self:RefreshDatas()
	end
end

--lua custom scripts end
return WatchWarInfoCtrl