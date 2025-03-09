module("MUIEvent", package.seeall)

local luaTypeCallback =
{
    --["ENUM_UI_SHOW_ROLE_INFO"]         = {file = "ModuleMgr/RoleInfoMgr",          func = "ModuleMgr.RoleInfoMgr.OnShowRoleInfo(...)",},
    --["ENUM_UI_SHOW_ROLE_ATTR_CHANGE"]  = {file = "ModuleMgr/RoleInfoMgr",          func = "ModuleMgr.RoleInfoMgr.OnShowRoleAttrChange(...)",},
    ["ENUM_UI_LONGCLICK_SKILL_SLOT"]  = {file = "ModuleMgr/SkillLearningMgr",          func = "ModuleMgr.SkillLearningMgr.OnLongClickSkillSlot(...)",},
    ["ENUM_UI_UP_SKILL_SLOT"]  = {file = "ModuleMgr/SkillLearningMgr",          func = "ModuleMgr.SkillLearningMgr.OnUpSkillSlot(...)",},
    ["ENUM_TRY_FIX_CASTINGOFFSET"]  = {file = "ModuleMgr/BeachMgr",          func = "ModuleMgr.BeachMgr.OnTryFixCastingOffset(...)",},
    ["ENUM_UI_HIDE_SKILL_SLOT_TIP"]  = {file = "ModuleMgr/SkillLearningMgr",          func = "ModuleMgr.SkillLearningMgr.OnCloseSlot(...)",},
    ["ENUM_UI_ON_TASK_CLOSE_TARGET"]   = {file = "ModuleMgr/NpcMgr",              func = "ModuleMgr.NpcMgr.GotoNpc(...)",},
    ["ENUM_UI_PLAYER_LV_CHANGE"]     = {file = "ModuleMgr/TaskMgr",              func = "ModuleMgr.TaskMgr.TaskInfoUpdateByLevelUp(...)",},
    ["ENUM_UI_STOP_AUTOBATTLE"]     = {file = "ModuleMgr/FightAutoMgr",              func = "ModuleMgr.FightAutoMgr.CloseFightAuto(...)",},
    ["ENUM_UI_ON_MYPLAYER_STOP_MOVE"] = {file = "ModuleMgr/TaskMgr",              func = "ModuleMgr.TaskMgr.OnMyPlayerStopMove(...)",},
    ["ENUM_UI_ON_TASK_START_AUTO_FIGHT"] = {file = "ModuleMgr/FightAutoMgr",      func = "ModuleMgr.FightAutoMgr.StartFightAuto(...)",},
    ["ENUM_UI_VEHICLE_RIDE"]  = {file = "ModuleMgr/VehicleMgr",          func = "ModuleMgr.VehicleMgr.RideVehicle(...)",},
    ["ENUM_UI_VEHICLE_RIDE_PASSENGER"]  = {file = "ModuleMgr/VehicleMgr",          func = "ModuleMgr.VehicleMgr.PassangerRideVehicle(...)",},
    ["ENUM_UI_VEHICLE_REQ_UNRIDE_VEHICLE"]  = {file = "ModuleMgr/VehicleMgr",          func = "ModuleMgr.VehicleMgr.RequestUnRideVehicle(...)",},
    ["ENUM_UI_SHOW_PHOTOGRAPH"]  = {file = "ModuleMgr/TaskMgr",          func = "ModuleMgr.TaskMgr.OpenShowPhotograph(...)",},
    ["ENUM_UI_SHOW_INFINITE_TOWER_REWARD"]  = {file = "ModuleMgr/InfiniteTowerDungeonMgr",          func = "ModuleMgr.InfiniteTowerDungeonMgr.ShowInfiniteTowerReward(...)",},
    ["ENUM_UI_OPEN_GUILDSHOP"] = {file = "ModuleMgr/ShopMgr",          func = "ModuleMgr.ShopMgr.OpenGuildShopEvent(...)",},
    ["ENUM_UI_CLOSE_SELFY"] = {func = function() UIMgr:DeActiveUI(UI.CtrlNames.Photograph) end},
    ["ENUM_UI_IS_SYSTEM_OPEN"] = {file = "ModuleMgr/OpenSystemMgr",     func = function(luaTable, id) return ModuleMgr.OpenSystemMgr.IsSystemOpen(id) end},
    ["ENUM_UI_OPEN_SYSTEM_INFO"] = {file = "ModuleMgr/OpenSystemMgr",     func = function(luaTable, id) return ModuleMgr.OpenSystemMgr.GetOpenSystemTipsInfo(id) end},
    ["ENUM_UI_ON_SCENE_OBJECT_START"] = {file = "ModuleMgr/TaskMgr", func = "ModuleMgr.TaskMgr.TaskSceneObjectStart(...)",},
    ["ENUM_UI_ON_SCENE_OBJECT_STOP"] = {file = "ModuleMgr/TaskMgr", func = "ModuleMgr.TaskMgr.TaskSceneObjectStop(...)",},
    ["ENUM_UI_ON_UPDATE_MONSTER_NUM"] = {file = "ModuleMgr/DungeonMgr", func = "ModuleMgr.DungeonMgr.OnUpdateMonsterNum(...)",},
    ["ENUM_UI_SELECT_PRO_ID"] = {file = "ModuleMgr/TaskMgr", func = "ModuleMgr.TaskMgr.RequestTaskTrialChoice(...)",},
    ["ENUM_UI_ON_STOP_AUTO_FIGHT"] = {file = "ModuleMgr/MainUIMgr", func = "ModuleMgr.MainUIMgr.OnStopAutoFight(...)",},
    ["ENUM_UI_ON_GET_SHAKE_DATA"] = {file = "ModuleMgr/SmallGameMgr", func = "ModuleMgr.SmallGameMgr.OnReceiveShakeData(...)",},
    --装备破坏
    ["ENUM_UI_ON_DISABLE_OR_ENABLE_EQUIPS"]  = {file = "ModuleMgr/SkillDestroyEquipMgr",func = "ModuleMgr.SkillDestroyEquipMgr.OnSkillDestroyEquipEvent(...)",},
    --生活技能
    ["ENUM_UI_ON_COOKING_SINGLE"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.ClickWindowBtn(...)",},
    ["ENUM_UI_ON_DRUG"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.ClickWindowBtn(...)",},
    ["ENUM_UI_ON_SWEET"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.ClickWindowBtn(...)",},
    ["ENUM_UI_ON_SMELT"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.ClickWindowBtn(...)",},
    ["ENUM_UI_ON_FOODFUSION"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.ClickWindowBtn(...)",},
    ["ENUM_UI_ON_MEDICINEFUSION"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.ClickWindowBtn(...)",},
    --采集
    ["ENUM_UI_ON_COLLECT_START"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.CollectStart(...)",},
    ["ENUM_UI_ON_COLLECT_END"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.CollectEnd(...)",},
    --钓鱼
    ["ENUM_UI_ON_ENTER_FISHING"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnEnterFishing(...)",},
    ["ENUM_UI_ON_EXIT_FISHING"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnExitFishing(...)",},
    ["ENUM_UI_ON_SHOW_PULL_ROD_TIP"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnShowPullRodTip(...)",},
    ["ENUM_UI_ON_CLOSE_PULL_ROD_TIP"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnClosePullRodTip(...)",},
    ["ENUM_UI_ON_SHOW_FISH_EVENT"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnShowFishEvent(...)",},
    ["ENUM_UI_ON_END_AUTO_FISHING"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnEndAutoFishing(...)",},
    ["ENUM_UI_ON_THROW_FISHING"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnThrowFishing(...)",},
    ["ENUM_UI_ON_SUCCEED_UP_FISHING"] = {file = "ModuleMgr/FishMgr", func = "ModuleMgr.FishMgr.OnSucceedUpFishing(...)",},
    --技能
    ["ENUM_UI_ON_OPEN_SKILL_SETTING"] = {file = "ModuleMgr/SkillLearningMgr", func = "ModuleMgr.SkillLearningMgr.OnOpenSkillSetting(...)"},
    ["ENUM_UI_ON_SHOW_NEW_BUFF_SKILL"] = {file = "ModuleMgr/CommonShowOpenItemMgr", func = "ModuleMgr.CommonShowOpenItemMgr.OnShowBuffSkill(...)"},
    --新手引导
    ["ENUM_UI_CHECK_SHOW_BEGINNER_GUIDE"] = {file = "ModuleMgr/BeginnerGuideMgr", func = "ModuleMgr.BeginnerGuideMgr.CheckShowBeginnerGuideFromCS(...)",},
    ["ENUM_UI_CHECK_SHOW_BEGINNER_GUIDE_WITH_ARRAY"] = {file = "ModuleMgr/BeginnerGuideMgr", func = "ModuleMgr.BeginnerGuideMgr.CheckShowBeginnerGuideFromCSWithArray(...)",},
    ["ENUM_UI_ON_GUIDE_OVER"] = {file = "ModuleMgr/BeginnerGuideMgr", func = "ModuleMgr.BeginnerGuideMgr.OnOneGuideOverFormCS(...)",},
    --公会华丽水晶点击
    ["ENUM_UI_OPEN_GUILD_CRYSTAL"] = {file = "ModuleMgr/SystemFunctionEventMgr", func = "ModuleMgr.SystemFunctionEventMgr.OpenGuildCrystalEvent(...)",},
    --宝藏猎人勘测器点击
    ["ENUM_UI_OPEN_TREASURE_HUNTER"] = {file = "ModuleMgr/SystemFunctionEventMgr", func = "ModuleMgr.SystemFunctionEventMgr.OpenTreasureHunterInfo(...)",},
    --公会狩猎进入副本事件
    ["ENUM_UI_ENTER_GUILD_HUNT_DUNGEONS"] = {file = "ModuleMgr/GuildHuntMgr", func = "ModuleMgr.GuildHuntMgr.ReqEnterGuildHuntDungeon(...)",},
    ["ENUM_UI_GET_GUILD_HUNT_PORTAL_INFO"] = {file = "ModuleMgr/GuildHuntMgr", func = "ModuleMgr.GuildHuntMgr.GetGuildHuntPortalInfo(...)",},
    --照片墙新手指引相关
    ["ENUM_UI_GET_ENTER_AUTO_CAMERA_TRIGGER"] = {file = "ModuleMgr/PhotoWallMgr", func = "ModuleMgr.PhotoWallMgr.GetEnterAutoCameraTriggerId(...)",},
    ["ENUM_UI_TRIGGER_CAMERA_MOVE_OVER"] = {file = "ModuleMgr/PhotoWallMgr", func = "ModuleMgr.PhotoWallMgr.GetTriggerCameraMoveOver(...)",},
    ["ENUM_UI_GET_EXIT_AUTO_CAMERA_TRIGGER"] = {file = "ModuleMgr/PhotoWallMgr", func = "ModuleMgr.PhotoWallMgr.GetExitTriggerAutoCamera(...)",},
    --NPC消失监听
    ["ENUM_UI_ON_NPC_DESTORY"] = {file = "ModuleMgr/NpcMgr", func = "ModuleMgr.NpcMgr.OnNpcDestory(...)",},
    --寻路
    ["ENUM_UI_REQ_NAVIGATE"] = {file = "Common/CommonUIFunc", func = "Common.CommonUIFunc.ReqNavigateStartCountDown(...)",},
    ["ENUM_UI_GET_NAVIGATE_RESULT"] = {file = "Common/CommonUIFunc", func = "Common.CommonUIFunc.GetNavigateResult(...)",},
    --UIMgr
    ["ENUM_UI_SHOW_NORMAL_TIPS"] = {func = function(luaTable, tip) MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tip) end},

    ["ENUM_BOSS_TARGET_CHANGE"] = {file = "ModuleMgr/PlayerInfoMgr", func = "ModuleMgr.PlayerInfoMgr.SetTargetTargetName(...)",},

    --Used for Command System Internal
    ["ENUM_COMMAND_NPC_TLAK"] = {file = "Event/CommandHandler",          func = "CommandHandler.OnTalkNpc(...)",},
    ["ENUM_COMMAND_NPC_SELECT"] = {file = "Event/CommandHandler",          func = "CommandHandler.OnNpcSelect(...)",},
    ["ENUM_COMMAND_START_TLAK"] = {file = "Event/CommandHandler",          func = "CommandHandler.OnStartTalk(...)",},
    ["ENUM_COMMAND_STOP_TLAK"] = {file = "Event/CommandHandler",          func = "CommandHandler.OnStopTalk(...)",},
    ["ENUM_COMMAND_SHOW_SELECT"] = {file = "Event/CommandHandler",          func = "CommandHandler.OnShowSelect(...)",},
    ["ENUM_COMMAND_CLEAR_SELECT"] = {file = "Event/CommandHandler",          func = "CommandHandler.OnClearSelect(...)",},
    ["ENUM_COMMAND_HANDLE_COMMON_LUA_COMMAND"] = {file = "Command/CommandConst", func = "CommandConst.CallHandleCommand(...)"},
    ["ENUM_COMMAND_FINISH_COMMON_LUA_COMMAND"] = {file = "Command/CommandConst", func = "CommandConst.CallFinishCommand(...)"},
    ["ENUM_COMMAND_UNINIT_COMMON_LUA_COMMAND"] = {file = "Command/CommandConst", func = "CommandConst.CallUninitCommand(...)"},
    ["ENUM_COMMAND_THEME_DUNGEON_NPC"] = {file = "ModuleMgr/ThemeDungeonMgr", func = "ModuleMgr.ThemeDungeonMgr.OnNpcSelect(...)" },
    ["ENUM_COMMAND_THEME_DUNGEON_BOX_NPC"] = {file = "ModuleMgr/ThemeDungeonMgr", func = "ModuleMgr.ThemeDungeonMgr.OnBoxSelect(...)" },
    ["ENUM_COMMAND_PLOT_BRANCH"] = {file = "Event/CommandHandler",          func = "CommandHandler.OnPlotBranch(...)",},

    --From Command System RunLuaCommand for logic
    ["ENUM_COMMAND_SELECT_INFINITE_TOWER_LEVEL"] = {file = "ModuleMgr/InfiniteTowerDungeonMgr", func = "ModuleMgr.InfiniteTowerDungeonMgr.OnSelectLevel(...)",},
    ["ON_THEME_DUNGEONS_PROMPT"] = {file = "ModuleMgr/DungeonMgr", func = "ModuleMgr.DungeonMgr.OnThemeDungeonsPrompt(...)",},

    ["COLLECT_COUNT_OVER"] = {file = "ModuleMgr/LifeProfessionMgr", func = "ModuleMgr.LifeProfessionMgr.OnCollectRequest(...)",},
    ["ONMESSAGE"] = {file = "ModuleMgr.MessageRouterMgr", func = "ModuleMgr.MessageRouterMgr.OnMessageFromClient(...)"},
    ["CHANGE_SKILL_OPERATION"] = {file = "ModuleMgr.ArrowMgr", func = "ModuleMgr.ArrowMgr.OnChangeSkillOperation(...)"},

    ["OPEN_PHOTO_WALL"] = {file = "ModuleMgr/PhotoWallMgr", func = function(func, groupName, index) ModuleMgr.PhotoWallMgr.ShowPhotoWallWithGroupId(groupName, index) end},
    ["OPEN_PHOTO_WALL_PLAYER"] = {file = "ModuleMgr/PhotoWallMgr", func = function(func, groupName, index) ModuleMgr.PhotoWallMgr.ShowPhotoWallPlayerWithGroupId(groupName, index) end},
    ["COUNT_DOWN_TAKE_PHOTO"] = {file = "ModuleMgr/CountDownTakePhotoMgr", func = function(luaType, openUI, cameraObj, autoSave, face, triggerRunResultTask, moveTime) ModuleMgr.CountDownTakePhotoMgr.BeginCountTakePhoto(openUI, cameraObj, autoSave, face, triggerRunResultTask, moveTime) end},
    ["CANCEL_COUNT_DOWN_TAKE_PHOTO"] =  {file = "ModuleMgr/CountDownTakePhotoMgr", func = function(triggerRunResultTask) ModuleMgr.CountDownTakePhotoMgr.StopCountDownTakePhotoByTrigger(triggerRunResultTask) end},
    ["OPEN_BGM_HOUSE_PLAYER"] = {file = "ModuleMgr/BGMHouseMgr", func = "ModuleMgr.BGMHouseMgr.OpenBGMHousePlayer(...)" },

    ["SCENARIO_GRADE"] = {file = "ModuleMgr/FashionRatingMgr", func = "ModuleMgr.FashionRatingMgr.ScenarioGrade(...)" },
    ["SCENARIO_START"] = {file = "ModuleMgr/FashionRatingMgr", func = "ModuleMgr.FashionRatingMgr.ScenarioStart(...)" },
    ["SCENARIO_PHOTO"] = {file = "ModuleMgr/FashionRatingMgr", func = "ModuleMgr.FashionRatingMgr.ScenarioPhotograph(...)" },
    ["OPEN_THEMEDUNGEON_UI"] = {file = "ModuleMgr/ThemeDungeonMgr", func = "ModuleMgr.ThemeDungeonMgr.OnSelectCollectionEvent(...)" },
    ["EXCHANGE_THEME_COIN"] = {file = "ModuleMgr/ThemePartyMgr", func = "ModuleMgr.ThemePartyMgr.ExchangeThemeCoin(...)" },
    ["AUTOFIGHTGUIDE"] = {file = "ModuleMgr/FightAutoMgr", func = "ModuleMgr.FightAutoMgr.CheckGuide(...)" },
    ["FINISH_CLIENT_ACHIEVEMENT"] = {file="ModuleMgr/AchievementMgr", func = function(luatype, id, type) MgrMgr:GetMgr("AchievementMgr").ClientFinishAchievement(id, type) end},

    ["OPEN_MERCHANT_SHOP"] = {file = "ModuleMgr/MerchantMgr", func = function() MgrMgr:GetMgr("MerchantMgr").OpenMerchantShopEvent() MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg() end },
    ["BUY_MERCHANT_EVENT"] = {file = "ModuleMgr/MerchantMgr", func = function() MgrMgr:GetMgr("MerchantMgr").RequestMerchantEventPreBuy() MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg() end },
    ["ENUM_UI_NOTIFY_MERCHANT_CANNOT_TELEPORT"] = {file = "ModuleMgr/MerchantMgr", func = function() MgrMgr:GetMgr("MerchantMgr").NotifyCannotTeleport() end },

    ["TOWER_DEFENSE_ENTER_SUMMON_CIRCLE"] = {file = "ModuleMgr/TowerDefenseMgr", func = "ModuleMgr.TowerDefenseMgr.OnEnterSummonCircle(...)" },
    ["TOWER_DEFENSE_LEAVE_SUMMON_CIRCLE"] = {file = "ModuleMgr/TowerDefenseMgr", func = "ModuleMgr.TowerDefenseMgr.OnLeaveSummonCircle(...)" },
    ["ENUM_COMMAND_OPEN_MAIN_TOWER_DEFENSE"] = {file = "ModuleMgr/TowerDefenseMgr", func = "ModuleMgr.TowerDefenseMgr.OpenTowerDefenseSpirit(...)" },
    ["ENUM_COMMAND_WORLD_EVENT_HOW_TO_PLAY"] =
    {
        func = function( luaType,tipsId,arg)
            MgrMgr:GetMgr("WorldPveMgr").WorldEventHotToPlay(tonumber(arg[1].Value))
        end
    },
    ["ENUM_COMMAND_WORLD_EVENT_NOT_OPEN"] =
    {
        func = function( )
            MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.WorldPve))
        end
    },

    ["SHOW_RECONNECTING"] = {
        func = function()
            CommonUI.Dialog.ShowReConnecting()
        end
    },
    ["HIDE_RECONNECTING"] = {
        func = function()
            CommonUI.Dialog.HideReConnecting()
        end
    },
    ["SHOW_WAITING"] = {
        func = function()
            CommonUI.Dialog.ShowWaiting()
        end
    },
    ["HIDE_WAITING"] = {
        func = function()
            CommonUI.Dialog.HideWaiting()
        end
    },
    ["LOADING_START"] = {
        file = "ModuleMgr/LoadingMgr",
        func = function(luaType, sceneId, bgIdx)
            MgrMgr:GetMgr("LoadingMgr").OnLoadingStart(sceneId, bgIdx)
        end
    },
    ["LOADING_END"] = {
        file = "ModuleMgr/LoadingMgr",
        func = function()
            MgrMgr:GetMgr("LoadingMgr").OnLoadingEnd()
        end
    },
    ["LOADING_PRELOAD"] = {
        file = "ModuleMgr/LoadingMgr",
        func = function(luaType, ...)
            MgrMgr:GetMgr("LoadingMgr").StartPreload(...) 
        end
    },
    ["ARROW_REFRESH"] = {
        file = "ModuleMgr/ArrowMgr",
        func = function()
            MgrMgr:GetMgr("ArrowMgr").RefreshArrowPanel()
            MgrMgr:GetMgr("RoleInfoMgr").OnTransFigure()
        end
    },
    ["CHECK_STUCK"] = {
        func = function(luaType, stuck)
            local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")
            if stuck then
                EventDispatcher.Dispatch(l_mainUIMgr.EventDispatcher,l_mainUIMgr.ON_ENTER_STUCK)
            else
                EventDispatcher.Dispatch(l_mainUIMgr.EventDispatcher,l_mainUIMgr.ON_EXIT_STUCK)
            end
        end
    },
    ["CHANGE_SHOW_MAP"] = {
        func = function(_,recover,sceneId,mapInfoIndex)
            local l_recover=true
            local l_sceneId=0
            local l_mapInfoIndex=0
            if type(recover) == "userdata" then --场景触发器传过来的是个数组结构
                l_recover=recover[0]=="true" and true or false
                l_sceneId=tonumber(recover[1])
                l_mapInfoIndex=tonumber(recover[2])
            else   --正常调用传过来的是3个值
                l_recover= recover=="true" and true or false
                l_sceneId=sceneId
                l_mapInfoIndex=mapInfoIndex
            end
            local l_mapInfoMgr=MgrMgr:GetMgr("MapInfoMgr")
            l_mapInfoMgr.OnUpdateMapBg(l_recover,l_sceneId,l_mapInfoIndex)
        end
    },
    ["ENUM_COMMAND_REQUEST_TASK_ACCEPT"] = {
        func = function(_, _, arg)
            local l_taskId = tonumber(arg[1].Value)
            local l_subTask = nil
            if (arg.Count > 2) then
                l_subTask = tonumber(arg[2].Value)
            end
            MgrMgr:GetMgr("TaskMgr").RequestTaskAccept(l_taskId, l_subTask)
        end
    },
    ["ON_SCROLL_SCREEN"] = {
        func = function(value,data)
            SendLuaEvent(EventConst.Names.ScrollOperation,data)
        end
    },
    ["ADD_MAP_EFFECT"] = {
        func = function(_,effectId,mapObjData)
            local l_mapInfoMgr=MgrMgr:GetMgr("MapInfoMgr")
            l_mapInfoMgr.EventDispatcher:Dispatch(l_mapInfoMgr.EventType.AddMapEffect,effectId,mapObjData)
        end
    },
    ["REMOVE_MAP_EFFECT"] = {
        func = function(_,effectId,isAll)
            local l_mapInfoMgr=MgrMgr:GetMgr("MapInfoMgr")
            l_mapInfoMgr.EventDispatcher:Dispatch(l_mapInfoMgr.EventType.RmMapEffect,effectId,isAll)
        end
    },
    ["UPGRADE_BASE_LEVEL"] = {file = "ModuleMgr/GmMgr", func = function() MgrMgr:GetMgr("GmMgr").RequestUpgradeLevel(true) end },
    ["UPGRADE_JOB_LEVEL"] = {file = "ModuleMgr/GmMgr", func = function() MgrMgr:GetMgr("GmMgr").RequestUpgradeLevel(false) end },

    --处理主界面技能盘显示等逻辑
    ["EVENT_UI_SKILL_SHOW_SKILL_CONTROLLER"] = {
        file = "ModuleMgr/SkillControllerMgr",
        func = function() MgrMgr:GetMgr("SkillControllerMgr").ShowSkillController() end
    },
    ["EVENT_UI_SKILL_HIDE_SKILL_CONTROLLER"] = {
        file = "ModuleMgr/SkillControllerMgr",
        func = function() MgrMgr:GetMgr("SkillControllerMgr").HideSkillController() end
    },
    ["EVENT_UI_SKILL_MAIN_PANEL_SHOW_SKILL"] = {
        file = "ModuleMgr/SkillControllerMgr",
        func = function() MgrMgr:GetMgr("SkillControllerMgr").MainPanelShowSkill() end
    },

    --处理移动摇杆
    ["EVENT_UI_MOVE_SHOW_MOVE_CONTROLLER"] = {
        file = "ModuleMgr/MoveControllerMgr",
        func = function() MgrMgr:GetMgr("MoveControllerMgr").ShowMoveController() end
    },
    ["EVENT_UI_MOVE_HIDE_MOVE_CONTROLLER"] = {
        file = "ModuleMgr/MoveControllerMgr",
        func = function() MgrMgr:GetMgr("MoveControllerMgr").HideMoveController() end
    },

    ["EVENT_UI_REVIVE"] = {
        file = "ModuleMgr/DeadDlgMgr",
        func = function() MgrMgr:GetMgr("DeadDlgMgr").OnRevive() end
    },

    -- sdk start
    ["ON_SDK_LOGIN_CALLBACK"] = {
        func = function(_, data)
            game:GetAuthMgr():OnSDKAuth(data)
        end
    },

    ["ON_SDK_PAY_CALLBACK"] = {
        func = function(_, data)
            game:GetPayMgr():OnSDKPay(data)
        end
    },

    ["ON_SDK_PUSH_NOTIFICATION"] = {
        func = function(_, data)
            logGreen(data)
        end
    },

    ["ON_SDK_PUSH_TOKEN_CALLBACK"] = {
        file = "ModuleMgr/SettingMgr",
        func = function(_,token) MgrMgr:GetMgr("SettingMgr").SetSDKPushToken(token) end
    },

    ["ON_SDK_SHARE_CALLBACK"] = {
        func = function(_, data)
            MgrMgr:GetMgr("ShareMgr").OnSDKShareCallback(data)
        end
    },

    ["ON_SDK_GET_USER_INFO_CALLBACK"] = {
        func = function(_, data)
            game:GetAuthMgr().AuthData.SetSDKUserInfo(data)
            game:GetAuthMgr().EventDispatcher:Dispatch(EventConst.Names.ON_SDK_GET_USER_INFO_CALLBACK)
        end
    },

    ["ON_SDK_BIND_ACCOUNT_CALLBACK"] = {
        func = function(_, data)
            game:GetAuthMgr().EventDispatcher:Dispatch(EventConst.Names.ON_SDK_BIND_ACCOUNT_CALLBACK, data)
        end
    },

    ["ON_SDK_PAY_REWARD_INFO_CALLBACK"] = {
        func = function(_, data)
            local l_payMgr = game:GetPayMgr()
            l_payMgr:FireEvent(l_payMgr.ON_EVENT_GET_REWARD_INFO, data)
        end
    },

    ["ON_SDK_PAY_NEEDLOGIN_CALLBACK"] = {
        func = function(_, data)
            local l_payMgr = game:GetPayMgr()
            l_payMgr:FireEvent(l_payMgr.ON_SDK_PAY_NEEDLOGIN_CALLBACK, data)
        end
    },

    ["ON_SCREEN_SHOT"] = {
        func = function(_, data)
            MgrMgr:GetMgr("ShareMgr").OnScreenShot(data)
        end
    },
    -- sdk end

    --处理场景交互
    ["EVENT_UI_SCENE_OBJ_CONTROLLER_ACTIVE_UI"] = {
        file = "ModuleMgr/SceneObjControllerMgr",
        func = function(_,info) MgrMgr:GetMgr("SceneObjControllerMgr").OnActiveUIEvent(info) end
    },

    ["EVENT_UI_SCENE_OBJ_CONTROLLER_DeACTIVE_UI"] = {
        file = "ModuleMgr/SceneObjControllerMgr",
        func = function(_,info) MgrMgr:GetMgr("SceneObjControllerMgr").OnDeActiveUIEvent(info) end
    },

    ["EVENT_UI_SCENE_OBJ_CONTROLLER_SET_PROGRESS_TIME"] = {
        file = "ModuleMgr/SceneObjControllerMgr",
        func = function(_,sceneObjInfo) MgrMgr:GetMgr("SceneObjControllerMgr").OnSetProgressTimeEvent(sceneObjInfo) end
    },
    ["EVENT_UI_ACTIVE_STORYBOARD"] = {
        func = function(_,args)
            local l_storyboardId = args[0]
            if l_storyboardId == nil then
                logError("EVENT_UI_ACTIVE_STORYBOARD  args error !")
                return
            end
            UIMgr:ActiveUI(UI.CtrlNames.StoryBoard,{storyBoardId = tonumber(l_storyboardId ),callback = nil,args = nil})
        end
    },
    ["EVENT_ON_KEY_ESCAPE"] = {
        func = function()
            if UIMgr:GoBack() then
                return
            end

            local stageEnum = StageMgr:GetCurStageEnum()
            if stageEnum == MStageEnum.SelectChar then
                game:GetAuthMgr():LogoutToGame()
                --UIMgr:ActiveUI(UI.CtrlNames.Login)
                UIMgr:DeActiveUI(UI.CtrlNames.SelectChar)
                return
            end

            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("CONFIRM_CLOSE_GAME"), function()
                MDevice.QuitApplication()
            end)
        end
    },
    ["OpenBlackCurtainByTimeline"] = {
        func = function(_, arg)
            MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(tonumber(arg), nil, nil, function()
                MCutSceneMgr:AfterBlackCurtainFinish()
            end, 0)
        end
    }
}

function SendLuaEvent(luaType, ...)
    GlobalEventBus:Dispatch(luaType, ...)
end

function SendLuaMessage(luaType, ...)
    return ReceiveCSharpMessage(luaType, ...)
end

function ReceiveCSharpMessage(luaType, ...)
    local handleEvents = luaTypeCallback[luaType]
    if handleEvents~=nil then

        if handleEvents.file~=nil then
            require( handleEvents.file )
        end
        if type(handleEvents.func) == "string" then
            local func = loadstring( handleEvents.func )
            if func then
                return func( luaType, ... )
            else
                logError("不存在该函数："..tostring(handleEvents.func))
            end
            func = nil
        elseif type(handleEvents.func) == "function" then
            local func = handleEvents.func
            if func then
                return func( luaType, ... )
            else
                logError("不存在该函数："..tostring(handleEvents.func))
            end
            func = nil
        end

    end
end


return MUIEvent