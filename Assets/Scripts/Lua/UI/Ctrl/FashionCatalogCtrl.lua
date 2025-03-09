--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FashionCatalogPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
FashionHistoryLen = 10
FashionCatalogCtrl = class("FashionCatalogCtrl", super)
--lua class define end

--lua functions
function FashionCatalogCtrl:ctor()

	super.ctor(self, CtrlNames.FashionCatalog, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function FashionCatalogCtrl:Init()

	self.panel = UI.FashionCatalogPanel.Bind(self)
	super.Init(self)

	---@type ModuleMgr.FashionRatingMgr
	self.mgr = MgrMgr:GetMgr("FashionRatingMgr")
	---@type FashionData
	self.data = DataMgr:GetData("FashionData")
	self.scrollRect = self.panel.RingScrollView.gameObject:GetComponent("MoonClient.MRingScrollRect")
	self.isDragging = false
	self.nowIndex = 1

	self.buttonList = {}
	self.PlayerModel = {}

	self.panel.CloseBtn:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.FashionCatalog)
	end)
	self.panel.FashionCloseBtn:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.FashionCatalog)
	end)
	self.panel.None.gameObject:SetActiveEx(false)

end --func end
--next--
function FashionCatalogCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
	if self.scrollRect then
		self.scrollRect.OnStartDrag=nil
		self.scrollRect.OnEndDrag=nil
		self.scrollRect.OnItemIndexChanged=nil
		self.scrollRect.onInitItem=nil
		self.scrollRect=nil
	end
	self.isDragging = nil
	self.nowIndex = nil

	self.buttonList = nil
	for i = 1, FashionHistoryLen do
		if self.PlayerModel[i] then
			self:DestroyUIModel(self.PlayerModel[i])
			self.PlayerModel[i] = nil
		end
	end

end --func end
--next--
function FashionCatalogCtrl:OnActive()

	if self.uiPanelData then
		if self.uiPanelData == self.data.EUIOpenType.SHOW then
			self.panel.FashionShow.gameObject:SetActiveEx(true)
			self.panel.FashionHistory.gameObject:SetActiveEx(false)
		end
		if self.uiPanelData == self.data.EUIOpenType.HISTORY then
			self.panel.FashionShow.gameObject:SetActiveEx(false)
			self.panel.FashionHistory.gameObject:SetActiveEx(true)
			self.mgr.RequestFashionHistory()
		end
	end


end --func end
--next--
function FashionCatalogCtrl:OnDeActive()


end --func end
--next--
function FashionCatalogCtrl:Update()


end --func end
--next--
function FashionCatalogCtrl:BindEvents()

	self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.HistoryData, self.GetHistory)

end --func end
--next--
--lua functions end

--lua custom scripts
function FashionCatalogCtrl:ShowModel(mainData, model, i, objData)

	if not self.panel then
		return
	end
	objData = objData and mainData
	if self.PlayerModel[i] and not objData then
		self:DestroyUIModel(self.PlayerModel[i])
		self.PlayerModel[i] = nil
		model:SetActiveEx(false)
	end

	if not self.PlayerModel[i] and objData then
		local l_attr = MgrMgr:GetMgr("PlayerInfoMgr").GetAttribData(mainData)
		local l_pos, l_scale, l_rotation = mainData:GetPSR()  --拍照时玩家的坐标 缩放 旋转获取
		if not l_pos then
			l_pos = {x = 0, y = -1.51, z = -0.17}
			l_scale = {x = 1.9, y = 1.9, z = 1.9}
			l_rotation = {x = -10.295, y = 180, z = 0}
		end
		local l_vMat, l_pMat = mainData:GetMatData()  --拍照时相机的观察矩阵和投影矩阵获取
		local l_fxData = {}
		l_fxData.rawImage = model.RawImg
		l_fxData.attr = l_attr
		l_fxData.useShadow = false
		l_fxData.useOutLine = false
		l_fxData.useCustomLight = true
		l_fxData.isOneFrame = true
		if l_pMat and l_vMat then
			l_fxData.isCameraMatrixCustom = true
			l_fxData.vMatrix = l_vMat
			l_fxData.pMatrix = l_pMat
			local l_rotEul = MUIModelManagerEx:GetRotationEulerByViewMatrix(l_vMat)
			l_fxData.customLightDirX = 0
			l_fxData.customLightDirY = l_rotEul.y - 180
			l_fxData.customLightDirZ = 0
		end
		l_fxData.position = Vector3.New(l_pos.x, l_pos.y, l_pos.z)
		l_fxData.scale = Vector3.New(l_scale.x, l_scale.y, l_scale.z)
		l_fxData.rotation = Quaternion.Euler(l_rotation.x, l_rotation.y, l_rotation.z)

		model:SetActiveEx(false)
		self.PlayerModel[i] = self:CreateUIModel(l_fxData)
		

		local l_animKey, l_animPath, l_animTime = mainData:GetAnimInfo()
		l_animKey = l_animKey or "Idle"
		l_animPath = l_animPath or l_attr.CommonIdleAnimPath
		l_animTime = l_animTime or 0
		self.PlayerModel[i].Ator:OverrideAnim(l_animKey, l_animPath)
		self.PlayerModel[i].Ator:Play(l_animKey, l_animTime)
		self.PlayerModel[i].Ator.Speed = 0

		local l_emotion1, l_emotion2 = mainData:GetEmotion()
		if l_emotion1 and l_emotion2 then
			self.PlayerModel[i]:ChangeEmotion(l_emotion1, l_emotion2, 999999)
		end

		self.PlayerModel[i]:AddLoadModelCallback(function(m)
			model:SetActiveEx(true)
		end)
	end

