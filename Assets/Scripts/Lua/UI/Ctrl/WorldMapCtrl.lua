--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/WorldMapPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
WorldMapCtrl = class("WorldMapCtrl", super)
--lua class define end

--lua functions
function WorldMapCtrl:ctor()
	super.ctor(self, CtrlNames.WorldMap, UILayer.Function, nil, ActiveType.Exclusive)
	--self.IgnoreHidePanelNames = { CtrlNames.Map }

	self.IsGroup=true

	self.isFullScreen=true
end --func end
--next--
function WorldMapCtrl:Init()
	self.panel = UI.WorldMapPanel.Bind(self)
	super.Init(self)

	self:initBaseInfo()
	self:initUIElement()
end --func end
--next--
function WorldMapCtrl:Uninit()
	super.Uninit(self)

	self.sceneIdWorldInfoBtnDic={}
	self.sceneIdMapBtnDic={}
	self.sceneIdEvtInfoDic={}
	self.panel = nil
end --func end
--next--
function WorldMapCtrl:OnActive()
	MTransferMgr.IsActiveWorldMap = true
	MgrMgr:GetMgr("MapInfoMgr").ShowMapPanel(false)
	if not self:IsInited() then
		return
	end
	self:showCave(false)
	self:showWorldInfo(true)
	self:showNowMap()
	self:freshMapArrived()
	self:showWorldEvt(true)
	self:freshWorldEvt()
end --func end
--next--
function WorldMapCtrl:OnDeActive()
	MTransferMgr.IsActiveWorldMap = false
	if not MLuaCommonHelper.IsNull(self.imgLightSlt) then
		MResLoader:DestroyObj(self.imgLightSlt)
		self.imgLightSlt = nil
	end
	MgrMgr:GetMgr("MapInfoMgr").ShowMapPanel(true)
end --func end
--next--
function WorldMapCtrl:Update()


end --func end
--next--
function WorldMapCtrl:BindEvents()
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.WorldEventUpdate, function(_,...)
		self:freshWorldEvt()
	end)
end --func end
--next--
--lua functions end

--lua custom scripts
function WorldMapCtrl:initBaseInfo()

	self.eventWarningTime1= MGlobalConfig:GetInt("EventWarningTime1")
	self.eventWarningTime2= MGlobalConfig:GetInt("EventWarningTime2")
	self.mgr=MgrMgr:GetMgr("WorldMapInfoMgr")
	self.imgLightSlt = nil
	self.sceneIdMapBtnDic = {}
	self.sceneIdWorldInfoBtnDic = {}
	self.sceneIdEvtInfoDic={}
end
function WorldMapCtrl:getMLuaUICom(go)
	if MLuaCommonHelper.IsNull(go) then
		logError("getMLuaUICom go isNull！")
		return
	end
	local l_mluaCom=go:GetComponent("MLuaUICom")
	if MLuaCommonHelper.IsNull(l_mluaCom) then
	 l_mluaCom=go:AddComponent(System.Type.GetType("MoonClient.MLuaUICom, MoonClient"))
	end
	return l_mluaCom
end
function WorldMapCtrl:initBtnMap(mapGo)
	if MLuaCommonHelper.IsNull(mapGo) then
		return
	end
	local l_btnName = mapGo.name
	local l_btnCom = self:getMLuaUICom(mapGo)
	if MLuaCommonHelper.IsNull(l_btnCom) then
		return
	end
	if MGameContext.IsOpenGM then  --debug模式显示场景ID
		local l_txt = mapGo.transform:GetComponentInChildren(System.Type.GetType("UnityEngine.UI.Text, UnityEngine.UI"))
		if MLuaCommonHelper.IsNull(l_txt) then
			local l_txtObj = self:CloneObj(self.panel.Template_SceneID.UObj)
			l_txtObj:SetActiveEx(true)
			l_txtObj.name = "SceneID"
			l_txt = l_txtObj:GetComponent("Text")
			local l_txtTran = l_txtObj.transform
			l_txtTran:SetParent(mapGo.transform)
			l_txtTran.localPosition = Vector3.zero
			l_txtTran.localScale = Vector3.one
			local l_mapGoRect= mapGo:GetComponent("RectTransform")
			l_txt.rectTransform.sizeDelta = l_mapGoRect.sizeDelta
		end
		l_txt.text = l_btnName
	end
	local l_toSceneId = tonumber(l_btnName)
 	l_btnCom:AddClick(function()
		local l_mapRow = TableUtil.GetMapTable().GetRowBySceneId(l_toSceneId,true)
		if MLuaCommonHelper.IsNull(l_mapRow) or (not l_mapRow.IsOpen) then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_SCENE"))
			return
		end

		MTransferMgr.WorldMapSelectId = l_toSceneId
		MTransferMgr:AddMapObj(l_toSceneId)
		if MLuaCommonHelper.IsNull(self.imgLightSlt) then
			self.imgLightSlt = self:CloneObj(self.panel.Img_SltLight.UObj)
		end
		self.panel.Img_SltLight.Transform:SetParent(l_btnCom.Transform)
		self.panel.Img_SltLight.Transform.localScale = Vector3.one
		self.panel.Img_SltLight.Transform.localPosition = Vector3.zero
		self.panel.Img_SltLight.UObj:SetActiveEx(true)
		self.panel.Img_SltLight.Transform:SetAsFirstSibling()

	end,true)
	if MLuaCommonHelper.IsNull(self.sceneIdMapBtnDic[l_toSceneId]) then
		self.sceneIdMapBtnDic[l_toSceneId] = l_btnCom
		local l_eventTem = self:NewTemplate("WorldMapTemplate",{
			IsActive = false,
			IsUsePool = true,
			TemplatePrefab = self.panel.Panel_EvtInfo.gameObject,
			TemplateParent = self.panel.Panel_EvtInfo.transform.parent,
			LoadCallback = function(tem)
				tem:transform().position = l_btnCom.Transform.position
				tem:transform().localScale = self.panel.Panel_EvtInfo.transform.localScale
			end
		})
		self.sceneIdEvtInfoDic[l_toSceneId] = l_eventTem
	end
