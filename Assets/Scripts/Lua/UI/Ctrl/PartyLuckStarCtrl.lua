--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PartyLuckStarPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PartyLuckStarCtrl = class("PartyLuckStarCtrl", super)
local l_itemList = {}
local l_themePartyMgr = nil
local l_curSelect = 0
--lua class define end

--lua functions
function PartyLuckStarCtrl:ctor()
    super.ctor(self, CtrlNames.PartyLuckStar, UILayer.Function, nil, ActiveType.Standalone)
    l_themePartyMgr = MgrMgr:GetMgr("ThemePartyMgr")
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.PartyLuckStar
end --func end
--next--
function PartyLuckStarCtrl:Init()
    self.panel = UI.PartyLuckStarPanel.Bind(self)
    super.Init(self)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PartyLuckStar)
    end)

    l_itemList = {}
    self.ContentData = {}
    self:InintContent()
end --func end
--next--
function PartyLuckStarCtrl:Uninit()
    l_itemList = {}
    self.ContentData = nil
    l_curSelect = nil
    self:DestoryModel()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function PartyLuckStarCtrl:OnActive()
    self.panel.ModelImage.gameObject:SetActiveEx(false)
    l_themePartyMgr.ThemePartyGetPrizeMember()
end --func end
--next--
function PartyLuckStarCtrl:OnDeActive()
    l_itemList = {}
    self.ContentData = nil
    l_curSelect = nil
    self:DestoryModel()
end --func end
--next--
function PartyLuckStarCtrl:Update()


end --func end

--next--
function PartyLuckStarCtrl:BindEvents()
    self:BindEvent(l_themePartyMgr.EventDispatcher, l_themePartyMgr.ON_GET_PRIZE_MEMBER, function()
        self:SetContenData(l_themePartyMgr.l_prizeMemberList)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function PartyLuckStarCtrl:InintContent()
    self.uiWrapContent = self.panel.Content.gameObject:GetComponent("UIWrapContent")
    self.uiWrapContent:InitContent()
    local l_count = 0
    self.uiWrapContent.updateOneItem = function(obj, index)
        local finIndex = index + 1
        if l_itemList[finIndex] == nil then
            l_itemList[finIndex] = {}
            self:SetTeamList(l_itemList[finIndex], obj)
        end
        if self.ContentData[finIndex] then
            self:SetTeamListByData(l_itemList[finIndex], self.ContentData[finIndex], finIndex)
        end
    end
    self.uiWrapContent:SetContentCount(l_count)
end

function PartyLuckStarCtrl:SetContenData(data)
    if data then
        self.ContentData = data
        self.uiWrapContent:SetContentCount(table.maxn(self.ContentData))
        if l_curSelect == nil or l_curSelect == 0 then
            l_itemList[1].btn.Tog.isOn = true
        end
    end
end

function PartyLuckStarCtrl:SetTeamList(element, obj)
    element.ui = obj
    element.btn = obj:GetComponent("MLuaUICom")
    element.HeadDummy = element.ui.transform:Find("Icon"):GetComponent("MLuaUICom")
    element.HeadComp = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = element.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    element.NoIcon = element.ui.transform:Find("Icon/NoIcon"):GetComponent("MLuaUICom")
    element.RankImg = element.ui.transform:Find("Rank"):GetComponent("MLuaUICom")
    element.Name = element.ui.transform:Find("Name"):GetComponent("MLuaUICom")
    element.Number = element.ui.transform:Find("Number"):GetComponent("MLuaUICom")
    element.Mark = element.ui.transform:Find("Mark"):GetComponent("MLuaUICom")
end

local PrizeIcon = {
    "UI_CommonIcon_Rank1.png",
    "UI_CommonIcon_Rank2.png",
    "UI_CommonIcon_Rank3.png",
}

function PartyLuckStarCtrl:SetTeamListByData(item, prizeMemberData, index)
    local isCreate = prizeMemberData.is_create
    local isCreateNoOneGet = prizeMemberData.is_createnooneGet
    local data = prizeMemberData.member
    item.RankImg:SetSprite("CommonIcon", PrizeIcon[tonumber(prizeMemberData.lottery_rank)])
    if not isCreate then
        item.HeadDummy:SetActiveEx(false)
        item.NoIcon:SetActiveEx(true)
        item.Number.LabText = Lang("UNOPEN_PRIZE_NUMBER")
        item.Name.LabText = Lang("OPEN_DANCE_PRIZE_TIME", prizeMemberData.startTime, prizeMemberData.lable)
    else
        if isCreateNoOneGet then
            item.HeadDummy:SetActiveEx(false)
            item.NoIcon:SetActiveEx(true)
            item.Number.LabText = Lang("UNOPEN_PRIZE_NUMBER_NOONE_GET")
            item.Name.LabText = Lang("CREATE_BUT_NO_ONEGET_LUCKY_PRIZE")
        else
            item.HeadDummy:SetActiveEx(true)
            item.NoIcon:SetActiveEx(false)
            local l_entity = MEntityMgr:GetEntity(data.role_uid, true)
            ---@type HeadTemplateParam
            local param = {}
            if l_entity then
                param.Entity = l_entity
            else
                local data = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data)
                param.EquipData = data
            end

            item.HeadComp:SetData(param)
            item.Number.LabText = "No." .. prizeMemberData.lucky_no
            item.Name.LabText = data.name
        end
    end

    item.btn.Tog.onValueChanged:AddListener(function(value)
        item.Mark:SetActiveEx(value)
        if value then
            self:ShowRightPanelByDate(prizeMemberData)
        end
        l_curSelect = index
    end)
