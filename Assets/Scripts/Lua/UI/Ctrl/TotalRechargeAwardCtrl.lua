--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TotalRechargeAwardPanel"
require "UI/Template/TotalRechargeMiaoItem"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
local l_mgr = MgrMgr:GetMgr("TotalRechargeAwardMgr")
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class TotalRechargeAwardCtrl : UIBaseCtrl
---@field m_cur_id number
---@field m_N number
---@field m_X number
---@field m_equal boolean
---@field m_miao_list TotalRechargeAwardItem[]
TotalRechargeAwardCtrl = class("TotalRechargeAwardCtrl", super)
--lua class define end

--lua functions
function TotalRechargeAwardCtrl:ctor()
	
	super.ctor(self, CtrlNames.TotalRechargeAward, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function TotalRechargeAwardCtrl:Init()
	
	self.panel = UI.TotalRechargeAwardPanel.Bind(self)
	super.Init(self)
	l_mgr = MgrMgr:GetMgr("TotalRechargeAwardMgr")

	self.m_miao_pool = self:NewTemplatePool({
		UITemplateClass = UITemplate.TotalRechargeMiaoItem,
		ScrollRect = self.panel.ProgressScroll.LoopScroll,
		TemplatePrefab = self.panel.TotalRechargeMiaoItem.gameObject
	})
	self.m_award_pool = self:NewTemplatePool({
		UITemplateClass=UITemplate.ItemTemplate,
		ScrollRect=self.panel.AwardListScroll.LoopScroll
	})
end --func end
--next--
function TotalRechargeAwardCtrl:Uninit()
	self:DestoryModel()

	super.Uninit(self)
	self.panel = nil


end --func end
--next--
function TotalRechargeAwardCtrl:OnActive()
	
	--self.panel.LeftRoot:SetActiveEx(false)
	--self.panel.RightRoot:SetActiveEx(false)
	self.m_cur_id = nil

	--l_mgr.SendGetAllInfo()
	self:OnGetAllInfo()
	l_mgr.SendGetAwardDetail()
end --func end
--next--
function TotalRechargeAwardCtrl:OnDeActive()
	
	
end --func end
--next--
function TotalRechargeAwardCtrl:Update()
	self:RefreshProgress()
end --func end
--next--
function TotalRechargeAwardCtrl:BindEvents()
	--self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.GetAllInfo, self.OnGetAllInfo)
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.GotAward, self.OnGotAward)
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.TotalRechargeUpdate, self.OnTotalRechargeUpdate)
	self:BindEvent(l_mgr.EventDispatcher, l_mgr.Event.ShowDetail, self.OnShowDetail)
	self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, l_mgr.Event.GetAwardDetail, function (self, info)
		l_mgr.OnGetAwardDetail(info)
		if self.m_cur_id then
			self:ShowDetail(self.m_cur_id) -- 刷新下
		end
	end)
	self.panel.Btn_Back:AddClickWithLuaSelf(self.Close, self)
	self.panel.Btn_GotoMall:AddClickWithLuaSelf(self.Close, self)
	-- 点击领奖，点击间隔设置大点
	self.panel.Btn_GetAward:AddClickWithLuaSelf(self.OnClickGetAward, self)
	self.panel.Help:AddClickWithLuaSelf(self.OnClickHelp, self)
end --func end
--next--
--lua functions end

--lua custom scripts
function TotalRechargeAwardCtrl:OnGetAllInfo()
	--self.panel.LeftRoot:SetActiveEx(true)
	local id = self:RefreshMiaoList()
	if id then
		self:ShowDetail(id)
	end
	self:RefreshProgress()
	self.panel.MyProgressNum.LabText = l_mgr.Datas.m_currency_symbol .. tostring(l_mgr.Datas.m_total_recharge)

	if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
		self.panel.Tip:SetActiveEx(true)
		self.panel.Tip.LabText = Lang("TotalRechargeAward_Tip")
	else
		self.panel.Tip:SetActiveEx(false)
	end
end
function TotalRechargeAwardCtrl:OnGotAward(id)
	self:RefreshGetAwardBtn()
	self.m_miao_pool:RefreshCells()
	self:RefreshAwardList()--奖励及时变灰
