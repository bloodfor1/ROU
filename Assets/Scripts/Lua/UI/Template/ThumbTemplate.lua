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
local l_friendMgr = MgrMgr:GetMgr("FriendMgr")
--lua fields end

--lua class define
---@class ThumbTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpLab MoonClient.MLuaUICom
---@field UI MoonClient.MLuaUICom
---@field ThumbBtn MoonClient.MLuaUICom
---@field Taken MoonClient.MLuaUICom
---@field PlayerPos MoonClient.MLuaUICom
---@field NameLab MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field JobText MoonClient.MLuaUICom
---@field IsMy MoonClient.MLuaUICom
---@field Hit MoonClient.MLuaUICom
---@field Heal MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom
---@field AddFriendBtn MoonClient.MLuaUICom

---@class ThumbTemplate : BaseUITemplate
---@field Parameter ThumbTemplateParameter

ThumbTemplate = class("ThumbTemplate", super)
--lua class define end

--lua functions
function ThumbTemplate:Init()

    super.Init(self)
    self.m_model = nil

end --func end
--next--
function ThumbTemplate:OnDestroy()

    if self.m_model then
        self:DestroyUIModel(self.m_model)
        self.m_model = nil
    end

end --func end
--next--
function ThumbTemplate:OnSetData(data)

    self:ShowTeamItem(data)

end --func end
--next--
function ThumbTemplate:BindEvents()


end --func end
--next--
function ThumbTemplate:OnDeActive()


end --func end
--next--
--lua functions end

--lua custom scripts
function ThumbTemplate:ShowTeamItem(data)

    self.data = data
    self.Parameter.NameLab.LabText = DataMgr:GetData("ThemeDungeonData").GetRoleNameById(data.roleId)
    --战斗属性
    self.Parameter.Taken.gameObject:SetActiveEx(data.isTaken == 1)
    self.Parameter.Hit.gameObject:SetActiveEx(data.isHit == 1)
    self.Parameter.Damage.gameObject:SetActiveEx(data.isDamage == 1)
    self.Parameter.Heal.gameObject:SetActiveEx(data.isHeal == 1)
    self.Parameter.AddFriendBtn.gameObject:SetActiveEx(true)
    --玩家职业
    local l_data = TableUtil.GetProfessionTable().GetRowById(data.professionID)
    self.Parameter.JobText.LabText = l_data.Name
    --判断是否是自己
    if tostring(data.roleId) == tostring(MPlayerInfo.UID) then
        self.Parameter.AddFriendBtn.Img.color = Color.New(0, 0, 0)
        self.Parameter.IsMy:SetSpriteAsync("Theme", "UI_Theme_SettlementBG_ziji.png")
    end
    --点赞玩家
    self.Parameter.ThumbBtn:AddClick(function()
        if self.Parameter.ThumbBtn.Img.color == Color.New(0, 0, 0) then
            return
        end
        self.Parameter.ThumbBtn.Img.color = Color.New(0, 0, 0)
        MgrMgr:GetMgr("ThemeDungeonMgr").SendDungeonsEncourage(data.roleId)
    end)
    self.Parameter.ThumbBtn.gameObject:SetActiveEx(not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator())

    --加好友
    -- 如果已经是好友就不要注册回调了
    local l_notFriendCb = function()
        self.Parameter.AddFriendBtn.Img.color = Color.New(0, 0, 0)
        l_friendMgr.RequestAddFriend(self.data.roleId)
    end

    if l_friendMgr.IsFriend(data.roleId) then
        self.Parameter.AddFriendBtn.Img.color = Color.New(0, 0, 0)
        self.Parameter.AddFriendBtn:AddClick(nil)
    else
        self.Parameter.AddFriendBtn:AddClick(l_notFriendCb)
    end

    if DataMgr:GetData("ThemeDungeonData").ThumbQueue[data.roleId] ~= nil then
        self.Parameter.UpLab.LabText = tostring(DataMgr:GetData("ThemeDungeonData").ThumbQueue[data.roleId].index)
    end
    --生成角色模型
    self.Parameter.ModelImage.gameObject:SetActiveEx(true)
    self.m_model = self:CreateRole(data.roleId, data.roleId, self.Parameter.PlayerPos.gameObject, self.Parameter.ModelImage.RawImg, self)
    --队伍结算的UI效果
    MUITweenHelper.TweenPos(self.Parameter.UI.gameObject, self.Parameter.UI.transform.localPosition, Vector3.New(0, 0, 0), 0.5)

