--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class IllustrationCardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectPanel MoonClient.MLuaUICom
---@field CardPrefab MoonClient.MLuaUICom
---@field CardItem MoonClient.MLuaUICom
---@field CardButton MoonClient.MLuaUICom

---@class IllustrationCardTemplate : BaseUITemplate
---@field Parameter IllustrationCardTemplateParameter

IllustrationCardTemplate = class("IllustrationCardTemplate", super)
--lua class define end

--lua functions
function IllustrationCardTemplate:Init()
	
	    super.Init(self)
	self.mgr = MgrMgr:GetMgr("IllustrationMgr")
	
end --func end
--next--
function IllustrationCardTemplate:OnDestroy()

    self.cardItemTemplate = nil
	
end --func end
--next--
function IllustrationCardTemplate:OnSetData(data)
	
	self:ShowCardInfo(data)
	
end --func end
--next--
function IllustrationCardTemplate:BindEvents()
	
	
end --func end
--next--
function IllustrationCardTemplate:OnDeActive()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationCardTemplate:ShowCardInfo(cardData)
    local data = {
        ID = cardData.ID,
        IsShowCount = false,
        IsShowTips = false,
    }
    if not self.cardItemTemplate then
        self.cardItemTemplate = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.Parameter.CardItem.transform,
            Data = data,
        })
    else
        self.cardItemTemplate:SetData(data)
    end

	--点击事件
	self.Parameter.CardButton:AddClick(function()
        self.mgr.EventDispatcher:Dispatch(self.mgr.ILLUSTRATION_SELECT_CARD, cardData)
        self.mgr.SetSelectCardIndex(self.ShowIndex)
        self:SetSelectState(true)
	end)
    --选中状态
    local isSelect = self.ShowIndex == self.mgr.GetSelectCardIndex()
    self:SetSelectState(isSelect)
end

function IllustrationCardTemplate:SetSelectState(isSelect)
    self.Parameter.SelectPanel.gameObject:SetActiveEx(isSelect)
end
--lua custom scripts end
return IllustrationCardTemplate