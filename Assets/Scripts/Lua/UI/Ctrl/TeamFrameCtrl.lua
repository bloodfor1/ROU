--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamFramePanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamFrameCtrl = class("TeamFrameCtrl", super)
--lua class define end

--lua functions
function TeamFrameCtrl:ctor()

    super.ctor(self, CtrlNames.TeamFrame, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function TeamFrameCtrl:Init()

    self.panel = UI.TeamFramePanel.Bind(self)
    super.Init(self)
    self.pvpArenaMgr = MgrMgr:GetMgr("PvpArenaMgr")
    self:OnInit()

end --func end
--next--
function TeamFrameCtrl:Uninit()

    self:OnUninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function TeamFrameCtrl:OnActive()
    self.panel.member.gameObject:SetActiveEx(false)
end --func end
--next--
function TeamFrameCtrl:OnDeActive()

end --func end
--next--
function TeamFrameCtrl:Update()

end --func end

--next--
function TeamFrameCtrl:BindEvents()
    self:BindEvent(self.pvpArenaMgr.EventDispatcher, self.pvpArenaMgr.ON_PVP_MEMBER_UPDATE_HP, function(self, roleId)
        local l_info = self.pvpArenaMgr.m_memberInfo[roleId]
        self:InitItem(l_info)
    end)
    self:BindEvent(self.pvpArenaMgr.EventDispatcher, self.pvpArenaMgr.UPDATE_ARENA_ROOM_INFO_NTF, function()
        if StageMgr:GetCurStageEnum() == MStageEnum.Arena and not self.state then
            self:InitScrollView()
        end
    end)
    self:BindEvent(self.pvpArenaMgr.EventDispatcher, self.pvpArenaMgr.LEAVE_ARENA_ROOM_INFO_NTF, function()
        if StageMgr:GetCurStageEnum() == MStageEnum.Arena then
            self:InitScrollView()
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

local m_allItem = {}
local m_curSelected = {}

function TeamFrameCtrl:OnInit()

    self.state = false
    if self.pvpArenaMgr.m_arenaRoomInfo ~= nil then
        self:InitScrollView()
    end

end

function TeamFrameCtrl:OnUninit()
    self:DestoryAllItemData()
    m_allItem = {}
    m_curSelected = {}
end

function TeamFrameCtrl:InitScrollView()
    self:DestoryAllItemData()
    self.state = true
    local l_targetInfo = self.pvpArenaMgr.m_memberInfo
    local l_playerGroup = 1
	for k,v in pairs(l_targetInfo) do
		local l_roleId = v.RoleId
		if tostring(MPlayerInfo.UID) == tostring(l_roleId) then
			l_playerGroup = v.FightGroup
			break
		end
	end
    for k, v in pairs(l_targetInfo) do
        local l_roleId = v.RoleId
        if tostring(MPlayerInfo.UID) ~= tostring(l_roleId) then
            local l_targetGroup = v.FightGroup;
            if l_playerGroup == l_targetGroup then
                m_allItem[l_roleId] = {}
                m_allItem[l_roleId].roleId = l_roleId
                m_allItem[l_roleId].Item = {}
                local l_go = self:CloneObj(self.panel.member.gameObject)
                l_go.transform:SetParent(self.panel.member.gameObject.transform.parent)
                l_go.transform.localScale = self.panel.member.gameObject.transform.localScale
                l_go:SetActiveEx(true)
                self:ExportItem(m_allItem[l_roleId].Item, l_go)
                self:InitItem(v)
            end
        end
    end
    m_curSelected = {}
end

function TeamFrameCtrl:DestoryAllItemData(...)
    for k, v in pairs(m_allItem) do
        if v.Item and v.Item.ui then
            MResLoader:DestroyObj(v.Item.ui)
            v.Item = nil
        end
    end
end

function TeamFrameCtrl:ExportItem(item, obj)
    item.ui = obj
    item.btn = item.ui:GetComponent("MLuaUICom")
    item.checkMark = item.ui.transform:Find("Checkmark").gameObject
    item.checkMark:SetActiveEx(false)
    item.nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("Name"))
    item.jobImg = item.ui.transform:Find("ImgJob"):GetComponent("MLuaUICom")
    item.hpSlider = item.ui.transform:Find("SliderHP"):GetComponent("Slider")
end

function TeamFrameCtrl:InitItem(info)
    --Common.Functions.DumpTable(info, "<var>", 6)
    local l_roleId = info.RoleId
    if m_allItem == nil then
        return
    end

    if m_allItem[l_roleId] == nil then
        return
    end
    m_allItem[l_roleId].Item.nameLab.LabText = info.Name
    local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(info.professionId)
    if imageName then
        m_allItem[l_roleId].Item.jobImg:SetSpriteAsync("Common", imageName)
    end
    m_allItem[l_roleId].Item.hpSlider.value = info.HP
    m_allItem[l_roleId].Item.btn:AddClick(function()
        self:OnClickItem(m_allItem[l_roleId])
    end)
end

function TeamFrameCtrl:OnClickItem(item)
    if m_curSelected.Item then
        m_curSelected.Item.checkMark:SetActiveEx(false)
    end
    m_curSelected = item
    m_curSelected.Item.checkMark:SetActiveEx(true)
end

return TeamFrameCtrl
--lua custom scripts end
