--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Template/MonsterLimitImageTemplate"
require "UI/Template/IllustrationEquipListTemplate"
require "UI/Template/EquipIllustrationSuitTemplate"
require "UI/Panel/IllustrationEquipmentPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
IllustrationEquipmentCtrl = class("IllustrationEquipmentCtrl", super)
--当前右侧数据
local currentEquipData
--lua class define end

--lua functions
function IllustrationEquipmentCtrl:ctor()
    super.ctor(self, CtrlNames.IllustrationEquipment, UILayer.Function, nil, ActiveType.Exclusive)
    self.mgr = MgrMgr:GetMgr("IllustrationMgr")
    self.selectEquipId = -1
    --- 界面选中的枚举类型
    self.E_BTN_STATE = {
        None = 0,
        Attr = 1,
        ProRecommend = 2,
        ForgeMat = 3,
    }
end --func end
--next--
function IllustrationEquipmentCtrl:Init()
    self.panel = UI.IllustrationEquipmentPanel.Bind(self)
    super.Init(self)
    -- self.mgr.InitEquipHandBook()

    self.equipSuitTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.EquipIllustrationSuitTemplate,
        TemplatePrefab = self.panel.EquipIllustrationSuitTemplate.EquipRandomTip.gameObject,
        TemplateParent = self.panel.GroupSuitAttr.transform,
    })

    --装备滚动条
    self.equipListTemplatePool = self:NewTemplatePool({
        ScrollRect = self.panel.ScrollEquipment.LoopScroll,
        PreloadPaths = {},
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
        GetTemplateAndPrefabMethod = function(data)
            return self:GetTemplate(data)
        end,
    })

    self._forgeMatTemplatePoolConfig = {
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        ScrollRect = self.panel.ForgeMatScroll.LoopScroll,
    }

    self.panel.Btn_EquipAttr:AddClickWithLuaSelf(self._onEquipAttrBtnSelected, self)
    self.panel.Btn_ProRecommend:AddClickWithLuaSelf(self._onProRecommendBtnSelected, self)
    self.panel.Btn_ForgeMat:AddClickWithLuaSelf(self._onForgeMatClick, self)
    self._itemForgeTemplatePool = self:NewTemplatePool(self._forgeMatTemplatePoolConfig)
    self.panel.EquipGetButton:AddClickWithLuaSelf(self._onEquipGetBtnClick, self)
    --处理装备类型二级菜单
    self.panel.EquipTypeSelectButton:AddClickWithLuaSelf(self.FliterEquipPart, self)
    --处理装备职业二级菜单
    self.panel.ProfessionSelectButton:AddClickWithLuaSelf(self.FliterProfession, self)

    --关闭按钮
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

    self.panel.ShowEquipTypeTipsButton:AddClick(function()
        if currentEquipData == nil then
            return
        end

        UIMgr:ActiveUI(UI.CtrlNames.EquipTypeExplainTips, function(ctrl)
            ctrl:ShowExplainTips(currentEquipData.WeaponId)
        end)
    end)

end --func end
--next--
function IllustrationEquipmentCtrl:Uninit()
    self.equipListTemplatePool = nil
    self.equipSuitTemplatePool = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function IllustrationEquipmentCtrl:OnActive()
    self.panel.EquipIllustrationSuitTemplate.EquipRandomTip.gameObject:SetActiveEx(false)
    self.panel.MonsterLimitImageTemplate.LuaUIGroup.gameObject:SetActiveEx(false)

    local partId, proId = self.mgr.GetEquipSearchValue()
    proId = proId or math.floor(MPlayerInfo.ProID / 1000) * 1000
    partId = (partId and not self.mgr.SelectEquipId) and partId or 0
    if proId == 1000 or self.mgr.SelectEquipId then
        --初心者显示全部
        self:CreateShowEquipScroll(self.mgr.GetTypeShowEquip(0))
    else
        --其他显示本职业装备
        self.panel.EquipProfessionSelectText.LabText = DataMgr:GetData("TeamData").GetProfessionNameById(proId)
        self:CreateShowEquipScroll(self.mgr.GetTypeShowEquip(4, proId))
    end

    self.panel.EquipTypeSelectText.LabText = self.mgr.DROPDOWN_EQUIP_TYPE_STR[partId + 1] or self.mgr.DROPDOWN_EQUIP_TYPE_STR[1]
    self.panel.EquipProfessionSelectText.LabText = self.mgr.ProIdToProName[self.mgr.SelectEquipId and 1000 or proId]

