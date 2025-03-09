--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/StickerPanel"
require "UI/Template/StickItemTemplate"
require "UI/Template/StickerScrollItemTemplate"
require "UI/Template/StickerGridDetailCellTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
StickerCtrl = class("StickerCtrl", super)
--lua class define end

--lua functions
function StickerCtrl:ctor()
    
    super.ctor(self, CtrlNames.Sticker, UILayer.Function, nil, ActiveType.None)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    
end --func end
--next--
function StickerCtrl:Init()
    
    self.panel = UI.StickerPanel.Bind(self)
    super.Init(self)

    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
    self.titleStickerData = DataMgr:GetData("TitleStickerData")
    self.chatData = DataMgr:GetData("ChatData")

    local l_contentGridLayout = self.panel.StickerContent:GetComponent("GridLayoutGroup")
    self.gridCellWidth = l_contentGridLayout.cellSize.x
    self.gridCellHeight = l_contentGridLayout.cellSize.y

    -- 当前选中的贴纸item，可能是StickItemTemplate或者StickerScrollItemTemplate
    self.selectedStickerItem = nil

    -- 贴纸栏位
    self.stickerGridPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StickItemTemplate,
        TemplateParent = self.panel.StickerWall.transform,
        TemplatePrefab = self.panel.StickItemTemplate.LuaUIGroup.gameObject
    })
    -- 贴纸列表
    self.stickerPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StickerScrollItemTemplate,
        TemplateParent = self.panel.StickerContent.transform,
        TemplatePrefab = self.panel.StickerScrollItemTemplate.LuaUIGroup.gameObject
    })
    -- 栏位列表
    self.gridDetailPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StickerGridDetailCellTemplate,
        TemplateParent = self.panel.GridDetailContent.transform,
        TemplatePrefab = self.panel.StickerGridDetailCell.LuaUIGroup.gameObject
    })

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Sticker)
    end)

    self.panel.StickerShareBtn:AddClick(function()
        local l_openPos = MUIManager.UIRoot.transform:InverseTransformPoint(self.panel.StickerShareBtn.transform.position)
        l_openPos = Vector2.New(l_openPos.x, l_openPos.y - 80)
        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = { Lang("CHAT_CHANNEL_TEAM"), Lang("CHAT_CHANNEL_GUILD"), Lang("CHAT_CHANNEL_CUR_SCENE") },
            callbackTb = { function()
                self.titleStickerMgr.ShareSticker(self.chatData.EChannel.TeamChat)
            end, function()
                self.titleStickerMgr.ShareSticker(self.chatData.EChannel.GuildChat)
            end, function()
                self.titleStickerMgr.ShareSticker(self.chatData.EChannel.CurSceneChat)
            end },
            dataopenPos = l_openPos,
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
    end)

    self.panel.TitleShareBtn:AddClick(function()
        local l_openPos = MUIManager.UIRoot.transform:InverseTransformPoint(self.panel.TitleShareBtn.transform.position)
        l_openPos = Vector2.New(l_openPos.x, l_openPos.y - 80)
        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = { Lang("CHAT_CHANNEL_TEAM"), Lang("CHAT_CHANNEL_GUILD"), Lang("CHAT_CHANNEL_CUR_SCENE") },
            callbackTb = { function()
                if self.curTitleInfo then
                    self.titleStickerMgr.ShareTitle(self.chatData.EChannel.TeamChat, self.curTitleInfo.titleId)
                end
            end, function()
                if self.curTitleInfo then
                    self.titleStickerMgr.ShareTitle(self.chatData.EChannel.GuildChat, self.curTitleInfo.titleId)
                end
            end, function()
                if self.curTitleInfo then
                    self.titleStickerMgr.ShareTitle(self.chatData.EChannel.CurSceneChat, self.curTitleInfo.titleId)
                end
            end },
            dataopenPos = l_openPos,
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
    end)

    self.panel.TitleName:AddClick(function()
        if self.curTitleInfo then
            UIMgr:ActiveUI(UI.CtrlNames.Viewtitle, {titleId = self.curTitleInfo.titleId})
        end
    end)

    self.panel.StickerIcon:AddClick(function()
        if self.curTitleInfo then
            UIMgr:ActiveUI(UI.CtrlNames.Viewstickers, {stickerId = self.curTitleInfo.titleTableInfo.StickersID})
        end
    end)

    self.panel.UnlockTog.Tog.isOn = false
    self.panel.UnlockTog.Tog.onValueChanged:AddListener(function(isOn)
        if self.shownStickerLength then
            self:RefreshLeftStickerInfosPanel(self.shownStickerLength)
        end
    end)

    self:InitStickerTogs()
    self:RefreshStickerGrids(true)
    self:RefreshRightDetail()
