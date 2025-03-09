--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildBookPanel"
require "UI/Template/GuildRewardTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
GuildBookCtrl = class("GuildBookCtrl", super)
--lua class define end

--lua functions
function GuildBookCtrl:ctor()

    super.ctor(self, CtrlNames.GuildBook, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildBookCtrl:Init()
    ---@type GuildBookPanel
    self.panel = UI.GuildBookPanel.Bind(self)
    super.Init(self)
    ---@type ModuleMgr.GuildMgr
    self.guildMgr = MgrMgr:GetMgr("GuildMgr")
    self:initBaseInfo()
end --func end
--next--
function GuildBookCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.handInItemTemplates = {}
end --func end
--next--
function GuildBookCtrl:OnActive()
    self.guildMgr.ReqGetGuildOrganizationInfo()
    self:refreshPanel()
end --func end
--next--
function GuildBookCtrl:OnDeActive()
    self.rewardPool = nil
end --func end
--next--
function GuildBookCtrl:Update()


end --func end
--next--
function GuildBookCtrl:BindEvents()
    self:BindEvent(self.guildMgr.EventDispatcher, self.guildMgr.ON_GUILD_ORGANIZE_PROGRESS_UPDATE, self.refreshPanel, self)
    local l_propMgr = MgrMgr:GetMgr("PropMgr")
    self:BindEvent(l_propMgr.EventDispatcher, l_propMgr.ItemChangeEvent, self.refreshPropInfo, self)
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildBookCtrl:initBaseInfo()
    self:initProgressInfo()
    self.handInItemTemplates = {}
    local l_addOrganizePropIds = self.guildMgr.GetAddOrganizeContributionProps()
    if #l_addOrganizePropIds>2 then
        self:initAddContributionProp(l_addOrganizePropIds[1],
                self.panel.Btn_Medal_ShangJiao1,self.panel.Obj_Prop1.Transform)
        self:initAddContributionProp(l_addOrganizePropIds[2],
                self.panel.Btn_Medal_ShangJiao2,self.panel.Obj_Prop2.Transform)
        self:initAddContributionProp(l_addOrganizePropIds[3],
                self.panel.Btn_Medal_ShangJiao3,self.panel.Obj_Prop3.Transform)
    end
    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.GuildBook)
    end, true)
    self.panel.Btn_Contribution:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.GuildOrganizationHanorRank)
    end, true)
end
---@param txtCom MoonClient.MLuaUICom
---@param btnCom MoonClient.MLuaUICom
---@param propParent UnityEngine.Transform
function GuildBookCtrl:initAddContributionProp(propId, btnCom,propParent)
    ---@type ItemTable
    local l_item = TableUtil.GetItemTable().GetRowByItemID(propId)
    if MLuaCommonHelper.IsNull(l_item) then
        return
    end

    btnCom:AddClick(function()
        local l_propNum = Data.BagModel:GetBagItemCountByTid(propId)
        if l_propNum < 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PROP_NOT_ENOUGH_TIP"))
            return
        end
        self:showHandInGuildPropDialog(l_item)
    end, true)
    local l_propNum = Data.BagModel:GetBagItemCountByTid(propId)
    local l_itemTemplate = self:NewTemplate("ItemTemplate", {
        TemplateParent = propParent,
        Data={
            ID = propId,
            Count = l_propNum,
            IsShowCount=true,
        }
    })
    table.insert(self.handInItemTemplates,l_itemTemplate)
end
---@param propItem ItemTable
---@param propInfo ItemData
function GuildBookCtrl:showHandInGuildPropDialog(propItem)
    local l_propText = GetImageText(propItem.ItemIcon, propItem.ItemAtlas, 20, 26, false)
    local l_hasPropNum = Data.BagModel:GetBagItemCountByTid(propItem.ItemID)
    local l_content = Lang("HAND_IN_GUILD_PROP_CONTENT", tostring(l_hasPropNum), l_propText)

    local l_dialogExtraData = {
        imgClickInfos = {
            {
                imgName = propItem.ItemIcon,
                clickAction = function(spriteName, ed)
                    self:setRichTextPropImgClickEvent(propItem.ItemID, ed)
                end,
            }
        }
    }
    CommonUI.Dialog.ShowYesNoDlg(true, Lang("HAND_IN_PROP"), l_content, function()
        local l_itemDatas = MgrMgr:GetMgr("ItemContainerMgr").GetBagItemsByTids({propItem.ItemID})
        if #l_itemDatas>0 then
            self.guildMgr.ContributeGuildItem(l_itemDatas[1].UID, propItem.ItemID, l_hasPropNum,true)
        end
    end, nil, nil, nil, nil, nil, nil, nil, UnityEngine.TextAnchor.MiddleLeft, l_dialogExtraData)
