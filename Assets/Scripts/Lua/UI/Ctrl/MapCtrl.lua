--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MapPanel"
require "UI/Template/MapInfoTitleTemplate"
require "UI/Template/NpcInfoTemplate"
require "UI/Template/EmptyTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MapCtrl = class("MapCtrl", super)
--lua class define end

--lua functions
function MapCtrl:ctor()
	super.ctor(self, CtrlNames.Map, UILayer.Normal, UITweenType.Left, ActiveType.Normal)--Standalone)
end --func end
--next--
function MapCtrl:Init()
	self.panel = UI.MapPanel.Bind(self)
	super.Init(self)
	self:initBaseInfo()
	self:initToggles()
	self:initClickEvent()
	self.panel.NoData:SetActiveEx(false)
	self.panel.NoDataNpcInfo:SetActiveEx(false)
	self.panel.NoDataMonsterInfo:SetActiveEx(false)
end --func end
--next--
function MapCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
	self.npcInfoPool=nil
end --func end
--next--
function MapCtrl:OnActive()
	self:initTowerInfos()
	self:initMapInfo()
	MapObjMgr:BindCSharpEvent()
	MapDataModel.IsMapActive=true
	self:showMapInfo(false)
	self:updateShowMap(true)
	self:showWeatherTemperatureTipsPanel(false)
	self:applyWeather()
	self:applyTemperatureSlider()
	if self.uiPanelData~=nil then
		self:showBigMap(self.uiPanelData.isShowBigMap)
	end

	if self.needCloseFlag then
		self.needCloseFlag = false
		self:Close()
	end
end --func end
--next--
function MapCtrl:OnDeActive()
	MapObjMgr:UnBindCSharpEvent()
	MapDataModel.IsMapActive=false
	MapDataModel.IsBigMapActive=false
	self:releaseInfo()
	self:releaseWeatherTips()
	self.weatherTipTables={}
	self:clearWeatherUnits()
	self.eventInfoTables={}
	self:releaseMapMesh()
	self.funcNpcDatas={}
	self.usualNpcDatas={}
end --func end
--next--
function MapCtrl:Update()
	if not MScene.SceneEntered or not self:IsInited() then
		return
	end
	local l_entity = self:getEntity()
	if not l_entity or not l_entity.Model.Trans then
		return
	end

	MoonClient.MapPerformanceOpt.MoveMiniMap(self.minMapUvHalf,self.panel.Raw_MnMapBg.RawImg,
			self.panel.Panel_MnPlayer.Transform)

	self:moveBigMap(l_entity)
	self:updateWeatherTemperatureTipsState()
	--更新小地图特效位置
	for k, v in pairs(self.effectObjTable) do
        self:adjustMapEffectPos(v)
    end

	if MGameContext.IsOpenGM then
		--更新小地图顶端玩家位置信息
		MoonClient.MapPerformanceOpt.UpdatePlayerPos( self.panel.Txt_PlayerPosition,
				self.panel.But_CollectToPlayerOffset, self.panel.Txt_CollectToPlayerOffset, self.selectTargerUID)
	end
end --func end

--next--
function MapCtrl:BindEvents()
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.AddMapEffect, function(_,...)
		self:addEffect(...)
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.RmMapEffect, function(_,...)
		self:removeEffect(...)
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.UpdateMapBg, function(_,changeBigMapState)
		if changeBigMapState==nil then
			changeBigMapState=false
		end
		self:updateShowMap(changeBigMapState)
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.OnStopNavigation, function(...)
		if self.npcInfoPool~=nil then
			self.npcInfoPool:CancelSelectTemplate()
		end
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.OnWeatherChange, function(...)
		self:applyWeather()
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.UpdateHour, function(...)
		if not self:IsInited() then
			return
		end
		if self.panel.Panel_Weather.isActiveAndEnabled then
			self:freshWeatherUnit()
		end
		if self.panel.Panel_WeatherTemperatureInfoTips.UObj.activeSelf then
			self:updateWeatherTemperatureInfoTipsPanel()
		end
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.OnTaskNpcStateChanged, function(_,longId)
		self:onTaskNpcChanged(longId)
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.UpdateNavIconPos, function(_,navIconType,pos)
		self:updateNavIcon(navIconType,pos)
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.ShowBigMap, function(_,isShow)
		self:showBigMap(isShow)
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.UpdateNpcInfoFoldState, function(_,titleId,fold)
		local l_npcDatas=self:getNpcInfoData(true)
		local l_startFold =false
		for i = 1,#l_npcDatas do
			local l_npcData=l_npcDatas[i]
			if l_npcData.isTitle and l_npcData.titleId==titleId then
				if l_npcData.isFold==fold then
					return
				else
					l_startFold=true
					l_npcData.isFold=fold
				end
			elseif l_startFold then
				if l_npcData.isTitle then
					l_startFold=false
				else
					l_npcData.isFold=fold
				end
			end
		end
		if self.npcInfoPool~=nil then
			local l_data,l_hasNpc = self:getNpcInfoData(true)
			self.panel.NoDataNpcInfo.gameObject:SetActiveEx(not l_hasNpc)
			self.npcInfoPool:ShowTemplates({
				Datas = l_data,
				StartScrollIndex=self.npcInfoPool:GetCellStartIndex(),
				IsNeedShowCellWithStartIndex=false,
				IsToStartPosition=false,
			})
		end
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.UpdateNpcInfoSelectState, function(_,isSelect,showIndex)
		if self.npcInfoPool==nil then
			return
		end
		if isSelect then
			self.npcInfoPool:SelectTemplate(showIndex)
		else
			self.npcInfoPool:CancelSelectTemplate()
		end
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.OnDungeonMonsterNumUpdate,function(_,count,changeValue)
		self:onDungeonMonsterNumChange(count,changeValue)
	end)
	local l_dungeonMgr=MgrMgr:GetMgr("DungeonMgr")
	self:BindEvent(l_dungeonMgr.EventDispatcher,l_dungeonMgr.EXIT_DUNGEON,function()
		self.panel.Img_TowerInfo:SetActiveEx(false)
	end)
	self:BindEvent(l_dungeonMgr.EventDispatcher,l_dungeonMgr.ENTER_DUNGEON,function()
		self.panel.Img_TowerInfo:SetActiveEx(true)
	end)
	local l_teamMgr = MgrMgr:GetMgr("TeamMgr")
    self:BindEvent(l_teamMgr.EventDispatcher, l_teamMgr.ON_GET_INVITATION_ID_LIST, function(_, roleIds)
        --只获取最近组队信息
        self:onGetInvationIds(roleIds)
    end)
	if MGameContext.IsOpenGM then
		self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.OnSelectTarget, function(_,uid)
			if uid~=nil then
				self.selectTargerUID=uid
			end
		end)
		self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.OnUpdateDebugVisible, function(_,show)
            if not self.isActive then
				return
            end
            self.panel.But_PlayerPositionBG:SetActiveEx(show)
		end)
	end

    local l_dungeonMgr=MgrMgr:GetMgr("DungeonMgr")
    self:BindEvent(l_dungeonMgr.EventDispatcher,l_dungeonMgr.Refresh_Dungeon_Info,function()
        -- 副本词缀
        self.panel.AffixBtn:SetActiveEx(#MgrMgr:GetMgr("DungeonMgr").DungeonAffixIds > 0)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--region-----------------------init start----------------------
function MapCtrl:initBaseInfo()
	local l_row= TableUtil.GetGlobalTable().GetRowByName("FliesWingsID")
	if l_row==nil then
		self.fliesWingsId=2031003
	else
		self.fliesWingsId=tonumber(l_row.Value)
	end
	self.mgr=MgrMgr:GetMgr("MapInfoMgr")
	self.taskMgr = MgrMgr:GetMgr("TaskMgr")
	self.minMapUvHalf=0
	self.mnMapUv=0
	self.bigMapUvHalf=0
	self.bigMapUv=0
	self.bigMapScale=0 --ui
	self.bigMapRealScale=0 --ui
	self.mnMapObjRt = nil
	self.bigMapObjRt = nil
	self.bigMapRate=0--ui
	self.bigMapOffset=Vector2.zero --ui
	self.mapInfoData = nil
	self.showDungeonsInfo = false
	self.showAllNpc = false
	self.needCloseFlag = false --需要关闭小地图标记
	self.lastPlayPos = Vector3.one * -1
	self._needNotifyMerchantState = true
	self.lastLeftMonsterCount=0
	self.selectTargerUID = 0
	self.currentScale = 2
	self.hasNpc = false
	self.showWeatherUnitCount=5
	self.isInitWeatherTemperatureInfoTipsPanel=false
	self.lastOpenWeatherTemperaTipsPanelFrame = -1
	self.mapNameWeatherBgListener=nil

	self.Hot_Color=Color.New(0xd0 / 255.0, 0x51 / 255.0, 0x75 / 255.0, 1)
	self.Cold_Color=Color.New(0xaf / 255.0, 0xb6 / 255.0, 0xd0 / 255.0,1)
	self.Comfortable_Color=Color.New(0xe5 / 255.0, 0xa2 / 255.0, 0x41 / 255.0, 1)

	self.effectObjTable={}
	self.npcDatas={}
	self.funcNpcDatas={}
	self.weatherTipTables={}
	self.eventInfoTables={}
	self.usualNpcDatas={}
	self.eventObjTables={}
	self.monsterParentTables={}
	self.mapTitleTemplateTables={}
	self.mapTitleTemplateEventTables={}
	self.btnMonsterInfoTemplateTables={}
	self:clearWeatherUnits()
	self:setBigMapEnlargeScale(1,true)
    self.nearPeoplePool = self:NewTemplatePool({
        ScrollRect = self.panel.Scroll_NearPeople.LoopScroll,
        TemplateClassName = "NearPeopleTemplate",
        TemplatePrefab = self.panel.Template_NearPeople.gameObject
    })
	self.panel.NpcInfoTemplate.gameObject:SetActiveEx(false)
end

function MapCtrl:initMapInfo()
	if not self:IsInited() or self.npcInfoPool~=nil then
		return
	end
	self.npcInfoPool=self:NewTemplatePool({
		ScrollRect=self.panel.LoopScroll_NPC.LoopScroll,
		PreloadPaths = {},
		GetTemplateAndPrefabMethod = function(data)
			return self:getNpcTemplateAndPrefab(data)
		end,
	})
end

function MapCtrl:initToggles()
	self.panel.Tog_01:OnToggleExChanged(function(on)
		self.panel.Panel_NpcInfo.UObj:SetActiveEx(on)
		if on then
			self:showNpcInfoPanel()
		end
	end,true)
	self.panel.Tog_02:OnToggleExChanged(function(on)
		self.panel.Scroll_MonsterScrollView.UObj:SetActiveEx(on)
		if on then
			self:showMonsterInfoPanel()
		end
	end,true)
	self.panel.Tog_03:OnToggleExChanged(function(on)
		self.panel.Scroll_MapEvent.UObj:SetActiveEx(on)
		if on then
			self:showEvtInfo()
		end
	end,true)

	self.panel.Toggle_ShowALlToggle:OnToggleChanged(function(on)
		self.showAllNpc=on
		if not self:isMapInfoPanelShow() then
			return
		end
		self:showOpenMapInfo()
	end,true)
	self.panel.Toggle_ShowALlToggle.Tog.isOn=self.showAllNpc
	self.panel.Toggle_ShowALlToggle:SetActiveEx(false)
end

function MapCtrl:initTowerInfos()
	self.panel.Img_TowerInfo:SetActiveEx(false)
	local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerInfo.PlayerDungeonsInfo.DungeonID,true)
	if MLuaCommonHelper.IsNull(l_dungeonData) then
		return
	end
	self.panel.Img_ShowTowerMonsterNumber:SetActiveEx(l_dungeonData.ShowRemainMonsters==1)
	--无限塔的业务需求先保留原逻辑
	if self:isTowerDungeon() then
		self.panel.Img_TowerInfo:SetActiveEx(true)
		--非无限塔隐藏宝箱
		local l_dungeonMgr=MgrMgr:GetMgr("DungeonMgr")
		self.panel.Btn_ShowTowerReward:SetActiveEx(l_dungeonData.DungeonsType == l_dungeonMgr.DungeonType.DungeonTower)
		self.panel.Txt_ShowTowerMonsterNumber.LabText=MPlayerInfo.PlayerDungeonsInfo.LeftMonster
		self.lastLeftMonsterCount=MPlayerInfo.PlayerDungeonsInfo.LeftMonster
	end
end

function MapCtrl:initClickEvent()
    -- 副本词缀
    self.panel.AffixBtn:SetActiveEx(#MgrMgr:GetMgr("DungeonMgr").DungeonAffixIds > 0)
    self.panel.AffixBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Bossbuff)
    end)

	self.panel.Btn_CloseBig:AddClick(function()
		self:showBigMap(false)
		self:closeMapInfo()
	end,true)
	self.panel.But_MnMapPanel:AddClick(function()
		self:showBigMap(true)
	end,true)
	self.panel.Btn_FliesWings:AddClick(function()
		local count = Data.BagModel:GetBagItemCountByTid(self.fliesWingsId)
		if count <= 0 then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips( Lang("ITEM_NOT_ENOUGH"))
			return
		end
		MgrMgr:GetMgr("PropMgr").RequestUseItemByItemId(self.fliesWingsId)
	end,true)
	self.panel.Btn_OpenMapInfo:AddClick(function()
		if self:isMapInfoPanelShow() then
			self:closeMapInfo()
			return
		end
		self:showOpenMapInfo()
		self:closeNearPeoplePanel()
	end,true)
	self.panel.Btn_CloseMapInfo:AddClick(function()
		self:closeMapInfo()
	end,true)
	self.panel.Btn_OpenWorldMap:AddClick(function()
		if not MTransferMgr.IsActiveWorldMap then
			UIMgr:ActiveUI(CtrlNames.WorldMap)
		end
	end,true)
	self.panel.Raw_BigMapBg.Listener.onClick = function(go, eventData)
		self:onBigMapBgClick(go, eventData)
	end
	self.panel.But_PlayerPositionBG:SetActiveEx(MGameContext.IsOpenGM)
	self.panel.But_PlayerPositionBG:AddClick(function()
		local l_playerEntity=self:getEntity()
		local l_playerPos=l_playerEntity.Position
		local l_face=l_playerEntity.VehicleOrModel.Trans.eulerAngles.y
		local l_result=StringEx.Format("{0}={1:F2}={2:F2}={3:F2}={4:F2}",MScene.SceneID,l_playerPos.x,l_playerPos.y,l_playerPos.z,l_face)
		MCommonFunctions.CopyToClipboard(l_result)
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COPY_TO_CLIPBOARD_TIPS"))
	end,true)
	self.panel.But_CollectToPlayerOffset:AddClick(function()
		local l_playerEntity=self:getEntity()
		local l_playerPos=l_playerEntity.Position
		local l_face=l_playerEntity.VehicleOrModel.Trans.eulerAngles.y
		local l_selectTarget=MEntityMgr:GetEntity(self.selectTargerUID)
		if not MLuaCommonHelper.IsNull(l_selectTarget) then
			local l_offset=l_playerPos-l_selectTarget.Position
			local l_result=StringEx.Format("{0:F2}={1:F2}={2:F2}={3:F2}",l_offset.x,l_offset.y,l_offset.z,l_face)
			MCommonFunctions.CopyToClipboard(l_result)
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COPY_TO_CLIPBOARD_TIPS"))
		end
	end,true)
	self.panel.Btn_CloseNearPeople:AddClick(function()
    	self:closeNearPeoplePanel()
    end, true)
    self.panel.Btn_Enlarge:AddClick(function()
        local l_enlargeScale = MGlobalConfig:GetInt("LittleMapMagnifyRatio",2)
        self:setBigMapEnlargeScale(l_enlargeScale,false)
    end, true)
    self.panel.Btn_Reduce:AddClick(function()
        self:setBigMapEnlargeScale(1,false)
    end, true)
    self.panel.Btn_NearPeople:AddClick(function()
		if self.panel.Panel_NearPeople.UObj.activeSelf then
			self:closeNearPeoplePanel()
			return
		end
        self:showNearPeopleInfo()
		self:closeMapInfo()
    end, true)
