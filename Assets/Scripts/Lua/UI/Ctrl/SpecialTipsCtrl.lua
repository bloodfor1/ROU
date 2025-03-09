--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SpecialTipsPanel"
require "UI/Template/ItemTemplate"
require "Common/Utils"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SpecialTipsCtrl = class("SpecialTipsCtrl", super)
--lua class define end

--lua functions
function SpecialTipsCtrl:ctor()

	super.ctor(self, CtrlNames.SpecialTips, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function SpecialTipsCtrl:Init()
	self.textObj = {}
	self.panel = UI.SpecialTipsPanel.Bind(self)
	super.Init(self)
	self.panel.RewardModel.UObj:SetActiveEx(false)
	self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })
end --func end
--next--
function SpecialTipsCtrl:Uninit()
	super.Uninit(self)
	self.itemPool = nil
	self.panel = nil
end --func end
--next--
function SpecialTipsCtrl:OnActive()
	self.panel.Btn_Ok:AddClick(function ()
		UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
	end)
	if self.uiPanelData then
		local l_openData = self.uiPanelData
        if l_openData.openType == DataMgr:GetData("TipsData").ESpecialTipsOpenType.ShowSpecialItem then
            self:ShowTipsById(l_openData.itemId,l_openData.itemCount,l_openData.btnOkFunc,l_openData.additionData,true)
		end
		if l_openData.openType == DataMgr:GetData("TipsData").ESpecialTipsOpenType.ShowSpecialStr then
            self:ShowTxtTips(l_openData.str,l_openData.btnOkFunc,l_openData.isShowCloseBtn)
		end
		if l_openData.openType == DataMgr:GetData("TipsData").ESpecialTipsOpenType.ShowSpecialItemList then
            self:ShowAwardListTips(l_openData.itemData,l_openData.btnOkFunc,l_openData.isShowCloseBtn)
		end
	end
	
	local fxAnim = self.panel.PanelRef.gameObject:GetComponent("FxAnimationHelper")
	if fxAnim then
		fxAnim:PlayAll()
	end

end --func end
--next--
function SpecialTipsCtrl:OnDeActive()
	self:DestroyRewardFx()
	self:DestroyTitleFx()
	self:DestroyEntity()
	self:DestroyTextObj()
	MgrMgr:GetMgr("PropMgr").ResetSpecialTipsData()
end --func end
--next--
function SpecialTipsCtrl:Update()

end --func end

--next--
function SpecialTipsCtrl:BindEvents()

	--dont override this function

end --func end


--next--

--lua functions end
SINGLE_BOOM_FX = "Effects/Prefabs/Creature/Ui/FX_UI_gongxihuode_Icon"	  --炸开
SINGLE_REWARD_FX = "Effects/Prefabs/Creature/Ui/fx_UI_gongxihuode_fazhan" --法阵
SINGLE_TITLE_FX = "Effects/Prefabs/Creature/Ui/Fx_ui_gongxihuode_ziti" 	  --文字
SINGLE_VEHICLE_FX = "Effects/Prefabs/Creature/Ui/Fx_Ui_ZaiJu_HuoDeFanKui_01"
MULTIPLE_REWARD_FX = "Effects/Prefabs/Creature/Ui/Fx_Ui_EWaiHuoDe_01" --多倍奖励特效