end
function GuildBookCtrl:setRichTextPropImgClickEvent(propId,eventData)
    local l_extraData=
    {
        relativeScreenPosition=eventData.position,
        bottomAlign = true
    }

    local l_itemData = Data.BagModel:CreateItemWithTid(propId)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(l_itemData, nil, nil, nil, false,l_extraData)
end

function GuildBookCtrl:initProgressInfo()
    local l_manualRows = TableUtil.GetGuildManualTable().GetTable()
    self.maxOrganizeContribution, _ = self.guildMgr.GetMaxAndMinOrganizeValue()
    if self.maxOrganizeContribution == 0 then
        self.maxOrganizeContribution = 1
        logError("GetGuildManualTable中配置的最大组织力进度小于等于0 @策划" )
    end
    local l_rewardDatas = {}
    local l_manualCount = #l_manualRows
    for i = 1, l_manualCount do
        local l_organizeItem = l_manualRows[i]
        local l_organizeProgress = l_organizeItem.ManualScore / self.maxOrganizeContribution
        local l_rewardPosX = self:getPosByProgress(l_organizeProgress)
        --最后一个奖励因为在进度条尾部所以位置需要向左偏移进度条
        if i==l_manualCount then
            local l_progressWidth = self.panel.Img_Progress.RectTransform.rect.size.x
            l_rewardPosX = l_rewardPosX - l_progressWidth * 0.01
        end
        local l_rewardData = {
            rewardPosX = l_rewardPosX,
            guildManualItem = l_organizeItem,
        }
        table.insert(l_rewardDatas,l_rewardData)
    end
    self.rewardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildRewardTemplate,
        TemplateParent = self.panel.Template_Reward.gameObject.transform.parent,
        TemplatePrefab = self.panel.Template_Reward.gameObject,
    })
    self.rewardPool:ShowTemplates({Datas = l_rewardDatas})
end
---@param manualRow GuildManualTable
function GuildBookCtrl:createOrganizeReward(manualRow,index)
    if MLuaCommonHelper.IsNull(manualRow) then
        return
    end
    local l_organizeProgress = manualRow.ManualScore / self.maxOrganizeContribution
    local l_rewardPosX = self:getPosByProgress(l_organizeProgress)

    self:NewTemplate("GuildRewardTemplate", {
        TemplateParent = self.panel.Template_Reward.gameObject.transform.parent,
        TemplatePrefab = self.panel.Template_Reward.gameObject,
        Data = {
            rewardPosX = l_rewardPosX,
            guildManualItem = manualRow,
            dataIndex = index,
        }
    })
end
function GuildBookCtrl:refreshPanel()
    local l_currentGuildOrganizeProgress = self.guildMgr.GetCurrentOrganizeProgressValue()
    self.panel.Txt_CurrentProgress.LabText = l_currentGuildOrganizeProgress
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Txt_CurrentProgress.RectTransform)
    self:setProgress(l_currentGuildOrganizeProgress / self.maxOrganizeContribution)
    self:refreshPropInfo()
end
function GuildBookCtrl:refreshPropInfo()
    local l_addOrganizePropIds = self.guildMgr.GetAddOrganizeContributionProps()
    for i = 1, #self.handInItemTemplates do
        local l_itemId = l_addOrganizePropIds[i]
        local l_itemTemplate = self.handInItemTemplates[i]
        local l_propNum = Data.BagModel:GetBagItemCountByTid(l_itemId)
        l_itemTemplate:SetData({
            ID = l_itemId,
            Count = l_propNum,
            IsShowCount=true,
        })
    end
