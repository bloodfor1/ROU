--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BeautyShopPanel"
require "Common/Functions"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

local LimitMgr = MgrMgr:GetMgr("LimitMgr")
local FindObjectInChild = function(...)
	return MoonCommonLib.GameObjectEx.FindObjectInChild(...)
end
local FxID = 121003
local l_fx = nil

local l_itemBag = {GameEnum.EBagContainerType.Bag,GameEnum.EBagContainerType.WareHouse,GameEnum.EBagContainerType.VirtualItem,GameEnum.EBagContainerType.HeadIcon}

--lua class define
local super = UI.UIBaseCtrl
BeautyShopCtrl = class("BeautyShopCtrl", super)
--lua class define end

--lua functions
function BeautyShopCtrl:ctor()

	super.ctor(self, CtrlNames.BeautyShop, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function BeautyShopCtrl:Init()
	self.panel = UI.BeautyShopPanel.Bind(self)
	super.Init(self)
	self.notEnoughId = nil
end --func end
--next--
function BeautyShopCtrl:Uninit()

	self:ClearFx()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BeautyShopCtrl:OnActive()
	self:CustomActive()
	self.lastPoint = nil
	MgrMgr:GetMgr("BeautyShopMgr").AddDragListener(self.panel.BGbtn.gameObject,
	function (data)
		if self.lastPoint == nil then
			self.lastPoint = data.position.x
			return
		end
		local l_dis = self.lastPoint - data.position.x
		self.lastPoint = data.position.x
		MgrMgr:GetMgr("BeautyShopMgr").UpdatePlayerRotation(l_dis)
	end,
	function (data)
		self.lastPoint = nil
	end)

	l_uiPanelConfigData = {}
	l_uiPanelConfigData.InsertPanelName = CtrlNames.BeautyShop

	UIMgr:ActiveUI(UI.CtrlNames.Currency, nil, l_uiPanelConfigData)
end --func end
--next--
function BeautyShopCtrl:OnDeActive()
	self:CustomDeActive()

end --func end
--next--
function BeautyShopCtrl:Update()


end --func end

--next--
function BeautyShopCtrl:BindEvents()
	local l_mgr = MgrMgr:GetMgr("BeautyShopMgr")
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.CHANGE_EYE_SUCCESS,function()
		self:OnChangeSuccess()
	end)
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.ON_INIT_SLIDER_VALUE,function()
		self:InitSilder()
	end)
end --func end
--next--
--lua functions end

--lua custom scripts

local l_mgr = MgrMgr:GetMgr("BeautyShopMgr")

local l_colorScroll         ---颜色滑动列表

local l_curSelectEyeIndex   ---当前眼睛
local l_curSelectEyeInfo   ---当前眼睛信息

local l_curSelectColorIndex ---当前眼睛颜色
local l_curSelectColorInfo   ---当前眼睛信息
local l_consumMon = 0		--当前的消耗

local l_bagEnough     ---道具是否充足
local l_moneyEnough   ---金钱是否充足

local l_allItem       ---全部Item
local l_curFlag       ---当前item
local l_curClick      ---当前点击item

local l_allColorItem  ---全部颜色Item
local l_curColorItem  ---当前点击颜色Item

local l_green = Color.New(90/255.0, 190/255.0, 17/255.0)
local l_red = Color.New(235/255.0, 76/255.0, 68/255.0)
local l_tips = nil

function BeautyShopCtrl:GarderobeFunc()
	local eyeId = MgrProxy:GetGarderobeMgr().JumpToEyeId
	self:OnClickEyeBtn(l_allItem[eyeId])
end

function BeautyShopCtrl:OnShow()

	self:UpdateConsum()
end

