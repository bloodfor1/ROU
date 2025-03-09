--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleMgr.CapraFAQMgr
module("ModuleMgr.CapraFAQMgr", package.seeall)

--lua model end
---@type ModuleData.CapraFAQData
local l_data = DataMgr:GetData("CapraFAQData")
EventDispatcher = EventDispatcher.new()

OnOpenConsultationQuestion = nil

--lua custom scripts
---@param type CapraFAQData.HttpType
---@param keyword string
function GetHttpRequest(type, keyword)
    local l_sign, l_time, l_url = Common.CommonUIFunc.GetHttpSignAndTimeAndUrl()
    local url = StringEx.Format(l_url .. "{0}?keyword={1}&language={2}", l_data.HttpUrls[tonumber(type)], encodeURI(keyword), GameEnum.GameLanguage2TechnologyCenter[tostring(MGameContext.CurrentLanguage)])
    --log("url = ", url, keyword)
    HttpTask.Create(url):AddHeader("timestamp", tostring(l_time)):AddHeader("sign", l_sign):TimeOut(5000):GetResponseAynsc(function(res, str)
        --logGreen("获取URL 结果", res)
        if res == HttpResult.OK then
            local data = CJson.decode(str)
            --log(ToString(data))
            ParseHttpRequest(type, keyword, data)
        else
            logError("GetAnncounceData Fail HttpResult = " .. tostring(res) .. " type = " .. type .. " keyword = " .. keyword)
        end
    end)
end

function ParseHttpRequest(type, keyword, data)
    CloseCapraQuestionTipsParent()
    local l_answerData
    if type == l_data.HttpType.Answer then
        l_data.SetAnswerData(keyword, type, data.data)
        l_answerData = l_data.GetAnswerData()
        EventDispatcher:Dispatch(l_data.HTTP_ANSWER_DATA_BACK, l_answerData)
    else
        l_data.SetKeyWordData(keyword, type, data.data)
        l_answerData = l_data.GetKeyWordData()
        EventDispatcher:Dispatch(l_data.HTTP_KEYWORD_DATA_BACK, l_answerData)
    end
end

function encodeURI(str)
    if (str) then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w _ %- . ~])",
                function(c)
                    return string.format("%%%02X", string.byte(c))
                end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

function decodeURI(s)
    if (s) then
        s = string.gsub(s, '%%(%x%x)',
                function(hex)
                    return string.char(tonumber(hex, 16))
                end)
    end
    return s
end

---@return CapraFAQAnswerData
function GetAnswerData()
    return l_data.GetAnswerData()
end

---@return CapraFAQKeyWordData
function GetKeyWordData()
    return l_data.GetKeyWordData()
end

function CloseCapraQuestionTipsParent()
    EventDispatcher:Dispatch(l_data.CLOSE_CAPRA_TIPS_Parent)
end

--比较当前返回的httpData是否为自己当前需要的httpData
---@param httpResult CapraFAQAnswerData
function CompareResultKey(key, type, httpResult)
    if httpResult.httpkey ~= key then
        return false
    end
    if httpResult.httpttype ~= type then
        return false
    end
    return true
end

function ParsHref(hrefName,obj)
    --log(ToString(hrefName))
    local strs = string.ro_split(hrefName, "@@")
    --log(ToString(strs))
    if string.lower(strs[1]) == l_data.FuncType.System then
        OpenUI(strs[2])
    elseif string.lower(strs[1]) == l_data.FuncType.NPCGuide then
        NpcGuide(tonumber(strs[2]))
    elseif string.lower(strs[1]) == l_data.FuncType.SameNPCId then
        SameNpcGuide(strs[2])
    elseif string.lower(strs[1]) == l_data.FuncType.URL then
        Application.OpenURL(strs[2])
    elseif string.lower(strs[1]) == l_data.FuncType.KeyWord then
        if not string.ro_isEmpty(strs[2]) then
            local askStr = string.gsub(strs[2],string.char(18)," ")
            EventDispatcher:Dispatch(l_data.SendAskQuestionEvent, askStr)
        end
    elseif string.lower(strs[1]) == l_data.FuncType.ItemTips then
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(tonumber(strs[2]), nil, nil, nil, false)
    elseif string.lower(strs[1]) == l_data.FuncType.SceneGuide then
        SceneGuide(tonumber(strs[2]))
    elseif string.lower(strs[1]) == l_data.FuncType.MarkSkillTips then
        ShowSkillTip(strs[2],obj)
    end
