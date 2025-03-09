--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/WatchWarRecordPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
WatchWarRecordHandler = class("WatchWarRecordHandler", super)
--lua class define end

--lua functions
function WatchWarRecordHandler:ctor()
	
	super.ctor(self, HandlerNames.WatchWarRecord, 0)
	
end --func end
--next--
function WatchWarRecordHandler:Init()
	
	self.panel = UI.WatchWarRecordPanel.Bind(self)
	super.Init(self)
	
	self.watchTemplatePool = self:NewTemplatePool({
		TemplatePrefab = self.ctrlRef:GetCommonTemplateGO("WatchTemplate"),
        UITemplateClass = UITemplate.WatchTemplate,
		TemplateParent = self.panel.Content.transform,
	})

	self.mostWatchedTemplate = self:NewTemplate("WatchTemplate", {
		TemplatePrefab = self.ctrlRef:GetCommonTemplateGO("WatchTemplate"),
		TemplateParent = self.panel.MostWatched.transform,
	})
    self.mostWatchedTemplate:AddLoadCallback(function()
        self.mostWatchedTemplate:transform():SetSiblingIndex(1)
        MLuaCommonHelper.SetRectTransformPos(self.mostWatchedTemplate:gameObject(), 333, -63)
    end)

	self.mostLikedTemplate = self:NewTemplate("WatchTemplate", {
		TemplatePrefab = self.ctrlRef:GetCommonTemplateGO("WatchTemplate"),
		TemplateParent = self.panel.MostLiked.transform,
	})
    self.mostLikedTemplate:AddLoadCallback(function()
        self.mostLikedTemplate:transform():SetSiblingIndex(1)
        MLuaCommonHelper.SetRectTransformPos(self.mostLikedTemplate:gameObject(), 333, -63)
    end)

	self.panel.Btn_N_B02:AddClick(function()
		MgrMgr:GetMgr("WatchWarMgr").OpenSettingCtrl()
	end)
end --func end
--next--
function WatchWarRecordHandler:Uninit()
	
	self.watchTemplatePool = nil
	self.mostWatchedTemplate = nil
	self.mostLikedTemplate = nil

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function WatchWarRecordHandler:OnActive()
	
	MgrMgr:GetMgr("WatchWarMgr").GetRoleWatchRecord()
	self:WatchWarRecordRefresh()
end --func end
--next--
function WatchWarRecordHandler:OnDeActive()
	
	
end --func end
--next--
function WatchWarRecordHandler:Update()
	
	
end --func end

--next--
function WatchWarRecordHandler:BindEvents()
	self:BindEvent(MgrMgr:GetMgr("WatchWarMgr").EventDispatcher,MgrMgr:GetMgr("WatchWarMgr").ON_WATCH_RECORD_UPDATE, self.WatchWarRecordRefresh)
end --func end
--next--
--lua functions end

--lua custom scripts
--next--
function WatchWarRecordHandler:WatchWarRecordRefresh()
	
	local l_recordData = DataMgr:GetData("WatchWarData").RecordDatas or {}
	self.panel.TextTotalWatch.LabText = l_recordData.total_watched_times or 0
	self.panel.TextTotalLike.LabText = l_recordData.total_liked_times or 0
	self.panel.TextTotalBeWatched.LabText = l_recordData.total_bewatched_times or 0
	self.panel.TextTotalBeLiked.LabText = l_recordData.total_beliked_times or 0

	local function _getTemplateGOByType(type)
		if type == WatchUnitType.kWatchUnitTypePVE then
			return self.ctrlRef:GetCommonTemplateGO("WatchSingleTemplate")
		elseif type == WatchUnitType.kWatchUnitTypePVPLight then
			return self.ctrlRef:GetCommonTemplateGO("WatchPVPTemplate")
		else
			return self.ctrlRef:GetCommonTemplateGO("WatchPVPMultipleTemplate")
		end
	end

	local function _getProfessionTemplateGO()
		return self.ctrlRef:GetCommonTemplateGO("WatchProTemplate")
	end
	if l_recordData.most_bewatched_record and l_recordData.most_bewatched_record.room_uid and l_recordData.most_bewatched_record.room_uid > 0 then
		self.mostWatchedTemplate:SetData({
            orginalData = l_recordData.most_bewatched_record,
            tplFunc = _getTemplateGOByType,
            proFunc = _getProfessionTemplateGO,
            frezze = true,
        })
        self.mostWatchedTemplate:SetGameObjectActive(true)
		self.panel.TitleMostWatched.gameObject:SetActiveEx(true)
	else
        self.mostWatchedTemplate:SetGameObjectActive(false)
        self.panel.TitleMostWatched.gameObject:SetActiveEx(false)
	end

	if l_recordData.most_beliked_record and l_recordData.most_beliked_record.room_uid and l_recordData.most_beliked_record.room_uid > 0 then
		self.mostLikedTemplate:SetData({
            orginalData = l_recordData.most_beliked_record,
            tplFunc = _getTemplateGOByType,
            proFunc = _getProfessionTemplateGO,
            frezze = true,
        })
        self.mostLikedTemplate:SetGameObjectActive(true)
		self.panel.TitleMostLiked.gameObject:SetActiveEx(true)
	else
        self.mostLikedTemplate:SetGameObjectActive(false)
        self.panel.TitleMostLiked.gameObject:SetActiveEx(false)
	end

    local l_showDatas = {}
	for i, v in ipairs(l_recordData.watched_history or {}) do
		table.insert(l_showDatas, {
			orginalData = v,
			tplFunc = _getTemplateGOByType,
            proFunc = _getProfessionTemplateGO,
            frezze = true,
		})
	end
	self.watchTemplatePool:ShowTemplates({Datas = l_showDatas})
end --func end
--lua custom scripts end
return WatchWarRecordHandler