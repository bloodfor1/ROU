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
--lua fields end

--lua class define
---@class DailyMapIconTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Item_AwardPreview MoonClient.MLuaUICom
---@field Img_TypeIcon MoonClient.MLuaUICom
---@field Img_Icon3 MoonClient.MLuaUICom
---@field Img_Icon2 MoonClient.MLuaUICom
---@field Img_Icon1 MoonClient.MLuaUICom
---@field Img_Dise3 MoonClient.MLuaUICom
---@field Img_Dise2 MoonClient.MLuaUICom
---@field Img_Dise1 MoonClient.MLuaUICom
---@field Img_BG2 MoonClient.MLuaUICom
---@field Img_BG MoonClient.MLuaUICom

---@class DailyMapIconTemplate : BaseUITemplate
---@field Parameter DailyMapIconTemplateParameter

DailyMapIconTemplate = class("DailyMapIconTemplate", super)
--lua class define end

--lua functions
function DailyMapIconTemplate:Init()

    super.Init(self)

end --func end
--next--
function DailyMapIconTemplate:OnDestroy()

    if self.showRewardAnimTimer ~= nil then
        self:StopUITimer(self.showRewardAnimTimer)
        self.showRewardAnimTimer = nil
    end

end --func end
--next--
function DailyMapIconTemplate:OnDeActive()


end --func end
--next--
function DailyMapIconTemplate:OnSetData(data)

    if data == nil then
        return
    end
    local l_info = data.activityInfo.tableInfo
    if l_info == nil then
        logError("DailyActivitiesTable no exist activity@徐波:" .. tostring(data.id))
        return
    end
    local l_ui = UIMgr:GetUI(UI.CtrlNames.DailyTask)
    local l_showAward = true
    if l_ui ~= nil then
        l_showAward = l_ui.showAward
    end
    self.Parameter.Text.LabText = l_info.ActivityName
    self.canShowDetailInfo = data.activityInfo.isOpen

    self.Parameter.Img_TypeIcon:SetGray(not self.canShowDetailInfo)
    self.Parameter.Img_BG:SetGray(not self.canShowDetailInfo)
    self.Parameter.Img_BG2:SetGray(not self.canShowDetailInfo)
    self.Parameter.Img_TypeIcon:SetActiveEx(false)
    self.Parameter.Img_TypeIcon:SetSpriteAsync(l_info.TerrainAtlas, l_info.TerrainIconName, function()
        self.Parameter.Img_TypeIcon:SetActiveEx(true)
        local l_pos = self.Parameter.Item_AwardPreview.RectTransform.anchoredPosition
        l_pos.y = self.Parameter.Img_TypeIcon.RectTransform.rect.size.y * self.Parameter.Img_TypeIcon.RectTransform.localScale.x
        self.Parameter.Item_AwardPreview.RectTransform.anchoredPosition = l_pos
    end, true)
    self.Parameter.Img_TypeIcon:AddClick(function()
        local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
        local l_dailyTaskCtrl = UIMgr:GetUI(UI.CtrlNames.DailyTask)
        if l_dailyTaskCtrl ~= nil then
            if data.activityInfo.isOpen then
                if data.activityInfo.netInfo and data.id == l_dailyMgr.g_ActivityType.activity_GuildHunt then
                    UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
                    UIMgr:ActiveUI(UI.CtrlNames.GuildHuntInfo)
                else
                    l_dailyTaskCtrl:ShowDetailInfoPanel(data.id)
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(data.activityInfo.functionId))
            end
        end
    end, true)
    if self.uTrans ~= nil then
        self.uTrans.anchoredPosition = Vector2.New(l_info.Position[0], l_info.Position[1])
    end
    if l_info.RewardDisplay.Length > 2 then
        self:HandleRewardProp(l_info.RewardDisplay[0], self.Parameter.Img_Icon1, self.Parameter.Img_Dise1)
        self:HandleRewardProp(l_info.RewardDisplay[1], self.Parameter.Img_Icon2, self.Parameter.Img_Dise2)
        self:HandleRewardProp(l_info.RewardDisplay[2], self.Parameter.Img_Icon3, self.Parameter.Img_Dise3)
    else
        self.canShowDetailInfo = false
    end
    self:ShowRewardProp(l_showAward)
end --func end

--next--
--lua functions end

--lua custom scripts
function DailyMapIconTemplate:HandleRewardProp(itemId, iconCom, bgCom)
    local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if l_itemInfo == nil then
        return
    end
    iconCom:SetSpriteAsync(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon)
    iconCom:AddClick(function()
        local itemData = Data.BagModel:CreateItemWithTid(itemId)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, false, nil)
    end, true)

    local l_color = Color.New(1, 1, 1, 1)
    if l_itemInfo.ItemQuality == 1 then
        l_color = Color.New(238 / 255, 251 / 255, 224 / 255, 1) --绿#eefbe0
    elseif l_itemInfo.ItemQuality == 2 then
        l_color = Color.New(115 / 255, 213 / 255, 254 / 255, 1) --蓝#d5e7fe
    elseif l_itemInfo.ItemQuality == 3 then
        l_color = Color.New(233 / 255, 142 / 255, 249 / 255, 1) --紫#f5e8fe
    elseif l_itemInfo.ItemQuality == 4 then
        l_color = Color.New(254 / 255, 187 / 255, 115 / 255, 1) --黄#fff2e2
    end

    bgCom.Img.color = l_color
end
function DailyMapIconTemplate:ShowRewardProp(isShow)
    if not self.canShowDetailInfo then
        return
    end
    self.Parameter.Item_AwardPreview:SetActiveEx(true)
    if self.showRewardAnimTimer ~= nil then
        self:StopUITimer(self.showRewardAnimTimer)
        self.showRewardAnimTimer = nil
    end
    self.showRewardAnimTimer = self:NewUITimer(function()
        local l_currentAlpha = self.Parameter.Item_AwardPreview.CanvasGroup.alpha
        l_currentAlpha = l_currentAlpha + (isShow and 1 or -1) * 0.1
        if l_currentAlpha > 1 or l_currentAlpha < 0 then
            if l_currentAlpha > 1 then
                l_currentAlpha = 1
            else
                self.Parameter.Item_AwardPreview:SetActiveEx(false)
                l_currentAlpha = 0
            end
            self:StopUITimer(self.showRewardAnimTimer)
            self.showRewardAnimTimer = nil
        end
        self.Parameter.Item_AwardPreview.CanvasGroup.alpha = l_currentAlpha
    end, 0.1, -1)
    self.showRewardAnimTimer:Start()
end
--function DailyMapIconTemplate:SetSpriteCallBack(self)
--	local l_pos=self.Parameter.Item_AwardPreview.anchoredPosition
--	l_pos.y=self.Parameter.Img_TypeIcon.RectTransform.rect.size.y
--	self.Parameter.Item_AwardPreview.anchoredPosition=l_pos
--end
--lua custom scripts end
return DailyMapIconTemplate