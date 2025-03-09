--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BeginnerBookPanel"
require "UI/Template/PostCardDisplayTemplate"
require "UI/Template/BeginnerRewardTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
-- 显示动效过期时间
local l_timeOutCondition = 5
-- Mgr
local l_mgr = MgrMgr:GetMgr("PostCardMgr")
--lua fields end

--lua class define
BeginnerBookCtrl = class("BeginnerBookCtrl", super)
--lua class define end

local l_commonTexPath = "Postcard/"
--lua functions
function BeginnerBookCtrl:ctor()

    super.ctor(self, CtrlNames.BeginnerBook, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function BeginnerBookCtrl:Init()

    self.panel = UI.BeginnerBookPanel.Bind(self)
	super.Init(self)

    self:CustomInit()

    self.tweenId = 0
    self.autoShowDetail = 0
    self.clearFxTimer = nil
    self.lineObjs = {}

    self.lineObjs[1] = self.panel.ImageLine.gameObject

    self.rightBtnFx = nil

    l_mgr.RequestPostCardInfo()
end --func end
--next--
function BeginnerBookCtrl:Uninit()

    self.templatePool = nil
    self.itemTemplatePool = nil
    self.pageId = nil
    self.cardIndex= nil
    self.cardAwardId = nil
    self.cardTaskId = nil
    self.cardsDatas = nil
    self.autoShowDetail = nil

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end

    if self.scrollTimer then
        self:StopUITimer(self.scrollTimer)
        self.scrollTimer = nil
    end

    if self.clearFxTimer then
        self:StopUITimer(self.clearFxTimer)
        self.clearFxTimer = nil
    end

    if self.lineObjs then
        for i, v in ipairs(self.lineObjs) do
            MResLoader:DestroyObj(v)
        end
        self.lineObjs = nil
    end

    if self.rightBtnFx ~= nil then
        self:DestroyUIEffect(self.rightBtnFx)
        self.rightBtnFx = nil
    end

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function BeginnerBookCtrl:OnActive()

    self:InitPage()
end --func end
--next--
function BeginnerBookCtrl:OnDeActive()

    self.panel.Image:ResetRawTex()
end --func end
--next--
function BeginnerBookCtrl:Update()
    
end --func end





--next--
function BeginnerBookCtrl:BindEvents()
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.POST_CARD_INFO_UPDATE, function()
        self:UpdateTemplateState()
    end)
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,l_mgr.POST_CARD_AWARD_PREVIEW, function(_, ...)
        self:HandleAwardReview(...)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function BeginnerBookCtrl:CloseUI()
    UIMgr:DeActiveUI(self.name)
end

-- 初始化页面
function BeginnerBookCtrl:InitPage()

    self.cardsDatas = {}
    local l_globalIndex = 0
    for i, row in ipairs(TableUtil.GetPostcardDisplayTable().GetTable()) do
        -- 检查目标、界面类型、奖励数量是否一致
        if row.Target.Length <= 0 or
            row.Target.Length ~= row.DetailType.Length or
            row.Target.Length ~= row.Awardid.Length then
            logError("BeginnerBookCtrl:InitPage失败，配置问题，数量不一致@李韬", self.curPage)
        else
            -- 以目标为基准
            for i = 0, row.Target.Length - 1 do
                l_globalIndex = l_globalIndex + 1
                local l_data = {
                    id = row.ID,
                    index = i,
                    globalIndex = l_globalIndex,
                }
                table.insert(self.cardsDatas, l_data)
            end
        end
    end

    local function _onClick(index)
        self:OnDetailClicked(index)
    end

    self.templatePool:ShowTemplates({Datas = self.cardsDatas, Method = _onClick})
end

-- 消息刷新状态
function BeginnerBookCtrl:UpdateTemplateState()
    
    local l_startIndex = self.templatePool:GetCellStartIndex()
    local l_endIndex = self.templatePool:GetCellEndIndex()
    for i = l_startIndex, l_endIndex do
        local l_item = self.templatePool:GetItem(i)
        if l_item then
            l_item:CustomSetData(self.cardsDatas[i])
        end
    end

    if self.autoShowDetail ~= 0 then
        self:OnDetailClicked(self.cardIndex)
    end
end

