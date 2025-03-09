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
--next--
--lua fields end

--lua class define
---@class CommonItemTipsBaseTemplentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Unidentified MoonClient.MLuaUICom
---@field Type03 MoonClient.MLuaUICom
---@field Type02 MoonClient.MLuaUICom
---@field Type01 MoonClient.MLuaUICom
---@field txtWeightNum MoonClient.MLuaUICom
---@field txtTipType MoonClient.MLuaUICom
---@field txtTipName MoonClient.MLuaUICom
---@field txtTipLevel MoonClient.MLuaUICom
---@field txtTipId MoonClient.MLuaUICom
---@field txtRemainingTime MoonClient.MLuaUICom
---@field txtJianDing MoonClient.MLuaUICom
---@field TxtHref MoonClient.MLuaUICom
---@field txtDes MoonClient.MLuaUICom
---@field Txt_RemainUseCount MoonClient.MLuaUICom
---@field suitTpl MoonClient.MLuaUICom
---@field suitPanel MoonClient.MLuaUICom
---@field skillName MoonClient.MLuaUICom[]
---@field sexPanel MoonClient.MLuaUICom
---@field sexName MoonClient.MLuaUICom
---@field Seal MoonClient.MLuaUICom
---@field ReplacerPanel MoonClient.MLuaUICom
---@field ReplacerNamePanel MoonClient.MLuaUICom
---@field ReplacerName MoonClient.MLuaUICom
---@field ReplacerDuarableValue MoonClient.MLuaUICom
---@field ReplacerAttrTpl MoonClient.MLuaUICom
---@field RefineSeal MoonClient.MLuaUICom
---@field refinePanel MoonClient.MLuaUICom
---@field RefineName MoonClient.MLuaUICom
---@field RefineLv MoonClient.MLuaUICom
---@field RefineCount_5 MoonClient.MLuaUICom
---@field RefineCount_4 MoonClient.MLuaUICom
---@field RefineCount_3 MoonClient.MLuaUICom
---@field RefineCount_2 MoonClient.MLuaUICom
---@field RefineCount_1 MoonClient.MLuaUICom
---@field RefineCount_0 MoonClient.MLuaUICom
---@field QualityPanel MoonClient.MLuaUICom
---@field professionPanel MoonClient.MLuaUICom
---@field professionName MoonClient.MLuaUICom
---@field NoRefineText MoonClient.MLuaUICom
---@field NoEnchantText MoonClient.MLuaUICom
---@field ImgTipIconBg MoonClient.MLuaUICom
---@field imgTipIcon MoonClient.MLuaUICom
---@field imgStar MoonClient.MLuaUICom[]
---@field imgQuality MoonClient.MLuaUICom[]
---@field imgHole MoonClient.MLuaUICom[]
---@field imgFengexian MoonClient.MLuaUICom
---@field imageEquipFlag MoonClient.MLuaUICom
---@field Image_2 MoonClient.MLuaUICom
---@field Image_1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field holeTpl MoonClient.MLuaUICom
---@field holePanel MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field GenrePanel MoonClient.MLuaUICom
---@field enchantTpl MoonClient.MLuaUICom
---@field enchantPanel MoonClient.MLuaUICom
---@field enchantName MoonClient.MLuaUICom
---@field detailTrans MoonClient.MLuaUICom
---@field DetailInfoScroll MoonClient.MLuaUICom
---@field DetailInfo MoonClient.MLuaUICom
---@field DestroyImage MoonClient.MLuaUICom
---@field DestroyFlag MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom
---@field customPanel MoonClient.MLuaUICom
---@field customContext MoonClient.MLuaUICom
---@field CommonItemTipsBaseObj MoonClient.MLuaUICom
---@field cardPostionText MoonClient.MLuaUICom
---@field cardPostionPanel MoonClient.MLuaUICom
---@field cardImage MoonClient.MLuaUICom
---@field CardFragmentFlag MoonClient.MLuaUICom
---@field CardBg MoonClient.MLuaUICom
---@field card MoonClient.MLuaUICom
---@field CantRefineText MoonClient.MLuaUICom
---@field CantEnchantText MoonClient.MLuaUICom
---@field btnHuoqu MoonClient.MLuaUICom
---@field btnGM MoonClient.MLuaUICom
---@field BindPanel MoonClient.MLuaUICom
---@field beiluzPlace MoonClient.MLuaUICom[]
---@field beiluzLifeRemain MoonClient.MLuaUICom
---@field beiluziPanel MoonClient.MLuaUICom
---@field AttrTpl MoonClient.MLuaUICom[]
---@field attrTpl MoonClient.MLuaUICom
---@field attrPanel MoonClient.MLuaUICom
---@field AttrList MoonClient.MLuaUICom
---@field attrDesc MoonClient.MLuaUICom[]
---@field Attr MoonClient.MLuaUICom
---@field TxtCanAddTime MoonClient.MLuaUICom

---@class CommonItemTipsBaseTemplent : BaseUITemplate
---@field Parameter CommonItemTipsBaseTemplentParameter

CommonItemTipsBaseTemplent = class("CommonItemTipsBaseTemplent", super)
--lua class define end

--lua functions
function CommonItemTipsBaseTemplent:Init()

    super.Init(self)
    for k, v in pairs(self.Parameter) do
        self[k] = v
    end
    self.cardTemplate = nil
    self.titleTemplate = nil
    self.Parameter.txtJianDing:SetActiveEx(false)
    self.Parameter.IconEffectImage:SetActiveEx(false)

end --func end
--next--
function CommonItemTipsBaseTemplent:OnDestroy()

    self.Parameter.IconEffectImage:StopDynamicEffect()

end --func end
--next--
function CommonItemTipsBaseTemplent:OnDeActive()

    -- do nothing

end --func end
--next--
function CommonItemTipsBaseTemplent:OnSetData(data)

    self.Parameter.data = data

