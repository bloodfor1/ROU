-- OnEnter=>ActiveMainPanels=>OnSceneLoaded=>OnEnterScene

module("Stage", package.seeall)

StageBase = class("StageBase")
--local l_keepActivedUis = {} --切到该场景需要保持打开的ui列表
local keepShowGroupNames={}

--缓存一个SceneEnterData的引用
local l_sceneEnterData = DataMgr:GetData("SceneEnterData")

function StageBase:ctor(emstage)
    self.sceneId = 0
    self.stage = emstage
    self.fromStage = MStageEnum.Null --标识是从哪个stage切过来的
end

function StageBase:OnLeaveScene(sceneId)
end

function StageBase:OnLeaveStage()
    local l_mainRoleInfoUi = UIMgr:GetUI(UI.CtrlNames.MainRoleInfo)
    if l_mainRoleInfoUi ~= nil then
        l_mainRoleInfoUi:HideBuffTips()
    end
    local l_dialog = UIMgr:GetUI(UI.CtrlNames.Dialog)
    if l_dialog ~= nil then
        UIMgr:DeActiveUI(UI.CtrlNames.Dialog)
    end
    MStatistics.GemAnalyseEnd()
end

function StageBase:OnEnterStage(toSceneId, fromStage)
    self.sceneId = toSceneId
    self.fromStage = fromStage
    self:InitMainPanel(toSceneId)

    local l_gameAuthData = game:GetAuthMgr().AuthData
    local tag = tostring(self.sceneId) .. self.stage:ToString()
    local serverId = l_gameAuthData.GetLoginAuthInfo().loginZoneId
    local l_loginServerInfo = l_gameAuthData.GetLoginServerLocal()
    MStatistics.GemAnalyseStart(CJson.encode({
        zoneid = serverId,
        tag = tag,
        roomip = l_loginServerInfo.ip .. ":" .. l_loginServerInfo.port
    }))

    --弹幕清理
    local l_danmu = UIMgr:GetUI(UI.CtrlNames.Danmu)
    if l_danmu then
        l_danmu:ReleaseDanmu(toSceneId)
    end
end

function StageBase:OnSceneLoaded(sceneId)
end

function StageBase:OnLuaDoEnterScene(msg)
end

function StageBase:OnEnterScene(sceneId)
end

--初始化ui，由OnEnter调用，有可能在子类被重写（比如非Concrete的stage）
function StageBase:InitMainPanel(sceneId)
    MgrMgr:GetMgr("MainUIMgr").ResetMainUICache()
    local l_isStatic = self:IsStaticStage(self.stage)
    if not l_isStatic or l_isStatic ~= self:IsStaticStage(self.fromStage) then
        --l_keepActivedUis = {}
        --UIMgr:ClearStack()

        keepShowGroupNames=UIMgr:GetKeepShowGroupNamesOnAllScene()
    else
        --l_keepActivedUis = self:_getActivedUIs()

        keepShowGroupNames=UIMgr:GetKeepShowGroupNamesOnSwitchScene()
    end

    l_sceneEnterData.ResetEnterSceneData()
    if not self:IsConcreteStage() then --非实体场景不处理mainui
        return
    end

    local l_sceneTableData = TableUtil.GetSceneTable().GetRowByID(sceneId)
    if l_sceneTableData == nil then
        logError("不存在的场景，SceneId={0}", sceneId)
        return
    end

    MgrMgr:GetMgr("SceneEnterMgr").SetMainPanelsWithId(l_sceneTableData.SceneUiId)

end

function StageBase:ActiveMainPanels()
    self:AddKeepActiveUI(UI.CtrlNames.Dialog)
    self:AddKeepActiveUI(UI.CtrlNames.TipsDlg)
    self:AddKeepActiveUI(UI.CtrlNames.Loading)
    self:AddKeepActiveUI(UI.CtrlNames.ChatRoomMini)
    self:AddKeepActiveUI(UI.CtrlNames.FishMain)
    self:AddKeepActiveUI(UI.CtrlNames.Vehicle)
    self:AddKeepActiveUI(UI.CtrlNames.MainTargetInfo)
    self:AddKeepActiveUI(UI.CtrlNames.SceneObjController)
    --MgrMgr:GetMgr("SceneEnterMgr").ShowMainUI(l_keepActivedUis)
    MgrMgr:GetMgr("SceneEnterMgr").ShowMainUI(keepShowGroupNames)

end

--function StageBase:AddKeepActiveUI(uiName)
--    table.insert(l_keepActivedUis, uiName)
--end
--
--function StageBase:RemoveKeepActiveUI(uiName)
--    table.ro_removeValue(l_keepActivedUis, uiName)
--end

function StageBase:AddKeepActiveUI(uiName)
    local l_groupName= UIGroupDefine:GetGroupName(uiName)
    table.insert(keepShowGroupNames, l_groupName)
end

function StageBase:RemoveKeepActiveUI(uiName)
    local l_groupName= UIGroupDefine:GetGroupName(uiName)
    table.ro_removeValue(keepShowGroupNames, l_groupName)
end

function StageBase:IsConcreteStage()
    return self.stage == MStageEnum.Hall or
        self.stage == MStageEnum.Wild or
        self.stage == MStageEnum.Dungeon or
        self.stage == MStageEnum.ArenaPre or
        self.stage == MStageEnum.Arena or
        self.stage == MStageEnum.Cooking or
        self.stage == MStageEnum.BattlePre or
        self.stage == MStageEnum.Battle or
        self.stage == MStageEnum.RingPre or
        self.stage == MStageEnum.Ring or
        self.stage == MStageEnum.MatchPre or
        self.stage == MStageEnum.Match
end

function StageBase:IsStaticStage(stage)
    return stage == MStageEnum.Hall or
        stage == MStageEnum.Wild
end

--function StageBase:_getActivedUIs()
--    local l_ret = {}
--    for k, v in pairs(UIMgr.activedCtrls) do
--        local l_isContains = false
--        for i, v1 in ipairs(l_sceneEnterData.GetEnterScenePanels()) do
--            if k == v1 then
--                l_isContains = true
--                break
--            end
--        end
--        --UIMgr.isSwitchSceneCloseUIs[k] 有些UI切场景不需要打开 这里做了一个判断
--        if not l_isContains and not UIMgr.isSwitchSceneCloseUIs[k] then
--            table.insert(l_ret, k)
--        end
--    end
--    return l_ret
--end

return StageBase