end

function PartyLuckStarCtrl:ShowRightPanelByDate(prizeMemberData)
    local isCreate = prizeMemberData.is_create
    local isCreateNoOneGet = prizeMemberData.is_createnooneGet
    self.panel.None:SetActiveEx(not isCreate or isCreateNoOneGet)
    self.panel.ModelImage:SetActiveEx(isCreate and not isCreateNoOneGet)
    if isCreate and not isCreateNoOneGet then
        --有人获奖 且 有人领奖
        self.panel.PrizeTitle.LabText = Lang("GET_LUCKY_PRIZE")
    else
        if not isCreate then
            --没有产生获奖
            self.panel.PrizeTitle.LabText = Lang("OPEN_DANCE_PRIZE_TIME", prizeMemberData.startTime, prizeMemberData.lable)
        end

        if isCreate and isCreateNoOneGet then
            --有人获奖 但 没人领奖
            self.panel.PrizeTitle.LabText = Lang("CREATE_BUT_NO_ONEGET_LUCKY_PRIZE")
        end
    end

    if isCreate and not isCreateNoOneGet then
        self.model = self:CreateModelEntity(prizeMemberData.member)
    end
end

function PartyLuckStarCtrl:DestoryModel()
    if self.model then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
end

function PartyLuckStarCtrl:CreateModelEntity(data)
    self:DestoryModel()
    local isMale = true
    if data.sex and data.sex == 1 then
        isMale = false
    end

    local attr = MgrMgr:GetMgr("TeamMgr").GetRoleAttrByData(data.type, isMale, data.outlook, data.equip_ids)
    local l_fxData = {}
    l_fxData.rawImage = self.panel.ModelImage.RawImg
    l_fxData.attr = attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)
    local model = self:CreateUIModel(l_fxData)
    model:AddLoadModelCallback(function(m)
        self.panel.ModelImage.gameObject:SetActiveEx(true)
    end)

    local listener = self.panel.ModelImage:GetComponent("MLuaUIListener")
    listener.onDrag = function(uobj, event)
        if model and model.Trans then
            model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
        end
    end

    listener.onClick = function(g, e)
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(MLuaCommonHelper.Long(data.role_uid))
    end

    return model
end

--lua custom scripts end
return PartyLuckStarCtrl