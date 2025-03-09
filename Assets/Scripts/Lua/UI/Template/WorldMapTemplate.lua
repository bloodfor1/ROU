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
---@class WorldMapTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Raw_WorldEvent1 MoonClient.MLuaUICom
---@field Raw_WorldEvent MoonClient.MLuaUICom
---@field Panel_EvtInfo MoonClient.MLuaUICom
---@field Img_Time1 MoonClient.MLuaUICom
---@field Img_Time MoonClient.MLuaUICom
---@field Img_EvtInfo2 MoonClient.MLuaUICom
---@field Img_EvtInfo1 MoonClient.MLuaUICom
---@field Img_EvtInfo MoonClient.MLuaUICom
---@field Btn_WorldInfo1 MoonClient.MLuaUICom
---@field Btn_WorldInfo MoonClient.MLuaUICom

---@class WorldMapTemplate : BaseUITemplate
---@field Parameter WorldMapTemplateParameter

WorldMapTemplate = class("WorldMapTemplate", super)
--lua class define end

--lua functions
function WorldMapTemplate:Init()
	
	super.Init(self)
	self.worldPveMgr = MgrMgr:GetMgr("WorldPveMgr")
end --func end
--next--
function WorldMapTemplate:BindEvents()
	
	
end --func end
--next--
function WorldMapTemplate:OnDestroy()
	
	
end --func end
--next--
function WorldMapTemplate:OnDeActive()
	
	
end --func end
--next--
function WorldMapTemplate:OnSetData(data)
	if data==nil then
		return
	end
	self.Parameter.Img_EvtInfo:SetActiveEx(false)
	self.Parameter.Img_EvtInfo1:SetActiveEx(false)
	--已显示时空事件数量
	local l_worldNewEventNum = self:showWorldNewsEvent(data.sceneID,data.eventWarningTime1,data.eventWarningTime2)
	--最多显示2个事件图标
	if l_worldNewEventNum>=2 then
		self:showOmittedIcon(l_worldNewEventNum)
		self:SetGameObjectActive(true)
		return
	end

	--总的已显示事件数量
	local l_eventNum = l_worldNewEventNum
	local l_events = MgrMgr:GetMgr("WorldMapInfoMgr").GetSceneInfluence(data.sceneID)
	l_eventNum = l_eventNum + #l_events
	if l_worldNewEventNum<2 then
		self:updateEventShow(l_events[1],self.Parameter.Img_EvtInfo)
		if l_worldNewEventNum<1 then
			self:updateEventShow(l_events[2],self.Parameter.Img_EvtInfo1)
		end
	end
	self:showOmittedIcon(l_eventNum)
	self:SetGameObjectActive(l_eventNum>0)
end --func end
--next--
--lua functions end

--lua custom scripts
function WorldMapTemplate:showWorldNewsEvent(sceneID,eventWarningTime1,eventWarningTime2)
	local l_worldEvents = self.worldPveMgr.GetWorldPveInScene(sceneID)
	local l_hasShowWorldEventNum = 0
	for i=1,#l_worldEvents do
		local l_worldEvent = l_worldEvents[i]
		local l_wordEventId = l_worldEvent.worldeventid
		local l_canShow = self.worldPveMgr.IsShowSmallWorldEventBg(l_wordEventId)
				and self.worldPveMgr.CheckEventMarked(l_wordEventId)
		if l_canShow then
			l_hasShowWorldEventNum=l_hasShowWorldEventNum+1
			if l_hasShowWorldEventNum==1 then
				self:updateWorldNewEventShow(l_worldEvent,self.Parameter.Btn_WorldInfo,
						self.Parameter.Img_Time,self.Parameter.Raw_WorldEvent,eventWarningTime1,eventWarningTime2)
			elseif l_hasShowWorldEventNum==2 then
				self:updateWorldNewEventShow(l_worldEvent,self.Parameter.Btn_WorldInfo1,
						self.Parameter.Img_Time1,self.Parameter.Raw_WorldEvent1,eventWarningTime1,eventWarningTime2)
			else
				break
			end
		end
	end
	self.Parameter.Btn_WorldInfo:SetActiveEx(l_hasShowWorldEventNum>0)
	self.Parameter.Btn_WorldInfo1:SetActiveEx(l_hasShowWorldEventNum>1)
	return l_hasShowWorldEventNum
