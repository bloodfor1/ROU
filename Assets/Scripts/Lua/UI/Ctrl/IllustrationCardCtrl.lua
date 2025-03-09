--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationCardPanel"
require "UI/Template/IllustrationCardTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--显示卡片数据
local currentCardInfo
--属性列表存储
local cardAttrItemTable = {}
--卡片标签
local cardAttrToggles = {}
--流派列表存储
local cardSchoolItemTable = {}
--是否刷新列表
local isRefreshCardScroll = true
--next--
--lua fields end

--lua class define
IllustrationCardCtrl = class("IllustrationCardCtrl", super)
--lua class define end

--lua functions
function IllustrationCardCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationCard, UILayer.Function, nil, ActiveType.Exclusive)
    self.mgr = MgrMgr:GetMgr("IllustrationMgr")

end --func end
--next--
function IllustrationCardCtrl:Init()

    self.panel = UI.IllustrationCardPanel.Bind(self)
    super.Init(self)

    -- self.mgr.InitCardHandBook()

    --卡片滚动条
    self.cardTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.IllustrationCardTemplate,
        TemplatePrefab = self.panel.IllustrationCardPrefab.CardPrefab.gameObject,
        ScrollRect = self.panel.ScrollCard.LoopScroll,
        SetCountPerFrame = 2,
        CreateObjPerFrame = 2,
    })

    --搜索按钮
    self.panel.CardSearchInputField:OnInputFieldChange(handler(self, self.OnInputFieldChange))
    --筛选按钮
    self.panel.CardTypeSelectButton:AddClick(handler(self, self.ClickFilter))
    --筛选按钮点击事件
    self.panel.CardSearchButton:AddClick(handler(self, self.OnClickCardSearchButton))
    --关闭筛选背景点击事件
    self.panel.CardCloseSearchButton:AddClick(function()
        self.panel.CardSearchPanel.gameObject:SetActiveEx(false)
    end)

    --清空筛选
    self.panel.CardCleanupButton:AddClick(function()
        self:CleanUpCardAttrSearch(true)
        self:CleanUpCardSchoolSearch(true)
    end)
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

    --创建所有卡片
    local allCards = self.mgr.GetTypeShowCard(0)
    self:CreateCardScroll(allCards)

    --self.panel.CardCollectedText.LabText = Lang("ILLUSTRATION_CARD_GATHERED", 0, #allCards)
    self.panel.CardCollectedText:SetActiveEx(false)
    self.panel.CardTypeSelectText.LabText = self.mgr.DROPDOWN_CARD_STR[1]

end --func end
--next--
function IllustrationCardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.cardTemplatePool = nil

end --func end
--next--
function IllustrationCardCtrl:OnActive()
    self.panel.CardAttrTog:SetActiveEx(false)
    self:OnClickCardSearchButton()
    self.panel.CardSearchPanel.gameObject:SetActiveEx(false)
    if self.uiPanelData then
        if self.uiPanelData.openType == self.mgr.OpenType.SearchCard then
            local name = TableUtil.GetItemTable().GetRowByItemID(tonumber(self.uiPanelData.cardId)).ItemName
            self.panel.CardSearchInputField.Input.text = name
        end
        if self.uiPanelData.openType == self.mgr.OpenType.SelectCard then
            self.mgr.SetCardSchoolSelect(self.uiPanelData.schoolId, true)
            self:OnClickCardSearchButton() -- 卡片筛选界面
            self.panel.CardAttrList100.TogEx.isOn = true
            self:SetCardAttrItem(self.uiPanelData.type, self.uiPanelData.schoolId)
            self:CreateCardScroll(self.mgr.GetTypeShowCard(4))
        end
        if self.uiPanelData.openType == self.mgr.OpenType.SelectEquipPart then
            if self.uiPanelData.equipPart then
                self:SelectEquipPart(self.uiPanelData.equipPart)
            end
        end
    end

end --func end
--next--
function IllustrationCardCtrl:OnDeActive()
    self:ResetData()
end --func end
--next--
function IllustrationCardCtrl:Update()
    self.cardTemplatePool:OnUpdate()
end --func end

--next--
function IllustrationCardCtrl:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ILLUSTRATION_SELECT_CARD, self.RefreshCardInfo)
end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationCardCtrl:SetCardAttrItem(type, v)

    if cardAttrToggles[type] and cardAttrToggles[type][v] then
        cardAttrToggles[type][v].isOn = true
    else
        logError("invalid type = {{0}} v = {{1}}  ", type, v)
    end

