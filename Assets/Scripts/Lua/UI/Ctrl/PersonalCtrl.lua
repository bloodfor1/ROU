--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PersonalPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PersonalCtrl = class("PersonalCtrl", super)
--lua class define end

--lua functions
function PersonalCtrl:ctor()
    super.ctor(self, CtrlNames.Personal, UILayer.Function, nil, ActiveType.Exclusive)
    local sysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    --- 系统开放标记和handler配置映射，key是成员变量名
    ---@type table<string, HandlerConfig>
    self.C_TAG_HANDLER_CONFIG_MAP = {
        {
            systemID = sysMgr.eSystemId.HeadBook,
            handlerName = HandlerNames.HeadSelect,
            handlerTitle = Lang("PERSONAL_TAG_HEAD"),
            ctrlName = "Personal",
            selectSpName = "UI_Personal_Icon_Tab_Head_01.png",
            unSelectSpName = "UI_Personal_Icon_Tab_Head_01.png",
        },
        {
            systemID = sysMgr.eSystemId.TitleBook,
            handlerName = HandlerNames.Titlesticker,
            handlerTitle = Lang("PERSONAL_TAG_TITLE"),
            ctrlName = "Personal",
            selectSpName = "UI_Personal_Icon_Tab_Title_01.png",
            unSelectSpName = "UI_Personal_Icon_Tab_Title_01.png",
        },
        {
            systemID = sysMgr.eSystemId.IconFrame,
            handlerName = HandlerNames.HeadframeSelect,
            handlerTitle = Lang("C_PERSON_TITLE_FRAME"),
            ctrlName = "Personal",
            selectSpName = "UI_Personal_Icon_Tab_Headframe_01.png",
            unSelectSpName = "UI_Personal_Icon_Tab_Headframe_01.png",
        },
        {
            systemID = sysMgr.eSystemId.DialogBg,
            handlerName = HandlerNames.ChatboxSelect,
            handlerTitle = Lang("C_PERSON_TITLE_CHAT_BUBBLE"),
            ctrlName = "Personal",
            selectSpName = "UI_Personal_Icon_Tab_Chatbox_01.png",
            unSelectSpName = "UI_Personal_Icon_Tab_Chatbox_01.png",
        },
        {
            systemID = sysMgr.eSystemId.ChatTag,
            handlerName = HandlerNames.LabelSelect,
            handlerTitle = Lang("C_PERSON_CHAT_TAG"),
            ctrlName = "Personal",
            selectSpName = "UI_Personal_Icon_Tab_Label_01.png",
            unSelectSpName = "UI_Personal_Icon_Tab_Label_01.png",
        },
    }
end --func end
--next--
function PersonalCtrl:Init()
    self.HeadIsOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.HeadBook)
    self.TitleIsOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TitleBook)
    self.panel = UI.PersonalPanel.Bind(self)
    super.Init(self)
    self.panel.BtnClose:AddClickWithLuaSelf(self.Close, self)
end --func end
--next--
function PersonalCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function PersonalCtrl:OnActive()
    if self.uiPanelData then
        if self.uiPanelData.photoId and self.HeadIsOpen then
            self:SelectOneHandler(HandlerNames.HeadSelect)
        elseif self.uiPanelData.titleId and self.TitleIsOpen then
            self:SelectOneHandler(HandlerNames.Titlesticker)
        end
    end
end --func end
--next--
function PersonalCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function PersonalCtrl:Update()
    self.curHandler:Update()
end --func end
--next--
function PersonalCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts

function PersonalCtrl:OnHandlerSwitch(handlerName)
    if nil == self.curHandler.OnHandlerSwitch then
        return
    end

    self.curHandler:OnHandlerSwitch()
end

function PersonalCtrl:Close()
    UIMgr:DeActiveUI(UI.CtrlNames.Personal)
end

function PersonalCtrl:SetupHandlers()
    local l_handlerTb = {}
    local sysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    for i = 1, #self.C_TAG_HANDLER_CONFIG_MAP do
        local config = self.C_TAG_HANDLER_CONFIG_MAP[i]
        if sysMgr.IsSystemOpen(config.systemID) then
            local singleRunningConfig = {
                config.handlerName,
                config.handlerTitle,
                config.ctrlName,
                config.selectSpName,
                config.unSelectSpName
            }

            table.insert(l_handlerTb, singleRunningConfig)
        end
    end

    self:InitHandler(l_handlerTb, self.panel.ToggleTpl)

    -- 红点处理
    if self.TitleIsOpen then
        self:NewRedSign({
            Key = eRedSignKey.TitleTag,
            ClickTogEx = self:GetHandlerTogExByName(HandlerNames.Titlesticker),
        })
    end
end
--lua custom scripts end

return PersonalCtrl