--游戏评价:显示消息
local l_rateMessage=Lang(MGlobalConfig:GetString("GameRateDressMessge"))
--游戏评价:触发的物品列表
local l_itemIds=MGlobalConfig:GetSequenceOrVectorInt("GameRateTriggerItemID")
--itemId 道具Id
--itemCount 道具数量
--btnOkFunc 点击按钮的回调
--additionData =
--{
	--titleName 标题的文字
	--ornamentId 载具配置ID
	--vehicleColor 载具颜色
--}
function SpecialTipsCtrl:ShowTipsById(itemId,itemCount,btnOkFunc,additionData,isShowCloseBtn)
	local l_itemId = itemId
	if l_itemId == nil then
		return
	end
	itemCount = tonumber(itemCount)
	local itemIdData = TableUtil.GetItemTable().GetRowByItemID(l_itemId)
	if itemIdData == nil then
		logError("ItemTable ID Error"..tostring(itemId))
		return
	end
	self:ResetUIState()
	self.panel.BthOkText.LabText = Common.Utils.Lang("DLG_BTN_OK")
	self.panel.Txt_GetItem.LabText = (additionData and additionData.titleName) and additionData.titleName or Lang("TXT_GETITEM")

	local l_itemShowStr = itemIdData.ItemName
	if tonumber(itemCount)>1 then
		l_itemShowStr = l_itemShowStr.." X "..itemCount
	end

	self.panel.Btn_Share.gameObject:SetActiveEx(false)
	--一般道具 装备和时装 创建模型
	if itemIdData.TypeTab == Data.BagModel.PropType.Weapon or itemIdData.TypeTab == Data.BagModel.PropType.Vehicle then
		self.panel.Panel_Prop.gameObject:SetActiveEx(true)
		self.panel.RewardIcon:SetSprite(itemIdData.ItemAtlas,itemIdData.ItemIcon, true)
		self.panel.RewardName.LabText = l_itemShowStr
		self.panel.RewardIcon.gameObject:SetActiveEx(false)
		self.panel.RewardName.gameObject:SetActiveEx(false)
		self.panel.Text01.gameObject:SetActiveEx(itemIdData.TypeTab == Data.BagModel.PropType.Weapon and TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) ~= nil)
		self:CreateModel(l_itemId,itemIdData,additionData)
	--头饰图纸
	elseif itemIdData.TypeTab == Data.BagModel.PropType.BluePrint or Data.BagModel.PropType.Material == itemIdData.TypeTab then
		self.panel.Panel_Item.gameObject:SetActiveEx(true)
		self.panel.ItemIcon:SetSprite(itemIdData.ItemAtlas,itemIdData.ItemIcon,true)
		self.panel.ItemButton:SetActiveEx(true)
		self.panel.ItemButton:SetSprite("Common", MGlobalConfig:GetString("ItemBluePrintBg"), true)
		self.panel.ItemName.LabText = l_itemShowStr
	elseif itemIdData.TypeTab == Data.BagModel.PropType.Card then
		--卡片tips
		self.panel.Panel_Card.gameObject:SetActiveEx(true)
		local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(itemId)
		if l_cardInfo == nil then
			logError("EquipCardTable ID Error"..tostring(itemId))
			return
		end
		local l_bgAtlas, l_bgIcon = Data.BagModel:getCardTextureBgInfo(itemId)
		self.panel.CardBG:SetSprite(l_bgAtlas, l_bgIcon)
		local l_c1,l_c2 = Data.BagModel:getCardTextureBgColor(itemId)
		self.panel.InforBG.Img.color = l_c1
		self.panel.NameBG.Img.color = l_c2

		if #self.textObj > 0 then
			for i = 1, #self.textObj do
				MResLoader:DestroyObj(self.textObj[i])
			end
			self.textObj = {}
		end
		for i = 0, l_cardInfo.CardAttributes.Length - 1 do
			local l_text = self:CloneObj(self.panel.Attr.gameObject):GetComponent("MLuaUICom")
			l_text.transform:SetParent(self.panel.Attr.transform.parent)
			l_text.transform:SetLocalScaleOne()
			l_text.gameObject:SetActiveEx(true)
			local attr ={}
			attr.type = l_cardInfo.CardAttributes[i][0]
			attr.id = l_cardInfo.CardAttributes[i][1]
			attr.val = l_cardInfo.CardAttributes[i][2]
			l_text.LabText = MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
			Common.CommonUIFunc.CalculateLowLevelTipsInfo(l_text,nil,Vector2.New(1,0.5))
			table.insert(self.textObj, l_text.gameObject)
		end
		if TableUtil.GetEquipCardTable().GetRowByID(itemId) ~= nil and MgrMgr:GetMgr("ShareMgr").CanShare_merge() then
			self.panel.Btn_Share.gameObject:SetActiveEx(true)
		end
		self.panel.Btn_Share:AddClick(function ()
			if TableUtil.GetEquipCardTable().GetRowByID(itemId) ~= nil then
				local sealrow = TableUtil.GetEquipCardSeal().GetRowBySealCardId(itemId,true)
				if  sealrow ~= nil then
					MgrMgr:GetMgr("ShareMgr").OpenShareUI(MgrMgr:GetMgr("ShareMgr").ShareID.CardShare,nil,MgrMgr:GetMgr("ShareMgr").ShareID.FashionShare,sealrow.CardId)
				else
					MgrMgr:GetMgr("ShareMgr").OpenShareUI(MgrMgr:GetMgr("ShareMgr").ShareID.CardShare,nil,MgrMgr:GetMgr("ShareMgr").ShareID.FashionShare,itemId)
				end

			end
		end)
		self.panel.Img:SetRawTex(l_cardInfo.CardTexture)
		self.panel.Name.LabText = l_cardInfo.CardName
		self.panel.Img:AddClick(function()
			--查看属性
			self.panel.InfoUI.gameObject:SetActiveEx(not self.panel.InfoUI.gameObject.activeSelf)
		end)
	else
		self.panel.Panel_Item.gameObject:SetActiveEx(true)
		self.panel.ItemIcon:SetSprite(itemIdData.ItemAtlas,itemIdData.ItemIcon,true)
		self.panel.ItemButton:SetActiveEx(false)
		self.panel.ItemName.LabText = l_itemShowStr
	end

	self.panel.Btn_Ok:AddClick(function ()
		self:DestroyEntity()
		if btnOkFunc~=nil then
			btnOkFunc()
		else
			UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
			if l_itemId~=nil then
				--游戏评价:领取的物品是符合条件时触发游戏评价
				for i = 1, l_itemIds.Length do
					if l_itemIds[i - 1] == l_itemId then
						MgrMgr:GetMgr("RateAppMgr").ShowRateDialog(nil,l_rateMessage)
						return
					end
				end
			end
		end
	end)
	self:SetCloseTipsState(isShowCloseBtn)
	self:CreateTitleFx()
	self:CreateRewardFx(itemIdData.TypeTab,additionData)