end --func end
--next--
function CommonItemTipsBaseTemplent:BindEvents()
    local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
    self:BindEvent(l_limitMgr.EventDispatcher, l_limitMgr.LIMIT_BUY_COUNT_UPDATE, function(self, type, id)
        self:RefreshInfo()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")

local l_propQualitySp = {
    [0] = "UI_Common_Iconbigframe_01.png",
    [1] = "UI_Common_Iconbigframe_03.png",
    [2] = "UI_Common_Iconbigframe_04.png",
    [3] = "UI_Common_Iconbigframe_05.png",
    [4] = "UI_Common_Iconbigframe_06.png" }

local super = UITemplate.BaseUITemplate
function CommonItemTipsBaseTemplent:ctor(data)
    data.TemplatePath = "UI/Prefabs/CommonItemTips/CommonItemTipsBaseComponent"
    data.Data = {}
    super.ctor(self, data)
end

--填进去一个Item的显示
function CommonItemTipsBaseTemplent:FillOneItemInfo(oneItem)
    self.shownOneItem = oneItem
    self.Parameter.LuaUIGroup.gameObject:SetActiveEx(true)
    self:ResetTips(oneItem)
    self:FillItemHead(oneItem)
    self:FillItemAttr(oneItem)
    self:AutoSize(oneItem)
    self:SetLine(oneItem)
    self:_showDestroy(oneItem)
end

function CommonItemTipsBaseTemplent:RefreshInfo()
    if self.shownOneItem then
        self:FillOneItemInfo(self.shownOneItem)
    end
end

function CommonItemTipsBaseTemplent:ResetTips(oneItem)
    oneItem.txtTipId:SetActiveEx(MGameContext.IsOpenGM)
    oneItem.btnGM:SetActiveEx(MGameContext.IsOpenGM)
    oneItem.RefineLv:SetActiveEx(false)
    oneItem.Unidentified:SetActiveEx(false)
    oneItem.Damage:SetActiveEx(false)
    oneItem.Seal:SetActiveEx(false)
    oneItem.QualityPanel:SetActiveEx(false)
    oneItem.btnHuoqu:SetActiveEx(false)
    oneItem.holeTpl:SetActiveEx(false)
    oneItem.AttrList:SetActiveEx(false)
    oneItem.attrPanel:SetActiveEx(false)
    oneItem.attrTpl:SetActiveEx(false)
    oneItem.cardPostionPanel:SetActiveEx(false)
    oneItem.ReplacerPanel:SetActiveEx(false)
    oneItem.holePanel:SetActiveEx(false)
    oneItem.refinePanel:SetActiveEx(false)
    oneItem.enchantPanel:SetActiveEx(false)
    oneItem.GenrePanel:SetActiveEx(false)
    oneItem.sexPanel:SetActiveEx(false)
    oneItem.professionPanel:SetActiveEx(false)
    oneItem.BindPanel:SetActiveEx(false)
    oneItem.CardFragmentFlag:SetActiveEx(false)
    --该组件暂时没有用到
    oneItem.GenrePanel:SetActiveEx(false)
    oneItem.imageEquipFlag:SetActiveEx(false)
    oneItem.card:SetActiveEx(false)
    --还原
    self:SetToHeadByState(oneItem, 1)
end

--设置Head
function CommonItemTipsBaseTemplent:FillItemHead(oneItem)
    ---@type ItemData
    local itemData = oneItem.data.baseData

    --基础属性设置
    self:_showItemName(oneItem, itemData:GetName())
    oneItem.txtTipId.LabText = "Id:" .. oneItem.data.itemTableData.ItemID
    oneItem.txtTipType.LabText = Common.CommonUIFunc.GetEquipTypeName(oneItem.data.itemTableData)
    oneItem.txtTipLevel.LabText = Common.CommonUIFunc.GetLevelStr(oneItem.data.itemTableData.LevelLimit)
    oneItem.txtWeightNum.LabText = itemData:GetWeight()
    --oneItem.txtWeightNum.LabText = math.floor(tonumber(oneItem.data.itemTableData.Weight) * 10 + 0.5) / 10
    oneItem.imgTipIcon:SetSprite(oneItem.data.itemTableData.ItemAtlas, oneItem.data.itemTableData.ItemIcon, true)
    if oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Head or oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Title then
        self:SetToHeadByState(oneItem, 0)
    end

    oneItem.ImgTipIconBg:SetActiveEx(false)
    oneItem.CardBg:SetActiveEx(false)
    if oneItem.data.itemTableData ~= nil and oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Card then
        oneItem.CardBg:SetActiveEx(true)
        if oneItem.data.baseData:GetRemainingTime() > 0 then
            oneItem.IconEffectImage:PlayDynamicEffect()
        end
    else
        oneItem.ImgTipIconBg:SetActiveEx(true)
        local l_bgName = nil
        local l_type = itemData.ItemConfig.TypeTab
        if l_type ~= Data.BagModel.PropType.BluePrint and l_type ~= Data.BagModel.PropType.Card then
            l_bgName = l_propQualitySp[itemData.ItemConfig.ItemQuality]
        end

        if l_bgName == nil then
            l_bgName = Data.BagModel:getItemBg(itemData)
        end

        oneItem.ImgTipIconBg:SetSprite("Common", l_bgName)
    end

    --是卡片 特殊处理信息
    if oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Card then
        local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(oneItem.data.itemTableData.ItemID)
        oneItem.card:SetActiveEx(true)
        oneItem.cardImage:SetRawTex(l_cardInfo.CardTexture)
        oneItem.detailTrans:SetActiveEx(false)
        oneItem.imgFengexian:SetActiveEx(false)
    else
        oneItem.imgTipIcon.gameObject:SetActiveEx(true)
        oneItem.detailTrans:SetActiveEx(oneItem.data.itemTableData and oneItem.data.itemTableData.ItemDescription ~= "")
        oneItem.imgFengexian:SetActiveEx(true)
        if oneItem.data.itemTableData.ItemDescription ~= "" then
            oneItem.txtDes.LabText = Lang(oneItem.data.itemTableData.ItemDescription)
            -- 打宝糖次数显示
            local l_functionRow = TableUtil.GetItemFunctionTable().GetRowByItemId(oneItem.data.itemTableData.ItemID, true)
            if l_functionRow and l_functionRow.ItemFunction == GameEnum.EItemFunctionType.DaBaoTang then
                local l_count, l_limit, l_timeStr = MgrMgr:GetMgr("AutoFightItemMgr").GetDaBaoTangCountAndLimitAndTimeStr(oneItem.data.itemTableData.ItemID)
                oneItem.txtDes.LabText = StringEx.Format("{0}\n{1}", Lang(oneItem.data.itemTableData.ItemDescription), RoColor.FormatWord(Lang("DA_BAO_COUNT", l_timeStr, l_limit - l_count)))
            end
        end

        oneItem.txtDes:SetActiveEx(oneItem.data.itemTableData.ItemDescription ~= "")
        oneItem.imgTipIcon:SetSprite(itemData.ItemConfig.ItemAtlas, itemData.ItemConfig.ItemIcon)
        self:FillItemHrefInfo(oneItem)
        self:FillTitleStickerInfo(oneItem)
    end
    -- 封印卡片处理
    if MgrMgr:GetMgr("SealCardMgr").IsSealCard(oneItem.data.baseData.TID) then
        self:FillSealCardInfo(oneItem)
    end

    --GM按钮设置
    oneItem.btnGM:AddClick(function()
        if MgrMgr:GetMgr("PropMgr").IsCoin(oneItem.data.itemTableData.ItemID) then
            MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("addmoney {0} 1000000", oneItem.data.itemTableData.ItemID))
        else
            MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("{0} 10", oneItem.data.itemTableData.ItemID))
        end
    end)

    if nil ~= itemData.EquipConfig then
        oneItem.RefineLv:SetActiveEx(0 < itemData.RefineLv)
        oneItem.RefineLv.LabText = StringEx.Format("+{0}", itemData.RefineLv)
        oneItem.Damage:SetActiveEx(itemData.Damaged)
        oneItem.Seal:SetActiveEx(0 < itemData.RefineSealLv)
        oneItem.QualityPanel.gameObject:SetActiveEx(itemData:IsEquipRareStyle())
    end

    --职业设置 全职业不显示
    local professionStr, isFull = Common.CommonUIFunc.GetProfessionStr(oneItem.data.itemTableData.Profession)
    oneItem.professionPanel:SetActiveEx(not isFull)
    oneItem.professionName.LabText = professionStr

    --是否显示获取途径
    if Common.CommonUIFunc.isItemHaveExport(tonumber(oneItem.data.itemTableData.ItemID)) then
        oneItem.btnHuoqu.gameObject:SetActiveEx(true)
        oneItem.btnHuoqu:AddClick(function()
            UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(l_ui)
                l_ui:InitItemAchievePanelByItemId(tonumber(oneItem.data.itemTableData.ItemID))
            end)
        end)
    end

    --性别限制 2=无限制 无限制不显示性别相关属性
    oneItem.sexPanel:SetActiveEx(not oneItem.data.itemTableData.SexLimit == 2)
    oneItem.sexName.LabText = Common.CommonUIFunc.GetSexStr(oneItem.data.itemTableData.SexLimit)
    oneItem.imageEquipFlag:SetActiveEx(false)

    --判断是否具有时效
    oneItem.TxtCanAddTime:SetActiveEx(false)
    if GameEnum.EItemTimeType.AddTime == itemData:GetItemTimeType() and itemData:IsFakeItem() then
        oneItem.TxtCanAddTime:SetActiveEx(true)
        oneItem.TxtCanAddTime.LabText = Common.Utils.Lang("C_TIME_CAN_ADD")
    end

    if 0 >= itemData:GetRemainingTime() or itemData:IsFakeItem() or itemData:ItemMatchesType(GameEnum.EItemType.BelluzGear) then
        oneItem.txtRemainingTime:SetActiveEx(false)
    else
        oneItem.txtRemainingTime.LabText = Data.BagModel:GetRemainingTimeFormat(oneItem.data.baseData)
        oneItem.txtRemainingTime:SetActiveEx(true)
    end

    --判断是否有使用次数限制
    if itemData:ItemMatchesType(GameEnum.EItemType.CountLimit) then
        oneItem.Txt_RemainUseCount.LabText = Lang("REMAIN_REWARD_COUNT", itemData:GetRemainUseCount())
        oneItem.Txt_RemainUseCount:SetActiveEx(true)
    else
        oneItem.Txt_RemainUseCount:SetActiveEx(false)
    end

    --特殊处理摆摊物品待计时
    if oneItem.data.stallOverTimeStr then
        oneItem.txtRemainingTime.LabText = oneItem.data.stallOverTimeStr
        oneItem.txtRemainingTime:SetActiveEx(true)
    end

    if oneItem.data.itemTableData.TypeTab ~= nil then
        oneItem.CardFragmentFlag:SetActiveEx(oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.CardFragment)
    end