end
function WorldMapCtrl:initUIElement()
	self.panel.Btn_Close:AddClick(function()
		self.mgr.HideWorldMap()
	end)
	self.panel.Panel_EvtInfo.gameObject:SetActiveEx(false)
	for i = 0, self.panel.Panel_BtnMaps.Transform.childCount-1 do
		local l_mapGo = self.panel.Panel_BtnMaps.Transform:GetChild(i).gameObject
		self:initBtnMap(l_mapGo)
	end
	self.panel.Btn_CaveOFF:AddClick(function()
		self:showCave(false)
	end,true)
	self.panel.Btn_ShowCave:AddClick(function()
		self:showCave(true)
	end,true)
	self.panel.Btn_HideWorldInfo:AddClick(function()
		self:showWorldInfo(false)
	end,true)
	self.panel.Btn_ShowWorldInfo:AddClick(function()
		self:showWorldInfo(true)
	end,true)
	self.panel.Btn_EvtOn:AddClick(function()
		self:showWorldEvt(true)
	end,true)
	self.panel.Btn_EvtOFF:AddClick(function()
		self:showWorldEvt(false)
	end,true)
end
function WorldMapCtrl:showNowMap()
	self.panel.Img_NowMap.Img.enabled = false
    local l_hasData,l_belongId=MTransferMgr.belongScene:TryGetValue(MScene.SceneID, nil)
	if not l_hasData then
	 l_belongId = MScene.SceneID
	end
	for i = 0, self.panel.Panel_BtnMaps.Transform.childCount-1 do
		local l_trans =self.panel.Panel_BtnMaps.transform:GetChild(i)
		local l_sceneId =tonumber(l_trans.name)
		if l_sceneId== l_belongId then
			self.panel.Img_NowMap.Transform.position = l_trans.position
			self.panel.Img_NowMap.Img.enabled = true
			break
		end
	end
end
function WorldMapCtrl:freshMapArrived()
	if not self:IsInited() then
		return
	end
	local l_trans = self.panel.Panel_MapMask.Transform
	local l_childCount = l_trans.childCount
	for i = 0,  l_childCount-1 do
		local l_child = l_trans:GetChild(i)
		local l_sceneId=tonumber(l_child.name)
		local l_isArrived = self.mgr.IsArrived(l_sceneId)
		if l_isArrived then
		 l_child.gameObject:SetActiveEx(false)
		else
		 l_child.gameObject:SetActiveEx(true)
		end
	end
end
function WorldMapCtrl:showWorldEvt(isShow)
	self.panel.Btn_EvtOFF:SetActiveEx(isShow)
	self.panel.Btn_EvtOn:SetActiveEx(not isShow)
	if isShow then
		self:freshWorldEvt()
	else
		for k,v in pairs(self.sceneIdEvtInfoDic) do
			v:SetGameObjectActive(false)
		end
	end
end
function WorldMapCtrl:freshWorldEvt()
	for k,v in pairs(self.sceneIdEvtInfoDic) do
		v:SetData({
			sceneID = k,
			eventWarningTime1= self.eventWarningTime1,
			eventWarningTime2= self.eventWarningTime2
		})
	end
end
function WorldMapCtrl:showWorldInfo(isShow)
	if not self:IsInited() then
		return
	end
	self.panel.Btn_ShowWorldInfo:SetActiveEx(not isShow)
	self.panel.Btn_HideWorldInfo:SetActiveEx(isShow)
	self.panel.Panel_WorldInfo:SetActiveEx(isShow)
end
function WorldMapCtrl:showCave(isShow)
	if not self:IsInited() then
		return
	end
	self.panel.Btn_ShowCave:SetActiveEx(not isShow)
	self.panel.Btn_CaveOFF:SetActiveEx(isShow)
	self.panel.Panel_CaveInfo:SetActiveEx(isShow)
	if isShow then
		local l_trs = self.panel.Panel_CaveInfo.Transform
		local l_childNum= l_trs.childCount
		for i = 0 ,l_childNum-1 do
			MLuaClientHelper.PlayFxHelper(l_trs:GetChild(i).gameObject)
		end
	end
end

--lua custom scripts end
return WorldMapCtrl