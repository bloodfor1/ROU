--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MagicLetterPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class MagicLetter:UIBaseCtrl
MagicLetterCtrl = class("MagicLetterCtrl", super)
--lua class define end

--lua functions
function MagicLetterCtrl:ctor()

    super.ctor(self, CtrlNames.MagicLetter, UILayer.Normal, nil, ActiveType.Exclusive)
    self.ignoreHideUI = {
        CtrlNames.ChoicePlayer,
        CtrlNames.ChoiceFragrance,
    }
end --func end
--next--
function MagicLetterCtrl:Init()
    ---@type MagicLetterPanel
    self.panel = UI.MagicLetterPanel.Bind(self)
    super.Init(self)

    self.sendLetterMode = true
    ---@type MagicLetterMgr
    self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
    self.panel.Btn_Close:AddClick(function()
        self:Close()
    end, true)

    self:initReceiveLetterPanel()
    self:initSendLetterPanel()
end --func end
--next--
function MagicLetterCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MagicLetterCtrl:OnActive()
    if self.uiPanelData ~= nil then
        self.sendLetterMode = self.uiPanelData.isSendLetter
        if not self.sendLetterMode and self.uiPanelData.receiveLetterInfo == nil then
            self:Close()
            return
        end
    end
    self:playOpenLetterAnim()

end --func end
--next--
function MagicLetterCtrl:OnDeActive()
    self.rewardItemTemplate = nil
    if self.sendLetterMode then
        self.magicLetterMgr.SetLastSendLetterContent(self.panel.Input_Blessing.Input.text)
    end
    self:closeTimer()
	self:destroyEffect()
    self.sendLetterMode = false
end --func end
--next--
function MagicLetterCtrl:Update()


end --func end
--next--
function MagicLetterCtrl:BindEvents()
    self:BindEvent(self.magicLetterMgr.EventDispatcher, self.magicLetterMgr.EMagicEvent.OnCurrentChooseFragranceChanged, self.refreshSendLetterPanel)
    self:BindEvent(self.magicLetterMgr.EventDispatcher, self.magicLetterMgr.EMagicEvent.OnCurrentReceiveLetterFriendChanged, function(_, isTemp, index)
        if not isTemp then
            self:refreshSendLetterPanel()
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function MagicLetterCtrl:playOpenLetterAnim()
    local l_spine = self.panel.Spawn_OpenLetter.Transform:GetComponent("SkeletonGraphic")
    l_spine.startingLoop = true
    l_spine.startingAnimation = "Idle"
    self.panel.Effect_OpenLetter:SetActiveEx(true)
    self:closeTimer()
    self.closeLetterAnimTimer = self:NewUITimer(function()
        if self.sendLetterMode then
            self.panel.Input_Blessing.Input.text = self.magicLetterMgr.GetLastSendLetterContent()
        end
        self.panel.Effect_OpenLetter:SetActiveEx(false)
        self:refreshPanel()
    end, 1.3,1)
    self.closeLetterAnimTimer:Start()
end
function MagicLetterCtrl:closeTimer()
    if self.closeLetterAnimTimer then
        self:StopUITimer(self.closeLetterAnimTimer)
        self.closeLetterAnimTimer = nil
    end
end
function MagicLetterCtrl:refreshPanel()
    self.panel.Panel_Collect:SetActiveEx(not self.sendLetterMode)
    self.panel.Panel_SendOut:SetActiveEx(self.sendLetterMode)
    if self.sendLetterMode then
        self.panel.Panel_SendOut:PlayDynamicEffect()
    else
        self.panel.Panel_Collect:PlayDynamicEffect()
    end
    self:refreshSendLetterPanel()
    self:refreshReceiveLetterPanel()
end
--region sendletter
function MagicLetterCtrl:initSendLetterPanel()
    self.panel.Input_Blessing.Input.characterLimit = self.magicLetterMgr.GetSendMagicLetterMaxCharacterLimit()
    self.panel.Btn_ChooseEffect:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.ChoiceFragrance)
    end, true)
    self.panel.Btn_ChooseRole:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.ChoicePlayer)
    end, true)
    self.panel.Btn_Send:AddClick(function()
        self.magicLetterMgr.ReqSendMagicLetter(self.panel.Input_Blessing.Input.text)
    end, true)
    self.panel.Btn_Face:AddClick(function()
        local l_openParam = {
            inputActionData = {
                inputFunc = function(st)
                    self.panel.Input_Blessing.Input.text = self.panel.Input_Blessing.Input.text .. st
                end,
                inputItemFunc = function(item, hrefType)
                    local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
                    self.panel.Input_Blessing.Input.text = l_linkInputMgr.AddInputHref(self.panel.Input_Blessing.Input.text, item, hrefType)
                end,
                inputHrefDirectFunc = function(st)
                    self.panel.Input_Blessing.Input.text = st
                end,
            },
            onlyShowEmojMode = true,
            needSetPositionMiddle = true,
        }
        UIMgr:ActiveUI(UI.CtrlNames.Multitool, l_openParam)
    end, true)
