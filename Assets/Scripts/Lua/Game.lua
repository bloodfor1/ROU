---@class Game
local Game = class("Game")
declareGlobal("Game", Game)

function Game:ctor()
    self.authMgr = self:GetAuthMgr()
    self.payMgr = nil
end

--region 周期
function Game:Init()
    --初始化网络
    Network.Init()
    UIMgr:Init()
    MgrMgr:Init()
    DataMgr:Init()

    self.authMgr:OnInit()

    MgrMgr:GetMgr("SettingMgr").SyncVideoVolume()

    -- 注册Update事件
    UpdateBeat:Add(self.Update)
    logGreen("lua game inited")
end

function Game:Uninit()
    UIMgr:Uninit()
    MgrMgr:Uninit()

    self.authMgr:OnUninit()
end

function Game:Update()
    UIMgr:Update()
    MgrMgr:Update()
end

--endregion 周期

--region 场景(由C#驱动)
function Game:SwitchStage(stage, sceneID, activeIdx)
    if activeIdx then
        MStageMgr:SwitchTo(stage, sceneID, 0, activeIdx)
    else
        MStageMgr:SwitchTo(stage, sceneID)
    end
    MgrMgr:SwitchStage(stage, sceneID)
end

function Game:OnLeaveScene(sceneId)
    StageMgr:OnLeaveScene(sceneId)
    MgrMgr:OnLeaveScene(sceneId)
    GlobalEventBus:Dispatch(EventConst.Names.LeaveScene)
end

function Game:OnLeaveStage(stage)
    StageMgr:OnLeaveStage(stage)
    MgrMgr:OnLeaveStage(stage)
end

function Game:OnEnterStage(stage, toSceneId)
    StageMgr:OnEnterStage(stage, toSceneId)
    MgrMgr:OnEnterStage(stage)
end

function Game:OnSceneLoaded(sceneId)
    StageMgr:OnSceneLoaded(sceneId)
    MgrMgr:OnSceneLoaded(sceneId)
end

function Game:OnEnterScene(sceneId)
    StageMgr:OnEnterScene(sceneId)
    MgrMgr:OnEnterScene(sceneId)
    GlobalEventBus:Dispatch(EventConst.Names.EnterScene)
end

--因为需要协议数据，所以这个周期由lua协议触发
function Game:OnLuaDoEnterScene(msgInfo)
    StageMgr:OnLuaDoEnterScene(msgInfo)
    MgrMgr:OnLuaDoEnterScene(msgInfo)
end

--endregion 场景

--region UI
function Game:ShowMainPanel(excludes)
    local showPanel = {}
    table.insert(showPanel, UI.CtrlNames.Dialog)
    table.insert(showPanel, UI.CtrlNames.BattleArena)
    table.insert(showPanel, UI.CtrlNames.ChatRoomMini)
    table.insert(showPanel, UI.CtrlNames.TimeCountDown)
    table.insert(showPanel, UI.CtrlNames.TipsDlg)
    table.insert(showPanel, UI.CtrlNames.Danmu)

    if excludes ~= nil then
        if type(excludes) == "string" then
             table.insert(showPanel, excludes)
        else
            for i=1,#excludes do
                table.insert(showPanel, excludes[i])
            end
        end
    end

    UIMgr:ShowMainGroup(showPanel)

    if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.IsFishing then
        UIMgr:ActiveUI(UI.CtrlNames.FishMain)
    end

    if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.IsDead then
        UIMgr:ActiveUI(UI.CtrlNames.DeadDlg)
    end
end

function Game:ActiveMainPanels()
    local l_curStage = StageMgr:CurStage()
    l_curStage:ActiveMainPanels()

    if MgrMgr:GetMgr("TaskMgr").IsHaveNameTask() then
        UIMgr:ActiveUI(UI.CtrlNames.ModifyCharacterName)
    end

    if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.IsDead then
        UIMgr:ActiveUI(UI.CtrlNames.DeadDlg)
    end
end

function Game:IsLogout()
    if MPlayerInfo.UID==MLuaCommonHelper.ULong(0) then
        return true
    end
    if not StageMgr:CurStage():IsConcreteStage() then
        return true
    end
    if not MgrMgr:GetMgr("SelectRoleMgr").IsLogin() then
        return true
    end
    return false
end
--endregion

--region 登陆
---@return BaseAuthMgr
function Game:GetAuthMgr()
    if not self.authMgr then
        if MDevice.EnableSDKInterface("MSDKLogin") then
            logGreen("[Game:GetAuthMgr]MSDKAuthMgr")
            require("ModuleMgr/MSDKAuthMgr")
            self.authMgr = ModuleMgr.MSDKAuthMgr.new()
        elseif MDevice.EnableSDKInterface("JoyyouLogin") then
            logGreen("[Game:GetAuthMgr]JoyyouAuthMgr")
            require("ModuleMgr/JoyyouAuthMgr")
            self.authMgr = ModuleMgr.JoyyouAuthMgr.new()
        else
            logGreen("[Game:GetAuthMgr]PCAuthMgr")
            require("ModuleMgr/PCAuthMgr")
            self.authMgr = ModuleMgr.PCAuthMgr.new()
        end
    end
    return self.authMgr
end

--endregion

function Game:GetPayMgr()
    if not self.payMgr then
        if MDevice.EnableSDKInterface("MidasPay") then
            logGreen("[Game:GetPayMgr]MidasPayMgr")
            require("ModuleMgr/MidasPayMgr")
            self.payMgr = ModuleMgr.MidasPayMgr.new()
        elseif MDevice.EnableSDKInterface("JoyyouPay") then
            logGreen("[Game:GetPayMgr]JoyyouPayMgr")
            require("ModuleMgr/JoyyouPayMgr")
            self.payMgr = ModuleMgr.JoyyouPayMgr.new()
        else
            logGreen("[Game:GetPayMgr]BasePayMgr")
            require("ModuleMgr/BasePayMgr")
            self.payMgr = ModuleMgr.BasePayMgr.new()
        end
    end
    return self.payMgr
end