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
---@class StickerGridDetailCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StickerGridDetailCell MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field Reach MoonClient.MLuaUICom
---@field NotReached MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field AttributeDes MoonClient.MLuaUICom
---@field AchievementText MoonClient.MLuaUICom
---@field AchievementSliderText MoonClient.MLuaUICom
---@field AchievementSlider MoonClient.MLuaUICom
---@field AchievementDes MoonClient.MLuaUICom

---@class StickerGridDetailCellTemplate : BaseUITemplate
---@field Parameter StickerGridDetailCellTemplateParameter

StickerGridDetailCellTemplate = class("StickerGridDetailCellTemplate", super)
--lua class define end

--lua functions
function StickerGridDetailCellTemplate:Init()
	
	super.Init(self)
	    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
	    self.titleStickerData = DataMgr:GetData("TitleStickerData")
	
end --func end
--next--
function StickerGridDetailCellTemplate:BindEvents()
	
	
end --func end
--next--
function StickerGridDetailCellTemplate:OnDestroy()
	
	
end --func end
--next--
function StickerGridDetailCellTemplate:OnDeActive()
	
	
end --func end
--next--
function StickerGridDetailCellTemplate:OnSetData(data)
    self.stickerGridInfo = data.stickerGridInfo
    self.Parameter.Name.LabText = self.stickerGridInfo.tableInfo.StickersColumnName
    -- 属性显示
    local l_attrStrs = {}
    for i = 0, self.stickerGridInfo.tableInfo.AddAttr.Length - 1 do
        local l_attrRow = TableUtil.GetAttrDecision().GetRowById(self.stickerGridInfo.tableInfo.AddAttr[i][1])
        if l_attrRow then
            local l_value = self.stickerGridInfo.tableInfo.AddAttr[i][2]
            if l_attrRow.TipParaEnum == 1 then
                l_value = StringEx.Format("{0:F2}%", l_value / 100)
            end
            table.insert(l_attrStrs, StringEx.Format(l_attrRow.TipTemplate, "+" .. l_value))
        end
    end
    self.Parameter.AttributeDes.LabText = table.concat(l_attrStrs, ", ")
    local l_badgeRow = TableUtil.GetAchievementBadgeTable().GetRowByLevel(self.stickerGridInfo.tableInfo.AchievementLevel)
    if l_badgeRow then
        self.Parameter.AchievementText.LabText = RoColor.FormatWord(Lang("ACHIEVEMENT_LEVEL_CONDITION", l_badgeRow.Name))
        self.Parameter.AchievementDes.LabText = Lang("ACHIEVEMENT_POINT_GET", l_badgeRow.Point)
        local l_curPoint = MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint
        self.Parameter.AchievementSlider.Slider.value = l_curPoint / l_badgeRow.Point
        self.Parameter.AchievementSliderText.LabText = StringEx.Format("{0}/{1}", l_curPoint, l_badgeRow.Point)
        self.Parameter.AchievementText:GetRichText().onHrefClick:RemoveAllListeners()
        self.Parameter.AchievementText:GetRichText().onHrefClick:AddListener(function(key)
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, self.stickerGridInfo.tableInfo.AchievementLevel)
        end)
    end
    local l_isGet = self.stickerGridInfo.status == self.titleStickerData.EStickerStatus.Open
    self.Parameter.Reach:SetActiveEx(l_isGet)
    self.Parameter.NotReached:SetActiveEx(not l_isGet)
    self:SetSelected(false)
end --func end
--next--
--lua functions end

--lua custom scripts
function StickerGridDetailCellTemplate:SetSelected(isSelected)
    self.Parameter.SelectImg:SetActiveEx(isSelected)
end

function StickerGridDetailCellTemplate:GetHeight()
    return self:transform().rect.height
end
--lua custom scripts end
return StickerGridDetailCellTemplate