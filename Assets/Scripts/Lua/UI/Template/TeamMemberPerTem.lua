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
---@class TeamMemberPerTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SuitFlag MoonClient.MLuaUICom
---@field ReviveMask MoonClient.MLuaUICom
---@field PlayerTpl MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field OnLineStatus MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field MaskTime MoonClient.MLuaUICom
---@field Map MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field LeadFlag MoonClient.MLuaUICom
---@field KickButton MoonClient.MLuaUICom
---@field InviteButton MoonClient.MLuaUICom
---@field Img_Job MoonClient.MLuaUICom
---@field FollowTog MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field BG2 MoonClient.MLuaUICom
---@field BG1 MoonClient.MLuaUICom

---@class TeamMemberPerTem : BaseUITemplate
---@field Parameter TeamMemberPerTemParameter

TeamMemberPerTem = class("TeamMemberPerTem", super)
--lua class define end

--lua functions
function TeamMemberPerTem:Init()

    super.Init(self)
    self.mgr = MgrMgr:GetMgr("TeamMgr")
    self.data = DataMgr:GetData("TeamData")
    self.model = nil
    self.isDeath = false
    self.reviveTimer = nil
end --func end
--next--
function TeamMemberPerTem:BindEvents()


end --func end
--next--
function TeamMemberPerTem:OnDestroy()

    if self.model ~= nil then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
    --self:ClearTimer()
end --func end
--next--
function TeamMemberPerTem:OnDeActive()


end --func end
--next--
function TeamMemberPerTem:OnSetData(data)

    self.Parameter.BG1:SetActiveEx(false)
    self.Parameter.BG2:SetActiveEx(false)
    if data.posType == self.data.ETeamPosType.Role then
        self:SetRole(data.info)
    elseif data.posType == self.data.ETeamPosType.Mercenary then
        self:SetMercenary(data.info)
    else
        self:SetEmpty()
    end

end --func end
--next--
--lua functions end

--lua custom scripts
function TeamMemberPerTem:SetEmpty()
    self.Parameter.BG1:SetActiveEx(true)
    self.Parameter.InviteButton:AddClick(function()
        MgrMgr:GetMgr("TeamMgr").GetInvitationIdListByType()
    end)
end

---@param data ClientOneMemberInfo
function TeamMemberPerTem:SetRole(data)
    self.Parameter.BG2:SetActiveEx(true)
    self.Parameter.PlayerName.LabText = Common.Utils.PlayerName(data.roleName)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.PlayerName.transform)
    local l_layout = self.Parameter.PlayerName:GetComponent("LayoutElement")
    l_layout.enabled = self.Parameter.PlayerName:GetComponent("Text").preferredWidth > l_layout.preferredWidth
    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, data.roleBriefInfo.tag)
    self.Parameter.Lv.LabText = "Lv." .. data.roleLevel
    self.Parameter.OnLineStatus:SetActiveEx(true)
    self.Parameter.OnLineStatus.LabText = self.mgr.GetMemberOnLineStatus(data)
    if data.sceneId and data.sceneId ~= 0 then
        local sceneInfo = TableUtil.GetSceneTable().GetRowByID(data.sceneId, true)
        if sceneInfo then
            self.Parameter.Map.LabText = sceneInfo.MiniMap .. self.mgr.GetLineText(data)
        end
    end
    self:SetProImage(data.roleType)

    self.Parameter.LeadFlag:SetActiveEx(uint64.equals(self.data.myTeamInfo.captainId, data.roleId))
    self.Parameter.FollowTog:SetActiveEx(uint64.equals(data.roleId, MPlayerInfo.FollowerUid))
    self.Parameter.SuitFlag:SetActiveEx(false)
    self.Parameter.ReviveMask:SetActiveEx(false)
    self.Parameter.KickButton:SetActiveEx(false)
    self.Parameter.BG2:AddClick(function()
        if not uint64.equals(MPlayerInfo.UID, data.roleId) then
            local pos = self.ShowIndex <= 3 and Vector3.New(480 + 160 * (i - 1), -305) or Vector3.New(490 + 160 * (i - 4), -305)
            self.mgr.ShowTeamFuncView(data.roleId, Vector2.New(-190 + 160 * (i - 1), 0), pos)
        end
    end)

    local isMale = data.roleSex ~= 1
    if self.model ~= nil then
        self:DestroyUIModel(self.model)
        self.model = nil
    end

    if data.roleType ~= 0 then
        local attr = self.mgr.GetRoleAttrByData(data.roleType, isMale, data.roleOutlook, data.roleEquipIds)
        local l_fxData = {}
        l_fxData.rawImage = self.Parameter.ModelImage.RawImg
        l_fxData.attr = attr
        l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)

        self.Parameter.ModelImage.RectTransform.sizeDelta = Vector2.New(256, 512)

        self.model = self:CreateUIModel(l_fxData)
        self.model:AddLoadModelCallback(function(m)
            self.Parameter.ModelImage:SetActiveEx(true)
        end)
    end