end

function SpecialTipsCtrl:ShowTxtTips(str,btnOkFunc,isShowCloseBtn)
	self:ResetUIState()
	self.panel.Panel_ShowText.gameObject:SetActiveEx(true)
	self.panel.Btn_Share.gameObject:SetActiveEx(false)
	self.panel.ShowTxtInfo.LabText = str
	self:CreateTitleFx()
	self:CreateFaZhenFx()
	self.panel.Btn_Ok:AddClick(function ()
		if btnOkFunc~=nil then
			btnOkFunc()
		else
			UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
		end
	end)
	self:SetCloseTipsState(isShowCloseBtn,btnOkFunc)
end

--是否显示关闭按钮
function SpecialTipsCtrl:SetCloseTipsState(isShowCloseBtn,btnOkFunc)
	self.panel.Btn_Ok.gameObject:SetActiveEx(isShowCloseBtn)
	self.panel.Text_Next.gameObject:SetActiveEx(not isShowCloseBtn)
	if not isShowCloseBtn then
		self.panel.Obj_Bg:AddClick(function ()
			if btnOkFunc~=nil then
				btnOkFunc()
			else
				UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
			end
		end)
	end
end

--显示奖励列表
function SpecialTipsCtrl:ShowAwardListTips(itemData,btnOkFunc,isShowCloseBtn)
	self:ResetUIState()
	self.panel.Panel_AwardList.gameObject:SetActiveEx(true)
	self.panel.Btn_Share.gameObject:SetActiveEx(false)
	self.itemPool:ShowTemplates({Datas = itemData,Parent = self.panel.Panel_AwardList.transform})
	self:CreateTitleFx()
	self:CreateFaZhenFx()
	self.panel.Btn_Ok:AddClick(function ()
		if btnOkFunc~=nil then
			btnOkFunc()
		else
			UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
		end
	end)
	self:SetCloseTipsState(isShowCloseBtn,btnOkFunc)
end

function SpecialTipsCtrl:ResetUIState( ... )
	self.panel.Panel_Prop.gameObject:SetActiveEx(false)
	self.panel.Panel_Item.gameObject:SetActiveEx(false)
	self.panel.Panel_Card.gameObject:SetActiveEx(false)
	self.panel.Panel_ShowText.gameObject:SetActiveEx(false)
	self.panel.Panel_AwardList.gameObject:SetActiveEx(false)
