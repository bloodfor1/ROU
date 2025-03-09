module("ModuleMgr.SceneEnterMgr", package.seeall)

CurrentTeleportType = 0
CurrentMainUiTableData = {}
EventDispatcher = EventDispatcher.new()
LoadingProgress = "LoadingProgress"

--缓存一个SceneEnterData的引用
local l_sceneEnterData = DataMgr:GetData("SceneEnterData")

--发送进入场景消息
function RequestEnterScene(sceneId, roleID)
    local l_msgId = Network.Define.Ptc.EnterSceneReq
    ---@type SceneRequest
    local l_sendInfo = GetProtoBufSendTable("SceneRequest")
    l_sendInfo.sceneID = sceneId
    l_sendInfo.roleID = roleID or tostring(MPlayerInfo.UID)
    Network.Handler.SendPtc(l_msgId,l_sendInfo)
end

function ShowSceneName()

    if MSceneFirstInMgr:NeedRun() == true then
        return
    end
    local sceneTable = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    if sceneTable.MapEntryName == "" then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.MapNamePanel)

end

function ShowCopyDungeonTitle(val)

    if val then
        MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(GetColorText(Lang("ENTER_COPY_DUNGEON_TIPS"), RoColorTag.Yellow))
    else
        MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(GetColorText(Lang("EXIT_COPY_DUNGEON_TIPS"), RoColorTag.Yellow))
    end

end

function ShowEffect()

    if CurrentTeleportType==KKSG.TeleportType.KTeleportPointTypeKapula or MgrMgr:GetMgr("TransmissionMgr").IsUseButterfly then
        MgrMgr:GetMgr("TransmissionMgr").ShowEffectWithPlayerSelf(104)
        MgrMgr:GetMgr("TransmissionMgr").IsUseButterfly = false
        CurrentTeleportType = 0
    end

end

function OnEnterNormalScene()

    if not StageMgr:CurStage():IsConcreteStage() then
        return
    end

    if MgrMgr:GetMgr("DungeonMgr").PlayerInCopyDungeon and not MgrMgr:GetMgr("DungeonMgr").CheckPlayerInCopyDungeon() then
        ShowCopyDungeonTitle(false)
    else
        if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInCopyDungeon() then
            ShowCopyDungeonTitle(true)
        else
            ShowSceneName()
            ShowEffect()
        end
    end
    MgrMgr:GetMgr("DungeonMgr").PlayerInCopyDungeon = MgrMgr:GetMgr("DungeonMgr").CheckPlayerInCopyDungeon()

end

--重置场景的UI显示
--id为 MainUiTable 表的id
function ResetSceneUIWithId(id,keepActivedUIs)
    if CurrentMainUiTableData and id == CurrentMainUiTableData.Id then
        return
    end
    MgrMgr:GetMgr("MainUIMgr").ResetMainUICache()

    game:ShowMainPanel()

    SetMainPanelsWithId(id)

    local l_keepActivedGroupNames = {}
    if keepActivedUIs ~= nil then
        for i, uiName in ipairs(keepActivedUIs) do
            local l_groupName = UIGroupDefine:GetGroupName(uiName)
            table.insert(l_keepActivedGroupNames, l_groupName)
        end
    end

    local l_tipsGroupName = UIGroupDefine:GetGroupName(UI.CtrlNames.TipsDlg)
    if l_keepActivedGroupNames == nil or l_keepActivedGroupNames[l_tipsGroupName] == nil then
        table.insert(l_keepActivedGroupNames, l_tipsGroupName)
    end

    ShowMainUI(l_keepActivedGroupNames)
end

function SetMainPanelsWithId(id)

    l_sceneEnterData.ResetEnterSceneData()

    local l_mainUiTableData = TableUtil.GetMainUiTable().GetRowById(id)
    if l_mainUiTableData == nil then
        return
    end

    CurrentMainUiTableData = l_mainUiTableData

    for i = 1, l_mainUiTableData.MainLuaUi.Length do
        l_sceneEnterData.InsertDataToEnterScenePanels(l_mainUiTableData.MainLuaUi[i-1])
    end

    for i = 1, l_mainUiTableData.IndividualPanelNames.Length do
        l_sceneEnterData.InsertDataToIndividualPanelNames(l_mainUiTableData.IndividualPanelNames[i-1])
    end

end

function ShowMainUI(keepShowGroupNames)

    local l_panelNames = l_sceneEnterData.GetEnterScenePanels()
    local l_define= UIGroupDefine:CreateGroupDefine(UIMgr.MainPanelsGroupDefineName,l_panelNames)
    UIMgr:ExchangeGroup(l_define,nil,{
        GroupContainerType=UI.UILayer.Normal,
        IsTakePartInGroupStack=true
    })

    UIMgr:ShowMainGroupWithExcludeGroupNames(keepShowGroupNames)

    local l_individualPanelNames=l_sceneEnterData.GetIndividualPanelNames()

    for i = 1, #l_individualPanelNames do
        UIMgr:ActiveUI(l_individualPanelNames[i])
    end

end

function IsPanelCanShow(uiName)
    local l_panelNames = l_sceneEnterData.GetEnterScenePanels()
    return table.ro_contains(l_panelNames,uiName)
end

--MgrMgr调用
function OnEnterScene(sceneId)

    OnEnterNormalScene()
    --进入副本 处理一些数据逻辑
    MgrMgr:GetMgr("DungeonMgr").ReSetDungeonExtendData()
    MgrMgr:GetMgr("DungeonMgr").SetToThreeToThreeDungeonsMode()

end

function SetLoadingProgress(percent)
    EventDispatcher:Dispatch(LoadingProgress, percent)
end

function GetCurrentMainId()

    return CurrentMainUiTableData and CurrentMainUiTableData.Id or 0
end

return SceneEnterMgr