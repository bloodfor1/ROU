--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/TitlestickerPanel"
require "UI/Template/TitleCategoryTemplate"
require "UI/Template/TitleCellTemplate"
require "UI/Template/StickerWallTemplent"
require "Common/CommonCharUtil"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
TitlestickerHandler = class("TitlestickerHandler", super)
--lua class define end

--lua functions
function TitlestickerHandler:ctor()

    super.ctor(self, HandlerNames.Titlesticker, 0)

end --func end
--next--
function TitlestickerHandler:Init()

    self.panel = UI.TitlestickerPanel.Bind(self)
    super.Init(self)

    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
    self.titleStickerData = DataMgr:GetData("TitleStickerData")

    self.chatData = DataMgr:GetData("ChatData")

    -- 当前选中的称号
    self.selectedTitleCellTemplate = nil

    -- 当前搜索字符串
    self.searchText = ""

    self:InitPanel()
end --func end
--next--
function TitlestickerHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function TitlestickerHandler:OnActive()
    if self.ctrlRef.uiPanelData and self.ctrlRef.uiPanelData.titleId then
        self:SetSearchTextAndSelectTitle(self.ctrlRef.uiPanelData.titleId)
    end
end --func end
--next--
function TitlestickerHandler:OnDeActive()
    -- do nothing
end --func end
--next--
function TitlestickerHandler:Update()
    if nil ~= self.defaultSortPool then
        self.defaultSortPool:OnUpdate()
    end

    if nil ~= self.categorySortPool then
        self.categorySortPool:OnUpdate()
    end
