--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildInforPanel = {}

--lua model end

--lua functions
---@class GuildInforPanel.GuildNewsItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field NewsText MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field Btn_GoodTxt MoonClient.MLuaUICom
---@field Btn_Good MoonClient.MLuaUICom

---@class GuildInforPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WordsBox MoonClient.MLuaUICom
---@field Words MoonClient.MLuaUICom
---@field TxtCrysatlCharge MoonClient.MLuaUICom
---@field Tog_TypeTxt MoonClient.MLuaUICom
---@field Tog_Type MoonClient.MLuaUICom
---@field Tog_News MoonClient.MLuaUICom
---@field Tog_Infos MoonClient.MLuaUICom
---@field Tog_GuildSprite MoonClient.MLuaUICom
---@field SwitchWordsOn MoonClient.MLuaUICom
---@field SwitchWordsOff MoonClient.MLuaUICom
---@field SwitchNoticeOn MoonClient.MLuaUICom
---@field SwitchNoticeOff MoonClient.MLuaUICom
---@field ScreenPanel MoonClient.MLuaUICom
---@field Obj_Img_Boli MoonClient.MLuaUICom
---@field NoticeBox MoonClient.MLuaUICom
---@field Notice MoonClient.MLuaUICom
---@field NewsScrollView MoonClient.MLuaUICom
---@field NewsContent MoonClient.MLuaUICom
---@field MemberNum MoonClient.MLuaUICom
---@field InfoTitle MoonClient.MLuaUICom
---@field Img_TypeIcon MoonClient.MLuaUICom
---@field GuildSpriteTxt MoonClient.MLuaUICom
---@field GuildSprite MoonClient.MLuaUICom
---@field GuildRawImage MoonClient.MLuaUICom
---@field GuildName MoonClient.MLuaUICom
---@field GuildLv MoonClient.MLuaUICom
---@field GuildID MoonClient.MLuaUICom
---@field GuildIcon MoonClient.MLuaUICom
---@field GuildGroupState MoonClient.MLuaUICom
---@field GuildCrystalPanelBtn MoonClient.MLuaUICom
---@field GuildCrystalPanel MoonClient.MLuaUICom
---@field GuildCrystalLv MoonClient.MLuaUICom
---@field FundTxt MoonClient.MLuaUICom
---@field DescribeText MoonClient.MLuaUICom
---@field DescribePanel MoonClient.MLuaUICom
---@field CrystalTitle MoonClient.MLuaUICom
---@field ContentView MoonClient.MLuaUICom
---@field Container MoonClient.MLuaUICom
---@field ChairmanSexIcon MoonClient.MLuaUICom
---@field ChairmanName MoonClient.MLuaUICom
---@field BuffValue MoonClient.MLuaUICom[]
---@field BuffTime MoonClient.MLuaUICom
---@field BuffPropertyBox MoonClient.MLuaUICom[]
---@field BuffProperty MoonClient.MLuaUICom
---@field BuffNone MoonClient.MLuaUICom
---@field BuffName MoonClient.MLuaUICom[]
---@field BtnMsgModify MoonClient.MLuaUICom
---@field BtnInfo MoonClient.MLuaUICom
---@field BtnGuildGroupText MoonClient.MLuaUICom
---@field BtnGuildGroup MoonClient.MLuaUICom
---@field BtnGuildCrystal MoonClient.MLuaUICom
---@field BtnGoToCrystal MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom
---@field BtnEnter MoonClient.MLuaUICom
---@field Btn_Screen MoonClient.MLuaUICom
---@field Btn_CloseScreen MoonClient.MLuaUICom
---@field GuildNewsItemPrefab GuildInforPanel.GuildNewsItemPrefab

---@return GuildInforPanel
---@param ctrl UIBase
function GuildInforPanel.Bind(ctrl)
	
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
return UI.GuildInforPanel