end

function SpecialTipsCtrl:CreateModel(itemId,itemTableData,additionData)
	if itemTableData.TypeTab == GameEnum.EItemType.Equip and TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) ~= nil then  --时装穿在身上
		local l_tempId = MUIModelManagerEx:GetTempUID()
		local l_attr = MAttrMgr:InitRoleAttr(l_tempId,tostring(l_tempId),MPlayerInfo.ProID, MPlayerInfo.IsMale, nil)
		l_attr:SetFashion(itemId)
		l_attr:SetHair(MPlayerInfo.HairStyle)
		l_attr:SetEyeColor(MPlayerInfo.EyeColorID)
		l_attr:SetEye(MPlayerInfo.EyeID)
		--【【DEV分支】【时装】【必现】玩家获取时装后不该展示其他部位饰品】
		--https://www.tapd.cn/20332331/bugtrace/bugs/view/1120332331001075575
		--l_attr:SetOrnament(MPlayerInfo.OrnamentHead)
		--l_attr:SetOrnament(MPlayerInfo.OrnamentFace)
		local l_fxData = {}
		l_fxData.rawImage = self.panel.RewardModel.RawImg
		l_fxData.attr = l_attr
		l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)

		self.modelEntity = self:CreateUIModel(l_fxData)

		local animPath = l_attr.CommonIdleAnimPath
		if l_attr.EquipData ~= nil and l_attr.EquipData.FashionItemID > 0 then
			local fashionRow = TableUtil.GetFashionTable().GetRowByFashionID(l_attr.EquipData.FashionItemID, true)
			if fashionRow ~= nil and fashionRow.IdleAnim ~= nil and fashionRow.IdleAnim ~= "" then
				animPath = MAnimationMgr:GetClipPath(fashionRow.IdleAnim)
			end
		end
		self.modelEntity.Ator:OverrideAnim("Idle", animPath)

		self.panel.RewardModel:SetActiveEx(false)
		self.modelEntity:AddLoadModelCallback(function(m)
			self.tween = self.modelEntity.Trans:DOLocalRotate(Vector3.New(0,0,0), 4)
			self.tween:SetLoops(-1,DG.Tweening.LoopType.Incremental)
			self.tween:SetEase(DG.Tweening.Ease.Linear)
			self.panel.RewardModel:SetActiveEx(true)
			if TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) ~= nil and MgrMgr:GetMgr("ShareMgr").CanShare_merge() then
				self.panel.Btn_Share.gameObject:SetActiveEx(true)
			end
		end)
		self.panel.Btn_Share:AddClick(function ()
			if TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) ~= nil then
				MgrMgr:GetMgr("ShareMgr").OpenShareUI(MgrMgr:GetMgr("ShareMgr").ShareID.FashionShare,l_attr,MgrMgr:GetMgr("ShareMgr").ShareID.FashionShare,itemId)
			end
		end)
	else
		self.modelObj = nil
		local equipData = nil
		--载具类型的处理
		if itemTableData.TypeTab == 14 then
			--OrnamentId 载具配置ID
			--VehicleColor 载具颜色
			local ornamentId = (additionData and additionData.ornamentId) and additionData.ornamentId or nil
			local vehicleColor = (additionData and additionData.vehicleColor) and additionData.vehicleColor or nil
			self.modelObj = MgrMgr:GetMgr("VehicleInfoMgr").CreateModel(itemId,ornamentId,vehicleColor,self.panel.RewardModel)
			self:SaveModelData(self.modelObj)
		else
			equipData = TableUtil.GetEquipTable().GetRowById(itemId)
			--装备类型没有模型显示图标  武器也不能显示 武器没有Prefab
			if equipData and equipData.EquipId == 1 or equipData.EquipId == 2 or equipData.EquipId == 3 or equipData.EquipId == 4 or equipData.EquipId == 5 or equipData.EquipId == 6 then
				self.panel.RewardIcon.gameObject:SetActiveEx(true)
				self.panel.RewardName.gameObject:SetActiveEx(true)
				return
			end
			--装备类型有模型处理
			self.panel.RewardModel:SetActiveEx(false)
			local l_modelData = 
			{
				itemId = itemId,
				rawImage = self.panel.RewardModel.RawImg
			}
			self.modelObj = self:CreateUIModelByItemId(l_modelData)
		end
		if self.modelObj then
			self.modelObj:AddLoadModelCallback(function(m)
				local setTween = function()
					self.tween = self.modelObj.Trans:DOLocalRotate(Vector3.New(self.modelObj.Trans.localEulerAngles.x,360,0), 4)
					self.tween:SetLoops(-1,DG.Tweening.LoopType.Incremental)
					self.tween:SetEase(DG.Tweening.Ease.Linear)
				end
				if equipData then
					if equipData.EquipId == 7 or equipData.EquipId == 8 or equipData.EquipId == 9 or equipData.EquipId == 10 then
						self.modelObj.Trans:SetLocalRotEuler(-90,-180,0)
						self.modelObj.Trans:SetLocalPos(0,self:SetPosByType(equipData.EquipId),0)
					end
					--面饰和嘴饰不旋转
					if equipData.EquipId ~= 8 or equipData.EquipId ~= 9 then
						setTween()
					end
				end
				if itemTableData.TypeTab == 14 then
					setTween()
				end
				self.panel.RewardModel.UObj:SetActiveEx(true)
				local OrRow = TableUtil.GetOrnamentTable().GetRowByOrnamentID(itemId,true)
				if  OrRow ~= nil and OrRow.IsShare == 1 and MgrMgr:GetMgr("ShareMgr").CanShare_merge() then
					self.panel.Btn_Share.gameObject:SetActiveEx(true)
				end
			end)
			self.panel.Btn_Share:AddClick(function ()
				if TableUtil.GetOrnamentTable().GetRowByOrnamentID(itemId,true) ~= nil then
					MgrMgr:GetMgr("ShareMgr").OpenShareUI(MgrMgr:GetMgr("ShareMgr").ShareID.OrnamentShare,l_modelData,MgrMgr:GetMgr("ShareMgr").ShareID.OrnamentShare,itemId)
				end
			end)
		end
	end
