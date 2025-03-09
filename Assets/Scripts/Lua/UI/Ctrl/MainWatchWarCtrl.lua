--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainWatchWarPanel"
require "UI/Template/MainWatchWarTeamTemplate"
require "UI/Template/MainWatchWarSimpleTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MainWatchWarCtrl = class("MainWatchWarCtrl", super)
--lua class define end

local l_maxTeamNumber = DataMgr:GetData("TeamData").maxTeamNumber
--lua functions
function MainWatchWarCtrl:ctor()

	super.ctor(self, CtrlNames.MainWatchWar, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function MainWatchWarCtrl:Init()

	self.panel = UI.MainWatchWarPanel.Bind(self)
	super.Init(self)
	---@type WatchWarMgr
	self.mgr = MgrMgr:GetMgr("WatchWarMgr")

	self.panel.BtnClose:AddClick(function()
		MgrMgr:GetMgr("DungeonMgr").SendLeaveSceneReq()
	end)

	self.panel.BtnShare:AddClick(function()
		self:Share()
	end)
	self.panel.BtnFabulous:AddClick(function()
		if self.grayColor == self.panel.ImageFabulous.Img.color then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(ErrorCode.ERR_HAS_ALREADY_LIKE_ROOM))
			return
		end
		self.mgr.RequestLikeWatchRoom(self.dataMgr.MainWatchRoomInfo.room_uid)
	end)
	self.panel.BtnFlower:AddClick(function()
		if MEntityMgr:GetRole(MPlayerInfo.WatchFocusPlayerId) ~= nil then
			local content = Common.Utils.Lang("GUILD_MATCH_FLOWER_CONFIRM", MEntityMgr:GetRole(MPlayerInfo.WatchFocusPlayerId).AttrRole.GuildName)
			CommonUI.Dialog.ShowYesNoDlg(true, nil, content, function()
				self.mgr.GiveGuildFlower()
			end, nil, nil, 0)
		end
	end)
	self.panel.BtnSetup:AddClick(function()
		self.mgr.OpenSettingCtrl()
	end)

	self.panel.Left.gameObject:SetActiveEx(false)
	self.panel.Right.gameObject:SetActiveEx(false)

	self.templatePool = {}

	self.initialize = false

	self.frameCtrlCount = 0

	self.lastFocusEntityId = 0

	self.firstCameraFocus = true

	self.grayColor = Color.New(0, 0, 0)
end --func end
--next--
function MainWatchWarCtrl:Uninit()

	self.templatePool = nil
	self.frameCtrlCount = nil
	self.lastFocusEntityId = nil

	self.mgr = nil
	self.initialize = nil
	self.teamsMarks = nil
	self.leftExpand = nil
	self.rightExpand = nil
	self.firstCameraFocus = nil
	self.grayColor = nil

	if MScene.GameCamera then
		MEventMgr:LuaFireEvent(MEventType.MEvent_SetCameraOnlySlowFollow, MScene.GameCamera, false)
	end

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function MainWatchWarCtrl:OnActive()

	self.lastRetryTime = Time.realtimeSinceStartup
	self.lastFocusEntityId = 0

	self.mgr = MgrMgr:GetMgr("WatchWarMgr")
	self.dataMgr = DataMgr:GetData("WatchWarData")
	self:MainWatchWarPanelRefresh()
	self.panel.BtnFlower.UObj:SetActiveEx(MPlayerInfo.PlayerDungeonsInfo.DungeonID == MGlobalConfig:GetInt("G_MatchBattleDungeonId"))
	
end --func end
--next--
function MainWatchWarCtrl:OnDeActive()

	self.mgr = nil
	self.dataMgr = nil