end --func end
--next--
function IllustrationEquipmentCtrl:OnDeActive()
    self:ResetData()
end --func end
--next--
function IllustrationEquipmentCtrl:Update()
    self.equipListTemplatePool:OnUpdate()
end --func end

--next--
function IllustrationEquipmentCtrl:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ILLUSTRATION_SELECT_EQUIP, self.RefreshEquipInfo)
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onBagItemUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts
--创建左侧列表
function IllustrationEquipmentCtrl:CreateShowEquipScroll(equipTable)
    local startScrollIndex = self.mgr.GetEquipShowLevelLimit()
    --创建装备滚动条
    self.equipListTemplatePool:DeActiveAll()
    self.equipListTemplatePool:ShowTemplates({
        Datas = equipTable,
        StartScrollIndex = startScrollIndex,
    })

    --未找到
    self.panel.EquipNotFoundText.gameObject:SetActiveEx(#equipTable == 0)

    --显示记录位置的魔物的信息
    if #equipTable > 0 then
        local l_equipData
        if self.mgr.SelectTableData then
            l_equipData = self.mgr.SelectTableData
        else
            l_equipData = equipTable[self.mgr.GetEquipListTemplateIndex()][self.mgr.GetEquipCellTemplateIndex()]
        end

        self:RefreshEquipInfo(l_equipData, true)
    end
end

function IllustrationEquipmentCtrl:_setSelectState(state)
    self:_setEquipAttrBtn(self.E_BTN_STATE.Attr == state)
    self:_setProRecommendBtn(self.E_BTN_STATE.ProRecommend == state)
    self:_setForgeMatBtn(self.E_BTN_STATE.ForgeMat == state)
    self.panel.EquipAttrScroll:SetActiveEx(self.E_BTN_STATE.Attr == state)
    self.panel.ProRecommendScroll:SetActiveEx(self.E_BTN_STATE.ProRecommend == state)
    self.panel.ForgeMatScroll:SetActiveEx(self.E_BTN_STATE.ForgeMat == state)
end

function IllustrationEquipmentCtrl:_setEquipAttrBtn(active)
    self.panel.Btn_EquipAttr_On:SetActiveEx(active)
    self.panel.Btn_EquipAttr_Off:SetActiveEx(not active)
end

function IllustrationEquipmentCtrl:_setProRecommendBtn(active)
    self.panel.Btn_ProRecommend_On:SetActiveEx(active)
    self.panel.Btn_ProRecommend_Off:SetActiveEx(not active)
end

function IllustrationEquipmentCtrl:_setForgeMatBtn(active)
    self.panel.Btn_ForgeMat_On:SetActiveEx(active)
    self.panel.Btn_ForgeMat_Off:SetActiveEx(not active)
end

--- 点击了基础属性按钮，选中按钮，反选其他按钮，开启对应界面，更新UI
function IllustrationEquipmentCtrl:_onEquipAttrBtnSelected()
    self:_setSelectState(self.E_BTN_STATE.Attr)
    self:_showAttrInfo(self._selectedEquipConfig)
end

function IllustrationEquipmentCtrl:_onProRecommendBtnSelected()
    self:_setSelectState(self.E_BTN_STATE.ProRecommend)
    self:_showProRecommendData(self._selectedEquipConfig)
end

function IllustrationEquipmentCtrl:_onForgeMatClick()
    self:_setSelectState(self.E_BTN_STATE.ForgeMat)
    self:_showForgeMat(self._selectedEquipConfig)
end

---@param equipData EquipTable
function IllustrationEquipmentCtrl:_showAttrInfo(equipData)
    --基础属性&流派属性
    local attrStrList = MgrMgr:GetMgr("IllustrationEquipAttrMgr").GetAttrStrsByID(equipData.Id)
    local hasAttr = 0 ~= #attrStrList
    local value = table.concat(attrStrList, '\n')
    self.panel.EquipAttrText1.LabText = value
    self.panel.EquipAttrTip.gameObject:SetActiveEx(hasAttr)
    local l_suitInfoTbl = {}
    local l_systemOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Suit)
    local l_suitData = DataMgr:GetData("SuitData")
    if l_systemOpen then
        local l_hasSuitInfo, l_suitDetail = MgrMgr:GetMgr("SuitMgr").GetEquipmentSuiteInfo(currentEquipData.Id)
        if l_hasSuitInfo then
            local l_suitMgr = MgrMgr:GetMgr("SuitMgr")
            local l_flag = table.ro_size(l_suitDetail) > 1
            local l_count = 1
            for suitId, suitDetail in pairs(l_suitDetail) do
                local l_oneSuitInfoTbl = {}
                local l_rowSuit = TableUtil.GetSuitTable().GetRowBySuitId(suitId)
                -- title
                if l_flag then
                    l_oneSuitInfoTbl.title = RoColor.GetTextWithDefineColor(Lang("SUIT_TITLE_FORMAT", l_count, l_rowSuit.Dec), l_suitData.SuitActiveColor)
                else
                    l_oneSuitInfoTbl.title = RoColor.GetTextWithDefineColor(l_rowSuit.Dec, l_suitData.SuitActiveColor)
                end
                -- equips
                local l_equipNames = l_suitMgr.GetSuitEquipmentNameBySuitDetail(suitDetail, true)
                if l_equipNames then
                    l_oneSuitInfoTbl.equipNames = l_equipNames
                end

                -- suit info
                local l_suitDesc = l_suitMgr.GetSuitDetailDesc(suitDetail, true)
                if l_suitDesc then
                    l_oneSuitInfoTbl.suitDesc = table.concat(l_suitDesc, "\n")
                end
                table.insert(l_suitInfoTbl, l_oneSuitInfoTbl)
                l_count = l_count + 1
            end
        end
    end

    self.equipSuitTemplatePool:ShowTemplates({ Datas = l_suitInfoTbl })
    self.panel.EquipSuit:SetActiveEx(#l_suitInfoTbl > 0)
    self.panel.ButtonSuit:SetActiveEx(l_systemOpen)
    self.panel.ButtonSuit:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.SetIllustration)
    end)

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.EquipAttrContent.transform)
end