---初始化
function BeautyShopCtrl:CustomActive()
	MVirtualTab:Clear()
	l_mgr.SynEyeInfo()
	l_tips = nil
	l_curSelectEyeIndex = l_mgr.g_eyeInfo.eyeID
	l_curSelectEyeInfo = l_mgr.g_eyeInfo.eyeRowData
	l_curSelectColorIndex = l_mgr.g_eyeInfo.eyeColorID
	l_curSelectColorInfo = l_mgr.g_eyeInfo.eyeColorRowData
	l_bagEnough = false
	l_moneyEnough = false
	l_allColorItem = {}
	---颜色选中滑动列表
	l_colorScroll = self.panel.Colors:GetComponent("UIBarberScroll")
	l_colorScroll.OnValueChanged = function(idx)
		l_curSelectColorIndex = idx + 1
		l_curSelectColorInfo = l_mgr.GetEyeColorDataById(l_curSelectColorIndex)
		self:UpdatePanel()
		self:UpdatePlayer(true)
	end
	for i = 0, l_colorScroll.transform.childCount-1 do
		local l_temp = l_colorScroll.transform:GetChild(i).gameObject
		l_allColorItem[i+1] = l_temp.transform:Find("TxSelected").gameObject
	end
	l_curColorItem = l_allColorItem[l_curSelectColorIndex]
	l_curColorItem:SetActiveEx(true)

	l_colorScroll.CurrentIndex = l_curSelectColorIndex - 1

	self:InitScrollView()
	self:InitClick()
	self:UpdatePanel()
	self:InitSilder()
end

function BeautyShopCtrl:CustomDeActive()

	---重置相机状态
	MPlayerInfo:FocusToMyPlayer()
	MEntityMgr.HideNpcAndRole = false

end

function BeautyShopCtrl:InitSilder()
	local l_slider = self.panel.SliderCameraSize.gameObject:GetComponent("Slider")
	l_slider.enabled = true
	if l_mgr.m_sliderValue>0 then
		l_slider.value = l_mgr.m_sliderValue
		self.SliderValue = l_mgr.m_sliderValue
	else
		l_slider.value = 1
		self.SliderValue = 1
	end
	self.panel.SliderCameraSize:OnSliderChange(function(v)
		if math.abs(self.SliderValue-v) > 0.05 then
			MPlayerInfo:FocusOffSetValueUpdate(v)
			self.SliderValue = 1-v
		end
	end)
end
---初始化眼睛item滑动列表
function BeautyShopCtrl:InitScrollView()
	local l_allInfo = l_mgr.GetAllEyeData()
	local l_tp = self.panel.BtBarberProt.gameObject
	l_allItem = {}
	local l_realId = l_mgr.g_eyeInfo.eyeID
	l_allItem[l_realId] = {}
	l_allItem[l_realId].obj = l_tp:GetComponent("MLuaUICom")
	l_allItem[l_realId].Img = l_allItem[l_realId].obj.gameObject.transform:Find("ImgContent").gameObject:GetComponent("MLuaUICom")
	l_allItem[l_realId].info = l_mgr.g_eyeInfo.eyeRowData
	l_allItem[l_realId].Img:SetSpriteAsync(l_allItem[l_realId].info.EyeAtlas, l_allItem[l_realId].info.EyeIcon)
	l_allItem[l_realId].curflag = l_allItem[l_realId].obj.gameObject.transform:Find("ImgSelected").gameObject
	l_allItem[l_realId].curflag:SetActiveEx(true)
	l_allItem[l_realId].clickflag = l_allItem[l_realId].obj.gameObject.transform:Find("ImgTrial").gameObject
	l_allItem[l_realId].clickflag:SetActiveEx(true)
	local LockGO = FindObjectInChild(l_tp.gameObject, "NotAward")
	LockGO.gameObject:SetActiveEx(not l_mgr.CheckLimit(l_realId))
	l_curFlag = l_allItem[l_realId]
	l_curClick = l_allItem[l_realId]
	local l_sex = MPlayerInfo.IsMale and 0 or 1
	for i = 1, #l_allInfo do
		local l_id = l_allInfo[i].EyeID
		if l_id ~= l_mgr.g_eyeInfo.eyeID and l_allInfo[i].SexLimit == l_sex and not l_allInfo[i].Hide then
			local l_temp = self:CloneObj(l_tp)
			l_temp.transform:SetParent(l_tp.gameObject.transform.parent)
			l_temp.transform.localScale = l_tp.transform.localScale
			l_allItem[l_id] ={}
			l_allItem[l_id].obj = l_temp:GetComponent("MLuaUICom")
			l_allItem[l_id].Img = l_allItem[l_id].obj.gameObject.transform:Find("ImgContent").gameObject:GetComponent("MLuaUICom")
			l_allItem[l_id].info = l_allInfo[i]
			l_allItem[l_id].Img:SetSpriteAsync(l_allInfo[i].EyeAtlas, l_allInfo[i].EyeIcon)
			l_allItem[l_id].curflag = l_allItem[l_id].obj.gameObject.transform:Find("ImgSelected").gameObject
			l_allItem[l_id].curflag:SetActiveEx(false)
			l_allItem[l_id].clickflag = l_allItem[l_id].obj.gameObject.transform:Find("ImgTrial").gameObject
			l_allItem[l_id].clickflag:SetActiveEx(false)
			LockGO = FindObjectInChild(l_temp.gameObject, "NotAward")
			LockGO.gameObject:SetActiveEx(not l_mgr.CheckLimit(l_id))
		end
	end
	for i, v in pairs(l_allItem) do
		v.obj:AddClick(function ()
			self:OnClickEyeBtn(l_allItem[i])
		end)
	end


	if MgrProxy:GetGarderobeMgr().GetEnableJumpToEyeShopFlag() then
		MgrProxy:GetGarderobeMgr().EnableJumpToEyeShop(false)
		self:GarderobeFunc()
	end
