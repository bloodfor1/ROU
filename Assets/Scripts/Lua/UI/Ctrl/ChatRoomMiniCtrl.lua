--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChatRoomMiniPanel"
require "UI/Template/ChatRoomMiniTem"
require "Common/CommonScreenPosConverter"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
---@type Common.CommonScreenPosConverter
local l_convertUtil = Common.CommonScreenPosConverter
--next--
--lua fields end

--lua class define
ChatRoomMiniCtrl = class("ChatRoomMiniCtrl", super)
--lua class define end

--lua functions
function ChatRoomMiniCtrl:ctor()

    super.ctor(self, CtrlNames.ChatRoomMini, UILayer.Normal, nil, ActiveType.None)

end --func end
--next--
function ChatRoomMiniCtrl:Init()

    self.panel = UI.ChatRoomMiniPanel.Bind(self)
    super.Init(self)
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    self.chatDataMgr = DataMgr:GetData("ChatData")
    self.roomMgr = MgrMgr:GetMgr("ChatRoomMgr")
    self.panel.Prefab.LuaUIGroup.gameObject:SetActiveEx(false)

    self.panel.BtnEnterChat:AddClick(function()
        self.roomMgr.TrySetPanelMax(true)
    end, true)

    self.chatTemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ChatRoomMiniTem,
        TemplatePrefab = self.panel.Prefab.LuaUIGroup.gameObject,
        ScrollRect = self.panel.MessageBox.LoopScroll,
    })


end --func end
--next--
function ChatRoomMiniCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.chatTemPool = nil
end --func end
--next--
function ChatRoomMiniCtrl:OnActive()
    self:resetRoomData()

end --func end
--next--
function ChatRoomMiniCtrl:OnDeActive()


end --func end
--next--
function ChatRoomMiniCtrl:Update()
    --两个采样数据-最近S+最远E
    local l_sampleS = { x = 7, y = 2.2 }
    local l_sampleE = { x = 28, y = 0.64 }

    --位置
    -- todo CLX: 能这么算是因为角色头顶的位置比3DUI的位置高了一点，所以获取到的位置表现上是对的
    -- todo 实际上这个东西应该改成3DUI
    local l_com = MgrMgr:GetMgr("ChatRoomBubbleMgr").GetEntityCom(MEntityMgr.PlayerEntity)
    if l_com then
        local l_pos = l_com:GetTopPoint()
        local screen_pos = MScene.GameCamera.UCam:WorldToScreenPoint(l_pos)
        local converted_pos = l_convertUtil.ConvertedRectTransformPos(screen_pos)
        self.panel.Main.gameObject:SetRectTransformPos(0, converted_pos.y)
    end

    --取插值
    local l_size = (MScene.GameCamera.Dis - l_sampleS.x) / (l_sampleE.x - l_sampleS.x)
    l_size = Mathf.Lerp(l_sampleS.y, l_sampleE.y, l_size)
    self.panel.Main.transform:SetLocalScale(l_size, l_size, 1)
end --func end

--next--
function ChatRoomMiniCtrl:BindEvents()
    self:BindEvent(GlobalEventBus,EventConst.Names.NewChatMsg, function(self, msg)
        self:newChatMsg(msg)
    end)

    --刷新所有数据
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.ResetData, function(self)
        if self.roomMgr.Room:Has() then
            self:resetRoomData()
        else
            UIMgr:DeActiveUI(UI.CtrlNames.ChatRoomMini)
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function ChatRoomMiniCtrl:resetRoomData()
    if not self.roomMgr.Room:Has() then
        -- UIMgr:DeActiveUI(UI.CtrlNames.ChatRoomMini)
        self.chatTemPool:ShowTemplates({ Datas = {} })
        return
    end

    --
    if string.ro_isEmpty(self.roomMgr.Room.Code) then
        self.panel.TitleIcon:SetSprite("Icon_Function01", "UI_Icon_Function_Liaotianshi01.png")
    else
        self.panel.TitleIcon:SetSprite("Icon_Function01", "UI_Icon_Function_Liaotianshi02.png")
    end

    --聊天信息
    local l_cacheQueue = self.chatDataMgr.GetChannelCache(self.chatDataMgr.EChannel.ChatRoomChat)
    local l_msgs = {}
    if l_cacheQueue ~= nil then
        local l_cacheTable = l_cacheQueue:enumerate()
        for _, msg in pairs(l_cacheTable) do
            table.insert(l_msgs, msg)
        end
    end
    self.chatTemPool:ShowTemplates({ Datas = l_msgs, StartScrollIndex = #l_msgs })

end

function ChatRoomMiniCtrl:newChatMsg(msg)
    if msg.channel ~= self.chatDataMgr.EChannel.ChatRoomChat then
        return
    end
    local l_max = self.chatDataMgr.GetLocalCacheNum(self.chatDataMgr.EChannel.ChatRoomChat)
    self.chatTemPool:AddTemplate(msg, l_max)

    self.panel.MessageBox.LoopScroll:ScrollToCell(#self.chatTemPool.Datas - 1, 2000)
end
--lua custom scripts end
