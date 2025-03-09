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
---@class MallFestivalPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PriceNum MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field 0 MoonClient.MLuaUICom

---@class MallFestivalPrefab : BaseUITemplate
---@field Parameter MallFestivalPrefabParameter

MallFestivalPrefab = class("MallFestivalPrefab", super)
--lua class define end

--lua functions
function MallFestivalPrefab:Init()
	
	super.Init(self)

	self.Parameter.Btn:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.CapraReward_Tips, {giftId = self.giftId, timeId = self.timeId})
	end)
	self.Parameter.VehicleModelBtn.Listener.onClick = function(go,eventData)
		UIMgr:ActiveUI(UI.CtrlNames.CapraReward_Tips, {giftId = self.giftId, timeId = self.timeId})
	end
	self.Parameter.Model.Listener.onClick = function(go,eventData)
		UIMgr:ActiveUI(UI.CtrlNames.CapraReward_Tips, {giftId = self.giftId, timeId = self.timeId})
	end
	self.Parameter.Btn_Buy:AddClick(function()
		if not self:IsOpen() then return end
		local l_count, l_limit = MgrMgr:GetMgr("GiftPackageMgr").GetLimitInfo(self.giftId)
		local l_isSellOut = l_count >= l_limit
		if l_isSellOut then return end

		local l_giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(self.giftId)
		if l_giftRow then
			local l_needCoinNum = l_giftRow.Cost[0][1]
			local l_isFree = l_needCoinNum == 0
			local l_hasCoinNum = Data.BagModel:GetCoinNumById(l_giftRow.Cost[0][0])
			if not l_isFree and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
				local l_iconStr = MgrMgr:GetMgr("ItemMgr").GetIconRichImage(l_giftRow.Cost[0][0])
				local l_msg = Lang("GIFT_BUY_MSG", l_iconStr, MNumberFormat.GetNumberFormat(l_giftRow.Cost[0][1]), l_giftRow.GiftPackageName)
				CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm, true, nil, l_msg, Lang("DLG_BTN_YES"), Lang("DLG_BTN_NO"), function()
					if l_hasCoinNum < l_needCoinNum then
						MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIAMOND_NOT_ENOUGH"))
					else
						MgrMgr:GetMgr("GiftPackageMgr").BuyGiftPackage(l_giftRow.MajorID, self.mainId)
					end
				end)
			else
				local l_hasCoinNum = Data.BagModel:GetCoinNumById(l_giftRow.Cost[0][0])
				if l_hasCoinNum < l_needCoinNum then
					MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIAMOND_NOT_ENOUGH"))
				else
					MgrMgr:GetMgr("GiftPackageMgr").BuyGiftPackage(l_giftRow.MajorID, self.mainId)
				end
			end
		end
	end)
	
end --func end
--next--
function MallFestivalPrefab:BindEvents()

	self:BindEvent(MgrMgr:GetMgr("LimitBuyMgr").EventDispatcher,MgrMgr:GetMgr("LimitBuyMgr").LIMIT_BUY_COUNT_UPDATE, function(_, type, id)
		id = tonumber(id)
		if self.giftId and self.giftId == id then
			self:RefreshDetail()
		end
	end)

	self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,function(object, data,h,id)
		if self.giftId then
			local giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(self.giftId)
			if giftRow and giftRow.AwardID == id then
				self:ShowModel(giftRow,data)
			end
		end
	end)
	
end --func end
--next--
function MallFestivalPrefab:OnDestroy()

		self:DestoryModel()

end --func end
--next--
function MallFestivalPrefab:OnDeActive()
	
	
end --func end
--next--
function MallFestivalPrefab:OnSetData(data)

	self.mainId = data.mainId
	self.giftId = data.giftId or 0
	self.timeId = data.timeId or 0
	self.state = data.state or 0
	self:RefreshDetail()
	
end --func end
--next--
--lua functions end

--lua custom scripts

