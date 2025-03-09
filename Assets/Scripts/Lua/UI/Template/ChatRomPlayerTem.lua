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
---@class ChatRomPlayerTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectBtn MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field HeadBtn MoonClient.MLuaUICom
---@field ExitBtn MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom

---@class ChatRomPlayerTem : BaseUITemplate
---@field Parameter ChatRomPlayerTemParameter

ChatRomPlayerTem = class("ChatRomPlayerTem", super)
--lua class define end

--lua functions
function ChatRomPlayerTem:Init()
    super.Init(self)
end --func end
--next--
function ChatRomPlayerTem:OnDestroy()
    self.head2d = nil
end --func end
--next--
function ChatRomPlayerTem:OnDeActive()
    -- do nothing
end --func end
--next--
function ChatRomPlayerTem:OnSetData(data)
    self.RoomMgr = MgrMgr:GetMgr("ChatRoomMgr")
    self.data = data
    self.playerInfo = data.member

    --玩家名
    self.Parameter.Name.LabText = self.playerInfo.name
    self:_updateHead()
    
    --踢出按钮
    self.Parameter.ExitBtn:AddClick(function()
        self.RoomMgr.TryKickMember(self.playerInfo.uid)
    end, true)

    --暂离
    self.Parameter.Mask:SetActiveEx(self.data.state)
    self.Parameter.SelectBtn:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(self)
        end
    end, true)

end --func end
--next--
function ChatRomPlayerTem:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

function ChatRomPlayerTem:_onHeadClick()
    MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.playerInfo.uid, self.playerInfo)
end

function ChatRomPlayerTem:_updateHead()
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Icon.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = self.playerInfo:GetEquipData(),
        ShowProfession = true,
        Profession = self.playerInfo.type,
        ShowLv = true,
        Level = self.playerInfo.level,
        OnClick = self._onHeadClick,
        OnClickSelf = self,
    }

    self.head2d:SetData(param)
end

function ChatRomPlayerTem:Select()
    self.Parameter.Light:SetActiveEx(true)
    -- 当玩家是房主且当前标签不是玩家标签时，选中标签才出现踢人按钮
    local showExitBtn = self.RoomMgr.Room:SelfCaptain() and self.playerInfo.uid ~= MPlayerInfo.UID
    self.Parameter.ExitBtn:SetActiveEx(showExitBtn)
end

function ChatRomPlayerTem:Deselect()
    self.Parameter.Light:SetActiveEx(false)
    self.Parameter.ExitBtn:SetActiveEx(false)
end
--lua custom scripts end
return ChatRomPlayerTem