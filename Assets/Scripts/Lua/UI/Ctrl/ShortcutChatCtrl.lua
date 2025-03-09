--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ShortcutChatPanel"
require "CommonUI/ChatRecordObj"
require "UI/Template/ShortcutFriendPrefab"
require "UI/Template/ShortcutChatPrefab"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ShortcutChatCtrl = class("ShortcutChatCtrl", super)
--lua class define end

--lua functions
function ShortcutChatCtrl:ctor()

    super.ctor(self, CtrlNames.ShortcutChat, UILayer.Normal, nil, ActiveType.Normal)
    --观战时，这个界面要比观战界面层级高。
    self.overrideSortLayer = UILayerSort.Normal + 1
end --func end
--next--
function ShortcutChatCtrl:Init()
    self.panel = UI.ShortcutChatPanel.Bind(self)
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("ShortcutChatMgr")
    self.GuildMgr = MgrMgr:GetMgr("GuildMgr")
    self.ChatMgr = MgrMgr:GetMgr("ChatMgr")
    self.TeamMgr = MgrMgr:GetMgr("TeamMgr")
    self.ChatLis = {}
    self.panel.Prefab.LuaUIGroup.gameObject:SetActiveEx(false)

    for i = 1, #self.Mgr.DataLis do
        self:AddChat(self.Mgr.DataLis[i])
    end

end --func end
--next--
function ShortcutChatCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.ChatLis = {}

end --func end
--next--
function ShortcutChatCtrl:OnActive()

    for i = 1, #self.ChatLis do
        local l_tem = self.ChatLis[i]
        l_tem:ResetShow()
    end

end --func end
--next--
function ShortcutChatCtrl:OnDeActive()


end --func end
--next--
function ShortcutChatCtrl:Update()
    for i = 1, #self.ChatLis do
        local l_tem = self.ChatLis[i]
        l_tem:Update()
    end

end --func end

--next--
function ShortcutChatCtrl:BindEvents()
    self:BindEvent(self.Mgr.EventDispatcher,self.Mgr.Event.AddData, self.AddChat)
    self:BindEvent(self.Mgr.EventDispatcher,self.Mgr.Event.RemoveData, self._removeData)
end --func end
--next--
--lua functions end

--lua custom scripts
-- 移除数据
function ShortcutChatCtrl:_removeData(data)

    for i = 1, #self.ChatLis do
        local l_tem = self.ChatLis[i]
        if l_tem.Data == data then
            self:UninitTemplate(l_tem)
            table.remove(self.ChatLis, i)
            return
        end
    end
end

-- 添加数据
function ShortcutChatCtrl:AddChat(data)
    local l_class = data.uid and "ShortcutFriendPrefab" or "ShortcutChatPrefab"
    local l_tempConfig = {
        TemplatePrefab = self.panel.Prefab.LuaUIGroup.gameObject,
        TemplateParent = self.panel.Parent.transform,
        Data = data,
    }

    local l_temp = self:NewTemplate(l_class, l_tempConfig)
    table.insert(self.ChatLis, l_temp)
end
--lua custom scripts end
return ShortcutChatCtrl