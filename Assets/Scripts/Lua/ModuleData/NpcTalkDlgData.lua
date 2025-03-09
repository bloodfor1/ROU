
module("ModuleData.NpcTalkDlgData", package.seeall)

ECommandType = {
    StartTalk = 1,
    TalkNpc = 2,
    NpcSelect = 3,
}


SelectInfos = {} -- 当前的Npc的选项信息
SelectShowInfo = {
    showSelect = false, -- 显示选项信息
    isPlayer = false, -- 玩家标记
    content = "", -- 对话内容
    block = nil  -- 运行block
}
Talked = false -- 一次交互中是否对话过

AutoRunFilter = nil

PlotData = {}

CurTalkNpcId = -1

TalkDlgBtnMoveStay = 1
TalkDlgBtnMoveSpeed = 10
TalkDlgBtnMoveExit = 1

FirstTalkTaskNpcID = -10000
SecondTalkTaskNpcID = -10000

ImportantTaskDic = {}

function Init()

    SelectInfos = {}
    SelectShowInfo = {
        showSelect = false,
        isPlayer = false,
        content = ""
    }

    CurTalkNpcId = -1

    AutoRunFilter = Common.Functions.VectorToTable(MGlobalConfig:GetSequenceOrVectorInt("TaskAutoRunFilter"))

    TalkDlgBtnMoveStay = MGlobalConfig:GetFloat("TalkDlgBtnMoveStay", 1)
    TalkDlgBtnMoveSpeed = MGlobalConfig:GetFloat("TalkDlgBtnMoveSpeed", 10)
    TalkDlgBtnMoveExit = MGlobalConfig:GetFloat("TalkDlgBtnMoveExit", 1)

    FirstTalkTaskNpcID = MGlobalConfig:GetInt("FirstTalkTaskNpcID", -10000)
    SecondTalkTaskNpcID = MGlobalConfig:GetInt("SecondTalkTaskNpcID", -10000)

    ImportantTaskDic = {}
    local l_config = MGlobalConfig:GetSequenceOrVectorInt("ImportantTask")
    if l_config then
        for i = 1, l_config.Length do
            ImportantTaskDic[l_config[i - 1]] = true
        end
    end
end

function Logout()

    SelectInfos = {}
    SelectShowInfo = {
        showSelect = false,
        isPlayer = false,
        content = ""
    }

    PlotData = {}

    CurTalkNpcId = -1
end
