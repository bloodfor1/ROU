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
---@class CardForgeUseCardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Use MoonClient.MLuaUICom
---@field NameBG MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IsCard MoonClient.MLuaUICom
---@field InfoUI MoonClient.MLuaUICom
---@field InforBG MoonClient.MLuaUICom
---@field img_recommendw MoonClient.MLuaUICom
---@field HideInforButton MoonClient.MLuaUICom
---@field CardName MoonClient.MLuaUICom
---@field CardImg MoonClient.MLuaUICom
---@field CardImageBtn MoonClient.MLuaUICom
---@field BindPanel MoonClient.MLuaUICom
---@field BigBG MoonClient.MLuaUICom
---@field Attr MoonClient.MLuaUICom

---@class CardForgeUseCardTemplate : BaseUITemplate
---@field Parameter CardForgeUseCardTemplateParameter

CardForgeUseCardTemplate = class("CardForgeUseCardTemplate", super)
--lua class define end

--lua functions
function CardForgeUseCardTemplate:Init()
	
	super.Init(self)
	self.cardTemplate=nil
	self.Parameter.Use:AddClickWithLuaSelf(self.UseCard,self)
	
end --func end
--next--
function CardForgeUseCardTemplate:BindEvents()
	
	
end --func end
--next--
function CardForgeUseCardTemplate:OnDestroy()
    self.data=nil
	
end --func end
--next--
function CardForgeUseCardTemplate:OnDeActive()
	
	
end --func end
--next--
function CardForgeUseCardTemplate:OnSetData(data)
	self:ShowCardInfo(data)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function CardForgeUseCardTemplate:ShowCardInfo(data)
	self.data = data
	self.Parameter.img_recommendw.gameObject:SetActiveEx(data.Recommended)
	if self.cardTemplate==nil then
		self.cardTemplate = self:NewTemplate("CardTemplate", {
			TemplateParent = self.Parameter.CardPrefabParent.transform,
		})
	end
	local useTimeText
	if data.ItemData then
		if data.ItemData:GetExistTime()>0 then
			useTimeText=Data.BagModel:GetRemainingTimeFormat(data.ItemData)
		end
	end
	local additionalData={}
	additionalData.ShowUseTimeText=useTimeText
	self.cardTemplate:SetData(data,additionalData)
	if data.ItemData ==nil then
		self.Parameter.Use:SetActiveEx(false)
	else
		self.Parameter.Use:SetActiveEx(true)
	end
end

--使用卡片
function CardForgeUseCardTemplate:UseCard()
	if self.data == nil then
		return
	end
	if self.data.ItemData ==nil then
		return
	end
    local l_mgr=MgrMgr:GetMgr("EquipCardForgeHandlerMgr")
    l_mgr.EventDispatcher:Dispatch(l_mgr.InsertCard, self.data.ItemData.UID)
end
--lua custom scripts end
return CardForgeUseCardTemplate