end --func end
--next--
function TitlestickerHandler:BindEvents()
    self:BindEvent(self.titleStickerMgr.EventDispatcher, self.titleStickerMgr.EEventType.StickerGridsRefresh, self.RefreshStickers)
    self:BindEvent(self.titleStickerMgr.EventDispatcher, self.titleStickerMgr.EEventType.CurrentTitleRefresh, function()
        self:RefreshCurrentTitle()
        self:RefreshTitleDetail()
    end)
    self:BindEvent(self.titleStickerMgr.EventDispatcher, self.titleStickerMgr.EEventType.TitleRefresh, function()
        --self:RefreshTitleList()
        self:RefreshTitleDetail()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

function TitlestickerHandler:InitPanel()

    -- 红点处理
    self:NewRedSign({
        Key = eRedSignKey.StickerButton,
        ClickButton = self.panel.ShowStickerBtn,
    })

    self.panel.InputClearBtn:SetActiveEx(false)
    -- 搜索输入框
    self.panel.SearchInput:OnInputFieldChange(function(value)
        self.searchText = StringEx.DeleteEmoji(value)
        self:RefreshTitleList()
        self.panel.InputClearBtn:SetActiveEx(value ~= "")
        if value ~= "" then
            self.panel.UnLockTog.Tog.isOn = false
        end
    end)

    self.panel.SearchInput.Input.onValidateInput = function(str, index, char)
        local l_num = Common.CommonCharUtil.CalcCharCount(str, true)
        if l_num >= 14 then
            return 0
        end

        return tonumber(char)
    end

    self.panel.InputClearBtn:AddClick(function()
        self.panel.SearchInput.Input.text = ""
    end)
    self.panel.UnLockTog.Tog.isOn = false
    self.panel.UnLockTog.Tog.onValueChanged:AddListener(function(isOn)
        if isOn then
            self.panel.SearchInput.Input.text = ""
        end
        self:RefreshTitleList()
    end)
    self.panel.ShowStickerBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Sticker)
    end)

    self.panel.StickerGotoBtn:AddClick(function()
        if self.selectedTitleCellTemplate then
            local l_titleInfo = self.selectedTitleCellTemplate:GetTitleInfo()
            UIMgr:ActiveUI(UI.CtrlNames.Sticker, { selectedStickerId = l_titleInfo.titleTableInfo.StickersID })
        end
    end)

    self.panel.ShowBtn:AddClick(function()
        self.titleStickerMgr.UpdateTitleStatus(0, TitleStatus.TitleStatus_Hide)
    end)
    self.panel.HideBtn:AddClick(function()
        self.titleStickerMgr.UpdateTitleStatus(0, TitleStatus.TitleStatus_Show)
    end)
    self.panel.TitleShareBtn:AddClick(function()
        local l_openPos = MUIManager.UIRoot.transform:InverseTransformPoint(self.panel.TitleShareBtn.transform.position)
        l_openPos = Vector2.New(l_openPos.x, l_openPos.y - 80)
        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = { Lang("CHAT_CHANNEL_TEAM"), Lang("CHAT_CHANNEL_GUILD"), Lang("CHAT_CHANNEL_CUR_SCENE") },
            callbackTb = { function()
                if self.selectedTitleCellTemplate then
                    local l_titleId = self.selectedTitleCellTemplate:GetTitleInfo().titleId
                    self.titleStickerMgr.ShareTitle(self.chatData.EChannel.TeamChat, l_titleId)
                end
            end, function()
                if self.selectedTitleCellTemplate then
                    local l_titleId = self.selectedTitleCellTemplate:GetTitleInfo().titleId
                    self.titleStickerMgr.ShareTitle(self.chatData.EChannel.GuildChat, l_titleId)
                end
            end, function()
                if self.selectedTitleCellTemplate then
                    local l_titleId = self.selectedTitleCellTemplate:GetTitleInfo().titleId
                    self.titleStickerMgr.ShareTitle(self.chatData.EChannel.CurSceneChat, l_titleId)
                end
            end },
            dataopenPos = l_openPos,
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
    end)

    self.panel.TitleName:AddClick(function()
        if self.selectedTitleCellTemplate then
            local l_titleId = self.selectedTitleCellTemplate:GetTitleInfo().titleId
            UIMgr:ActiveUI(UI.CtrlNames.Viewtitle, { titleId = l_titleId })
        end
    end)

    self.panel.StickerIcon:AddClick(function()
        if self.selectedTitleCellTemplate then
            local l_titleInfo = self.selectedTitleCellTemplate:GetTitleInfo()
            UIMgr:ActiveUI(UI.CtrlNames.Viewstickers, { stickerId = l_titleInfo.titleTableInfo.StickersID })
        end
    end)

    self.panel.ReceiveTitleBtn:AddClick(function()

    end)
    self.panel.ActiveTitleBtn:AddClick(function()
        if self.selectedTitleCellTemplate then
            local l_titleInfo = self.selectedTitleCellTemplate:GetTitleInfo()
            self.titleStickerMgr.UpdateTitleStatus(l_titleInfo.titleId, TitleStatus.TitleStatus_SetId)
        end
    end)
    self.panel.DeactiveTitleBtn:AddClick(function()
        if self.selectedTitleCellTemplate then
            local l_titleInfo = self.selectedTitleCellTemplate:GetTitleInfo()
            self.titleStickerMgr.UpdateTitleStatus(0, TitleStatus.TitleStatus_SetId)
        end
    end)


    -- 初始化下拉框
    self.panel.SortDrop.DropDown:ClearOptions()
    self.panel.SortDrop:SetDropdownOptions({ Lang("TITLE_SORT_DEFAULT"), Lang("TITLE_SORT_CATEGORY") })
    self.panel.SortDrop.DropDown.onValueChanged:AddListener(function(index)
        self.titleStickerData.RemoveAllTitleNew()
        -- index 0默认排序，1按分类排序
        self:RefreshTitleList()
    end)

    -- 默认的滑动区
    self.defaultSortPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TitleCellTemplate,
        TemplateParent = self.panel.DefaultContent.transform,
        TemplatePrefab = self.panel.TitleCell.LuaUIGroup.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
    -- 分类的滑动区
    self.categorySortPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TitleCategoryTemplate,
        TemplateParent = self.panel.CategoryContent.transform,
        TemplatePrefab = self.panel.TitleCategory.LuaUIGroup.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })

    self.stickersTemplate = self:NewTemplate("StickerWallTemplent", {
        TemplateParent = self.panel.StickerWall.transform,
    })

    self:RefreshCurrentTitle()

    -- 刷新称号列表
    self:RefreshTitleList()
    self:RefreshTitleDetail()

    self:RefreshStickers()
end

function TitlestickerHandler:CanTitleShow(titleInfo)
    local l_ownedMatched = not self.panel.UnLockTog.Tog.isOn or titleInfo.isOwned
    local l_isSearchTextMatched = self.searchText == "" or string.find(titleInfo.titleTableInfo.TitleName, self.searchText)
    return l_ownedMatched and l_isSearchTextMatched
end

function TitlestickerHandler:SetSearchTextAndSelectTitle(titleId)
    local l_titleRow = TableUtil.GetTitleTable().GetRowByTitleID(titleId, true)
    if l_titleRow then
        self.panel.SearchInput.Input.text = l_titleRow.TitleName
        self:SelectTitle(titleId)
    end
end