end
function TotalRechargeAwardCtrl:OnTotalRechargeUpdate()
	self.m_miao_pool:RefreshCells()
	self:RefreshGetAwardBtn()
	self.panel.MyProgressNum.LabText = l_mgr.Datas.m_currency_symbol .. tostring(l_mgr.Datas.m_total_recharge)
end

function TotalRechargeAwardCtrl:RefreshAwardList()
	local id = self.m_cur_id
	local ls = {}
	if id ~= nil then
		local info = l_mgr.Datas.m_award_map[id]
		local detail_info = l_mgr.Datas.m_award_detail_map[info.gift_award_id]
		if detail_info then
			for _,v in ipairs(detail_info.award_list) do
				local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
				if l_itemRow then
					table.insert(ls, {
						ID = v.item_id,
						Count = v.count,
						IsGray = info.has_got,
					})
				end
			end
		end
	end
	self.m_award_pool:ShowTemplates({Datas = ls})
end

function TotalRechargeAwardCtrl:ShowDetail(id)
	self.m_cur_id = id
	--self.panel.RightRoot:SetActiveEx(true)
	self:RefreshGetAwardBtn()

	local ls = {}
	local info = l_mgr.Datas.m_award_map[id]
	local detail_info = l_mgr.Datas.m_award_detail_map[info.gift_award_id]
	---@type ItemTable
	local l_clothesItem = nil
	---@type ItemTable
	local l_houseItem = nil
	---@type CommonUIFunc
	local common_func = Common.CommonUIFunc
	if detail_info then
		for _,v in ipairs(detail_info.award_list) do
			local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
			if l_itemRow then
				table.insert(ls, {
					ID = v.item_id,
					Count = v.count,
					IsGray = info.has_got,
				})
				if common_func.GetItemIsOrnament(l_itemRow) then
					l_clothesItem = l_itemRow
				elseif l_itemRow.Subclass == 102 then
					l_houseItem = l_itemRow
				end
			end
		end
	end
	self.m_award_pool:ShowTemplates({Datas = ls})

	-- 显示图标或者模型
	local gift_info = TableUtil.GetGiftPackageTable().GetRowByMajorID(info.gift_id)
	self.panel.ModelImage:SetActiveEx(false)
	self.panel.ItemIcon:SetActiveEx(false)
	self:DestoryModel()
	if gift_info == nil then return end
	if gift_info.PackageShow == 0 then
		self.panel.ItemIcon:SetActiveEx(true)
		self.panel.ItemIcon:SetSprite(gift_info.GiftPackageAtlas, gift_info.GiftPackageIcon, true)
	elseif gift_info.PackageShow == 2 then
		if l_houseItem then
			self.panel.ModelImage:SetActiveEx(true)
			self.model = common_func.CreateVechicleModel(l_houseItem.ItemID,self.panel.ModelImage,true,false)
			self:SaveModelData(self.model)
		end
	else
		if l_clothesItem then
			self.panel.ModelImage:SetActiveEx(true)
			self.model = common_func.CreatePlayerModel({l_clothesItem.ItemID},{l_clothesItem},self.panel.ModelImage,false,true,false,nil,{
				width = self.panel.ModelImage.RectTransform.rect.width*1.4,
				height = self.panel.ModelImage.RectTransform.rect.height*1.4,
			})
			self:SaveModelData(self.model)
		end
	end
end

function TotalRechargeAwardCtrl:DestoryModel()
	if self.model then
		self:DestroyUIModel(self.model)
		self.model = nil
	end
end

function TotalRechargeAwardCtrl:OnShowDetail(idx, id)
	if self.m_cur_id == id then return end
	self:ShowDetail(id)
	self.m_miao_pool:SelectTemplate(idx)
end

function TotalRechargeAwardCtrl:OnClickGetAward()
	if not self.m_cur_id then return end

	l_mgr.SendGetAward(self.m_cur_id)
end

function TotalRechargeAwardCtrl:OnClickHelp()
	MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
		content = Lang("TotalRechargeAward_Help"),
		alignment = UnityEngine.TextAnchor.MiddleCenter,
		pivot = Vector2.New(0.5,0.5),
		anchoreMin=Vector2.New(0.5,0.5),
		anchoreMax=Vector2.New(0.5,0.5),
		pos = {
			x = 7,
			y = 172,
		},
		width = 400,
	})
