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
---@class TeamApplyPerTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PlayerTpl MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field Map MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field Img_Job MoonClient.MLuaUICom
---@field Btn_Men MoonClient.MLuaUICom
---@field AgreeBtn MoonClient.MLuaUICom

---@class TeamApplyPerTem : BaseUITemplate
---@field Parameter TeamApplyPerTemParameter

TeamApplyPerTem = class("TeamApplyPerTem", super)
--lua class define end

--lua functions
function TeamApplyPerTem:Init()

    super.Init(self)
    self.model = nil
    self.mgr = MgrMgr:GetMgr("TeamMgr")
    self.data = DataMgr:GetData("TeamData")
end --func end
--next--
function TeamApplyPerTem:BindEvents()


end --func end
--next--
function TeamApplyPerTem:OnDestroy()
	if self.model then
		self:DestroyUIModel(self.model)
		self.model = nil
	end
end --func end
--next--
function TeamApplyPerTem:OnDeActive()


end --func end
--next--
function TeamApplyPerTem:OnSetData(data)
    self:RefreshPanel(data)

end --func end
--next--
--lua functions end

--lua custom scripts
---@param roleData MemberBaseInfo
function TeamApplyPerTem:RefreshPanel(roleData)
    self.Parameter.PlayerName.LabText = Common.Utils.PlayerName(roleData.name)
    self.Parameter.Lv.LabText = "Lv " .. roleData.base_level
    local imageName = self.data.GetProfessionImageById(roleData.type)
    if imageName then
        self.Parameter.Img_Job:SetSprite("Common", imageName)
    end
    if roleData.map_id and roleData.map_id ~= 0 then
        local sceneInfo = TableUtil.GetSceneTable().GetRowByID(roleData.map_id)
        if sceneInfo then
            self.Parameter.Map.LabText = sceneInfo.MiniMap
        end
    end
    self.Parameter.AgreeBtn:AddClick(function()
        self.mgr.Acceptjointeam(roleData.role_uid)
    end)

    local isMale = roleData.sex ~= 1
    if self.model then
        self:DestroyUIModel(self.model)
		self.model = nil
    end
    local attr = self.mgr.GetRoleAttrByData(roleData.type, isMale, roleData.outlook, roleData.equip_ids)
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.ModelImage.RawImg
    l_fxData.attr = attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)
    self.model = self:CreateUIModel(l_fxData)
    self.model:AddLoadModelCallback(function(m)
        self.Parameter.ModelImage:SetActiveEx(true)
    end)
end

--lua custom scripts end
return TeamApplyPerTem