end

function ThumbTemplate:OnThumbEvent(beThumbID)
    self.Parameter.UpLab.LabText = tostring(DataMgr:GetData("ThemeDungeonData").ThumbQueue[beThumbID].index)
end

function ThumbTemplate:CreateRole(roleId, index, parentGo, rawImg, thumbItem)

    local l_target
    l_target = self:CreateRoleByTeamInfo(roleId, index, rawImg)
    if l_target == nil then
        l_target = self:CreateRoleByScene(roleId, index, rawImg)
    end
    if l_target == nil then
        l_target = self:CreateRoleBySever(roleId, rawImg, thumbItem)
    end
    if l_target == nil then
        rawImg.gameObject:SetActiveEx(false)
    end
    return l_target

end

function ThumbTemplate:CreateRoleByScene(roleId, index, rawImg)

    local l_sceneRoleInfo = DataMgr:GetData("ThemeDungeonData").GetSceneRoleInfoAndTeamInfo()
    if l_sceneRoleInfo == nil then
        return nil
    end
    local l_targetInfo = l_sceneRoleInfo[roleId]
    if l_targetInfo == nil then
        return nil
    end
    local l_fxData = {}
    l_fxData.rawImage = rawImg
    l_fxData.attr = l_targetInfo
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_targetInfo)
    local l_model = self:CreateUIModel(l_fxData)
    l_model:AddLoadModelCallback(function(m)
        rawImg.gameObject:SetActiveEx(true)
    end)
    return l_model

end

function ThumbTemplate:CreateRoleByTeamInfo(roleId, index, rawImg)

    local data = DataMgr:GetData("TeamData").myTeamInfo
    if data == nil then
        return nil
    end
    ---@type ClientOneMemberInfo
    local l_targetInfo = nil
    for k, v in pairs(data.memberList) do
        if l_targetInfo == nil and tostring(v.roleId) == tostring(roleId) then
            l_targetInfo = v
        end
    end
    if l_targetInfo == nil then
        return nil
    end
    local l_model
    local isMale = true
    if l_targetInfo.roleSex and l_targetInfo.roleSex == 1 then
        isMale = false
    end
    if l_targetInfo.roleType and l_targetInfo.roleType ~= 0 then
        local l_attr = MgrMgr:GetMgr("TeamMgr").GetRoleAttrByData(l_targetInfo.roleType, l_targetInfo.roleSex ~= 1, l_targetInfo.roleOutlook, l_targetInfo.roleEquipIds)
        local l_fxData = {}
        l_fxData.rawImage = rawImg
        l_fxData.attr = l_attr
        l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)
        l_model = self:CreateUIModel(l_fxData)
        l_model:AddLoadModelCallback(function(m)
            rawImg.gameObject:SetActiveEx(true)
        end)
        return l_model
    end
    return nil

end

function ThumbTemplate:CreateRoleBySever(roleId, rawImg, thumbItem)

    MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(roleId, function(playInfo)
        if not rawImg then
            return
        end
        local l_attr = playInfo:GetAttribData()
        local l_fxData = {}
        l_fxData.rawImage = rawImg
        l_fxData.attr = l_attr
        l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)
        l_model = self:CreateUIModel(l_fxData)
        l_model:AddLoadGoCallback(function(go)
            if not rawImg then
                self:DestroyUIModel(l_model)
                return
            end
            rawImg.gameObject:SetActiveEx(true)
        end)
        if not thumbItem then
            self:DestroyUIModel(l_model)
            return
        end
        thumbItem.m_model = l_model
    end)

end
--lua custom scripts end
return ThumbTemplate