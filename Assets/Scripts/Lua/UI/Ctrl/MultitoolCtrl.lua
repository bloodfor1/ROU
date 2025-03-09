--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MultitoolPanel"

require "Data/Model/BagModel"
require "UI/Template/ItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MultitoolCtrl = class("MultitoolCtrl", super)
--lua class define end

--lua functions
function MultitoolCtrl:ctor()
    super.ctor(self, CtrlNames.Multitool, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
end --func end
--next--
function MultitoolCtrl:Init()
    self.panel = UI.MultitoolPanel.Bind(self)
    super.Init(self)
    self.panel.BtnClose:AddClick(function()
        self:CloseSelfWithAction()
    end)
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    ---@type ModuleMgr.OpenSystemMgr
    self.openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.specialShowFunc = {}
    self.panel.BtnClose1.gameObject:SetActiveEx(true)
    self.panel.BtnClose1.Listener.onClick = function(obj, data)
        if self.DeActiveAction ~= nil then
            self.DeActiveAction()
        end
        self.panel.BtnClose1.gameObject:SetActiveEx(false)
        self.panel.BtnClose1.Listener.onClick = nil
        UIMgr:DeActiveUI(CtrlNames.Multitool)
        MLuaClientHelper.ExecuteClickEvents(data.position, CtrlNames.Multitool)
    end

    self.panel.EmojPanel:SetActiveEx(false)
    self.panel.ItemPanel:SetActiveEx(false)
    self.panel.RedEnvelopePanel:SetActiveEx(false)

    self.panel.PasswordRedEnvelope:AddClick(function()
        self:OpenRedEnvelopeUI(MgrMgr:GetMgr("RedEnvelopeMgr").RED_TYPE.PASSWORD)
    end)
    self.panel.LuckRedEnvelope:AddClick(function()
        self:OpenRedEnvelopeUI(MgrMgr:GetMgr("RedEnvelopeMgr").RED_TYPE.LUCKY)
    end)

    --红包tog是否显示控制
    --self.panel.TogRedEnvelope:SetActiveEx(self.ShowRedEnvelope and true)

    self:InitItem()
    self:InitAchievement()
    self:InitQuickTalk()
    self:InitBuildPlanPanel()

    self:InitFuncShowPanel()

    self.panel.PageItem:SetActiveEx(false)
end --func end
function MultitoolCtrl:InitFuncShowPanel()
    self.FuncShowPool = self:NewTemplatePool({
        TemplateClassName = "FuncBtnTemplate",
        ScrollRect = self.panel.FuncShowScroll.LoopScroll,
        TemplatePrefab = self.panel.FuncBtn.gameObject,
        pagesCom = {
            pagesGroup = self.panel.FuncShowPagesGroup.UObj,
            pagesItem = self.panel.FuncShowPageItem.UObj,
            pageChildNum = 9,
        }
    })

    if self.funcInfo == nil then
        self.funcInfo = {}
        local l_tableData = TableUtil.GetChatSystemTable().GetTable()
        for _, row in ipairs(l_tableData) do
            table.insert(self.funcInfo, row)
        end
        table.sort(self.funcInfo, function(a, b)
            return a.SortID < b.SortID
        end)
    end
end
function MultitoolCtrl:InitBuildPlanPanel()
    self.SkillPlanPool = self:NewTemplatePool({
        TemplateClassName = "SkillPlanTemplate",
        ScrollRect = self.panel.SkillScroll.LoopScroll,
        TemplatePrefab = self.panel.SkillPlan.gameObject,
    })
    self.AttPlanPool = self:NewTemplatePool({
        TemplateClassName = "AttPlanTemplate",
        ScrollRect = self.panel.AttScroll.LoopScroll,
        TemplatePrefab = self.panel.AttPlan.gameObject,
    })
end
function MultitoolCtrl:UpdateBuildPlanPanel()
    --skillPlan
    local l_multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
    local l_skillPlanData = l_multiMgr.GetMultiDataBySystemId(l_multiMgr.l_skillMultiTalent)
    for i = 1, #l_skillPlanData do
        local l_skillPlanInfo = l_skillPlanData[i]
        l_skillPlanInfo.buttonMethod = function(planId)
            self:OnSkillClick(planId)
        end
    end
    self.SkillPlanPool:ShowTemplates({ Datas = l_skillPlanData })
    --attPlan
    local l_attPlanData = l_multiMgr.GetMultiDataBySystemId(146)
    for i = 1, #l_attPlanData do
        local l_attPlanInfo = l_attPlanData[i]
        l_attPlanInfo.buttonMethod = function(planId)
            self:OnAttClick(planId)
        end
    end
    self.AttPlanPool:ShowTemplates({ Datas = l_attPlanData })
end
function MultitoolCtrl:OnSkillClick(planId)
    local l_data = {
        planId = planId,
    }
    UIMgr:ActiveUI(UI.CtrlNames.BuildPlan, {
        planId = planId,
        showSkillPlan = true,
        isLocalPlan = true,
    })
    if self.InputItemAction ~= nil then
        self.InputItemAction(l_data, ChatHrefType.SkillPlan)
    end
end
function MultitoolCtrl:OnAttClick(planId)
    local l_data = {
        planId = planId,
    }
    UIMgr:ActiveUI(UI.CtrlNames.BuildPlan, {
        planId = planId,
        showSkillPlan = false,
        isLocalPlan = true,
    })
    if self.InputItemAction ~= nil then
        self.InputItemAction(l_data, ChatHrefType.AttributePlan)
    end
end

function MultitoolCtrl:InitQuickTalk()
    self.QuickTalkPool = self:NewTemplatePool({
        TemplateClassName = "QuickTalkBtnTemplate",
        ScrollRect = self.panel.TalkScroll.LoopScroll,
        TemplatePrefab = self.panel.QuickTalkBtn.gameObject,
        pagesCom = {
            pagesGroup = self.panel.QuickPagesGroup.UObj,
            pagesItem = self.panel.QuickPageItem.UObj,
            pageChildNum = 12,
        }
    })
end

function MultitoolCtrl:InitAchievement()
    self.finishAchievementTempData = nil

    local l_chatDataMgr = DataMgr:GetData("ChatData")
    self.panel.Search.Input.text = l_chatDataMgr.GetHistorySearchAchievement()
    self.panel.SearchButton:AddClick(function()
        l_chatDataMgr.SetHistorySearchAchievement(self.panel.Search.Input.text)
        local l_achievements = self:GetChatAchievementDatas(l_chatDataMgr.GetHistorySearchAchievement())
        self:UpdateAchievementDetail(l_achievements)
    end)

    self.AchievementPool = self:NewTemplatePool({
        TemplateClassName = "AchievementChatTemplate",
        ScrollRect = self.panel.CupScroll.LoopScroll,
        TemplatePrefab = self.panel.AchiBtn.gameObject,
        pagesCom = {
            pagesGroup = self.panel.AchiPagesGroup.UObj,
            pagesItem = self.panel.AchiPageItem.UObj,
            pageChildNum = 12,
        }
    })
end

function MultitoolCtrl:InitItem()
    --道具池
    self.ItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.ItemScroll.LoopScroll,
        pagesCom = {
            pagesGroup = self.panel.PagesGroup.UObj,
            pagesItem = self.panel.PageItem.UObj,
            pageChildNum = 14,
        }
    })

    self.panel.All:OnToggleExChanged(function(value)
        if value then
            self:SetItemLink(true)
        end
    end)
    self.panel.Equip:OnToggleExChanged(function(value)
        if value then
            self:SetItemLink(false, Data.BagModel.PropType.Weapon)
        end
    end)
    self.panel.Potion:OnToggleExChanged(function(value)
        if value then
            self:SetItemLink(false, Data.BagModel.PropType.Consume)
        end
    end)
    self.panel.Material:OnToggleExChanged(function(value)
        if value then
            self:SetItemLink(false, Data.BagModel.PropType.Material)
        end
    end)
    self.panel.Card:OnToggleExChanged(function(value)
        if value then
            self:SetItemLink(false, Data.BagModel.PropType.Card)
        end
    end)
