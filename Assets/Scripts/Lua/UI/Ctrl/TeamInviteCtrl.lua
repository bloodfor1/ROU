--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamInvitePanel"
--

-- 获取头像用
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamInviteCtrl = class("TeamInviteCtrl", super)
--lua class define end

--lua functions
function TeamInviteCtrl:ctor()

    super.ctor(self, CtrlNames.TeamInvite, UILayer.Function, nil, ActiveType.Standalone)


end --func end
--next--
function TeamInviteCtrl:Init()

    self.panel = UI.TeamInvitePanel.Bind(self)
    super.Init(self)
    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamInvite)
    end)
    self.panel.BtnBg:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamInvite)
    end)
    self:SetTitle()
    self.teamInviteUI = {}
end --func end
--next--
function TeamInviteCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end

--next--
function TeamInviteCtrl:OnActive()
    if self.teamInviteUI == nil then
        self.teamInviteUI = {}
    end
    if self.uiPanelData ~= nil then
        if self.uiPanelData.openType == DataMgr:GetData("TeamData").ETeamOpenType.SetPanelByInfo then
            self:SetPanelByInfo(self.uiPanelData.openData)
        end
    end
end --func end

--next--
function TeamInviteCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function TeamInviteCtrl:Update()
    -- do nothing
end --func end
--next--
function TeamInviteCtrl:BindEvents()
    -- do nothing
end --func end

function TeamInviteCtrl:SetTitle()
    local typeTb = {
        [1] = Common.Utils.Lang("FRIEND"), --好友
        [2] = Common.Utils.Lang("TRADE_TIPS"), --工会
        [3] = Common.Utils.Lang("RECOMMEND_TEAM"), --推荐组队
    }
    self.itemTb = {}
    self.panel.Tog.gameObject:SetActiveEx(true)
    for i = 1, table.ro_size(typeTb) do
        self.itemTb[i] = {}
        self.itemTb[i].titleId = i
        self.itemTb[i].ui = self:CloneObj(self.panel.Tog.gameObject)
        self.itemTb[i].ui.transform:SetParent(self.panel.Tog.transform.parent)
        self.itemTb[i].ui.transform:SetLocalScaleOne()
        self.itemTb[i].ui.transform:SetLocalPos(-141 + 143 * (i - 1), 0, 0)
        self.itemTb[i].childToogle = {}
        self:ExportElement(self.itemTb[i])
        self.itemTb[i].parentItemTxtOn.LabText = typeTb[i]
        self.itemTb[i].parentItemTxtOff.LabText = typeTb[i]

        --暂时默认显示类型4
        if i == 3 then
            self.itemTb[i].toggle.isOn = true
        else
            self.itemTb[i].toggle.isOn = false
        end

        self.itemTb[i].toggle.onValueChanged:AddListener(function(index)
            if index then
                MgrMgr:GetMgr("TeamMgr").GetInvitationIdListByType(self.itemTb[i].titleId)
            end
        end)
    end
    self.panel.Tog.gameObject:SetActiveEx(false)
end

function TeamInviteCtrl:ExportElement(element)
    element.toggle = element.ui.transform:GetComponent("MLuaUICom").TogEx
    element.parentItemImgOn   = element.ui.transform:Find("ON/Image"):GetComponent("MLuaUICom")
    element.parentItemImgOff  = element.ui.transform:Find("OFF/Image"):GetComponent("MLuaUICom")
    element.parentItemTxtOn   = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ON/Text"))
    element.parentItemTxtOff  = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("OFF/Text"))
end

