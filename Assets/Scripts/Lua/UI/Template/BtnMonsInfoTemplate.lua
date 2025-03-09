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
---@class BtnMonsInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_MonsLv MoonClient.MLuaUICom
---@field Img_MonsLv MoonClient.MLuaUICom
---@field Img_MonsInfo MoonClient.MLuaUICom
---@field Btn_MonsInfo MoonClient.MLuaUICom

---@class BtnMonsInfoTemplate : BaseUITemplate
---@field Parameter BtnMonsInfoTemplateParameter

BtnMonsInfoTemplate = class("BtnMonsInfoTemplate", super)
--lua class define end

--lua functions
function BtnMonsInfoTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function BtnMonsInfoTemplate:OnDestroy()
	
	
end --func end
--next--
function BtnMonsInfoTemplate:OnDeActive()
	
	
end --func end
--next--
function BtnMonsInfoTemplate:OnSetData(data)
	
	self.Parameter.Img_MonsInfo:SetSprite(data.atlas, data.spName)
	local l_entityRow = TableUtil.GetEntityTable().GetRowById(data.monsterId)
	if MLuaCommonHelper.IsNull(l_entityRow) then
		self.Parameter.Txt_MonsLv.LabText = ""
		logError(StringEx.Format("no exist monster {0} in EntityTable", monsId))
	else
		self.Parameter.Txt_MonsLv.LabText = l_entityRow.UnitLevel
		--1主动0被动
		if l_entityRow.IsInitiative == 1 then
			self.Parameter.Txt_MonsLv:SetOutLineColor(Color.New(0xaa / 255, 0x3a / 255, 0x47 / 255, 1))
			self.Parameter.Img_MonsLv:SetSprite("Common", "UI_Common_Shuzijiaobiao2.png")
		else
			self.Parameter.Txt_MonsLv:SetOutLineColor(Color.New(0x41 / 255, 0x6e / 255, 0xc2 / 255, 1))
			self.Parameter.Img_MonsLv:SetSprite("Common", "UI_Common_Shuzijiaobiao.png")
		end
	end
	self.Parameter.Btn_MonsInfo:AddClick(function()
		MgrMgr:GetMgr("TipsMgr").ShowMonsterInfoTipsFromMap(data.monsterId,self.Parameter.Btn_MonsInfo.Transform.position,true,data.sceneId,self.Parameter.Btn_MonsInfo.RectTransform)
	end,true)
	
end --func end
--next--
function BtnMonsInfoTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BtnMonsInfoTemplate