end
--next--
function MultitoolCtrl:Uninit()

    self.ItemPool = nil
    self.AchievementPool = nil
    self.FuncShowPool = nil

    self.DeActiveAction = nil
    self.InputAction = nil
    self.InputItemAction = nil
    self.channelType = nil
    self.specialShowFunc = nil
    super.Uninit(self)
    self.panel = nil
    self.ShowRedEnvelope = nil
end --func end
--next--
function MultitoolCtrl:OnActive()
    self:HandleOpenUIParam()
    self:UpdateFuncShow(self.funcInfo)
end --func end
--next--
function MultitoolCtrl:OnDeActive()
    self:executeDeActiveAction()
    DataMgr:GetData("ChatData").SaveServerQuickTalkInfos()
end --func end
--next--
function MultitoolCtrl:Update()


end --func end



--next--
function MultitoolCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function MultitoolCtrl:HandleOpenUIParam()
    if self.uiPanelData == nil then
        return
    end
    if self.uiPanelData.channelType ~= nil then
        self:SetChannelType(self.uiPanelData.channelType)
    end
    if self.uiPanelData.deActiveAction ~= nil then
        self:SetDeActiveAction(self.uiPanelData.deActiveAction)
    end
    if self.uiPanelData.inputActionData ~= nil then
        local l_inputFunc = self.uiPanelData.inputActionData.inputFunc
        local l_inputItemFunc = self.uiPanelData.inputActionData.inputItemFunc
        local l_extraData = self.uiPanelData.inputActionData.extraData
        local l_inputHrefDirectFunc = self.uiPanelData.inputActionData.inputHrefDirectFunc
        self:SetInputAction(l_inputFunc, l_inputItemFunc, l_extraData, l_inputHrefDirectFunc)
    end
    if self.uiPanelData.needSetPositionMiddle then
        self:SetPositionMiddle()
    end
    if self.uiPanelData.onlyShowEmojMode then
        self:OnlyShowEmoj()
    end
