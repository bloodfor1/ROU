--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/HeadframeSelectPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
HeadframeSelectHandler = class("HeadframeSelectHandler", super)
--lua class define end

--lua functions
function HeadframeSelectHandler:ctor()
    super.ctor(self, HandlerNames.HeadframeSelect, 0)
end --func end
--next--
function HeadframeSelectHandler:Init()
    self.panel = UI.HeadframeSelectPanel.Bind(self)
    super.Init(self)

    self._frameTemplatePool = nil
    self._id = nil
    self._headIcon = nil
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function HeadframeSelectHandler:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function HeadframeSelectHandler:OnActive()
    self:_refreshPage()
end --func end
--next--
function HeadframeSelectHandler:OnDeActive()
    local mgr = MgrMgr:GetMgr("HeadFrameMgr")
    mgr.ClearAllNewFlag()
end --func end
--next--
function HeadframeSelectHandler:Update()

end --func end
--next--
function HeadframeSelectHandler:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnIconFrameUpdate, self._refreshPage)
end --func end
--next--
--lua functions end

--lua custom scripts

function HeadframeSelectHandler:OnHandlerSwitch()
    self:_refreshPage()
end

function HeadframeSelectHandler:_initConfig()
    self._frameTemplatePoolConfig = {
        TemplateClassName = "HeadframeSelectItem",
        TemplatePrefab = self.panel.HeadframeSelectItem.gameObject,
        ScrollRect = self.panel.scroll_view_item.LoopScroll,
    }
end

function HeadframeSelectHandler:_initWidgets()
    self._frameTemplatePool = self:NewTemplatePool(self._frameTemplatePoolConfig)
    function _onSearchValueChange(value)
        self:_onSearchFieldChange(value)
    end

    self.panel.SearchInput:OnInputFieldChange(_onSearchValueChange)
    self.panel.btn_use:AddClickWithLuaSelf(self._onSave, self)
    self.panel.btn_clear_input:AddClickWithLuaSelf(self._onClearInputStr, self)
    self._headIcon = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.panel.dummy_icon.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end

--- active时候触发的函数，创建所有数据之后，会选中数据
function HeadframeSelectHandler:_refreshPage()
    self.panel.SearchInput.Input.text = ""
    self:_showTemplatesByPattern(nil)
    local playerDataMgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentFrame = playerDataMgr.GetIconFrame()
    self._id = currentFrame
    local mgr = MgrMgr:GetMgr("HeadFrameMgr")
    local targetIdx = mgr.GetDataIdxByID(currentFrame)
    local targetData = mgr.GetDataByID(currentFrame)
    self:_selectItem(targetData, targetIdx)
end

function HeadframeSelectHandler:_onSave()
    if nil == self._id then
        logError("[FrameHandler] no select id")
        return
    end

    local mgr = MgrMgr:GetMgr("HeadFrameMgr")
    mgr.ReqChangeFrame(self._id)
end

--- 根据匹配模式刷新显示列表
function HeadframeSelectHandler:_showTemplatesByPattern(pattern)
    local mgr = MgrMgr:GetMgr("HeadFrameMgr")
    local frameList = mgr.GetFrameByPattern(pattern)
    local showEmpty = 0 >= #frameList
    self.panel.widget_empty:SetActiveEx(showEmpty)
    ---@type FrameShowDataWrap[]
    local wrapDataList = {}
    for i = 1, #frameList do
        ---@type FrameShowDataWrap
        local wrapData = {
            showData = frameList[i],
            onHeadFrameSelected = self._selectItem,
            onSelectedSelf = self,
        }

        table.insert(wrapDataList, wrapData)
    end

    self._frameTemplatePool:ShowTemplates({ Datas = wrapDataList })
end

function HeadframeSelectHandler:_onClearInputStr()
    self.panel.SearchInput.Input.text = ""
end

--- 选中目标，这里传两个参数，一个是数据，一个是显示编号
--- 因为有可能会有筛选，有筛选的时候要保证点击触发的回调拿到的参数是没有问题的
--- 显示编号是template回调触发的，初始化的时候因为是不会有筛选条件的，所以直接获取全量编号
---@param targetData FrameShowData
function HeadframeSelectHandler:_selectItem(targetData, idx)
    if nil == targetData then
        logError("[FrameHandler] invalid data")
        return
    end

    self._id = targetData.config.ID
    self._frameTemplatePool:SelectTemplate(idx)
    self:_refreshSelectZone(targetData)
    self.panel.btn_use.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.Active == targetData.state)
    self.panel.obj_in_use.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.InUse == targetData.state)
    self.panel.obj_unavailible.gameObject:SetActiveEx(GameEnum.ECustomItemActiveType.InActive == targetData.state)
end

--- 刷新右边区域, 参数为选中框的ID，不是使用框的ID
---@param targetData FrameShowData
function HeadframeSelectHandler:_refreshSelectZone(targetData)
    if nil == targetData then
        logError("[FrameHandler] invalid param")
        return
    end
    
    local id = targetData.config.ID
    self.panel.txt_title.LabText = targetData.config.Name
    self.panel.txt_detail_desc.LabText = targetData.config.Description
    self.panel.txt_time:SetActiveEx(targetData.timeLimited)
    local l_timeTable = Common.TimeMgr.GetTimeTable(Common.TimeMgr.GetLocalTimestamp(targetData.expireTime))
    local str = Lang("DATE_YY_MM_DD_H_M", l_timeTable.year, l_timeTable.month, l_timeTable.day, l_timeTable.hour, l_timeTable.min)
    self.panel.txt_time.LabText = Common.Utils.Lang("C_EXPIRE_TIME", str)
    self.panel.TitleCondition:SetActiveEx(targetData.config.Description ~= '')

    ---@type HeadTemplateParam
    local param = {}
    param.IsPlayerSelf = true
    param.FrameID = id
    self._headIcon:SetData(param)
end

--- 如果搜索框输入了什么东西，这个时候要刷新显示列表
function HeadframeSelectHandler:_onSearchFieldChange(value)
    self:_showTemplatesByPattern(value)
end

--lua custom scripts end
return HeadframeSelectHandler