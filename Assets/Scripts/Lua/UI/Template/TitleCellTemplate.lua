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
---@class TitleCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtBg MoonClient.MLuaUICom
---@field TitleName MoonClient.MLuaUICom
---@field TitleCell MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field New MoonClient.MLuaUICom
---@field Collectionicon MoonClient.MLuaUICom
---@field Activated MoonClient.MLuaUICom

---@class TitleCellTemplate : BaseUITemplate
---@field Parameter TitleCellTemplateParameter

TitleCellTemplate = class("TitleCellTemplate", super)
--lua class define end

--lua functions
function TitleCellTemplate:Init()

    super.Init(self)
    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
    self.titleStickerData = DataMgr:GetData("TitleStickerData")
    self.Parameter.TitleCell:AddClick(function()
        if self.titleHandler then
            self.titleHandler:HandleTitleCellClicked(self)
        end

        if self.titleInfo.isNew then
            self.titleStickerData.SetTitleInfo(self.titleInfo.titleId, { isNew = false })
            self.Parameter.New:SetActiveEx(false)
        end
    end)

end --func end
--next--
function TitleCellTemplate:BindEvents()
    self:BindEvent(self.titleStickerMgr.EventDispatcher, self.titleStickerMgr.EEventType.TitleRefresh, function()
        self:RefreshDetail()
    end)
end --func end
--next--
function TitleCellTemplate:OnDestroy()


end --func end
--next--
function TitleCellTemplate:OnDeActive()


end --func end
--next--
function TitleCellTemplate:OnSetData(data)

    self.titleInfo = data.titleInfo
    self.titleHandler = data.titleHandler
    self:SetSelected(false)

    self:RefreshDetail()
end --func end
--next--
--lua functions end

--lua custom scripts
function TitleCellTemplate:SetSelected(isSelected)
    self.Parameter.SelectImg:SetActiveEx(isSelected)
end

function TitleCellTemplate:GetTitleInfo()
    return self.titleInfo
end

function TitleCellTemplate:RefreshDetail()
    local C_STR_DEFAULT_TITLE_COLOR = "937674"
    self.Parameter.TitleName.LabText = self.titleInfo.titleTableInfo.TitleName
    if self.titleInfo.isOwned then
        self.Parameter.TitleName.LabColor = self.titleStickerMgr.GetQualityColor(self.titleInfo.itemTableInfo.ItemQuality)
    else
        self.Parameter.TitleName.LabColor = RoColor.Hex2Color(C_STR_DEFAULT_TITLE_COLOR)
    end
    self.Parameter.Collectionicon:SetActiveEx(self.titleInfo.titleTableInfo.StickersID ~= 0)
    self.Parameter.Activated:SetActiveEx(self.titleInfo.isOwned)
    self.Parameter.New:SetActiveEx(self.titleInfo.isNew and self.titleInfo.isOwned)
end

--lua custom scripts end
return TitleCellTemplate