end

--创建卡片滚动条
function IllustrationCardCtrl:CreateCardScroll(cardTable)

    --判断一开始出现的位置
    local startScrollIndex = 1
    local checkMonsterCardId = self.mgr.GetCheckMonsterCardId()
    local gridCount = self.panel.CardScroll:GetComponent("GridLayoutGroup").constraintCount
    if checkMonsterCardId then
        local _, idx = array.find(cardTable, function(v)
            return v.ID == checkMonsterCardId
        end)
        if idx then
            startScrollIndex = math.floor((idx - 1) / gridCount) * gridCount + 1
            self.mgr.SetSelectCardIndex(idx)
        end
        self.mgr.SetCheckMonsterCardId(nil)
    end

    --填入数据
    self.cardTemplatePool:ShowTemplates({
        Datas = cardTable,
        StartScrollIndex = startScrollIndex,
        IsNeedShowCellWithStartIndex = false,
    })
    --是否显示未找到文字
    self.panel.CardNotFoundText.gameObject:SetActiveEx(#cardTable == 0)
    --显示第一个卡片的信息
    if #cardTable > 0 then
        self:RefreshCardInfo(cardTable[self.mgr.GetSelectCardIndex()])
    end

end

--刷新卡片右侧信息
function IllustrationCardCtrl:RefreshCardInfo(cardData)

    local itemSdata = TableUtil.GetItemTable().GetRowByItemID(cardData.ID)
    if not itemSdata then
        return
    end

    --原来选中的取消选中
    local cardCell = self.cardTemplatePool:GetItem(self.mgr.GetSelectCardIndex())
    if cardCell then
        cardCell:SetSelectState(false)
    end
    currentCardInfo = cardData
    --卡片图
    self.panel.CardImage:SetRawTex(currentCardInfo.CardTexture)
    --卡片框
    self.panel.CardFrame:SetSprite(Data.BagModel:getCardTextureBgInfo(currentCardInfo.ID))
    --卡片名称框
    local l_color = Color.New(1, 1, 1, 1)
    if cardData.ItemQuality == 1 then
        l_color = Color.New(238 / 255, 251 / 255, 224 / 255, 1) --绿#eefbe0
    elseif cardData.ItemQuality == 2 then
        l_color = Color.New(213 / 255, 231 / 255, 254 / 255, 1) --蓝#d5e7fe
    elseif cardData.ItemQuality == 3 then
        l_color = Color.New(245 / 255, 232 / 255, 254 / 255, 1) --紫#f5e8fe
    elseif cardData.ItemQuality == 4 then
        l_color = Color.New(255 / 255, 242 / 255, 226 / 255, 1) --黄#fff2e2
    end
    self.panel.CardNameFrame.Img.color = l_color
    --卡片名称
    self.panel.CardName.LabText = itemSdata.ItemName
    --卡片属性
    self.panel.CardAttrText.LabText = self:CreateCardAttrStr(currentCardInfo.CardAttributes)
    --推荐流派
    local recommendSchoolTable = TableUtil.GetEquipCardTable().GetRowByID(currentCardInfo.ID).RecommendSchool
    if recommendSchoolTable.Length > 0 then
        local suggestStr = Common.Utils.Lang("ILLUSTRATION_CARD_SUGGEST")
        for k, v in ipairs(currentCardInfo.professionText) do
            suggestStr = suggestStr .. v.str
        end
        self.panel.CardSuggestText.LabText = suggestStr
    else
        self.panel.CardSuggestText.LabText = ""
    end
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.CardAttrText, self.panel.CardAttrPos)
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.CardSuggestText, self.panel.CardSuggestPos)
    --卡片属性列表刷新
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.CardDescContent.RectTransform)
    --获取途径按钮
    if Common.CommonUIFunc.isItemHaveExport(currentCardInfo.ID) then
        self.panel.CardGetButton:AddClick(function()
            local l_ui = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
            if l_ui then
                UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
            end

            UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(l_ui)
                if l_ui then
                    l_ui:InitItemAchievePanelByItemId(tonumber(currentCardInfo.ID))
                end
            end)
        end)
    else
        self.panel.CardGetButton:AddClick(function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_EXPORT_PATH"))
        end)
    end