end --func end
--next--
function MainWatchWarCtrl:Update()

	if not self.initialize then
		return
	end
	-- 检测频率控制
	self.frameCtrlCount = self.frameCtrlCount - 1
	if self.frameCtrlCount > 0 then
		return
	end
	-- 当前在黑幕中，不处理
	if self.dataMgr.UnderBlackCurtainFadeIn then
		return
	end

	self.frameCtrlCount = 5

	local l_camera = MScene.GameCamera
	if not l_camera then
		return
	end

	local l_focusMemberId = tostring(MPlayerInfo.WatchFocusPlayerId)
	-- 无对象时，不处理，等服务器通知
	if l_focusMemberId == "0" then
		-- if Time.realtimeSinceStartup - self.lastRetryTime > 1 then
		-- 	MgrMgr:GetMgr("WatchWarMgr").AutoFindWatchMember()
		-- 	self.lastRetryTime = Time.realtimeSinceStartup
		-- end
		return
	end
	local l_needRetry = false
	-- 观战目标已消失
	if not l_camera.Target or l_camera.Target.Deprecated then
		l_needRetry = true
	else
		-- 观战目标不一致
		if tostring(l_camera.Target.UID) ~= l_focusMemberId then
			l_needRetry = true
		end
	end
	if not l_needRetry then
		return
	end
	
	local l_focusEntity = MEntityMgr:GetEntity(MPlayerInfo.WatchFocusPlayerId, true)
	-- 观战目标已创建
	if l_focusEntity and l_focusEntity.IsLoaded then
		-- 非首次的情况下，修改相机跟随方式
		if self.firstCameraFocus then
			self.firstCameraFocus = false
			MEventMgr:LuaFireEvent(MEventType.MEvent_SetCameraOnlySlowFollow, MScene.GameCamera, true)
		end
		-- 相机跟随
		MEventMgr:LuaFireEvent(MEventType.MEvent_CamTarget, MScene.GameCamera, l_focusEntity)
		-- 阵营切换
		MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_FIGHT_GROUP_Change, true)
		-- 更新战场StoneFx
		MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_UpdateStoneFx, true)
		-- 更新小地图图标
		MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_ForceUpdateMiniMapIcon, true)

		MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_CameraShowTypeChange)

		-- 阵营切换
		MgrMgr:GetMgr("WatchWarMgr").UpdateBattleSide()
		-- 切换角色事件
		MgrMgr:GetMgr("WatchWarMgr").OnFocusRole()
		return
	end
end --func end

--next--
function MainWatchWarCtrl:BindEvents()
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_MAIN_WATCH_ALL_BRIEF_INFO, self.MainWatchWarPanelRefresh)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_LIKE_STATUS, self.OnLikeStatusUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts

function MainWatchWarCtrl:MainWatchWarPanelRefresh()
	local l_watchRoomInfo = self.dataMgr.MainWatchRoomInfo
	if not l_watchRoomInfo then
		return
	end
	-- 有数据才会显示
	if not self.initialize then
		if l_watchRoomInfo.dungeon_id and l_watchRoomInfo.role_infos then
			self.initialize = true

			self:InitRoomBaseInfo()
			self:OnRoomBriefStatusUpdate()
		else
			log("wait for initialize")
		end
	else
		self:OnRoomBriefStatusUpdate()
	end
end

-- 初始化显示样式
function MainWatchWarCtrl:InitRoomBaseInfo()

	self.leftExpand = nil
	self.rightExpand = nil

	local l_watchRoomInfo = self.dataMgr.MainWatchRoomInfo
	local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_watchRoomInfo.dungeon_id)

	self.spectatorDungeonsType = self.mgr.GetSpectatorTypeByDungeonType(l_dungeonRow.DungeonsType)
	if self.spectatorDungeonsType == WatchUnitType.kWatchUnitTypePVE then
		self:ShowPVEPanel()
	elseif self.spectatorDungeonsType == WatchUnitType.kWatchUnitTypePVPLight then
		self:ShowPVPPanel()
	elseif self.spectatorDungeonsType == WatchUnitType.WatchUnitTypePVPHeavy then
		self:ShowPVPHeavyPanel()
	else
		logError("MainWatchWarCtrl:InitRoomBaseInfo() fail,不支持的观战副本类型")
		return
	end
end

-- PVE，仅左边且不可展开
function MainWatchWarCtrl:ShowPVEPanel()
	self.panel.Left.gameObject:SetActiveEx(true)
	self.panel.Right.gameObject:SetActiveEx(false)

	self.panel.ButtonFoldLeft.gameObject:SetActiveEx(false)
	self.panel.ButtonExpandLeft.gameObject:SetActiveEx(false)

	self.panel.BGExpandLeft.gameObject:SetActiveEx(false)

	MLuaCommonHelper.SetRectTransformWidth(self.panel.BGFoldLeft.gameObject, 188)
	self.leftExpand = false
end

-- PVP 左右，且都可展开
function MainWatchWarCtrl:ShowPVPPanel()
	self.panel.Left.gameObject:SetActiveEx(true)
	self.panel.Right.gameObject:SetActiveEx(true)

	self:TryExpand(true, false)
	self:TryExpand(false, false)

	self.panel.ButtonFoldLeft:AddClick(function()
		self:TryExpand(true, true)
	end)

	self.panel.ButtonExpandLeft:AddClick(function()
		self:TryExpand(true, false)
	end)

	self.panel.ButtonFoldRight:AddClick(function()
		self:TryExpand(false, true)
	end)

	self.panel.ButtonExpandRight:AddClick(function()
		self:TryExpand(false, false)
	end)

	MLuaCommonHelper.SetRectTransformSize(self.panel.BGFoldLeft.gameObject, 188, 318)
	MLuaCommonHelper.SetRectTransformSize(self.panel.BGFoldRight.gameObject, 188, 318)
	MLuaCommonHelper.SetRectTransformPosX(self.panel.LeftContent_.gameObject, 126)
	MLuaCommonHelper.SetRectTransformPosX(self.panel.RightContent_.gameObject, -126)