end

---初始化点击事件
function BeautyShopCtrl:InitClick()
	---更换按钮
	self.panel.BtOp:AddClick(function()
		self:OnOpClick()
	end)
	---更换按钮
	self.panel.BtOpGray:AddClick(function()
		self:OnOpClick()
	end)
	---关闭按钮
	self.panel.BtClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.BeautyShop)
		self:ShowOrnament(true)
		self:UpdatePlayer(false)
	end)
	---隐藏按钮
	self.panel.TogHide:OnToggleChanged(function(v)
		self:ShowOrnament(not v)
	end)
end

---点击兑换
function BeautyShopCtrl:OnOpClick()
	if l_curSelectEyeIndex == l_mgr.g_eyeInfo.eyeID and l_curSelectColorIndex == l_mgr.g_eyeInfo.eyeColorID then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("OUTWARD_ALREADY_CURRENT"))
	else
        if self.notEnoughId ~= nil then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.notEnoughId,nil,nil,nil,true)
            return
        end
		if not l_bagEnough then
			if l_tips then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(l_tips)..Common.Utils.Lang("CLICK_NOT_ENOUGH"))
			end
		--elseif not l_moneyEnough then
			--MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_ENOUGH_ZENY"))
		else
			local msg = {}
			msg.eye_id = l_curSelectEyeIndex
			msg.eye_style_id = l_curSelectColorIndex
			msg.totalCost = l_consumMon
			l_mgr.ChangeEyeReq(msg)
		end
	end
end

---=====================================================================================================================
---选择眼睛
function BeautyShopCtrl:OnClickEyeBtn(msg)
	if l_curSelectEyeIndex == msg.info.EyeID then
		return
	end
	l_curSelectEyeIndex = msg.info.EyeID
	l_curSelectEyeInfo = msg.info

	if l_curClick then
		l_curClick.clickflag:SetActiveEx(false)
	end
	l_curClick = l_allItem[l_curSelectEyeIndex]
	l_curClick.clickflag:SetActiveEx(true)

	self:UpdatePanel()
	self:UpdatePlayer(true)
end

---=====================================================================================================================
function BeautyShopCtrl:OnUnlockEye()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("UNLOCKED")..l_curSelectEyeInfo.EyeName)
	LimitMgr.AddInEye(l_curSelectEyeInfo.EyeID)
	local LockGO = FindObjectInChild(l_allItem[l_curSelectEyeInfo.EyeID].obj.gameObject, "NotAward")
	LockGO.gameObject:SetActiveEx(not l_mgr.CheckLimit(l_curSelectEyeInfo.EyeID))
	self:UpdatePanel()
end

---更新面板
function BeautyShopCtrl:UpdatePanel()
	self:UpdateTitle()
	self:UpdateConsum()
	self:UpdateBuyBtnState()
end

