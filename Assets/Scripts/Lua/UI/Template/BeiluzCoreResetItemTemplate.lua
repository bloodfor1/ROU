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
---@class BeiluzCoreResetItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtWeight MoonClient.MLuaUICom
---@field SkillName2 MoonClient.MLuaUICom
---@field SkillName1 MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field itemIcon MoonClient.MLuaUICom
---@field IconBg MoonClient.MLuaUICom
---@field ButtonSelect MoonClient.MLuaUICom

---@class BeiluzCoreResetItemTemplate : BaseUITemplate
---@field Parameter BeiluzCoreResetItemTemplateParameter

BeiluzCoreResetItemTemplate = class("BeiluzCoreResetItemTemplate", super)
local mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
local attrMgr = MgrMgr:GetMgr("AttrDescUtil")
--lua class define end

--lua functions
function BeiluzCoreResetItemTemplate:Init()

	super.Init(self)

	self.Parameter.ButtonSelect:AddClick(function ()
		self:onBtnItem()
	end)

	self.Parameter.ItemRoot:AddClick(function()
		self:onBtnItemIcon()
	end)

	self.l_itemTemplate = self:NewTemplate("ItemTemplate", {
		TemplateParent = self.Parameter.ItemRoot.gameObject.transform,
	})

end --func end
--next--
function BeiluzCoreResetItemTemplate:BindEvents()

	self:BindEvent(mgr.l_eventDispatcher, mgr.SIG_RESET_ATTR_CHANGE,self.OnAttrChange,self)
	
end --func end
--next--
function BeiluzCoreResetItemTemplate:OnDestroy()
	
	
end --func end
--next--
function BeiluzCoreResetItemTemplate:OnDeActive()
	
	
end --func end
--next--
function BeiluzCoreResetItemTemplate:OnSetData(data)
	self.data = data
	self:RefreshUI()
end --func end
--next--
--lua functions end

--lua custom scripts
BeiluzCoreResetItemTemplate.TemplatePath = "UI/Prefabs/BeiluzCoreResetItem"

function BeiluzCoreResetItemTemplate:RefreshUI()
	if self.data then
		local itemData={
			PropInfo = self.data,
			IsShowCount = false,
			HideButton = true,
		}
		self.l_itemTemplate:SetData(itemData)

		local itemCfg = self.data.ItemConfig
		self.Parameter.Name.LabText = itemCfg.ItemName

		local skillIDs = self.data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
		if skillIDs[1] then
			local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[1].TableID)
			if not wheelSkillCfg then return end
			local quality = wheelSkillCfg.SkillQuality
			local color = mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
			local attr = attrMgr.GetAttrStr(skillIDs[1], color)
			self.Parameter.SkillName1.LabText = attr.Name
			self.Parameter.SkillName1:SetActiveEx(true)
		else
			self.Parameter.SkillName1:SetActiveEx(false)
		end

		if skillIDs[2] then

			local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[2].TableID)
			if not wheelSkillCfg then return end
			local quality = wheelSkillCfg.SkillQuality
			local color = mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
			local attr = attrMgr.GetAttrStr(skillIDs[2], color)
			self.Parameter.SkillName2.LabText = attr.Name
			self.Parameter.SkillName2:SetActiveEx(true)
		else
			self.Parameter.SkillName2:SetActiveEx(false)
		end
	end
end

function BeiluzCoreResetItemTemplate:Deselect()
	self.Parameter.Selected.gameObject:SetActiveEx(false)
end

function BeiluzCoreResetItemTemplate:Select()
	self.Parameter.Selected.gameObject:SetActiveEx(true)
end

function BeiluzCoreResetItemTemplate:onBtnItem()
	if self.ShowIndex == self.CurrentSelectIndex then return end

	if self.data then
		if self.MethodCallback then
			self.MethodCallback(self.data,self.ShowIndex)
		end
	end
end

function BeiluzCoreResetItemTemplate:onBtnItemIcon()
	if self.data then
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(self.data)
	end
end

function BeiluzCoreResetItemTemplate:OnAttrChange(data)
	if self.data and tostring(self.data.UID) == tostring(data.UID) then
		self.data = data
		self:RefreshUI()
	end
end

--lua custom scripts end
return BeiluzCoreResetItemTemplate