---@param equipData EquipTable
function IllustrationEquipmentCtrl:_showProRecommendData(equipData)
    local itemData = TableUtil.GetItemTable().GetRowByItemID(equipData.Id)
    --职业限制
    local professionStr, isFull = Common.CommonUIFunc.GetProfessionStr(itemData.Profession)
    if isFull then
        self.panel.EquipJobText.LabText = Common.Utils.Lang("ILLUSTRATION_EQUIP_DETAIL_PROFESSION_ALL")
    else
        self.panel.EquipJobText.LabText = professionStr
    end

    --推荐流派
    local suggestTxt = MgrMgr:GetMgr("EquipMgr").GetGenreText(equipData.Id)
    self.panel.EquipSuggestText:SetActiveEx(not IsEmptyOrNil(suggestTxt))
    self.panel.EquipSuggestText.LabText = Common.Utils.Lang("ILLUSTRATION_CARD_SUGGEST") .. tostring(suggestTxt)
end

function IllustrationEquipmentCtrl:_onBagItemUpdate()
    if not self.panel.ForgeMatScroll.gameObject.activeSelf then
        return
    end

    self:_showForgeMat(self._selectedEquipConfig)
end

--- 显示锻造材料
---@param equipData EquipTable
function IllustrationEquipmentCtrl:_showForgeMat(equipData)
    if nil == equipData then
        logError("[EquipBook] invalid config")
        return
    end

    local paramList = MgrMgr:GetMgr("IllustrationEquipAttrMgr").MgrObj:GetEquipForgeMatList(equipData.Id)
    self._itemForgeTemplatePool:ShowTemplates({ Datas = paramList })
    self.panel.Txt_NoMatState:SetActiveEx(0 >= #paramList)
    self.panel.Txt_NoMatState.LabText = Common.Utils.Lang("C_NO_FORGE_MAT")
end

--刷新右侧数据
---@param equipData EquipTable
function IllustrationEquipmentCtrl:RefreshEquipInfo(equipData, isNotDeSelect)
    self._selectedEquipConfig = equipData

    if isNotDeSelect == nil then
        --清除原来的选择
        local equipList = self.equipListTemplatePool:GetItem(self.mgr.GetEquipListTemplateIndex())
        if equipList then
            local equipCell = equipList:GetTemplatePool():GetItem(self.mgr.GetEquipCellTemplateIndex())
            if equipCell then
                equipCell:SetEquipSelectState(false)
            end
        end
    end

    currentEquipData = equipData
    if currentEquipData.EquipId == 1 then
        self.panel.ShowEquipTypeTipsButton:SetActiveEx(true)
    else
        self.panel.ShowEquipTypeTipsButton:SetActiveEx(false)
    end

    local itemData = TableUtil.GetItemTable().GetRowByItemID(equipData.Id)
    --图片
    self.panel.EquipImg:SetSprite(currentEquipData.ItemAtlas, currentEquipData.ItemIcon, true)
    --名称
    self.panel.EquipNameText.LabText = itemData.ItemName
    --类型
    local equipTypeName = Common.CommonUIFunc.GetEquipTypeName(itemData) or ""
    self.panel.EquipTypeText.LabText = equipTypeName
    --等级
    self.panel.EquipLvText.LabText = StringEx.Format(Lang("ILLUSTRATION_EQUIP_DETAIL_LEVEL"), currentEquipData.LevelLimit)
    --卡槽
    local holeNum = currentEquipData.HoleNum
    if holeNum == 0 then
        self.panel.EquipSlotText.LabText = Common.Utils.Lang("ILLUSTRATION_EQUIP_DETAIL_NO_HOLE")
    else
        self.panel.EquipSlotText.LabText = StringEx.Format(Common.Utils.Lang("ILLUSTRATION_EQUIP_DETAIL_HOLE"), holeNum)
    end

    self:_onEquipAttrBtnSelected()
end

function IllustrationEquipmentCtrl:_onEquipGetBtnClick()
    if not Common.CommonUIFunc.isItemHaveExport(self._selectedEquipConfig.Id) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_EXPORT_PATH"))
        return
    end

    local l_ui = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
    if l_ui then
        UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
    end

    UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(l_ui)
        if l_ui then
            l_ui:InitItemAchievePanelByItemId(tonumber(currentEquipData.Id))
        end
    end)