end
--动态表情输入
function MultitoolCtrl:SetEmoj()
    for i = self.panel.EmojiContent.transform.childCount - 1, 0, -1 do
        MResLoader:DestroyObj(self.panel.EmojiContent.transform:GetChild(i).gameObject)
    end

    local l_allData = TableUtil.GetExpressionTable().GetTable()
    for i, row in ipairs(l_allData) do
        local l_newObj = self:CloneObj(self.panel.EmojiModel.gameObject)
        l_newObj.transform:SetParent(self.panel.EmojiContent.transform)

        local l_com = l_newObj:GetComponent("MLuaUICom")
        local l_content = StringEx.Format("[z{0}]", row.ID)
        l_com.LabText = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)

        l_com:AddClick(function()
            if self.InputAction ~= nil then
                self.InputAction(l_content)
            end
        end, true)

        l_newObj.transform:SetLocalScale(2, 2, 2)
        l_newObj:SetActiveEx(true)
        l_newObj.transform:SetAsLastSibling()
    end
end
function MultitoolCtrl:SetQuickTalk()
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    local l_quickTalkInfos = l_chatDataMgr.GetQuickTalkInfo(true)
    self:UpdateQuickTalkInfo(l_quickTalkInfos)
end
function MultitoolCtrl:SetAchievement()
    self:UpdateCupInfo()
    local l_achievements = self:GetChatAchievementDatas(DataMgr:GetData("ChatData").GetHistorySearchAchievement())
    self:UpdateAchievementDetail(l_achievements)
end

function MultitoolCtrl:GetChatAchievementDatas(searchText)
    local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")
    local l_achievements = {} --l_achievementMgr.Achievements

    if self.finishAchievementTempData == nil then
        self.finishAchievementTempData = l_achievementMgr.GetAllFinishAchievements()
    end

    if searchText == nil or string.len(searchText) < 1 then
        return self.finishAchievementTempData
    end

    for i = 1, #self.finishAchievementTempData do
        --模糊查找
        local l_achiData = self.finishAchievementTempData[i]
        local l_achiDetailItem = l_achiData:GetDetailTableInfo()
        if not MLuaCommonHelper.IsNull(l_achiDetailItem) then
            local l_startIndex, l_endIndex = string.find(l_achiDetailItem.Name, searchText)
            if l_startIndex ~= l_endIndex then
                table.insert(l_achievements, l_achiData)
            end
        end
    end
    return l_achievements