end

function MapCtrl:initMapMesh()
	self:releaseMapMesh()
	local l_miniMapRtW = MapDataModel.MnMapRealScale
	if MCommonFunctions.IsEqual(l_miniMapRtW,0) then --此值不能为0
		l_miniMapRtW = 512
	end
	local l_mnMapObjRd={}

	if  MLuaCommonHelper.IsNull(MapObjMgr.MiniMapSpriteMesh) then
		logError("not minimap obj mesh")
	else
		MapObjMgr.MiniMapSpriteMesh:SetRtSize(l_miniMapRtW)
		table.insert(l_mnMapObjRd,MapObjMgr.MiniMapSpriteMesh.meshRenderer)
	end

	if MLuaCommonHelper.IsNull(self.mnMapObjRt) then
		self.mnMapObjRt = MLuaClientHelper.DrawRenderTexture(l_miniMapRtW, l_mnMapObjRd)
		if MLuaCommonHelper.IsNull(self.mnMapObjRt) then
			logError("create minimap RT failed")
		end
	end

	self.panel.Raw_MnMapObj.RawImg.texture = self.mnMapObjRt
	local l_bigMapRtW = self.bigMapRealScale

	local l_bigMapObjRds = {}
	if MLuaCommonHelper.IsNull(MapObjMgr.BigMapSpriteMesh) then
		logError("not bigmap obj mesh")
	else
		MapObjMgr.BigMapSpriteMesh:SetRtSize(l_bigMapRtW)
		table.insert(l_bigMapObjRds,MapObjMgr.singleton.BigMapSpriteMesh.meshRenderer)
	end

	if MLuaCommonHelper.IsNull(MapObjMgr.BigMapTxtMesh) then
		logError("not bigmap obj txt mesh")
	else
		MapObjMgr.BigMapTxtMesh:SetRtSize(l_bigMapRtW)
		table.insert(l_bigMapObjRds,MapObjMgr.singleton.BigMapTxtMesh.meshRenderer)
	end

	if MLuaCommonHelper.IsNull(self.bigMapObjRt) then
		self.bigMapObjRt =MLuaClientHelper.DrawRenderTexture(l_bigMapRtW, l_bigMapObjRds)
		if MLuaCommonHelper.IsNull(self.bigMapObjRt) then
			logError("create RT failed")
		end
	end
	self.panel.Raw_BigMapObj.RawImg.texture = self.bigMapObjRt
end
--endregion-----------------------init end------------------------

--region ----------------------nearPeople-----------------------
function MapCtrl:showNearPeopleInfo()
    self.panel.Panel_NearPeople:SetActiveEx(true)
    MgrMgr:GetMgr("TeamMgr").GetRecentTeamMate()
end

function MapCtrl:getNearPeopleDisLimitSquare()
    if self.nearPeopleDisLimitSquare == nil then
        self.nearPeopleDisLimitSquare = MGlobalConfig:GetInt("LittleMapNearbyR",1)
        self.nearPeopleDisLimitSquare = self.nearPeopleDisLimitSquare * self.nearPeopleDisLimitSquare
    end
    return self.nearPeopleDisLimitSquare
end

function MapCtrl:getDistanceSquare(fromPosX,fromPosY,toPosX,toPosY)
    local l_offsetX = toPosX - fromPosX
    local l_offsetY = toPosY - fromPosY
    return l_offsetX * l_offsetX + l_offsetY * l_offsetY
end

