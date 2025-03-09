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
---@class CommonItemTipsTitleStickerComponentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StickerIcon MoonClient.MLuaUICom
---@field Sticker MoonClient.MLuaUICom
---@field CommonItemTipsTitleStickerComponent MoonClient.MLuaUICom
---@field ButtonGo MoonClient.MLuaUICom

---@class CommonItemTipsTitleStickerComponent : BaseUITemplate
---@field Parameter CommonItemTipsTitleStickerComponentParameter

CommonItemTipsTitleStickerComponent = class("CommonItemTipsTitleStickerComponent", super)
--lua class define end

--lua functions
function CommonItemTipsTitleStickerComponent:Init()
	
	super.Init(self)
	
end --func end
--next--
function CommonItemTipsTitleStickerComponent:BindEvents()
	
	
end --func end
--next--
function CommonItemTipsTitleStickerComponent:OnDestroy()
	
	
end --func end
--next--
function CommonItemTipsTitleStickerComponent:OnDeActive()
	
	
end --func end
--next--
function CommonItemTipsTitleStickerComponent:OnSetData(data)
	
	    self.titleId = data.titleId
	    local l_titleRow = TableUtil.GetTitleTable().GetRowByTitleID(self.titleId)
	    if l_titleRow then
	        self.Parameter.Sticker:SetActiveEx(l_titleRow.StickersID ~= 0)
	        if l_titleRow.StickersID ~= 0 then
	            local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(l_titleRow.StickersID)
	            if l_stickerRow then
	                self.Parameter.StickerIcon:SetSpriteAsync(l_stickerRow.StickersAtlas, l_stickerRow.StickersIcon, nil, true)
	            end
	        end
	    end
	    self.Parameter.ButtonGo:AddClick(function()
	        MgrMgr:GetMgr("TitleStickerMgr").OpenTitleUI(self.titleId)
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
	    end)
	
end --func end
--next--
--lua functions end

--lua custom scripts
CommonItemTipsTitleStickerComponent.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsTitleStickerComponent"

function CommonItemTipsTitleStickerComponent:ResetSetComponent()

end
--lua custom scripts end
return CommonItemTipsTitleStickerComponent