end

function SpecialTipsCtrl:SetPosByType(itemType)
	if itemType == 7 then
		return 0.75
	elseif itemType == 8 then
		return 0.9
	elseif itemType == 9 then
		return 1.15
	elseif itemType == 10 then
		return 0.9
	end
	return 0.5
end

--设置坐骑的缩放
function SpecialTipsCtrl:SetModleSize(objTrans)
	local bundSize = nil
	local bounds = nil
	if objTrans.gameObject:GetComponent("Renderer") then
		bundSize = objTrans.gameObject:GetComponent("Renderer").bounds.size
		bounds = objTrans.gameObject:GetComponent("Renderer").bounds
	else
		bundSize = objTrans:GetChild(0).gameObject:GetComponent("Renderer").bounds.size
		bounds = objTrans:GetChild(0).gameObject:GetComponent("Renderer").bounds
	end

	if bundSize == nil then
		logError("Check Object Renderer Compent")
		return
	end

	local maxSize = math.max(bundSize.x,bundSize.y,bundSize.z)
	local StandScale = 1.3/maxSize
	objTrans:SetLocalScale(StandScale,StandScale,StandScale)
	objTrans:SetLocalPos(0,StandScale/2,0)
end

function SpecialTipsCtrl:CreateTitleFx()
	self:DestroyTitleFx()
	if self.titleFxId == 0 or self.titleFxId == nil then
		local l_fxData = {}
		l_fxData.rawImage = self.panel.Raw_EffBg.RawImg
		l_fxData.destroyHandler = function ()
			self.titleFxId = 0
		end
		l_fxData.loadedCallback = function(go)
			go.transform:SetLocalPos(0,0.62,0)
			go.transform:SetLocalScale(1.1,1.1,1.1)
		end
		self.titleFxId = self:CreateUIEffect(SINGLE_TITLE_FX,l_fxData)
		
	end
end

