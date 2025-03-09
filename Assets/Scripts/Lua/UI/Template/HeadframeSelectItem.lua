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
--lua fields end

--lua class define
---@class HeadframeSelectItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field img_time_limit MoonClient.MLuaUICom
---@field img_tag_in_use MoonClient.MLuaUICom
---@field img_selected MoonClient.MLuaUICom
---@field img_new MoonClient.MLuaUICom
---@field img_main_icon_bottom MoonClient.MLuaUICom
---@field img_main_icon MoonClient.MLuaUICom
---@field img_bg_bottom MoonClient.MLuaUICom
---@field img_bg MoonClient.MLuaUICom

---@class HeadframeSelectItem : BaseUITemplate
---@field Parameter HeadframeSelectItemParameter

HeadframeSelectItem = class("HeadframeSelectItem", super)
--lua class define end

--lua functions
function HeadframeSelectItem:Init()
    super.Init(self)
    ---@type FrameShowData
    self._data = nil
    self._onClick = nil
    self._onClickSelf = nil
    self.Parameter.img_bg_bottom:AddClickWithLuaSelf(self._tryInvokeCallBack, self)
    self:_initPrefabState()
end --func end
--next--
function HeadframeSelectItem:BindEvents()
    -- do nothing
end --func end
--next--
function HeadframeSelectItem:OnDestroy()
    self._data = nil
    self._onClick = nil
    self._onClickSelf = nil
    self.Parameter.img_bg_bottom:Clear()
end --func end
--next--
function HeadframeSelectItem:OnDeActive()
    -- do nothing
end --func end
--next--
function HeadframeSelectItem:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function HeadframeSelectItem:_initPrefabState()
    self.Parameter.img_selected.gameObject:SetActiveEx(false)
    self.Parameter.img_main_icon.gameObject:SetActiveEx(true)
end

---@param data FrameShowDataWrap
function HeadframeSelectItem:_onSetData(data)
    if nil == data then
        logError("[HeadFrame] invalid param")
        return
    end

    self._onClick = data.onHeadFrameSelected
    self._onClickSelf = data.onSelectedSelf
    self._data = data.showData
    self:_setSp(data.showData)
    self:_setState(data.showData)
end

---@param data FrameShowData
function HeadframeSelectItem:_setState(data)
    if nil == data then
        logError("[HeadFrame] invalid param")
        return
    end

    local ECustomItemType = GameEnum.ECustomItemActiveType
    self.Parameter.img_tag_in_use.gameObject:SetActiveEx(ECustomItemType.InUse == data.state)
    self.Parameter.img_new.gameObject:SetActiveEx(data.newIconFrame)
    self.Parameter.img_time_limit.gameObject:SetActiveEx(data.timeLimited)
    self.Parameter.img_bg.gameObject:SetActiveEx(ECustomItemType.InActive == data.state)
end

---@param data FrameShowData
function HeadframeSelectItem:_setSp(data)
    if nil == data then
        logError("[HeadFrame] invalid param")
        return
    end

    local config = data.config
    if nil == config then
        logError("[HeadFrame] invalid config")
        return
    end

    self.Parameter.img_main_icon:SetSpriteAsync(config.Atlas, config.Photo, nil, false)
    self.Parameter.img_main_icon_bottom:SetSpriteAsync(config.Atlas, config.FrameBot, nil, false)
end

function HeadframeSelectItem:OnSelect()
    self.Parameter.img_selected.gameObject:SetActiveEx(true)
    if nil == self._data then
        logError("[FrameTemplate] invalid template state")
        return
    end

    local mgr = MgrMgr:GetMgr("HeadFrameMgr")
    mgr.SetNewState(self._data.config.ID, false)
    self.Parameter.img_new.gameObject:SetActiveEx(false)
end

function HeadframeSelectItem:OnDeselect()
    self.Parameter.img_selected.gameObject:SetActiveEx(false)
end

--- 选中之后触发回调
function HeadframeSelectItem:_tryInvokeCallBack()
    if nil == self._onClick then
        return
    end

    if nil == self._onClickSelf then
        self._onClick(self._data, self.ShowIndex)
        return
    end

    self._onClick(self._onClickSelf, self._data, self.ShowIndex)
end
--lua custom scripts end
return HeadframeSelectItem