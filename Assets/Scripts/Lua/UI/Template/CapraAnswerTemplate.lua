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
---@class CapraAnswerTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field QuestionText MoonClient.MLuaUICom
---@field NeedAskButton MoonClient.MLuaUICom
---@field InterestedParent MoonClient.MLuaUICom
---@field InterestedGroup MoonClient.MLuaUICom
---@field FunctionGroup MoonClient.MLuaUICom
---@field DivideLine MoonClient.MLuaUICom
---@field Btn_Share MoonClient.MLuaUICom
---@field AskText MoonClient.MLuaUICom
---@field CapraAnswerInterestedPrefab MoonClient.MLuaUIGroup

---@class CapraAnswerTemplate : BaseUITemplate
---@field Parameter CapraAnswerTemplateParameter

CapraAnswerTemplate = class("CapraAnswerTemplate", super)
--lua class define end

--lua functions
function CapraAnswerTemplate:Init()

    super.Init(self)
    self._question = nil
    self.Parameter.NeedAskButton:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.CapraFAQFeedback)
    end)
    self.interestedPool = self:NewTemplatePool({
        TemplateClassName = "CapraAnswerInterestedTemplate",
        TemplatePrefab = self.Parameter.CapraAnswerInterestedPrefab.gameObject,
        TemplateParent = self.Parameter.InterestedParent.transform,
        ShowMaxCount = 2
    })
    self.Parameter.QuestionText:GetRichText().onHrefClick:AddListener(function(hrefName)
        MgrMgr:GetMgr("CapraFAQMgr").ParsHref(hrefName,self.Parameter.QuestionText.gameObject)
    end)
    self.Parameter.Btn_Share:AddClick(function()
        self:_shareAnswer()
    end)

end --func end
--next--
function CapraAnswerTemplate:BindEvents()


end --func end
--next--
function CapraAnswerTemplate:OnDestroy()

    self._question = nil

end --func end
--next--
function CapraAnswerTemplate:OnDeActive()


end --func end
--next--
function CapraAnswerTemplate:OnSetData(data)
    --log(ToString(data))
    self._question = data.Question
    self.Parameter.FunctionGroup:SetActiveEx(false)
    self.Parameter.InterestedGroup:SetActiveEx(false)
    self.Parameter.Btn_Share:SetActiveEx(false)
    if self:_isNoAnswer(data) then
        self.Parameter.QuestionText.LabText = Lang("CapraFAQ_NoAnswer")
        self.Parameter.FunctionGroup:SetActiveEx(true)
        if data.Keyword and #data.Keyword > 0 then
            self.Parameter.InterestedGroup:SetActiveEx(true)
            self.Parameter.InterestedParent:SetActiveEx(true)
            self.interestedPool:ShowTemplates({ Datas = data.Keyword })
        end
        self.Parameter.NeedAskButton:SetActiveEx(true)
    else
        self.Parameter.NeedAskButton:SetActiveEx(false)
        self.Parameter.QuestionText.LabText = data.Text
        if not data.IsDefaultAnswer then
            self.Parameter.Btn_Share:SetActiveEx(true)
        end
    end
    self.Parameter.AskText:SetActiveEx(self.Parameter.InterestedGroup.UObj.activeSelf)
    self.Parameter.DivideLine:SetActiveEx(self.Parameter.InterestedGroup.UObj.activeSelf)
end --func end
--next--
--lua functions end

--lua custom scripts
function CapraAnswerTemplate:_isNoAnswer(data)
    if string.ro_isEmpty(data.Text) then
        return true
    end

    --if data.Keyword == nil then
    --	return true
    --end
    --
    --if #data.Keyword == 0 then
    --	return true
    --end

    return false
end

function CapraAnswerTemplate:_shareAnswer()
    local l_mousepos = Input.mousePosition
    log(ToString(l_mousepos))
    if self._question == nil then
        return
    end

    local l_names = {}
    local l_callBacks = {}

    local l_Text = StringEx.Format("<a href=LinkCapraFAQ|{0}>[{0}]</a>", self._question)
    local l_TextParam = {}
    local l_param = {}
    l_param.type = ChatHrefType.CapraFAQ
    table.insert(l_TextParam, l_param)

    local l_chatDataMgr = DataMgr:GetData("ChatData")
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")

    local l_channels = {}
    table.insert(l_channels, l_chatDataMgr.EChannel.GuildChat)
    table.insert(l_channels, l_chatDataMgr.EChannel.TeamChat)
    for i, l_channel in pairs(l_channels) do
        local l_name = l_chatDataMgr.GetChannelName(l_channel)
        if l_name ~= nil then
            table.insert(l_names, l_name)
            local l_callBack = function()
                if l_chatMgr.CanSendMsg(l_channel, false, nil, true) then
                    local l_isSendSucceed = l_chatMgr.SendChatMsg(MPlayerInfo.UID, l_Text, l_channel, l_TextParam)
                    if l_isSendSucceed then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShareSucceedText"))
                    end
                else
                    local l_text=StringEx.Format(Lang("CapraAnswer_CantShareTips"), l_name)
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_text)

                end

            end
            table.insert(l_callBacks, l_callBack)
        end

    end
    if #l_names > 0 then
        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = l_names,
            callbackTb = l_callBacks,
            dataopenPos = Vector2.New(900,360),
            dataAnchorMaxPos = Vector2.New(0, 0),
            dataAnchorMinPos = Vector2.New(0, 0)
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
    else

    end

end
--lua custom scripts end
return CapraAnswerTemplate