function SpecialTipsCtrl:CreateFaZhenFx()
	self:DestroyTitleFx()
	if self.rewardEffectId == 0 or self.rewardEffectId == nil then
		local l_fxData = {}
		l_fxData.rawImage = self.panel.Raw_EffBg.RawImg
		l_fxData.destroyHandler = function ()
			self.rewardEffectId = 0
		end
		l_fxData.loadedCallback = function(go)
			go.transform:SetLocalScale(1.1,1.1,1.1)
		end
		self.rewardEffectId = self:CreateUIEffect(SINGLE_REWARD_FX,l_fxData)
		
	end
end

function SpecialTipsCtrl:DestroyTitleFx( ... )
	if self.titleFxId and self.titleFxId ~= 0 then
		self:DestroyUIEffect(self.titleFxId)
		self.titleFxId = 0
	end
end

function SpecialTipsCtrl:CreateRewardFx(itemType,additionData)
	self:DestroyRewardFx()
	self:CreateFaZhenFx()
	if additionData~=nil and additionData.playMultipleRewardEffect then
		if self.multipleRewardEffectId == 0 or self.multipleRewardEffectId == nil then
			local l_fxData = {}
			l_fxData.rawImage = self.panel.Raw_MultipleEffectBg.RawImg
			l_fxData.destroyHandler = function ()
				self.multipleRewardEffectId = 0
			end
			l_fxData.loadedCallback = function(go)
				go.transform:SetLocalScale(1,1,1)
			end
			self.multipleRewardEffectId = self:CreateUIEffect(MULTIPLE_REWARD_FX,l_fxData)
			
		end
	end
	if self.boomEffectId == 0 or self.boomEffectId == nil then
		local l_fxData = {}
		l_fxData.rawImage = self.panel.Raw_EffBg.RawImg
		l_fxData.destroyHandler = function ()
			self.boomEffectId = 0
		end
		l_fxData.loadedCallback = function(go)
			go.transform:SetLocalScale(1,1,1)
		end
		self.boomEffectId = self:CreateUIEffect(SINGLE_BOOM_FX,l_fxData)
		
	end

	if itemType and itemType == Data.BagModel.PropType.Vehicle then
		if self.vehicleEffectId == 0 or self.vehicleEffectId == nil then
			local l_fxData = {}
			l_fxData.rawImage = self.panel.Raw_EffBg.RawImg
			l_fxData.destroyHandler = function ()
				self.vehicleEffectId = 0
			end
			l_fxData.loadedCallback = function(go)
				go.transform:SetLocalScale(0.8,0.8,0.8)
				go.transform:SetLocalPos(0,-0.5,0)
			end
			self.vehicleEffectId = self:CreateUIEffect(SINGLE_VEHICLE_FX,l_fxData)
			
		end
	end
end

function SpecialTipsCtrl:DestroyRewardFx( ... )
	if self.rewardEffectId and self.rewardEffectId ~= 0 then
		self:DestroyUIEffect(self.rewardEffectId)
		self.rewardEffectId = 0
	end
	if self.multipleRewardEffectId and self.multipleRewardEffectId ~= 0 then
		self:DestroyUIEffect(self.multipleRewardEffectId)
		self.multipleRewardEffectId = 0
	end

	if self.boomEffectId and self.boomEffectId ~= 0 then
		self:DestroyUIEffect(self.boomEffectId)
		self.boomEffectId = 0
	end
	if self.vehicleEffectId and self.vehicleEffectId ~= 0 then
		self:DestroyUIEffect(self.vehicleEffectId)
		self.vehicleEffectId = 0
	end
end

function SpecialTipsCtrl:DestroyEntity()
	if self.modelEntity then
		self:DestroyUIModel(self.modelEntity)
		self.modelEntity = nil
	end
	if self.modelObj  then
		self:DestroyUIModel(self.modelObj)
		self.modelObj  = nil
	end
	if self.tween then
		self.tween:Kill()
		self.tween = nil
	end
end

function SpecialTipsCtrl:DestroyTextObj( ... )
	if #self.textObj > 0 then
		for i = 1, #self.textObj do
			MResLoader:DestroyObj(self.textObj[i])
		end
		self.textObj = {}
	end
end
--lua custom scripts

--lua custom scripts end
return SpecialTipsCtrl