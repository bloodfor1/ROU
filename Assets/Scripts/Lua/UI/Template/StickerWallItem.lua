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
---@class StickerWallItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StickerIcon MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field Add MoonClient.MLuaUICom

---@class StickerWallItem : BaseUITemplate
---@field Parameter StickerWallItemParameter

StickerWallItem = class("StickerWallItem", super)
--lua class define end

--lua functions
function StickerWallItem:Init()
	
	super.Init(self)
    self.itemWidth = self.Parameter.LuaUIGroup.RectTransform.rect.width
	
end --func end
--next--
function StickerWallItem:BindEvents()
	
	
end --func end
--next--
function StickerWallItem:OnDestroy()
	
	
end --func end
--next--
function StickerWallItem:OnDeActive()
	
	
end --func end
--next--
function StickerWallItem:OnSetData(data)
	self.gridInfo = data
    if self.gridInfo.isCovered then
        self.Parameter.LuaUIGroup.gameObject:SetActiveEx(false)
        return
    end
    if self.gridInfo.stickerId ~= 0 then
        self.Parameter.Lock:SetActiveEx(false)
        self.Parameter.Add:SetActiveEx(false)
        self.Parameter.StickerIcon:SetActiveEx(true)
        local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(self.gridInfo.stickerId)
        if l_stickerRow then
            self.Parameter.StickerIcon:SetSpriteAsync(l_stickerRow.StickersAtlas, l_stickerRow.StickersIcon, nil, true)
            MLuaCommonHelper.SetRectTransformWidth(self.Parameter.LuaUIGroup.gameObject, self.itemWidth * l_stickerRow.Length)
        end
        if data.isShowTip then
            self.Parameter.StickerIcon:AddClick(function()
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(DataMgr:GetData("TitleStickerData").GetStickerTitleId(self.gridInfo.stickerId))
            end)
        end
    else
        self.Parameter.StickerIcon:SetActiveEx(false)
        --self.Parameter.Lock:SetActiveEx(self.gridInfo.status ~= 2)
        --self.Parameter.Add:SetActiveEx(self.gridInfo.status == 2)
        self.Parameter.Lock:SetActiveEx(false)
        self.Parameter.Add:SetActiveEx(false)
    end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return StickerWallItem