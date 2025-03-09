--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GarderobeFashionPanel"
require "UI/Template/FashionLevelChangeItemTemplate"
require "UI/Template/GarderobeFashionAttrTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class GarderobeFashionCtrl : UIBaseCtrl
GarderobeFashionCtrl = class("GarderobeFashionCtrl", super)
--lua class define end

local FindObjectInChild = function(...)
	return MoonCommonLib.GameObjectEx.FindObjectInChild(...)
end
local Mgr = MgrMgr:GetMgr("GarderobeMgr")
local EachPageNum = 5
local CurrentLevel = 0

--lua functions
function GarderobeFashionCtrl:ctor()

	super.ctor(self, CtrlNames.GarderobeFashion, UILayer.Function, nil, ActiveType.None)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.GarderobeFashion
	self.MaskDelayClickTime=2

end --func end
--next--
function GarderobeFashionCtrl:Init()

	self.panel = UI.GarderobeFashionPanel.Bind(self)
	super.Init(self)

	self.rankMgr = MgrMgr:GetMgr("RankMgr")
	self.mgr = MgrMgr:GetMgr("FashionRatingMgr")
	self.RowsInfo = {}
	self.data = DataMgr:GetData("FashionData")

	self.CurPage = 1
	self.CurrentLevel = 0
	self.FashionNumber = 0
	self.GarderobeAwardRow = nil

	self.NextLevel = 0
	self.NextGarderobeAwardRow = nil

end --func end

--next--
function GarderobeFashionCtrl:SetFashionNumber(number)
	self.FashionNumber = number
	self.panel.leftfashionnum.LabText = Lang("Garderobe_FASHION_Count")..tostring(number)
	local Table = TableUtil.GetGarderobeAwardTable().GetTable()
	local flag = false
	for i = 1, #Table do
		if Table[i].Point <= number then
			self.CurrentLevel = Table[i].ID
			self.GarderobeAwardRow = Table[i]
		else
			self.NextLevel = Table[i].ID
			self.NextGarderobeAwardRow = Table[i]
			flag = true
			break
		end
	end
	if flag == false then
		self.NextLevel = self.CurrentLevel
		self.NextGarderobeAwardRow = self.GarderobeAwardRow
	end
	Mgr.SelectFashionNumberIndex = self.CurrentLevel
	self.panel.LevelText.LabText = self.CurrentLevel
	self.panel.LevelText.LabColor = CommonUI.Color.Hex2Color(self.GarderobeAwardRow.NumberColor)
	self.CurPage = math.ceil(self.NextGarderobeAwardRow.ID / EachPageNum)
	self.panel.LeftIcon:SetSpriteAsync(self.GarderobeAwardRow.Atlas, self.GarderobeAwardRow.Icon, nil, true)
	self.panel.progress.Img.fillAmount = (number - self.GarderobeAwardRow.Point) / (self.NextGarderobeAwardRow.Point - self.GarderobeAwardRow.Point)
	self.panel.progress.Img.color = CommonUI.Color.Hex2Color(self.GarderobeAwardRow.Color)
	self:RefreshNextInfo()
end --func end
--next--
function GarderobeFashionCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
	self.scrollRect = nil
	self.GarderobeFashionAttrPool = nil
end --func end
--next--
function GarderobeFashionCtrl:OnActive()
	self:Bind()
	self.panel.leftfashionhelp:SetActiveEx(true)
	self:InitView()
	self:_checkGuild()
end --func end
-- 引导
function GarderobeFashionCtrl:_checkGuild()
	if self.CurrentLevel >= 1 then
		local l_beginnerGuideChecks = {"GarderobeFashionCountGuide2"}
		MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
	end