function MapCtrl:onGetInvationIds(roleIds)
    local l_allPlayerEntity = MEntityMgr:GetRoleEntities()
    local l_showRolesTable = {}
    local l_playerPos = self:getPlayerPos()
    local l_levelCloseRegion = MGlobalConfig:GetInt("LittleMapLevelAbsoluteValue",10)
    for z = 0, l_allPlayerEntity.Count - 1 do
        ---@type MoonClient.MEntity
        local l_roleEntity = l_allPlayerEntity[z]
        local l_disSquare = self:getDistanceSquare(l_playerPos.x,l_playerPos.y,l_roleEntity.Position.x,
                l_roleEntity.Position.z)
        --仅显示小于配置距离玩家
        if l_disSquare <=  self:getNearPeopleDisLimitSquare() then
            local l_levelClose = math.abs(MPlayerInfo.Lv - l_roleEntity.AttrComp.Level)<=l_levelCloseRegion
            local l_roleInfo = {
                entity = l_roleEntity,
                hasInSameTeam = self:hasInSameTeam(roleIds, l_roleEntity.UID),
                --性别是否相等
                isSameSex = MPlayerInfo.IsMale == l_roleEntity.AttrComp.EquipData.IsMale,
                --等级与玩家是否相近
                isLevelClose = math.abs(MPlayerInfo.Lv - l_roleEntity.AttrComp.Level)<=l_levelCloseRegion,
                disSquare = l_disSquare,
                onSelectMethod = function(selectIndex)
                    self:onSelectNearPeople(selectIndex)
                end,
            }
            --角色相近放在前面
            if l_levelClose then
                table.insert(l_showRolesTable,1,l_roleInfo)
            else
                table.insert(l_showRolesTable,l_roleInfo)
            end
        end
    end

    local l_showPlayerNumLimit = MGlobalConfig:GetInt("LittleMapManListLimit",10)

    local l_hasRoleNum = #l_showRolesTable
    --筛选指定数量角色数据
    if l_hasRoleNum>l_showPlayerNumLimit then
        for i = l_hasRoleNum, l_showPlayerNumLimit+1,-1 do
            table.remove(l_showRolesTable,i)
        end
    end
	self:sortNearPeople(l_showRolesTable)
	self.panel.NoData.gameObject:SetActiveEx(#l_showRolesTable<=0)
    self.nearPeoplePool:ShowTemplates({ Datas = l_showRolesTable })
end

function MapCtrl:sortNearPeople(roleDatas)
    table.sort(roleDatas, function(a, b)
        if a.hasInSameTeam and not b.hasInSameTeam then
            return true
        elseif a.hasInSameTeam == b.hasInSameTeam then
            if a.isSameSex ~= b.isSameSex then
                return not a.isSameSex
            else
                if a.disSquare < b.disSquare then
                    return true
                end
            end
        end
        return false
    end)
end

function MapCtrl:hasInSameTeam(roleIds, uid)
    for i = 1, #roleIds do
        if roleIds[i] == uid then
            return true
        end
    end
    return false
end

function MapCtrl:onSelectNearPeople(selectIndex)
    if self.nearPeoplePool == nil then
        return
    end
    self.nearPeoplePool:SelectTemplate(selectIndex)
end
--endregion

--region-----------------------map info------------------------
function MapCtrl:getNpcInfoData(onlyFuncNpc)
	if self.npcDatas==nil or (not self.npcDatas.isInit) then
		self.hasNpc = false
		self.titleId=1
		self.npcDatas={}
		local l_sceneId = MapDataModel.ShowSceneId
		table.insert(self.npcDatas,self:getTitleData(Lang("CURRENT_MAP_NPC"),false))
		self.npcDatas.isInit=true
		self:addTaskAndSceneNpcData(self.npcDatas, l_sceneId,onlyFuncNpc)
		self:addWorldMapInfoNpcData(self.npcDatas,l_sceneId)
		self:addMazeNpcData(self.npcDatas,onlyFuncNpc,l_sceneId)
		for key, value in pairs(self.npcDatas) do
			if type(value) == "table" and not value.isTitle then
				self.hasNpc = true
				break
			end
		end
	end
	return self.npcDatas,self.hasNpc
end

function MapCtrl:getTitleId()
	if self.titleId==nil then
		self.titleId=1
	end
	local l_tempId=self.titleId
	self.titleId=self.titleId+1
	return l_tempId
end

function MapCtrl:addWorldMapInfoNpcData(npcDatas,sceneId)
	local l_worldMapMgr=MgrMgr:GetMgr("WorldMapInfoMgr")
	local l_dynamicNpcs = l_worldMapMgr.GetDynamicDisplayNpcs(sceneId)
	for i = 1, #l_dynamicNpcs do
		local l_dynamicNpcData=l_dynamicNpcs[i]
		local l_tableId = l_dynamicNpcData.tableId
		local l_npcData= TableUtil.GetNpcTable().GetRowById(l_tableId)
		if MLuaCommonHelper.IsNull(l_npcData) then
			logError(StringEx.Format("npcId {0} sceneId {1} in Dynamic Npc ,but not in npcTable",l_tableId,sceneId))
		else
			local l_typeSp = l_npcData.NpcMapIcon
            if not string.ro_isEmpty(l_typeSp) then
                local l_data = self:getOrCreateNpcInfoData(l_npcData, sceneId, l_typeSp, false, l_dynamicNpcData.pos)
                self:insertUniqueNpcDatas(npcDatas,l_data)
                --table.insert(npcDatas, self:getOrCreateNpcInfoData(l_npcData, sceneId, l_typeSp, false, l_dynamicNpcData.pos))
            end
            --if not self:containsNpcData(npcDatas, l_npcData.Id) then
            --    local l_typeSp = l_npcData.NpcMapIcon
            --    if not string.ro_isEmpty(l_typeSp) then
            --        table.insert(npcDatas, self:getOrCreateNpcInfoData(l_npcData, sceneId, l_typeSp, false, l_dynamicNpcData.pos))
            --    end
            --end
		end
	end
end

function MapCtrl:getTaskNpcData(sceneId)
	local l_InProgressTaskDatas = {}
	local l_otherTaskDatas = {}
    if MTransferMgr.IsActiveWorldMap then
		return l_InProgressTaskDatas, l_otherTaskDatas
    end
    local l_iter = MapObjMgr.ObjDic:GetEnumerator()
    while l_iter:MoveNext() do
        local l_keyValue = l_iter.Current
        if l_keyValue.Key.type == MapObjType.TaskNpc then
            local l_npcId = MLuaCommonHelper.Int(l_keyValue.Key.id)
            local l_spName = l_keyValue.Value.spName
            if not string.ro_isEmpty(l_spName) then
                local l_npcRow = TableUtil.GetNpcTable().GetRowById(l_npcId)
                if not MLuaCommonHelper.IsNull(l_npcRow) then
                    local l_isInProgressTask = false
                    local l_npcMapInfo = self.taskMgr.GetTaskNpcInfo(sceneId, l_npcRow.Id)
                    local l_npcDatas = self:getOrCreateNpcInfoData(l_npcRow, sceneId, l_spName, false, Vector3.zero)
                    if l_npcMapInfo ~= nil then
                        if l_npcMapInfo.status == self.taskMgr.ETaskStatus.CanFinish or
                                l_npcMapInfo.status == self.taskMgr.ETaskStatus.Taked then
                            table.insert(l_InProgressTaskDatas, l_npcDatas)
                            l_isInProgressTask = true
                        end
                    end
                    if not l_isInProgressTask then
                        table.insert(l_otherTaskDatas, l_npcDatas)
                    end
                end
            end
        end
    end
    return l_InProgressTaskDatas, l_otherTaskDatas
end

function MapCtrl:addTaskAndSceneNpcData(npcDatas, sceneId,onlyFuncNpc)
    local l_inProgressTaskNpcDatas, l_otherTaskNpcDatas = self:getTaskNpcData(sceneId)
    local l_funcNpcDatas, l_usualNpcDatas = self:getCurrentSceneNpcDatas(sceneId, onlyFuncNpc)
    self:sortTaskNpcData(l_inProgressTaskNpcDatas,sceneId)
    --非可完成、已接取 任务类型的任务NPC数据
    local l_otherStateTaskNpcDatas = {}
    --非可完成、已接取 非任务类型的任务NPC数据
    local l_otherStateOtherNpcDatas = {}
    for i = 1, #l_otherTaskNpcDatas do
        local l_otherTaskNpcData = l_otherTaskNpcDatas[i]
        local l_npcMapInfo = self.taskMgr.GetTaskNpcInfo(sceneId, l_otherTaskNpcData.npcData.Id)
        if l_npcMapInfo~=nil then
            if l_npcMapInfo.tableInfo.typeTag == self.taskMgr.ETaskTag.Adventure then
                table.insert(l_otherStateTaskNpcDatas,l_otherTaskNpcData)
            else
                table.insert(l_otherStateOtherNpcDatas,l_otherTaskNpcData)
            end
        end
    end
    self:sortTaskNpcData(l_otherStateTaskNpcDatas,sceneId)
    self:sortTaskNpcData(l_otherStateOtherNpcDatas,sceneId)

    for i = 1, #l_inProgressTaskNpcDatas do
        self:insertUniqueNpcDatas(npcDatas,l_inProgressTaskNpcDatas[i])
        --table.insert(npcDatas,l_inProgressTaskNpcDatas[i])
    end
    for i = 1, #l_otherStateTaskNpcDatas do
        self:insertUniqueNpcDatas(npcDatas,l_otherStateTaskNpcDatas[i])
        --table.insert(npcDatas,l_otherStateTaskNpcDatas[i])
    end
    for i = 1, #l_funcNpcDatas do
        self:insertUniqueNpcDatas(npcDatas,l_funcNpcDatas[i])
        --table.insert(npcDatas,l_funcNpcDatas[i])
    end
    for i = 1, #l_otherStateOtherNpcDatas do
        self:insertUniqueNpcDatas(npcDatas,l_otherStateOtherNpcDatas[i])
        --table.insert(npcDatas,l_otherStateOtherNpcDatas[i])
    end
    for i = 1, #l_usualNpcDatas do
        self:insertUniqueNpcDatas(npcDatas,l_usualNpcDatas[i])
        --table.insert(npcDatas,l_usualNpcDatas[i])
    end
end

function MapCtrl:sortTaskNpcData(npcDatas,sceneId)
	if npcDatas==nil then
		return
	end
    table.sort(npcDatas,function(a,b)
        local l_npcAMapInfo = self.taskMgr.GetTaskNpcInfo(sceneId, a.npcData.Id)
        local l_npcBMapInfo = self.taskMgr.GetTaskNpcInfo(sceneId, b.npcData.Id)
        if l_npcAMapInfo~=nil and l_npcBMapInfo~=nil then
            --可以完成排在最前面、可接取紧随其后
            if l_npcAMapInfo.status~= l_npcBMapInfo.status then
                if  l_npcAMapInfo.status == self.taskMgr.ETaskStatus.CanFinish  then
                    return true
                end
            else
                --任务类型>玩法类型>奇遇类型
                if l_npcAMapInfo.tableInfo.typeTag < l_npcBMapInfo.tableInfo.typeTag then
                    return true
                elseif l_npcAMapInfo.tableInfo.typeTag == l_npcBMapInfo.tableInfo.typeTag then
                    if l_npcAMapInfo.taskData.showPriority < l_npcBMapInfo.taskData.showPriority then
                        return true
                    elseif l_npcAMapInfo.taskData.showPriority == l_npcBMapInfo.taskData.showPriority then
                        if l_npcAMapInfo.taskData.showTime > l_npcBMapInfo.taskData.showTime then
                            return true
                        end
                    end
                end
            end
        elseif l_npcAMapInfo~=nil then
            return true
        elseif l_npcBMapInfo~=nil then
            return false
        end
        return false
    end)
    return npcDatas
end

function MapCtrl:insertUniqueNpcDatas(npcDatas,npcData)
    if not self:containsNpcData(npcDatas, npcData.npcData.Id) then
        --local l_npcAMapInfo = self.taskMgr.GetTaskNpcInfo(7, npcData.npcData.Id)
        --if l_npcAMapInfo~=nil then
        --    logError(tostring(l_npcAMapInfo.tableInfo.typeTag))
        --else
        --    logError(tostring("nil"))
        --end
        table.insert(npcDatas, npcData)
    end
end

function MapCtrl:containsNpcData(npcDatas,npcId)
	if npcDatas==nil then
		return false
	end
	for i = 1, #npcDatas do
		local l_npcData=npcDatas[i]
		if not MLuaCommonHelper.IsNull(l_npcData.npcData) and l_npcData.npcData.Id==npcId then
			return true
		end
	end
	return false
end

function MapCtrl:addMazeNpcData(npcDatas,onlyFuncNpc,sceneId)
	local l_mapData = TableUtil.GetMapTable().GetRowBySceneId(sceneId,true)
	if MLuaCommonHelper.IsNull(l_mapData) then
		return
	end
	if  l_mapData.LabyrinthArea1.Length > 0 then
		self:getMazeNpcData(npcDatas,l_mapData.LabyrinthArea1,l_mapData.LabyrinthAreaDes1,onlyFuncNpc)
	end
	if  l_mapData.LabyrinthArea2.Length > 0 then
		self:getMazeNpcData(npcDatas,l_mapData.LabyrinthArea2,l_mapData.LabyrinthAreaDes2,onlyFuncNpc)
	end
	if  l_mapData.LabyrinthArea3.Length > 0 then
		self:getMazeNpcData(npcDatas,l_mapData.LabyrinthArea3,l_mapData.LabyrinthAreaDes3,onlyFuncNpc)
	end
end

function MapCtrl:getCurrentSceneNpcDatas(sceneId, onlyFuncNpc)
    local l_funcNpcData, l_usualNpcData = self:getNpcInfosBySceneId(sceneId, onlyFuncNpc)
    local l_funcNpcDatas = {}
    local l_usualNpcDatas = {}
    if l_funcNpcData.count == 0 and l_usualNpcData.count == 0 then
        return l_funcNpcDatas,l_usualNpcDatas
    end
    for i = 1, l_funcNpcData.count do
        local l_npcData = l_funcNpcData[i]
        l_npcData.isFold = false
        table.insert(l_funcNpcDatas, l_npcData)
    end
    l_funcNpcDatas = self:sortNpcByPriority(l_funcNpcDatas)
    for i = 1, l_usualNpcData.count do
        local l_npcData = l_usualNpcData[i]
        l_npcData.isFold = false
        table.insert(l_usualNpcDatas, l_npcData)
    end
    l_usualNpcDatas = self:sortNpcByPriority(l_usualNpcDatas)
    return l_funcNpcDatas, l_usualNpcDatas
end

function MapCtrl:sortNpcByPriority(sortTable)
    table.sort(sortTable,function(a,b)
        if a.npcData.MapIconWeight < b.npcData.MapIconWeight then
            return true
        elseif a.npcData.MapIconWeight == b.npcData.MapIconWeight then
            if a.npcData.Id < b.npcData.Id then
                return true
            end
        end
        return false
    end)
    return sortTable
end

function MapCtrl:getMazeNpcData(npcDatas,labyrinthArea,labyrinthAreaDes,onlyFuncNpc)
	if labyrinthArea.Length<1  then
		return
	end
	local l_funcNpcData,l_usualNpcData
	if not string.ro_isEmpty(labyrinthAreaDes) then
		l_funcNpcData,l_usualNpcData=self:getNpcInfos(labyrinthArea,onlyFuncNpc)
		l_mapName=labyrinthAreaDes..Lang("MAP_INFO_NPC")
		self:addMazeSceneData(npcDatas, l_mapName,l_funcNpcData,l_usualNpcData,onlyFuncNpc)
	else
		for i = 0, labyrinthArea.Length-1 do
			local l_sceneId=MLuaCommonHelper.Int(labyrinthArea[i])
			l_funcNpcData,l_usualNpcData=self:getNpcInfosBySceneId(l_sceneId,onlyFuncNpc)
			local l_mapData = TableUtil.GetMapTable().GetRowBySceneId(l_sceneId,true)
			if not MLuaCommonHelper.IsNull(l_mapData) then
				local l_mapName=l_mapData.SceneName..Lang("MAP_INFO_NPC")
				self:addMazeSceneData(npcDatas, l_mapName,l_funcNpcData,l_usualNpcData,onlyFuncNpc)
			end
		end
	end
end

function MapCtrl:addMazeSceneData(npcDatas, mapName,funcNpcData,usualNpcData,onlyFuncNpc)
	if not (funcNpcData.count>0 or (not onlyFuncNpc and usualNpcData.count>0)) then
		return
	end
	local l_isFold=true
	table.insert(npcDatas,self:getTitleData(mapName,l_isFold))
	for i = 1, funcNpcData.count do
		local l_funcData=funcNpcData[i]
		l_funcData.isFold=l_isFold
		table.insert(npcDatas,l_funcData)
	end
	for i = 1, usualNpcData.count do
		local l_usualData=usualNpcData[i]
		l_usualData.isFold=l_isFold
		table.insert(npcDatas,l_usualData)
	end
end

function MapCtrl:getTitleData(mapName,isFold,setToFirstPos)
	local l_titleData=
	{
		isTitle=true,
		titleId=self:getTitleId(),
		mapName=mapName,
		isFold=isFold,
		buttonMethod=nil,
		setToFirstPos=setToFirstPos,
	}
	return l_titleData
end

function MapCtrl:getOrCreateNpcInfoData(npcRow,sceneId,spName,isFold,pos)
	local l_npcData=
	{
		npcData = npcRow,
		sceneId = sceneId,
		spName=spName,
		isFold=isFold,
		pos = pos
	}
	return l_npcData
end

function MapCtrl:getOrCreateEventObj(parent)
	local l_eventObj=self:CloneObj(self.panel.Obj_RowEvtInfo.UObj)
	l_eventObj:SetActiveEx(true)
	local l_eventTran = l_eventObj.transform
	l_eventTran:SetParent(parent)
	l_eventTran.localScale=Vector3.one
	table.insert(self.eventObjTables,l_eventObj)
	return l_eventObj.transform
end

function MapCtrl:releaseNpcInfo()
	if self.npcInfoPool~=nil then
		self.npcInfoPool:CancelSelectTemplate()
	end
	self.npcDatas={}
end

function MapCtrl:releaseWeatherTips()
	for i=1, #self.weatherTipTables do
		local l_weatherTipObj=self.weatherTipTables[i]
		MResLoader:DestroyObj(l_weatherTipObj.UObj)
	end
	self.weatherTipTables={}
end

function MapCtrl:releaseEventInfo()
	self.isEventInfoInit=false
	for i = 1, #self.mapTitleTemplateEventTables do
		local l_mapTitleTem=self.mapTitleTemplateEventTables[i]
		self:UninitTemplate(l_mapTitleTem)
	end
	for i = 1, #self.eventObjTables do
		local l_eventObj=self.eventObjTables[i]
		MResLoader:DestroyObj(l_eventObj)
	end
	self.eventObjTables={}
	return npcData
end

function MapCtrl:containsKey(tb, value)
	for k, v in pairs(tb) do
		if v == value then
			return true
		end
	end

	return false
end

function MapCtrl:getNpcInfosBySceneId(sceneId,onlyFuncNpc)
	self.funcNpcDatas.count=0
	self.usualNpcDatas.count=0

	local l_dataList = MSceneMgr:GetAllNpcInfos()
	for i = 0, l_dataList.Count-1 do
		local l_sceneNpcData=l_dataList[i]
		if l_sceneNpcData.sceneId==sceneId then
			self:handleNpcInfo(self.funcNpcDatas,self.usualNpcDatas,l_sceneNpcData.selfId,sceneId,onlyFuncNpc)
		end
	end
	return self.funcNpcDatas,self.usualNpcDatas
end

function MapCtrl:handleNpcInfo(funcNpcDatas,usualNpcDatas,npcId,sceneId,onlyFuncNpc)
	local l_npcData = TableUtil.GetNpcTable().GetRowById(npcId)
	if MLuaCommonHelper.IsNull(l_npcData) or l_npcData.ElfID>0 then
		return
	end
	if string.ro_isEmpty(l_npcData.NpcMapIcon) then
		if not onlyFuncNpc then
			local l_index=usualNpcDatas.count+1
			usualNpcDatas.count=l_index
			local l_data=self:getOrCreateNpcInfoData(l_npcData,sceneId,nil,false,Vector3.zero)
			usualNpcDatas[l_index]=l_data
		end
	else
		local l_index=funcNpcDatas.count+1
		funcNpcDatas.count=l_index
		local l_data=self:getOrCreateNpcInfoData(l_npcData,sceneId,nil,false,Vector3.zero)
		l_data.npcData=l_npcData
		l_data.sceneId=sceneId
		funcNpcDatas[l_index]=l_data
	end
end

function MapCtrl:getNpcInfos(sceneIds,onlyFuncNpc)
	self.funcNpcDatas.count=0
	self.usualNpcDatas.count=0
	local l_dataList = MSceneMgr:GetAllNpcInfos()
	for i = 0, l_dataList.Count-1 do
		local l_sceneNpcData=l_dataList[i]
		if Common.Utils.CSharpArrayContainValue(sceneIds,l_sceneNpcData.sceneId) then
			self:handleNpcInfo(self.funcNpcDatas,self.usualNpcDatas,l_sceneNpcData.selfId,l_sceneNpcData.sceneId,onlyFuncNpc)
		end
	end
	return self.funcNpcDatas,self.usualNpcDatas
end

function MapCtrl:getNpcTemplateAndPrefab(data)
	if data==nil then
		return
	end
	local l_npcTemplate,l_prefab
	if data.isTitle then
		l_npcTemplate = UITemplate.MapInfoTitleTemplate
		l_prefab = self.panel.MapInfoTitleTemplate.gameObject
	else
		if data.isFold then
			l_npcTemplate = UITemplate.EmptyTemplate
			l_prefab = self.panel.EmptyTemplate.gameObject
		else
			l_npcTemplate = UITemplate.NpcInfoTemplate
			l_prefab = self.panel.NpcInfoTemplate.gameObject
		end
	end
	return l_npcTemplate,l_prefab
end

function MapCtrl:showNpcInfoPanel()
	local l_data,l_hasNpc = self:getNpcInfoData(true)
	self.panel.NoDataNpcInfo.gameObject:SetActiveEx(not l_hasNpc)
	self.npcInfoPool:ShowTemplates({
		Datas = l_data,
		StartScrollIndex=self.npcInfoPool:GetCellStartIndex(),
		IsNeedShowCellWithStartIndex=false,
		IsToStartPosition=false,
	})
end

function MapCtrl:showMonsterInfoPanel()
	if self.isMonsterInfoInited then
		return
	end
	self.isMonsterInfoInited=true
	local l_hasMonsterInfo = self:showCurrentSceneMonsterInfoPanel()
	local l_mapData = TableUtil.GetMapTable().GetRowBySceneId(MapDataModel.ShowSceneId,true)
	if MLuaCommonHelper.IsNull(l_mapData) then
		return
	end
	if not string.ro_isEmpty(l_mapData.LabyrinthAreaDes1) then
		l_hasMonsterInfo = self:showSubSceneMonsterInfoPanel(l_mapData.LabyrinthAreaDes1,l_mapData.LabyrinthArea1)
			or l_hasMonsterInfo
	end
	if not string.ro_isEmpty(l_mapData.LabyrinthAreaDes2) then
		l_hasMonsterInfo = self:showSubSceneMonsterInfoPanel(l_mapData.LabyrinthAreaDes2,l_mapData.LabyrinthArea2)
				or l_hasMonsterInfo
	end
	if not string.ro_isEmpty(l_mapData.LabyrinthAreaDes3) then
		l_hasMonsterInfo = self:showSubSceneMonsterInfoPanel(l_mapData.LabyrinthAreaDes3,l_mapData.LabyrinthArea3)
				or l_hasMonsterInfo
	end
	self.panel.NoDataMonsterInfo:SetActiveEx(not l_hasMonsterInfo)
end

function MapCtrl:showCurrentSceneMonsterInfoPanel()
	local l_titleData=self:getTitleData(Lang("CURRENT_MAP_MONSTERS"),false)
	local l_monsterIds=MSceneMgr:GetMonsIdsBySceneId(MapDataModel.ShowSceneId)
	local l_monsterObjParentTran
	l_titleData.buttonMethod=function()
		if not MLuaCommonHelper.IsNull(l_monsterObjParentTran) then
			l_monsterObjParentTran.gameObject:SetActiveEx(not l_titleData.isFold)
		end
	end
	self:getOrCreateMapTitleTem(l_titleData,true)
	l_monsterObjParentTran= self:getOrCreateMonsterObjParent()
	local l_hasMonsterInfo = false
	for i = 0, l_monsterIds.Count-1 do
		local l_curState = self:setMonsterInfo(l_monsterObjParentTran,l_monsterIds[i],MapDataModel.ShowSceneId)
		if l_curState then
			l_hasMonsterInfo = true
		end
	end
	return l_hasMonsterInfo
end

function MapCtrl:setMonsterInfo(parent,monsterId,sceneId)
	if MLuaCommonHelper.IsNull(parent) then
		return
	end
	local l_entityRow=TableUtil.GetEntityTable().GetRowById(monsterId)
	if MLuaCommonHelper.IsNull(l_entityRow) then
		logError(StringEx.Format("Can't find EntityTable.RowData id={0} @陈阳", monsId))
		return
	end
	if l_entityRow.UnitTypeLevel~=0 then
		return
	end
	local l_presentRow=TableUtil.GetPresentTable().GetRowById(l_entityRow.PresentID)
	if MLuaCommonHelper.IsNull(l_presentRow) then
		logError(StringEx.Format("Can't find PresentTable.RowData id={0} @陈阳", l_entityRow.PresentID))
		return
	end
	self:getOrCreateBtnMonsterInfoTem(parent,monsterId,sceneId,l_presentRow.Atlas,l_presentRow.Icon)
	return true
end

function MapCtrl:showSubSceneMonsterInfoPanel(labyrinthAreaDes,labyrinthArea)
	if string.ro_isEmpty(labyrinthAreaDes) then
		return false
	end
	local l_mapName=labyrinthAreaDes..Lang("MAP_INFO_MONSTER")
	local l_monsterObjParentTran
	local l_titleData=self:getTitleData(l_mapName,false)
	l_titleData.buttonMethod=function()
		if not MLuaCommonHelper.IsNull(l_monsterObjParentTran) then
			l_monsterObjParentTran.gameObject:SetActiveEx(not l_titleData.isFold)
		end
	end
	self:getOrCreateMapTitleTem(l_titleData,true)
	l_monsterObjParentTran= self:getOrCreateMonsterObjParent()
	local l_tempMonsterIds={}
	local l_hasMonsterInfo = false
	for i = 0, labyrinthArea.Length-1 do
		local l_sceneId=labyrinthArea[i]
		local l_monsterIds=MSceneMgr:GetMonsIdsBySceneId(l_sceneId)
		local l_monsterCount=l_monsterIds.Count
		if l_monsterCount>0 then
			for i = 0, l_monsterIds.Count-1 do
				local monsterId=l_monsterIds[i]
				if not table.ro_contains(l_tempMonsterIds,monsterId) then
					table.insert(l_tempMonsterIds,monsterId)
					l_hasMonsterInfo = true
					self:setMonsterInfo(l_monsterObjParentTran,monsterId,l_sceneId)
				end
			end
		end
	end
	return l_hasMonsterInfo
end

function MapCtrl:getOrCreateMonsterObjParent()
	local monsterObjParent= self:CloneObj(self.panel.Panel_MonsInfo.UObj)
	local l_monsterObjParentTran= monsterObjParent.transform
	l_monsterObjParentTran:SetParent(self.panel.Obj_MonsterContent.Transform)
	l_monsterObjParentTran.localScale=self.panel.Panel_MonsInfo.Transform.localScale
	l_monsterObjParentTran.gameObject:SetActiveEx(true)
	table.insert(self.monsterParentTables,monsterObjParent)
	return l_monsterObjParentTran
end

function MapCtrl:releaseMonsterInfoPanel()
	for i = 1, #self.mapTitleTemplateTables do
		local l_mapTitleTem=self.mapTitleTemplateTables[i]
		self:UninitTemplate(l_mapTitleTem)
	end
	self.mapTitleTemplateTables={}
	for i = 1, #self.btnMonsterInfoTemplateTables do
		local l_monsterInfoTem=self.btnMonsterInfoTemplateTables[i]
		self:UninitTemplate(l_monsterInfoTem)
	end
	for i = 1, #self.btnMonsterInfoTemplateTables do
		local l_monsterObj=self.btnMonsterInfoTemplateTables[i]
		if not MLuaCommonHelper.IsNull(l_monsterObj) then
			l_monsterObj:Uninit()
		end
	end
	for i = #self.monsterParentTables, 1,-1 do
		local l_monsterParentObj = self.monsterParentTables[i]
		if not MLuaCommonHelper.IsNull(l_monsterParentObj) then
			MResLoader:DestroyObj(l_monsterParentObj, self.usePool)
		end
	end
	self.btnMonsterInfoTemplateTables={}
	self.isMonsterInfoInited=false
end

function MapCtrl:getOrCreateMapTitleTem(titleData,isMonsterUse)
	local l_parent
	if isMonsterUse then
		l_parent=self.panel.Obj_MonsterContent.Transform
	else
		l_parent=self.panel.Obj_eventContent.Transform
	end
	local mapTitle = self:NewTemplate("MapInfoTitleTemplate",{
		TemplatePrefab = self.panel.MapInfoTitleTemplate.gameObject,
		TemplateParent = l_parent,
		Data = titleData,
	})
	if isMonsterUse then
		table.insert(self.mapTitleTemplateTables,mapTitle)
	else
		table.insert(self.mapTitleTemplateEventTables,mapTitle)
	end
end

function MapCtrl:getOrCreateBtnMonsterInfoTem(parent,monsterId,sceneId,atlas,icon)
	local l_monsterInfoObj=self:NewTemplate("BtnMonsInfoTemplate",{
		TemplatePrefab = self.panel.BtnMonsInfoTemplate.gameObject,
		TemplateParent = parent,
		Data =
		{
			monsterId = monsterId,
			sceneId= sceneId,
			atlas = atlas,
			spName= icon,
		},
	})
	table.insert(self.btnMonsterInfoTemplateTables,l_monsterInfoObj)
end
--endregion-----------------------map end ------------------------

--region---------------map base logic--------------------------
function MapCtrl:activeBigMap()
	if self:IsInited() and self.panel.Panel_BigMap.Canvas.enabled then
		return true
	end
	return false
end

function MapCtrl:isMapInfoPanelShow()
	if not self:IsInited() or MLuaCommonHelper.IsNull(self.panel.Panel_MapInfo.Canvas)  then
		return false
	end
	return self.panel.Panel_MapInfo.Canvas.enabled
end

function MapCtrl:showBigMapInner(isShow)
	self._needNotifyMerchantState = true
	if not self:IsInited() then
		return
	end
	MapDataModel.IsBigMapActive=isShow

	self.panel.Panel_BigMap.Canvas.enabled = isShow
	if isShow then
		self.panel.Btn_OpenMapInfo.UObj:SetActiveEx(not MStageMgr.IsDungeon)
		self:freshWeatherUnit()
	else
		self.panel.Panel_WeatherTip:SetActiveEx(false)
		self:closeMapInfo()
	end
	self.panel.Btn_NearPeople:SetActiveEx(not MPlayerInfo.IsWatchWar)
end

function MapCtrl:closeMapInfo()
	self:showMapInfo(false)
	self.panel.Toggle_ShowALlToggle.Tog.isOn = false
	MapObjMgr:OnCloseBigMap()
end

function MapCtrl:closeNearPeoplePanel()
	self.panel.Panel_NearPeople:SetActiveEx(false)
	if self.nearPeoplePool~=nil then
		self.panel.NoData.gameObject:SetActiveEx(true)
		self.nearPeoplePool:ShowTemplates({ Datas = {} })
	end
end

function MapCtrl:showOpenMapInfo()
	self:releaseInfo()
	if self.panel.Tog_01.TogEx.isOn then
		self:showNpcInfoPanel()
	end
	self.panel.Tog_01.TogEx.isOn=true
	self:showMapInfo(true)
end

function MapCtrl:refreshMapInfo()
    if not self.panel.Panel_MapInfo.Canvas.enabled then
		return
	end
	if not MTransferMgr.singleton.IsActiveWorldMap then
		return
	end
	self:releaseInfo()
	if self.panel.Tog_01.TogEx.isOn then
		self:showNpcInfoPanel()
		return
	end
	if self.panel.Tog_02.TogEx.isOn then
		self:showMonsterInfoPanel()
		return
	end
	if self.panel.Tog_03.TogEx.isOn then
		self:showEvtInfo()
		return
	end
end

function MapCtrl:onBigMapBgClick(go,eventData)
	if MPlayerInfo.IsWatchWar then
		return
	end
	local l_pointPos=eventData.position
	local l_worldSceneId = MTransferMgr.WorldMapSelectId
	local l_isActiveWorldMap = MTransferMgr.singleton.IsActiveWorldMap
	local l_navSceneId=MapDataModel.ShowSceneId
	local l_sceneData = TableUtil.GetSceneTable().GetRowByID(l_navSceneId)
	if l_sceneData == nil or l_sceneData.CanMnMapNav == 1 then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CANT_SUPPORT_MNMAP_NAV"))
		return
	end
	local l_point = Vector2.New(l_pointPos.x, l_pointPos.y)
	local l_cgPos = self:getRealPosFromBigMap(l_point)
	if MapObjMgr:TryClickEvent(go, eventData, l_cgPos) then
		return
	end
	local l_y = 0
	if l_isActiveWorldMap then
		--Process_RpcC2G_EasyNavigate.OutPutError = false;
		MTransferMgr:GotoPosition(l_worldSceneId, Vector3.New(l_cgPos.x, l_y, l_cgPos.y))
		UIMgr:DeActiveUI(CtrlNames.WorldMap)
		if MScene.SceneEntered then
			MTransferMgr:AddMapObj(MScene.SceneID)
			--UIMgr:ActiveUI(CtrlNames.Map)
		end
	else
		local l_player = self:getEntity()
		if not MLuaCommonHelper.IsNull(l_player) and (not l_player.Deprecated) then
			if l_player.IsFly then
				MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_Navigation, 0,0,false,Vector3.New(l_cgPos.x, 0, l_cgPos.y))
			else
				local l_desPos = self:seekMovePoint(l_cgPos)
				if l_desPos.x < 0 then
					MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ARRIVE"))
				else
					MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_Navigation, 0,0,false,l_desPos,true,true,true)
				end
			end
		end
	end
	if  self._needNotifyMerchantState then
		self._needNotifyMerchantState = false
		MUIEvent.SendLuaMessage("ENUM_UI_NOTIFY_MERCHANT_CANNOT_TELEPORT")
	end