end

--设置Tips超链接信息
function CommonItemTipsBaseTemplent:FillItemHrefInfo(oneItem)
    --材料
    if oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Material then
        local ItemExchangeOrnamentInfo, ItemExchangeEquipInfo = Common.CommonUIFunc.CheckItemExcnageInfo(oneItem.data.itemTableData.ItemID)
        local ItemVechicleInfo = Common.CommonUIFunc.GetVehicleExchangeInfo(oneItem.data.itemTableData.ItemID)
        if (ItemExchangeOrnamentInfo and #ItemExchangeOrnamentInfo > 0)
                or (ItemExchangeEquipInfo and #ItemExchangeEquipInfo > 0)
                or (ItemVechicleInfo and #ItemVechicleInfo > 0) then
            oneItem.TxtHref:SetActiveEx(true)
            oneItem.TxtHref.LabText = "<a href=ItemUseful><color=$$Blue$$>[" .. Lang("CAN_EXCHANGE_MAT") .. "]</color></a>"
            oneItem.TxtHref.LabRayCastTarget = true
            oneItem.TxtHref:GetRichText().onHrefClick:RemoveAllListeners()
            oneItem.TxtHref:GetRichText().onHrefClick:AddListener(function(key)
                if key == "ItemUseful" then
                    UIMgr:DeActiveUI(UI.CtrlNames.ItemUsefulTips)
                    UIMgr:ActiveUI(UI.CtrlNames.ItemUsefulTips, function(ctrl)
                        ctrl:ShowMaterialUseFulPanel(ItemExchangeOrnamentInfo, ItemExchangeEquipInfo, ItemVechicleInfo, oneItem.data.itemTableData)
                    end)
                end
            end)
            return
        end
    end

    --图纸
    if oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.BluePrint then
        local ItemExchangeOrnamentInfo, ItemExchangeEquipInfo = Common.CommonUIFunc.CheckItemExcnageInfo(oneItem.data.itemTableData.ItemID)
        local ItemVechicleInfo = Common.CommonUIFunc.GetVehicleExchangeInfo(oneItem.data.itemTableData.ItemID)
        if ItemExchangeOrnamentInfo and #ItemExchangeOrnamentInfo > 0 then
            oneItem.TxtHref:SetActiveEx(true)
            oneItem.TxtHref.LabText = "<a href=openBarberShop><color=$$Blue$$>[" .. Lang("CAN_EXCHANGE_BARBER") .. "]</color></a>"
            oneItem.TxtHref.LabRayCastTarget = true
            oneItem.TxtHref:GetRichText().onHrefClick:RemoveAllListeners()
            oneItem.TxtHref:GetRichText().onHrefClick:AddListener(function(key)
                if key == "openBarberShop" then
                    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                    MgrProxy:GetGarderobeMgr().OpenGarderobeWithItemId(ItemExchangeOrnamentInfo[1])
                end
            end)
            return
        end
        if ItemExchangeEquipInfo and #ItemExchangeEquipInfo > 0 then
            oneItem.TxtHref:SetActiveEx(true)
            oneItem.TxtHref.LabText = "<a href=openEquipForge><color=$$Blue$$>[" .. Lang("CAN_EQUIP_FORGE") .. "]</color></a>"
            oneItem.TxtHref.LabRayCastTarget = true
            oneItem.TxtHref:GetRichText().onHrefClick:RemoveAllListeners()
            oneItem.TxtHref:GetRichText().onHrefClick:AddListener(function(key)
                if key == "openEquipForge" then
                    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                    Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.IllustratorEquip, { ItemExchangeEquipInfo[1] })
                end
            end)
            return
        end
        if ItemVechicleInfo and #ItemVechicleInfo > 0 then
            oneItem.TxtHref:SetActiveEx(true)
            oneItem.TxtHref.LabText = "<a href=exchangeVehicle><color=$$Blue$$>[" .. Lang("CAN_EXCHANGE_VEHIVLE") .. "]</color></a>"
            oneItem.TxtHref.LabRayCastTarget = true
            oneItem.TxtHref:GetRichText().onHrefClick:RemoveAllListeners()
            oneItem.TxtHref:GetRichText().onHrefClick:AddListener(function(key)
                if key == "exchangeVehicle" then
                    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.VehicleAbility) then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SYSTEM_DONT_OPEN"))
                        return
                    end
                    local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
                    l_vehicleInfoMgr.ShowVehicleCharacteristicPanel(ItemVechicleInfo[1])
                end
            end)
            return
        end
    end

    --人物模型
    if oneItem.data.itemTableData.Subclass == 103 or
            oneItem.data.itemTableData.Subclass == 104 or
            oneItem.data.itemTableData.Subclass == 105 or
            oneItem.data.itemTableData.Subclass == 106 or
            oneItem.data.itemTableData.Subclass == 202 then
        oneItem.TxtHref:SetActiveEx(true)
        oneItem.TxtHref.LabText = "<a href=openModel><color=$$Blue$$>[" .. Lang("MODEL_VIEW") .. "]</color></a>"
        oneItem.TxtHref.LabRayCastTarget = true
        oneItem.TxtHref:GetRichText().onHrefClick:RemoveAllListeners()
        oneItem.TxtHref:GetRichText().onHrefClick:AddListener(function(key)
            if key == "openModel" then
                UIMgr:DeActiveUI(UI.CtrlNames.ItemUsefulTips)
                UIMgr:ActiveUI(UI.CtrlNames.ItemUsefulTips, function(ctrl)
                    ctrl:ModelViewer(oneItem.data.itemTableData)
                end)
            end
        end)
        return
    end
    --时装
    if oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Weapon and
            TableUtil.GetFashionTable().GetRowByFashionID(oneItem.data.itemTableData.ItemID, true) ~= nil then
        oneItem.TxtHref:SetActiveEx(true)
        oneItem.TxtHref.LabText = "<a href=openModel><color=$$Blue$$>[" .. Lang("MODEL_VIEW") .. "]</color></a>"
        oneItem.TxtHref.LabRayCastTarget = true
        oneItem.TxtHref:GetRichText().onHrefClick:RemoveAllListeners()
        oneItem.TxtHref:GetRichText().onHrefClick:AddListener(function(key)
            if key == "openModel" then
                UIMgr:DeActiveUI(UI.CtrlNames.ItemUsefulTips)
                UIMgr:ActiveUI(UI.CtrlNames.ItemUsefulTips, function(ctrl)
                    ctrl:ModelViewer(oneItem.data.itemTableData)
                end)
            end
        end)
        return
    end
    oneItem.TxtHref:SetActiveEx(false)
end

--设置属性
function CommonItemTipsBaseTemplent:FillItemAttr(oneItem)
    if not oneItem.basicAttr then
        oneItem.basicAttr = {}
    end
    if not oneItem.entryAttr then
        oneItem.entryAttr = {}
    end
    if not oneItem.replaceAttr then
        oneItem.replaceAttr = {}
    end
    if not oneItem.libAttr then
        oneItem.libAttr = {}
    end
    if not oneItem.holeAttr then
        oneItem.holeAttr = {}
    end
    if not oneItem.cardAttr then
        oneItem.cardAttr = {}
    end
    if not oneItem.stuntAttr then
        oneItem.stuntAttr = {}
    end
    if not oneItem.enchantAttr then
        oneItem.enchantAttr = {}
    end

    self:HideAllUI(oneItem.entryAttr)
    self:HideAllUI(oneItem.basicAttr)
    self:HideAllUI(oneItem.libAttr)
    self:HideAllUI(oneItem.stuntAttr)
    self:HideAllUI(oneItem.holeAttr)
    self:HideAllUI(oneItem.cardAttr)
    self:HideAllUI(oneItem.replaceAttr)
    self:HideAllUI(oneItem.enchantAttr)

    -- 设置绑定
    self:_showBind(oneItem)
    -- 基础词条属性
    self:showBaseAttr(oneItem)
    -- 贝鲁兹属性
    self:showBeiluzAttr(oneItem)
    -- 流派词条
    self:showEntryAttr(oneItem)
    -- 打洞插卡属性
    self:_showHoleCardAttr(oneItem)
    -- 精炼属性
    self:_showRefineAttr(oneItem)
    -- 付魔属性
    self:_showEnchantInfoField(oneItem)
    -- 置换器属性
    self:_showReplacerAttr(oneItem)
    -- 套装属性
    self:SetEquipmentSuitInfo(oneItem.data.itemTableData.ItemID)
    -- 跑商数据
    self:SetMerchantInfo(oneItem.data.itemTableData.ItemID)
end

function CommonItemTipsBaseTemplent:_showBind(oneItem)
    if oneItem.data.baseData.IsBind ~= nil then
        oneItem.BindPanel:SetActiveEx(oneItem.data.baseData.IsBind)
        local l_notInSell = MgrMgr:GetMgr("EquipMgr").IsEquipNotInSell(oneItem.data.baseData.TID)
        -- 如果当前道具id不在CommoditTable表和StallDetailTable表和GiftTable表中，直接隐藏【绑定】页签
        if l_notInSell then
            oneItem.BindPanel:SetActiveEx(false)
        end
    end
end

function CommonItemTipsBaseTemplent:_showHoleCardAttr(oneItem)
    ---@type ItemData
    local itemData = oneItem.data.baseData
    local holeAttrTable = itemData.AttrSet[GameEnum.EItemAttrModuleType.Hole]
    local showHolePanel = nil ~= holeAttrTable and #holeAttrTable > 0
    oneItem.holePanel:SetActiveEx(showHolePanel)
    if not showHolePanel then
        return
    end

    --已插的卡片
    local l_cardID = 0
    local l_cardInfo = nil
    local l_cardIndex = 1
    if nil == itemData.EquipConfig then
        return
    end

    local l_cardIds = {}
    local emptyHoleList = {}
    for i = 1, #itemData.AttrSet[GameEnum.EItemAttrModuleType.Card] do
        local cardTable = itemData.AttrSet[GameEnum.EItemAttrModuleType.Card][i]
        if 0 == #cardTable then
            table.insert(emptyHoleList, i)
        else
            for j = 1, #cardTable do
                table.insert(l_cardIds, cardTable[j].AttrID)
            end
        end
    end

    for i = 1, #l_cardIds do
        oneItem.imgHole[i].transform.gameObject:SetActiveEx(true)
        oneItem.imgHole[i]:SetSprite("Common", "UI_Common_Icon_Kacao01.png")
        l_cardID = l_cardIds[i]
        l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(l_cardID)
        self:SetHoleInfo(oneItem, i, l_cardInfo.CardName, "UI_Common_Icon_Kacao01.png")
        --有卡片显示卡片属性
        for j = 0, l_cardInfo.CardAttributes.Length - 1 do
            local attr = {}
            attr.type = l_cardInfo.CardAttributes[j][0]
            attr.id = l_cardInfo.CardAttributes[j][1]
            attr.val = l_cardInfo.CardAttributes[j][2]
            if not oneItem.cardAttr[l_cardIndex] then
                oneItem.cardAttr[l_cardIndex] = {}
                oneItem.cardAttr[l_cardIndex].ui = self:CloneObj(oneItem.AttrList.gameObject)
                oneItem.cardAttr[l_cardIndex].ui.transform:SetParent(oneItem.AttrList.transform.parent)
                oneItem.cardAttr[l_cardIndex].ui.transform:SetLocalScaleOne()
            end

            oneItem.cardAttr[l_cardIndex].ui.gameObject:SetActiveEx(true)
            local l_text = oneItem.cardAttr[l_cardIndex].ui.transform:Find("AttrTpl"):GetComponent("MLuaUICom")
            local itemAttr = Data.ItemAttrData.new(attr.type, attr.id, attr.val, 0, nil)
            l_text.LabText = attrUtil.GetAttrStr(itemAttr).Desc
            l_cardIndex = l_cardIndex + 1
            Common.CommonUIFunc.CalculateLowLevelTipsInfo(l_text)
        end
    end

    --已打洞未插卡的
    local l_cardCount = #l_cardIds
    local l_notCard = oneItem.data.baseData:GetOpenHoleCount() - l_cardCount
    for i = l_cardCount + 1, l_notCard + l_cardCount do
        oneItem.imgHole[i].transform.gameObject:SetActiveEx(true)
        oneItem.imgHole[i]:SetSprite("Common", "UI_Common_Icon_Kacao02.png")
        self:SetHoleInfo(oneItem, i, Common.Utils.Lang("EMPTY_CARD_HOLE"), "UI_Common_Icon_Kacao02.png")

        if not oneItem.cardAttr[l_cardIndex] then
            oneItem.cardAttr[l_cardIndex] = {}
            oneItem.cardAttr[l_cardIndex].ui = self:CloneObj(oneItem.AttrList.gameObject)
            oneItem.cardAttr[l_cardIndex].ui.transform:SetParent(oneItem.AttrList.transform.parent)
            oneItem.cardAttr[l_cardIndex].ui.transform:SetLocalScaleOne()
        end

        oneItem.cardAttr[l_cardIndex].ui.gameObject:SetActiveEx(true)
        local l_text = oneItem.cardAttr[l_cardIndex].ui.transform:Find("AttrTpl"):GetComponent("MLuaUICom")
        local holeIdx = i - l_cardCount
        if nil ~= emptyHoleList[holeIdx] then
            l_text.LabText = self:_getHoleAttrStr(oneItem.data.baseData, emptyHoleList[holeIdx])
        else
            logError("[CommonItemTips] invalid idx: " .. tostring(holeIdx))
        end

        l_cardIndex = l_cardIndex + 1
        Common.CommonUIFunc.CalculateLowLevelTipsInfo(l_text)
    end

    --未打洞的
    local l_dontHole = MgrMgr:GetMgr("EquipMakeHoleMgr").GetNotOpenHoleCount(oneItem.data.baseData)
    for i = 1 + l_notCard + l_cardCount, l_dontHole + l_notCard + l_cardCount do
        oneItem.imgHole[i].transform.gameObject:SetActiveEx(true)
        oneItem.imgHole[i]:SetSprite("Common", "UI_Common_Icon_Kacao03.png")
        self:SetHoleInfo(oneItem, i, Common.Utils.Lang("EQUIP_HOLE_NOTOPEND"), "UI_Common_Icon_Kacao03.png")
    end
end

--- 获取属性拼接后的字符串
---@param itemData ItemData
function CommonItemTipsBaseTemplent:_getHoleAttrStr(itemData, index)
    local attrSet = itemData.AttrSet[GameEnum.EItemAttrModuleType.Hole][index]
    if nil == attrSet then
        logError("[CommonItemTips] hole attrs got nil")
        return "[CommonItemTips] hole attrs got nil"
    end

    local ret = ""
    for i = 1, #attrSet do
        local singleAttr = attrSet[i]
        local attrDesc = attrUtil.GetAttrStr(singleAttr)
        if nil ~= attrDesc and nil ~= attrDesc.FullValue then
            ret = ret .. attrUtil.GetAttrStr(singleAttr).FullValue .. ";"
        else
            logError("[ItemTips] invalid attr: " .. ToString(singleAttr))
        end
    end

    return ret
end

---@param oneItem CommonItemTipsBaseTemplentParameter
function CommonItemTipsBaseTemplent:_showRefineAttr(oneItem)
    ---@type ItemData
    local itemData = oneItem.data.baseData
    if nil == itemData.EquipConfig then
        oneItem.RefineSeal.gameObject:SetActiveEx(false)
        return
    end

    --不可精炼
    if not MgrMgr:GetMgr("RefineMgr").IsCanRefine(oneItem.data.equipTableData) then
        oneItem.RefineSeal.gameObject:SetActiveEx(false)
    else
        oneItem.refinePanel:SetActiveEx(true)
        oneItem.NoRefineText:SetActiveEx(false)
        oneItem.RefineCount_0:SetActiveEx(false)
        oneItem.RefineCount_1:SetActiveEx(false)
        oneItem.RefineCount_2:SetActiveEx(false)
        oneItem.RefineCount_3:SetActiveEx(false)
        oneItem.RefineCount_4:SetActiveEx(false)
        oneItem.RefineCount_5:SetActiveEx(false)
        local refineAttrSet = itemData.AttrSet[GameEnum.EItemAttrModuleType.Refine]
        local refineAttr = nil
        if nil ~= refineAttrSet then
            refineAttr = refineAttrSet[1]
        end

        local currentRefineLevel = itemData.RefineLv
        oneItem.RefineName:SetActiveEx(false)
        oneItem.RefineSeal.gameObject:SetActiveEx(false)
        --- 这里可能是创建的假数据，所以没有精炼属性
        if nil == refineAttr then
            return
        end

        if currentRefineLevel == 0 then
            oneItem.NoRefineText:SetActiveEx(true)
        else
            oneItem.RefineName:SetActiveEx(true)
            self:_updateRefineAttrs(oneItem, refineAttr)
        end

        if itemData.RefineSealLv > 0 then
            oneItem.RefineSeal.LabText = Lang("REFINE_SEAL_TIP_FORMAT", itemData.RefineSealLv)
            oneItem.RefineSeal.gameObject:SetActiveEx(true)
        else
            oneItem.RefineSeal.gameObject:SetActiveEx(false)
        end

        if currentRefineLevel > 0 then
            self:_showItemName(oneItem, string.ro_concat(oneItem.txtTipName.LabText, "+", currentRefineLevel))
        end
    end
end

--- 显示精炼属性
---@param oneItem CommonItemTipsBaseTemplentParameter
---@param attrs ItemAttrData[]
function CommonItemTipsBaseTemplent:_updateRefineAttrs(oneItem, attrs)
    local goList = {
        oneItem.RefineCount_0,
        oneItem.RefineCount_1,
        oneItem.RefineCount_2,
        oneItem.RefineCount_3,
        oneItem.RefineCount_4,
        oneItem.RefineCount_5,
    }

    for i = 1, #goList do
        goList[i].gameObject:SetActiveEx(false)
    end

    if nil == attrs then
        return
    end

    for i = 1, #attrs do
        if i <= #goList then
            --临时解决
            goList[i].gameObject:SetActiveEx(true)
            local attrDesc = attrUtil.GetAttrStr(attrs[i]).FullValue
            goList[i].LabText = attrDesc
        end
    end
end

-- 置换器属性
function CommonItemTipsBaseTemplent:_showReplacerAttr(oneItem)
    ---@type ItemData
    local itemData = oneItem.data.baseData
    local l_ReplaceAttrs = {}
    local showPanel = false
    local deviceAttrSet = itemData.AttrSet[GameEnum.EItemAttrModuleType.Device]
    if nil ~= deviceAttrSet then
        l_ReplaceAttrs = deviceAttrSet[1]
        showPanel = 0 < #l_ReplaceAttrs
    end

    oneItem.ReplacerPanel:SetActiveEx(showPanel)
    if not showPanel then
        return
    end

    oneItem.ReplacerNamePanel:SetActiveEx(oneItem.data.itemTableData.TypeTab == 1)
    oneItem.ReplacerName.LabText = Common.Utils.Lang("DISPLACER")
    for i = 1, #l_ReplaceAttrs do
        if not oneItem.replaceAttr[i] then
            oneItem.replaceAttr[i] = {}
            oneItem.replaceAttr[i].ui = self:CloneObj(oneItem.ReplacerAttrTpl.gameObject)
            oneItem.replaceAttr[i].ui.transform:SetParent(oneItem.ReplacerAttrTpl.transform.parent)
            oneItem.replaceAttr[i].ui.transform:SetLocalScaleOne()
            self:ExportReplaceElement(oneItem.replaceAttr[i])
        end

        oneItem.replaceAttr[i].ui.gameObject:SetActiveEx(true)
        oneItem.replaceAttr[i].ReplaceText.LabText = attrUtil.GetAttrStr(l_ReplaceAttrs[i], RoColorTag.Yellow).Desc
    end

    --置换器物品耐久设置
    oneItem.ReplacerDuarableValue.LabText = tostring(itemData.DeviceItemDuration)
    oneItem.ReplacerDuarableValue.transform.parent.parent:SetAsLastSibling()
    oneItem.ReplacerAttrTpl:SetActiveEx(false)
end

-- 表示itemTips的附魔的页面状态
local l_eEnchantState = {
    None = 0,
    HideAll = 1,
    ShowNoEnchant = 2,
    ShowEnchant = 3,
}

-- 获取状态
-- 这边equip数据是可能没有的，但是item数据是一定会有的
function CommonItemTipsBaseTemplent:_getEnchantState(oneItem)
    if nil == oneItem then
        logError("[CommonItemTipsBaseTemplate] one item got nil, plis check")
        return l_eEnchantState.None
    end

    ---@type ItemData
    local itemData = oneItem.data.baseData
    if nil ~= oneItem.data.equipTableData then
        if 1 > oneItem.data.equipTableData.EnchantingId then
            return l_eEnchantState.HideAll
        else
            l_attrs = itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
            if 0 == #l_attrs then
                return l_eEnchantState.ShowNoEnchant
            end

            return l_eEnchantState.ShowEnchant, l_attrs
        end
    end

    if nil ~= oneItem.data.itemTableData then
        return l_eEnchantState.HideAll
    end

    logError("[CommonItemTipsBaseTemplate] invalid item enchant info condition")
    return l_eEnchantState.None
end

-- 显示附魔属性相关的数据
-- 做个标注，这个地方创建了之后，需要在重置的时候进行销毁
function CommonItemTipsBaseTemplent:_showEnchantInfoField(oneItem)
    local l_state, l_attrs = self:_getEnchantState(oneItem)
    local l_isPanelShown = l_eEnchantState.HideAll < l_state
    local l_isEnchantShown = false
    if nil ~= l_attrs and 0 < #l_attrs then
        l_isEnchantShown = true
    end

    oneItem.enchantPanel.gameObject:SetActiveEx(l_isPanelShown)
    oneItem.enchantName:SetActiveEx(l_isEnchantShown)

    ---@type ItemData
    local itemData = oneItem.data.baseData
    oneItem.CantEnchantText:SetActiveEx(itemData.EnchantExtracted)
    oneItem.NoEnchantText:SetActiveEx((not l_isEnchantShown) and (not itemData.EnchantExtracted))
    oneItem.CantEnchantText.LabText = Common.Utils.Lang("C_CANNOT_ENCHANT")
    if not l_isEnchantShown then
        return
    end

    if not oneItem.enchantAttr then
        oneItem.enchantAttr = {}
    end

    for i = 1, #l_attrs do
        if nil == oneItem.enchantAttr[i] then
            oneItem.enchantAttr[i] = self:_createSingleAttrWidget(oneItem)
        end

        oneItem.enchantAttr[i].ui.gameObject:SetActiveEx(true)
        local l_cntStr = attrUtil.GetAttrStr(l_attrs[i]).FullValue
        oneItem.enchantAttr[i].attrTxt.LabText = l_cntStr
    end
end

-- 附魔：用于创建单条属性的obj
function CommonItemTipsBaseTemplent:_createSingleAttrWidget(oneItem)
    if nil == oneItem then
        return nil
    end

    local l_ret = {}
    l_ret.ui = self:CloneObj(oneItem.enchantTpl.gameObject)
    l_ret.ui.transform:SetParent(oneItem.enchantTpl.transform.parent)
    l_ret.ui.transform:SetLocalScaleOne()
    l_ret.attrTxt = MLuaClientHelper.GetOrCreateMLuaUICom(l_ret.ui)
    return l_ret
end

function CommonItemTipsBaseTemplent:showBaseAttr(oneItem)
    ---@type ItemData
    local itemData = oneItem.data.baseData
    local baseAttrs = {}
    ---@type ItemAttrData[]
    local originBaseAttrList = {}
    if nil ~= itemData.AttrSet[GameEnum.EItemAttrModuleType.Base] and 0 ~= #itemData.AttrSet[GameEnum.EItemAttrModuleType.Base] then
        originBaseAttrList = itemData.AttrSet[GameEnum.EItemAttrModuleType.Base][1]
    end

    --- 策划要求有一些属性是不显示的
    for i = 1, #originBaseAttrList do
        local singleAttr = originBaseAttrList[i]
        if not singleAttr:IgnoreAttr() then
            table.insert(baseAttrs, singleAttr)
        end
    end

    if not oneItem.attrPanel.gameObject.activeSelf then
        oneItem.attrPanel:SetActiveEx(#baseAttrs > 0)
    end

    for i = 1, #baseAttrs do
        if not oneItem.basicAttr[i] then
            oneItem.basicAttr[i] = {}
            oneItem.basicAttr[i].ui = self:CloneObj(oneItem.attrTpl.gameObject)
            oneItem.basicAttr[i].ui.transform:SetParent(oneItem.attrTpl.transform.parent)
            oneItem.basicAttr[i].ui.transform:SetLocalScaleOne()
            oneItem.basicAttr[i].attrText = oneItem.basicAttr[i].ui.transform:Find("AttrTpl"):GetComponent("MLuaUICom")
        end

        oneItem.basicAttr[i].ui.gameObject:SetActiveEx(true)
        oneItem.basicAttr[i].attrText.LabText = attrUtil.GetAttrStr(baseAttrs[i]).Desc
        Common.CommonUIFunc.CalculateLowLevelTipsInfo(oneItem.basicAttr[i].attrText)
    end
end

function CommonItemTipsBaseTemplent:showBeiluzAttr(oneItem)
    ---@type ItemData
    local itemData = oneItem.data.baseData
    local baseAttrs = {}
    if nil ~= itemData.AttrSet[GameEnum.EItemAttrModuleType.BelluzGear] and 0 ~= #itemData.AttrSet[GameEnum.EItemAttrModuleType.BelluzGear] then
        baseAttrs = itemData.AttrSet[GameEnum.EItemAttrModuleType.BelluzGear][1]
    end

    oneItem.beiluziPanel:SetActiveEx(#baseAttrs > 0)

    local beiluzMgr = MgrMgr:GetMgr("BeiluzCoreMgr")
    for i = 1, 2 do
        if baseAttrs[i] then
            if baseAttrs[i].TableID == 0 then
                break
            end
            local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(baseAttrs[i].TableID)
            if not wheelSkillCfg then
                return
            end
            local quality = wheelSkillCfg.SkillQuality
            local color = beiluzMgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
            oneItem.skillName[i].LabText = attrUtil.GetAttrStr(baseAttrs[i], color).Name
            oneItem.attrDesc[i].LabText = attrUtil.GetAttrStr(baseAttrs[i]).Desc
            oneItem.skillName[i].gameObject:SetActiveEx(true)
            oneItem.attrDesc[i].gameObject:SetActiveEx(true)
            oneItem.beiluzPlace[i].gameObject:SetActiveEx(true)
        else
            oneItem.skillName[i].gameObject:SetActiveEx(false)
            oneItem.attrDesc[i].gameObject:SetActiveEx(false)
            oneItem.beiluzPlace[i].gameObject:SetActiveEx(false)
        end
        --Common.CommonUIFunc.CalculateLowLevelTipsInfo(oneItem.basicAttr[i].attrText)
    end
    oneItem.beiluzLifeRemain.LabText = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_REMAIN_IN_DAY"), beiluzMgr.GetCoreRemainTimeInDay(itemData))
end

function CommonItemTipsBaseTemplent:showEntryAttr(oneItem)
    if oneItem.data.equipTableData == nil then
        return
    end

    ---@type ItemData
    local itemData = oneItem.data.baseData
    local entryAttrs = itemData.AttrSet[GameEnum.EItemAttrModuleType.School][1]
    if not oneItem.attrPanel.gameObject.activeSelf then
        oneItem.attrPanel:SetActiveEx(#entryAttrs > 0)
    end

    local attrDescList = attrUtil.GetItemSchoolAttrStr(itemData)
    for i = 1, #attrDescList do
        if not oneItem.entryAttr[i] then
            oneItem.entryAttr[i] = {}
            oneItem.entryAttr[i].ui = self:CloneObj(oneItem.attrTpl.gameObject)
            oneItem.entryAttr[i].ui.transform:SetParent(oneItem.attrTpl.transform.parent)
            oneItem.entryAttr[i].ui.transform:SetLocalScaleOne()
            self:ExportAttrElement(oneItem.entryAttr[i])
        end

        oneItem.entryAttr[i].ui.transform:Find("Image").gameObject:SetActiveEx(true)
        oneItem.entryAttr[i].ui.gameObject:SetActiveEx(true)
        oneItem.entryAttr[i].attrTxt.LabText = attrDescList[i]
        Common.CommonUIFunc.CalculateLowLevelTipsInfo(oneItem.entryAttr[i].attrMluaUIcom)
    end
end

--特技属性展示
function CommonItemTipsBaseTemplent:SkillAttrInfo(l_text, attr)
    l_text:AddClick(function()
        local l_position = l_text.transform.position

        --显示描述
        local l_skillData = {
            openType = DataMgr:GetData("SkillData").OpenType.ShowSkillInfo,
            position = l_position,
            data = attr
        }
        UIMgr:ActiveUI(UI.CtrlNames.SkillAttr, l_skillData)
    end)
end

--设置插卡属性
function CommonItemTipsBaseTemplent:SetHoleInfo(oneItem, index, text, spriteName)
    if not oneItem.holeAttr[index] then
        oneItem.holeAttr[index] = {}
        oneItem.holeAttr[index].ui = self:CloneObj(oneItem.holeTpl.gameObject)
        oneItem.holeAttr[index].ui.transform:SetParent(oneItem.holeTpl.transform.parent)
        oneItem.holeAttr[index].ui.transform:SetLocalScaleOne()
        self:ExportHoleElement(oneItem.holeAttr[index])
    end

    oneItem.holeAttr[index].ui.gameObject:SetActiveEx(true)
    oneItem.holeAttr[index].holeImage:SetSprite("Common", spriteName)
    oneItem.holeAttr[index].holeText.LabText = text
end

function CommonItemTipsBaseTemplent:HideAllUI(uiTable)
    for i = 1, table.maxn(uiTable) do
        uiTable[i].ui.gameObject:SetActiveEx(false)
    end
end

function CommonItemTipsBaseTemplent:ExportHoleElement(element)
    element.holeImage = element.ui.transform:Find("Image"):GetComponent("MLuaUICom")
    element.holeText = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Label/Text"))
end

function CommonItemTipsBaseTemplent:ExportAttrElement(element)
    element.attrTxt = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("AttrTpl"))
    element.attrMluaUIcom = element.ui.transform:Find("AttrTpl"):GetComponent("MLuaUICom")
end

function CommonItemTipsBaseTemplent:ExportReplaceElement(element)
    element.ReplaceText = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("AttrTpl"))
end

function CommonItemTipsBaseTemplent:ResetSetComponent()
    if self.basicAttr then
        for j = 1, table.maxn(self.basicAttr) do
            MResLoader:DestroyObj(self.basicAttr[j].ui)
        end
        self.basicAttr = {}
    end
    if self.libAttr then
        for j = 1, table.maxn(self.libAttr) do
            MResLoader:DestroyObj(self.libAttr[j].ui)
        end
        self.libAttr = {}
    end
    if self.entryAttr then
        for j = 1, table.maxn(self.entryAttr) do
            MResLoader:DestroyObj(self.entryAttr[j].ui)
        end
        self.entryAttr = {}
    end
    if self.stuntAttr then
        for j = 1, table.maxn(self.stuntAttr) do
            MResLoader:DestroyObj(self.stuntAttr[j].ui)
        end
        self.stuntAttr = {}
    end
    if self.holeAttr then
        for j = 1, table.maxn(self.holeAttr) do
            MResLoader:DestroyObj(self.holeAttr[j].ui)
        end
        self.holeAttr = {}
    end
    if self.cardAttr then
        for j = 1, table.maxn(self.cardAttr) do
            MResLoader:DestroyObj(self.cardAttr[j].ui)
        end
        self.cardAttr = {}
    end
    if self.enchantAttr then
        for j = 1, table.maxn(self.enchantAttr) do
            MResLoader:DestroyObj(self.enchantAttr[j].ui)
        end
        self.enchantAttr = {}
    end
    if self.replaceAttr then
        for j = 1, table.maxn(self.replaceAttr) do
            MResLoader:DestroyObj(self.replaceAttr[j].ui)
        end
        self.replaceAttr = {}
    end

    array.each(self.Parameter.imgHole, function(v)
        v:SetActiveEx(false)
    end)
    array.each(self.Parameter.imgStar, function(v)
        v:SetActiveEx(false)
    end)
end

function CommonItemTipsBaseTemplent:SetEquipmentSuitInfo(itemID)
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Suit) then
        local l_hasSuitInfo, l_suitDetail = MgrMgr:GetMgr("SuitMgr").GetEquipmentSuiteInfo(itemID)
        if not l_hasSuitInfo then
            self.Parameter.suitPanel.gameObject:SetActiveEx(false)
        else
            local l_suitMgr = MgrMgr:GetMgr("SuitMgr")
            local l_suitData = DataMgr:GetData("SuitData")
            local l_suitInfoTbl = {}
            local l_flag = table.ro_size(l_suitDetail) > 1
            local l_count = 1
            for suitId, suitDetail in pairs(l_suitDetail) do
                local l_rowSuit = TableUtil.GetSuitTable().GetRowBySuitId(suitId)
                -- title
                if l_flag then
                    table.insert(l_suitInfoTbl, RoColor.GetTextWithDefineColor(Lang("SUIT_TITLE_FORMAT", l_count, l_rowSuit.Dec), l_suitData.SuitActiveColor))
                else
                    table.insert(l_suitInfoTbl, RoColor.GetTextWithDefineColor(l_rowSuit.Dec, l_suitData.SuitActiveColor))
                end
                -- equips
                local l_equipNames = l_suitMgr.GetSuitEquipmentNameBySuitDetail(suitDetail)
                if l_equipNames then
                    table.insert(l_suitInfoTbl, l_equipNames)
                end

                -- suit info
                local l_suitDesc = l_suitMgr.GetSuitDetailDesc(suitDetail)
                if l_suitDesc then
                    table.ro_insertRange(l_suitInfoTbl, l_suitDesc)
                end
                l_count = l_count + 1
            end
            local l_finalTxt = table.concat(l_suitInfoTbl, "\n")
            self.Parameter.suitTpl.LabText = l_finalTxt

            self.Parameter.suitPanel.gameObject:SetActiveEx(true)
        end
    else
        self.Parameter.suitPanel.gameObject:SetActiveEx(false)
    end
end

function CommonItemTipsBaseTemplent:SetMerchantInfo(itemID)
    if itemID == DataMgr:GetData("MerchantData").BusinessCertificateId then
        self.Parameter.customContext.LabText = Lang("MERCHANT_COIN_FORMAT", tostring(MPlayerInfo.MerchantCoin))
        self.Parameter.customPanel.gameObject:SetActiveEx(true)
    else
        self.Parameter.customPanel.gameObject:SetActiveEx(false)
    end
end

function CommonItemTipsBaseTemplent:_showItemName(oneItem, name)
    local l_isDestroy = MgrMgr:GetMgr("SkillDestroyEquipMgr").IsDestroyWithPropInfo(oneItem.data.baseData)
    if l_isDestroy then
        name = GetColorText(name, RoColorTag.Red)
    end

    oneItem.txtTipName.LabText = name
end

function CommonItemTipsBaseTemplent:_showDestroy(oneItem)
    local l_isDestroy = MgrMgr:GetMgr("SkillDestroyEquipMgr").IsDestroyWithPropInfo(oneItem.data.baseData)

    oneItem.DestroyFlag:SetActiveEx(l_isDestroy)

    if l_isDestroy then
        local l_imageName = MgrMgr:GetMgr("SkillDestroyEquipMgr").GetDestroyImageNameWithEquipPart(oneItem.data.equipTableData.EquipId)
        self.Parameter.DestroyImage:SetSpriteAsync("CommonIcon", l_imageName)
    end
end

DETAIL_INFO_MAX_SIZE = 310
DETAIL_INFO_OFFSET_SIZE = 2
MALL_DETAIL_INFO_MAX_SIZE = 90
MALL_DISCOUNT_DETAIL_INFO_SIZE = 70
function CommonItemTipsBaseTemplent:AutoSize(oneItem)
    LayoutRebuilder.ForceRebuildLayoutImmediate(oneItem.DetailInfo.RectTransform)
    local detailSizeY = oneItem.DetailInfo.RectTransform.sizeDelta.y
    local scrollLayoutElement = oneItem.DetailInfoScroll.LayoutEle
    local l_max = DETAIL_INFO_MAX_SIZE
    if oneItem.data and oneItem.data.additionalData then
        if oneItem.data.additionalData.forMallAutoSize then
            l_max = MALL_DETAIL_INFO_MAX_SIZE
            if not oneItem.data.additionalData.discounts then
                l_max = l_max + MALL_DISCOUNT_DETAIL_INFO_SIZE
            end
        end
    end
    if detailSizeY > l_max then
        scrollLayoutElement.preferredHeight = l_max
    else
        scrollLayoutElement.preferredHeight = detailSizeY + DETAIL_INFO_OFFSET_SIZE
    end
end

function CommonItemTipsBaseTemplent:SetLine(oneItem)
    LayoutRebuilder.ForceRebuildLayoutImmediate(oneItem.DetailInfo.RectTransform)
    local go = MLuaCommonHelper.GetLastActiveGo(oneItem.DetailInfo.gameObject)
    if go then
        local placeHolder = go.transform:Find("Img_Fengexian")
        if placeHolder then
            placeHolder.gameObject:SetActiveEx(false)
        end
    end
end

function CommonItemTipsBaseTemplent:SetToHeadByState(oneItem, headState)
    if headState == 1 then
        oneItem.ImgTipIconBg:SetHeight(136)
        oneItem.ImgTipIconBg:SetWidth(114)
        oneItem.Type02:SetActiveEx(true)
        oneItem.Head.LayoutEle.preferredHeight = 160
        oneItem.imgTipIcon.RectTransform.anchoredPosition = Vector2.New(0, 0)
        oneItem.imgTipIcon.transform:SetLocalScale(0.7, 0.7, 0.7)
    else
        oneItem.ImgTipIconBg:SetHeight(100)
        oneItem.ImgTipIconBg:SetWidth(100)
        oneItem.ImgTipIconBg.gameObject:SetRectTransformPos(75, -85)
        oneItem.imgTipIcon.transform:SetLocalScaleOne()
        oneItem.imgTipIcon.RectTransform.anchoredPosition = Vector2.New(-1, 2)
        oneItem.imgTipIcon.RectTransform.sizeDelta = Vector2.New(93, 93)
        oneItem.Type02:SetActiveEx(false)
        oneItem.Head.LayoutEle.preferredHeight = 145
    end
end

-- 创建一个贴纸的具体信息的显示逻辑
function CommonItemTipsBaseTemplent:FillTitleStickerInfo(oneItem)
    if oneItem.data.itemTableData.TypeTab ~= Data.BagModel.PropType.Title then
        return
    end
    if self.titleTemplate ~= nil then
        self:UninitTemplate(self.titleTemplate)
    end
    self.titleTemplate = self:NewTemplate("CommonItemTipsTitleStickerComponent", { TemplateParent = oneItem.DetailInfo.transform })
    self.titleTemplate:SetData({ titleId = oneItem.data.itemTableData.ItemID })
    self.titleTemplate:AddLoadCallback(function()
        self:AutoSize(oneItem)
    end)
end

-- 封印卡片特有信息
function CommonItemTipsBaseTemplent:FillSealCardInfo(oneItem)
    if self.cardTemplate ~= nil then
        self:UninitTemplate(self.cardTemplate)
    end
    self.cardTemplate = self:NewTemplate("CommonItemTipsSealCardComponent", { TemplateParent = oneItem.DetailInfo.transform })
    self.cardTemplate:AddLoadCallback(function()
        local l_unsealCardId = 0
        local l_cardRow = TableUtil.GetEquipCardSeal().GetRowBySealCardId(oneItem.data.baseData.TID)
        if l_cardRow then
            l_unsealCardId = l_cardRow.CardId
        end
        self.cardTemplate:SetData({ unsealCardId = l_unsealCardId })
        self:AutoSize(oneItem)
    end)
end
--lua custom scripts end
return CommonItemTipsBaseTemplent