end

function IllustrationEquipmentCtrl:GetTemplate(data)
    local class, prefab
    if data.isLevelLimitTitle then
        class = UITemplate.MonsterLimitImageTemplate
        prefab = self.panel.MonsterLimitImageTemplate.LuaUIGroup.gameObject
    else
        class = UITemplate.IllustrationEquipListTemplate
        prefab = self.panel.IllustrationEquipListPrefab.LuaUIGroup.gameObject
    end
    return class, prefab
end

function IllustrationEquipmentCtrl:FliterEquipPart()
    local datas = {}
    for i, v in ipairs(self.mgr.DROPDOWN_EQUIP_TYPE_STR) do
        table.insert(datas, {
            name = v,
            index = i,
        })
    end
    UIMgr:ActiveUI(UI.CtrlNames.SelectBox, function(ctrl)
        ctrl:ShowSelectBox(datas, function(data)
            --清除选中位置
            self.mgr.SetEquipListTemplateIndex(2)
            self.mgr.SetEquipCellTemplateIndex(1)
            --创建卡片列表
            self:CreateShowEquipScroll(self.mgr.GetTypeShowEquip(2, data.index))
            self.panel.EquipTypeSelectText.LabText = data.name

        end)
    end)
end

function IllustrationEquipmentCtrl:FliterProfession()
    local datas = {}
    for i, v in ipairs(self.mgr.DROPDOWN_EQUIP_PROFESSION_STR) do
        table.insert(datas, {
            name = v,
            index = i,
        })
    end
    UIMgr:ActiveUI(UI.CtrlNames.SelectBox, function(ctrl)
        ctrl:ShowSelectBox(datas, function(data)
            --清除选中位置
            self.mgr.SetEquipListTemplateIndex(2)
            self.mgr.SetEquipCellTemplateIndex(1)
            --创建卡片列表
            self:CreateShowEquipScroll(self.mgr.GetTypeShowEquip(3, data.index))
            self.panel.EquipProfessionSelectText.LabText = data.name
        end)
    end)
end

function IllustrationEquipmentCtrl:ResetData()
    --清除选中位置
    self.mgr.ResetEquipValues()
    self.selectEquipId = -1
end

function IllustrationEquipmentCtrl:SetSelectEquip(equipId)
    self.selectEquipId = equipId
end

--lua custom scripts end
return IllustrationEquipmentCtrl