end --func end
--next--
function StickerCtrl:Uninit()
    
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function StickerCtrl:OnActive()
    self.titleStickerMgr.RequestGridState()

    if self.uiPanelData and self.uiPanelData.selectedStickerId then
        self:SelectSticker(self.uiPanelData.selectedStickerId)
    end

    --新手指引相关 
    local l_beginnerGuideChecks = {"CheckStickersGuide"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())

end --func end
--next--
function StickerCtrl:OnDeActive()
    
    
end --func end
--next--
function StickerCtrl:Update()
    
    
end --func end
--next--
function StickerCtrl:Refresh()
    
    
end --func end
--next--
function StickerCtrl:OnLogout()
    
    
end --func end
--next--
function StickerCtrl:OnReconnected(roleData)
    
    
end --func end
--next--
function StickerCtrl:Show(withTween)
    
    if not super.Show(self, withTween) then return end
    
end --func end
--next--
function StickerCtrl:Hide(withTween)
    
    if not super.Hide(self, withTween) then return end
    
end --func end
--next--
function StickerCtrl:BindEvents()
    self:BindEvent(self.titleStickerMgr.EventDispatcher,self.titleStickerMgr.EEventType.StickerGridsRefresh, function()
        self:RefreshStickerGrids()
        self:RefreshRightDetail()
    end)
    self:BindEvent(self.titleStickerMgr.EventDispatcher,self.titleStickerMgr.EEventType.StickerInfosRefresh, function()
        for i = 1, #self.stickerTogs do
            if self.stickerTogs[i].TogEx.isOn then
                self:RefreshLeftStickerInfosPanel(i)
                break
            end
        end
    end)
    
end --func end

--next--
--lua functions end

--lua custom scripts

-- 初始化标签信息
function StickerCtrl:InitStickerTogs()
    self.stickerTogs = {}
    self.panel.Tog:SetActiveEx(false)
    local group = self.panel.Toggroup:GetComponent('UIToggleExGroup')
    for i = 1, self.titleStickerData.MAX_STICKER_LENGTH do
        local l_stickInfos = self.titleStickerData.GetStickerInfosByLength(i)
        if #l_stickInfos ~= 0 then
            local l_togGo = self:CloneObj(self.panel.Tog.gameObject)
            l_togGo:SetActiveEx(true)
            l_togGo.transform:SetParent(self.panel.Tog.transform.parent, false)
            local l_togCom = l_togGo:GetComponent('MLuaUICom')
            l_togCom.TogEx.group = group
            l_togCom.TogEx.onValueChanged:AddListener(function(value)
                if value then
                    -- 切页签，清除选中状态
                    if self.selectedStickerItem and self.selectedStickerItem.IsStickerScrollItemTemplate then
                        self.selectedStickerItem = nil
                    end
                    self:RefreshLeftStickerInfosPanel(i)
                end
            end)
            local l_togName = Lang("STICKER_TOGGLE_NAME", i)
            MLuaClientHelper.GetOrCreateMLuaUICom(l_togGo.transform:Find("ON/Txt")).LabText = l_togName
            MLuaClientHelper.GetOrCreateMLuaUICom(l_togGo.transform:Find("Off/Txt")).LabText = l_togName

            table.insert(self.stickerTogs, l_togCom)
            -- 默认选中第一个
            if i == 1 then
                l_togCom.TogEx.isOn = true
            end
        end
    end

end

-- 选中特定的贴纸
function StickerCtrl:SelectSticker(stickerId)
    -- 切换页签
    local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(stickerId)
    if l_stickerRow and self.stickerTogs[l_stickerRow.Length] then
        self.stickerTogs[l_stickerRow.Length].TogEx.isOn = true
    end
    local l_items = self.stickerPool:GetItems()
    local l_foundItem = nil
    for _, item in ipairs(l_items) do
        if item:GetStickerInfo().stickerId == stickerId then
            l_foundItem = item
            break
        end
    end
    if l_foundItem then
        self:HandleStickerClicked(l_foundItem)
    end
end


