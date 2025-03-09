--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FriendsPanel = {}

--lua model end

--lua functions
---@class FriendsPanel.FriendsItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field PlayerHeadButton MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field FriendsText MoonClient.MLuaUICom
---@field Friends_Selected MoonClient.MLuaUICom
---@field Friends_ItemButton MoonClient.MLuaUICom
---@field ChatPrompt MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom

---@class FriendsPanel.FriendsHelperPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field EnterBtn MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field ChatPrompt MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class FriendsPanel.FriendChatPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field SystemChatText MoonClient.MLuaUICom
---@field SystemChat MoonClient.MLuaUICom
---@field PlayerWarningTag MoonClient.MLuaUICom
---@field PlayerLeftRect MoonClient.MLuaUICom
---@field PlayerChatText MoonClient.MLuaUICom
---@field PlayerChatHead MoonClient.MLuaUICom
---@field PlayerChat MoonClient.MLuaUICom
---@field PlayerAudioTime MoonClient.MLuaUICom
---@field PlayerAudioPoint MoonClient.MLuaUICom
---@field PlayerAudioObj MoonClient.MLuaUICom
---@field PlayerAudioBtn MoonClient.MLuaUICom
---@field PlayerAudioAnim MoonClient.MLuaUICom
---@field OtherChatText MoonClient.MLuaUICom
---@field OtherChatHead MoonClient.MLuaUICom
---@field OtherChat MoonClient.MLuaUICom
---@field OtherAudioTime MoonClient.MLuaUICom
---@field OtherAudioPoint MoonClient.MLuaUICom
---@field OtherAudioObj MoonClient.MLuaUICom
---@field OtherAudioBtn MoonClient.MLuaUICom
---@field OtherAudioAnim MoonClient.MLuaUICom
---@field img_other_bg MoonClient.MLuaUICom
---@field img_chat_tag_self MoonClient.MLuaUICom
---@field img_chat_tag_other MoonClient.MLuaUICom
---@field img_bg_self MoonClient.MLuaUICom

---@class FriendsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tog_Friends_RecentChat MoonClient.MLuaUICom
---@field Tog_Friends_Friend MoonClient.MLuaUICom
---@field ShowIntimacyDegreeDeatialButton MoonClient.MLuaUICom
---@field Panel_Input MoonClient.MLuaUICom
---@field OnlyWearToggleLight MoonClient.MLuaUICom
---@field OnlyWearToggle MoonClient.MLuaUICom
---@field NonFriendText MoonClient.MLuaUICom
---@field KeyboardBtn MoonClient.MLuaUICom
---@field IntimacyDegreeDeatialText MoonClient.MLuaUICom
---@field IntimacyDegreeDeatialPanel MoonClient.MLuaUICom
---@field IntimacyDegree MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field FriendText MoonClient.MLuaUICom
---@field FriendsScroll MoonClient.MLuaUICom
---@field FriendsItemParent MoonClient.MLuaUICom
---@field Friends_Talk_Emty MoonClient.MLuaUICom
---@field Friends_Light MoonClient.MLuaUICom
---@field FriendChatParent MoonClient.MLuaUICom
---@field DeletionRecordButton MoonClient.MLuaUICom
---@field CloseDegreeDeatialButton MoonClient.MLuaUICom
---@field ChatScroll MoonClient.MLuaUICom
---@field BtnSend MoonClient.MLuaUICom
---@field BtnFace MoonClient.MLuaUICom
---@field Btn_Friends_VoiceChat MoonClient.MLuaUICom
---@field Btn_Friends_Jiayuan MoonClient.MLuaUICom
---@field Btn_Friends_Jiapu MoonClient.MLuaUICom
---@field Btn_Friends_AddFriend MoonClient.MLuaUICom
---@field AudioPanel MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom
---@field AssistantBtn2 MoonClient.MLuaUICom
---@field AssistantBtn1 MoonClient.MLuaUICom
---@field Assistant MoonClient.MLuaUICom
---@field FriendsItemPrefab FriendsPanel.FriendsItemPrefab
---@field FriendsHelperPrefab FriendsPanel.FriendsHelperPrefab
---@field FriendChatPrefab FriendsPanel.FriendChatPrefab

---@return FriendsPanel
---@param ctrl UIBase
function FriendsPanel.Bind(ctrl)
	
	--dont override this function
	---@type MoonClient.MLuaUIPanel
	local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
	ctrl:OnBindPanel(panelRef)
	return BindMLuaPanel(panelRef)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return UI.FriendsPanel