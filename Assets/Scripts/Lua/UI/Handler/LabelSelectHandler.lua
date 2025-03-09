--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/LabelSelectPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
LabelSelectHandler = class("LabelSelectHandler", super)
--lua class define end

--lua functions
function LabelSelectHandler:ctor()
    super.ctor(self, HandlerNames.LabelSelect, 0)
end --func end
--next--
function LabelSelectHandler:Init()
    self.panel = UI.LabelSelectPanel.Bind(self)
    super.Init(self)

    self._id = nil
    self._tagTemplatePoolConfig = nil
    self._tagTemplatePool = nil
    self._headIcon = nil
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function LabelSelectHandler:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function LabelSelectHandler:OnActive()
    self:_refreshPage()
end --func end
--next--
function LabelSelectHandler:OnDeActive()
    -- do nothing
end --func end
--next--
function LabelSelectHandler:Update()
    -- do nothing
end --func end
--next--

function LabelSelectHandler:OnHandlerSwitch()
    self:_refreshPage()
end

function LabelSelectHandler:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnChatLabelUpdate, self._refreshPage)
end --func end
--next--
--lua functions end

--lua custom scripts
function LabelSelectHandler:_initConfig()
    self._tagTemplatePoolConfig = {
        TemplateClassName = "ChatTagSelectItem",
        TemplatePrefab = self.panel.ChatTagSelectItem.gameObject,
        ScrollRect = self.panel.scroll_view.LoopScroll,
    }
end

function LabelSelectHandler:_initWidgets()
    self._tagTemplatePool = self:NewTemplatePool(self._tagTemplatePoolConfig)
    function _onSearchValueChange(value)
        self:_onSearchValueChange(value)
    end

    self.panel.search_input:OnInputFieldChange(_onSearchValueChange)
    self.panel.btn_save:AddClickWithLuaSelf(self._onSave, self)
    self.panel.btn_clear_input:AddClickWithLuaSelf(self._onClearInputStr, self)
    self.panel.btn_check_lv.Listener:SetActionClick(self._showOtherLv, self)
    self._headIcon = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.panel.widget_head_icon.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end

function LabelSelectHandler:_refreshPage()
    self.panel.search_input.Input.text = ""
    self:_showTemplatesByPattern(nil)
    local playerDataMgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentTag = playerDataMgr.GetChatTagID()
    self._id = currentTag
    local mgr = MgrMgr:GetMgr("ChatTagMgr")
    local targetIdx = mgr.GetDataIdxByID(currentTag)
    local targetData = mgr.GetDataByID(currentTag)
    self:_selectItem(targetData, targetIdx)
end

function LabelSelectHandler:_onSave()
    if nil == self._id then
        logError("[ChatTagHandler] invalid param")
        return
    end

    local mgr = MgrMgr:GetMgr("ChatTagMgr")
    mgr.ReqChangeTag(self._id)
end

function LabelSelectHandler:_showTemplatesByPattern(pattern)
    local mgr = MgrMgr:GetMgr("ChatTagMgr")
    local targetList = mgr.GetTagListByPattern(pattern)
    local showEmpty = 0 >= #targetList
    self.panel.widget_empty:SetActiveEx(showEmpty)
    ---@type ChatTagDataWrap[]
    local dataWrapList = {}
    for i = 1, #targetList do
        local singleData = targetList[i]
        local singleDataWrap = self:_createDataWrap(singleData)
        table.insert(dataWrapList, singleDataWrap)
    end

    self._tagTemplatePool:ShowTemplates({ Datas = dataWrapList })
end

--- 用来包装一层数据，主要是用来包装触发点击的回调
---@param data ChatTagData
function LabelSelectHandler:_createDataWrap(data)
    if nil == data then
        logError("[ChatTagHandler] invalid param")
        return nil
    end

    ---@type ChatTagDataWrap
    local ret = {
        data = data,
        onClick = self._selectItem,
        onClickSelf = self
    }

    return ret
end

--- 刷新右侧选中区域，这个时候会做几个事情
--- 如果参数为false不会刷新角色头像框和气泡框
--- 如果参数为true这个时候会刷新角色头像框和气泡框
--- 聊天标签相关的数据一定会刷新
---@param resetPlayerData boolean
---@param targetData ChatTagData
function LabelSelectHandler:_refreshSelectZone(targetData, resetPlayerData)
    if nil == self._id then
        logError("[ChatTagHandler] invalid param")
        return
    end

    if nil == targetData then
        logError("[ChatTagMgr] invalid param")
        return
    end

    self.panel.txt_title.LabText = targetData.config.Name
    self.panel.txt_detail.LabText = targetData.config.Desc
    self.panel.TitleCondition:SetActiveEx(targetData.config.Desc ~= '')
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(self._id, self.panel.img_label_icon,
            self.panel.img_tag_bg, self.panel.txt_tag_lv)
    local configList = MgrMgr:GetMgr("ChatTagMgr").GetTagPreviewList(targetData.config.Type)
    self.panel.btn_check_other_lv:SetActiveEx(nil ~= configList)
    if not resetPlayerData then
        return
    end

    self.panel.txt_player_name.LabText = tostring(MPlayerInfo.Name)
    ---@type HeadTemplateParam
    local param = {}
    param.IsPlayerSelf = true
    self._headIcon:SetData(param)
    local playerCustomDataMgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentChatBubble = playerCustomDataMgr.GetBubbleID()
    local chatBubbleConfigData = MgrMgr:GetMgr("DialogBgMgr").GetDataByID(currentChatBubble)
    if nil == chatBubbleConfigData then
        logError("[LabelSelectHandler] invalid chat bubble id: " .. tostring(currentChatBubble))
        return
    end

    self.panel.img_chat_bg:SetSpriteAsync(chatBubbleConfigData.config.Atlas, chatBubbleConfigData.config.Photo, nil, false)
    -- onSpLoaded()
    local targetColor = CommonUI.Color.Hex2Color(chatBubbleConfigData.config.Color)
    self.panel.txt_chat_content.LabColor = targetColor
end

function LabelSelectHandler:_onClearInputStr()
    self.panel.search_input.Input.text = ""
end

function LabelSelectHandler:_onSearchValueChange(value)
    self:_showTemplatesByPattern(value)
end

---@param targetData ChatTagData
function LabelSelectHandler:_selectItem(targetData, idx)
    if nil == targetData then
        logError("[ChatTagHandler] invalid data")
        return
    end

    self._id = targetData.config.ID
    self._tagTemplatePool:SelectTemplate(idx)
    self:_refreshSelectZone(targetData, true)
    self.panel.btn_save.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.Active == targetData.state)
    self.panel.widget_inuse.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.InUse == targetData.state)
    self.panel.txt_inactive.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.InActive == targetData.state)
end

function LabelSelectHandler:_showOtherLv(go, eventData)
    local data = MgrMgr:GetMgr("ChatTagMgr").GetDataByID(self._id)
    if nil == data then
        return
    end

    local configList = MgrMgr:GetMgr("ChatTagMgr").GetTagPreviewList(data.config.Type)
    local param = {
        Position = self.panel.btn_check_lv.transform.position,
        DataList = configList
    }

    UIMgr:ActiveUI(UI.CtrlNames.ChatTagPreviewPanel, param)
end

--lua custom scripts end
return LabelSelectHandler