---更新标题
function BeautyShopCtrl:UpdateTitle()
	if l_curSelectEyeInfo == nil then
		return
	end
	self.panel.TxName.LabText = tostring(l_curSelectEyeInfo.EyeName)
end

---更新消耗
function BeautyShopCtrl:UpdateConsum()
	local l_consumItem = nil
	l_consumMon = 0
    self.notEnoughId = nil

	if l_mgr.g_eyeInfo.eyeID ~= l_curSelectEyeIndex then
		local l_monInfo = {}
		l_monInfo = Common.Functions.SequenceToTable((l_curSelectEyeInfo.EyePrice))
		l_consumMon = l_consumMon +l_monInfo[2]
	end
	if l_mgr.g_eyeInfo.eyeColorID~= l_curSelectColorIndex then
		l_consumItem = {}
		l_consumItem = Common.Functions.VectorSequenceToTable(l_curSelectColorInfo.ItemCost)

		local l_monInfo = {}
	    l_monInfo = Common.Functions.SequenceToTable(l_curSelectColorInfo.MoneyCost)
		l_consumMon = l_consumMon +l_monInfo[2]
	end
	---金币
	--TODO:货币系统
	l_moneyEnough = true

	self.panel.TxMoney.LabText = tostring(l_consumMon)

	if MLuaCommonHelper.Long(l_consumMon) > MPlayerInfo.Coin101 then
		l_moneyEnough = false
	end
	if l_moneyEnough then
		self.panel.TxMoney.LabColor = Color.black
	else
		self.panel.TxMoney.LabColor = Color.red
	end
	self.panel.Img_huafei.gameObject:SetActiveEx(not (l_consumMon == 0))

	--道具
	for i = 1, 4 do
		self.panel.ImgCostIcon[i].gameObject:SetActiveEx(false)
	end
	l_bagEnough = true
	if l_consumItem~=nil then
		local l_index  = 1
		l_tips = nil
		for i, v in ipairs(l_consumItem) do
			local itemId = v[1]
			local count = v[2]
			local itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
			local propInfo = Data.BagModel:CreateItemWithTid(itemId)
			local l_bgAtlas = Data.BagModel:getItemBgAtlas(propInfo)
			local l_bgIcon = Data.BagModel:getItemBg(propInfo)
			self.panel.ImgCostIcon[l_index]:SetSprite(l_bgAtlas, l_bgIcon, true)
			self.panel.ImgCostIcon[l_index].gameObject:SetActiveEx(true)
			self.panel.ImgCost[l_index]:SetSpriteAsync(itemRow.ItemAtlas, itemRow.ItemIcon)
			local l_count = Data.BagApi:GetItemCountByContListAndTid(l_itemBag,itemId) --BagModel:GetBagItemCountByTid(itemId)
			--logError(itemId.." : "..l_count)
			self.panel.TxCost[l_index].LabText = tostring(l_count).."/"..tostring(count)
			self.panel.ImgCostIcon[i].gameObject:GetComponent("MLuaUICom"):AddClick(function()
				MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemId,self.panel.ImgCostIcon[i].transform)
			end)
			if count > l_count then
				l_bagEnough = false
				self.panel.TxCost[l_index].LabColor = l_red
				if l_tips == nil then
					l_tips = itemRow.ItemName
				end
                if self.notEnoughId == nil then
                    self.notEnoughId = itemId
                end
			else
				self.panel.TxCost[l_index].LabColor = l_green
			end
			l_index =l_index+1
		end
	end
	--self.panel.ItemPanel.gameObject:SetActiveEx(true)
	self.panel.BtOp.gameObject:SetActiveEx(false)
	self.panel.BtOpGray.gameObject:SetActiveEx(false)
	self.panel.BtOpGray1.gameObject:SetActiveEx(not l_mgr.CheckLimit(l_curSelectEyeInfo.EyeID))
	if l_mgr.CheckLimit(l_curSelectEyeInfo.EyeID) then
		self.panel.ItemPanel.gameObject:SetActiveEx(true)
		self.panel.LockCondition.gameObject:SetActiveEx(false)
		self.panel.BtOp.gameObject:SetActiveEx(true)
	else
		self.panel.ItemPanel.gameObject:SetActiveEx(false)
		self.panel.LockCondition.gameObject:SetActiveEx(true)
		self.panel.Img_huafei.gameObject:SetActiveEx(false)
	end
	if not l_mgr.CheckLimit(l_curSelectEyeInfo.EyeID) then
		local strTable = l_mgr.GetLimitStr(l_curSelectEyeInfo.EyeID)

		for i = 1, MgrMgr:GetMgr("BeautyShopMgr").MaxLimitCondition do
			--logError(type(l_str_tbl[i]))
			if strTable[i] ~= nil and strTable[i].limitType == LimitMgr.ELimitType.UESITEM_LIMIT then
				self:ProcessUesItemLimitGO(self.panel.UnlockItem.gameObject, strTable[i])
			end
		end
	end