-- 选中特定的称号
function TitlestickerHandler:SelectTitle(titleId)
    -- 0默认排序，1按分类排序
    local l_sortIndex = self.panel.SortDrop.DropDown.value
    local l_foundItem = nil
    if l_sortIndex == 0 then
        local l_titleItems = self.defaultSortPool:GetItems()
        for _, titleItem in ipairs(l_titleItems) do
            if titleItem:GetTitleInfo().titleId == titleId then
                l_foundItem = titleItem
                break
            end
        end
    elseif l_sortIndex == 1 then
        local l_items = self.categorySortPool:GetItems()
        for _, item in ipairs(l_items) do
            local l_titleItems = item:GetTitleItems()
            for _, titleItem in ipairs(l_titleItems) do
                if titleItem:GetTitleInfo().titleId == titleId then
                    l_foundItem = titleItem
                    break
                end
            end
            if l_foundItem then
                break
            end
        end
    end

    if l_foundItem then
        self:HandleTitleCellClicked(l_foundItem)
    end
end


-- 刷新贴纸信息
function TitlestickerHandler:RefreshStickers()
    local l_gridInfos = {}
    local l_stickerGridInfos = self.titleStickerData.GetStickerGridInfos()
    local l_lastEnd = 0
    for i = 1, #l_stickerGridInfos do
        local l_stickerGridInfo = l_stickerGridInfos[i]
        table.insert(l_gridInfos, {
            stickerId = l_stickerGridInfo.stickerId,
            status = l_stickerGridInfo.status,
            isCovered = i <= l_lastEnd, -- 是否被覆盖
        })
        if i > l_lastEnd then
            l_lastEnd = i + l_stickerGridInfo:GetLengthFunc() - 1
        end
    end
    self.stickersTemplate:SetData({ bgType = "black", gridInfos = l_gridInfos })
end

-- 刷新当前称号
function TitlestickerHandler:RefreshCurrentTitle()
    local l_activeTitleInfo = self.titleStickerData.GetActiveTitle()
    if l_activeTitleInfo then
        self.panel.EquipTitleName.LabText = StringEx.Format("[{0}]", l_activeTitleInfo.titleTableInfo.TitleName)
        self.panel.EquipTitleName.LabColor = self.titleStickerMgr.GetQualityColor(l_activeTitleInfo.itemTableInfo.ItemQuality)
        self.panel.ShowBtn:SetActiveEx(self.titleStickerData.IsTitleShown)
        self.panel.HideBtn:SetActiveEx(not self.titleStickerData.IsTitleShown)
    else
        self.panel.EquipTitleName.LabText = Lang("TITLE_EMPTY")
        self.panel.EquipTitleName.LabColor = self.titleStickerMgr.GetQualityColor(0)
        self.panel.ShowBtn:SetActiveEx(false)
        self.panel.HideBtn:SetActiveEx(false)
    end
end

function TitlestickerHandler:RefreshTitleList()
    -- 0默认排序，1按分类排序
    local l_sortIndex = self.panel.SortDrop.DropDown.value

    -- 查找是否有符合要求的称号
    local l_hasTitleMatched = false
    for _, titleInfo in pairs(self.titleStickerData.GetTitleInfosByIndex(0)) do
        if self:CanTitleShow(titleInfo) then
            l_hasTitleMatched = true
            break
        end
    end
    self.panel.LeftScrollDefault:SetActiveEx(l_hasTitleMatched and l_sortIndex == 0)
    self.panel.LeftScrollCategory:SetActiveEx(l_hasTitleMatched and l_sortIndex == 1)
    self.panel.LeftEmpty:SetActiveEx(not l_hasTitleMatched)
    if not l_hasTitleMatched then
        return
    end

    local l_lastSelectedTitleId = nil
    if self.selectedTitleCellTemplate then
        l_lastSelectedTitleId = self.selectedTitleCellTemplate:GetTitleInfo().titleId
        self.selectedTitleCellTemplate = nil
    end

    if l_sortIndex == 0 then
        local l_titleInfos = self.titleStickerData.GetTitleInfosByIndex(0)
        local l_datas = {}
        for i = 1, #l_titleInfos do
            if self:CanTitleShow(l_titleInfos[i]) then
                table.insert(l_datas, { titleInfo = l_titleInfos[i], titleHandler = self })
            end
        end
        self.defaultSortPool:ShowTemplates({ Datas = l_datas })
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.DefaultContent.transform)
    elseif l_sortIndex == 1 then
        local l_titleIndexInfos = self.titleStickerData.GetTitleIndexInfos()
        local l_datas = {}
        for i = 1, #l_titleIndexInfos do
            table.insert(l_datas, { titleIndexInfo = l_titleIndexInfos[i],
                                    canTitleShownFunc = l_canTitleShownFunc,
                                    titleHandler = self,
                                    titleCellGo = self.panel.TitleCell.LuaUIGroup.gameObject })
        end
        self.categorySortPool:ShowTemplates({ Datas = l_datas })
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.CategoryContent.transform)
    end

    if l_lastSelectedTitleId then
        self:SelectTitle(l_lastSelectedTitleId)
    end
