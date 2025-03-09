--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/HeadSelectPanel"
require "UI/Template/HeadSelectItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
HeadSelectHandler = class("HeadSelectHandler", super)
--lua class define end

--lua functions
function HeadSelectHandler:ctor()
    super.ctor(self, HandlerNames.HeadSelect, 0)
end --func end
--next--
function HeadSelectHandler:Init()
    self.panel = UI.HeadSelectPanel.Bind(self)
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("HeadSelectMgr")
    self.info = self.Mgr.TempHeadInfo
    self.curSelectID = nil
    self.curSelectUID = nil
    self.HeadSelectItems = self:NewTemplatePool(
            {
                ScrollRect = self.panel.ScrollView.LoopScroll,
                UITemplateClass = UITemplate.HeadSelectItemTemplate,
                TemplatePrefab = self.panel.HeadSelectItemTemplate.LuaUIGroup.gameObject,
                SetCountPerFrame = 2,
                CreateObjPerFrame = 5,
            })
end --func end
--next--
function HeadSelectHandler:Uninit()
    self.head2d = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function HeadSelectHandler:OnActive()
    self:OnInitialize()
    if self.ctrlRef.uiPanelData and self.ctrlRef.uiPanelData.photoId then
        self:SelectPhoto(self.ctrlRef.uiPanelData.photoId)
    end
end --func end
--next--
function HeadSelectHandler:OnDeActive()
    if self.panel then
        self:UnInitialize()
    end
end --func end
--next--
function HeadSelectHandler:Update()
    if nil == self.HeadSelectItems then
        return
    end

    self.HeadSelectItems:OnUpdate()
end --func end

--next--
function HeadSelectHandler:BindEvents()
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.ON_SELECT_HEAD_ITEM, function(self, enough)
        self.curSelectID = self.Mgr.CurSelectedHead.id
        self.curSelectUID = self.Mgr.CurSelectedHead.uid
        self.enough = enough
        self:InitDisplayPanel(self.curSelectID)
    end)
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.UPDATE_HEAD_SELF, function(self, uid)
        if uid == MPlayerInfo.UID then
            self.enough = false
            self:InitDisplayPanel(MPlayerInfo.HeadID)
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function HeadSelectHandler:OnInitialize()
    self.Mgr.InitMgrNetData()
    self.panel.useButton:AddClick(function()
        if self.enough then
            if self.curSelectUID == 0 and MPlayerInfo.HeadID > 0 then
                self.Mgr.SendWearHeadPortraitReq(MPlayerInfo.HeadID, self.Mgr.CurUID)
                return
            end
            if self.curSelectID ~= 0 and self.curSelectUID ~= 0 then
                self.Mgr.SendWearHeadPortraitReq(self.curSelectID, self.curSelectUID)
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("HEAD_NOT_ENOUGH"))
        end
    end)

    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.panel.myHead.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    self.Mgr.CurSelectedHead = {}
    self.Mgr.CurSelectedHead.id = MPlayerInfo.HeadID
    self.Mgr.CurSelectedHead.uid = self.Mgr.CurUID
    self.Mgr.CurSelectedHead.selected = nil

    local param = {}
    for i = 1, #self.info do
        local singleData = self.info[i]
        singleData.OnSelected = self._onHeadIconSelectedCb
        singleData.OnSelectedSelf = self
        table.insert(param, singleData)
    end

    local showEmpty = 0 >= #param
    self.panel.widget_empty:SetActiveEx(showEmpty)
    if #self.info then
        self.HeadSelectItems:ShowTemplates({ Datas = param })
    end

    self.enough = false
    self:InitDisplayPanel(MPlayerInfo.HeadID)
    self:_onHeadIconSelectedCb(self.Mgr.CurSelectedHead.id)
end

function HeadSelectHandler:SelectPhoto(photoId)
    self:InitDisplayPanel(photoId)
    self:SelectTemplateById(photoId, true)
end

function HeadSelectHandler:InitDisplayPanel(id)
    if 0 == id then
        ---@type HeadTemplateParam
        local param = {}
        param.EquipData = self.Mgr.GetDefaultEquipData()
        self.head2d:SetData(param)
        self.panel.Tittle.LabText = Common.Utils.Lang("HEAD_SELECT_DEFALUTE")
        self.panel.FromTips.gameObject:SetActiveEx(false)
        self.panel.TitleCondition:SetActiveEx(false)
    else
        ---@type HeadTemplateParam
        local param = {}
        param.EquipData = self.Mgr.GetDefaultEquipData(id)
        self.head2d:SetData(param)
        local l_headInfo = TableUtil.GetProfilePhotoTable().GetRowByProfilePhotoID(id)
        local l_name = ""
        local l_des = ""
        if l_headInfo then
            l_name = l_headInfo.ProfilePhotoName
            l_des = l_headInfo.Description
        end

        self.panel.FromTips.LabText = l_des        
        self.panel.Tittle.LabText = l_name
        -- 如果没有详情信息，不显示详情title和详情字体本身
        local l_isHasTip = l_des ~= ''
        self.panel.FromTips:SetActiveEx(l_isHasTip)
        self.panel.TitleCondition:SetActiveEx(l_isHasTip)

    end

    local l_isUsing = id == MPlayerInfo.HeadID
    self.panel.Inuse:SetActiveEx(l_isUsing)
    self.panel.useButton:SetActiveEx(not l_isUsing and self.enough)
    self.panel.Weijihuo:SetActiveEx(not l_isUsing and not self.enough)
end

function HeadSelectHandler:UnInitialize()
    self.HeadSelectItems = nil
end

--- 点击之后收到的回调
function HeadSelectHandler:_onHeadIconSelectedCb(id)
    self:SelectTemplateById(id)
end

function HeadSelectHandler:SelectTemplateById(id, needScrollTo)
    if 0 == id then
        for i = 1, #self.info do
            if self.info[i].tableInfo == "default" then
                self.HeadSelectItems:SelectTemplate(i)
                if needScrollTo then
                    self.HeadSelectItems:ScrollToCell(i, 80000)
                end
                return
            end
        end
    end

    for i = 1, #self.info do
        if self.info[i].tableInfo.ProfilePhotoID == id then
            self.HeadSelectItems:SelectTemplate(i)
            if needScrollTo then
                self.HeadSelectItems:ScrollToCell(i, 80000)
            end
            return
        end
    end
end

--lua custom scripts end
return HeadSelectHandler