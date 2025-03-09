--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/WatchSingleTemplate"
require "UI/Template/WatchPVPTemplate"
require "UI/Template/WatchPVPMultipleTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class WatchTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field WatchTemplate MoonClient.MLuaUICom
---@field TitleName MoonClient.MLuaUICom
---@field TimeText MoonClient.MLuaUICom
---@field NumberText MoonClient.MLuaUICom
---@field FabulousText MoonClient.MLuaUICom

---@class WatchTemplate : BaseUITemplate
---@field Parameter WatchTemplateParameter

WatchTemplate = class("WatchTemplate", super)
--lua class define end

--lua functions
function WatchTemplate:Init()
	
	super.Init(self)
	self.pveTemplate = nil
	self.pvpTemplate = nil
	self.pvpMultipleTemplate = nil
	
end --func end
--next--
function WatchTemplate:OnDestroy()
	
	self.pveTemplate = nil
	self.pvpTemplate = nil
	self.pvpMultipleTemplate = nil
	self:CloseUpdateTimer()
	
end --func end
--next--
function WatchTemplate:OnDeActive()
	
	self:CloseUpdateTimer()
	
end --func end
--next--
function WatchTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function WatchTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function WatchTemplate:CustomSetData(data)
	
	self:CloseUpdateTimer()
	
	local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(data.orginalData.dungeon_id)
	if not l_dungeonRow then
		logError("WatchTemplate:CustomSetData error", ToString(data.orginalData))
		return
	end
	local l_type = MgrMgr:GetMgr("WatchWarMgr").GetSpectatorTypeByDungeonType(l_dungeonRow.DungeonsType)
	
	self:HideUnusedTemplate(l_type)
	-- 根据类型显示不同的template
	if l_type == WatchUnitType.kWatchUnitTypePVE then
		self:ProcessPVE(data, l_type)
	elseif l_type == WatchUnitType.kWatchUnitTypePVPLight then
		self:ProcessPVP(data, l_type)
	elseif l_type == WatchUnitType.WatchUnitTypePVPHeavy then
		self:ProcessPVPMultiple(data, l_type)
	else
		logError("WatchTemplate:CustomSetData error, watchunit type is error", data.orginalData.room_uid, l_type)
	end
	-- 通用信息
	self:ProcessCommon(data)
end

-- PVE
function WatchTemplate:ProcessPVE(data, type)

	if not self.pveTemplate then
		self.pveTemplate = self:NewTemplate("WatchSingleTemplate", {
			TemplatePrefab = data.tplFunc(type),
			TemplateParent = self.Parameter.LuaUIGroup.transform,
			Data = data
		})
		self.pveTemplate:AddLoadCallback(function()
			MLuaCommonHelper.SetRectTransformPos(self.pveTemplate:gameObject(), 0, -20)
		end)
	else
		self.pveTemplate:SetData(data)
	end
end

-- PVP
function WatchTemplate:ProcessPVP(data, type)

	if not self.pvpTemplate then
		self.pvpTemplate = self:NewTemplate("WatchPVPTemplate", {
			TemplatePrefab = data.tplFunc(type),
			TemplateParent = self.Parameter.LuaUIGroup.transform,
			Data = data
		})
		self.pvpTemplate:AddLoadCallback(function()
			MLuaCommonHelper.SetRectTransformPos(self.pvpTemplate:gameObject(), 0, -20)
		end)
	else
		self.pvpTemplate:SetData(data)
	end
end

-- 战场PVP
function WatchTemplate:ProcessPVPMultiple(data, type)

	if not self.pvpMultipleTemplate then
		self.pvpMultipleTemplate = self:NewTemplate("WatchPVPMultipleTemplate", {
			TemplatePrefab = data.tplFunc(type),
			TemplateParent = self.Parameter.LuaUIGroup.transform,
			Data = data
		})
		self.pvpMultipleTemplate:AddLoadCallback(function()
			MLuaCommonHelper.SetRectTransformPos(self.pvpMultipleTemplate:gameObject(), 0, -20)
		end)
	else
		self.pvpMultipleTemplate:SetData(data)
	end
end

function WatchTemplate:HideUnusedTemplate(type)

	if self.pveTemplate then
		self.pveTemplate:SetGameObjectActive(type == WatchUnitType.kWatchUnitTypePVE)
	end
	if self.pvpTemplate then
		self.pvpTemplate:SetGameObjectActive(type == WatchUnitType.kWatchUnitTypePVPLight)
	end
	if self.pvpMultipleTemplate then
		self.pvpMultipleTemplate:SetGameObjectActive(type == WatchUnitType.WatchUnitTypePVPHeavy)
	end
end

function WatchTemplate:ProcessCommon(data)

	local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(data.orginalData.dungeon_id)

	self.Parameter.TitleName.LabText = l_dungeonRow.DungeonsName
	self.Parameter.NumberText.LabText = MgrMgr:GetMgr("WatchWarMgr").GetSpectatorDisplayNum(data.orginalData.watch_times)
	self.Parameter.FabulousText.LabText = tostring(data.orginalData.like_times)

	self:SetupUpdateTimer(data)
end

function WatchTemplate:CloseUpdateTimer()

	if self.updateTimer then
		self:StopUITimer(self.updateTimer)
		self.updateTimer = nil
	end
end

function WatchTemplate:SetTextContext(hour, min, sec)

	if hour <= 0 then
		self.Parameter.TimeText.LabText = StringEx.Format("{0:00}:{1:00}", min, sec)
	else
		self.Parameter.TimeText.LabText = StringEx.Format("{0}:{1:00}:{2:00}", hour, min, sec)
	end
end

function WatchTemplate:GetTimeFormat(passTime)

	local l_hour = math.floor(passTime / 3600)
	local l_min = math.floor((passTime - l_hour * 3600) / 60)
	local l_sec = math.floor(math.fmod(passTime, 60))
	return l_hour, l_min, l_sec
end

function WatchTemplate:SetupUpdateTimer(data)

	local l_timeMgr = Common.TimeMgr
	local l_originalPassTime = l_timeMgr.GetNowTimestamp() - MLuaCommonHelper.Int(data.orginalData.create_time)
	if l_originalPassTime < 0 then
		l_originalPassTime = 0
	end
	local l_startTime = Time.realtimeSinceStartup
	if data.frezze then
		self:SetTextContext(self:GetTimeFormat(data.orginalData.life_time or 0))
		return
	end
	self:SetTextContext(self:GetTimeFormat(Time.realtimeSinceStartup - l_startTime + l_originalPassTime))
	self.updateTimer = self:NewUITimer(function()
		self:SetTextContext(self:GetTimeFormat(Time.realtimeSinceStartup - l_startTime + l_originalPassTime))
	end, 1, -1)
	self.updateTimer:Start()
end

function WatchTemplate:GetPreferredWidth()

	return self.Parameter.TitleName:GetText().preferredWidth
end
--lua custom scripts end
return WatchTemplate