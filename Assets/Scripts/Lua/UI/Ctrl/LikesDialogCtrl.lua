--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LikesDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
LikesDialogCtrl = class("LikesDialogCtrl", super)
local l_tipsData = DataMgr:GetData("TipsData")
--lua class define end

--lua functions
function LikesDialogCtrl:ctor()
	
	super.ctor(self, CtrlNames.LikesDialog, UILayer.Function, nil, ActiveType.Standalone)
	self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.LikesDialog
	
end --func end
--next--
function LikesDialogCtrl:Init()
	
	self.panel = UI.LikesDialogPanel.Bind(self)
	super.Init(self)
	self.panel.CloseBth:AddClick(function ()
		UIMgr:DeActiveUI(UI.CtrlNames.LikesDialog)
	end)
end --func end
--next--
function LikesDialogCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function LikesDialogCtrl:OnActive()
	if self.uiPanelData then
        if self.uiPanelData.openType == l_tipsData.ETipsOpenType.GuildLikesOpen then
            self:ShowLikesDialog(self.uiPanelData.title,self.uiPanelData.mainInfo,self.uiPanelData.defaultInfo,self.uiPanelData.additionData,self.uiPanelData.func)
        end
    end
end --func end
--next--
function LikesDialogCtrl:OnDeActive()
	
	
end --func end
--next--
function LikesDialogCtrl:Update()
	
	
end --func end
--next--
function LikesDialogCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function LikesDialogCtrl:ShowLikesDialog(title,mainInfo,defaultInfo,additionData,func)
	self.panel.Title.LabText = title
	local replace = Lang("GUILD_LAKE_R")
	local l_mainInfo = string.gsub(mainInfo, replace, "") 
	self.panel.Txt_Likes.LabText = l_mainInfo
	self.panel.Obj_Input.Input.text = defaultInfo
	self.panel.Obj_Input:OnInputFieldChange(function(value)
        self.panel.Obj_Input.Input.text = value
	end)
	local l_playerName = self.panel.Txt_Likes:GetRichText():GetHrefValue("ShowPlayerDetail")
	l_playerName = string.gsub(l_playerName,"<color=$$Blue$$>","")
	l_playerName = string.gsub(l_playerName,"</color>","")
	self.panel.Btn_Send:AddClick(function ()
		local l_show = "@ "..l_playerName .." ".. self.panel.Obj_Input.Input.text --用于显示
		local l_replace = "@&&"..l_playerName .."&&".. self.panel.Obj_Input.Input.text --用于附议 需要替换掉&& 为 空格
		local l_finText = self.panel.Txt_Likes.LabText .. "\n" .. l_show .. Lang("GUILD_AGREE",l_replace,tostring(MPlayerInfo.UID))
		MgrMgr:GetMgr("ForbidTextMgr").RequestJudgeTextForbid(l_show, function(checkInfo)
			local l_resultCode = checkInfo.result
			if l_resultCode ~= 0 then
				--判断服务器是否判断失败 如果失败什么都不发生
				if l_resultCode == ErrorCode.ERR_FAILED then
					return
				end

				--含有屏蔽字则提示
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resultCode))
				return
			end
			MgrMgr:GetMgr("GuildMgr").GuildNewsSetLakeState(l_mainInfo)
			local cloneData = table.ro_clone(additionData.announceData)
			cloneData.agreeText = l_show
			cloneData.replaceText = l_replace
			cloneData.senderUid = tostring(MPlayerInfo.UID)
			additionData.announceData = cloneData
			func(additionData)
			UIMgr:DeActiveUI(UI.CtrlNames.LikesDialog)
		end)
	end)
	local l_msgData,l_content,l_params,l_localArgs,l_extraLinkData = MgrMgr:GetMgr("MessageRouterMgr").GetMessageContent(additionData.announceData.id,nil,additionData.announceData)
	self.panel.Txt_Likes:GetRichText().onHrefClick:RemoveAllListeners()
    self.panel.Txt_Likes:GetRichText().onHrefClick:AddListener(function(key)
		MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo(key,nil,l_extraLinkData)
    end)
end
--lua custom scripts end
return LikesDialogCtrl