end

function MapCtrl:releaseInfo()
	self:releaseNpcInfo()
	self:releaseEventInfo()
	self:releaseMonsterInfoPanel()
end

function MapCtrl:showEvtInfo()
	if not self:IsInited() then
		return
	end
	if self.isEventInfoInit then
		return
	end
	self.isEventInfoInit=true
	local l_titleData=self:getTitleData(Lang("CURRENT_MAP_EVENT"),false,true)
	l_titleData.buttonMethod=function()
		self.panel.Panel_EvtInfo.UObj:SetActiveEx(not l_titleData.isFold)
	end
	self:getOrCreateMapTitleTem(l_titleData,false)
	local l_eventIds= MgrMgr:GetMgr("WorldMapInfoMgr").GetSceneInfluence(MapDataModel.ShowSceneId)
	local l_hasEvent=false
	for i = 1, #l_eventIds do
		local l_eventId=l_eventIds[i]
		local l_eventRow= TableUtil.GetOpenWorldInfluenceTable().GetRowByID(l_eventId)
		if not MLuaCommonHelper.IsNull(l_eventRow) then
			local l_eventTran = self:getOrCreateEventObj(self.panel.Panel_EvtInfo.Transform)
			local l_evtInfoImg=l_eventTran:Find("ImgEvtInfo"):GetComponent("MLuaUICom")
			l_evtInfoImg:SetSprite(l_eventRow.Atlas, l_eventRow.Icon)
			local l_eventTxt = l_eventTran:Find("TxtEvtInfo"):GetComponent("MLuaUICom")
			l_eventTxt.LabText= l_eventRow.Desc
			l_hasEvent=true
		end
	end
	self.panel.Panel_NoEvent:SetActiveEx(not l_hasEvent)
