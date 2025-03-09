--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChatsetingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ChatsetingCtrl = class("ChatsetingCtrl", super)

RETAIN_HINT = "RETAIN_HINT"
--lua class define end

--lua functions
function ChatsetingCtrl:ctor()

	super.ctor(self, CtrlNames.Chatseting, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.Toogles={}
end --func end
--next--
function ChatsetingCtrl:Init()
	self.panel = UI.ChatsetingPanel.Bind(self)
	super.Init(self)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Chatseting)
    end)
    
    --前五个为主界面频道显示
    self.Toogles[1]=self.panel.MainTogle1;
    self.Toogles[2]=self.panel.MainTogle2;
    self.Toogles[3]=self.panel.MainTogle3;
    self.Toogles[4]=self.panel.MainTogle4;
    self.Toogles[5]=self.panel.MainTogle5;

    --选项不能少于一个，取消到最后一个提示
    for i=1,5 do
        local Tog = self.Toogles[i]
        self.Toogles[i]:OnToggleChanged(function(active)
            if not active then
                for i=1,5 do
                    if self.Toogles[i].Tog.isOn then
                        return
                    end
                end
                Tog.Tog.isOn=true;
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang(RETAIN_HINT))--至少保留一个频道
            end
        end,true)
    end

end --func end
--next--
function ChatsetingCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function ChatsetingCtrl:OnActive()
    --读表可以勾选
    --self.Toogles[4].gameObject:SetActiveEx(false);
    --读表默认勾选
    -- if MPlayerSetting.ChatSystemIndex<0 then
    --     MPlayerSetting.ChatSystemIndex=-1
    -- end

    --设置按钮当前状态
    for i=1,#self.Toogles do
        local l_curActive = DataMgr:GetData("ChatData").GetSystemSwich(i)
        self.Toogles[i].Tog.isOn = l_curActive;
    end

    self.StartSystemIndex=MPlayerSetting.ChatSystemIndex

    --快捷聊天选项
    local l_value = MPlayerSetting.ChatQuickIndex
    local l_shortCutMgr = MgrMgr:GetMgr("ShortcutChatMgr")
    self.panel.QuickTeam.Tog.isOn = Common.Bit32.And(l_value,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.TEAM)) ~= 0
    self.panel.QuickGuild.Tog.isOn = Common.Bit32.And(l_value,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.GUILD)) ~= 0
    self.panel.QuickWatch.Tog.isOn = Common.Bit32.And(l_value,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.WATCH)) ~= 0
end --func end
--next--
function ChatsetingCtrl:OnDeActive()
    --保存设置
    local l_Index = 0;
    for i=1,#self.Toogles do
        if self.Toogles[i].Tog.isOn then
            local l_curIndex = Common.Bit32.Lshift(1,i)
            l_Index = Common.Bit32.Or(l_Index,l_curIndex)
        end
    end


    --设置变化
    if self.StartSystemIndex~=l_Index then
        MPlayerSetting.ChatSystemIndex=l_Index
        --通知对话框
        MgrMgr:GetMgr("ChatMgr").OnSystemIndexChange();
    end

    local l_shortCutMgr = MgrMgr:GetMgr("ShortcutChatMgr")
    --快捷聊天选项
    local l_oldIndex = MPlayerSetting.ChatQuickIndex
    local l_index = l_oldIndex
    if self.panel.QuickTeam.Tog.isOn then
        l_index = Common.Bit32.Or(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.TEAM))
    elseif Common.Bit32.And(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.TEAM)) ~= 0 then
        l_index = Common.Bit32.Xor(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.TEAM))
    end
    if self.panel.QuickGuild.Tog.isOn then
        l_index = Common.Bit32.Or(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.GUILD))
    elseif Common.Bit32.And(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.GUILD)) ~= 0 then
        l_index = Common.Bit32.Xor(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.GUILD))
    end

    if self.panel.QuickWatch.Tog.isOn then
        l_index = Common.Bit32.Or(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.WATCH))
    elseif Common.Bit32.And(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.WATCH)) ~= 0 then
        l_index = Common.Bit32.Xor(l_index,Common.Bit32.Lshift(1,l_shortCutMgr.QUICK_CHAT_BIT.WATCH))
    end

    if l_oldIndex ~= l_index then
        MPlayerSetting.ChatQuickIndex = l_index
        MgrMgr:GetMgr("ChatMgr").OnChatSettingIndexChange();
    end
end --func end
--next--
function ChatsetingCtrl:Update()


end --func end


--next--
function ChatsetingCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
--lua custom scripts end
