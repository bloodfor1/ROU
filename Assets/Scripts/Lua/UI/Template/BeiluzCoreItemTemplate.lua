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
---@class BeiluzCoreItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillName2 MoonClient.MLuaUICom
---@field SkillName1 MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field QualityTxt MoonClient.MLuaUICom
---@field QualityBG MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemRoot MoonClient.MLuaUICom

---@class BeiluzCoreItemTemplate : BaseUITemplate
---@field Parameter BeiluzCoreItemTemplateParameter

BeiluzCoreItemTemplate = class("BeiluzCoreItemTemplate", super)
local l_mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
local attrMgr = MgrMgr:GetMgr("AttrDescUtil")
--lua class define end

--lua functions

function BeiluzCoreItemTemplate:Init()
	super.Init(self)

	self.Parameter.BtnEquip:AddClickWithLuaSelf(self.OnBtnEquip,self)

	self.Parameter.ItemRoot:AddClickWithLuaSelf(self.OnItemIcon,self)

	self.Parameter.SkillName[1]:AddClick(function()
		l_mgr.ShowSkillDesc(self.data,1,self.Parameter.SkillName[1].transform.position)
	end)

	self.Parameter.SkillName[2]:AddClick(function()
		l_mgr.ShowSkillDesc(self.data,2,self.Parameter.SkillName[2].transform.position)
	end)

	self.l_itemTemplate = self:NewTemplate("ItemTemplate", {
		TemplateParent = self.Parameter.ItemRoot.gameObject.transform,
	})
end --func end
--next--
function BeiluzCoreItemTemplate:BindEvents()

	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_WHEEL_GREY_STATE_UPDATE,self.UpdateBtnState,self)

end --func end
--next--
function BeiluzCoreItemTemplate:OnDestroy()
end --func end
--next--
function BeiluzCoreItemTemplate:OnDeActive()
end --func end
--next--
function BeiluzCoreItemTemplate:OnSetData(data)
	self.data = data
	if data then

		local itemCfg = data.ItemConfig
		self.Parameter.Name.LabText = l_mgr.GetColorNameByQuality(itemCfg.ItemName,itemCfg.ItemQuality)

		local skillIDs = data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
		for i=1,l_mgr.MAX_ATTR_COUNT do
			if skillIDs[i] then
				local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[i].TableID)
				if not wheelSkillCfg then return end
				local quality = wheelSkillCfg.SkillQuality
				local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
				local attr = attrMgr.GetAttrStr(skillIDs[i], color)
				self.Parameter.SkillName[i].LabText = attr.Name
				self.Parameter.SkillName[i]:SetActiveEx(true)
			else
				self.Parameter.SkillName[i]:SetActiveEx(false)
			end
		end

		self:UpdateBtnState()

	end
end --func end
--next--
--lua functions end

--lua custom scripts

BeiluzCoreItemTemplate.TemplatePath = "UI/Prefabs/BeiluzCoreItem"

function BeiluzCoreItemTemplate:OnBtnEquip()
	if self.data then
		if self.MethodCallback then
			self.MethodCallback(self.data)
		end
	end
end

function BeiluzCoreItemTemplate:OnItemIcon()
	if self.data then
		l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_WHEEL_ON_CLICK_ICON,self.data)
	end
end

function BeiluzCoreItemTemplate:UpdateBtnState()
	if self.data then
		self.canEquip = l_mgr.IsWheelCanEquip(self.data)
		self.lifeOver = l_mgr.GetActiveState(self.data) == l_mgr.E_ACTIVE_STATE.NoLife
		local itemData={
			PropInfo = self.data,
			IsShowCount = false,
			HideButton = true,
			IsGray = not self.canEquip or self.lifeOver,
		}
		self.l_itemTemplate:SetData(itemData)
		if self.lifeOver and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BeiluzMaintain) then
			self.Parameter.BtnTxt.LabText = Common.Utils.Lang("WHEEL_MAINTAIN")
		else
			self.Parameter.BtnTxt.LabText = Common.Utils.Lang("WHEEL_EQUIP")
		end
	end
end

--lua custom scripts end
return BeiluzCoreItemTemplate