end

function ShowSkillTip(Param,obj)
    local params = string.ro_split(Param, ",")

    if params[1] and params[2] then
        MgrMgr:GetMgr("SkillLearningMgr").ShowSkillTip(tonumber(params[1]), obj, tonumber(params[2]))
    end
end

function OpenUI(UIParam)
    local params = string.ro_split(UIParam, ",")
    --log(ToString(params))
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(tonumber(params[1])) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SYSTEM_DONT_OPEN"))
        return
    end
    local par = {}
    if #params > 1 then
        for i = 2, #params do
            table.insert(par, params[i])
        end
    end
    if #par == 0 then
        par = nil
    end
    Common.CommonUIFunc.InvokeFunctionByFuncId(tonumber(params[1]), par)
end

function NpcGuide(npcId)
    local l_sceneId, l_pos = Common.CommonUIFunc.GetNpcSceneIdAndPos(npcId)
    game:ShowMainPanel()
    MTransferMgr:GotoNpc(l_sceneId[1], npcId)
end

function SameNpcGuide(npcIds)
    local NpcIds = string.ro_split(npcIds, ",")
    local MySceneId = MScene.SceneID
    for _, npcId in pairs(NpcIds) do
        local l_sceneIdTb, l_pos = Common.CommonUIFunc.GetNpcSceneIdAndPos(tonumber(npcId))
        for __, sceneId in pairs(l_sceneIdTb) do
            if MySceneId == sceneId then
                game:ShowMainPanel()
                MTransferMgr:GotoNpc(sceneId, tonumber(npcId))
                return
            end
        end
    end
    NpcGuide(tonumber(NpcIds[1]))
end

function SceneGuide(SceneID)
    game:ShowMainPanel()
    MTransferMgr:GotoScene(SceneID)
end

function SetCapraFAQQuestionData(data)
    l_data.SetCapraFAQQuestionData(data)
end

function OpenConsultationPanel(question)
    OnOpenConsultationQuestion = question
    UIMgr:ActiveUI(UI.CtrlNames.CapraFAQ)
end

--正常问问题，并有回答
function RequestFAQReportOnGetAnswer(question, answer)
    if answer == nil then
        return
    end
    if question == nil then
        return
    end
    if string.ro_isEmpty(answer) then
        return
    end
    if string.ro_isEmpty(question) then
        return
    end
    --logGreen("question:"..question)
    --logGreen("answer:"..answer)
    _requestFAQReport(true, question, answer, nil)
end

--在提问界面提问
function RequestFAQReportOnSendQuestion(question)
    _requestFAQReport(false, nil, nil, question)
end

function _requestFAQReport(isMatched, question, answer, content)
    local l_msgId = Network.Define.Rpc.FAQReport
    local l_sendInfo = GetProtoBufSendTable("FAQReportArg")
    l_sendInfo.is_matched = isMatched
    l_sendInfo.question = question
    l_sendInfo.answer = answer
    l_sendInfo.content = content
    --logGreen("l_sendInfo.is_matched:"..tostring(l_sendInfo.is_matched))
    --logGreen("l_sendInfo.question:"..tostring(l_sendInfo.question))
    --logGreen("l_sendInfo.answer:"..tostring(l_sendInfo.answer))
    --logGreen("l_sendInfo.content:"..tostring(l_sendInfo.content))
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveFAQReport(msg)
    local l_info = ParseProtoBufToTable("FAQReportRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CapraFAQFeedback_FinishAsk"))
end

--lua custom scripts end
return ModuleMgr.CapraFAQMgr