end
function GarderobeFashionCtrl:Bind()
	self.panel.Close:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.GarderobeFashion)
	end)
	self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_AWARD_RES, function()
		self:RefreshFoot()
		self:RefreshNextInfo()
		MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.FashionAward)
	end)
	self.panel.leftfashionhelp.Listener.onClick = function(go, eventData)
		local l_infoText = Lang("Garderobe_FASHION_Help")
		local pos = Vector2.New(eventData.position.x, eventData.position.y)
		eventData.position = pos
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, Vector2(0, 0))
	end
	self.panel.TogFashion.TogEx.isOn = true
	self.panel.TogFashion.TogEx.onValueChanged:AddListener(function(value)
		if value then
			self.panel.LeftView.gameObject:SetActiveEx(true)
			self.panel.RightView.gameObject:SetActiveEx(true)
			self.panel.FootView.gameObject:SetActiveEx(true)
			self.panel.PanelRank.Group.gameObject:SetActiveEx(false)
		end
	end)
	self.panel.TogRank.TogEx.onValueChanged:AddListener(function(value)
		if value then
			self.panel.LeftView.gameObject:SetActiveEx(false)
			self.panel.RightView.gameObject:SetActiveEx(false)
			self.panel.FootView.gameObject:SetActiveEx(false)
			self.panel.PanelRank.Group.gameObject:SetActiveEx(true)


			self.panel.PanelRank.Choose.gameObject:SetActiveEx(false)
			self.mgr.RequestFashionEvaluationInfo()
			self.mgr.RequestFashionEvaluationNpc()
			--2默认显示所有玩家，0默认最新排行，1默认第一页
			self.rankMgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, 2, 0, 0, true)
		end
	end)

	self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.InvData, self.InitAll)
	self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.RoleData, function(self, role)
		self:ShowModel3D(role)
	end)
	self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_IS_READY, function(self, strKey, targetRankList)
		self.RowsInfo = {}
		self.data.TotalNum = 0
		self:AddPageInfo(targetRankList)
		if self.panel.TogRank.TogEx.isOn then
			self:RankInit(self.panel.PanelRank)
		else
			self:InitAll()
		end
	end)
	self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_NIL, function(self)
		self.RowsInfo = {}
		self.data.TotalNum = 0
		self:RankInit(self.panel.PanelRank)
	end)
	self:BindEvent(MgrMgr:GetMgr("RankMgr").EventDispatcher, DataMgr:GetData("RankData").RANKINFO_NEXT_PAGE, function(self, strKey, targetRankList)
		self:AddPageInfo(targetRankList)
		self.panel.PanelRank.ScrollView.LoopScroll:ChangeTotalCount(self.data.TotalNum)
	end)
end
function GarderobeFashionCtrl:InitAll()
	--self:InvInit(self.panel.PanelInv)
	local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
	if l_dailyMgr.IsActivityInOpenDay(l_dailyMgr.g_ActivityType.activity_Fashion) then
		--只移植时尚街拍的排行榜功能
		--self:BeforeInit(self.panel.PanelBefore)
		--self:AfterInit(self.panel.PanelAfter)
	end

end

function GarderobeFashionCtrl:SelectAttrById(garderobeAwardId)
	local l_Row = TableUtil.GetGarderobeAwardTable().GetRowByID(garderobeAwardId,true)
	if l_Row then
		self:SetFashionNumber(Mgr.FashionRecord.fashion_count)
		self:SelectAttr(
			{
				ID = garderobeAwardId,
				GarderobeAwardRow = l_Row
			})
	end
end

function GarderobeFashionCtrl:SelectAttr(Info)
	self.NextLevel = Info.ID
	self.NextGarderobeAwardRow = Info.GarderobeAwardRow
	self:RefreshFoot()
	self:RefreshNextInfo()
