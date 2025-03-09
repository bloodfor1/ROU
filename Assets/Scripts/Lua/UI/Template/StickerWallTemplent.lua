--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/StickerWallItem"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class StickerWallTemplentParameter.StickerWallItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field StickerIcon MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field Add MoonClient.MLuaUICom

---@class StickerWallTemplentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StickerWall MoonClient.MLuaUICom
---@field BgWhite MoonClient.MLuaUICom
---@field BgBlack MoonClient.MLuaUICom
---@field StickerWallItem StickerWallTemplentParameter.StickerWallItem

---@class StickerWallTemplent : BaseUITemplate
---@field Parameter StickerWallTemplentParameter

StickerWallTemplent = class("StickerWallTemplent", super)
--lua class define end

--lua functions
function StickerWallTemplent:Init()
	
	super.Init(self)
	    self.stickerPool = self:NewTemplatePool({
	        UITemplateClass = UITemplate.StickerWallItem,
	        TemplateParent = self:transform(),
	        TemplatePrefab = self.Parameter.StickerWallItem.LuaUIGroup.gameObject
	    })
	
end --func end
--next--
function StickerWallTemplent:BindEvents()
	
	
end --func end
--next--
function StickerWallTemplent:OnDestroy()
	
	
end --func end
--next--
function StickerWallTemplent:OnDeActive()
	
	
end --func end
--next--
StickerWallTemplent.TemplatePath = "UI/Prefabs/StickerWallTemplent"
function StickerWallTemplent:OnSetData(data)
    self.gridInfos = data.gridInfos
    self.bgType = data.bgType or "none"
    self.Parameter.BgBlack:SetActiveEx(self.bgType == "black")
    self.Parameter.BgWhite:SetActiveEx(self.bgType == "white")

    -- 根据父控件调整缩放比例
    local l_newScale = self:transform().parent:GetComponent("RectTransform").rect.width / self:transform().rect.width
    self:transform():SetLocalScale(l_newScale, l_newScale, 1)

    for _, v in pairs(self.gridInfos) do
        v.isShowTip = data.isShowTip
    end

    self.stickerPool:ShowTemplates({Datas = self.gridInfos })
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return StickerWallTemplent