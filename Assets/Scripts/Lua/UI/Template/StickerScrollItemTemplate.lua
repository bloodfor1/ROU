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
---@class StickerScrollItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtBg MoonClient.MLuaUICom
---@field Txt MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class StickerScrollItemTemplate : BaseUITemplate
---@field Parameter StickerScrollItemTemplateParameter

StickerScrollItemTemplate = class("StickerScrollItemTemplate", super)
--lua class define end

--lua functions
function StickerScrollItemTemplate:Init()
	
	    super.Init(self)
	    self.titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")
	    self.titleStickerData = DataMgr:GetData("TitleStickerData")
	    self.Parameter.Icon:AddClick(function()
	        if self.stickerCtrl then
	            self.stickerCtrl:HandleStickerClicked(self)
	        end
	    end)
        -- 双击穿上
        self.Parameter.Icon.Listener.onDoubleClick = (function()
            if self.stickerInfo and self.stickerInfo.gridIndex == 0 then
                if not self.stickerInfo or not self.stickerInfo.isOwned then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STICKER_DROP_GRID_NOT_HAVE_STICKER"))
                elseif self.stickerInfo.gridIndex == 0 then
                    local l_index = self.titleStickerMgr.FindValidGridIndex(self.stickerInfo.tableInfo.Length)
                    if l_index == 0 then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STICKER_DROP_GRID_LENGTH_NOT_ENOUGH"))
                    else
                        self.titleStickerMgr.RequestChangeSticker(self.stickerInfo.stickerId, l_index)
                    end
                end
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
	            self.stickerCtrl:HandleStickerEndDrag(self.stickerInfo, self.Parameter.Icon.DragItem:GetMoveObject(), false)
	        end
	    end
	    self.IsStickerScrollItemTemplate = true
	
end --func end
--next--
function StickerScrollItemTemplate:OnDestroy()
	
	
end --func end
--next--
function StickerScrollItemTemplate:OnDeActive()
	
	
end --func end
--next--
function StickerScrollItemTemplate:OnSetData(data)
	
	    self.stickerInfo = data.stickerInfo
	    self.stickerCtrl = data.stickerCtrl
	    if not self.stickerInfo then return end
	    self.Parameter.Icon:SetSpriteAsync(self.stickerInfo.tableInfo.StickersAtlas, self.stickerInfo.tableInfo.StickersIcon, nil, true)
	    self.Parameter.TxtBg:SetActiveEx(self.stickerInfo.gridIndex ~= 0)
	    self.Parameter.Icon:SetGray(not self.stickerInfo.isOwned)
	    self:SetSelected(false)
	
end --func end
--next--
function StickerScrollItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function StickerScrollItemTemplate:SetSelected(isSelected)
    self.Parameter.SelectImg:SetActiveEx(isSelected)
end


function StickerScrollItemTemplate:GetStickerInfo()
    return self.stickerInfo
end
--lua custom scripts end
return StickerScrollItemTemplate