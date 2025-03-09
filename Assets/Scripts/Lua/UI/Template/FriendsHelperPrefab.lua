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
---@class FriendsHelperPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field EnterBtn MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field ChatPrompt MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class FriendsHelperPrefab : BaseUITemplate
---@field Parameter FriendsHelperPrefabParameter

FriendsHelperPrefab = class("FriendsHelperPrefab", super)
--lua class define end

--lua functions
function FriendsHelperPrefab:Init()

	    super.Init(self)

end --func end
--next--
function FriendsHelperPrefab:OnDestroy()

	    self.head2d = nil

end --func end
--next--
function FriendsHelperPrefab:OnDeActive()


end --func end
--next--
function FriendsHelperPrefab:OnSetData(data)

	    if data == nil then
	        return
	    end
	    self.Data = data
	    self.Mgr = MgrMgr:GetMgr("FriendMgr")
	    self.RedMgr = MgrMgr:GetMgr("RedSignMgr")
	    self.Parameter.Desc.LabText = Lang("KAPULA_SIGNATURE")
	    local l_row = TableUtil.GetNpcTable().GetRowById(self.Data.npcID)
	    if l_row then
	        self.Parameter.Name.LabText = l_row.Name
	        --头像
	        if not self.head2d then
	            self.head2d = self:NewTemplate("HeadWrapTemplate", {
	                TemplateParent = self.Parameter.Head.transform,
	                TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	            })
	        end
	        ---@type HeadTemplateParam
	        local param = {
	            NpcHeadID = self.Data.npcID
	        }
	        self.head2d:SetData(param)
	    else
	        self.Parameter.Name.LabText = "???"
	    end
		local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
		self.Parameter.EnterBtn:SetActiveEx(l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.CapraFaq) and l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Consultation))
	    self.Parameter.EnterBtn:AddClick(function()
	        MgrMgr:GetMgr("FriendMgr").OpenAssistantUrl()
	        self:showSelect()
	    end)
	    self.Parameter.Btn:AddClick(function()
	        self:MethodCallback(self)
	    end)
	    self:showSelect()

end --func end
--next--
function FriendsHelperPrefab:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function FriendsHelperPrefab:showSelect()
    local l_light = self.Mgr.CurrentSelectFriendIndex == self.ShowIndex
    self.Parameter.Light:SetActiveEx(l_light)
    self.Parameter.ChatPrompt:SetActiveEx(not l_light and self.RedMgr.IsRedSignShow(eRedSignKey.FriendHelper))
end
--lua custom scripts end
return FriendsHelperPrefab