function MallFestivalPrefab:RefreshDetail()
	if not self.giftId then return end
	local l_giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(self.giftId)
	if l_giftRow then
		local l_isFree = l_giftRow.Cost[0][1] == 0
		local l_giftPackageMgr = MgrMgr:GetMgr("GiftPackageMgr")
		local l_count, l_limit = l_giftPackageMgr.GetLimitInfo(self.giftId)
		local l_isSellOut = l_count >= l_limit
		local l_isOpen = self:IsOpen()
		local l_isShowState = self.state == GameEnum.ETimeLimitState.kTLS_Show
		local l_isEnd = self.state == GameEnum.ETimeLimitState.kTLS_End
		MgrMgr:GetMgr("ItemMgr").SetItemSprite(self.Parameter.OriginalCoinIcon, l_giftRow.Value[0][0])
		MgrMgr:GetMgr("ItemMgr").SetItemSprite(self.Parameter.PresentCoinIcon, l_giftRow.Cost[0][0])
		self.Parameter.LimitNum.LabText = StringEx.Format("{0}/{1}", l_count, l_limit)
		local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
		local l_refreshType = l_limitBuyMgr.GetRefreshTypeByKey(l_limitBuyMgr.g_limitType.GiftPackage, self.giftId)
		if l_refreshType == 0 then
			self.Parameter.LimitBuy.LabText = Lang("Activity_Buy_Limit")
		elseif l_refreshType == 1 or l_refreshType == 2 then
			self.Parameter.LimitBuy.LabText = Lang("Day_Buy_Limit")
		elseif l_refreshType == 3 or l_refreshType == 4 then
			self.Parameter.LimitBuy.LabText = Lang("Week_Buy_Limit")
		end
		self.Parameter.OriginalPriceNum.LabText = MNumberFormat.GetNumberFormat(l_giftRow.Value[0][1])
		self.Parameter.PresentPriceNum.LabText = MNumberFormat.GetNumberFormat(l_giftRow.Cost[0][1])
		self.Parameter.PresentCoinIcon:SetActiveEx(not l_isFree)
		self.Parameter.PresentPriceNum:SetActiveEx(not l_isFree)

		self.Parameter.FreeText:SetActiveEx(l_isFree)

		self.Parameter.Name.LabText = l_giftRow.GiftPackageName

		self:SetShowItem(l_giftRow)

		self.Parameter.RedPoint:SetActiveEx(l_isOpen and not l_isSellOut and l_isFree)

		--self.Parameter.Btn_Buy:SetActiveEx(not l_isSellOut and l_isOpen)

		local btnStr = Lang("Buy")
		local gray = false
		if l_isOpen then
			if l_isSellOut then
				if l_isFree then
					btnStr = Common.Utils.Lang("ButtonText_AwardGetFinish")
					gray = true
				else
					btnStr = Common.Utils.Lang("MALL_SELL_OUT")
					gray = true
				end
			else
				if l_isFree then
					btnStr = Lang("Free_Get")
				end
			end
		else
			if l_isShowState then
				btnStr = Lang("DELEGATE_EMBLEM_TEMP_WORD")
			elseif l_isEnd then
				btnStr = Lang("TimeOut")
			else
				btnStr = Lang("NotOpened")
			end
			gray = true
		end
		self.Parameter.BtnTxt.LabText = btnStr
		self.Parameter.Btn_Buy:SetGray(gray)
	end
end

function MallFestivalPrefab:IsOpen()
	return self.state == GameEnum.ETimeLimitState.kTLS_Begin
end

---@param l_giftRow GiftPackageTable
function MallFestivalPrefab:SetShowItem(l_giftRow)
	if l_giftRow then	--0为显示图片，1为显示头饰，2为显示载具，3为依次显示礼包中的物品，4为时装，5为不同部位时装均显示
		if l_giftRow.PackageShow == 0 or l_giftRow.PackageShow == 3 then
			self.Parameter.Icon:SetActiveEx(true)
			self.Parameter.Model:SetActiveEx(false)
			self.Parameter.VehicleModel:SetActiveEx(false)
			self.Parameter.Btn:SetActiveEx(true)
			self.Parameter.Icon:SetSpriteAsync(l_giftRow.GiftPackageAtlas, l_giftRow.GiftPackageIcon,nil,true)
		else
			if l_giftRow.PackageShow == 2 then		--载具和衣服缩放比例不同，使用不同RT
				self.Parameter.Model:SetActiveEx(false)
				self.Parameter.VehicleModel:SetActiveEx(true)
			else
				self.Parameter.Model:SetActiveEx(true)
				self.Parameter.VehicleModel:SetActiveEx(false)
			end
			self.Parameter.Icon:SetActiveEx(false)
			self.Parameter.Btn:SetActiveEx(false)
			MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_giftRow.AwardID)
		end
	end