end
function MultitoolCtrl:UpdateFuncShow(showDatas)
    if showDatas == nil then
        return
    end
    local l_datas = {}
    self.curSelectFuncIndex = 1
    self.curShowFuncIndex = 1
    local l_dataIndex = 1
    for i = 1, #showDatas do
        local l_data = showDatas[i]
        if self:ContainChannel(self.channelType, l_data.ChannelLimit, l_data.ID)
                and (self.openSysMgr.IsSystemOpen(l_data.ID)) then
            table.insert(l_datas, {
                id = l_data.ID,
                dataIndex = l_dataIndex,
                chooseState = l_dataIndex == self.curSelectFuncIndex,
                buttonMethod = function(funcId, dataIndex)
                    local l_showSelectImg = true
                    if self.curSelectFuncIndex ~= dataIndex then
                        local l_reserveCurrentPanel = self:OnFuncClick(funcId, true)
                        if not self:IsInited() then
                            return
                        end
                        local l_lastData = l_datas[self.curShowFuncIndex]
                        local l_lastSelectTem = self.FuncShowPool:GetItem(self.curSelectFuncIndex, true)
                        if l_lastSelectTem ~= nil then
                            l_lastSelectTem:CancelSelect()
                        end
                        self.curSelectFuncIndex = dataIndex
                        if not l_reserveCurrentPanel and self.curSelectFuncIndex ~= self.curShowFuncIndex then
                            if l_lastData ~= nil then
                                l_lastData.chooseState = false
                                self:OnFuncClick(l_lastData.id, false)
                            end
                            self.curShowFuncIndex = dataIndex
                        end
                    end
                    return l_showSelectImg
                end,
            })
            l_dataIndex = l_dataIndex + 1
        end
    end
    local l_currentSelectData = l_datas[self.curSelectFuncIndex]
    if l_currentSelectData ~= nil then
        self:OnFuncClick(l_currentSelectData.id, true)
    end
    self.FuncShowPool:UpdateData(l_datas, true)
end
function MultitoolCtrl:OnFuncClick(funcId, show)
    local l_reserveLastPanel = false
    if funcId == self.openSysMgr.eSystemId.Emoticon then
        --表情
        self.panel.EmojPanel:SetActiveEx(show)
        if show then
            self:SetEmoj()
        end
    elseif funcId == self.openSysMgr.eSystemId.QuickTalk then
        --常用语
        self.panel.QuickTalk:SetActiveEx(show)
        if show then
            self:SetQuickTalk()
        end
    elseif funcId == self.openSysMgr.eSystemId.ChatProp then
        --道具
        self.panel.ItemPanel:SetActiveEx(show)
        if show then
            self.panel.All.TogEx.isOn = true
        end
    elseif funcId == self.openSysMgr.eSystemId.RedEnvelope then
        --红包
        self.panel.RedEnvelopePanel:SetActiveEx(show)
    elseif funcId == self.openSysMgr.eSystemId.RoleGrow then
        --角色成长
        self.panel.BuildPlan:SetActiveEx(show)
        if show then
            self:UpdateBuildPlanPanel()
        end
    elseif funcId == self.openSysMgr.eSystemId.ChatAchievement then
        --成就
        self.panel.Achievement:SetActiveEx(show)
        if show then
            self:SetAchievement()
        else
            self.finishAchievementTempData = nil
        end
    elseif funcId == self.openSysMgr.eSystemId.ChatCloth then
        --典藏值
        if show then
            UIMgr:ActiveUI(CtrlNames.Clothshare, { isLocalPlan = true })
            if self.InputItemAction ~= nil then
                self.InputItemAction(nil, ChatHrefType.ClothPlan)
            end
            l_reserveLastPanel = true
        end
    elseif funcId == self.openSysMgr.eSystemId.MagicLetter then
        --魔法信笺
        if show then
            self:CloseSelfWithAction()
            UIMgr:ActiveUI(CtrlNames.MagicLetterSendout)
        else
            UIMgr:DeActiveUI(CtrlNames.MagicLetterSendout)
        end
    end
    return l_reserveLastPanel
