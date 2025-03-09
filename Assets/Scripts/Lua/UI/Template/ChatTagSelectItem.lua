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
---@class ChatTagSelectItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field img_time_limited MoonClient.MLuaUICom
---@field img_tag_new MoonClient.MLuaUICom
---@field img_selected MoonClient.MLuaUICom
---@field img_main_icon MoonClient.MLuaUICom
---@field img_lock MoonClient.MLuaUICom
---@field img_in_use MoonClient.MLuaUICom
---@field img_default MoonClient.MLuaUICom
---@field img_btn_click MoonClient.MLuaUICom

---@class ChatTagSelectItem : BaseUITemplate
---@field Parameter ChatTagSelectItemParameter

ChatTagSelectItem = class("ChatTagSelectItem", super)
--lua class define end

--lua functions
function ChatTagSelectItem:Init()
    super.Init(self)
    ---@type ChatTagData
    self._data = nil
    self._onClick = nil
    self._onClickSelf = nil
    self.Parameter.img_btn_click:AddClickWithLuaSelf(self._tryInvokeCallBack, self)
    self:_initState()
end --func end
--next--
function ChatTagSelectItem:BindEvents()
    -- do nothing
end --func end
--next--
function ChatTagSelectItem:OnDestroy()
    self._data = nil
    self._onClick = nil
    self._onClickSelf = nil
    self.Parameter.img_btn_click:Clear()
end --func end
--next--
function ChatTagSelectItem:OnDeActive()


end --func end
--next--
function ChatTagSelectItem:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts

function ChatTagSelectItem:OnSelect()
    self.Parameter.img_selected.gameObject:SetActive(true)
end

function ChatTagSelectItem:OnDeselect()
    self.Parameter.img_selected.gameObject:SetActive(false)
end

function ChatTagSelectItem:_initState()
    self.Parameter.img_tag_new.gameObject:SetActive(false)
    self.Parameter.img_time_limited.gameObject:SetActive(false)
    self.Parameter.img_selected.gameObject:SetActive(false)
    self.Parameter.img_main_icon.gameObject:SetActive(true)
    self.Parameter.img_default.gameObject:SetActive(true)
end

---@param dataParam ChatTagDataWrap
function ChatTagSelectItem:_onSetData(dataParam)
    if nil == dataParam then
        logError("[ChatTagItem] invalid param")
        return
    end

    self._data = dataParam.data
    self._onClick = dataParam.onClick
    self._onClickSelf = dataParam.onClickSelf
    self:_showSP(dataParam.data)
    self:_showState(dataParam.data)
end

--- 这里会有一个默认值，代码中认为这个默认值是不显示的，为0
---@param data ChatTagData
function ChatTagSelectItem:_showSP(data)
    if nil == data then
        logError("[ChatTagItem] invalid param")
        return
    end

    if nil == data.config then
        return
    end

    local defaultConfig = "" == data.config.Icon
    self.Parameter.img_default.gameObject:SetActive(defaultConfig)
    self.Parameter.img_main_icon.gameObject:SetActive(not defaultConfig)
    local config = data.config
    self.Parameter.img_main_icon:SetSpriteAsync(config.Atlas, config.Icon, nil, false)
end

---@param data ChatTagData
function ChatTagSelectItem:_showState(data)
    if nil == data then
        logError("[ChatTagItem] invalid param")
        return
    end

    local E_CUSTOM_STATE = GameEnum.ECustomItemActiveType
    self.Parameter.img_in_use.gameObject:SetActive(E_CUSTOM_STATE.InUse == data.state)
    self.Parameter.img_lock.gameObject:SetActive(E_CUSTOM_STATE.InActive == data.state)
end

function ChatTagSelectItem:_tryInvokeCallBack()
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
return ChatTagSelectItem