end
function BeautyShopCtrl:ProcessUesItemLimitGO(gameObject, item)
	if item == nil or item.limitType ~= LimitMgr.ELimitType.UESITEM_LIMIT then
		return
	end
	gameObject:SetActiveEx(true)

	local isEnough = true
	local notisEnoughitemRow = nil
	for i = 1, #self.panel.UseCostIcon do
		if #item.UseItemSeq / 2 >= i then
			local itemId = item.UseItemSeq[i*2-1]
			local count = item.UseItemSeq[i*2]
			local itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)

			local propInfo = Data.BagModel:CreateItemWithTid(itemId)
			local l_bgAtlas = Data.BagModel:getItemBgAtlas(propInfo)
			local l_bgIcon = Data.BagModel:getItemBg(propInfo)

			self.panel.UseCostIcon[i]:SetSprite(l_bgAtlas, l_bgIcon, true)
			self.panel.UseCostIcon[i].gameObject:SetActiveEx(true)
			self.panel.UesImgCost[i]:SetSpriteAsync(itemRow.ItemAtlas, itemRow.ItemIcon)
			local l_count = Data.BagApi:GetItemCountByContListAndTid(l_itemBag,itemId)
			--logError(tostring(itemId).." : "..tostring(l_count))
			local l_strCurCount, l_strCostCount
			if MgrMgr:GetMgr("PropMgr").IsCoin(itemId) then
				l_strCurCount = MNumberFormat.GetNumberFormat(l_count)
				l_strCostCount = MNumberFormat.GetNumberFormat(count)
			else
				l_strCurCount = tostring(l_count)
				l_strCostCount = tostring(count)
			end
			if count > 100 then
				self.panel.UesTxCost[i].LabText = l_strCostCount
			else
				self.panel.UesTxCost[i].LabText = l_strCurCount .. "/" .. l_strCostCount
			end
			if count > l_count then
				isEnough = false
				self.panel.UesTxCost[i].LabColor = l_red
				notisEnoughitemRow = itemRow
			else
				self.panel.UesTxCost[i].LabColor = l_green
			end
			self.panel.UseCostIcon[i].gameObject:GetComponent("MLuaUICom"):AddClick(function()
				MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemId, self.panel.UseCostIcon[i].transform)
			end)
		else
			self.panel.UseCostIcon[i].gameObject:SetActiveEx(false)
		end
	end
	self.panel.UnlockBt.gameObject:GetComponent("MLuaUICom"):AddClick(function ()
		--logError(tostring(isEnough))
		--logError(tostring(notisEnoughitemRow.ItemName))
		if isEnough == true then
			local itemRow = TableUtil.GetItemTable().GetRowByItemID(item.UseItemSeq[1])
			local txt = StringEx.Format(Common.Utils.Lang("UnLock_Eye_Bag"), item.UseItemSeq[2],itemRow.ItemName)
			CommonUI.Dialog.ShowYesNoDlg(true, nil, txt, function()
				l_mgr.RequestUnlockEye(l_curSelectEyeIndex)
			end, function()
			end)
		else
			if notisEnoughitemRow ~= nil then
				MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(notisEnoughitemRow.ItemID, nil, nil, nil, true)
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(notisEnoughitemRow.ItemName) .. Common.Utils.Lang("CLICK_NOT_ENOUGH"))
			end
		end
	end)
	self.panel.UnlockBt_text.gameObject:GetComponent("MLuaUICom"):AddClick(function ()
		--logError(tostring(isEnough))
		--logError(tostring(notisEnoughitemRow.ItemName))
		if isEnough == true then
			local itemRow = TableUtil.GetItemTable().GetRowByItemID(item.UseItemSeq[1])
			local txt = StringEx.Format(Common.Utils.Lang("UnLock_Eye_Bag"), item.UseItemSeq[2],itemRow.ItemName)
			CommonUI.Dialog.ShowYesNoDlg(true, nil, txt, function()
				l_mgr.RequestUnlockEye(l_curSelectEyeIndex)
			end, function()
			end)
		else
			if notisEnoughitemRow ~= nil then
				MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(notisEnoughitemRow.ItemID, nil, nil, nil, true)
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(notisEnoughitemRow.ItemName) .. Common.Utils.Lang("CLICK_NOT_ENOUGH"))
			end
		end
	end)
