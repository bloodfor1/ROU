module("ModuleMgr", package.seeall)

---@class ModuleMgr.MgrMgr
MgrMgr = class("MgrMgr")
local l_mgrTable = {}
local l_mgrUpdateFuncTable = {}

function MgrMgr:ctor()
    self._initMap = {
        ["BagMgr"] = 1,
        ["BeginnerGuideMgr"] = 1,
        ["PhotoWallMgr"] = 1,
        ["GuildDinnerMgr"] = 1,
        ["LogoutMgr"] = 1,
        ["TitleStickerMgr"] = 1,
        ["RoleTagMgr"] = 1,
        ["BGMHouseMgr"] = 1,
        ["DeathGuideMgr"] = 1,
        ["RoleNurturanceMgr"] = 1,
        ["GuildDinnerMgr"] = 1,
        ["CatCaravanMgr"] = 1,
        ["ThemePartyMgr"] = 1,
        ["TaskMgr"] = 1,
        ["SelectEquipMgr"] = 1,
        ["StoneSculptureMgr"] = 1,
        ["LandingAwardMgr"] = 1,
        ["LevelRewardMgr"] = 1,
        ["SignInMgr"] = 1,
        ["DelegateModuleMgr"] = 1,
        ["BattleStatisticsMgr"] = 1,
        ["CookingDoubleMgr"] = 1,
        ["ForgeMgr"] = 1,
        ["TransmissionMgr"] = 1,
        ["EquipCardForgeHandlerMgr"] = 1,
        ["ChatMgr"] = 1,
        ["LifeProfessionMgr"] = 1,
        ["FishMgr"] = 1,
        ["ArrowMgr"] = 1,
        ["ThemeDungeonMgr"] = 1,
        ["NoticeMgr"] = 1,
        ["QuickUseMgr"] = 1,
        ["MonthCardMgr"] = 1,
        ["HeadSelectMgr"] = 1,
        ["GarderobeMgr"] = 1,
        ["TowerDefenseMgr"] = 1,
        ["MultiTalentEquipMgr"] = 1,
        ["ShortCutItemMgr"] = 1,
        ["OnceSystemMgr"] = 1,
        ["RedSignCheckMgr"] = 1,
        ["EquipMgr"] = 1,
        ["ItemContainerMgr"] = 1,
        ["VirtualItemMgr"] = 1,
        ["ItemUpdateCsMgr"] = 1,
        ["RecommendMapMgr"] = 1,
        ["EquipReformMgr"] = 1,
        ["EquipAssistGuideMgr"] = 1,
        ["RebateMonthCardMgr"] = 1,
        ["CommonDataMgr"] = 1,
        ["ItemCdMgr"] = 1,
        ["ShortCutItemAutoSetMgr"] = 1,
        ["ShopMgr"] = 1,
        ["ItemWeightMgr"] = 1,
        ["AdjustTrackerMgr"] = 1,
        ["CrashReportMgr"] = 1,
        ["IllustrationEquipAttrMgr"] = 1,
        ["ServerOnceSystemMgr"] = 1,
        ["BlessMgr"] = 1,
        ["ItemCountBroadCastMgr"] = 1,
        ["HeadShopMgr"] = 1,
        ["LimitMgr"] = 1,
        ["AutoDoseDrugMgr"] = 1,
        ["ProbabilityInfoMgr"] = 1,
        ["TotalRechargeAwardMgr"] = 1,
        ["AutoFightItemMgr"] = 1,
        ["BingoMgr"] = 1,
        ["ShareMgr"] = 1,
        ["ReBackMgr"] = 1,
        ["GiftPackageMgr"] = 1,
        ["CapraRewardMgr"] = 1,
        ["PlayerCustomDataMgr"] = 1,
        ["HeadFrameMgr"] = 1,
        ["DialogBgMgr"] = 1,
        ["ChatTagMgr"] = 1,
        ["EquipShardMgr"] = 1,
        ["PlayerInfoSyncMgr"] = 1,
        ["ItemResolveMgr"] = 1,
        ["ActivityNewKingMgr"] = 1,
        ["BattleMgr"] = 1,
        ["BeiluzCoreMgr"] = 1,
        ["DeadDlgMgr"] = 1,
        ["FestivalMgr"] = 1,
    }
end

--初始化MgrMgr，添加需要游戏进入时候就需要初始化的Mgr(例如事件监听)
function MgrMgr:Init()
    if nil == self._initMap then
        return
    end

    for mgrName, value in pairs(self._initMap) do
        PCallAndDebug(self.Regist, self,mgrName)
    end

end