function TeamInviteCtrl:SetPanelByInfo(cShowData)
    local currentIds = DataMgr:GetData("TeamData").GetCurrentMemberIds()
    if self.panel == nil then
        return
    end
    if self.teamInviteUI == nil then
        return
    end
    self:ClearUI()
    local cData = cShowData
    self.panel.AchieveTpl.gameObject:SetActiveEx(true)
    self.panel.NoData.gameObject:SetActiveEx(table.maxn(cData)<=0)
    for i=1,table.maxn(cData) do
        --判断当前玩家在不在邀请CD中
        if not DataMgr:GetData("TeamData").CheckIsInvateCd(cData[i].role_uid) then

            self.teamInviteUI[i] = {}
            self.teamInviteUI[i].ui = self:CloneObj(self.panel.AchieveTpl.gameObject)
            self.teamInviteUI[i].ui.transform:SetParent(self.panel.AchieveTpl.transform.parent)
            self.teamInviteUI[i].ui.transform:SetLocalScaleOne()
            self:ExportItem(self.teamInviteUI[i])
            if currentIds[cData[i].role_uid] and currentIds[cData[i].role_uid] == 1 then
                self.teamInviteUI[i].CurrenInvite:SetActiveEx(true)
            else
                self.teamInviteUI[i].CurrenInvite:SetActiveEx(false)
            end
            --所在地图
            if cData[i].map_id then
                local sceneId = cData[i].map_id
                local sceneInfo = TableUtil.GetSceneTable().GetRowByID(sceneId)
                if sceneInfo then
                    local mapName = sceneInfo.MiniMap
                    self.teamInviteUI[i].Maptxt.LabText = mapName
                end
            end

            local textName = DataMgr:GetData("TeamData").GetProfessionNameById(cData[i].type)
            local l_entity = MEntityMgr:GetEntity(cData[i].role_uid, true)

            local onIconClick = function()
                Common.CommonUIFunc.RefreshPlayerMenuLByUid(cData[i].role_uid)
            end

            ---@type HeadTemplateParam
            local param = {}
            if l_entity then
                param.Entity = l_entity
                param.OnClick = onIconClick
            else
                param.OnClick = onIconClick
                local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(cData[i])
                param.EquipData = equipData
            end

            self.teamInviteUI[i].HeadComp:SetData(param)
            local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
            if selfIsCaptain then
                self.teamInviteUI[i].Btntxt.LabText = Common.Utils.Lang("INVITE_WORD")
            else
                self.teamInviteUI[i].Btntxt.LabText = Common.Utils.Lang("RECOMMEND_WORD")
            end

            self.teamInviteUI[i].cId = cData[i].role_uid
            self.teamInviteUI[i].cName = cData[i].name
            self.teamInviteUI[i].Name.LabText = cData[i].name
            self.teamInviteUI[i].Lv.LabText = "Lv "..cData[i].base_level
            self.teamInviteUI[i].Job.LabText = textName

            -- 标签处理
            MgrMgr:GetMgr("RoleTagMgr").SetTag(self.teamInviteUI[i].BiaoQian, cData[i].tag)

            self.teamInviteUI[i].Btn:AddClick(function()
                if DataMgr:GetData("TeamData").CheckIsInvateCd(cData[i].role_uid) then
                    return
                end
                if selfIsCaptain then
                    MgrMgr:GetMgr("TeamMgr").InviteJoinTeam(cData[i].role_uid, cData[i].base_level)
                    self.teamInviteUI[i].Btntxt.LabText = Common.Utils.Lang("HAS_INVATED")
                else
                    MgrMgr:GetMgr("TeamMgr").RecommandMember(cData[i].role_uid)
                    self.teamInviteUI[i].Btntxt.LabText = Common.Utils.Lang("HAS_RECOMMEND")
                end
                self.teamInviteUI[i].Btn:SetGray(true)
                self.teamInviteUI[i].Btntxt:SetOutLineEnable(false)
                self.teamInviteUI[i].Btn:AddClick(function()

                end)
            end)
            --1 在线 2 离线
            if cData[i].status == 2 then
                self:SetGray(self.teamInviteUI[i])
            end
        end
    end
    self.panel.AchieveTpl.gameObject:SetActiveEx(false)

    self.panel.BtnBig_B:AddClick(function()
        local cTxt = self.panel.InputField.gameObject:GetComponent("InputField").text
        MgrMgr:GetMgr("ForbidTextMgr").RequestJudgeTextForbid(cTxt, function(checkInfo)
            local l_resultCode = checkInfo.result
            if l_resultCode ~= 0 then
                --判断服务器是否判断失败 如果失败什么都不发生
                if l_resultCode == ErrorCode.ERR_FAILED then
                    return
                end
                --含有屏蔽字则提示
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resultCode))
                return
            end
            --不含屏蔽字则搜索
            if self.panel ~= nil then
                self:SearchInviteMember(cTxt)
            end
        end)
    end)

    self.panel.InputField:OnInputFieldChange(function(txt)
        txt = StringEx.DeleteEmoji(txt)
        if txt == "" then
            self:ShowAll()
        end
        self.panel.InputField.Input.text = txt;
    end)