-- 初始化界面
function BeginnerBookCtrl:CustomInit()

    self.panel.BtnClose:AddClick(function()
        self:CloseUI()
    end)

    self.panel.left:AddClick(function()
        self:OnDetailClicked(self.cardIndex - 1, true)
    end)

    self.panel.right:AddClick(function()
        self:OnDetailClicked(self.cardIndex + 1, true)
    end)

    self.panel.BlackMask:AddClick(function()
        self.panel.Postcard.gameObject:SetActiveEx(false)
    end)

    self.panel.ButtonForward:AddClick(function()
        if self.cardTaskId then
            local l_cardTaskId = self.cardTaskId
            self:CloseUI()
            MgrMgr:GetMgr("TaskMgr").OnQuickTaskClickWithTaskId(l_cardTaskId)
        end
    end)

    self.templatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.PostCardDisplayTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.PostCardDisplay.LuaUIGroup.gameObject,
        ScrollRect = self.panel.scrollview.LoopScroll,
    })

    self.panel.scrollbar.CanvasGroup.alpha = 0
    self.panel.scrollview.LoopScroll.OnBeginDragCallback = function()
        self:PlayScrollBarTween(1)
    end

    self.panel.scrollview.LoopScroll.OnEndDragCallback = function()
        self:PlayScrollBarTween(0)
    end

    self.panel.Postcard.gameObject:SetActiveEx(false)
    
    local l_topVisible = false
    local l_bottomVisible = false

    local function _updateComVisible(com, visible)
        if visible then
            com.gameObject:SetActiveEx(true)
        else
            com.gameObject:SetActiveEx(false)
        end
    end
    local function _updateVisible(top, visible)
        if top then
            if l_topVisible ~= visible then
                _updateComVisible(self.panel.ImageUp, visible)
                l_topVisible = visible
            end
        else
            if l_bottomVisible ~= visible then
                _updateComVisible(self.panel.ImageDown, visible)
                l_bottomVisible = visible
            end
        end
    end
    local l_upTriggerHeight = 20
    local l_downTriggerHeight
    self.panel.ContextScroll.LoopScroll.OnBeginDragCallback = function()
        l_topVisible = self.panel.ImageUp.gameObject.activeSelf
        l_bottomVisible = self.panel.ImageDown.gameObject.activeSelf
        l_downTriggerHeight = self.panel.BGText.RectTransform.sizeDelta.y - 187
    end

    self.panel.ContextScroll.LoopScroll.OnDragCallback = function()
        local l_bgPos = self.panel.BGText.RectTransform.anchoredPosition
        _updateVisible(true, l_bgPos.y > l_upTriggerHeight)
        _updateVisible(false, l_bgPos.y < l_downTriggerHeight)
    end

    self.panel.ContextScroll.LoopScroll.OnEndDragCallback = function()
        local l_bgPos = self.panel.BGText.RectTransform.anchoredPosition
        _updateVisible(true, l_bgPos.y > l_upTriggerHeight)
        _updateVisible(false, l_bgPos.y < l_downTriggerHeight)
    end
end