end

---@return number
function TotalRechargeAwardCtrl:RefreshMiaoList()
	---@type TotalRechargeAwardItem[]
	local ls = {}
	local first_not = 0
	local limit = l_mgr.Datas.m_show_num_limit
	for i,v in ipairs(l_mgr.Datas.m_award_list) do
		if v.condition <= l_mgr.Datas.m_total_recharge then
			table.insert(ls, v)
		elseif limit > 0 then
			if first_not == 0 then first_not = i end
			limit = limit - 1
			table.insert(ls, v)
		elseif #ls < 4 then
			table.insert(ls, v)
		else
			break
		end
	end
	self.m_miao_list = ls
	local idx = #ls
	self.m_N = idx
	if first_not == 0 then first_not = self.m_N + 1 end
	self.m_equal = false
	if first_not > 1 then
		self.m_equal = ls[first_not-1].condition == l_mgr.Datas.m_total_recharge
	end
	self.m_X = first_not
	if idx == 0 then
		logError("测试没有配置任何该地区的数据")
		return
	end
	for i,v in ipairs(ls) do
		if v.condition <= l_mgr.Datas.m_total_recharge and not v.has_got then
			idx = i
			break
		elseif v.condition > l_mgr.Datas.m_total_recharge then
			idx = i
			break
		end
	end

	-- 尴尬，需要反转下
	ls = table.ro_reverse(ls)
	idx = #ls + 1 - idx
	local start_idx = idx

	-- 列表组件有bug，策划配置小于5个会出问题，填充些空白的。
	if #ls < 5 then
		for i = #ls+1,5 do
			idx = idx + 1
			table.insert(ls,1,{})
		end
		start_idx = 5
		self.panel.ProgressScroll.LoopScroll.enabled = false
	else
		self.panel.ProgressScroll.LoopScroll.enabled = true
	end

	self.m_miao_pool:ShowTemplates({ Datas = ls, StartScrollIndex = start_idx})

	self.m_miao_pool:SelectTemplate(idx)
	return ls[idx].id
end
function TotalRechargeAwardCtrl:RefreshProgress()

	if not self.m_N then return end
	-- 如果m_N < 5 需要特殊处理，组件有bug，奈何。

	local max_y = 205
	local min_y = -220

	local scroll_p = self.panel.ProgressScroll.LoopScroll:GetNormalizedPosition()
	-- scroll_p = 1 - scroll_p
	local H,S = 100,0
	local total_h = (H+S)*self.m_N - S
	local view_h = 432
	local pos_y = self.m_X * (H+S) - S*1.5 - H
	if self.m_equal then
		pos_y = (self.m_X-2) * (H+S) + H*0.5
	elseif self.m_X == 1 and l_mgr.Datas.m_total_recharge > 0 then
		pos_y = 16
	end
	local cur_y = (total_h - view_h) * scroll_p

	local target_y = pos_y - cur_y + min_y
	if target_y < min_y then
		target_y = min_y
	elseif target_y > max_y then
		target_y = max_y
	end

	local tmp_x = self.panel.MyProgress.transform.localPosition.x
	local tmp_y = math.min(target_y + 3, max_y-16)
	self.panel.MyProgress.transform.localPosition = Vector3.New(tmp_x, tmp_y, 0)

	self.panel.Slider.Slider.value = (target_y - min_y)/(max_y - min_y)
end
function TotalRechargeAwardCtrl:RefreshGetAwardBtn()
	self.panel.Btn_GotoMall:SetActiveEx(false)
	self.panel.Btn_GetAward:SetActiveEx(false)
	self.panel.Image_Got:SetActiveEx(false)
	if not self.m_cur_id then return end

	local info = l_mgr.Datas.m_award_map[self.m_cur_id]
	if info.has_got then
		self.panel.Image_Got:SetActiveEx(true)
	elseif info.condition <= l_mgr.Datas.m_total_recharge then
		self.panel.Btn_GetAward:SetActiveEx(true)
	else
		self.panel.Btn_GotoMall:SetActiveEx(true)
	end
end

--lua custom scripts end
return TotalRechargeAwardCtrl