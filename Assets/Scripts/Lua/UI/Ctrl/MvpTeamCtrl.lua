--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MvpTeamPanel"



--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MvpTeamCtrl = class("MvpTeamCtrl", super)
--lua class define end

--lua functions
function MvpTeamCtrl:ctor()

    super.ctor(self, CtrlNames.MvpTeam, UILayer.Function, nil, ActiveType.Standalone)

    self.InsertPanelName=UI.CtrlNames.DailyTask
    --self:SetParent(UI.CtrlNames.DailyTask)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent

end --func end
--next--
function MvpTeamCtrl:Init()
    self.panel = UI.MvpTeamPanel.Bind(self)
    super.Init(self)
    --self:SetBlockOpt(BlockColor.Transparent)
    self:OnInit()
end --func end
--next--
function MvpTeamCtrl:Uninit()

    self:OnUnInit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MvpTeamCtrl:OnActive()


end --func end
--next--
function MvpTeamCtrl:OnDeActive()


end --func end
--next--
function MvpTeamCtrl:Update()


end --func end



--next--
function MvpTeamCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

local l_info
local l_item = {}

local l_space = 0
local l_modleScale = 1
local l_imageScale = 1

function MvpTeamCtrl:OnInit()
    l_item = {}
    self.playerInfo = {}
    self.panel.closeButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MvpTeam)
    end)
    l_info = MgrMgr:GetMgr("MvpMgr").m_mvpRankInfo.netInfo
    local l_member = l_info.mvp_team_member
    local l_prefab = self.panel.PanelRef.gameObject.transform:Find("BG/RoleGroup/RoleItem").gameObject
    local l_count = #l_member
    l_space = 0
    l_modleScale = 1
    l_imageScale = 1 / 1.15
    if l_count < 1 then
        return
    end
    if l_count < 4 then
        --l_space = 55
        l_modleScale = 1.15
        l_imageScale = 1
    end
    for i = 1, l_count do
        local l_roleInfo = l_member[i].member_info
        local l_score = l_member[i].score
        l_item[i] = {}
        local l_target = self:CloneObj(l_prefab)
        l_item[i].ui = l_target.gameObject
        l_item[i].lvLab = MLuaClientHelper.GetOrCreateMLuaUICom(l_item[i].ui.transform:Find("Lv"))
        l_item[i].nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(l_item[i].ui.transform:Find("Name"))
        l_item[i].jobIcon = l_item[i].ui.transform:Find("Name/Job"):GetComponent("MLuaUICom")
        l_item[i].btn = l_item[i].ui.transform:Find("Button"):GetComponent("MLuaUICom")
        l_item[i].modelImage = l_item[i].ui.transform:Find("ModelImage"):GetComponent("RawImage")
        l_item[i].ui.transform:SetParent(l_prefab.transform.parent)
        l_item[i].ui:SetLocalScaleToOther(l_prefab)
        l_item[i].ui:SetActiveEx(true)

        self.playerInfo[i] = {}
        self.playerInfo[i].RawImg = l_item[i].modelImage
        local l_attr, l_player = MgrMgr:GetMgr("HeadMgr").GetAttrByMemberDetailInfo(l_roleInfo)
        local l_fxData = {}
        l_fxData.rawImage = self.playerInfo[i].RawImg
        l_fxData.attr = l_attr
        l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)
        self.playerInfo[i].model = self:CreateUIModel(l_fxData)
        self.playerInfo[i].model.Scale = Vector3.New(l_modleScale, l_modleScale, l_modleScale)
        self.playerInfo[i].model.Position = Vector3.New(0, 0, 0)
        self.playerInfo[i].model:AddLoadModelCallback(function(m)
            self.playerInfo[i].RawImg.gameObject:SetLocalScale(l_imageScale, l_imageScale, 1)
            self.playerInfo[i].RawImg.gameObject:SetActiveEx(true)
        end)
        

        l_item[i].lvLab.LabText = "Lv." .. tostring(l_player.level)
        l_item[i].nameLab.LabText = l_player.name
        local l_imageName = DataMgr:GetData("TeamData").GetProfessionImageById(l_player.role_type)
        if l_imageName then
            l_item[i].jobIcon:SetSpriteAsync("Common", l_imageName)
        end
        l_item[i].btn:AddClick(function()
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(l_player.uid)
        end)
    end
    local l_group = self.panel.PanelRef.gameObject.transform:Find("BG/RoleGroup"):GetComponent("HorizontalLayoutGroup")
    l_group.spacing = l_space
end

function MvpTeamCtrl:OnUnInit()
    if #l_item > 0 then
        for i = 1, #l_item do
            if self.playerInfo[i].model ~= nil then
                --TODO:不知道有没有用对象池,反正重置下吧哎
                self.playerInfo[i].model.Scale = Vector3.New(1.0, 1.0, 1.0)
                self:DestroyUIModel(self.playerInfo[i].model)
                self.playerInfo[i].model = nil
            end
            MResLoader:DestroyObj(l_item[i].ui)
        end
    end
end
return MvpTeamCtrl
--lua custom scripts end