-- 刷新贴纸栏位
function StickerCtrl:RefreshStickerGrids(isInit)
    -- 保存选中状态
    local l_selectedIndex = -1
    -- 默认选中第一个
    if isInit then
        l_selectedIndex = 1
    end
    if self.selectedStickerItem and not self.selectedStickerItem.IsStickerScrollItemTemplate then
        l_selectedIndex = self.selectedStickerItem.ShowIndex
    end
    local l_isStickerUsing = false      -- 是否在使用贴纸
    local l_templateDatas = {}
    local l_stickerGridInfos = self.titleStickerData.GetStickerGridInfos()
    local l_lastEnd = 0
    for i = 1, #l_stickerGridInfos do
        local l_stickerGridInfo = l_stickerGridInfos[i]
        table.insert(l_templateDatas, {
            stickerGridInfo = l_stickerGridInfo,        -- 贴纸栏位信息
            stickerCtrl = self,
            isCovered = i <= l_lastEnd,                 -- 是否被覆盖
        })
        if i > l_lastEnd then
            l_lastEnd = i + l_stickerGridInfo:GetLengthFunc() - 1
        end

        l_isStickerUsing = l_isStickerUsing or l_stickerGridInfo.stickerId ~= 0
    end
    self.stickerGridPool:ShowTemplates({Datas = l_templateDatas})
    if l_selectedIndex ~= -1 then
        self.selectedStickerItem = self.stickerGridPool:GetItem(l_selectedIndex)
        self.selectedStickerItem:SetSelected(true)
    end
    self.panel.StickerShareBtn:SetActiveEx(l_isStickerUsing)
end