end

function MapCtrl:showMapInfo(active)
	if self.panel.Panel_MapInfo.Canvas.enabled ~= active then
		self.panel.Panel_MapInfo.Canvas.enabled=active
	end
	if active then
		---因--bug=1087178 --user=曾祥硕 【KR.DEV.OBT分支】【... https://www.tapd.cn/20332331/s/1814090
		---临时解决方案，策划将场景类型配置为PVP类型，此处特判场景ID
--		local sceneData = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
--		if sceneData.SceneType == GameEnum.ESceneType.Hunt then
		if MScene.SceneID == MGlobalConfig:GetInt("HuntingGroundSceneID") then
			self.panel.Tog_02:SetActiveEx(false)
		else
			self.panel.Tog_02:SetActiveEx(true)
		end
	end
end

function MapCtrl:showBigMap(isShow)
    if not isShow or MTransferMgr.IsActiveWorldMap then
        if self.enlargeMode then
            self:setBigMapEnlargeScale(1,false)
        end
        self:closeNearPeoplePanel()
        self.panel.Btn_Reduce.Transform.parent.gameObject:SetActiveEx(false)
    else
        self.panel.Btn_Reduce.Transform.parent.gameObject:SetActiveEx(true)
    end

    self:showBigMapInner(isShow)
end

function MapCtrl:hideBigMap()
	self:showBigMap(false)
	self:closeMapInfo()
end

function MapCtrl:getEntity()
	if MPlayerInfo.IsWatchWar then
		local l_watchEntity=MEntityMgr:GetEntity(MPlayerInfo.WatchFocusPlayerId)
		if not MLuaCommonHelper.IsNull(l_watchEntity) then
			return l_watchEntity
		end
	end
	return MEntityMgr.singleton.PlayerEntity
end

function MapCtrl:updateShowMapBaseView(changeBigMapState,sceneData,mapIndex)
	self:refreshMapInfo()

	if changeBigMapState==nil then
		changeBigMapState=true
	end
	if changeBigMapState then
		self:showBigMap(MapDataModel.IsBigMapActive)
	end

	self.panel.Panel_BigPlayer:SetActiveEx(not MTransferMgr.IsActiveWorldMap)
	self.panel.Btn_OpenWorldMap:SetActiveEx(not MTransferMgr.IsActiveWorldMap)
	self.panel.Btn_FliesWings:SetActiveEx(not MTransferMgr.IsActiveWorldMap)

	if MPlayerDungeonsInfo.InDungeon then
		self.panel.Btn_OpenWorldMap:SetActiveEx(false)
	end

	if MPlayerInfo.IsWatchWar then
		self.panel.Btn_FliesWings:SetActiveEx(false)
	end

	if MMazeDungeonMgr:IsMazeDungeon(sceneData.ID) then
		self.panel.Raw_BigMapBg:SetRawTex(string.Empty)
		self.panel.Raw_MnMapBg:SetRawTex(string.Empty)
		local l_mapRt=MMazeDungeonMgr:GetMapRt()
		if not MLuaCommonHelper.IsNull(l_mapRt) then
			self.panel.Raw_MnMapBg.RawImg.texture = l_mapRt
			self.panel.Raw_BigMapBg.RawImg.texture = l_mapRt
		end
		self.panel.Raw_BigMapBg:SetRawImgMaterial("Materials/UIMapRT")
		self.panel.Raw_MnMapBg:SetRawImgMaterial("Materials/UIMapRT")
	else
		local l_mapName = sceneData.MapName[mapIndex]
		local l_mapTexName = StringEx.Format("Map/{0}.png",l_mapName)
		self.panel.Raw_BigMapBg:SetRawImgMaterial(string.Empty)
		self.panel.Raw_MnMapBg:SetRawImgMaterial(string.Empty)
		self.panel.Raw_MnMapBg:SetRawTex(l_mapTexName)
		self.panel.Raw_BigMapBg:SetRawTex(l_mapTexName)
	end

	self.panel.Txt_BigMapName.LabText = sceneData.MiniMap
	self.panel.Txt_MnMapName.LabText = sceneData.MiniMap
end

---@Description:检查当前场景配置数据是否合法
---@return boolean 是否成功
---@return SceneTableLua sceneData
---@return number mapindex
function MapCtrl:checkSceneDataValid()
	local l_sceneId=MapDataModel.ShowSceneId
	local l_sceneData=TableUtil.GetSceneTable().GetRowByID(l_sceneId)
	if l_sceneData==nil then
		return false
	end

	local l_maxLength = l_sceneData.MapName.Length
	--没有配置的小地图数据，此处可能不显示小地图，需要关闭小地图
	if l_maxLength<1 then
		logRed("not exist map info in scenetable,sceneId:"..tostring(l_sceneData.ID))
		self.needCloseFlag = true
		return false
	end

	local l_mapIndex = 0
	if MapDataModel.TriggerSceneId > 0 then
		l_mapIndex = Mathf.Clamp(MapDataModel.TriggerSceneMapIndex, 1, l_maxLength) - 1
	end
	if l_mapIndex>=l_sceneData.MapName.Length then
		logRed("SceneTable中MapName缺少配置！访问的索引："..tostring(l_mapIndex))
		return false
	end
	if l_mapIndex>=l_sceneData.MapSize.Length then
		logRed("SceneTable中MapSize缺少配置！访问的索引："..tostring(l_mapIndex))
		return false
	end
	if l_mapIndex>=l_sceneData.MapSizeChange.Length then
		logRed("SceneTable中MapSizeChange缺少配置！访问的索引："..tostring(l_mapIndex))
		return false
	end
	if l_mapIndex>=l_sceneData.MapOffset.Length then
		logRed("SceneTable中MapOffset缺少配置！访问的索引："..tostring(l_mapIndex))
		return false
	end
	return true,l_sceneData,l_mapIndex
end

