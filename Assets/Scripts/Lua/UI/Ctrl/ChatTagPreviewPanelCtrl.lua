--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChatTagPreviewPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ChatTagPreviewPanelCtrl : UIBaseCtrl
ChatTagPreviewPanelCtrl = class("ChatTagPreviewPanelCtrl", super)
--lua class define end

--lua functions
function ChatTagPreviewPanelCtrl:ctor()
    super.ctor(self, CtrlNames.ChatTagPreviewPanel, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.ClosePanelNameOnClickMask = self.name
end --func end
--next--
function ChatTagPreviewPanelCtrl:Init()
    self.panel = UI.ChatTagPreviewPanelPanel.Bind(self)
    super.Init(self)
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function ChatTagPreviewPanelCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ChatTagPreviewPanelCtrl:OnActive()
    self:_showData(self.uiPanelData.DataList)
    local pos = CoordinateHelper.WorldPositionToLocalPosition(self.uiPanelData.Position, self.panel.ChatTagPreviewPanel.transform)
    local vec2 = Vector2.New(pos.x + self.panel.MainPanel.Img.rectTransform.sizeDelta.x * 0.3, pos.y + self.panel.MainPanel.Img.rectTransform.sizeDelta.y * 0.5)
    self.panel.MainPanel.gameObject:SetLocalPos(vec2)
end --func end
--next--
function ChatTagPreviewPanelCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function ChatTagPreviewPanelCtrl:Update()
    -- do nothing
end --func end
--next--
function ChatTagPreviewPanelCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

function ChatTagPreviewPanelCtrl:_initConfig()
    self._tagTemplatePoolConfig = {
        TemplateClassName = "ChatTagTemplate",
        TemplatePrefab = self.panel.ChatTagTemplate.gameObject,
        ScrollRect = self.panel.LoopScroll.LoopScroll,
    }
end

function ChatTagPreviewPanelCtrl:_initWidgets()
    self._tagTemplatePool = self:NewTemplatePool(self._tagTemplatePoolConfig)
end

---@param data DialogTabTable[]
function ChatTagPreviewPanelCtrl:_showData(data)
    if nil == data then
        logError("[ChatTagPanel] invalid data")
        return
    end

    self._tagTemplatePool:ShowTemplates({ Datas = data })
end

--lua custom scripts end
return ChatTagPreviewPanelCtrl