end
---更新按钮状态
function BeautyShopCtrl:UpdateBuyBtnState()
	local gray = (not l_bagEnough or not l_moneyEnough or (l_curSelectEyeIndex == l_mgr.g_eyeInfo.eyeID and l_curSelectColorIndex == l_mgr.g_eyeInfo.eyeColorID))
	--self.panel.BtOp.gameObject:SetActiveEx(true)
	--self.panel.BtOpGray.gameObject:SetActiveEx(false)
end

---更新角色
function BeautyShopCtrl:UpdatePlayer(state)
	if state then
		MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(l_curSelectColorIndex)
		MEntityMgr.PlayerEntity.AttrComp:SetEye(l_curSelectEyeIndex)
	else
		MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(l_mgr.g_eyeInfo.eyeColorID)
		MEntityMgr.PlayerEntity.AttrComp:SetEye(l_mgr.g_eyeInfo.eyeID)
	end
end

---隐藏其他装备
function BeautyShopCtrl:ShowOrnament(show)
	if MEntityMgr.PlayerEntity == nil or MEntityMgr.PlayerEntity.AttrComp == nil then
		return
	end
	if show then
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, MPlayerInfo.OrnamentHead)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, MPlayerInfo.OrnamentFace)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, MPlayerInfo.OrnamentMouth)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, MPlayerInfo.OrnamentBack)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, MPlayerInfo.OrnamentTail)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, MPlayerInfo.OrnamentHeadFromBag, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, MPlayerInfo.OrnamentFaceFromBag, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, MPlayerInfo.OrnamentMouthFromBag, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, MPlayerInfo.OrnamentBackFromBag, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, MPlayerInfo.OrnamentTailFromBag, true)
	else
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, 0)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, 0)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, 0)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, 0)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, 0)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, 0, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, 0, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, 0, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, 0, true)
		MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, 0, true)
	end
end

---美瞳更换成功网络回调事件
function BeautyShopCtrl:OnChangeSuccess()
	if l_curColorItem then
		l_curColorItem:SetActiveEx(false)
	end
	l_allColorItem[l_mgr.g_eyeInfo.eyeColorID]:SetActiveEx(true)
	l_curColorItem = l_allColorItem[l_mgr.g_eyeInfo.eyeColorID]

	if l_curFlag then
		l_curFlag.curflag:SetActiveEx(false)
	end

	l_allItem[l_mgr.g_eyeInfo.eyeID].curflag:SetActiveEx(true)
	l_curFlag = l_allItem[l_mgr.g_eyeInfo.eyeID]
	self:UpdatePanel()
	self:UpdatePlayer(false)
	self:PlayFx()
end

function BeautyShopCtrl:PlayFx()
	self:ClearFx()
	local player = MEntityMgr.PlayerEntity
	if player == nil then
		return
	end
    local fxData = MFxMgr:GetDataFromPool()
    fxData.layer = player.Model.Layer
	l_fx = player.Model:CreateFx(FxID, EModelBone.EHelmet, fxData)
	self:SaveEffetcData(l_fx)
    MFxMgr:ReturnDataToPool(fxData)
end

function BeautyShopCtrl:ClearFx()
    if l_fx ~= nil then
        self:DestroyUIEffect(l_fx)
        l_fx = nil
    end
end

return BeautyShopCtrl
--lua custom scripts end
