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
---@class ChatLineBoxPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SystemChatText MoonClient.MLuaUICom

---@class ChatLineBoxPrefab : BaseUITemplate
---@field Parameter ChatLineBoxPrefabParameter

ChatLineBoxPrefab = class("ChatLineBoxPrefab", super)
--lua class define end

--lua functions
function ChatLineBoxPrefab:Init()
    super.Init(self)
end --func end
--next--
function ChatLineBoxPrefab:OnDestroy()
    -- do nothing
end --func end
--next--
function ChatLineBoxPrefab:OnDeActive()
    -- do nothing
end --func end
--next--
function ChatLineBoxPrefab:OnSetData(data)

    self.msgPack = data
    local l_content = nil
    local l_row = TableUtil.GetMessageTable().GetRowByID(data.FriendData.contentID, true)
    if l_row then
        if data.FriendData.contentID == 63002 then
            l_content = l_row.Content
            l_content = StringEx.Format(l_content, "PlayerSetting")
            self:AddSystemChatHref()
        elseif data.FriendData.contentID == 63001 then
            l_content = l_row.Content
            l_content = StringEx.Format(l_content, Common.Utils.PlayerName(data.FriendInfo.base_info.name) or "???")
        else
            logError("data.FriendData.contentID=" .. tostring(data.FriendData.contentID))
            l_content = l_row.Content
        end
    else
        l_content = "???"
    end
    self.Parameter.SystemChatText.LabText = l_content
    self.Parameter.SystemChatText.LabRayCastTarget = true
    local l_richText = self.Parameter.SystemChatText:GetRichText()
    l_richText.onHrefClick:Release()
    l_richText.onHrefClick:AddListener(function(hrefName)
        if hrefName == "PlayerSetting" then
            UIMgr:ActiveUI(UI.CtrlNames.Setting, function(ctrl)
                local settingMgr = MgrMgr:GetMgr("SettingMgr")
                settingMgr.SetIsOpenToPlayerPrivate(true)
                ctrl:SelectOneHandler(UI.HandlerNames.SettingPlayer)
            end)
        end
    end)
    l_richText.onDown = function()
        if self.MethodCallback then
            self.MethodCallback(self.msgPack)
        end
    end
    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)

end --func end
--next--
function ChatLineBoxPrefab:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
--添加设置链接
function ChatLineBoxPrefab:AddSystemChatHref()
	self.Parameter.SystemChatText.LabRayCastTarget = true
	self.Parameter.SystemChatText:GetRichText().onHrefClick:Release()
	self.Parameter.SystemChatText:GetRichText().onHrefClick:AddListener(function (hrefName)
		if hrefName == "PlayerSetting" then
			UIMgr:ActiveUI(UI.CtrlNames.Setting,function(ctrl)
				local settingMgr = MgrMgr:GetMgr("SettingMgr")
				settingMgr.SetIsOpenToPlayerPrivate(true)
				ctrl:SelectOneHandler(UI.HandlerNames.SettingPlayer)
			end)
		end
	end)
end
--lua custom scripts end
return ChatLineBoxPrefab