end
function MultitoolCtrl:ContainChannel(curChannel, channelList, funcId)
    if funcId and self.specialShowFunc then
        for i = 1, #self.specialShowFunc do
            if self.specialShowFunc[i] == funcId then
                return true
            end
        end
    end
    return self.chatMgr.ContainChannel(curChannel, channelList)
end
function MultitoolCtrl:UpdateAchievementDetail(showDatas)
    if showDatas == nil then
        return
    end
    
    local l_datas = {}
    table.sort(showDatas, function(a, b)
        if nil == a or nil == b then
            return false
        end

        if nil ~= a.finishtime and nil ~= b.finishtime then
            return a.finishtime > b.finishtime
        elseif nil == a.finishtime and nil ~= b.finishtime then
            return false
        elseif nil ~= a.finishtime and nil == b.finishtime then
            return true
        else
            return false
        end
    end)

    for i = 1, #showDatas do
        local l_data = showDatas[i]
        local l_achievementDetailInfo = l_data:GetDetailTableInfo()
        local l_hideAchievementType = 2
        if l_achievementDetailInfo~=nil
                and l_achievementDetailInfo.HideType~=l_hideAchievementType then
            local l_achiData = {
                data = l_data,
                ButtonMethod = function()
                    UIMgr:ActiveUI(UI.CtrlNames.AchievementDetails, function(ctrl)
                        ctrl:ShowDetails(l_data.achievementid, MPlayerInfo.UID, l_data.finishtime, false)
                    end)
                    if self.InputItemAction ~= nil then
                        self.InputItemAction(l_data, ChatHrefType.AchievementDetails)
                    end
                end
            }
            table.insert(l_datas, l_achiData)
        end
    end
    self.AchievementPool:UpdateData(l_datas, true)
end
function MultitoolCtrl:UpdateCupInfo()
    local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")
    local l_badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(l_achievementMgr.BadgeLevel)
    if l_badgeTableInfo == nil then
        return
    end
    self.panel.CupText.LabText = l_badgeTableInfo.Name
    self.panel.CupImg:SetSprite(l_badgeTableInfo.Atlas, l_badgeTableInfo.Icon)
    local l_childNum = self.panel.StarParent.transform.childCount
    for i = 0, l_childNum - 1 do
        local l_star = self.panel.StarParent.transform:GetChild(i)
        local l_showStar = i < l_badgeTableInfo.StarType
        l_star.gameObject:SetActiveEx(l_showStar)
        if l_showStar then
            local l_darkStar = l_star.transform:Find("Dark")
            if not IsNil(l_darkStar) then
                l_darkStar.gameObject:SetActiveEx(i >= l_badgeTableInfo.LightNumber)
            end
        end
    end
    self.panel.ShowCupBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.AchievementBadge, function(ctrl)
            ctrl:ShowBadge(l_badgeTableInfo.Point, l_badgeTableInfo.Level, MPlayerInfo.UID, false)
        end)
        if self.InputItemAction ~= nil then
            self.InputItemAction(l_badgeTableInfo, ChatHrefType.AchievementBadge)
        end
    end, true)
end
function MultitoolCtrl:UpdateQuickTalkInfo(showDatas)
    if showDatas == nil then
        return
    end
    local l_datas = {}
    for i = 1, #showDatas do
        local l_data = showDatas[i]
        local l_talkInfo = {
            data = l_data,
            ButtonMethod = function()
                local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
                if l_data.hasHref then
                    if self.InputHrefDirectAction ~= nil then
                        self.InputHrefDirectAction(l_data.inputStr)
                        l_linkInputMgr.UpdateCurHrefInfo(l_data.param)
                    end
                else
                    if self.InputAction ~= nil then
                        self.InputAction(l_data.content)
                    end
                end
            end,
        }
        table.insert(l_datas, l_talkInfo)
    end
    self.QuickTalkPool:UpdateData(l_datas, true)
end

--- 获取背包中的道具
---@return ItemData[]
function MultitoolCtrl:_getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

function MultitoolCtrl:_getBagItemsByType(type)
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTypes, Param = { type } }
    local conditions = { condition }
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

