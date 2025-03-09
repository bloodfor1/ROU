--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LoadingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
LoadingCtrl = class("LoadingCtrl", super)
--lua class define end

--lua functions
function LoadingCtrl:ctor()

	super.ctor(self, CtrlNames.Loading, UILayer.Top, nil, ActiveType.Standalone)
    self.mgr = MgrMgr:GetMgr("LoadingMgr")
	self.isFullScreen = true
	self.cacheGrade = EUICacheLv.VeryLow
	self.loadingSceneRow = nil
	self.loadingBGIdx = 0
	self.bg1Loaded = false
	self.bg2Loaded = false

end --func end
--next--
function LoadingCtrl:Init()

	math.randomseed(Common.TimeMgr.GetUtcTimeByTimeTable())
	self.panel = UI.LoadingPanel.Bind(self)
	super.Init(self)
	self.panel.LoadingAnim:SetActiveEx(false)
end --func end
--next--
function LoadingCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function LoadingCtrl:OnActive()
	self.loadingSceneId = self.uiPanelData
	self.loadingBGIdx = self.mgr.GetLoadingBGIdx()

	local l_showError = MStageMgr.IsSwitchingScene
	if self.loadingSceneId < 0 and l_showError then
		logError("invalid loading sceneId ", self.loadingSceneId)
	end
	self.loadingSceneRow = TableUtil.GetSceneTable().GetRowByID(self.loadingSceneId, not l_showError)

	MgrMgr:GetMgr("SceneEnterMgr").CurrentTeleportType = MTransferMgr.CurrentTeleportType
	self.panel.LoadingAnim:SetActiveEx(true)
	self.panel.TxtLoad.LabText = "0%"
	if self.loadingSceneRow ~= nil then

		if MTransferMgr.CurrentTeleportType == KKSG.TeleportType.KTeleportPointTypeKapula then
			self:ShowWorldMap()
		else
			self.panel.WorldMapDetails.gameObject:SetActiveEx(false)
		end

		local l_loadingTips = self.loadingSceneRow.LoadingTips
		if l_loadingTips ~= nil and l_loadingTips.Length > 0 then
			local l_currentTips = {}
		    local l_tableData = TableUtil.GetTipsTable().GetTable()
		    for i,row in ipairs(l_tableData) do
		    	local l_typeContains = false
		    	for j=0,l_loadingTips.Length - 1 do
		    		if l_loadingTips[j] == row.TipsType then
		    			l_typeContains = true
		    			break
		    		end
		    	end
		    	if l_typeContains then
		    		local l_limit = row.LevelLimit
			        local l_min = l_limit:get_Item(0)
			        local l_max = l_limit:get_Item(1)
			        if MPlayerInfo.Lv >= l_min and MPlayerInfo.Lv <= l_max then
			            table.insert(l_currentTips, row.TipsContent)
			        end
		    	end
		    end

			local l_tipsId = math.random(1, #l_currentTips)
			self.panel.TxtTips.LabText = tostring(l_currentTips[l_tipsId])
		end
	end

    local l_picName1 = "PrefabBg/RO_Map_BG1.png"
    local l_picName2 = "PrefabBg/RO_Map_BG2.png"
    if MTransferMgr.CurrentTeleportType ~= KKSG.TeleportType.KTeleportPointTypeKapula and self.loadingSceneRow then
        l_picName1 = "PrefabBg/"..self.loadingSceneRow.LoadingPic[self.loadingBGIdx].."_L.png"
        l_picName2 = "PrefabBg/"..self.loadingSceneRow.LoadingPic[self.loadingBGIdx].."_R.png"
    end
    self.panel.RImgBg1:SetRawTexAsync(l_picName1)
    self.panel.RImgBg2:SetRawTexAsync(l_picName2)

    MAudioMgr:PlayBGM("event:/BGM/BGM_Loading")
end --func end
--next--
function LoadingCtrl:OnDeActive()

	self.panel.LoadingAnim:SetActiveEx(false)
	self.panel.RImgBg1:SetRawTex(nil)
	self.panel.RImgBg2:SetRawTex(nil)

	self.loadingSceneId = 0
	self.loadingSceneRow = nil
	self.bg1Loaded = false
	self.bg2Loaded = false

end --func end
--next--
function LoadingCtrl:Update()


end --func end

--next--
function LoadingCtrl:BindEvents()

	local l_mgr = MgrMgr:GetMgr("SceneEnterMgr")
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.LoadingProgress, function (self,percent)
		self.panel.TxtLoad.LabText = StringEx.Format("{0:F0}", percent).."%"
	end)

end --func end
--next--
--lua functions end

--lua custom scripts
function LoadingCtrl:ShowWorldMap()
	self.panel.WorldMapDetails.gameObject:SetActiveEx(true)
	local currentMapItem=self:getWorldMapItem(MScene.SceneID)
	local targetMapItem=self:getWorldMapItem(self.loadingSceneId)
	if targetMapItem==nil or currentMapItem==nil then
		self.panel.Mine.gameObject:SetActiveEx(false)
		self.panel.Selected.gameObject:SetActiveEx(false)
		self.panel.Path.gameObject:SetActiveEx(false)
		return
	end
	self.panel.Mine.gameObject:SetActiveEx(true)
	self.panel.Selected.gameObject:SetActiveEx(true)
	self.panel.Path.gameObject:SetActiveEx(true)
	self.panel.Mine.transform.anchoredPosition=currentMapItem.anchoredPosition
	self.panel.Selected.transform.anchoredPosition=targetMapItem.anchoredPosition
	self.panel.Path:GetComponent("MShowPathNode"):ShowPath()
end

function LoadingCtrl:getWorldMapItem(sceneID)
	local mapItem= self.panel.WorldMapDetails.transform:Find("Map/"..tostring(sceneID))
	return mapItem
end

--lua custom scripts end
return LoadingCtrl