end

function WorldMapTemplate:showOmittedIcon(eventNum)
	if eventNum>2 then
		self.Parameter.Img_EvtInfo2:SetActiveEx(true)
		local l_icons = MGlobalConfig:GetSequenceOrVectorString("OpenWorldDotIcon")
		self.Parameter.Img_EvtInfo2:SetSprite(l_icons[0], l_icons[1])
	else
		self.Parameter.Img_EvtInfo2:SetActiveEx(false)
	end
end
function WorldMapTemplate:updateWorldNewEventShow(worldEventInfo,worldInfoBtnCom,timeImgCom,
												  worldEventFxRaw,eventWarningTime1,eventWarningTime2)
	worldInfoBtnCom:SetActiveEx(true)
	local l_wordEventId = worldEventInfo.worldeventid
	local l_row = TableUtil.GetWorldEventTable().GetRowByID(l_wordEventId)
	if not MLuaCommonHelper.IsNull(l_row) then
		worldInfoBtnCom:SetSpriteAsync(l_row.WorldAtlas, l_row.WorldIcon)
	end
	local l_leftTime =MLuaCommonHelper.Int(worldEventInfo.end_time - MServerTimeMgr.singleton.UtcSeconds)
	local l_timeImgRes
	if l_leftTime > eventWarningTime1 * 60 then
		timeImgCom:SetActiveEx(false)
	else
		timeImgCom:SetActiveEx(true)
		if l_leftTime <= eventWarningTime1 * 60 and l_leftTime > eventWarningTime2 * 60 then
			l_timeImgRes = "UI_map_Interactive_Shalou1.png"
		else
			l_timeImgRes = "UI_map_Interactive_Shalou2.png"
		end
		timeImgCom:SetSpriteAsync("Map", l_timeImgRes)
	end

	if self.worldPveMgr.CheckMapFx(l_wordEventId) ~= nil then
		self.worldPveMgr.RemoveMapFx(l_wordEventId)
		local l_fxData = {}
		l_fxData.rawImage = worldEventFxRaw.RawImg
		l_fxData.loadedCallback = function()
			if not self.isActive then
				return
			end
			if worldEventFxRaw ~= nil then
				worldEventFxRaw:SetActiveEx(true)
			end
		end
		l_fxData.destroyHandler = function ()
			if not self.isActive then
				return
			end
			if worldEventFxRaw ~= nil then
				worldEventFxRaw:SetActiveEx(false)
			end
		end
		self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_LeiDa_01", l_fxData)
	else
		worldEventFxRaw:SetActiveEx(false)
	end

	worldInfoBtnCom:SetActiveEx(true)
	MLuaUIListener.Get(worldInfoBtnCom.UObj)
	worldInfoBtnCom.Listener.onClick =function(go,eventData)
		l_leftTime =MLuaCommonHelper.Int(tonumber(worldEventInfo.end_time) - tonumber(MServerTimeMgr.singleton.UtcSeconds))
		MgrMgr:GetMgr("TipsMgr").ShowTimedQuestionTip(l_leftTime,Lang("WORLD_EVENT_TASKINFO_TIP"),eventData,Vector2.New(0,1), l_wordEventId)
	end
end
function WorldMapTemplate:updateEventShow(eventID,imgCom)
	if eventID~=nil then
		local l_influenceRow = TableUtil.GetOpenWorldInfluenceTable().GetRowByID(eventID)
		if not MLuaCommonHelper.IsNull(l_influenceRow) then
			imgCom:SetActiveEx(true)
			imgCom:SetSprite(l_influenceRow.Atlas, l_influenceRow.Icon)
			return
		end
	end
	imgCom:SetActiveEx(false)
end
--lua custom scripts end
return WorldMapTemplate