-- template点击回调
function BeginnerBookCtrl:OnDetailClicked(index, notReward)

    local l_totalCount = #self.cardsDatas
    if index > l_totalCount then
        index = 1
    elseif index < 1 then
        index = l_totalCount
    end

    local l_data = self.cardsDatas[index]
    if not l_data then
        logError("BeginnerBookCtrl:OnDetailClicked 找不到对应数据", index)
        return
    end
    -- check reward
    local l_row = TableUtil.GetPostcardDisplayTable().GetRow(l_data.id)
    if not l_row then
        logError("BeginnerBookCtrl:OnDetailClicked fail,传入id有误", l_data.id)
        return
    end
    
    if self.autoShowDetail > 1 then
        return
    end

    self.cardIndex = index

    local l_taskId = l_row.Target[l_data.index]
    local l_taskState = l_mgr.GetTaskState(l_taskId)
    local l_awardState = l_mgr.GetAwardState(l_taskId)
    local l_awardId = l_row.Awardid[l_data.index]
    local l_showForward = l_row.ShowMoveButton[l_data.index] == 1
    
    self.cardAwardId = l_awardId
    self.cardTaskId = l_taskId
    -- 领奖
    if l_taskState and (not l_awardState) then
        if not notReward then
            l_mgr.RequestRewardPostCard(l_taskId)
            if self.autoShowDetail == 0 then
                self.autoShowDetail = 1
            else
                self.autoShowDetail = self.autoShowDetail + 1
            end
            return
        end
    end

    local l_flag = (self.autoShowDetail > 0)

    self.autoShowDetail = 0

    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_awardId, l_mgr.POST_CARD_AWARD_PREVIEW)

    local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(l_taskId)

    self.panel.TaskName.LabText = (l_taskInfo.targetDesc[1] or "")
    self.panel.TaskDesc.LabText = l_taskInfo.taskDesc
    self.panel.ImageUp.gameObject:SetActiveEx(false)
    local l_preferredHeight = self.panel.TaskDesc:GetText().preferredHeight
    if l_preferredHeight >= 160 then
        self.panel.TaskDesc.LabRayCastTarget = true
        self.panel.ImageDown.gameObject:SetActiveEx(true)
    else
        self.panel.TaskDesc.LabRayCastTarget = false
        self.panel.ImageDown.gameObject:SetActiveEx(false)
    end

    MLuaCommonHelper.SetLocalPosY(self.panel.BGText.gameObject, 0)

    local l_baseLineCount = 4
    local l_preferreLineCount = math.floor((l_preferredHeight + 10) / 40)
    local l_needCount = (l_preferreLineCount > l_baseLineCount) and l_preferreLineCount or l_baseLineCount
    local l_max = math.max(l_needCount, #self.lineObjs)
    for i = 1, l_max do
        local l_visible = i <= l_needCount
        if l_visible then
            if not self.lineObjs[i] then
                local l_newObj = MResLoader:CloneObj(self.lineObjs[1], true)
                MLuaCommonHelper.SetParent(l_newObj, self.panel.BGText.gameObject)
                MLuaCommonHelper.SetLocalScaleOne(l_newObj)
                MLuaCommonHelper.SetLocalRotEulerZero(l_newObj)
                MLuaCommonHelper.SetLocalPosZero(l_newObj)
                self.lineObjs[i] = l_newObj
            end
            MLuaCommonHelper.SetActiveEx(self.lineObjs[i], true)
        else
            if self.lineObjs[i] then
                MLuaCommonHelper.SetActiveEx(self.lineObjs[i], false)
            end
        end
    end

    MLuaCommonHelper.SetRectTransformHeight(self.panel.BGText.gameObject, l_preferredHeight + 15)

    self.panel.Clear.gameObject:SetActiveEx(l_awardState)
    if self.clearFxTimer then
        self:StopUITimer(self.clearFxTimer)
        self.clearFxTimer = nil
    end

    self.panel.RightButtonFx.gameObject:SetActiveEx(false)
    if l_flag then
        self.clearFxTimer = self:NewUITimer(function()
            MLuaClientHelper.PlayFxHelper(self.panel.Clear.UObj)
        end, 0.05)
        self.clearFxTimer:Start()
        -- 如果不是最后一个  显示按钮特效
        if self.cardIndex ~= #self.cardsDatas then

            if self.RightButtonFx == nil then
                local l_fxData = {}
                l_fxData.rawImage = self.panel.RightButtonFx.RawImg
                l_fxData.rotation = Quaternion.Euler(0, 0, 0)
                l_fxData.position = Vector3.New(-0.45, -1.77, 0)
                l_fxData.scaleFac = Vector3.New(0.5, 1.06, 0)
                l_fxData.speed = 1
                l_fxData.destroyHandler = function ()
                    self.RightButtonFx = nil
                end
                l_fxData.loadedCallback = function ()
                    self.panel.RightButtonFx.gameObject:SetActiveEx(true)    
                end
                self.RightButtonFx = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_QiRiDengLu_01", l_fxData)
                
            end
            self.panel.RightButtonFx.gameObject:SetActiveEx(false)
        end
    end

    if not l_taskState then
        self.panel.ButtonForward.gameObject:SetActiveEx(MgrMgr:GetMgr("TaskMgr").CheckTaskTaked(l_taskId) and l_showForward)
        -- self.panel.Image:SetRawImgMaterial("Materials/UIRawImgGray")
        self.panel.Image:SetRawTexAsync(MGlobalConfig:GetString("PostcardDefaultRes"))
    else
        self.panel.ButtonForward.gameObject:SetActiveEx(false)
        -- self.panel.Image:SetRawImgMaterial("")
        self.panel.Image:SetRawTexAsync(StringEx.Format("{0}{1}", l_commonTexPath, l_row[StringEx.Format("Res{0}", (l_data.index + 1))]))
    end

    self.panel.TextPage.LabText = StringEx.Format("No.{0:000}", self.cardIndex)

    self.panel.Postcard.gameObject:SetActiveEx(true)
end

function BeginnerBookCtrl:HandleAwardReview(awardInfo)
    -- reward
    if awardInfo then
        local l_datas = {}
        for i, v in ipairs(awardInfo.award_list) do
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
            if l_itemRow then
                -- l_result = l_result .. StringEx.Format("{0}X{1}\n", l_itemRow.ItemName, v.count)
                table.insert(l_datas, {
                    id = v.item_id,
                    count = v.count
                })
            else
                logError("PostCardDetailCtrl:SetPostCardDetail fail, 奖励预览道具id客户端找不到")
            end
        end

        if not self.itemTemplatePool then
            self.itemTemplatePool = self:NewTemplatePool({
                UITemplateClass = UITemplate.BeginnerRewardTemplate,
                TemplateParent = self.panel.RewardContent.transform,
                TemplatePrefab = self.panel.BeginnerReward.LuaUIGroup.gameObject,
            })
        end

        self.itemTemplatePool:ShowTemplates({Datas = l_datas})
        self.panel.Reward.gameObject:SetActiveEx(true)
    else
        self.panel.Reward.gameObject:SetActiveEx(false)
    end
end

function BeginnerBookCtrl:PlayScrollBarTween(targetAlpha)

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end

    if self.scrollTimer then
        self:StopUITimer(self.scrollTimer)
        self.scrollTimer = nil
    end

    local l_curAlpha = self.panel.scrollbar.CanvasGroup.alpha
    local l_func = function()
        self.tweenId = MUITweenHelper.TweenAlpha(self.panel.scrollbar.gameObject, l_curAlpha, targetAlpha, 0.5, function ()
            self.tweenId = 0
        end)
    end

    if targetAlpha == 0 then
        self.scrollTimer = self:NewUITimer(function()
            l_func()
        end, 0.5)
        self.scrollTimer:Start()
    else
        l_func()
    end
end

--lua custom scripts end
