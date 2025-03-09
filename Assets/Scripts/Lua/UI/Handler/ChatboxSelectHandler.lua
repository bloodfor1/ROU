--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/ChatboxSelectPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
ChatboxSelectHandler = class("ChatboxSelectHandler", super)
--lua class define end

--lua functions
function ChatboxSelectHandler:ctor()
    super.ctor(self, HandlerNames.ChatboxSelect, 0)
end --func end
--next--
function ChatboxSelectHandler:Init()
    self.panel = UI.ChatboxSelectPanel.Bind(self)
    super.Init(self)

    self._bubbleTemplatePool = nil
    self._id = nil
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function ChatboxSelectHandler:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ChatboxSelectHandler:OnActive()
    self:_refreshPage()
end --func end
--next--
function ChatboxSelectHandler:OnDeActive()
    local mgr = MgrMgr:GetMgr("DialogBgMgr")
    mgr.ClearAllNewFlag()
end --func end
--next--
function ChatboxSelectHandler:Update()

end --func end
--next--
function ChatboxSelectHandler:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnDialogBgUpdate, self._refreshPage)
end --func end
--next--
--lua functions end

--lua custom scripts

function ChatboxSelectHandler:OnHandlerSwitch()
    self:_refreshPage()
end

function ChatboxSelectHandler:_initConfig()
    self._chatBubbleTemplatePoolConfig = {
        TemplateClassName = "ChatBubbleItem",
        TemplatePrefab = self.panel.ChatBubbleItem.gameObject,
        ScrollRect = self.panel.loop_scroll.LoopScroll,
    }
end

function ChatboxSelectHandler:_initWidgets()
    self._bubbleTemplatePool = self:NewTemplatePool(self._chatBubbleTemplatePoolConfig)
    function _onSearchValueChange(value)
        self:_onSearchFieldChange(value)
    end

    self.panel.input_search:OnInputFieldChange(_onSearchValueChange)
    self.panel.btn_save:AddClickWithLuaSelf(self._onSave, self)
    self.panel.btn_clear_input:AddClickWithLuaSelf(self._onClearInputStr, self)
end

--- active时候触发的函数，创建所有数据之后，会选中数据
function ChatboxSelectHandler:_refreshPage()
    self.panel.input_search.Input.text = ""
    self:_showTemplatesByPattern(nil)
    local playerDataMgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentBubble = playerDataMgr.GetBubbleID()
    self._id = currentBubble
    local mgr = MgrMgr:GetMgr("DialogBgMgr")
    local targetIdx = mgr.GetDataIdxByID(currentBubble)
    local targetData = mgr.GetDataByID(currentBubble)
    self:_selectItem(targetData, targetIdx)
end

function ChatboxSelectHandler:_onSave()
    if nil == self._id then
        logError("[DialogBgHandler] no select id")
        return
    end

    local mgr = MgrMgr:GetMgr("DialogBgMgr")
    mgr.ReqChangeDialogBg(self._id)
end

--- 刷新显示所有icon
function ChatboxSelectHandler:_showAllBubbles()
    self:_showTemplatesByPattern(nil)
end

--- 根据匹配模式刷新显示列表
function ChatboxSelectHandler:_showTemplatesByPattern(pattern)
    local mgr = MgrMgr:GetMgr("DialogBgMgr")
    local frameList = mgr.GetBgByPattern(pattern)
    local showEmpty = 0 >= #frameList
    self.panel.widget_empty:SetActiveEx(showEmpty)
    ---@type DialogBgShowDataWrap[]
    local wrapDataList = {}
    for i = 1, #frameList do
        ---@type DialogBgShowDataWrap
        local wrapData = {
            showData = frameList[i],
            onSelected = self._selectItem,
            onSelectedSelf = self,
        }

        table.insert(wrapDataList, wrapData)
    end

    self._bubbleTemplatePool:ShowTemplates({ Datas = wrapDataList })
end

function ChatboxSelectHandler:_onClearInputStr()
    self.panel.input_search.Input.text = ""
end

--- 选中目标
---@param targetData DialogBgShowData
function ChatboxSelectHandler:_selectItem(targetData, idx)
    if nil == targetData then
        logError("[DialogBgHandler] invalid data")
        return
    end    

    self._id = targetData.config.ID
    self._bubbleTemplatePool:SelectTemplate(idx)
    self:_refreshSelectZone(targetData)
    self.panel.btn_save.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.Active == targetData.state)
    self.panel.txt_in_use.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.InUse == targetData.state)
    self.panel.txt_in_active.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.InActive == targetData.state)
end

--- 刷新右边区域, 参数为选中框的ID，不是使用框的ID
---@param targetData DialogBgShowData
function ChatboxSelectHandler:_refreshSelectZone(targetData)
    if nil == targetData then
        logError("[DialogBgHandler] invalid param")
        return
    end

    self.panel.txt_bubble_name.LabText = targetData.config.Name
    self.panel.txt_detail.LabText = targetData.config.Description
    self.panel.img_bubble:SetSpriteAsync(targetData.config.Atlas, targetData.config.Photo, nil, false)
    self.panel.txt_time:SetActiveEx(targetData.timeLimited)
    local l_timeTable = Common.TimeMgr.GetTimeTable(Common.TimeMgr.GetLocalTimestamp(targetData.expireTime))
    local str = Lang("DATE_YY_MM_DD_H_M", l_timeTable.year, l_timeTable.month, l_timeTable.day, l_timeTable.hour, l_timeTable.min)
    self.panel.txt_time.LabText = Common.Utils.Lang("C_EXPIRE_TIME", str)
    local targetColor = CommonUI.Color.Hex2Color(targetData.config.Color)
    self.panel.txt_chat.LabColor = targetColor
    self.panel.TitleCondition:SetActiveEx(targetData.config.Description ~= '')
end

--- 如果搜索框输入了什么东西，这个时候要刷新显示列表
function ChatboxSelectHandler:_onSearchFieldChange(value)
    self:_showTemplatesByPattern(value)
end

--lua custom scripts end
return ChatboxSelectHandler