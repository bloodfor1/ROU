--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleData.CapraFAQData
module("ModuleData.CapraFAQData", package.seeall)

--lua model end

HTTP_ANSWER_DATA_BACK = "HTTP_ANSWER_DATA_BACK"
HTTP_KEYWORD_DATA_BACK = "HTTP_KEYWORD_DATA_BACK"
SendAskQuestionEvent = "SendAskQuestionEvent"
CLOSE_CAPRA_TIPS_Parent = "CLOSE_CAPRA_TIPS_Parent"

HttpUrls = {
    [1] = "/qa/keywords",
    [2] = "/qa/answer"
}

---@class CapraFAQData.HttpType
HttpType = {
    KeyWord = 1, ---@关键字补全
    Answer = 2---@获取问题答案
}
---@class CapraFAQData.FuncType
FuncType = {
    System = "system",
    NPCGuide = "npcguide",
    NPCScene = "npcsene",
    SameNPCId = "samenpcid",
    KeyWord = "keyword",
    URL = "url",
    ItemTips = "itemtips",
    SceneGuide = "sceneguide",
    MarkSkillTips = "markskilltips",
}

---@class CapraFAQAnswerData
---@field httpkey string
---@field httpttype number
---@field answer string
---@field keyword string[]
local answerData = {}
---@class CapraFAQKeyWordData
---@field httpkey string
---@field httpttype number
---@field result string[]
local keyWordData = {}

local knowledgeTableInfo = {}

local capraFAQQuestionData = {}
local judgeTextForbid = {}

--lua functions
function Init()
    ResetAnswerData()
    ResetKeyWordData()

    local knowledgeTable = TableUtil.GetKnowledgeTable().GetTable()
    local serverLvl = DataMgr:GetData("RoleInfoData").SeverLevelData.serverlevel
    for i = 1, #knowledgeTable do
        if knowledgeTable[i].ServerLevel <= serverLvl then
            local l_answers = knowledgeTableInfo[knowledgeTable[i].Type]
            if l_answers == nil then
                l_answers = {}
                knowledgeTableInfo[knowledgeTable[i].Type] = l_answers
            end
            table.insert(knowledgeTableInfo[knowledgeTable[i].Type], knowledgeTable[i].Text)
        end
    end

end --func end
--next--
function Logout()
    ResetAnswerData()
    ResetKeyWordData()
    capraFAQQuestionData = {}
    judgeTextForbid = {}
    knowledgeTableInfo = {}
end --func end
--next--
--lua functions end

--lua custom scripts

function SetAnswerData(key, type, mvalue)
    ResetAnswerData()
    answerData.httpkey = key
    answerData.httpttype = type
    local answerStr = mvalue.answer

    if answerStr then

        local oldStr = answerStr
        for hstr in string.gmatch(oldStr,"href=([^>\n]+)>") do
            if hstr then
                local subStr = string.gsub(hstr," " ,string.char(18))
                answerStr = string.gsub(answerStr, hstr,subStr)
            end
        end


        local hrefstrs = MLuaCommonHelper.GetHrefStr(answerStr)
        if hrefstrs then
            local strs = string.ro_split(hrefstrs[0], "@@")
            if string.lower(strs[1]) == "getknowledgetable" then
                local l_type = string.ro_split(strs[2], ",")
                answerData.answer = GetKnowlegeTableText(l_type[1])
            end
        end
    end
    if answerData.answer == nil then
        local str = string.gsub(answerStr, "\\n", "\n")
        answerData.answer = str
    end

    if mvalue.keywords and #mvalue.keywords >= 1 then
        for _, v in ipairs(mvalue.keywords) do
            table.insert(answerData.keyword, v)
        end
    end
end

function SetKeyWordData(key, type, mvalue)
    ResetKeyWordData()
    keyWordData.httpkey = key
    keyWordData.httpttype = type
    if mvalue and #mvalue >= 1 then
        for _, v in ipairs(mvalue) do
            table.insert(keyWordData.result, v)
        end
    end
end

function GetAnswerData()
    return answerData
end

function GetKeyWordData()
    return keyWordData
end

function ResetAnswerData()
    answerData.httpkey = 0
    answerData.httpttype = 0
    answerData.keyword = {}
    answerData.answer = nil
end

function ResetKeyWordData()
    keyWordData.httpkey = 0
    keyWordData.httpttype = 0
    keyWordData.result = {}
end

function SetCapraFAQQuestionData(data)
    table.insert(capraFAQQuestionData, data)
    if #capraFAQQuestionData > 20 then
        table.remove(capraFAQQuestionData, 1)
    end
end

function SetDefaultAnswer()
    if GetCapraFAQQuestionCount() > 0 then
        return
    end
    local l_data = {}
    l_data.IsQuestion = false
    l_data.Text = Lang("CapraFAQ_DefaultAnswer")
    l_data.IsDefaultAnswer = true
    SetCapraFAQQuestionData(l_data)
end

function GetCapraFAQQuestionDatas()
    SetDefaultAnswer()
    --logGreen("#capraFAQQuestionData:"..tostring(#capraFAQQuestionData))
    return capraFAQQuestionData
end

function GetCapraFAQQuestionCount()
    return #capraFAQQuestionData
end

function GetKnowlegeTableText(type)
    type = tonumber(type)

    local l_answers = knowledgeTableInfo[type]
    if l_answers == nil then
        logError("此类型没有随机答案数据:" .. tostring(type))
        return nil
    end
    local count = #l_answers
    local l_randNum = math.random(1, count)
    return l_answers[l_randNum]

end

function SetJudgeTextForbid(key, value)
    judgeTextForbid[key] = value
end

function GetJudgeTextForbid(key)
    --logGreen("GetJudgeTextForbid:"..key)
    return judgeTextForbid[key]
end

--lua custom scripts end
return ModuleData.CapraFAQData