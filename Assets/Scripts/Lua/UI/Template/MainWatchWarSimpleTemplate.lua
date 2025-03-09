--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class MainWatchWarSimpleTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SliderHP MoonClient.MLuaUICom
---@field NoTeam MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Member MoonClient.MLuaUICom
---@field ImgJob MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@class MainWatchWarSimpleTemplate : BaseUITemplate
---@field Parameter MainWatchWarSimpleTemplateParameter

MainWatchWarSimpleTemplate = class("MainWatchWarSimpleTemplate", super)
--lua class define end

--lua functions
function MainWatchWarSimpleTemplate:Init()
	
	super.Init(self)
	self.mgr = MgrMgr:GetMgr("WatchWarMgr")
	self.lastHp = nil
	self.hasInit = nil
	self.customVisible = nil
	self.lastDisplayRoleId = nil
	
end --func end
--next--
function MainWatchWarSimpleTemplate:BindEvents()
	
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_MAIN_WATCH_BRIEF_INFO_UPDATE, self.OnRoomBriefStatusUpdate)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_SWITCH_WATCH_PLAYER, self.UpdateCheckmark)
	
end --func end
--next--
function MainWatchWarSimpleTemplate:OnDestroy()
	
	self.lastHp = nil
	self.hasInit = nil
	self.dataIndex = nil
	self.teamIndex = nil
	self.customVisible = nil
	self.lastDisplayRoleId = nil
	self.mgr = nil
	
end --func end
--next--
function MainWatchWarSimpleTemplate:OnDeActive()
	
	
end --func end
--next--
function MainWatchWarSimpleTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MainWatchWarSimpleTemplate:CustomSetData(data)

	self.hasInit = true

	self.dataIndex = data.dataIndex
	self.teamId = data.teamId

	self.Parameter.Member:AddClick(function()
		self.mgr.WatcherSwitchPlayer(self.mgr.GetWatchUnitIdByTeamAndIndex(self.teamId, self.dataIndex))
	end)

	self:UpdateCheckmark()

	self:OnRoomBriefStatusUpdate()
end

function MainWatchWarSimpleTemplate:SetTemplateVisible(visible)
	
	if self.customVisible == visible then
		return
	end
	self.customVisible = visible
	self.Parameter.Member.gameObject:SetActiveEx(self.customVisible)
	self.Parameter.NoTeam.gameObject:SetActiveEx(not self.customVisible)
end

-- 仅数据更新是才做UI更新
function MainWatchWarSimpleTemplate:UpdateHp(hp)

	if hp and self.lastHp ~= hp then
		self.lastHp = hp
		self.Parameter.SliderHP.Slider.value = hp / 100
	end
end

function MainWatchWarSimpleTemplate:UpdateExpand(expand)
	
end

function MainWatchWarSimpleTemplate:UpdateCheckmark()

	local l_displayRoleId = self.mgr.GetWatchUnitIdByTeamAndIndex(self.teamId, self.dataIndex)
	local l_visible = false
	if l_displayRoleId and tostring(l_displayRoleId) == tostring(MPlayerInfo.WatchFocusPlayerId) then
		l_visible = true
	end
	self.Parameter.Checkmark.gameObject:SetActiveEx(l_visible)
end

function MainWatchWarSimpleTemplate:OnRoomBriefStatusUpdate()
	-- 未初始化不作处理
	if not self.hasInit then
		return
	end
	-- 无数据则显示为空
	local l_displayRoleId = self.mgr.GetWatchUnitIdByTeamAndIndex(self.teamId, self.dataIndex)
	if not l_displayRoleId then
		self:SetTemplateVisible(false)
		return
	end
	-- 无数据则显示为空
	local l_data = self.mgr.GetWatchUnitInfoByRoleId(l_displayRoleId)
	if not l_data then
		self:SetTemplateVisible(false)
		return
	else
		-- 显示角色不一致时，刷新信息
		if l_displayRoleId ~= self.lastDisplayRoleId then
			self.lastDisplayRoleId = l_displayRoleId
			self.Parameter.Name.LabText = self:getDisplayName(l_data)
			self.Parameter.ImgJob:SetSpriteAsync("Common", DataMgr:GetData("TeamData").GetProfessionImageById(l_data.type) or "")
		end
		-- 更新状态信息
		self:UpdateHp(l_data.hp, l_data.sp)

		self:SetTemplateVisible(true)
	end
end

function MainWatchWarSimpleTemplate:getDisplayName(data)

	if data.is_hit_outlook then
		return Lang("Mysterious_Adventurer")
	else
		return data.name
	end
end
--lua custom scripts end
return MainWatchWarSimpleTemplate