end

function TitlestickerHandler:RefreshTitleDetail()
    local l_isSelected = self.selectedTitleCellTemplate ~= nil
    self.panel.Detail:SetActiveEx(l_isSelected)
    self.panel.Nothing:SetActiveEx(not l_isSelected)
    if not l_isSelected then
        return
    end

    local l_titleInfo = self.selectedTitleCellTemplate:GetTitleInfo()
    local titleID=l_titleInfo.titleTableInfo.TitleID
    local titleData=self:_getTitleByTID(titleID)
    self.panel.TimeLimit.LabText=""

    if titleData then
        local expireTime=titleData:GetExpireTime()
        if expireTime>0 then
            local l_timeTable = Common.TimeMgr.GetTimeTable(Common.TimeMgr.GetLocalTimestamp(expireTime))
            local str = Lang("DATE_YY_MM_DD_H_M", l_timeTable.year, l_timeTable.month, l_timeTable.day, l_timeTable.hour, l_timeTable.min)
            self.panel.TimeLimit.LabText=Common.Utils.Lang("C_EXPIRE_TIME", str)
        end
    end
    self.panel.TitleName.LabText = StringEx.Format("[{0}]", l_titleInfo.titleTableInfo.TitleName)
    self.panel.TitleName.LabColor = self.titleStickerMgr.GetQualityColor(l_titleInfo.itemTableInfo.ItemQuality)
    self.panel.TitleLine.Img.color = self.titleStickerMgr.GetQualityColor(l_titleInfo.itemTableInfo.ItemQuality)
    self.panel.StickerInfo:SetActiveEx(l_titleInfo.titleTableInfo.StickersID ~= 0)
    if l_titleInfo.titleTableInfo.StickersID ~= 0 then
        local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(l_titleInfo.titleTableInfo.StickersID)
        if l_stickerRow then
            self.panel.StickerIcon:SetSpriteAsync(l_stickerRow.StickersAtlas, l_stickerRow.StickersIcon, nil, true)
        end
    end

    -- 获取途径处理
    local l_getWay = self.titleStickerMgr.GetTitleGetWay(l_titleInfo.titleId)
    self.panel.TitleCondition:SetActiveEx(l_getWay.type ~= 0)
    if l_getWay ~= 0 then
        self.panel.ConditionName.LabText = l_getWay.typeName
        self.panel.NonProgress:SetActiveEx(not l_getWay.isShowSlider)
        self.panel.Progress:SetActiveEx(l_getWay.isShowSlider)
        self.panel.ConditionGotoBtn:SetActiveEx(l_getWay.btnText ~= "")
        if l_getWay.btnText ~= "" then
            self.panel.ConditionGotoText.LabText = l_getWay.btnText
        end
        if l_getWay.btnFunc then
            self.panel.ConditionGotoBtn:AddClick(l_getWay.btnFunc)
            self.panel.ReceiveTitleBtn:AddClick(l_getWay.btnFunc)
        end
        if l_getWay.isShowSlider then
            self.panel.ProgressText.LabText = l_getWay.des
            self.panel.ProgressSlider.Slider.value = l_getWay.sliderValue
            self.panel.ProgressSliderText.LabText = l_getWay.sliderText
        else
            self.panel.NonProgressText.LabText = l_getWay.des
        end

        self.panel.ReceiveTitleBtn:SetActiveEx(l_getWay.isDone and not l_titleInfo.isOwned)
        self.panel.Weijihuo:SetActiveEx(not l_getWay.isDone and not l_titleInfo.isOwned)
    end

    local l_isActive = self.titleStickerData.IsTitleActive(l_titleInfo.titleId)
    self.panel.ActiveTitleBtn:SetActiveEx(l_titleInfo.isOwned and not l_isActive)
    self.panel.DeactiveTitleBtn:SetActiveEx(l_titleInfo.isOwned and l_isActive)
end

function TitlestickerHandler:HandleTitleCellClicked(titleCellTemplate)
    if self.selectedTitleCellTemplate == titleCellTemplate then
        return
    end

    if self.selectedTitleCellTemplate then
        self.selectedTitleCellTemplate:SetSelected(false)
    end
    self.selectedTitleCellTemplate = titleCellTemplate
    self.selectedTitleCellTemplate:SetSelected(true)

    self:RefreshTitleDetail()
end

---@return ItemData
function TitlestickerHandler:_getTitleByTID(tid)
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local types = { GameEnum.EBagContainerType.Title,  GameEnum.EBagContainerType.TitleUsing}
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    if items == nil then
        return nil
    end
    if #items == 0 then
        return nil
    end
    return items[1]
end

--lua custom scripts end
return TitlestickerHandler