function MapCtrl:updateShowMap(changeBigMapState)
	if not self:IsInited() then
		return
	end

	local l_sceneDataValid,l_sceneData,l_mapIndex = self:checkSceneDataValid()
	if not l_sceneDataValid then
		return
	end

	self:updateShowMapBaseView(changeBigMapState,l_sceneData,l_mapIndex)

	--初始化场景小地图配置信息
	local l_mapSizeChangeSequence = l_sceneData.MapSizeChange[l_mapIndex]
	local l_mnMapEnlargeScale = 1
	if l_mapSizeChangeSequence.Count>2 then
		l_mnMapEnlargeScale = l_mapSizeChangeSequence[2]
		if l_mnMapEnlargeScale<1 then
			l_mnMapEnlargeScale = 1
		end
	end
	MapDataModel.MinMapEnlargeScale = l_mnMapEnlargeScale
	local l_mnMapScale = self.panel.Raw_MnMapBg.RectTransform.sizeDelta.x
	MapDataModel.MnMapRealScale = l_sceneData.MiniMapSize
	if MCommonFunctions.IsEqual(MapDataModel.MnMapRealScale,0) then
		MapDataModel.MnMapRealScale = 512
	end
	--当前小地图Img大小相对于美术制作的Image大小的比例
	self.mnMapUv = l_mnMapScale / MapDataModel.MnMapRealScale
	self.minMapUvHalf = self.mnMapUv * 0.5
	local l_minMapUvPos = Vector2.one *0.5 - Vector2.New(self.minMapUvHalf,self.minMapUvHalf)
	self.panel.Raw_MnMapObj.RawImg.uvRect = UnityEngine.Rect.New(l_minMapUvPos, Vector2.New(self.mnMapUv, self.mnMapUv))
	--场景真实大小
	MapDataModel.MapRealScale = l_sceneData.MapSize[l_mapIndex]
	self.bigMapScale = self.panel.Raw_BigMapBg.RectTransform.rect.width
	self.bigMapRate =l_mapSizeChangeSequence[0]
	self.bigMapRate = self.bigMapRate
	self.bigMapRealScale = MapDataModel.MnMapRealScale * self.bigMapRate
	local l_mapOffsetInfo=l_sceneData.MapOffset[l_mapIndex]
	--配置的地图偏移
	self.bigMapOffset =  Vector2.New(l_mapOffsetInfo[0], l_mapOffsetInfo[1])
	--计算了图片大小及配置偏移的最终偏移
	local l_bigMapUvOffset = Vector2.New((self.bigMapRealScale - self.bigMapScale) * 0.5, (self.bigMapRealScale - self.bigMapScale) * 0.5) - self.bigMapOffset
	l_bigMapUvOffset =l_bigMapUvOffset / self.bigMapRealScale
	--大地图绘制的比例
	self.bigMapUv = self.bigMapScale / self.bigMapRealScale
	self.bigMapUvHalf = self.bigMapUv * 0.5
	--用于计算小地图绘制处的边界，对应的坐标区间为-1~1,而此处偏移的坐标区间为0~1，归一化，所以要
	--(当前值-0.5) * 2
	MapDataModel.BigMapLeftBorderPercentPos= (l_bigMapUvOffset.x - 0.5)*2
	MapDataModel.BigMapRightBorderPercentPos=(l_bigMapUvOffset.x+self.bigMapUv-0.5)*2

	if self.enlargeMode then
		--放大模式，位置会根据玩家动态变化，此处只是临时位置
		local l_bigMapRealUvOffset = Vector2.New(0.5-self.bigMapUv/2,0.5-self.bigMapUv/2)
		self.panel.Raw_BigMapObj.RawImg.uvRect = UnityEngine.Rect.New(l_bigMapRealUvOffset, Vector2.New(self.bigMapUv, self.bigMapUv))
	else
		self.panel.Raw_BigMapBg.RawImg.uvRect = UnityEngine.Rect.New(l_bigMapUvOffset, Vector2.New(self.bigMapUv, self.bigMapUv))
		self.panel.Raw_BigMapObj.RawImg.uvRect = self.panel.Raw_BigMapBg.RawImg.uvRect
	end
	self:initMapMesh()
	local l_isWorldMapPanelShow=UIMgr:IsActiveUI(CtrlNames.WorldMap)
	self.panel.Panel_EffectParentBigMap:SetActiveEx(not l_isWorldMapPanelShow)
end

function MapCtrl:setBigMapEnlargeScale(scale,callInInit)
    self.currentScale = scale
    self.enlargeMode = self.currentScale > 1
    if self.enlargeMode then
        self.panel.Panel_BigPlayer.RectTransform.anchoredPosition = Vector2.zero
    end
    MapDataModel.IsBigMapEnlargeState = self.enlargeMode
    self.panel.Btn_Enlarge:SetActiveEx(not self.enlargeMode)
    self.panel.Btn_Reduce:SetActiveEx(self.enlargeMode)
	if not callInInit then
		self:updateShowMap(false)
	end
end

function MapCtrl:getBigMapEnlargeScale()
    return self.currentScale
end

function MapCtrl:releaseMapMesh()
	if self:IsInited() then
		self.panel.Raw_MnMapObj.RawImg.texture = nil
		self.panel.Raw_BigMapObj.RawImg.texture = nil
	end
	if not MLuaCommonHelper.IsNull(self.mnMapObjRt) then
		MLuaClientHelper.ReleaseTexture(self.mnMapObjRt)
		self.mnMapObjRt = nil
	end
	if not MLuaCommonHelper.IsNull(self.bigMapObjRt) then
		MLuaClientHelper.ReleaseTexture(self.bigMapObjRt)
		self.bigMapObjRt = nil
	end
end

function MapCtrl:onOpenSceneWorldInfoPanel(go, eventData)
	self:showWeatherTemperatureTipsPanel(false)
end

function MapCtrl:onOpenWeatherTemperatureTips(go, eventData)
	self:showWeatherTemperatureTipsPanel(true)
end

function MapCtrl:addEffect(id,mapData)
	if not self:IsInited() then
		return
	end
	if MLuaCommonHelper.IsNull(mapData) then
		return
	end
	local l_oldMapData = self.effectObjTable[id]
	if not MLuaCommonHelper.IsNull(l_oldMapData) then
		self:removeEffectById(id)
	end
	if mapData.activeBig then
		self:addMapEffect(id, true,mapData)
	end
	if mapData.activeSmall then
		self:addMapEffect(id, false,mapData)
	end
	self.effectObjTable[tostring(id)]=mapData
end

function MapCtrl:removeEffect(id, isAll)
	if isAll then
		for k,v in pairs( self.effectObjTable) do
			self:removeEffectById(k)
		end
		return
	end
	self:removeEffectById(id)
end

function MapCtrl:removeEffectById(id)
	local l_idStr=tostring(id)
	local l_mapData = self.effectObjTable[l_idStr]
	self.effectObjTable[l_idStr]=nil
	if MLuaCommonHelper.IsNull(l_mapData) then
		return
	end
	if not MLuaCommonHelper.IsNull(l_mapData.effectObj) then
		if l_mapData.effectObj.effectId > 0 then
			self:DestroyUIEffect(l_mapData.effectObj.effectId)
			l_mapData.effectObj.effectId = 0
		end
		if l_mapData.effectObj.mnEffectId > 0 then
			self:DestroyUIEffect(l_mapData.effectObj.mnEffectId)
			l_mapData.effectObj.mnEffectId = 0
		end
		if not MLuaCommonHelper.IsNull(l_mapData.effectObj.rawImg) then
			MResLoader:DestroyObj(l_mapData.effectObj.rawImg.gameObject)
			l_mapData.effectObj.rawImg = nil
		end
		if not MLuaCommonHelper.IsNull(l_mapData.effectObj.mnRawImg) then
			MResLoader:DestroyObj(l_mapData.effectObj.mnRawImg.gameObject)
			l_mapData.effectObj.mnRawImg = nil
		end
	end
	MapObjMgr:ReleaseMapRelateObj(l_mapData.effectObj, l_mapData)

end

function MapCtrl:addMapEffect(id, isBigMap,mapData)
	if MLuaCommonHelper.IsNull(mapData) or MLuaCommonHelper.IsNull(mapData.effectObj) then
		return false
	end
	local l_rawImg = self:getEffectRawImg(mapData.spPos, isBigMap)
	if MLuaCommonHelper.IsNull(l_rawImg) then
		logError("addMapEffect error:rawImg is null!")
		return false
	end
	l_rawImg.rectTransform.sizeDelta = mapData.size
	l_rawImg.transform.localScale = Vector3.one
	local l_fxData = {}
	l_fxData.rawImage = l_rawImg
	l_fxData.scaleFac = mapData.scale;
	l_fxData.playTime = mapData.effectObj.playTime
	l_fxData.destroyHandler =function(isFxEnd, data)
		MapObjMgr:RmEffect(id)
	end
	local l_effectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/"..mapData.spName, l_fxData)

	l_rawImg.gameObject:SetActiveEx(not MMazeDungeonMgr:IsMazeDungeon(MScene.SceneID))
	if isBigMap then
		mapData.effectObj.rawImg = l_rawImg
		mapData.effectObj.effectId = l_effectId
	else
		mapData.effectObj.mnRawImg = l_rawImg
		mapData.effectObj.mnEffectId = l_effectId
	end
	return true
end

function MapCtrl:adjustMapEffectPos(mapData)
    if MLuaCommonHelper.IsNull(mapData) then
        return
    end
    if not MLuaCommonHelper.IsNull(mapData.effectObj.rawImg) then
        local l_bigMapPos = MoonClient.MapPerformanceOpt.GetBigMapPosByRealPos(mapData.spPos,self.bigMapOffset,self.bigMapRealScale,self.currentScale)
        mapData.effectObj.rawImg.gameObject:SetRectTransformPos(l_bigMapPos.x,l_bigMapPos.y)
    end
    if not MLuaCommonHelper.IsNull(mapData.effectObj.mnRawImg) then
        local l_mnMapPos = MoonClient.MapPerformanceOpt.GetMnMapPosByRealPos(mapData.spPos)
        mapData.effectObj.mnRawImg.gameObject:SetRectTransformPos(l_mnMapPos.x,l_mnMapPos.y)
    end
end

function MapCtrl:reSetMapEffectScale(mapData)
    if MLuaCommonHelper.IsNull(mapData) then
        return
    end
    local l_rawScale = Vector3.one * self.currentScale
    if not MLuaCommonHelper.IsNull(mapData.effectObj.rawImg) then
        mapData.effectObj.rawImg.transform.localScale = l_rawScale
    end
    if not MLuaCommonHelper.IsNull(mapData.effectObj.mnRawImg) then
        mapData.effectObj.mnRawImg.transform.localScale = l_rawScale
    end
end

function MapCtrl:getEffectRawImg(pos, isBigMap)
    if isBigMap == nil then
        isBigMap = true
    end
    if not self:IsInited() then
        return
    end
    local l_effectObj = MResLoader:CloneObj(self.panel.Raw_EffectTemplate.UObj)
    local l_rawImg = l_effectObj:GetComponent("RawImage")
    if isBigMap then
        l_effectObj.transform:SetParent(self.panel.Panel_EffectParentBigMap.Transform)
        l_rawImg.transform.localScale = Vector3.one
        local bigMapPos = MoonClient.MapPerformanceOpt.GetBigMapPosByRealPos(pos,self.bigMapOffset,self.bigMapRealScale,self.currentScale)
        l_rawImg.transform.localPosition = bigMapPos
    else
        l_effectObj.transform:SetParent(self.panel.Panel_EffectParent.Transform)
        l_rawImg.transform.localScale = Vector3.one
        local mnMapPos = MoonClient.MapPerformanceOpt.GetMnMapPosByRealPos(pos)
        l_rawImg.transform.localPosition = mnMapPos
    end
    return l_rawImg
end

function MapCtrl:onTaskNpcChanged(longNpcId)
	if not self:isMapInfoPanelShow() then
		return
	end
	if self.npcInfoPool==nil then
		return
	end
	self:releaseNpcInfo()
	local l_data,l_hasNpc = self:getNpcInfoData(true)
	self.panel.NoDataNpcInfo.gameObject:SetActiveEx(not l_hasNpc)
	self.npcInfoPool:ShowTemplates({
		Datas = l_data,
		StartScrollIndex=self.npcInfoPool:GetCellStartIndex(),
		IsNeedShowCellWithStartIndex=false,
		IsToStartPosition=false,
	})
end

function MapCtrl:UpdateInput(touchItem)
	super.UpdateInput(self,touchItem)
	if not self:IsInited() then
		return
	end
	if not self.panel.Panel_WeatherTip.UObj.activeSelf then
		return
	end
	local l_firstClickObj = self:GetFirstRaycastObj(touchItem)
	if not MLuaCommonHelper.IsNull(l_firstClickObj) then
		if l_firstClickObj.name ~= "Img_WeatherUnit" then
			self.panel.Panel_WeatherTip.UObj:SetActiveEx(false)
		end
	end
end