end

function FashionCatalogCtrl:MagazineInit(go, index)

	go = go.transform:Find("Panel_Main")
	local l_themeNum = go.transform:Find("Txt_Theme")
	local l_themeName = go.transform:Find("Txt_Name")
	local l_button = go.transform:Find("BlackDot")
	local l_pInfo = go.transform:Find("Panel_PlayerInfo")
	l_themeNum:GetComponent("MLuaUICom").LabText = tostring(self.data.History[index].round)
	local l_themeRow = TableUtil.GetFashionThemeTable().GetRowByID(self.data.History[index].theme, true)
	l_themeName:GetComponent("MLuaUICom").LabText = l_themeRow.Name
	l_button:GetComponent("MLuaUICom").Img.material = nil
	l_button:GetComponent("MLuaUICom").Img.color = RoColor.Hex2Color("00000030")
	if index == 1 then
		l_button:GetComponent("MLuaUICom").Img.color = RoColor.Hex2Color("00000000")
	end
	self.buttonList[index] = l_button:GetComponent("MLuaUICom")

	local l_Name = l_pInfo.transform:Find("Txt_Name")
	local l_Job = l_pInfo.transform:Find("Txt_Job")
	--local l_Rank = l_pInfo.transform:Find("Txt_Rank")		--一定是第一名
	local l_Score = l_pInfo.transform:Find("Txt_Score")
	local l_Point = l_pInfo.transform:Find("Txt_Point")
	local l_model = l_pInfo.transform:Find("Model")

	local l_scoreData = self.data.History[index].fashion_score_data
	if l_scoreData.role_id ~= 0 then
		l_Job:GetComponent("MLuaUICom").LabText = tostring(
			DataMgr:GetData("TeamData").GetProfessionNameById(l_scoreData.roleType))
		l_Point:GetComponent("MLuaUICom").LabText = l_scoreData.outlook.fashion_count
		l_Name:GetComponent("MLuaUICom").LabText = tostring(l_scoreData.name)
		l_Score:GetComponent("MLuaUICom").LabText = Lang("Fashion_Point", l_scoreData.score)
		self:ShowModel(l_scoreData, l_model:GetComponent("MLuaUICom"), index, true)
	else
		l_Job:GetComponent("MLuaUICom").LabText = ""
		l_Point:GetComponent("MLuaUICom").LabText = ""
		l_Name:GetComponent("MLuaUICom").LabText = ""
		l_Score:GetComponent("MLuaUICom").LabText = ""
		self:ShowModel(l_scoreData, l_model:GetComponent("MLuaUICom"), index, false)
	end

end

function FashionCatalogCtrl:GetHistory()

	self.scrollRect.OnStartDrag = function()
		self.isDragging = true
	end
	self.scrollRect.OnEndDrag = function()
		self.isDragging = false
	end
	self.panel.ChooseOn[1].gameObject:SetActiveEx(true)
	self.scrollRect.OnItemIndexChanged = function()
		if self.scrollRect ~= nil then
			for i = 1, FashionHistoryLen, 1 do
				self.panel.ChooseOn[i].gameObject:SetActiveEx(false)
			end
			for i = 1, #self.buttonList do
				if math.abs(i - self.scrollRect.CurItemIndex - 1) == 0 then
					self.buttonList[i].Img.color = RoColor.Hex2Color("00000000")
				elseif math.abs(i - self.scrollRect.CurItemIndex - 1) == 1 then
					self.buttonList[i].Img.color = RoColor.Hex2Color("00000030")
				else
					self.buttonList[i].Img.color = RoColor.Hex2Color("00000050")
				end
			end
			self.nowIndex = self.scrollRect.CurItemIndex + 1
			self.panel.ChooseOn[self.scrollRect.CurItemIndex + 1].gameObject:SetActiveEx(true)
		end
	end
	self.scrollRect.onInitItem = function(go, index)
		self:MagazineInit(go, index + 1)
	end
	local l_maCount = #self.data.History
	for i = 1, FashionHistoryLen, 1 do
		self.panel.ChooseNote[i].gameObject:SetActiveEx(i <= l_maCount)
	end

	if l_maCount == 0 then
		self.panel.FashionMain.gameObject:SetActiveEx(false)
		self.panel.None.gameObject:SetActiveEx(true)
		self.panel.LeftArrow.gameObject:SetActiveEx(false)
		self.panel.RightArrow.gameObject:SetActiveEx(false)
		return
	end
	self.scrollRect:SetCount(l_maCount)
	self.panel.LeftArrow:AddClick(function()
		local index = self.scrollRect.CurItemIndex
		if index ~= 0 then
			index = index - 1
		else
			index = l_maCount - 1
		end
		self.scrollRect:SelectIndex(index, true)
	end)
	self.panel.RightArrow:AddClick(function()
		local index = self.scrollRect.CurItemIndex
		if index ~= l_maCount - 1 then
			index = index + 1
		else
			index = 0
		end
		self.scrollRect:SelectIndex(index, true)
	end)
	for i = 1, #self.buttonList do
		self.buttonList[i]:AddClick(function()
			if i == self.nowIndex then
				UIMgr:ActiveUI(UI.CtrlNames.FashionRatingMain, self.data.History[i].round)
			end
		end)
	end

end
--lua custom scripts end
return FashionCatalogCtrl