-- 刷新左侧贴纸展示面板
function StickerCtrl:RefreshLeftStickerInfosPanel(stickerLength)
    if not self.spacingConfig then
        self.spacingConfig = {
            [1] = 0,
            [2] = 30,
            [3] = 60,
            [4] = 0,
            [5] = 0
        }
    end

    -- 保存选中状态
    local l_selectedIndex = -1
    if self.selectedStickerItem and self.selectedStickerItem.IsStickerScrollItemTemplate then
        l_selectedIndex = self.selectedStickerItem.ShowIndex
    end

    -- 保存当前显示的贴纸长度
    self.shownStickerLength = stickerLength
    -- 设置布局信息
    local l_contentGridLayout = self.panel.StickerContent:GetComponent("GridLayoutGroup")
    l_contentGridLayout.cellSize = Vector2(self.gridCellWidth * stickerLength, self.gridCellHeight)
    local l_rowCount = math.floor(l_contentGridLayout:GetComponent("RectTransform").rect.width / l_contentGridLayout.cellSize.x)
    local l_spacing = self.spacingConfig[l_rowCount] or 0
    l_contentGridLayout.constraintCount = l_rowCount
    l_contentGridLayout.spacing = Vector2(l_spacing, 0)

    local l_stickInfos = self.titleStickerData.GetStickerInfosByLength(stickerLength)
    local l_templateDatas = {}
    for _, stickerInfo in ipairs(l_stickInfos) do
        if not self.panel.UnlockTog.Tog.isOn or self.panel.UnlockTog.Tog.isOn == stickerInfo.isOwned then
            table.insert(l_templateDatas, {
                stickerInfo = stickerInfo,        -- 贴纸信息
                stickerCtrl = self,
            })
        end
    end
    self.panel.LeftEmpty:SetActiveEx(#l_templateDatas == 0)
    self.stickerPool:ShowTemplates({Datas = l_templateDatas})
    if l_selectedIndex ~= -1 then
        self.selectedStickerItem = self.stickerPool:GetItem(l_selectedIndex)
        if self.selectedStickerItem then
            self.selectedStickerItem:SetSelected(true)
        end
    end
end


-- 处理贴纸点击选中
function StickerCtrl:HandleStickerClicked(stickItemTemplate)
    if self.selectedStickerItem then
        self.selectedStickerItem:SetSelected(false)
    end
    self.selectedStickerItem = stickItemTemplate
    self.selectedStickerItem:SetSelected(true)

    self:RefreshRightDetail()
end

-- 刷新右侧详细信息
function StickerCtrl:RefreshRightDetail()
    local l_isSelect = self.selectedStickerItem ~= nil
    self.panel.Nothing:SetActiveEx(not l_isSelect)
    self.panel.StickerDetail:SetActiveEx(false)
    self.panel.GridDetail:SetActiveEx(false)
    if not l_isSelect then return end

    if self.selectedStickerItem.GetStickerGridInfo then      -- 栏位信息
        local l_stickerGridInfo = self.selectedStickerItem:GetStickerGridInfo()
        if l_stickerGridInfo then
            if l_stickerGridInfo.status == self.titleStickerData.EStickerStatus.CanGet then
                self:OpenGridInfo(l_stickerGridInfo.index)
            elseif l_stickerGridInfo.status == self.titleStickerData.EStickerStatus.Close then
                self:OpenGridInfo(l_stickerGridInfo.index)
            elseif l_stickerGridInfo.status == self.titleStickerData.EStickerStatus.Open then
                local l_stickerInfo = self.selectedStickerItem:GetStickerInfo()
                if l_stickerInfo then
                    self:OpenStickerInfo(l_stickerInfo)
                else
                    self:OpenGridInfo(l_stickerGridInfo.index)
                end
            end
        end
    elseif self.selectedStickerItem.GetStickerInfo then      -- 贴纸信息
        local l_stickerInfo = self.selectedStickerItem:GetStickerInfo()
        self:OpenStickerInfo(l_stickerInfo)
    end
end

-- 打开称号信息
function StickerCtrl:OpenStickerInfo(stickerInfo)
    if not stickerInfo then return end
    self.panel.StickerDetail:SetActiveEx(true)
    self.panel.GridDetail:SetActiveEx(false)

    local l_titleInfo = self.titleStickerData.GetTitleInfoById(stickerInfo.titleId)
    if not l_titleInfo then return end

    self.curTitleInfo = l_titleInfo

    self.panel.StickerIcon:SetSpriteAsync(stickerInfo.tableInfo.StickersAtlas, stickerInfo.tableInfo.StickersIcon, nil, true)
    -- self.panel.StickerIcon:SetGray(not stickerInfo.isOwned)
    local l_colorHex = RoQuality.GetColorHex(l_titleInfo.itemTableInfo.ItemQuality)
    local l_nameColored = StringEx.Format("<color=#{0}>[{1}]</color>", l_colorHex, l_titleInfo.titleTableInfo.TitleName)
    self.panel.TitleName.LabText = Lang("TITLE_GET", l_nameColored)
    self.panel.TitleLine.Img.color = self.titleStickerMgr.GetQualityColor(l_titleInfo.itemTableInfo.ItemQuality)
    self.panel.Yiyongyou:SetActiveEx(l_titleInfo.isOwned)
    self.panel.Weiyongyou:SetActiveEx(not l_titleInfo.isOwned)

    -- 获取途径处理
    local l_getWay = self.titleStickerMgr.GetTitleGetWay(stickerInfo.titleId)
    self.panel.TitleCondition:SetActiveEx(l_getWay.type ~= 0)
    if l_getWay ~= 0 then
        self.panel.ConditionName.LabText = l_getWay.typeName
        self.panel.NonProgress:SetActiveEx(not l_getWay.isShowSlider)
        self.panel.Progress:SetActiveEx(l_getWay.isShowSlider)
        self.panel.ConditionGotoBtn:SetActiveEx(l_getWay.btnText ~= "")
        if l_getWay.btnText ~= "" then
            self.panel.ConditionGotoText.LabText = l_getWay.btnText
            if l_getWay.btnFunc then
                self.panel.ConditionGotoBtn:AddClick(l_getWay.btnFunc)
            end
        end
        if l_getWay.isShowSlider then
            self.panel.ProgressText.LabText = l_getWay.des
            self.panel.ProgressSlider.Slider.value = l_getWay.sliderValue
            self.panel.ProgressSliderText.LabText = l_getWay.sliderText
        else
            self.panel.NonProgressText.LabText = l_getWay.des
        end

        --self.panel.ReceiveTitleBtn:SetActiveEx(l_getWay.isDone)
        --self.panel.ReceiveTitleBtn:AddClick(l_getWay.btnFunc)
    end
end

-- 打开栏位信息
function StickerCtrl:OpenGridInfo(gridIndex)
    self.panel.StickerDetail:SetActiveEx(false)
    self.panel.GridDetail:SetActiveEx(true)

    local l_datas = {}
    local l_stickerGridInfos = self.titleStickerData.GetStickerGridInfos()
    for i = 1, #l_stickerGridInfos do
        table.insert(l_datas, {stickerGridInfo = l_stickerGridInfos[i]})
    end
    self.gridDetailPool:ShowTemplates({Datas = l_datas})
    local l_items = self.gridDetailPool:GetItems()
    if l_items[gridIndex] then
        l_items[gridIndex]:SetSelected(true)
        -- 滑动到指定区域
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.GridDetail.RectTransform)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.GridDetailContent.RectTransform)
        local l_spacing = self.panel.GridDetailContent.VGroup.spacing
        local l_y = (gridIndex - 1) * (l_items[gridIndex]:GetHeight() + l_spacing)
        if (self.panel.GridDetailContent.RectTransform.anchoredPosition.y < self.panel.GridDetailContent.RectTransform.rect.height - self.panel.GridDetail.RectTransform.rect.height
            and l_y > self.panel.GridDetailContent.RectTransform.anchoredPosition.y)
        or l_y < self.panel.GridDetailContent.RectTransform.anchoredPosition.y then
            l_y = math.min(l_y, self.panel.GridDetailContent.RectTransform.rect.height - self.panel.GridDetail.RectTransform.rect.height)
            self.panel.GridDetailContent.RectTransform.anchoredPosition = Vector3.New(0, l_y, 0)
        end
    end
