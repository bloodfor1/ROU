--转职用
module("CommandHandler", package.seeall)

local l_talkMgr = MgrMgr:GetMgr("NpcTalkDlgMgr")
local l_npcMgr = MgrMgr:GetMgr("NpcMgr")

local function customLog(...)
    logYellow(...)
end

function OnStartTalk(luaType, command, npcId)
    -- customLog("OnStartTalk", npcId)
    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        logRed("Spectator OnStartTalk")
        return
    end

    game:ShowMainPanel({UI.CtrlNames.TalkDlg2})

    l_talkMgr.SetShowInfo({block = command.Block})
    l_talkMgr.SetCurrentNpcId(npcId)

    l_talkMgr.ActiveTalkDlgOrBroadcastEvent()
    
    command:FinishCommand()
end

function OnStopTalk(luaType, command)
    if UIMgr:IsActiveUI(UI.CtrlNames.TalkDlg2) then
        UIMgr:DeActiveUI(UI.CtrlNames.TalkDlg2)
    end
    command:FinishCommand()
end

--与NPC对话
function OnTalkNpc(luaType, command, isPlayer, content)
    -- customLog("OnTalkNpc", isPlayer, content)

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        logRed("Spectator OnTalkNpc")
        return
    end

    game:ShowMainPanel({UI.CtrlNames.TalkDlg2})

    l_talkMgr.SetShowInfo({isPlayer = isPlayer, content = content, block = command.Block})

    l_talkMgr.ActiveTalkDlgOrBroadcastEvent({
        commandType = l_talkMgr.ECommandType.TalkNpc,
        command = command,
    })
end


function GetNpcSelectFuncs(selectNames, selectCallbacks, command, cancelBtnName)

    local l_nameTable = {}
    local l_callbackTable = {}
    for i = 0, selectNames.Count - 1 do
        table.insert(l_nameTable, selectNames[i])
        table.insert(l_callbackTable, function()
            l_talkMgr.OnNpcSelectForward(command, selectCallbacks[i])
        end)
    end

    if cancelBtnName ~= nil and cancelBtnName ~= "" then
        table.insert(l_nameTable, cancelBtnName)
        table.insert(l_callbackTable, function()
            l_talkMgr.OnNpcSelectQuit(command)
        end)
    end

    return l_nameTable, l_callbackTable
end

--NPC进行选择
function OnNpcSelect(luaType, command, isPlayer, content, selectNames, selectCallbacks, cancelBtnName, isNewPlot)
    -- customLog("OnNpcSelect", isPlayer, content, ToString(selectNames))

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        logRed("Spectator OnNpcSelect")
        return
    end

    local l_nameTable, l_callbackTable = GetNpcSelectFuncs(selectNames, selectCallbacks, command, cancelBtnName)

    game:ShowMainPanel({UI.CtrlNames.TalkDlg2})

    l_talkMgr.SetShowInfo({showSelect = true, isPlayer = isPlayer, content = content})
    l_talkMgr.AddSelectInfos(l_nameTable, l_callbackTable, false, l_npcMgr.NPC_SELECT_TYPE.NORMAL, isNewPlot)

    l_talkMgr.ActiveTalkDlgOrBroadcastEvent({
        commandType = l_talkMgr.ECommandType.NpcSelect,
        command = command,
        isNewPlot = isNewPlot,
    })
end

function OnShowSelect(luaType, command, isPlayer, content)

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        logRed("Spectator OnShowSelect")
        return
    end

    l_talkMgr.ShowSelect(command, isPlayer, content)
    command:FinishCommand()
end

function OnClearSelect(luaType, command)

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        logRed("Spectator OnClearSelect")
        return
    end
    
    l_talkMgr.ClearSelect(command)
    command:FinishCommand()
end

function OnPlotBranch(luaType, command, selectNames, tagList, emojiList)

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        logRed("Spectator OnPlotBranch")
        return
    end

    l_talkMgr.ClearPlotCache()
    for i = 0, selectNames.Count - 1 do

        local l_name = selectNames[i]
        local l_tag = tagList[i]
        local l_emoji = emojiList[i] or 0
        l_talkMgr.InsertDataToPlotCache({
            talkName = l_name,
            callBack = function()
                command.Block:GotoTag(l_tag)
            end,
            emojiId = l_emoji,
        })
    end
    
    UIMgr:ActiveUI(UI.CtrlNames.NewPlotBranch)
end

return CommandHandler