end
function GarderobeFashionCtrl:RefreshFoot()
	local Page = self.CurPage
	local Table = TableUtil.GetGarderobeAwardTable().GetTable()

	local openTimeStamps = {}
	local fashion_count_award = Mgr.FashionRecord.fashion_count_award



	for i, row in ipairs(fashion_count_award.repeat_pairs) do
		local l_pair = row
		table.insert(openTimeStamps,tonumber(l_pair.second))
	end
	for i = 1,#self.panel.FashionLevelChange do
		self.panel.FashionLevelChange[i].gameObject:SetActiveEx(false)
	end
	local objindex = 1
	for i = (Page - 1)*EachPageNum + 1,math.min(#Table - 1,Page * EachPageNum) do
		self.panel.FashionLevelChange[objindex].gameObject:SetActiveEx(true)

		self.panel.ItemFashionLevel[objindex].LabText = Table[i+1].ID
		local redIcon = FindObjectInChild(self.panel.FashionLevelChange[objindex].gameObject, "IconHot")
		if Table[i+1].AwardId ~= nil and Table[i+1].AwardId ~= 0  then
			self.panel.havReward[objindex].gameObject:SetActiveEx(true)
			if openTimeStamps[Table[i+1].ID] ~= 1 and self.CurrentLevel >= Table[i+1].ID then
				if redIcon ~= nil then
					redIcon:SetActiveEx(true)
				end
			else
				if redIcon ~= nil then
					redIcon:SetActiveEx(false)
				end
			end
		else
			self.panel.havReward[objindex].gameObject:SetActiveEx(false)
			if redIcon ~= nil then
				redIcon:SetActiveEx(false)
			end
		end

		if MgrMgr:GetMgr("GarderobeMgr").Callfashionlevelbyfashioncount(MgrMgr:GetMgr("GarderobeMgr").FashionRecord.fashion_count) >= Table[i+1].ID then
			self.panel.FashionLevelChange[objindex]:SetSpriteAsync(Table[i+1].ListAtlas, Table[i+1].ListIcon[0], nil, false)
		else
			self.panel.FashionLevelChange[objindex]:SetSpriteAsync(Table[i+1].ListAtlas, Table[i+1].ListIcon[2], nil, false)
		end

		if Table[i+1].ID == self.NextGarderobeAwardRow.ID then
			self.panel.FashionLevelChange[objindex]:SetSpriteAsync(Table[i+1].ListAtlas, Table[i+1].ListIcon[1], nil, false)
		end
		self.panel.FashionLevelChange[objindex]:AddClick(function()
			self:SelectAttr({ID =  Table[i+1].ID,GarderobeAwardRow =  Table[i+1]})
		end)
		objindex = objindex + 1
	end
	self:RefreshSelectpanelState()
	self:MissionScrollTipArrowControl()
end
function GarderobeFashionCtrl:InitView()

	local onArrowUp = function()
		self.CurPage = self.CurPage - 1
		self:RefreshFoot()
	end

	local onArrowDown = function()
		self.CurPage = self.CurPage + 1
		self:RefreshFoot()
	end
	self.panel.LeftLevel:AddClick(onArrowUp)
	self.panel.RightLevel:AddClick(onArrowDown)


	self.GarderobeFashionAttrPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.GarderobeFashionAttrTemplate,
		TemplatePrefab = self.panel.GarderobeFashionAttr.gameObject,
		TemplateParent = self.panel.CurrentContent.transform,
	})
	local attrdata = {}
	local Table = TableUtil.GetGarderobeAwardTable().GetTable()
	for i = 2,#Table do
		if Table[i].ID > self.CurrentLevel then
			break
		end
		local attrs = Common.Functions.VectorSequenceToTable(Table[i].AddAttr)
		for i, v in ipairs(attrs) do
			local attr = {type = v[1], id = v[2], val = v[3]}
			if attr.type and attr.id and attr.val then
				local flag = false
				for j=1,#attrdata do
					if attrdata[j].type == attr.type and attrdata[j].id == attr.id then
						flag = true
						attrdata[j].val = attrdata[j].val + attr.val
						break
					end
				end
				if flag == false then
					table.insert(attrdata,attr)
				end
			end
		end
	end
	self.GarderobeFashionAttrPool:ShowTemplates({
		Datas = attrdata
	})
	if #attrdata == 0 then
		self.panel.NoAttrTips.gameObject:SetActiveEx(true)
	else
		self.panel.NoAttrTips.gameObject:SetActiveEx(false)
	end


	--查看是否有未领取的
	local fashion_count_award = Mgr.FashionRecord.fashion_count_award
	--for i, row in ipairs(fashion_count_award.repeat_pairs) do
	--	logError("i : row : "..i.." "..tostring(row.first).." "..tostring(row.second))
	--end
	for i, row in ipairs(fashion_count_award.repeat_pairs) do
		local l_pair = row
		--logError("l_pair.first : l_pair.second : "..l_pair.first..tostring(l_pair.second))
		local GarderobeAwardTrows = TableUtil.GetGarderobeAwardTable().GetRowByID(l_pair.first,true)
		if  self.CurrentLevel >= l_pair.first and l_pair.second ~= 1 and GarderobeAwardTrows.AwardId ~= 0 then
			self.NextLevel = l_pair.first
			self.NextGarderobeAwardRow = TableUtil.GetGarderobeAwardTable().GetRowByID(l_pair.first,true)
			break
		end
	end
	self.CurPage = math.ceil(self.NextGarderobeAwardRow.ID / EachPageNum)
	self:RefreshFoot()
	self:RefreshNextInfo()