end
function MagicLetterCtrl:refreshSendLetterPanel()
    if not self.sendLetterMode then
        return
    end
    local l_receiveFriendInfo = self.magicLetterMgr.GetReceiveLetterFriendInfo()
    if l_receiveFriendInfo ~= nil then
        self.panel.Txt_WisePlayer.LabText = l_receiveFriendInfo.base_info.name
    else
        self.panel.Txt_WisePlayer.LabText = ""
    end

    local l_magicPaperItem = TableUtil.GetMagicPaperTypeTable().GetRowByMagicPaperID(self.magicLetterMgr.GetFragranceEffectId())
    if not MLuaCommonHelper.IsNull(l_magicPaperItem) then
        self.panel.Txt_EffectName.LabText = Lang(l_magicPaperItem.MagicPaperTItle)
        if l_magicPaperItem.MagicPaperExpend.Length > 1 then
            local l_firstPropItem = TableUtil.GetItemTable().GetRowByItemID(l_magicPaperItem.MagicPaperExpend[0][0])
            local l_secondPropItem = TableUtil.GetItemTable().GetRowByItemID(l_magicPaperItem.MagicPaperExpend[1][0])
            if not MLuaCommonHelper.IsNull(l_firstPropItem) and not MLuaCommonHelper.IsNull(l_secondPropItem) then
                local l_firstRewardPropText = GetImageText(l_firstPropItem.ItemIcon, l_firstPropItem.ItemAtlas, 16, 26, false)
                local l_secondRewardPropText = GetImageText(l_secondPropItem.ItemIcon, l_secondPropItem.ItemAtlas, 16, 26, false)
                local l_coinCostStr = MNumberFormat.GetNumberFormat(tostring(l_magicPaperItem.MagicPaperExpend[1][1]))
                self.panel.Txt_blessingCoinNum.LabText = Lang("SEND_MAGIC_LETTER_COST", l_firstRewardPropText, l_magicPaperItem.MagicPaperExpend[0][1],
                        l_secondRewardPropText, l_coinCostStr)
                local l_blessingRichTxt = self.panel.Txt_blessingCoinNum:GetRichText()
                l_blessingRichTxt:ClearImgClickInfo()
                l_blessingRichTxt:AddImageClickFuncToDic(l_firstPropItem.ItemIcon, function(spName, ed)
                    self:setRichTextClickFunc(l_firstPropItem.ItemID, ed.position)
                end)
                l_blessingRichTxt:AddImageClickFuncToDic(l_secondPropItem.ItemIcon, function(spName, ed)
                    self:setRichTextClickFunc(l_secondPropItem.ItemID, ed.position)
                end)
                l_blessingRichTxt:SetVerticesDirty()
            end
        end
    end
end
function MagicLetterCtrl:setRichTextClickFunc(propId, pos)
    local l_extraData = {
        relativeScreenPosition = pos,
        bottomAlign = true
    }
    local l_itemData = Data.BagModel:CreateItemWithTid(propId)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(l_itemData, nil, nil, nil, false, l_extraData)
end
--endregion
--region receiveLetter
function MagicLetterCtrl:initReceiveLetterPanel()

    self.panel.Btn_Thanks:AddClick(function()
        ---@type magicLetterReceiveInfo
        local l_sendLetterInfo = self.uiPanelData.receiveLetterInfo
        if l_sendLetterInfo == nil then
            return
        end
        self.magicLetterMgr.ReqThanksMagicPaper(l_sendLetterInfo.letterUId, l_sendLetterInfo.receivePlayerUId)
    end, true)
end
function MagicLetterCtrl:refreshReceiveLetterPanel()
    if self.sendLetterMode then
        return
    end
    ---@type magicLetterReceiveInfo
    local l_receiveLetterInfo = self.uiPanelData.receiveLetterInfo
    local l_blessingContent = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_receiveLetterInfo.blessing)
    self.panel.Text_Blessing.LabText = StringEx.Format("		{0}", l_blessingContent)
    self.panel.Txt_SenderName.LabText = l_receiveLetterInfo.receivePlayerName
    self.panel.Txt_ReceiveName.LabText = Lang("SEND_TO_PLAYER", MPlayerInfo.Name)
    local l_magicPaperItem = TableUtil.GetMagicPaperTypeTable().GetRowByMagicPaperID(l_receiveLetterInfo.fragranceId)
    if not MLuaCommonHelper.IsNull(l_magicPaperItem) then
        self.panel.Txt_ExplainCollect.LabText = Lang(l_magicPaperItem.MagicPaperText)
		self:playEffect(l_magicPaperItem.MagicPaperEffects)
    end
    if self.rewardItemTemplate == nil then
        local l_rewardId = MGlobalConfig:GetInt("MagicPaperAwardForYouAndMe", 0)
        self.rewardItemTemplate = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.panel.Panel_Award.Transform,
            Data = {
                ID = l_rewardId
            }
        })
    end
end
function MagicLetterCtrl:playEffect(effectName)
    self:destroyEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.Raw_Effect.RawImg
    l_fxData.destroyHandler = function()
        self.currentEffectId = 0
    end
    l_fxData.scaleFac = Vector3.New(0.9, 0.9, 0.9)
    self.currentEffectId = self:CreateUIEffect(StringEx.Format("Effects/Prefabs/Creature/Ui/{0}",effectName), l_fxData)
end
function MagicLetterCtrl:destroyEffect()
	if self.currentEffectId and self.currentEffectId > 0 then
		self:DestroyUIEffect(self.currentEffectId)
		self.currentEffectId = 0
	end
end
--endregion
--lua custom scripts end
return MagicLetterCtrl