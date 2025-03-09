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
---@class LakeTplParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Maptxt MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field LakeTpl MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field Btntxt MoonClient.MLuaUICom
---@field BtnSmall MoonClient.MLuaUICom

---@class LakeTpl : BaseUITemplate
---@field Parameter LakeTplParameter

LakeTpl = class("LakeTpl", super)
--lua class define end

--lua functions
function LakeTpl:Init()

	super.Init(self)
	
end --func end
--next--
function LakeTpl:BindEvents()
	
	
end --func end
--next--
function LakeTpl:OnDestroy()
	
	
end --func end
--next--
function LakeTpl:OnDeActive()
    if self.HeadComponent then
        self.HeadComponent = nil
    end
end --func end
--next--
function LakeTpl:OnSetData(data)
	if self.HeadComponent == nil then
		self.HeadComponent = self:NewTemplate("HeadWrapTemplate", {
			TemplateParent = self.Parameter.HeadDummy.transform,
			TemplatePath = "UI/Prefabs/HeadWrapTemplate"
		})
	end
	self:SetTeamListByData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function LakeTpl:SetTeamListByData(data)
    --所在地图
    if data.map_id then
        local sceneId = data.map_id
        local sceneInfo = TableUtil.GetSceneTable().GetRowByID(sceneId)
        if sceneInfo then
            local mapName = sceneInfo.MiniMap
            self.Parameter.Maptxt.LabText = mapName
        end
    end

    --图集图片
    local textName = DataMgr:GetData("TeamData").GetProfessionNameById(data.type)
    local l_entity = MEntityMgr:GetEntity(data.role_uid, true)
    if l_entity then
        ---@type HeadTemplateParam
        local param = {
            ShowProfession = true,
            Profession = data.type,
            Entity = l_entity,
            OnClick = function()
                Common.CommonUIFunc.RefreshPlayerMenuLByUid(data.role_uid)
            end,
        }
        self.HeadComponent:SetData(param)
    else
        local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data)
        ---@type HeadTemplateParam
        local param = {
            ShowProfession = true,
            Profession = data.type,
            EquipData = equipData,
            OnClick = function()
                Common.CommonUIFunc.RefreshPlayerMenuLByUid(data.role_uid)
            end,
        }
        self.HeadComponent:SetData(param)
    end

    local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
    if selfIsCaptain then
        self.Parameter.Btntxt.LabText = Common.Utils.Lang("INVITE_WORD")
    else
        self.Parameter.Btntxt.LabText = Common.Utils.Lang("RECOMMEND_WORD")
    end

    self.Parameter.cId = data.role_uid
    self.Parameter.cName = data.name
    self.Parameter.Name.LabText = data.name
    self.Parameter.Lv.LabText = "Lv "..data.base_level
    self.Parameter.Job.LabText = textName

    self.Parameter.LakeBtn:AddClick(function()
		self.MethodCallback(data)
    end)

    --self.Parameter.BtnSmall:SetActiveEx(l_themePartyMgr.l_curToggleState == l_themePartyMgr.l_lakeState.NearBy)
    self.Parameter.BtnSmall:AddClick(function()
        MgrMgr:GetMgr("ThemePartyMgr").ThemePartySendLove(data.role_uid)
    end)
end
--lua custom scripts end
return LakeTpl