end

--卡片属性
function IllustrationCardCtrl:CreateCardAttrStr(cardAttr)

    local attrStr = ""
    local cardAttrTableLen = cardAttr.Length - 1
    for k = 0, cardAttrTableLen do
        local attr = { type = cardAttr[k][0], id = cardAttr[k][1], val = cardAttr[k][2] }
        attrStr = attrStr .. tostring(MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr))
        if k < cardAttrTableLen then
            attrStr = attrStr .. "\n"
        end
    end
    return attrStr

end

--刷新筛选数据
function IllustrationCardCtrl:CreateCardSearchInfo()

    for k = 1, 10 do
        if self.panel["CardAttrList" .. k] then
            self.panel["CardAttrList" .. k].TogEx.onValueChanged:AddListener(function(value)
                if value then
                    self:CreateCardAttrScroll(k)
                end
            end)
        end
    end
    --流派分类
    if self.panel.CardAttrList100 then
        self.panel.CardAttrList100.TogEx.onValueChanged:AddListener(function(value)
            if value then
                self:CreateCardAttrScroll(100)
            end
        end)
    end
    self.panel.CardAttrList100.TogEx.isOn = true

end

--筛选属性列表
function IllustrationCardCtrl:CreateCardAttrScroll(type)

    --type 1-10属性 100流派
    --清除之前的属性按钮
    for k, v in ipairs(cardAttrItemTable) do
        MResLoader:DestroyObj(v)
    end
    --清除之前的流派按钮
    for k, v in ipairs(cardSchoolItemTable) do
        MResLoader:DestroyObj(v)
    end
    --清除数据
    cardAttrItemTable = {}
    cardAttrToggles = {}
    cardSchoolItemTable = {}
    --创建属性按钮
    local itemAttr = self.panel.CardAttrTog.gameObject
    local gridAttr = self.panel.CardAttrGroup
    if type == 100 then
        --处理按钮
        local cardSchoolTable = self.mgr.GetCardSchoolTableByProId(MPlayerInfo.ProID)
        for k, v in pairs(cardSchoolTable) do
            local tempAttr = self:CloneObj(itemAttr)
            tempAttr.transform:SetParent(gridAttr.gameObject.transform)
            tempAttr.transform.localScale = itemAttr.transform.localScale
            tempAttr:SetActiveEx(true)
            --重新命名
            local className = TableUtil.GetAutoAddSkilPointDetailTable().GetRowByID(v).ClassName
            local onText = MLuaClientHelper.GetOrCreateMLuaUICom(tempAttr.transform:Find("ON/Text"))
            onText.LabText = className
            local offText = MLuaClientHelper.GetOrCreateMLuaUICom(tempAttr.transform:Find("OFF/Text"))
            offText.LabText = className
            --是否已选择处理
            local tempTogEx = tempAttr:GetComponent("UIToggleEx")
            tempTogEx.onValueChanged:RemoveAllListeners()
            if self.mgr.GetCardSchoolSelectBySchoolId(v) then
                tempTogEx.isOn = true
            else
                tempTogEx.isOn = false
            end
            --Toggle监听
            tempTogEx.onValueChanged:AddListener(function(value)
                --是否刷新按钮们
                if isRefreshCardScroll then
                    --清空输入搜索
                    self.panel.CardSearchInputField.Input.text = ""
                    --清除属性筛选数据
                    self.mgr.ClearCardAttrSelect()
                    --清空分类选择
                    self.panel.CardTypeSelectText.LabText = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MAIN")
                    self.mgr.SetCardTypeSelect(1)
                    --清除选中卡片ID
                    self.mgr.SetCheckMonsterCardId(nil)
                    self.mgr.SetSelectCardIndex(1)
                    --选中
                    self.mgr.SetCardSchoolSelect(v, value)
                    --清空按钮显示
                    self.panel.CardCleanupButton.gameObject:SetActiveEx((self.mgr.GetCardSelectSchoolNum() ~= 0) or (self.mgr.GetCardSelectAttrNum() ~= 0))
                    self:CreateCardScroll(self.mgr.GetTypeShowCard(4))
                end
            end)
            table.insert(cardSchoolItemTable, tempAttr)
            cardAttrToggles[type] = cardAttrToggles[type] or {}
            cardAttrToggles[type][v] = tempTogEx
            --清空按钮显示
            self.panel.CardCleanupButton.gameObject:SetActiveEx((self.mgr.GetCardSelectSchoolNum() ~= 0) or (self.mgr.GetCardSelectAttrNum() ~= 0))
        end
    else
        --处理按钮
        for k, v in ipairs(self.mgr.GetCardAttrListTable()[type]) do
            local tempAttr = self:CloneObj(itemAttr)
            tempAttr.transform:SetParent(gridAttr.gameObject.transform)
            tempAttr.transform.localScale = itemAttr.transform.localScale
            tempAttr:SetActiveEx(true)
            --重新命名
            local onText = MLuaClientHelper.GetOrCreateMLuaUICom(tempAttr.transform:Find("ON/Text"))
            onText.LabText = v.TypeName
            local offText = MLuaClientHelper.GetOrCreateMLuaUICom(tempAttr.transform:Find("OFF/Text"))
            offText.LabText = v.TypeName
            --是否已选择处理
            local tempTogEx = tempAttr:GetComponent("UIToggleEx")
            tempTogEx.onValueChanged:RemoveAllListeners()
            if self.mgr.GetCardAttrSelect()[type] then
                if self.mgr.GetCardAttrSelect()[type][k] then
                    tempTogEx.isOn = true
                else
                    tempTogEx.isOn = false
                end
            else
                tempTogEx.isOn = false
            end
            --Toggle监听
            tempTogEx.onValueChanged:AddListener(function(value)
                --是否刷新按钮们
                if isRefreshCardScroll then
                    --清空输入搜索
                    self.panel.CardSearchInputField.Input.text = ""
                    --清除流派筛选数据
                    self.mgr.ClearCardSchoolSelect()
                    --清除选中数据
                    self.mgr.SetCheckMonsterCardId(nil)
                    self.mgr.SetSelectCardIndex(1)
                    --选中
                    self.mgr.SetCardAttrSelect(type, k, value)
                    --清空按钮显示
                    self.panel.CardCleanupButton.gameObject:SetActiveEx((self.mgr.GetCardSelectAttrNum() ~= 0) or (self.mgr.GetCardSelectSchoolNum() ~= 0))
                    self:CreateCardScroll(self.mgr.GetTypeShowCard(3))
                end
            end)
            table.insert(cardAttrItemTable, tempAttr)
            cardAttrToggles[type] = cardAttrToggles[type] or {}
            cardAttrToggles[type][v] = tempTogEx
            --清空按钮显示
            self.panel.CardCleanupButton.gameObject:SetActiveEx((self.mgr.GetCardSelectAttrNum() ~= 0) or (self.mgr.GetCardSelectSchoolNum() ~= 0))
        end
    end
    self.panel.CardAttrTog:SetActiveEx(false)