function MapCtrl:isTowerDungeon() --原代码逻辑
	local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerInfo.PlayerDungeonsInfo.DungeonID,true)
	if MLuaCommonHelper.IsNull(l_dungeonData) then
		return false
	end
	local l_dungeonMgr=MgrMgr:GetMgr("DungeonMgr")
	if l_dungeonData.DungeonsType == l_dungeonMgr.DungeonType.DungeonTower or
			l_dungeonData.DungeonsType == l_dungeonMgr.DungeonType.DungeonTheme or
			l_dungeonData.DungeonsType == l_dungeonMgr.DungeonType.TowerDefenseSingle or
			l_dungeonData.DungeonsType == l_dungeonMgr.DungeonType.TowerDefenseDouble then
		return true
	end
	return false
end

function MapCtrl:onDungeonMonsterNumChange(count,changeValue)
	local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerInfo.PlayerDungeonsInfo.DungeonID,true)
	if MLuaCommonHelper.IsNull(l_dungeonData) then
		return
	end
	local l_dungeonMgr=MgrMgr:GetMgr("DungeonMgr")
	--无限塔的业务需求先保留原逻辑
	if self:isTowerDungeon() then
		self.panel.Txt_ShowTowerMonsterNumber.LabText=count
		if l_dungeonData.DungeonsType == l_dungeonMgr.DungeonType.TowerDefenseSingle or
				l_dungeonData.DungeonsType == l_dungeonMgr.DungeonType.TowerDefenseDouble then
			if count>self.lastLeftMonsterCount then
				MLuaClientHelper.PlayFxHelper(self.panel.Txt_ShowTowerMonsterNumber.UObj)
			end
			self.lastLeftMonsterCount = count
		end
	else
		l_dungeonMgr.OnUpdateMonsterNum(nil,count,changeValue)
	end
end
--endregion

--region-----------------------pos相关 start----------------------
function MapCtrl:getRealPosFromBigMap(mapPos)
    local l_realPos = Vector2.New(-1, -1)
    local l_pointW = MUIManager.UICamera:ScreenToWorldPoint(mapPos)
    local l_pointLocal = self.panel.Raw_BigMapBg.transform:InverseTransformPoint(l_pointW)
    local l_pointL = Vector2.New(l_pointLocal.x, l_pointLocal.y)
    local l_ratio = MapDataModel.MapRealScale / self.bigMapRealScale / self.currentScale
    if self.currentScale>1 then
        local l_pos1 = (l_pointL )*l_ratio
        l_pos1 = l_pos1 + self:getPlayerPos()
        return l_pos1
    end
    l_pointL = l_pointL - self.bigMapOffset
    l_pointL = l_pointL + Vector2.New(self.bigMapRealScale, self.bigMapRealScale) * 0.5
    l_realPos = l_pointL * l_ratio
    return l_realPos
end

function MapCtrl:seekMovePoint(pos)
	local l_resPos = Vector3.one * -1
	local l_entity=self:getEntity()
	if MLuaCommonHelper.IsNull(l_entity) then
		return l_resPos
	end
	l_resPos = MapDataModel:SeekMovePoint(pos,l_entity.Position)
	return l_resPos
end

function MapCtrl:getPlayerPos()
	local l_playerPos
	if MMazeDungeonMgr:IsMazeDungeon(MapDataModel.ShowSceneId) then
		l_playerPos = MMazeDungeonMgr.PlayerPos;
	else
		local l_playEntity=MEntityMgr.PlayerEntity
		if MLuaCommonHelper.IsNull(l_playEntity) then
			l_playerPos=Vector2.zero
		else
			l_playerPos = Vector2.New(l_playEntity.Position.x, l_playEntity.Position.z)
		end
	end
	return l_playerPos
end

function MapCtrl:getMnMapPos(realPos)
	local l_mapPos = Vector2.New(-1, -1)
	local l_ratio = MapDataModel.MnMapRealScale / MapDataModel.MapRealScale
	l_mapPos = l_ratio * realPos
	return l_mapPos
end

function MapCtrl:getMnMapPosByRealPos(realPos)
    local l_mapPos = MoonClient.MapPerformanceOpt.GetMnMapPos(realPos)
    local playerMapPos = MoonClient.MapPerformanceOpt.GetMnMapPos(self:getPlayerPos())

    return l_mapPos - playerMapPos
end

function MapCtrl:cntMnMapRealPos()
	local mnMapRealPos = Vector2.one * -1
	local l_entity=self:getEntity()
	if MLuaCommonHelper.IsNull(l_entity) then
		logError("player is null,do not get pos")
		return mnMapRealPos
	end

	local l_ratio = MapDataModel.MnMapRealScale / MapDataModel.MapRealScale
	local l_playerPos = Vector2.New(l_entity.Position.x,l_entity.Position.z)
	local l_cgPos = l_ratio * l_playerPos
	local l_centerPos = Vector2.New(MapDataModel.MnMapRealScale * 0.5,MapDataModel.MnMapRealScale * 0.5)
	mnMapRealPos = l_centerPos - l_cgPos
	return mnMapRealPos
end

function MapCtrl:moveBigMap(playerEntity)
    if not self:activeBigMap() or MLuaCommonHelper.IsNull(playerEntity) then
        return
    end
    if self.enlargeMode then
        MoonClient.MapPerformanceOpt.MoveEnlargeBigMap(self.panel.Panel_BigPlayer, self.panel.Raw_BigMapBg,
                self.panel.Raw_BigMapObj, self.bigMapUv, self.currentScale)
    else
        MoonClient.MapPerformanceOpt.MoveBigMap(self.panel.Panel_BigPlayer, self.bigMapOffset, self.bigMapRealScale)
    end
end

function MapCtrl:addClickFx(pos)
	local l_mapEffectData = MapObjMgr:GetMapObjData()
	l_mapEffectData.spPos = pos
	l_mapEffectData.spName = "Fx_Ui_Xunlu_Mudidian001"
	l_mapEffectData.size = Vector2.New(80.0, 80.0)
	l_mapEffectData.activeBig = false
	l_mapEffectData.activeSmall = true
	l_mapEffectData.effectObj.playTime = 2.0
	self:addEffect(MapObjMgr:GetEffectId(),l_mapEffectData)
end

function MapCtrl:updateNavIcon(navIconType,pos)
	if not self:IsInited() then
		return
	end
	if navIconType==self.mgr.EUpdateNavIconType.TaskNav then
		MoonClient.MapPerformanceOpt.UpdateTaskNavIcon(pos,self.panel.Raw_MnMapBg)
	elseif navIconType==self.mgr.EUpdateNavIconType.DungeonTargetNav then
		MoonClient.MapPerformanceOpt.UpdateDungeonTargetNavIcon(pos,self.panel.Raw_MnMapBg)
	end
end
--endregion--------------------------pos相关 end---------------------

--region-----------------------weather start----------------------
function MapCtrl:freshWeatherUnit()
	local l_scId = MapDataModel.ShowSceneId
	local l_curHour = MEnvironMgr.GetCurHour()
	local l_weatherInfoUnits=self:getWeatherUnits()
	local l_showHourCount=#l_weatherInfoUnits
	local l_weatherLs=MEnvironWeatherGM.GetDurationWeatherTypeListInLua(l_scId,l_showHourCount)
	if l_weatherLs.Count==l_showHourCount then
		self.panel.Panel_Weather:SetActiveEx(true)
		for i = 0, l_showHourCount-1 do
			local l_wType=l_weatherLs[i]
			local l_rowData= TableUtil.GetEnvironmentWeatherIconTable().GetRowByWeatherType(l_wType,true)
			if MLuaCommonHelper.IsNull(l_rowData) then
				logError(StringEx.Format("have not weather type{0}",l_weatherLs[i]))
			else
				local l_hourTime= math.fmod(l_curHour+i,24)
				local l_weatherUnit=l_weatherInfoUnits[i+1]
				l_weatherUnit:SetData(
						{
							spriteName=l_rowData.IconSprite,
							hours=l_hourTime,
							isNow= i==0 and true or false,
							clickEvent=function(go,eventData)
								self:showWeatherTips(l_scId,l_wType,l_hourTime)
							end,
						})
			end
		end
	else
		self.panel.Panel_Weather:SetActiveEx(false)
	end
end

function MapCtrl:getWeatherUnits()
	if self.weatherUnits==nil then
		self.weatherUnits={}
	end
	if #self.weatherUnits>0 then
		return self.weatherUnits
	end
	for i = 1, self.showWeatherUnitCount do
		local l_weatherUnit = self:NewTemplate("WeatherUnitTemplate",{
			TemplatePrefab = self.panel.WeatherUnitTemplate.gameObject,
			TemplateParent = self.panel.Panel_Weather.Transform,
			Data = nil,
		})
		table.insert(self.weatherUnits,l_weatherUnit)
	end
	return self.weatherUnits
end

-- 获取副本词缀按钮位置
function MapCtrl:GetAffixBtnPosition()
    return self.panel.AffixBtn.transform.position
end

function MapCtrl:clearWeatherUnits()
	if self.weatherUnits==nil then
		self.weatherUnits={}
		return
	end
	for i = 1, #self.weatherUnits do
		local l_weatherUnit = self.weatherUnits[i]
		if not MLuaCommonHelper.IsNull(l_weatherUnit) then
			l_weatherUnit:Uninit()
		end
	end
	self.weatherUnits={}
end

function MapCtrl:showWeatherTips(scId,weatherType,weatherHour)
	local l_scRow = TableUtil.GetSceneTable().GetRowByID(scId)
	local l_scName = ""
	if not MLuaCommonHelper.IsNull(l_scRow) then
		l_scName = l_scRow.MiniMap
	end
	self.panel.Panel_WeatherTip:SetActiveEx(true)
	self.panel.Txt_WeatherMapName.LabText = l_scName
	if weatherHour<12 then
		self.panel.Txt_WeatherTime.LabText= StringEx.Format("{0}{1}",weatherHour,Lang("WEATHER_AM"))
	elseif weatherHour==12 then
		self.panel.Txt_WeatherTime.LabText= StringEx.Format("{0}{1}",weatherHour,Lang("WEATHER_PM"))
	else
		self.panel.Txt_WeatherTime.LabText= StringEx.Format("{0}{1}",weatherHour-12,Lang("WEATHER_PM"))
	end
	local l_rowData = TableUtil.GetEnvironmentWeatherIconTable().GetRowByWeatherType(weatherType)
	local l_weatherName= MLuaCommonHelper.IsNull(l_rowData) and "" or l_rowData.Name
	self.panel.Txt_Weather.LabText=StringEx.Format("{0}·{1}",MEnvironMgr.GetNameByPeriodType(weatherHour),l_weatherName)
	local l_periodType = MEnvironMgr.GetPeriodType(weatherHour)
	local l_owmRow = TableUtil.GetOpenWorldMapTable().GetRowByID(scId,true)
	local l_eventDescTables={}
	if not MLuaCommonHelper.IsNull(l_owmRow) then
		local l_eventId=0
		if l_periodType==MoonClient.MSceneEnvoriment.MPeriodType.Morning then
			l_eventId=l_owmRow.Morning
		elseif l_periodType==MoonClient.MSceneEnvoriment.MPeriodType.Afternoon then
			l_eventId=l_owmRow.Afternoon
		elseif l_periodType==MoonClient.MSceneEnvoriment.MPeriodType.Evening then
			l_eventId=l_owmRow.Evening
		elseif l_periodType==MoonClient.MSceneEnvoriment.MPeriodType.LateNight then
			l_eventId=l_owmRow.LateNight
		end
		local l_owmeRow= TableUtil.GetOpenWorldMapEventTable().GetRowByID(l_eventId)
		if not MLuaCommonHelper.IsNull(l_owmeRow) then
			local l_widx = weatherType
			if l_widx < l_owmeRow.MapEventDesc.Length then
				local eventDesc=l_owmeRow.MapEventDesc[l_widx]
				for i = 0, eventDesc.Length-1 do
					local l_descRow =TableUtil.GetOpenWorldMapEventDescTable().GetRowByID(eventDesc[i])
					if not MLuaCommonHelper.IsNull(l_descRow) then
						table.insert(l_eventDescTables,l_descRow.EventDesc)
					end
				end
			end
		end
	end
	local l_eventDescCount=#l_eventDescTables
	local l_weatherTipComs = self:getOrCreateWeatherTips(l_eventDescCount)
	local l_tipCount=#l_weatherTipComs
	if l_eventDescCount<=l_tipCount then
		for i = 1, l_eventDescCount do
			local l_weatherTip=l_weatherTipComs[i]
			l_weatherTip.LabText=l_eventDescTables[i]
			l_weatherTip:SetActiveEx(true)
		end
		for i = l_eventDescCount+1, l_tipCount do
			local l_weatherTip=l_weatherTipComs[i]
			l_weatherTip:SetActiveEx(false)
		end
	end