end

---@param data ClientMercenaryInfo
function TeamMemberPerTem:SetMercenary(data)
    local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(data.Id)
    self.Parameter.BG2:SetActiveEx(true)
    self.Parameter.PlayerName.LabText = l_mercenaryRow.Name
    self.Parameter.Lv.LabText = "Lv." .. data.lvl
    self.Parameter.OnLineStatus:SetActiveEx(true)
    self.Parameter.OnLineStatus.LabText = self.mgr.GetMercenaryStatus()
    self.Parameter.LeadFlag:SetActiveEx(false)
    self.Parameter.FollowTog:SetActiveEx(false)
    self.Parameter.SuitFlag:SetActiveEx(true)
    self.Parameter.KickButton:SetActiveEx(false)
    self.Parameter.BiaoQian:SetActiveEx(false)
    self:SetProImage(l_mercenaryRow.Profession)

    self.isDeath = data.isDeath
    self.Parameter.ReviveMask:SetActiveEx(self.isDeath)
    self.Parameter.MaskTime.LabText = data.reviveTime

    --if data.isDeath then
    --
    --    self:ClearTimer()
    --    self.reviveTimer = self:NewUITimer(function()
    --        local l_curTime = Common.TimeMgr.GetNowTimestamp()
    --        self.Parameter.MaskTime.LabText = tostring(math.floor(data.reviveTime - l_curTime)) .. Common.Utils.Lang("Resurrection_Time_Text")
    --        if (tonumber(data.reviveTime) < tonumber(l_curTime)) then
    --            self.Parameter.ReviveMask:SetActiveEx(false)
    --            self:ClearTimer()
    --        end
    --    end, 1, -1)
    --end

    local _, mapID = self.data.GetUserIsInTeamAndSceneId(data.ownerId)
    if mapID then
        local sceneInfo = TableUtil.GetSceneTable().GetRowByID(mapID, true)
        if sceneInfo then
            self.Parameter.Map.LabText = sceneInfo.MiniMap
        end
    end

    if self.model ~= nil then
        self:DestroyUIModel(self.model)
        self.model = nil
    end

    self.Parameter.ModelImage.RectTransform.sizeDelta = Vector2.New(512, 512)

    local l_modelData = {
        defaultEquipId = l_mercenaryRow.DefaultEquipID,
        presentId = l_mercenaryRow.PresentID,
        rawImage = self.Parameter.ModelImage.RawImg
    }
    self.model = self:CreateUIModelByDefaultEquipId(l_modelData)
    self.Parameter.BG2:AddClick(function()
        local l_CallBack_MercenarySetting = function()
            if data and uint64.equals(data.ownerId, MPlayerInfo.UID) then
                MgrMgr:GetMgr("MercenaryMgr").OpenMercenary(data.Id)
            else
                MgrMgr:GetMgr("MercenaryMgr").OpenMercenary()
            end
        end
        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = { Common.Utils.Lang("MERCENARY_SET") },
            callbackTb = { l_CallBack_MercenarySetting },
            dataopenPos = Vector2.New(405 + 165 * (i + l_index - 2), -305),
            dataAnchorMaxPos = Vector2.New(0, 1),
            dataAnchorMinPos = Vector2.New(0, 1)
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
    end)
end

function TeamMemberPerTem:SetProImage(roleType)
    local imageName = self.data.GetProfessionImageById(roleType)
    self.Parameter.Img_Job:SetSprite("Common", imageName)
end

function TeamMemberPerTem:ClearTimer()
    if self.reviveTimer ~= nil then
        self:StopUITimer(self.reviveTimer)
        self.reviveTimer = nil
    end
end

--lua custom scripts end
return TeamMemberPerTem