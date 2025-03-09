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
---@class ChatBubbleItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field img_time_limited MoonClient.MLuaUICom
---@field img_selected MoonClient.MLuaUICom
---@field img_new_tag MoonClient.MLuaUICom
---@field img_in_use MoonClient.MLuaUICom
---@field img_icon MoonClient.MLuaUICom
---@field img_bg_mask MoonClient.MLuaUICom
---@field img_bg MoonClient.MLuaUICom

---@class ChatBubbleItem : BaseUITemplate
---@field Parameter ChatBubbleItemParameter

ChatBubbleItem = class("ChatBubbleItem", super)
--lua class define end

--lua functions
function ChatBubbleItem:Init()
    super.Init(self)

    ---@type DialogBgShowData
    self._data = nil
    self._onClick = nil
    self._onClickSelf = nil
    self.Parameter.img_bg:AddClickWithLuaSelf(self._tryInvokeCallBack, self)
    self:_initPrefabState()
end --func end
--next--
function ChatBubbleItem:BindEvents()
    -- do nothing
end --func end
--next--
function ChatBubbleItem:OnDestroy()
    self._data = nil
    self._onClick = nil
    self._onClickSelf = nil
    self.Parameter.img_bg:Clear()
end --func end
--next--
function ChatBubbleItem:OnDeActive()

end --func end
--next--
function ChatBubbleItem:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts

function ChatBubbleItem:_initPrefabState()
    self.Parameter.img_selected.gameObject:SetActiveEx(false)
    self.Parameter.img_icon.gameObject:SetActiveEx(true)
end

---@param data DialogBgShowDataWrap
function ChatBubbleItem:_onSetData(data)
    self._onClick = data.onSelected
    self._onClickSelf = data.onSelectedSelf
    self._data = data.showData
    self:_setSp(data.showData)
    self:_setState(data.showData)
end

---@param data DialogBgShowData
function ChatBubbleItem:_setState(data)
    if nil == data then
        logError("[ChatBubble] invalid param")
        return
    end

    local ECustomItemType = GameEnum.ECustomItemActiveType
    self.Parameter.img_in_use.gameObject:SetActiveEx(ECustomItemType.InUse == data.state)
    self.Parameter.img_new_tag.gameObject:SetActiveEx(data.newTag)
    self.Parameter.img_time_limited.gameObject:SetActiveEx(data.timeLimited)
    self.Parameter.img_bg_mask.gameObject:SetActiveEx(ECustomItemType.InActive == data.state)
end

---@param data DialogBgShowData
function ChatBubbleItem:_setSp(data)
    if nil == data then
        logError("[ChatBubble] invalid param")
        return
    end

    local config = data.config
    if nil == config then
        logError("[ChatBubble] invalid config")
        return
    end

    self.Parameter.img_icon:SetSpriteAsync(config.Atlas, config.Photo, nil, false)
end

function ChatBubbleItem:OnSelect()
    self.Parameter.img_selected.gameObject:SetActiveEx(true)
    if nil == self._data then
        logError("[ChatBubble] invalid template state")
        return
    end

    local mgr = MgrMgr:GetMgr("DialogBgMgr")
    mgr.SetNewState(self._data.config.ID, false)
    self.Parameter.img_new_tag.gameObject:SetActiveEx(false)
end

function ChatBubbleItem:OnDeselect()
    self.Parameter.img_selected.gameObject:SetActiveEx(false)
end

function ChatBubbleItem:_tryInvokeCallBack()
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
return ChatBubbleItem