end

-- 战场，显示4个队伍，不可展开
function MainWatchWarCtrl:ShowPVPHeavyPanel()

	self.panel.Left.gameObject:SetActiveEx(true)
	self.panel.Right.gameObject:SetActiveEx(true)

	self.panel.ButtonFoldLeft.gameObject:SetActiveEx(false)
	self.panel.ButtonExpandLeft.gameObject:SetActiveEx(false)

	self.panel.ButtonFoldRight.gameObject:SetActiveEx(false)
	self.panel.ButtonExpandRight.gameObject:SetActiveEx(false)

	self.panel.BGExpandLeft.gameObject:SetActiveEx(false)
	self.panel.BGExpandRight.gameObject:SetActiveEx(false)

	MLuaCommonHelper.SetRectTransformSize(self.panel.BGFoldLeft.gameObject, 248, 240)
	MLuaCommonHelper.SetRectTransformSize(self.panel.BGFoldRight.gameObject, 248, 240)

	MLuaCommonHelper.SetRectTransformPosX(self.panel.LeftContent_.gameObject, 126)
	MLuaCommonHelper.SetRectTransformPosX(self.panel.RightContent_.gameObject, -131)
end

function MainWatchWarCtrl:TryExpand(left, expand)

	if left then
		-- if expand == self.leftExpand then return end
		self.leftExpand = expand

		self.panel.BGExpandLeft.gameObject:SetActiveEx(self.leftExpand)
		self.panel.BGFoldLeft.gameObject:SetActiveEx(not self.leftExpand)
		self.panel.ButtonExpandLeft.gameObject:SetActiveEx(self.leftExpand)
		self.panel.ButtonFoldLeft.gameObject:SetActiveEx(not self.leftExpand)
		-- 特判了。。
		if self.templatePool[1] then
			self:UpdatePoolExpand(self.templatePool[1], self.leftExpand)
		end
	else
		-- if expand == self.rightExpand then return end
		self.rightExpand = expand

		self.panel.BGExpandRight.gameObject:SetActiveEx(self.rightExpand)
		self.panel.BGFoldRight.gameObject:SetActiveEx(not self.rightExpand)
		self.panel.ButtonExpandRight.gameObject:SetActiveEx(self.rightExpand)
		self.panel.ButtonFoldRight.gameObject:SetActiveEx(not self.rightExpand)
		-- 特判了。。
		if self.templatePool[2] then
			self:UpdatePoolExpand(self.templatePool[2], self.rightExpand)
		end
	end
end

-- 根据teamId输出队伍玩家id列表
function MainWatchWarCtrl:GetTeamMemberID(teamId)

	local l_ret = {}

	local l_watchRoomInfo = self.dataMgr.MainWatchRoomInfo.role_infos
	local l_key
	while next(l_watchRoomInfo, l_key) do
		-- logError(next(l_watchRoomInfo, l_key))
		l_key = next(l_watchRoomInfo, l_key)
		table.insert(l_ret, l_key)
	end

	return l_ret
end

-- 根据teamId创建template显示数据(具体数据template自己去拿)
function MainWatchWarCtrl:CreateTemplateData(teamId, index)

	local l_expand = ((index % 2) ~= 0) and self.leftExpand, self.rightExpand

	local l_ret = {}
	for i = 1, l_maxTeamNumber do
		l_ret[i] = {
			dataIndex = i,
			teamId = teamId,
			expand = l_expand
		}
	end

	return l_ret
end

-- 创建templatePool
function MainWatchWarCtrl:GetTemplatePoolByIndex(index, useSimple)

	if not self.templatePool[index] then

		local l_key = StringEx.Format("{0}{1}GO", ((index % 2 == 0) and "Right" or "Left"), useSimple and "Simple" or "Team")
		local l_templatePrefab = self.panel[l_key].gameObject

		local l_parentName = (index % 2 == 0) and "RightContent" or "LeftContent"
		if index > 2 then
			l_parentName = l_parentName .. "_"
		end
		self.templatePool[index] = self:NewTemplatePool({
			TemplatePrefab = l_templatePrefab,
			UITemplateClass = useSimple and UITemplate.MainWatchWarSimpleTemplate or UITemplate.MainWatchWarTeamTemplate,
			TemplateParent = self.panel[l_parentName].transform,
		})
	end

	return self.templatePool[index]