end

function MapCtrl:getOrCreateWeatherTips(tipCount)
	if self.weatherTipTables==nil then
		self.weatherTipTables={}
	end
	if #self.weatherTipTables>=tipCount then
		return self.weatherTipTables
	end
	for i = #self.weatherTipTables, tipCount do
		local l_weatherTipObj=self:CloneObj(self.panel.Txt_WeatherEvt.UObj)
		local l_weatherTipCom=l_weatherTipObj.transform:GetComponent("MLuaUICom")
		l_weatherTipCom.Transform:SetParent(self.panel.Panel_WeatherTip.Transform)
		l_weatherTipCom.Transform.localScale=Vector3.one
		table.insert(self.weatherTipTables,l_weatherTipObj.transform:GetComponent("MLuaUICom"))
	end
	return self.weatherTipTables
end

function MapCtrl:showWeatherTemperatureTipsPanel(isShow)
	self.panel.Panel_WeatherTemperatureInfoTips.UObj:SetActive(isShow);
	if isShow then
		self.lastOpenWeatherTemperaTipsPanelFrame = Time.frameCount
		self.panel.Bg_MapNameWeather.Listener.onUp = nil
		self.panel.Obj_EventInfoList.Listener.onClick = function(go, eventData)
			self:onOpenSceneWorldInfoPanel(go, eventData)
		end
	else
		self.panel.Bg_MapNameWeather.Listener.onUp =function(go, eventData)
			self:onOpenWeatherTemperatureTips(go, eventData)
		end
		self.panel.Obj_EventInfoList.Listener.onClick = nil
	end
	self:updateWeatherTemperatureInfoTipsPanel()
end

function MapCtrl:updateWeatherTemperatureInfoTipsPanel()
	if not self:isOpenWeatherTemperatureInfoTipsPanel() then return end
	if not MScene.EnvironmentMgr:IsHasDayData() then
		logWarn("当前场景未配置天气 场景ID:"..tostring(MScene.singleton.SceneID))
		return
	end
	self:initWeatherTemperatureInfoTipsPanel()
	self:updateWeatherTypeChangeTips()
	self:updateTemperatureRangeChangeTips()
	self:updateTemperatureChangeTips()
	self:updateEventInfo()
end

function MapCtrl:getIconSpriteByWeatherType(weatherType)
	local l_rowData = TableUtil.GetEnvironmentWeatherIconTable().GetRowByWeatherType(weatherType)
	if not MLuaCommonHelper.IsNull(l_rowData) then
		return l_rowData.IconSprite
	else
		logError("EnvironmentWeatherIconTable don't exist data weatherType:{0}", weatherType)
		return
	end
end

function MapCtrl:updateWeatherTypeChangeTips()
	if not self:isOpenWeatherTemperatureInfoTipsPanel() then return end
	local l_weatherType = MEnvironWeatherGM.GetWeatherType()
	if l_weatherType == MoonClient.MSceneEnvoriment.MWeatherType.None then
		logError("weatherType is none don't should update WeatherTypeChangeTips")
		return
	end
	local l_weatherTypeValue = Common.CommonUIFunc.ChangeEnumValueToNumber(l_weatherType)
	local l_curIconSprite = self:getIconSpriteByWeatherType(l_weatherTypeValue)
	self.panel.Img_WeatherTemperatureInfoTipsIcon:SetSprite("main", l_curIconSprite)
	local l_curSceneID = MScene.SceneID
	local l_durationHour = 2
	local l_listWeatherType=MEnvironWeatherGM.GetDurationWeatherTypeListInLua(l_curSceneID,l_durationHour)
	if l_listWeatherType.Count == l_durationHour then
		local l_nextHourWeatherType = l_listWeatherType[1]
		local l_nextHourIconSprite = self:getIconSpriteByWeatherType(l_nextHourWeatherType)
		self.panel.Img_NextWeatherTemperatureInfoTipsIcon:SetSprite("main", l_nextHourIconSprite)
	end
	self.panel.Txt_CurTimeInfoTxt.LabText = MEnvironMgr.GetHourDisplay()
	self.panel.Txt_NextTimeInfo.LabText = MEnvironMgr.GetHourDisplay(1)
	local l_curPeriodTypeName = MEnvironWeatherGM.GetCurPeriodTypeName()
	local l_curWeatherTypeName = MEnvironWeatherGM.GetCurWeatherTypeName()
	self.panel.Txt_WeatherTemperatureInfoTipsType.LabText = StringEx.Format("{0}·{1}", l_curPeriodTypeName, l_curWeatherTypeName)
end

function MapCtrl:getSceneColdTemperature()
	return MGlobalConfig.sceneDefaultColdTemperature
end

function MapCtrl:getSceneHotTemperature()
	return MGlobalConfig.sceneDefaultHotTemperature
end

function MapCtrl:updateTemperatureRangeChangeTips()
	if not self:isOpenWeatherTemperatureInfoTipsPanel() then return end
	local l_curTemperature = MEnvironWeatherGM.CurTemperature
	local l_coldTemperature = self:getSceneColdTemperature()
	local l_hotTemperature = self:getSceneHotTemperature()
	local l_state = null
	local l_stateTextColor
	if l_curTemperature < l_coldTemperature then
		l_state = Lang("TEMPERATURE_COLD")
		l_stateTextColor = self.Cold_Color
	elseif l_curTemperature > l_hotTemperature then
		l_state =  Lang("TEMPERATURE_HOT")
		l_stateTextColor = self.Hot_Color
	else
		l_state = Lang("TEMPERATURE_COMFORTABLE")
		l_stateTextColor = self.Comfortable_Color
	end
	self.panel.Txt_WeatherTemperatureInfoTipsState.LabText = l_state
	self.panel.Txt_WeatherTemperatureInfoTipsState.LabColor = l_stateTextColor
end

function MapCtrl:updateTemperatureChangeTips()
	local l_curTemperatureStateName = MEnvironWeatherGM.GetCurTemperatureStateName()
	self.panel.Txt_WeatherTemperatureInfoTipsRange.LabText = Lang("TEMPERATURE_CUR_TEMP") .. l_curTemperatureStateName
end

function MapCtrl:getOrCreateEventInfoObj()
	if self.eventInfoTables==nil then
		self.eventInfoTables={}
	end
	local l_weatherEventInfoCount=3
	if #self.eventInfoTables>=l_weatherEventInfoCount then
		return self.eventInfoTables
	end
	for i = #self.eventInfoTables+1, l_weatherEventInfoCount do
		local l_eventTemplate = self:NewTemplate("MapEventInfoTemplate",{
			TemplatePrefab = self.panel.MapEventInfoTemplate.gameObject,
			TemplateParent = self.panel.Obj_EventInfoList.Transform,
			Data = nil,
		})
		table.insert(self.eventInfoTables,l_eventTemplate)
	end
	return self.eventInfoTables
end

function MapCtrl:updateEventInfo()
	local l_eventIds= MgrMgr:GetMgr("WorldMapInfoMgr").GetSceneInfluence(MScene.SceneID)
	local l_eventInfoTems=self:getOrCreateEventInfoObj()
	local l_eventCount=#l_eventIds
	for i = 1, #l_eventInfoTems do
		local l_eventInfoTem=l_eventInfoTems[i]
		if i<=l_eventCount then
			local l_eventId=l_eventIds[i]
			local l_eventRow= TableUtil.GetOpenWorldInfluenceTable().GetRowByID(l_eventId)
			if not MLuaCommonHelper.IsNull(l_eventRow) then
				l_eventInfoTem:SetData({
					desc=l_eventRow.DescShort,
					atlas=l_eventRow.Atlas,
					icon=l_eventRow.Icon,
				})
			end
			l_eventInfoTem:SetGameObjectActive(true)
		else
			l_eventInfoTem:SetGameObjectActive(false)
		end
	end
	if l_eventCount > 0 then
		self.panel.Obj_EventInfoList.UObj:SetActiveEx(true)
		self.panel.Txt_WeatherTemperatureInfoTipsDesc.UObj:SetActiveEx(false)
	else
		self.panel.Txt_WeatherTemperatureInfoTipsDesc.UObj:SetActiveEx(true)
		self.panel.Obj_EventInfoList.UObj:SetActiveEx(false)
	end
end

function MapCtrl:applyWeather()
	if not self:IsInited() then
		return
	end
	local l_weatherType = MEnvironWeatherGM.GetWeatherType()
	local l_isShowWeatherAndTemperature = l_weatherType ~= MoonClient.MSceneEnvoriment.MWeatherType.None
	self.panel.Bg_MapNameNoWeather.UObj:SetActiveEx(not l_isShowWeatherAndTemperature)
	self.panel.Bg_MapNameWeather.UObj:SetActiveEx(l_isShowWeatherAndTemperature)
	local l_rectTransform = self.panel.Txt_MnMapName.RectTransform
	if l_isShowWeatherAndTemperature then
		l_rectTransform.sizeDelta = Vector2.New(224, 44)
		l_rectTransform.anchoredPosition3D = Vector3.New(-27, -20.1, 0)
		local l_weatherTypeValue = Common.CommonUIFunc.ChangeEnumValueToNumber(l_weatherType)
		local l_rowData = TableUtil.GetEnvironmentWeatherIconTable().GetRowByWeatherType(l_weatherTypeValue)
		if not MLuaCommonHelper.IsNull(l_rowData) then
			self.panel.Img_SceneWeatherIcon:SetSprite("main", l_rowData.IconSprite)
		end
		self:applyTemperaturePointer()
	else
		l_rectTransform.sizeDelta = Vector2.New(224, 44)
		l_rectTransform.localPosition = Vector3.New(-25, -20.1, 0)
	end
end

function MapCtrl:applyTemperatureSlider()
	local l_coldTemperature =self:getSceneColdTemperature()
	local l_hotTemperature = self:getSceneHotTemperature()
	local l_defaultTemperature = MGlobalConfig.sceneDefaultOriginTemperature

	local l_coldFillAmount = Mathf.InverseLerp(0, l_defaultTemperature, l_coldTemperature) * 0.8 + 0.2
	self.panel.Slider_SceneTemperatureCold.Img.fillAmount = l_coldFillAmount

	local l_hotFillAmount = Mathf.InverseLerp(20, l_defaultTemperature, l_hotTemperature) * 0.8 + 0.2
	self.panel.Slider_SceneTemperatureHot.Img.fillAmount = l_hotFillAmount
end

function MapCtrl:applyTemperaturePointer()
	local l_curTemperature = MEnvironWeatherGM.CurTemperature
	local l_angle = Mathf.Lerp(40, 320, l_curTemperature * 0.05)

	self.panel.Img_SceneTemperaturePointer.Transform.rotation = Quaternion.AngleAxis(l_angle, Vector3.back)
end

function MapCtrl:initWeatherTemperature()
	self.panel.Bg_MapNameWeather.Listener.onUp = function(go, eventData)
		self:onOpenWeatherTemperatureTips(go, eventData)
	end
	self.lastOpenWeatherTemperaTipsPanelFrame = -1
end

function MapCtrl:uninitWeatherTemperature()
	self.panel.Bg_MapNameWeather.Listener.onUp = null
end

function MapCtrl:initWeatherTemperatureInfoTipsPanel()
	if self.isInitWeatherTemperatureInfoTipsPanel then
		return
	end
	self.isInitWeatherTemperatureInfoTipsPanel = true
	self.panel.Txt_WeatherTemperatureInfoTipsDesc.LabText = Lang("TEMPERATURE_INSTRUCTION")
	self.panel.Txt_WeatherTemperatureInfoTipsStateTitle.LabText = Lang("TEMPERATURE_CUR_BODY_TEMP")
end

function MapCtrl:uninitWeatherTemperatureInfoTipsPanel()
	if self.isInitWeatherTemperatureInfoTipsPanel then
		self:showWeatherTemperatureTipsPanel(false)
	end
end

function MapCtrl:isOpenWeatherTemperatureInfoTipsPanel()
	if self:IsInited() and self.panel.Panel_WeatherTemperatureInfoTips.isActiveAndEnabled then
		return true
	end
	return false
end

function MapCtrl:updateWeatherTemperatureTipsState()
	if not self:isOpenWeatherTemperatureInfoTipsPanel()
			or Time.frameCount <= self.lastOpenWeatherTemperaTipsPanelFrame then
		return
	end
	if MoonClient.MRaycastTouchUtils.IsNoTouched(self.panel.Img_WeatherTemperatureInfoTipsBG.UObj,false) then
		self:showWeatherTemperatureTipsPanel(false)
	end
end
--endregion-----------------------weather end------------------------

--lua custom scripts end

return MapCtrl