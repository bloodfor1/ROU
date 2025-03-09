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
---@class ArenaSettleRoleItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RoleItem MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom
---@field BtnLike MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom

---@class ArenaSettleRoleItem : BaseUITemplate
---@field Parameter ArenaSettleRoleItemParameter

ArenaSettleRoleItem = class("ArenaSettleRoleItem", super)
--lua class define end

--lua functions
function ArenaSettleRoleItem:Init()
	
	super.Init(self)
	
end --func end
--next--
function ArenaSettleRoleItem:OnDeActive()
	
	self:ClearModel()
	
end --func end
--next--
function ArenaSettleRoleItem:OnSetData(data)
	
	self.Parameter.Lv.LabText = StringEx.Format("Lv.{0}", tostring(data.lv or 0))
	self.Parameter.Name.LabText = data.name or ""
	if not IsEmptyOrNil(data.jobName) then
		self.Parameter.Job:SetSprite("Common", data.jobName)
	end
	self:ClearModel()
	local l_fxData = {}
	l_fxData.rawImage = self.Parameter.ModelImage.RawImg
	l_fxData.attr = data.attr
	l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(data.attr)
	self.model = self:CreateUIModel(l_fxData)
	self.model:AddLoadModelCallback(function(m)
		self.Parameter.ModelImage.gameObject:SetActiveEx(true)
	end)
	
	    if data.hideLike then
	        self.Parameter.BtnLike:SetActiveEx(false)
	    else
	        self.Parameter.BtnLike:SetActiveEx(true)
	    end
	self.Parameter.BtnLike:AddClick(function()
		if self.Parameter.BtnLike.Img.color == Color.New(0,0,0) then
			return
		end
		self.Parameter.BtnLike.Img.color = Color.New(0,0,0)
		MgrMgr:GetMgr("ThemeDungeonMgr").SendDungeonsEncourage(data.roleId)
	end)
	self.Parameter.BtnFriend:AddClick(function()
		if self.Parameter.BtnFriend.Img.color == Color.New(0,0,0) then
			return
		end
		self.Parameter.BtnFriend.Img.color = Color.New(0,0,0)
		MgrMgr:GetMgr("FriendMgr").RequestAddFriend(data.roleId)
	end)
	
end --func end
--next--
function ArenaSettleRoleItem:OnDestroy()
	
	
end --func end
--next--
function ArenaSettleRoleItem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ArenaSettleRoleItem:ClearModel()
    if self.model then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
end
--lua custom scripts end
return ArenaSettleRoleItem