end

--清空属性筛选
function IllustrationCardCtrl:CleanUpCardAttrSearch(isCreate)

    --清除筛选数据
    self.mgr.ClearCardAttrSelect()
    --清空按钮显示
    self.panel.CardCleanupButton.gameObject:SetActiveEx((self.mgr.GetCardSelectAttrNum() ~= 0) or (self.mgr.GetCardSelectSchoolNum() ~= 0))
    --清除分类选择数据
    self.mgr.SetCheckMonsterCardId(nil)
    self.mgr.SetSelectCardIndex(1)
    isRefreshCardScroll = false
    for k, v in ipairs(cardAttrItemTable) do
        v:GetComponent("UIToggleEx").isOn = false
    end
    isRefreshCardScroll = true
    if isCreate then
        self:CreateCardScroll(self.mgr.GetTypeShowCard(3))
    end

end

--清空流派筛选
function IllustrationCardCtrl:CleanUpCardSchoolSearch(isCreate)

    --清除筛选数据
    self.mgr.ClearCardSchoolSelect()
    --清空按钮显示
    self.panel.CardCleanupButton.gameObject:SetActiveEx((self.mgr.GetCardSelectSchoolNum() ~= 0) or (self.mgr.GetCardSelectAttrNum() ~= 0))
    isRefreshCardScroll = false
    for k, v in ipairs(cardSchoolItemTable) do
        local l_comp = v:GetComponent("UIToggleEx")
        if nil ~= l_comp then
            l_comp.isOn = false
        end
    end

    isRefreshCardScroll = true
    if isCreate then
        self:CreateCardScroll(self.mgr.GetTypeShowCard(0))
    end