end

function TeamInviteCtrl:SearchInviteMember(cTxt)
    local cTb = DataMgr:GetData("TeamData").GetInviteInfoByIdOrName(cTxt)
    if table.maxn(cTb) > 0 then
        for z = 1, table.maxn(cTb) do
            self:ShowUIItem(cTb[z].role_uid, table.maxn(cTb))
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_PLAYER"))
    end
end

function TeamInviteCtrl:ExportItem(go)
    go.HeadDummy = go.ui.transform:Find("HeadDummy")
    go.HeadComp = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = go.HeadDummy,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
    
    go.Maptxt = MLuaClientHelper.GetOrCreateMLuaUICom(go.ui.transform:Find("Map"))
    go.Name = MLuaClientHelper.GetOrCreateMLuaUICom(go.ui.transform:Find("NameInfo/Name"))
    go.BiaoQian = go.ui.transform:Find("NameInfo/BiaoQian"):GetComponent("MLuaUICom")
    go.Lv   = MLuaClientHelper.GetOrCreateMLuaUICom(go.ui.transform:Find("Lv"))
    go.Job  = MLuaClientHelper.GetOrCreateMLuaUICom(go.ui.transform:Find("Job"))
    go.Btn  = go.ui.transform:Find("BtnSmall_B"):GetComponent("MLuaUICom")
    go.Btntxt = go.ui.transform:Find("BtnSmall_B/Text"):GetComponent("MLuaUICom")
    go.CurrenInvite = go.ui.transform:Find("CurrentInvite"):GetComponent("MLuaUICom")
end

-- todo 头像置灰可以用shader做
function TeamInviteCtrl:SetGray(go)
    for i = 0, go.HeadDummy.transform.childCount - 1 do
        local image = go.HeadDummy.transform:GetChild(i):GetComponent("Image")
        if image then
            image.color = Color.New(0, 0, 0)
        end
    end

    local BtnBg = go.Btn.transform:GetComponent("Image")
    if BtnBg then
        BtnBg.color = Color.New(0, 0, 0)
    end

    go.Btntxt:SetOutLineEnable(false)
    go.Btn:AddClick(function()
        -- do nothing
    end)
end

function TeamInviteCtrl:ShowUIItem(cId, count)
    for i = 1, table.maxn(self.teamInviteUI) do
        if self.teamInviteUI[i].cId == cId then
            self.teamInviteUI[i].ui.gameObject:SetActiveEx(true)
        else
            self.teamInviteUI[i].ui.gameObject:SetActiveEx(false)
        end
    end
end

function TeamInviteCtrl:ShowAll()
    for i = 1, table.maxn(self.teamInviteUI) do
        if self.teamInviteUI[i] ~= nil and self.teamInviteUI[i].ui ~= nil then
            self.teamInviteUI[i].ui.gameObject:SetActiveEx(true)
        end
    end
end

function TeamInviteCtrl:ClearUI()
    if self.teamInviteUI then
        for i = 1, table.maxn(self.teamInviteUI) do
            if self.teamInviteUI[i] ~= nil and self.teamInviteUI[i].ui ~= nil then
                MResLoader:DestroyObj(self.teamInviteUI[i].ui)
            end
            self.teamInviteUI[i] = {}
        end
    end
end

function TeamInviteCtrl:ClosePanel()
    UIMgr:DeActiveUI(UI.CtrlNames.TeamInvite)
end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return TeamInviteCtrl