end

-- 处理贴纸开始拖拽
function StickerCtrl:HandleStickerBeginDrag(stickerInfo, moveObject)
    -- 设置栏位状态
    self:SetStickerGridsState(1)
end

-- 处理贴纸拖拽中
function StickerCtrl:HandleStickerDragging(stickerInfo, moveObject)
    self:ProcessMoveObjectOverGrids(stickerInfo, moveObject, stickerInfo.tableInfo.Length)
end

-- 处理贴纸结束拖拽
function StickerCtrl:HandleStickerEndDrag(stickerInfo, moveObject, isFromGrid)
    local l_canDropIndex = self:ProcessMoveObjectOverGrids(stickerInfo, moveObject, stickerInfo.tableInfo.Length, true)
    if l_canDropIndex then
        self.titleStickerMgr.RequestChangeSticker(stickerInfo.stickerId, l_canDropIndex)
    elseif stickerInfo.gridIndex ~= 0 and isFromGrid then
        self.titleStickerMgr.RequestChangeSticker(0, stickerInfo.gridIndex)
    end
    -- 还原栏位状态
    self:SetStickerGridsState(0)
end

-- 处理物品在栏位上的移动，更新栏位的状态，如果可放置，则返回栏位的index
function StickerCtrl:ProcessMoveObjectOverGrids(stickerInfo, moveObject, length, needTip)
    local l_stickItemTemplates = self.stickerGridPool:GetItems()
    local l_firstOverlapIndex = nil
    for i = 1, #l_stickItemTemplates do
        -- 判断物品是否已经移动到栏位上
        local l_stickItemTemplate = l_stickItemTemplates[i]
        local l_moveObjCom = moveObject:GetComponent("MLuaUICom")
        if Common.Utils.IsRectTransformOverlap(l_moveObjCom.RectTransform, l_stickItemTemplate:gameObject():GetComponent("RectTransform")) then
            l_firstOverlapIndex = i
            break
        end
    end
    if not l_firstOverlapIndex then
        self:SetStickerGridsState(0)
        return
    end
    local l_canDrop = true
    if not stickerInfo.isOwned then
        if needTip then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STICKER_DROP_GRID_NOT_HAVE_STICKER"))
        end
        l_canDrop = false
    else
        for i = l_firstOverlapIndex, l_firstOverlapIndex + length - 1 do
            if i <= #l_stickItemTemplates and l_canDrop then
                l_canDrop = l_canDrop and l_stickItemTemplates[i]:CanDrop()
            else
                l_canDrop = false
                break
            end
            if not l_canDrop and needTip then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STICKER_DROP_GRID_LENGTH_NOT_ENOUGH"))
            end
        end
    end
    for i = 1, #l_stickItemTemplates do
        if i >= l_firstOverlapIndex and i <= l_firstOverlapIndex + length - 1 then
            if l_canDrop then
                l_stickItemTemplates[i]:SetState(2)
            else
                l_stickItemTemplates[i]:SetState(3)
            end
        else
            l_stickItemTemplates[i]:SetState(1)
        end
    end
    if l_canDrop then
        return l_firstOverlapIndex
    end
end

-- 设置整体栏位状态
function StickerCtrl:SetStickerGridsState(state)
    local l_stickItemTemplates = self.stickerGridPool:GetItems()
    for _, stickItemTemplate in pairs(l_stickItemTemplates) do
        stickItemTemplate:SetState(state)
    end
end

--lua custom scripts end
return StickerCtrl