end
--region 特殊进度条相关
function GuildBookCtrl:setFirstSegmentProgress(progressValue)
    if progressValue >= self.firstOrganizeRewardProgress then
        return false
    end
    --将progressValue转化为相对第一段的进度条的值
    progressValue = progressValue / self.firstOrganizeRewardProgress
    local l_firstProgressFillAmount = 0
    local l_secondProgressFillAmount = 0
    local l_thirdProgressFillAmount = 0
    local l_fourthProgressFillAmount = 0

    local l_firstProgressMaxProgress = self.firstProgressLength / self.firstSegmentTotalLength
    if progressValue < l_firstProgressMaxProgress then
        l_firstProgressFillAmount = self.zeroProgressValue + (1 - self.zeroProgressValue) * (progressValue / l_firstProgressMaxProgress)
    else
        local l_firstCurveTotalProgress = self.perCurveProgressLength / self.firstSegmentTotalLength
        local l_firstCurveMaxProgress = l_firstProgressMaxProgress + l_firstCurveTotalProgress
        if progressValue < l_firstCurveMaxProgress then
            l_secondProgressFillAmount = (progressValue - l_firstProgressMaxProgress) / l_firstCurveTotalProgress
        else
            local l_secondCurveTotalProgress = l_firstCurveTotalProgress
            local l_secondCurveMaxProgress = l_firstCurveMaxProgress + l_secondCurveTotalProgress
            if progressValue < l_secondCurveMaxProgress then
                l_thirdProgressFillAmount = (progressValue - l_firstCurveMaxProgress) / l_secondCurveTotalProgress
            else
                local l_firstSegmentTrailTotalProgress = self.firstSegmentTrailLength / self.firstSegmentTotalLength
                local l_firstSegmentTrailMaxProgress = l_firstSegmentTrailTotalProgress + l_secondCurveMaxProgress
                if progressValue < l_firstSegmentTrailMaxProgress then
                    l_fourthProgressFillAmount = (progressValue - l_secondCurveMaxProgress) / l_firstSegmentTrailTotalProgress
                else
                    l_fourthProgressFillAmount = self.extraProgress
                end

                l_thirdProgressFillAmount = 1
            end
            l_secondProgressFillAmount = 1
        end
        l_firstProgressFillAmount = 1
    end
    self.panel.Img_Progress1.Img.fillAmount = l_firstProgressFillAmount
    self.panel.Img_Progress2.Img.fillAmount = l_secondProgressFillAmount
    self.panel.Img_Progress3.Img.fillAmount = l_thirdProgressFillAmount
    self.panel.Img_Progress4.Img.fillAmount = l_fourthProgressFillAmount
    return true
end
function GuildBookCtrl:setLastSegmentProgress(progressValue)
    if progressValue < self.firstOrganizeRewardProgress then
        return
    end
    local l_lastSegmentTotalProgress = 1 - self.firstOrganizeRewardProgress
    local l_lastSegmentProgresssValue = (progressValue - self.firstOrganizeRewardProgress) / l_lastSegmentTotalProgress

    local l_fourthProgressFillAmount = self.extraProgress + (1 - self.extraProgress) * l_lastSegmentProgresssValue
    self.panel.Img_Progress1.Img.fillAmount = 1
    self.panel.Img_Progress2.Img.fillAmount = 1
    self.panel.Img_Progress3.Img.fillAmount = 1
    self.panel.Img_Progress4.Img.fillAmount = l_fourthProgressFillAmount
end
function GuildBookCtrl:setProgress(progressValue)
    if progressValue>1 then
        progressValue = 1
    end
    self.panel.Img_Progress.RectTransform.anchorMax = Vector2.New(progressValue,1)
    self.panel.Img_Progress.RectTransform.anchoredPosition = Vector2.zero

end
function GuildBookCtrl:getPosByProgress(progressValue)
    local l_progressWidth = self.panel.Img_Progress.RectTransform.rect.size.x
    local l_posX = l_progressWidth * (progressValue - 0.5)
    return l_posX
end
function GuildBookCtrl:SelectGuildReward(index)
    if self.rewardPool==nil then
        return
    end
    self.rewardPool:SelectTemplate(index)
end
--endregion
--lua custom scripts end
return GuildBookCtrl