end

--点击搜索
function IllustrationCardCtrl:OnClickCardSearchButton()

    self.panel.CardSearchPanel.gameObject:SetActiveEx(true)
    self.panel.CardSearchPanel.transform:SetAsLastSibling()
    self:CreateCardSearchInfo()

end

--搜索文字
function IllustrationCardCtrl:OnInputFieldChange(value)

    local searchStr = StringEx.DeleteEmoji(value)
    self.panel.CardSearchInputField.Input.text = searchStr
    --搜索框恢复时不刷新
    if not IsEmptyOrNil(value) then
        self.panel.CardTypeSelectText.LabText = Lang("ILLUSTRATION_DROPDOWN_MAIN")
        --清除筛选数据
        self:CleanUpCardAttrSearch(false)
        self:CleanUpCardSchoolSearch(false)
        --清除选中卡片ID
        self.mgr.SetCheckMonsterCardId(nil)
        self.mgr.SetSelectCardIndex(1)
        --清除分类数据
        self.mgr.SetCardTypeSelect(1)
    end
    --没有选择筛选时 创建卡片列表
    if self.mgr.GetCardSelectAttrNum() == 0 then
        self:CreateCardScroll(self.mgr.GetTypeShowCard(1, searchStr))
    end

end

function IllustrationCardCtrl:ClickFilter()

    local datas = {}
    for i, v in ipairs(self.mgr.DROPDOWN_CARD_STR) do
        table.insert(datas, {
            name = v,
            index = i,
        })
    end
    UIMgr:ActiveUI(UI.CtrlNames.SelectBox, function(ctrl)
        ctrl:ShowSelectBox(datas, function(data)
            self:SelectEquipPart(data.index)
        end)
    end)

end

function IllustrationCardCtrl:SelectEquipPart(equipPart)

    if not equipPart then
        logError("非法的装备部位 请检查传入的部位equipPart = %s是否在IllustraionMgr.DROPDOWN_CARD_STR中", equipPart)
        return
    end
    self.panel.CardSearchInputField.Input.text = ""
    --清除选中卡片ID
    self.mgr.SetCheckMonsterCardId(nil)
    self.mgr.SetSelectCardIndex(1)
    --清空属性筛选
    self:CleanUpCardSchoolSearch(false)
    --创建卡片列表
    self:CreateCardScroll(self.mgr.GetTypeShowCard(2, equipPart))
    self.panel.CardTypeSelectText.LabText = self.mgr.DROPDOWN_CARD_STR[equipPart]

end

function IllustrationCardCtrl:ResetData()
    --清除选中卡片ID
    self.mgr.ResetCardValues()
end

--lua custom scripts end
return IllustrationCardCtrl