end

function MallFestivalPrefab:DestoryModel()
	if self.model then
		self:DestroyUIModel(self.model)
		self.model = nil
	end
end

function MallFestivalPrefab:ShowModel(giftRow,data)
	--0为显示图片，1为显示头饰，2为显示载具，3为依次显示礼包中的物品，4为时装，5为不同部位头饰和时装均显示
	if giftRow.PackageShow == 1 then
		local ids,rows = self:GetOrnament(data)
		if #ids > 0 then
			self:DestoryModel()
			self.model = Common.CommonUIFunc.CreatePlayerModel(ids,rows,self.Parameter.Model,false,true,false,false)
			self:SaveModelData(self.model)
		else
			logError("GiftPackageTable配置错误,MajorID:"..giftRow.MajorID.."显示类型为1（头饰）但是没有对应奖励没有包含头饰")
		end
	elseif giftRow.PackageShow == 4 then
		local fashionCfg = self:GetFashionID(data)
		if fashionCfg then
			self:DestoryModel()
			self.model = Common.CommonUIFunc.CreatePlayerModel({fashionCfg.ItemID},{fashionCfg},self.Parameter.Model,false,true,false,false)
			self:SaveModelData(self.model)
		else
			logError("GiftPackageTable配置错误,MajorID:"..giftRow.MajorID.."显示类型为4（时装）但是没有对应奖励没有包含时装")
		end
	elseif giftRow.PackageShow == 2 then
		local vehicleCfg = self:GetVehicleInfo(data)
		if vehicleCfg then
			self:DestoryModel()
			self.model = MgrMgr:GetMgr("VehicleInfoMgr").CreateModel(vehicleCfg.ItemID,0,0,self.Parameter.VehicleModel,self.Parameter.VehicleModelBtn)
			self:SaveModelData(self.model)
		end
	elseif giftRow.PackageShow == 5 then		-- 显示头饰和时装
		local ids,rows = self:GetAllOrnament(data)
		if #ids > 0 then
			self:DestoryModel()
			self.model = Common.CommonUIFunc.CreatePlayerModel(ids,rows,self.Parameter.Model,false,true,false,false)
			self:SaveModelData(self.model)
		else
			logError("GiftPackageTable配置错误,MajorID:"..giftRow.MajorID.."显示类型为1（头饰）但是没有对应奖励没有包含头饰")
		end
	else
		logError("GiftPackageTable配置错误,MajorID"..giftRow.MajorID.."不支持的显示类型"..giftRow.PackageShow)
	end
end

-- 头饰
function MallFestivalPrefab:GetOrnament(data)
	local ids = {}
	local itemRows = {}
	for _,v in ipairs(data.award_list) do
		local itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
		if Common.CommonUIFunc.GetItemIsOrnament(itemRow) then
			table.insert(ids,itemRow.ItemID)
			table.insert(itemRows,itemRow)
		end
	end
	return ids,itemRows
end

-- 时装
function MallFestivalPrefab:GetFashionID(data)
	for _,v in ipairs(data.award_list) do
		if TableUtil.GetFashionTable().GetRowByFashionID(v.item_id,true) ~= nil then
			local itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
			return itemRow
		end
	end
	return nil
end

-- 载具
function MallFestivalPrefab:GetVehicleInfo(data)
	for _,v in ipairs(data.award_list) do
		local itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
		if itemRow.TypeTab == GameEnum.EItemType.Vehicle then
			return itemRow
		end
	end
	return nil
end

-- 头饰和时装
function MallFestivalPrefab:GetAllOrnament(data)
	local ids = {}
	local itemRows = {}
	for _,v in ipairs(data.award_list) do
		local itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
		if TableUtil.GetFashionTable().GetRowByFashionID(v.item_id,true) ~= nil or Common.CommonUIFunc.GetItemIsOrnament(itemRow) then
			table.insert(ids,itemRow.ItemID)
			table.insert(itemRows,itemRow)
		end
	end
	return ids,itemRows
end

--lua custom scripts end
return MallFestivalPrefab