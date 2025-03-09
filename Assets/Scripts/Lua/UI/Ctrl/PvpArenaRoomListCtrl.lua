--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PvpArenaRoomListPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PvpArenaRoomListCtrl = class("PvpArenaRoomListCtrl", super)
--lua class define end

--lua functions
function PvpArenaRoomListCtrl:ctor()

    super.ctor(self,CtrlNames.PvpArenaRoomList, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

    self.InsertPanelName=UI.CtrlNames.DailyTask

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    --self:SetParent(UI.CtrlNames.DailyTask)

end --func end
--next--
function PvpArenaRoomListCtrl:Init()

    self.panel = UI.PvpArenaRoomListPanel.Bind(self)
    super.Init(self)
    self.pvpArenaMgr = MgrMgr:GetMgr("PvpArenaMgr")
    self:CustomActive()

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark)
end --func end
--next--
function PvpArenaRoomListCtrl:Uninit()

    self:CustomDeActive()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function PvpArenaRoomListCtrl:OnActive()


end --func end
--next--
function PvpArenaRoomListCtrl:OnDeActive()


end --func end
--next--
function PvpArenaRoomListCtrl:Update()


end --func end





--next--
function PvpArenaRoomListCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

local m_scrollViewInit = true --if init UIWrapContent
local m_curShowCount = 200
local m_curSelectItem = {}

function PvpArenaRoomListCtrl:CustomActive()
    self.panel.closeBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaRoomList)
    end)
    m_curSelectItem.index = -1
    self:InitScrollview()
end

function PvpArenaRoomListCtrl:CustomDeActive()
    self.pvpArenaMgr.m_pvpRomeListInfo = {}
    self.pvpArenaMgr.SetReqCount(0)
    m_scrollViewInit = true
    --remove event
    self.pvpArenaMgr.EventDispatcher:RemoveObjectAllFunc(
    self.pvpArenaMgr.SHOW_ARENA_ROOM_LIST, self)
end

function PvpArenaRoomListCtrl:InitScrollview()
    self.uiWrap = self.panel.uiWrapContent.gameObject:GetComponent("UIWrapContent")
    if m_scrollViewInit then
        self.uiWrap:InitContent()
        m_scrollViewInit = false
    end
    local curInfoCount = table.maxn(self.pvpArenaMgr.m_pvpRomeListInfo)
    if curInfoCount > 5 then
        -->5 room info
        self.uiWrap.updateOneItem = function(obj, index)
            local tempCount = table.maxn(self.pvpArenaMgr.m_pvpRomeListInfo)
            --start to send req
            if (tempCount - index) < 2 and index < m_curShowCount then
                self.pvpArenaMgr.EventDispatcher:Add(
                self.pvpArenaMgr.SHOW_ARENA_ROOM_LIST,
                function()
                    self:OnGetNewInfoEvent()
                end, self)
                self.pvpArenaMgr.ShowArenaRoomList(nil)
            end
            local item = obj:GetComponent("MLuaUICom");
            local infoItem = {}
            self:ExportItem(infoItem, obj, index)
            self:InitItem(infoItem)
            item:OnToggleChanged(function()
                self:OnItemClick(infoItem)
            end)
        end
    else
        --<5 room info
        self.uiWrap.updateOneItem = function(obj, index)
            local item = obj:GetComponent("MLuaUICom");
            local infoItem = {}
            self:ExportItem(infoItem, obj, index)
            self:InitItem(infoItem)
            item:OnToggleChanged(function()
                self:OnItemClick(infoItem)
            end)
        end
    end
    self.uiWrap:SetContentCount(curInfoCount)
    self.panel.noObject.gameObject:SetActiveEx(curInfoCount < 1)
end

--On item click to join
function PvpArenaRoomListCtrl:OnItemClick(item)
    if m_curSelectItem.index > 0 then
        m_curSelectItem.checkMark:SetActiveEx(false)
    end
    m_curSelectItem.index = item.index
    m_curSelectItem.checkMark = item.checkMark
    m_curSelectItem.checkMark:SetActiveEx(true)
    self.pvpArenaMgr.ActiveJoinArenaRoom(item.info)
end

--export item
function PvpArenaRoomListCtrl:ExportItem(element, obj, index)
    element.ui = obj
    element.index = index + 1

    element.nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Background/Txt_Room"))
    element.ownerNameLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Background/Txt_Master"))
    element.nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Background/Txt_Room"))
    element.lvLimitLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Background/Txt_Lv"))
    element.numberLab = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Background/Txt_Renshu"))
    element.checkMark = element.ui.transform:Find("Background/Checkmark").gameObject
end

--init item ui and info
function PvpArenaRoomListCtrl:InitItem(item)
    local info = self.pvpArenaMgr.m_pvpRomeListInfo[item.index]
    item.info = info

    item.nameLab.LabText = info.name
    item.ownerNameLab.LabText = info.owner.name
    item.nameLab.LabText = info.owner.name .. Common.Utils.Lang("PVP_DEFAULT_ROOM_NAME")
    item.lvLimitLab.LabText = "lv" .. tostring(info.room_open_minlevel) .. "~lv" .. tostring(info.room_open_maxlevel)
    item.numberLab.LabText = tostring(info.room_open_mincount) .. "/" .. tostring(info.room_open_maxcount)
    item.checkMark:SetActiveEx(false)
end

function PvpArenaRoomListCtrl:OnGetNewInfoEvent()
    --remove drag limit
    self.uiWrap:SetContentCount(table.maxn(self.pvpArenaMgr.m_pvpRomeListInfo))
end

--lua custom scripts end
return PvpArenaRoomListCtrl