--道具链接
function MultitoolCtrl:SetItemLink(isAll, propType)
    local l_datas = {}
    local l_extraData = self.ExtraData

    --已装备
    if isAll or propType == Data.BagModel.PropType.Weapon then
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Head)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Face)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Mouth)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Cloth)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.MainWeapon)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Assist)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Cloak)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Shoe)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.OrnaL)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.OrnaR)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Back)
        self:AddEquiped(l_datas, l_extraData, Data.BagModel.WeapType.Ride)
    end
    --未装备
    local l_items = nil
    local l_bagData = {}

    if isAll then
        l_items = self:_getItemsInBag()
    else
        l_items = self:_getBagItemsByType(propType)
    end

    for i = 1, #l_items do
        local l_item = l_items[i]
        l_bagData[#l_bagData + 1] = {
            PropInfo = l_item,
            ButtonMethod = function()
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(l_item, nil, Data.BagModel.WeaponStatus.NORMAL_PROP, nil, nil, l_extraData)
                if self.InputItemAction ~= nil then
                    self.InputItemAction(l_item, ChatHrefType.Prop)
                end
            end
        }
    end

    table.sort(l_bagData, function(a, b)
        local l_sortA = TableUtil.GetItemTable().GetRowByItemID(a.PropInfo.TID).SortID
        local l_sortB = TableUtil.GetItemTable().GetRowByItemID(b.PropInfo.TID).SortID
        return l_sortB < l_sortA
    end)
    for i = 1, #l_bagData do
        l_datas[#l_datas + 1] = l_bagData[i]
    end
    self.ItemPool:UpdateData(l_datas, true)
end

function MultitoolCtrl:AddEquiped(datas, extraData, pos)
    local l_item = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, pos + 1)
    if l_item ~= nil then
        datas[#datas + 1] = {
            PropInfo = l_item,
            IsShowEquipFlag = true,
            ButtonMethod = function()
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(l_item, nil, Data.BagModel.WeaponStatus.NORMAL_PROP, nil, nil, extraData)
                if self.InputItemAction ~= nil then
                    self.InputItemAction(l_item, ChatHrefType.Prop)
                end
            end
        }
    end
end

--设置界面的回调
function MultitoolCtrl:SetDeActiveAction(func)
    self.DeActiveAction = func
end

--设置当前的频道
function MultitoolCtrl:SetChannelType(channelType)
    self.channelType = channelType
end

--设置选择的输入回调
function MultitoolCtrl:SetInputAction(func, itemFunc, extraData, hrefFunc)
    self.InputAction = func
    self.InputItemAction = itemFunc
    self.ExtraData = extraData
    self.InputHrefDirectAction = hrefFunc
end

function MultitoolCtrl:SetPositionMiddle()
    local l_pos = MUIManager.UIRoot.transform.sizeDelta.x / 2
    MLuaCommonHelper.SetRectTransformPosX(self.panel.MultitoolPanel.UObj, l_pos)
end

--打开红包发送界面
function MultitoolCtrl:OpenRedEnvelopeUI(redType)
    if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        MgrMgr:GetMgr("RedEnvelopeMgr").ShowRedEnvelope_Send(redType, true)
        self:CloseSelfWithAction()
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_CONDITION_GUILD"))
    end
end


--无视频道仅显示表情
--目前红包使用表情时用到 
function MultitoolCtrl:OnlyShowEmoj()
    --Emoj.TogEx.isOn = true
    if self.specialShowFunc then
        table.insert(self.specialShowFunc, self.openSysMgr.eSystemId.Emoticon)
        self:UpdateFuncShow(self.funcInfo)
    end
    --self.panel.TogRedEnvelope:SetActiveEx(false)
end

--执行关闭函数 并关闭自己
function MultitoolCtrl:CloseSelfWithAction()
    self:executeDeActiveAction()
    UIMgr:DeActiveUI(CtrlNames.Multitool)
end
function MultitoolCtrl:executeDeActiveAction()
    if self.DeActiveAction ~= nil then
        self.DeActiveAction()
        self.DeActiveAction = nil
    end
end
--lua custom scripts end

return MultitoolCtrl