function MgrMgr:Regist(mgrName)
    if l_mgrTable[mgrName] == nil then
        require("ModuleMgr/" .. mgrName)
        local l_mgr = ModuleMgr[mgrName]
        l_mgrTable[mgrName] = l_mgr

        local l_dataName = l_mgr.DataName
        local l_fileName = nil
        if l_dataName ~= nil then
            l_fileName = "ModuleData/" .. l_dataName
            if l_fileName ~= nil and not MLuaClientHelper.ExistLuaFile(l_fileName) then
                l_dataName = string.gsub(mgrName, "^(.-)Mgr$", "%1Data")
                logError("{0}.DataName = {1} does not exists File = {2} ,try to use Default DataName = {3} ", mgrName, l_mgr.DataName, l_fileName, l_dataName)
            end
        else
            l_dataName = string.gsub(mgrName, "^(.-)Mgr$", "%1Data")
        end

        l_fileName = "ModuleData/" .. l_dataName
        if MLuaClientHelper.ExistLuaFile(l_fileName) then
            local l_data = DataMgr:GetData(l_dataName)
            if l_data ~= nil and l_mgr ~= nil then
                --注意：以下代码导致mgr模块无法继承
                setmetatable(l_mgr, { __index = l_data, __newindex = function(t, k, v)
                    if rawget(l_data, k) ~= nil then
                        logError("请通过data层引用修改数据, example: DataMgr:GetData(\"{0}\").{1} = {2}", l_dataName, tostring(k), tostring(v))
                    end
                    rawset(l_mgr, k, v)
                end })
            end
        end
        if l_mgrTable[mgrName].OnInit ~= nil then
            l_mgrTable[mgrName].OnInit()
        end
        local l_updateFunc = l_mgrTable[mgrName].OnUpdate
        if l_updateFunc ~= nil then
            l_mgrUpdateFuncTable[mgrName] = l_updateFunc
        end
    end
end

---@return ModuleMgr.usefirststring
function MgrMgr:GetMgr(mgrName)
    self:Regist(mgrName)
    return l_mgrTable[mgrName]
end

function MgrMgr:Uninit()
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnUnInit ~= nil then
            PCallAndDebug(mgr.OnUnInit)
        end
    end
end

--Todo MgrMgr生命周期不对等 需要后面补上Login这个周期
function MgrMgr:Login()
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnLogin ~= nil then
            PCallAndDebug(mgr.OnLogin)
        end
    end
end

function MgrMgr:OnLogout()
    --UIMgr:OnLogout()
    DataMgr:OnLogout()
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnLogout ~= nil then
            PCallAndDebug(mgr.OnLogout)
        end
    end
end

function MgrMgr:OnReconnected(reconnectData)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnReconnected ~= nil then
            PCallAndDebug(mgr.OnReconnected,reconnectData)
        end
    end
    game:GetAuthMgr():OnReconnected(reconnectData)
    game:GetPayMgr():OnReconnected(reconnectData)
end

function MgrMgr:Update()
    for mgrName, updateFunc in pairs(l_mgrUpdateFuncTable) do
        if updateFunc ~= nil then
            PCallAndDebug(updateFunc)
        end
    end
end

function MgrMgr:SwitchStage(stage, sceneId)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnSwitchStage ~= nil then
            PCallAndDebug(mgr.OnSwitchStage,stage, sceneId)
        end
    end
end

--状态切换的时候 CS MStage->102
function MgrMgr:OnEnterStage(stage)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnEnterStage ~= nil then
            PCallAndDebug(mgr.OnEnterStage,stage)
        end
    end
end

function MgrMgr:OnLeaveStage(stage)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnLeaveStage ~= nil then
            PCallAndDebug(mgr.OnLeaveStage,stage)
        end
    end
end

--完成了资源等逻辑加载 彻底进入场景后  CS MScene->521
function MgrMgr:OnSceneLoaded(sceneId)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnSceneLoaded ~= nil then
            PCallAndDebug(mgr.OnSceneLoaded,sceneId)
        end
    end
end

function MgrMgr:OnLeaveScene(sceneId)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnLeaveScene ~= nil then
            PCallAndDebug(mgr.OnLeaveScene,sceneId)
        end
    end
end

function MgrMgr:OnLuaDoEnterScene(info)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnLuaDoEnterScene ~= nil then
            PCallAndDebug(mgr.OnLuaDoEnterScene,info)
        end
    end
end

function MgrMgr:OnEnterScene(sceneId)
    for mgrName, mgr in pairs(l_mgrTable) do
        if mgr.OnEnterScene ~= nil then
            PCallAndDebug(mgr.OnEnterScene,sceneId)
        end
    end
end

return ModuleMgr.MgrMgr