end

function GarderobeFashionCtrl:RefreshSelectpanelState()
	local Table = TableUtil.GetGarderobeAwardTable().GetTable()
	local data_count = math.ceil(((#Table -1)/ EachPageNum))
	for i=1,#self.panel.IsSelectedpanel do
		self.panel.IsSelectedpanel[i].gameObject:SetActive(false)
	end
	local _index = self.CurPage
	--logError(" _index : ".._index)
	for i=1,data_count do
		self.panel.IsSelectedpanel[i].gameObject:SetActive(true)
		if data_count % 2 == 0 then
			self.panel.IsSelectedpanel[i].transform.localPosition = Vector3.New(((i-1)*2+1 - (data_count)) * 20, -60 ,0.0)
		else
			self.panel.IsSelectedpanel[i].transform.localPosition = Vector3.New((i - math.ceil(data_count/2)) * 40, -60, 0.0)
		end
		if _index == i then
			self.panel.IsSelectedpanel[i].transform:Find("Image").gameObject:SetActive(true)
		else
			self.panel.IsSelectedpanel[i].transform:Find("Image").gameObject:SetActive(false)
		end
	end



end
function GarderobeFashionCtrl:RefreshNextInfo()
	local openTimeStamps = {}
	local fashion_count_award = Mgr.FashionRecord.fashion_count_award

	for i, row in ipairs(fashion_count_award.repeat_pairs) do
		local l_pair = row
		table.insert(openTimeStamps,tonumber(l_pair.second))
	end
	self.panel.FashionLevel.LabText = self.NextGarderobeAwardRow.ID

	local tiaojian = tostring(self.NextGarderobeAwardRow.Point)
	if self.NextGarderobeAwardRow.Point > self.FashionNumber then
		tiaojian = GetColorText(tiaojian, RoColorTag.Red)
	else
		tiaojian = GetColorText(tiaojian, RoColorTag.Green)
	end
	self.panel.UpgradeLimit.LabText = Lang("Garderobe_FASHION_UpgradeTips", tiaojian)
	if self.NextGarderobeAwardRow.AwardId ~= 0 then
		self.panel.OtherReward.gameObject:SetActive(true)


		local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(self.NextGarderobeAwardRow.AwardId)
		local itemDatas = {}
		if l_awardData ~= nil then
			for i = 0, l_awardData.PackIds.Length - 1 do
				local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
				if l_packData ~= nil then
					for j = 0, l_packData.GroupContent.Count - 1 do
						table.insert(itemDatas, { ID = tonumber(l_packData.GroupContent:get_Item(j, 0)), Count = tonumber(l_packData.GroupContent:get_Item(j, 1)),
												  ButtonMethod = function()
													  if openTimeStamps[self.NextGarderobeAwardRow.ID] ~= 1 and self.CurrentLevel >= self.NextGarderobeAwardRow.ID then
														  MgrProxy:GetGarderobeMgr().RequestFashionCountSendAward(self.NextGarderobeAwardRow.ID)
													  else
														  local itemid =  tonumber(l_packData.GroupContent:get_Item(j, 0))
														  MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemid, self.panel.OtherReward.transform)
													  end
												  end
						})
					end
				end
			end
		end
		if self.ItemPool == nil then
			self.ItemPool = self:NewTemplatePool({
				TemplateClassName = "ItemTemplate",
				TemplateParent = self.panel.OtherRewardicon.Transform,
				TemplatePath = "UI/Prefabs/ItemPrefab",

			})
		end
		self.ItemPool:ShowTemplates({
			Datas = itemDatas
		})


	else
		self.panel.OtherReward.gameObject:SetActive(false)
	end
	for i = 1,#self.panel.LevelAttribute do
		self.panel.LevelAttribute[i].gameObject:SetActive(false)
	end
	local attrs = Common.Functions.VectorSequenceToTable(self.NextGarderobeAwardRow.AddAttr)
	for i, v in ipairs(attrs) do
		local attr = {type = v[1], id = v[2], val = v[3]}
		if attr.type and attr.id and attr.val then
			self.panel.LevelAttribute[i].gameObject:SetActive(true)
			self.panel.LevelAttribute[i].LabText =  MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
		end
	end
	if openTimeStamps[self.NextGarderobeAwardRow.ID] == 1 then
		self.panel.isGeted.gameObject:SetActive(true)
		self.panel.ClicktoGet.gameObject:SetActive(false)
		local redIcon = FindObjectInChild(self.panel.OtherReward.gameObject, "IconHot")
		if redIcon ~= nil then
			redIcon:SetActiveEx(false)
		end
	else
		self.panel.isGeted.gameObject:SetActive(false)
		self.panel.ClicktoGet.gameObject:SetActive(true)
		if self.CurrentLevel >= self.NextGarderobeAwardRow.ID then
			self.panel.ClicktoGet.gameObject:SetActive(true)
			--			--redpoint true
			local redIcon = FindObjectInChild(self.panel.OtherReward.gameObject, "IconHot")
			if redIcon ~= nil then
				redIcon:SetActiveEx(true)
			end
		else
			self.panel.ClicktoGet.gameObject:SetActive(false)
			--redpoint false
			local redIcon = FindObjectInChild(self.panel.OtherReward.gameObject, "IconHot")
			if redIcon ~= nil then
				redIcon:SetActiveEx(false)
			end
		end
	end

end

function GarderobeFashionCtrl:MissionScrollTipArrowControl()
	local Table = TableUtil.GetGarderobeAwardTable().GetTable()
	local openTimeStamps = {}
	local fashion_count_award = Mgr.FashionRecord.fashion_count_award

	for i, row in ipairs(fashion_count_award.repeat_pairs) do
		local l_pair = row
		table.insert(openTimeStamps,tonumber(l_pair.second))
	end

	local CurPagemi = (self.CurPage - 1) * EachPageNum + 1
	local CurPagemx = math.min(self.CurPage * EachPageNum,#Table - 1)

	local mi = 1000
	local mx = 0
	for i = 1, #Table-1 do
		if i <= self.CurrentLevel and openTimeStamps[i] ~= 1 and Table[i + 1].AwardId > 0 then
			mi = math.min(mi,i )
			mx = math.max(mx,i )
		end
	end



	--logError("CurPagemi is "..CurPagemi)
	--logError("CurPagemx is "..CurPagemx)
	--logError("mi is "..mi)
	--logError("mx is "..mx)



	if self.CurPage == 1 then
		self.panel.LeftLevel.UObj:SetActiveEx(false)
	else
		self.panel.LeftLevel.UObj:SetActiveEx(true)
		local redIcon = FindObjectInChild(self.panel.LeftLevel.UObj, "IconHot")
		if CurPagemi > mi then
			if redIcon ~= nil then
				redIcon:SetActiveEx(true)
			end
		else
			if redIcon ~= nil then
				redIcon:SetActiveEx(false)
			end
		end
	end


	if self.CurPage == math.ceil((#Table - 1) / EachPageNum)  then
		self.panel.RightLevel.UObj:SetActiveEx(false)
	else
		self.panel.RightLevel.UObj:SetActiveEx(true)
		local redIcon = FindObjectInChild(self.panel.RightLevel.UObj, "IconHot")
		if CurPagemx < mx then
			if redIcon ~= nil then
				redIcon:SetActiveEx(true)
			end
		else
			if redIcon ~= nil then
				redIcon:SetActiveEx(false)
			end
		end
	end


end
function GarderobeFashionCtrl:AddPageInfo(newRowTb)

	local l_tabs = table.ro_deepCopy(newRowTb)
	table.ro_insertRange(self.RowsInfo, l_tabs)
	self.data.TotalNum = #self.RowsInfo

	local l_ownInfo = DataMgr:GetData("RankData").OwnRankInfo
	local l_ownInfoData = l_ownInfo[MgrMgr:GetMgr("FashionRatingMgr").FashionTableID .. "_" .. MgrMgr:GetMgr("FashionRatingMgr").RankKey .. "_" .. "0"]
	if l_ownInfoData[1] == nil or l_ownInfoData[1].value == nil or l_ownInfoData[1].value == 0 then
		self.data.CollectRank = 0
	else
		self.data.CollectScore = l_ownInfoData[2].value
		self.data.CollectRank = l_ownInfoData[1].value
	end

	self.panel.PanelRank.MyScore.LabText = tostring(self.data.CollectScore)
	self.panel.PanelRank.MyName.LabText = MPlayerInfo.Name
	if self.data.CollectRank > 0 then
		self.panel.PanelRank.MyRank.LabText = tostring(self.data.CollectRank)
	else
		self.panel.PanelRank.MyRank.LabText = tostring(MgrMgr:GetMgr("FashionRatingMgr").RankLimit) .. "+"
	end

end
function GarderobeFashionCtrl:SelectRole(index, id)

	self.scrollRect:SelectTemplate(index)
	local l_idTable = {}
	l_idTable[1] = { value = id }
	MgrMgr:GetMgr("TeamMgr").GetRoleInfoListByIds(l_idTable, DataMgr:GetData("TeamData").ERoleInfoType.FashionCollection)

end
function GarderobeFashionCtrl:GetNowPage()

	local l_info = self.rankMgr.GetPbVarInExcelByType(self.mgr.FashionTableID)
	local rowDatas = {}
	for k, v in pairs(self.RowsInfo) do
		local l_data = {}
		l_data.index = k
		l_data.rowValue = v
		l_data.rowName = l_info
		table.insert(rowDatas, l_data)
	end
	return rowDatas

end
function GarderobeFashionCtrl:RankInit(panel)

	if self.scrollRect == nil then
		self.scrollRect = self:NewTemplatePool({
			TemplateClassName = "FashionRankTemplate",
			TemplatePrefab = panel.FashionRank.gameObject,
			ScrollRect = panel.ScrollView.LoopScroll,
			GetDatasMethod = function()
				return self:GetNowPage()
			end,
			Method = function(index, id)
				self:SelectRole(index, id)
			end
		})
	end

	self.scrollRect:ShowTemplates()
	if self.data.TotalNum > 0 then
		local l_one = self:GetNowPage()
		local id = l_one[1].rowValue[3].membersInfo[1].id
		self:SelectRole(1, id)
		panel.Model:SetActiveEx(true)
	else
		panel.Model:SetActiveEx(false)
	end

	panel.FashionRankDescribe.LabText = Lang("FASHION_RANK_DESCRIBE")

	panel.BtnQuestion.gameObject:SetActiveEx(false)
	panel.BtnQuestion.Listener.onClick = function(go, ed)
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("FASHIONSTAR_QUESTION"), ed, Vector2(1, 1), false)
	end
	panel.None:SetActiveEx(self.data.TotalNum == 0)
	panel.BtnScreen:AddClick(function()
		DataMgr:GetData("RankData").isGetNextPage = false
		if panel.Choose.gameObject.activeSelf then
			panel.Choose.gameObject:SetActiveEx(false)
			self.mgr.RankKey = 2
			self.rankMgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, 2, 0, 0, true)
		else
			panel.Choose.gameObject:SetActiveEx(true)
			self.mgr.RankKey = 12
			self.rankMgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, 12, 0, 0, true)
		end
	end)

end
function GarderobeFashionCtrl:StopCountDown()

	if self.timer then
		self:StopUITimer(self.timer)
		self.timer = nil
	end

end

function GarderobeFashionCtrl:SetCountDown(timeUI)

	self:SetTime(timeUI)
	self:StopCountDown()
	self.timer = self:NewUITimer(function()
		self:SetTime(timeUI)
	end, 1, -1)
	self.timer:Start()

end

function GarderobeFashionCtrl:GetTimeData(time)

	if StringEx.Length(time) == 4 then
		return tonumber(StringEx.SubString(time, 0, 2)) * 60 + tonumber(StringEx.SubString(time, 2, 2))
	elseif StringEx.Length(time) == 3 then
		return tonumber(StringEx.SubString(time, 0, 1)) * 60 + tonumber(StringEx.SubString(time, 1, 2))
	end
	return 0

end

function GarderobeFashionCtrl:SetTime(timeUI)

	local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
	local l_table = TableUtil.GetDailyActivitiesTable().GetRowById(l_taskMgr.g_ActivityType.activity_Fashion)
	local l_beginTime = l_taskMgr.GetBattleTime(l_taskMgr.g_ActivityType.activity_Fashion)
	local l_nowTime = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
	local l_lastTime = l_nowTime - l_beginTime

	local l_endTime = self:GetTimeData(l_table.TimePass[0][1])
	l_beginTime = self:GetTimeData(l_table.TimePass[0][0])
	l_lastTime = l_endTime * 60 - l_beginTime * 60 - l_lastTime
	if l_lastTime <= 0 or not l_taskMgr.IsActivityInOpenDay(l_taskMgr.g_ActivityType.activity_Fashion) then
		timeUI.LabText = Lang("ACTIVITY_IS_ALREADY_OVER")
	else
		local l_hour, l_min, l_second = math.floor(l_lastTime / 3600), math.floor((l_lastTime % 3600) / 60), l_lastTime % 60
		if l_hour == 0 then
			if l_min == 0 then
				timeUI.LabText = Lang("ACTIVITY_TIME_REMAINED") .. "：" .. tostring(l_second) .. Lang("SECOND")
			else
				timeUI.LabText = Lang("ACTIVITY_TIME_REMAINED") .. "：" .. tostring(l_min) .. Lang("MINUTE")
						.. tostring(l_second) .. Lang("SECOND")
			end
		else
			timeUI.LabText = Lang("ACTIVITY_TIME_REMAINED") .. "：" .. tostring(l_hour) .. Lang("HOURS") .. tostring(l_min)
					.. Lang("MINUTE") .. tostring(l_second) .. Lang("SECOND")
		end
	end

end

function GarderobeFashionCtrl:InvInit(panel)

	self:SetCountDown(panel.Time)
	panel.Group.gameObject:SetActiveEx(true)
	panel.Describe.LabText = Lang("FASHION_PRETEXT")
	panel.Title.LabText = Lang("FASHION_TITLE")
	panel.BtnOpen:AddClick(function()
		local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
		if l_taskMgr.IsActivityInOpenDay(l_taskMgr.g_ActivityType.activity_Fashion) then
			self.panel.PanelInv.Group.gameObject:SetActiveEx(false)
			if self.data.MaxCount - self.data.GradeCount == 0 then
				self.panel.PanelBefore.Group.gameObject:SetActiveEx(true)
				self:SetCountDown(self.panel.PanelBefore.Time)
			else
				self.panel.PanelAfter.Group.gameObject:SetActiveEx(true)
				self:SetCountDown(self.panel.PanelAfter.Time)
			end
			self.panel.BtnTab.gameObject:SetActiveEx(true)
		else
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_IS_ALREADY_OVER"))
		end
	end)

end

function GarderobeFashionCtrl:BeforeInit(panel)

	if self.data.JournalTheme == 0 or self.data.NpcData.sceneId == 0 then
		--logError("非法的时尚主题，是否不在活动时间内？")
		return
	end
	local l_theme = TableUtil.GetFashionThemeTable().GetRowByID(self.data.JournalTheme, true)
	local l_sceneData = TableUtil.GetSceneTable().GetRowByID(self.data.NpcData.sceneId)
	panel.Group.gameObject:SetActiveEx(false)
	if l_theme ~= nil then
		if self.data.CollectRank > 0 and self.data.CollectScore > 0 then
			panel.Describe.LabText = Lang("FASHION_BEFORETEXT", l_theme.Name, self.data.CollectScore, self.data.CollectRank, l_sceneData.MapEntryName)
		else
			panel.Describe.LabText = Lang("FASHION_BEFORETEXT_CIVILIAN", l_theme.Name, l_sceneData.MapEntryName)
		end
	end

	panel.BtnQuestion.gameObject:SetActiveEx(false)
	panel.BtnQuestion.Listener.onClick = function(go, ed)
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("FASHION_QUESTION"), ed, Vector2(1, 1), false)
	end
	panel.BtnAward:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.FashionAwardPreview)
	end)
	panel.BtnGo:AddClick(function()
		self.mgr.GotoNpc()
	end)

