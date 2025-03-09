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
---@class WatchPVPMultipleTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TeamName04 MoonClient.MLuaUICom
---@field TeamName03 MoonClient.MLuaUICom
---@field TeamName02 MoonClient.MLuaUICom
---@field TeamName01 MoonClient.MLuaUICom
---@field Team04 MoonClient.MLuaUICom
---@field Team03 MoonClient.MLuaUICom
---@field Team02 MoonClient.MLuaUICom
---@field Team01 MoonClient.MLuaUICom
---@field Btn_N_S01 MoonClient.MLuaUICom

---@class WatchPVPMultipleTemplate : BaseUITemplate
---@field Parameter WatchPVPMultipleTemplateParameter

WatchPVPMultipleTemplate = class("WatchPVPMultipleTemplate", super)
--lua class define end

--lua functions
function WatchPVPMultipleTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function WatchPVPMultipleTemplate:OnDestroy()
	
	
end --func end
--next--
function WatchPVPMultipleTemplate:OnDeActive()
	
	
end --func end
--next--
function WatchPVPMultipleTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function WatchPVPMultipleTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function WatchPVPMultipleTemplate:CustomSetData(data)

	self:EnsureCreateProTemplates(data)

	local l_mark = {}
	for i = 1, 4 do
		local l_data = data.orginalData.team[i]
		l_mark[i] = l_data ~= nil
		local l_hide = self:IsCaptainHideOutlook(l_data)
		self.Parameter["TeamName0" .. i].LabText = self:GetTeamTitle(l_data, l_hide)
		self.Parameter["TeamName0" .. i]:GetRichText().useEllipsis = true
		self:UpdateOneTeamProfession("membersProfeessionTemplatePool" .. i, l_data)
	end

	self.Parameter.Btn_N_S01:AddClick(function()
		CommonUI.Dialog.ShowYesNoDlg(true, "", Lang("ENSURE_WATCHWAR", Common.CommonUIFunc.GetDungonNameByDungonID(data.orginalData.dungeon_id)), function()
			MgrMgr:GetMgr("WatchWarMgr").RequestWatchRoom(data.orginalData.sequence_uid, data.orginalData)
		end)
	end)
	self.Parameter.Btn_N_S01.gameObject:SetActiveEx(not data.frezze)
end

function WatchPVPMultipleTemplate:UpdateOneTeamProfession(key, info)

	local l_membersData = {}
	if info then
		for i, v in ipairs(info.members) do
			table.insert(l_membersData, v.type)
		end
	end
	
	for i = #l_membersData + 1, 5 do
		table.insert(l_membersData, 0)
	end
	self[key]:ShowTemplates({Datas = l_membersData})
end

function WatchPVPMultipleTemplate:CreateOneProTemplatePool(key, parent, func)

	self[key] = self:NewTemplatePool({
		TemplatePrefab = func(),
		UITemplateClass = UITemplate.WatchProTemplate,
		TemplateParent = parent,
	})
end

function WatchPVPMultipleTemplate:EnsureCreateProTemplates(data)

	for i = 1, 4 do
		local l_key = "membersProfeessionTemplatePool" .. i
		if not self[l_key] then
			self:CreateOneProTemplatePool(l_key, self.Parameter["Team0" .. i].transform, data.proFunc)
		end
	end
end

-- 没有队伍时，返回"某某某的队伍"
function WatchPVPMultipleTemplate:GetTeamTitle(teamInfo, hide)
	if teamInfo.team_name and string.len(teamInfo.team_name) > 0 then
		return teamInfo.team_name
	else
		if hide then
			return Lang("TEAM_DEFAULT_NAME", Lang("Mysterious_Adventurer"))
		end
		return Lang("TEAM_DEFAULT_NAME", teamInfo.captain.name)
	end
end

function WatchPVPMultipleTemplate:IsCaptainHideOutlook(teaminfo)
	local captainUid = tostring(teaminfo.captain.role_uid)
	for i, v in ipairs(teaminfo.members) do
		if tostring(v.uid) == captainUid then
			return v.is_hit_outlook
		end
	end
	return false
end
--lua custom scripts end
return WatchPVPMultipleTemplate