end

function MainWatchWarCtrl:CustomShowTemplates(count)

	local l_index = 1
	while l_index <= count do
		local l_teamId = self.dataMgr.MainWatchRoomInfo.teamInfoList[l_index]
		local l_datas = self:CreateTemplateData(l_teamId, l_index) or {}
		  --logError("MainWatchWarCtrl:CustomShowTemplates", l_index, count, l_teamId, ToString(l_datas))
		self:GetTemplatePoolByIndex(l_index, false):ShowTemplates({Datas = l_datas, ShowMaxCount = l_maxTeamNumber, ShowMinCount = l_maxTeamNumber})

		l_index = l_index + 1
	end
end

function MainWatchWarCtrl:GetBattleTeamIds()

	local l_teamIds = {}
	if not self.dataMgr.BattleTeamInfo or not self.dataMgr.MainWatchRoomInfo then
		for k, v in pairs(self.dataMgr.BattleTeamInfo.teamLinkInfos) do
			table.insert(l_teamIds, k)
		end
		return l_teamIds
	end

	for i, v in ipairs(self.dataMgr.BattleTeamInfo) do
		local l_roleInfo = self.dataMgr.MainWatchRoomInfo.role_infos[tostring(v)]
		if l_roleInfo then
			l_teamIds[i] = l_roleInfo.team_id
		end
	end

	return l_teamIds
end

function MainWatchWarCtrl:CustomShowBattleTemplates()

	local l_teamLinkInfos = self.dataMgr.MainWatchRoomInfo.teamLinkInfos or {}
	local l_teamIds = self:GetBattleTeamIds()
	for i = 1, 4 do
		local l_teamId = l_teamIds[i]
		local l_datas = self:CreateTemplateData(l_teamId, i) or {}
		-- logError("MainWatchWarCtrl:CustomShowTemplates", i, l_teamId, ToString(l_datas))
		local l_index = i
		if l_index == 2 then
			l_index = 3
		elseif l_index == 3 then
			l_index = 2
		end
		self:GetTemplatePoolByIndex(l_index, true):ShowTemplates({Datas = l_datas, ShowMaxCount = l_maxTeamNumber, ShowMinCount = l_maxTeamNumber})
	end

end

function MainWatchWarCtrl:UpdatePVEPanel()

	self:CustomShowTemplates(1)
end

function MainWatchWarCtrl:UpdatePVPPanel()

	self:CustomShowTemplates(2)
end

function MainWatchWarCtrl:UpdatePVPHeavyPanel()

	self:CustomShowBattleTemplates()
end

function MainWatchWarCtrl:UpdatePoolExpand(pool, expand)
	for i, v in ipairs(pool:GetItems()) do
		v:UpdateExpand(expand)
	end
end

function MainWatchWarCtrl:OnRoomBriefStatusUpdate()
	if not self.initialize then
		log("MainWatchWarCtrl:OnRoomBriefStatusUpdate fail, not initialize yet")
		return
	end

	if self.spectatorDungeonsType == WatchUnitType.kWatchUnitTypePVE then
		self:UpdatePVEPanel()
	elseif self.spectatorDungeonsType == WatchUnitType.kWatchUnitTypePVPLight then
		self:UpdatePVPPanel()
	elseif self.spectatorDungeonsType == WatchUnitType.WatchUnitTypePVPHeavy then
		self:UpdatePVPHeavyPanel()
	else
		logError("MainWatchWarCtrl:InitRoomBaseInfo() fail,不支持的观战副本类型")
		return
	end
end

function MainWatchWarCtrl:Share()

	if not self.dataMgr.MainWatchRoomInfo or not self.dataMgr.MainWatchRoomInfo.dungeon_id then 
		return 
	end

	local l_linkMgr = MgrMgr:GetMgr("LinkInputMgr")
	local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
	local l_roleInfo = self.dataMgr.MainWatchRoomInfo.role_infos[tostring(MPlayerInfo.WatchFocusPlayerId)]
	local l_playerName = l_roleInfo and l_roleInfo.name or ""
	local l_dungeonName = TableUtil.GetDungeonsTable().GetRowByDungeonsID(self.dataMgr.MainWatchRoomInfo.dungeon_id).DungeonsName
	local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetWatchPack(Lang("SHARE_FORMAT", l_playerName, l_dungeonName), self.dataMgr.SequenceUid)
	self.mgr.ShareWatch(l_msg, l_msgParam, Vector2.New(447, -153.7))
end

function MainWatchWarCtrl:OnLikeStatusUpdate()

	self.panel.ImageFabulous.Img.color = self.grayColor
end

--lua custom scripts end
return MainWatchWarCtrl