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
---@class StickItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ValidMask MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field InvalidMask MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field AwardRawImg MoonClient.MLuaUICom
---@field AddImg MoonClient.MLuaUICom

---@class StickItemTemplate : BaseUITemplate
---@field Parameter StickItemTemplateParameter

StickItemTemplate = class("StickItemTemplate", super)
--lua class define end

--lua functions
function StickItemTemplate:Init()
	
    super.Init(self)
    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
    self.titleStickerData = DataMgr:GetData("TitleStickerData")
    -- 物品大小
    self.itemWidth = self.Parameter.LuaUIGroup.RectTransform.rect.width
    self.selectWidth = self.Parameter.SelectImg.RectTransform.rect.width
    self.Parameter.Item:AddClick(function()
        if self.stickerCtrl then
            self.stickerCtrl:HandleStickerClicked(self)
        end
        -- 解锁
        if self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.CanGet then
            self.titleStickerMgr.RequestUnlockGrid(self.stickerGridInfo.index)
        end
    end)
    self.Parameter.Lock:AddClick(function()
        if self.stickerCtrl then
            self.stickerCtrl:HandleStickerClicked(self)
        end
    end)
    self.Parameter.AddImg:AddClick(function()
        if self.stickerCtrl then
            self.stickerCtrl:HandleStickerClicked(self)
        end
    end)
    self.Parameter.Icon:AddClick(function()
        if self.stickerCtrl then
            self.stickerCtrl:HandleStickerClicked(self)
        end
    end)
    -- 双击卸下
    self.Parameter.Icon.Listener.onDoubleClick = (function()
        if self.stickerInfo then
            self.titleStickerMgr.RequestChangeSticker(0, self.stickerGridInfo.index)
        end
    end)
    self.Parameter.Icon.DragItem.onBeginDrag = function(go, ed)
        if self.stickerCtrl then
            self.stickerCtrl:HandleStickerBeginDrag(self.stickerInfo, self.Parameter.Icon.DragItem:GetMoveObject())
        end
    end
    self.Parameter.Icon.DragItem.onDraging = function(go, ed)
        if self.stickerCtrl then
            self.stickerCtrl:HandleStickerDragging(self.stickerInfo, self.Parameter.Icon.DragItem:GetMoveObject())
        end
    end
    self.Parameter.Icon.DragItem.onEndDrag = function(go, ed)
        if self.stickerCtrl then
            self.stickerCtrl:HandleStickerEndDrag(self.stickerInfo, self.Parameter.Icon.DragItem:GetMoveObject(), true)
        end
    end
	
end --func end
--next--
function StickItemTemplate:OnDestroy()
	
	    if self.rewardFx then
	        self:DestroyUIEffect(self.rewardFx)
	        self.rewardFx = nil
	    end
	
end --func end
--next--
function StickItemTemplate:OnDeActive()
	
	
end --func end
--next--
function StickItemTemplate:OnSetData(data)
    self.stickerGridInfo = data.stickerGridInfo
    self.stickerCtrl = data.stickerCtrl
    self.isCovered = data.isCovered
    self.stickerInfo = self.titleStickerData.GetStickerInfoById(self.stickerGridInfo.stickerId)
    self.Parameter.Lock:SetActiveEx(self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.Close)
    self.Parameter.AwardRawImg:SetActiveEx(self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.CanGet)
    if self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.CanGet then
        if not self.rewardFx then
            self.rewardFx = self:CreateUIEffect(MGlobalConfig:GetInt("NoticeRewardEffect"), {
                rawImage = self.Parameter.AwardRawImg.RawImg,
            })
        end
    else
        if self.rewardFx then
            self:DestroyUIEffect(self.rewardFx)
            self.rewardFx = nil
        end
    end
    self.Parameter.Icon:SetActiveEx(self.stickerInfo ~= nil)
    self.Parameter.AddImg:SetActiveEx(not self.stickerInfo and self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.Open)
    if self.stickerInfo then
        self.Parameter.Icon:SetSpriteAsync(self.stickerInfo.tableInfo.StickersAtlas, self.stickerInfo.tableInfo.StickersIcon, nil, true)
    end
    self.Parameter.ValidMask:SetActiveEx(false)
    self.Parameter.InvalidMask:SetActiveEx(false)
    -- 设置宽度
    self:SetWidth(self:GetLength())
    self:SetSelected(false)
    self:SetVisible(not self.isCovered)
	
end --func end
--next--
function StickItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function StickItemTemplate:SetSelected(isSelected)
    self.Parameter.SelectImg:SetActiveEx(isSelected)
end

function StickItemTemplate:GetStickerGridInfo()
    return self.stickerGridInfo
end

function StickItemTemplate:GetStickerInfo()
    return self.stickerInfo
end

-- 获取长度
function StickItemTemplate:GetLength()
    if self.stickerInfo then
        return self.stickerInfo.tableInfo.Length
    end
    return 1
end

-- 设置宽度
function StickItemTemplate:SetWidth(length)
    MLuaCommonHelper.SetRectTransformWidth(self.Parameter.LuaUIGroup.gameObject, self.itemWidth * length)
    --MLuaCommonHelper.SetRectTransformWidth(self.Parameter.SelectImg.gameObject, self.selectWidth * length)
end

-- 是否可放置
function StickItemTemplate:CanDrop()
    return self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.Open
end

-- 栏位状态，0普通状态，1待放置状态，2可放置状态，3不可放置状态
function StickItemTemplate:SetState(state)
    self:SetVisible(state ~= 0 or not self.isCovered)
    self.Parameter.ValidMask:SetActiveEx(state == 2)
    self.Parameter.InvalidMask:SetActiveEx(state == 3)
    self:SetWidth(state == 0 and self:GetLength() or 1)

    self.Parameter.AddImg:SetActiveEx((state ~= 0 or not self.stickerInfo) and self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.Open)
end

function StickItemTemplate:SetVisible(isVisible)
    self.Parameter.LuaUIGroup.gameObject:SetActiveEx(isVisible)
end
--lua custom scripts end
return StickItemTemplate