end

function GarderobeFashionCtrl:AfterInit(panel)

	if self.data.JournalTheme == 0 or self.data.NpcData.sceneId == 0 then
		--logError("非法的时尚主题，是否不在活动时间内？")
		return
	end
	panel.Group.gameObject:SetActiveEx(false)
	panel.Describe.LabText = Lang("FASHION_AFTERTEXT", self.data.MaxCount - self.data.GradeCount, self.data.GradeCount, self.data.MaxPoint)
	if self.data.MaxCount - self.data.GradeCount ~= 0 and self.data.PhotoData.type ~= 0 then    --已有记录才刷新照片
		self:ShowModel(self.data.PhotoData, panel.Model, true)
	end

	panel.BtnQuestion.gameObject:SetActiveEx(false)
	panel.BtnQuestion.Listener.onClick = function(go, ed)
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("FASHION_QUESTION"), ed, Vector2(1, 1), false)
	end
	panel.BtnAward:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.FashionAwardPreview)
	end)
	panel.BtnShare:AddClick(function()
		MgrMgr:GetMgr("FashionRatingMgr").ShareFashionRating()
	end)
	panel.BtnGo:AddClick(function()
		self.mgr.GotoNpc()
	end)

end
function GarderobeFashionCtrl:ShowModel(mainData, model, objData)

	if not self.panel then
		return
	end
	objData = objData and mainData
	if self.PlayerModel and not objData then
		self:DestroyUIModel(self.PlayerModel)
		self.PlayerModel = nil
		model:SetActiveEx(false)
	end

	if not self.PlayerModel and objData then
		local l_attr = MgrMgr:GetMgr("PlayerInfoMgr").GetAttribData(mainData)
		local l_pos, l_scale, l_rotation = mainData:GetPSR()  --拍照时玩家的坐标 缩放 旋转获取
		if not l_pos then
			l_pos = { x = 0, y = -1.51, z = -0.17 }
			l_scale = { x = 1.9, y = 1.9, z = 1.9 }
			l_rotation = { x = -10.295, y = 180, z = 0 }
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
		self.PlayerModel = self:CreateUIModel(l_fxData)


		local l_animKey, l_animPath, l_animTime = mainData:GetAnimInfo()
		l_animKey = l_animKey or "Idle"
		l_animPath = l_animPath or l_attr.CommonIdleAnimPath
		l_animTime = l_animTime or 0
		self.PlayerModel.Ator:OverrideAnim(l_animKey, l_animPath)
		self.PlayerModel.Ator:Play(l_animKey, l_animTime)
		self.PlayerModel.Ator.Speed = 0

		local l_emotion1, l_emotion2 = mainData:GetEmotion()
		if l_emotion1 and l_emotion2 then
			self.PlayerModel:ChangeEmotion(l_emotion1, l_emotion2, 999999)
		end

		self.PlayerModel:AddLoadModelCallback(function(m)
			model:SetActiveEx(true)
		end)
	end

end

function GarderobeFashionCtrl:ShowModel3D(roleInfo)


	if self.playerModel3D ~= nil then
		self:DestroyUIModel(self.playerModel3D)
		self.playerModel3D = nil
	end
	self.playerModel3D = Common.CommonUIFunc.CreateModelEntity(roleInfo, self.panel.PanelRank.Model, true, true)
	self:SaveModelData(self.playerModel3D)
end
--next--
function GarderobeFashionCtrl:OnDeActive()


end --func end
--next--
function GarderobeFashionCtrl:Update()


end --func end
--next--
function GarderobeFashionCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GarderobeFashionCtrl