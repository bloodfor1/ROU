---@module ModuleMgr.TaskMgr
module("ModuleMgr.TaskMgr", package.seeall)

require "Data/Model/BagModel"
require "Event/EventConst"
require "Task/TaskBase"
require "TableEx/TaskDataTable"

DEBUG = false

function DebugTaskError(str)
    if DEBUG then
        logError(str)
    end
end

function DebugTaskYellow(str)
    if DEBUG then
        logYellow(str)
    end
end

function DebugTaskGreen(str)
    if DEBUG then
        logGreen(str)
    end
end

function DebugTaskRed(str)
    if DEBUG then
        logRed(str)
    end
end

ResponseEventDispatcher = EventDispatcher.new()

--- 任务类型 可见TaskTypeTable.csv（2020.08.14此表最全最新）
ETaskType = {
    --- 主线任务
    Main = 1,
    --- 支线任务
    Branch = 2,
    --- 职业任务
    Class = 3,
    --- 日常任务
    Daily = 4,
    --- 周环任务
    Weekly = 5,
    --- 引导任务
    Guide = 6,
    --- 奇遇任务
    Surprise = 7,
    --- 公会任务
    Guild = 8,
    --- 伊甸园任务
    Eden = 9,
    --- 爱神任务(deprecated)
    Couple = 10,
    --- 伊甸园加急(deprecated)
    EdenQ = 11,
    --- 冒险任务
    Adventure = 12,
    --- 副本任务
    Dungeons = 13,
    --- 生活支线
    Life = 14,
    --- 世界任务
    WorldEvent = 15,
    --- 萌新手册
    NewbieManual = 16,
    --- 委托任务
    Commission = 17,
    --- 装备追踪（专用）
    Virtual = 18,
    --- 清扫任务
    Explore = 19,
    --- 佣兵任务
    Mercenary = 20,
    --- 挑战任务
    Challenge = 21,
    --- 活动任务
    Activity = 22,
    --- 勋章任务
    Medal = 23,
    --- 活动引导任务（现在只做了宝藏猎人）
    TreasureHunt = 24,
    --- 勇士招募任务
    Conscript = 25,
}

--- 任务显示追踪的（任务面板&快捷任务面板）的时机
ETaskShowType = {
    --- 任何时机都不显示追踪
    None = 0,
    --- 在玩家接取之后才显示追踪
    Default = 3,
    --- 在玩家不可接取的时候就显示追踪
    BeforeAccept = 1,
    --- 在玩家可接取的时候就显示追踪
    Acceptable = 2,
    --- 可接取时显示 只显示在任务面板 待改进
    OnlyUI = 4
}

--- 任务接取方式
ETaskAcceptType = {
    --- 正常对话接取
    Normal = 1,
    --- 自动接取
    Auto = 2,
    --- 飞鸽传书并接取
    Mail = 3
}

--- 任务完成方式
ETaskFinishType = {
    --- 正常对话交付
    Normal = 1,
    --- 自动交付
    Auto = 2
}

--- 内务归属的三个页签
ETaskTag = {
    --- 任务
    Adventure = 1,
    --- 玩法
    Story = 2,
    --- 奇遇
    Other = 3
}

-- 目标配置示例参考项目wiki-任务配置流程说明
--- 任务目标类型
ETaskTargetType = {
    ---对话(对应NpcTable)
    NpcTalk = 1,
    ---打怪(对应EntityTable)
    MonsterFarm = 2,
    ---采集(对应CollectTable)
    Collection = 3,
    ---收集(回收)(对应ItemTable)
    ItemCollect = 4,
    ---寻路(对应SceneTable)
    Navigation = 5,
    ---使用道具(对应ItemTable)
    UseItem = 6,
    ---完成副本(对应DungeonsTable)
    DungeonComplete = 7,
    ---完成操作(对应OpenSystemTable)
    SystemComplete = 8,
    ---拍照
    TakePhotograph = 9,
    ---完成活动任务(对应ActivitiesTable)
    ActivityComplete = 10,
    ---完成成就任务(对应AchievementDetailTable)
    Achievement = 11,
    ---打怪收集(对应ItemTable)
    MonsterLoot = 15,
    ---父任务(客户端不处理)
    ParentTask = 16,
    ---进入副本(对应DungeonsTable)
    DungeonEnter = 17,
    ---单人烹饪(对应RecipeTable)
    CookingSingle = 18,
    ---双人烹饪(副本)(对应DungeonsTable)
    CookingDouble = 19,
    ---搭乘公共载具(对应VehiclePublicTable)
    VehiclePublic = 20,
    ---与场景进行交互(对应TaskSceneInteractionTable)
    SceneObject = 21,
    ---搭乘单人载具(对应VehiclePublicTable)
    VehiclePublicSingle = 22,
    ---双人交互(对应ShowActionTable)
    PlayerActionDouble = 23,
    ---使用技能(对应SkillTable)
    CastSkill = 24,
    ---播放过场动画(对应CutSceneTable)
    PlayTimeline = 25,
    ---技能达到指定等级(对应SkillTable)
    SkillLevel = 26,
    ---使用道具(假使用)
    FakeUseItem = 27,
    ---播放黑幕(对应BlackCurtainTable)
    PlayBlackCurtain = 28,
    ---动态回收
    DyncItemRecycle = 29,
    ---动态怪物
    Monster = 30,
    ---动态拍照
    DyncPhoto = 31,
    ---完成QTE小游戏目标
    QTECompleted = 32,
    ---护送
    Convoy = 33,
    ---搬运
    Carry = 34,
    ---虚拟目标(纯前端)
    Virtual = 35,
    ---采集某一类型采集物
    CollectionCategory = 36,
    ---等待N秒完成目标
    DelayTime = 37,
    ---与指定NPC做出指定交互动作
    NpcAction = 38,
    ---完成指定动作
    ShowAction = 39,
    ---环任务目标
    CycTask = 40,
    ---收集后对话交付复合目标
    SpTalk = 41,
    ---泡点跳舞
    Dance = 42,
    ---完成N次指定玩法
    PlayActivity = 44,
}

--- 任务状态枚举 取值根据服务器定的
ETaskStatus = {
    --- 不可接(已推送但未达到接取条件)
    NotTake = 6,
    --- 可接取
    CanTake = 0,
    --- 已接取(进行中)
    Taked = 1,
    --- 可完成
    CanFinish = 5,
    --- 失败
    Failed = 4,
    --- 废弃
    Abandoned = 2,
    --- 已完成
    Finished = 3
}

--- 任务目标执行方式
ETargetRunType = {
    Parallel = 1,
    Sequence = 2,
    AnyOne = 3
}

--- 子任务选择方式
ETaskSubChoose = {
    --- 无子任务
    None = 0,
    --- 服务器随机给予子任务
    Random = 1,
    --- 顺序选取子任务
    Sequence = 2,
    --- 由玩家选取分支子任务
    ByPlayer = 3,
    --- 乐园团专用
    Eden = 4
}

--- 任务导航寻路方式
ETaskNavType = {
    --- 自动寻路到指定地点
    Normal = 1,
    --- 指出大概位置，玩家自行寻找
    Explore = 2,
    --- 不提供寻路
    Invalid = 3
}

-- 往后尽可能用Track和Nav来区分任务的追踪与人物的导航
--- 并行任务目标的追踪（Track）方式
EParallelTargetTrackType = {
    Sequence = 1,
    Select = 2
}


--- 任务不可接原因
ETaskAcceptFailed = {
    None = 0,
    --- 等级不符合要求
    Level = 1,
    --- 队长身份不符合要求
    Captain = 2,
    --- 性别不符合要求
    Sex = 3,
    --- 委托证书数量不符合要求
    Commission = 4,
    --- 携带道具不符合要求
    ItemLimit = 5
}

ETaskVirtualType = {
    EquipForge = 1, --装备打造
}

--任务触发条件枚举（客户端只用到 9 10 16）
ETaskConditionType = {
    Achievement = 1,            --成就
    Medal = 2,                  --勋章
    InteractScene = 3,          --场景物件交互
    KillMonster = 4,            --杀怪
    UseItemWithTargetId = 5,    --使用指定ID道具
    UseItemWithTargetType = 6,  --使用指定类型道具
    PlayAction = 7,             --执行指定动作
    HaveItemWithTargetId = 8,   --拥有指定ID道具
    PhotoNpc = 9,               --拍照到NPC
    PhotoEntity = 10,           --拍照到怪物
    Trigger = 11,               --触发器
    InteractNpc = 12,           --与npc交互
    InteractPlayer = 13,        --与玩家交互
    LifeSkillLevel = 14,        --生活职业等级
    ReadDialogue = 15,          --读到某句对话
    PhotoPlace = 16,            --拍摄到指定地点
}

DEBUT_TASK_NAMES = {
    [ETaskType.Main] = { "赵广", "TaskTable" },
    [ETaskType.Branch] = { "鹿龙", "TaskSplitBranchTable" },
    [ETaskType.Class] = { "赵广", "TaskSplitJobTable" },
    [ETaskType.Daily] = { "黄兆晗", "TaskSplitDailyTable" },
    [ETaskType.Weekly] = { "黄兆晗", "TaskSplitWeekTable" },
    [ETaskType.Guide] = { "天考", "TaskSplitGuideTable" },
    [ETaskType.Surprise] = { "鹿龙", "TaskSplitInterestingmeetTable" },
    [ETaskType.Guild] = { "黄兆晗", "TaskSplitGuildTable" },
    [ETaskType.Adventure] = { "黄兆晗,天考", "TaskSplitAdventureTable" },
    [ETaskType.Dungeons] = { "天考", "TaskSplitDungeonsTable" },
    [ETaskType.Life] = { "天考", "TaskSplitLifeTable" },
    [ETaskType.WorldEvent] = { "黄兆晗，陈阳", "TaskSplitWroldTable" },
    [ETaskType.Commission] = { "黄兆晗，戴瑞轩", "TaskSplitEntrustTable" },
    [ETaskType.NewbieManual] = { "李韬", "TaskSplitPostCardTable" },
    [ETaskType.Explore] = { "鹿龙", "TaskSplitExploreTable" },
    [ETaskType.Mercenary] = { "鹿龙", "TaskSplitMercenaryTable" },
    [ETaskType.Activity] = { "鹿龙", "TaskSplitActivityTable" }
}

MINIMAP_ID = MoonCommonLib.MLuaCommonHelper.ULong(1)
TASK_NAV_FX = "Effects/Prefabs/Creature/Common/Fx_Common_Scene_Mubiaodian001"
-- TASK_MAP_ICON_FX = "Fx_Ui_Xunlu_Mudidian001"

TASK_NAV_FX_ID = 0

TaskMapIcon = {
    [1] = { [ETaskStatus.CanTake] = "UI_map_identification_task_zhuxian.png", [ETaskStatus.Taked] = "UI_common_task_zhuxian_yijie01.png", [ETaskStatus.CanFinish] = "UI_map_identification_task_zhuxiancomplete.png" },
    [2] = { [ETaskStatus.CanTake] = "UI_map_identification_task_zhixian.png", [ETaskStatus.Taked] = "UI_common_task_zhixian_yijie01.png", [ETaskStatus.CanFinish] = "UI_map_identification_task_zhixiancomplete.png" },
    [3] = { [ETaskStatus.CanTake] = "UI_map_identification_task_teshu.png", [ETaskStatus.Taked] = "UI_common_task_zhiye_yijie01.png", [ETaskStatus.CanFinish] = "UI_map_identification_task_teshucomplete.png" },
    [4] = { [ETaskStatus.CanTake] = "UI_map_identification_task_zhuanzhi.png", [ETaskStatus.Taked] = "UI_common_task_aishen_yijie01", [ETaskStatus.CanFinish] = "UI_map_identification_task_zhuanzhicomplete.png" }
}

TaskNpcFx = {
    [ETaskStatus.CanTake] = "Effects/Prefabs/Creature/Ui/Fx_Ui_GanTanHao_0",
    [ETaskStatus.Taked] = "Effects/Prefabs/Creature/Ui/Fx_Ui_WenHao_0",
    [ETaskStatus.CanFinish] = "Effects/Prefabs/Creature/Ui/Fx_Ui_WanChengRenWu_0"
}


--任务事件列表
taskEventName = {
    [ETaskTargetType.TakePhotograph] = EventConst.Names.OnPhotoGraphComplete,
    [ETaskTargetType.SceneObject] = EventConst.Names.OnSceneObjectComplete,
    [ETaskTargetType.CastSkill] = EventConst.Names.TaskEventCastSkill,
    [ETaskTargetType.PlayTimeline] = EventConst.Names.CutSceneStop,
    [ETaskTargetType.PlayBlackCurtain] = EventConst.Names.OnPlayBlackCurtainCompleted,
    [ETaskTargetType.QTECompleted] = EventConst.Names.OnQTEComplete,
    [ETaskTargetType.DyncPhoto] = EventConst.Names.OnPhotoGraphComplete,
    [ETaskTargetType.NpcAction] = EventConst.Names.OnTaskNpcAction,
    [ETaskTargetType.ShowAction] = EventConst.Names.OnShowAction,
    [ETaskTargetType.Dance] = EventConst.Names.OnDanceStatusModified
}

-------------------------特判用任务ID--------------------------------
--跑商任务ID
BusinessLineTaskId = 17000018

-----------------------End 特判用任务ID------------------------------

taskItemInfo = {}
taskShowMailFlag = {}

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

--角色等级改变相关监听 用来刷新任务状态或者推导潜在可接任务
function OnInit()
    Data.PlayerInfoModel.BASELV:Add(Data.onDataChange, TaskInfoUpdateByBaseLvChanged, ModuleMgr.TaskMgr)
    Data.PlayerInfoModel.JOBLV:Add(Data.onDataChange, TaskInfoUpdateByJobLvChanged, ModuleMgr.TaskMgr)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    InitPhotoConditionEvent()
end

function OnUninit()
    Data.PlayerInfoModel.BASELV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.TaskMgr)
    Data.PlayerInfoModel.JOBLV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.TaskMgr)
    gameEventMgr.UnRegister(gameEventMgr.OnBagUpdate)
end

local npcInfo = {}
local TaskInfo = {
    ---@type TaskBase[] 所有可接及已经的任务列表
    taskList = {},
    ---@type TaskBase[] 完成的任务
    finishedTask = {},
    ---当前选中的任务页签
    currentSelectTaskTag = ETaskTag.Adventure,
    ---是否有取名任务
    hasNameTask = false,
    ---转职任务选择职业ID
    taskSelectProId = 0,
    ---重新接取任务ID 缓存
    reacceptTaskId = -1,
    ---@type TaskBase 当前导航任务数据
    currentSelectTaskData = nil,
    ---@type Vec3 当前地图临时导航数据
    tempNavPosition = nil,
    ---通过任务触发隐藏UI的计数
    hideTriggerUICnt = 0,
    ---@type TaskBase 最新刚接到的任务
    lastAcceptTask = nil,
    isInit = false,
    ---当前委托拍照引导数据
    currentPhotoGuide = nil,
    ---上一个选中任务的id
    preSelectTaskId = 0,
    ---某个页签下是否有新任务的缓存，为页签类型->boolean映射
    newTaskTagCache = {
        [ETaskTag.Adventure] = false,
        [ETaskTag.Story] = false,
        [ETaskTag.Other] = false
    }
}

local TaskTimer = {
    changeCamera = nil,
    hideUI = nil
}

local l_taskNpcCache = {}

local l_taskNavCallback = nil

TargetUpdater = {}
function RegisterUpdater(updater)
    table.insert(TargetUpdater, updater)
end

function RemoveUpdater(updater)
    table.ro_removeValue(TargetUpdater, updater)
end

function IsHaveNameTask()
    return TaskInfo and TaskInfo.hasNameTask
end

--客户端模拟时间刷新
function OnUpdateTaskTime()
    for k, v in pairs(TaskInfo.taskList) do
        if v.taskStatus == ETaskStatus.Taked and v.totalTime ~= nil and v.totalTime > 0 and v.lastTime > 0 then
            v.lastTime = v.lastTime - 1
        end
    end
    GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskTime)
end

local l_timer = nil
l_timer = Timer.New(OnUpdateTaskTime, 1, -1, true)
l_timer:Start()

--MgrMgr调用
function OnLogout()
    ClearAllTaskInfo()
end

actionProgress = nil  --场景交互任务相关 进度条
function OnUpdate()
    if actionProgress ~= nil then
        actionProgress:Update(Time.deltaTime)
    end
    if not MStageMgr.IsSwitchingScene then
        UpdateMiniMapIcon()
    end
    for i = 1, #TargetUpdater do
        TargetUpdater[i]:Update()
    end
end

function OnEnterScene(sceneId)
    DebugTaskYellow("OnEnterScene")
    OnMyPlayerStopMove(nil, true)
    UIMgr:DeActiveUI(UI.CtrlNames.TaskMail)
    UpdateTaskNavigation()
    -- CheckShouldShowTaskMailReceive()
    ValidatePhotoGuide()
    ResponseEventDispatcher:Dispatch(TASK_REQUEST_EVENT_ON_SWITCH_SCENE)
end

function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    if l_roleAllInfo and l_roleAllInfo.taskrecord and l_roleAllInfo.taskrecord.tasks and #l_roleAllInfo.taskrecord.tasks > 0 then
        local l_selectedTaskId = GetSelectTaskID()  --获取当前选择的任务ID  用于之后还原
        ClearAllTaskInfo()
        MgrMgr:GetMgr("TaskTriggerMgr").OnTaskTriggerAll(reconnectData.task_triggers)
        InitTaskInfo(l_roleAllInfo.taskrecord, l_selectedTaskId)
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    end
end

------------------------任务数据--begin------------------------
------------------------配置数据--begin------------------------
MAX_TASK_TARGET_COUNT = 5
--任务完成通用特效路径
TASK_COMPLETED_TIPS_FXPATH = "Effects/Prefabs/Creature/Ui/Fx_Ui_RenWuWanCheng_01"
--起名任务ID
NameTaskID = MGlobalConfig:GetInt("RenameTask")
--快捷面板的最大显示数量
MAX_PRE_SHOW_NUM = MGlobalConfig:GetInt("TaskTrackMaxNum")
--播放完该cutscene会立马切场景  防穿帮
SWITCH_SCENE_CUTSCENE = MGlobalConfig:GetInt("SwitchSceneCutSceneId")
--无角色errorcode
ERR_ROLE_NOTEXIST = 211
TASK_REQUEST_EVENT_ON_SWITCH_SCENE = "TASK_REQUEST_EVENT_ON_SWITCH_SCENE"

------------------------配置数据--end------------------------

--- 设置任务页签，刷新对应页签内的任务内容
---@return boolean true若任务页签发生改变
function SetSelectTag(tag)
    if TaskInfo.currentSelectTaskTag == tag then
        return false
    end
    TaskInfo.currentSelectTaskTag = tag
    GlobalEventBus:Dispatch(EventConst.Names.RefreshSelectTaskTag)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
    return true
end

function ResetSelectTask()
    SetSelectTask(nil)
end

--- 设置当前追踪的任务及任务目标数据
function SetSelectTask(taskData)
    local l_needUpdate = true
    if taskData == nil then
        TaskInfo.currentSelectTaskData = nil
        SetPhotoGuide(nil)
    else
        local l_preTaskData = TaskInfo.currentSelectTaskData
        TaskInfo.currentSelectTaskData = taskData
        TaskInfo.preSelectTaskId = taskData.taskId
        SetPhotoGuide(taskData.currentTaskTarget)
        -- 若任务存在追踪方式，可能在不可接取 / 可接取 / 接取后 显示追踪， 对应表中ShortcutShowType字段
        if taskData.tableData.acceptShowType ~= 0 then
            SetSelectTag(taskData.tableData.typeTag)
            end
        -- 修复了导航数据对比总是返回false的问题，使用递归比较
        if l_preTaskData ~= nil and l_preTaskData == taskData
            and table.ro_deepCompare(l_preTaskData:GetNavigationData(), taskData:GetNavigationData()) then
            --logGreen("NO NEED UPDATE")
            l_needUpdate = false
        else
            --logRed("NEED UPDATE")
        end
    end
    if l_needUpdate then
        UpdateTaskNavigation()
    end
    GlobalEventBus:Dispatch(EventConst.Names.RefreshTaskNavState)
end

--单个任务目标完成的回调
function OnTaskTargetCompleted(taskTarget)
    local l_taskData = taskTarget.taskData
    if TaskInfo.currentSelectTaskData == nil or TaskInfo.currentSelectTaskData ~= l_taskData then
        return
    end
    SetSelectTask(l_taskData)
end


--验证委托拍照是否需要引导
function ValidatePhotoGuide()
    if currentPhotoGuide == nil then
        MEventMgr:LuaFireEvent(MEventType.MEvent_PhotoStopGuide, MEntityMgr.PlayerEntity)
        return
    end
    if currentPhotoGuide.scene == MScene.SceneID then
        local l_position = currentPhotoGuide.targetPosition
        MEventMgr:LuaFireEvent(MEventType.MEvent_PhotoStartGuide, MEntityMgr.PlayerEntity, l_position.x, l_position.y, l_position.z)
    else
        MEventMgr:LuaFireEvent(MEventType.MEvent_PhotoStopGuide, MEntityMgr.PlayerEntity)
    end
end

--设置委托拍照引导
function SetPhotoGuide(target)
    if target == nil then
        currentPhotoGuide = nil
    else
        if target.targetType ~= ETaskTargetType.DyncPhoto then
            currentPhotoGuide = nil
        else
            if currentPhotoGuide == target then
                return
            end
        end
    end

    currentPhotoGuide = target
    if currentPhotoGuide == nil then
        MEventMgr:LuaFireEvent(MEventType.MEvent_PhotoStopGuide, MEntityMgr.PlayerEntity)
        return
    end
    --如果目的地在当前场景开始引导
    if currentPhotoGuide.scene == MScene.SceneID then
        local l_position = currentPhotoGuide.targetPosition
        MEventMgr:LuaFireEvent(MEventType.MEvent_PhotoStartGuide, MEntityMgr.PlayerEntity, l_position.x, l_position.y, l_position.z)
    else
        MEventMgr:LuaFireEvent(MEventType.MEvent_PhotoStopGuide, MEntityMgr.PlayerEntity)
    end
end

--重置委托拍照引导
function ResetPhotoGuide(target)
    if target == nil then
        SetPhotoGuide(nil)
    else
        if currentPhotoGuide == target then
            SetPhotoGuide(nil)
        end
    end
end

--玩家移动至某个位置之后派发事件 交由各任务验证具体逻辑
function OnMyPlayerStopMove(luaType, isEnterScene)
    if isEnterScene == nil then
        isEnterScene = false
    end
    if MEntityMgr.PlayerEntity == nil then
        return
    end
    local l_playerPos = MEntityMgr.PlayerEntity.Position
    if isEnterScene then
        l_playerPos = MPlayerInfo.PosEnterScene
    end
    local l_nowSceneId = MScene.SceneID
    GlobalEventBus:Dispatch(EventConst.Names.OnPlayerStopMoveForTask, l_nowSceneId, l_playerPos)
end

--清理所有任务数据
function ClearAllTaskInfo()
    TargetUpdater = {}
    StopAllCoroutines()
    ResetSelectTask()
    if TASK_NAV_FX_ID > 0 then
        MFxMgr:DestroyFx(TASK_NAV_FX_ID)
        TASK_NAV_FX_ID = 0
    end
    for k, v in pairs(TaskInfo.taskList) do
        v:Destroy()
    end

    TaskInfo = {
        taskList = {}, --所有可接及已经的任务列表
        finishedTask = {}, --完成的任务
        currentSelectTaskTag = ETaskTag.Adventure, --当前选中的任务页签
        hasNameTask = false, --是否有取名任务
        taskSelectProId = 0,
        reacceptTaskId = -1,
        currentSelectTaskData = nil, --当前追踪任务数据
        hideTriggerUICnt = 0,
        lastAcceptTask = nil, --最新刚接到的任务
        isInit = false,
        currentPhotoGuide = nil,
        preSelectTaskId = 0,
        newTaskTagCache = {
            [ETaskTag.Adventure] = false,
            [ETaskTag.Story] = false,
            [ETaskTag.Other] = false
        }
    }
    l_taskNpcCache = {}
    l_taskNavCallback = nil
    MgrMgr:GetMgr("TaskTriggerMgr").ResetTriggerData()
    MgrMgr:GetMgr("TaskTriggerMgr").InitNpcStatus()
    ClearNpcInfo()
    TaskEventStopSceneObject()
    taskShowMailFlag = {}
    --GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)  --清理完之后一般都会刷新 这里不重复抛刷新事件
    ClearAllMapIcon()
end
------------------------任务数据--end------------------------
------------------------服务器协议处理--begin------------------------
--初始化任务数据
--info 服务器下发的任务信息
--selectedTaskId 选中的任务ID
function InitTaskInfo(info, selectedTaskId)
    if info ~= nil then
        UpdateTaskList(info.tasks, true)
    else
        --GM指令刷新任务  清理所有跟任务相关的数据  重新check任务
        ClearAllTaskInfo()
        GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)  --ClearAllTaskInfo内部不再抛刷新界面事件 这里补上
    end
    MgrMgr:GetMgr("ForgeMgr").RecoverForgeTask()  --材料追踪任务恢复
    InitSelectTaskTag()
    UpdateExTaskInfo()
    --还原之前选中的任务
    if selectedTaskId and selectedTaskId > 0 then
        local l_selectTaksData = GetTaskData(selectedTaskId)
        if l_selectTaksData then
            SetSelectTask(l_selectTaksData)
        end
    end
    -- CheckShouldShowTaskMailReceive()
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
    GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskDetail)
end

function ResetModifyNameFlag(...)
    TaskInfo.hasNameTask = false
end

--初始化默认选中页签  递归：没有任务的时候起效 依次寻找每一个页签看是否有对应任务 都没有则返回第一个页签
function InitSelectTaskTag()
    local l_tmpList = ShowTaskFilter()  --查找对应页签是否有任务
    if #l_tmpList > 0 then
        return
    end
    TaskInfo.currentSelectTaskTag = TaskInfo.currentSelectTaskTag + 1
    if TaskInfo.currentSelectTaskTag > ETaskTag.Other then
        TaskInfo.currentSelectTaskTag = ETaskTag.Adventure
        return
    end
    InitSelectTaskTag()
end

--更新视野内NPC状态
function UpdateNpcFxInViewport()
    MNpcMgr:UpdateNpcFxInViewport()
end

--任务接取成功通知(处理组队任务相关)
function OnTaskAcceptNotify(msg)
    ---@type TaskAcceptNotify
    local l_info = ParseProtoBufToTable("TaskAcceptNotify", msg)
    local l_task = GetTaskTableInfoByTaskId(l_info.taskid)
    if l_task ~= nil and l_task.taskType == ETaskType.WorldEvent and #l_task.targetSubTasks > 0 then
        local l_taskName = l_task.name
        local l_tips = StringEx.Format(Common.Utils.Lang("WROLD_TASK_ACCEPTED"), l_taskName)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
    end
end

--任务接取失败通知(处理组队任务相关)
function OnTaskAcceptFailedNotify(msg)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    ---@type TaskAcceptFailed
    local l_info = ParseProtoBufToTable("TaskAcceptFailed", msg)

    if l_info.errcode ~= 0 then
        local task = GetTaskTableInfoByTaskId(l_info.taskid)
        if task ~= nil and task.taskType == ETaskType.WorldEvent then
            if not string.ro_isEmpty(l_info.membername) then
                local l_tipsKey = Common.Functions.GetErrorCodeKey(l_info.errcode)
                if l_tipsKey ~= nil then
                    l_tipsKey = StringEx.Format("{0}_Teammate", l_tipsKey)
                    local l_tipsStr = Lang(l_tipsKey)
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(l_tipsStr, l_info.membername))
                    return
                end
            end
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
        end
    end
end

--任务完成通知
function OnTaskFinishNotify(msg)
    ---@type TaskFinishNotify
    local l_info = ParseProtoBufToTable("TaskFinishNotify", msg)
    local l_taskData = GetTaskTableInfoByTaskId(l_info.taskid)
    if l_taskData ~= nil then
        RemoveOneTaskInfo(l_info.taskid)
        if l_taskData.isReminder then
            ShowTaskFinishTips()
        end
        if not string.ro_isEmpty(l_taskData.finishTips) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_taskData.finishTips)
        end
    end
    GlobalEventBus:Dispatch(EventConst.Names.OnTaskFinishNotify, l_info.taskid)
end

function ShowTaskFinishTips()
    MgrMgr:GetMgr("TipsMgr").ShowFxTips(TASK_COMPLETED_TIPS_FXPATH, 400, 260, 2)
end

--任务放弃通知
function OnTaskGiveupNotify(msg)
    ---@type TaskGiveupNotify
    local l_info = ParseProtoBufToTable("TaskGiveupNotify", msg)
    RemoveOneTaskInfo(l_info.taskid)
    local task = GetTaskTableInfoByTaskId(l_info.taskid)
    if task ~= nil and #task.targetSubTasks == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(GetColorText(Common.Utils.Lang("TASK_GIVEUP"), RoColorTag.Yellow) .. task.name)
    end
    --如果有缓存的重接任务Id并且是放弃的该任务则重新导航接取该任务
    if l_info.taskid == TaskInfo.reacceptTaskId then
        TaskInfo.reacceptTaskId = -1
        NavToTaskAcceptNpc(l_info.taskid)
    end
end

--任务失败通知
function OnTaskFailedNotify(msg)
    ---@type TaskFailedNtf
    local l_info = ParseProtoBufToTable("TaskFailedNtf", msg)
    local task = GetTaskTableInfoByTaskId(l_info.taskid)
    if l_info.taskid == GetSelectTaskID() then
        MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
        ResetSelectTask()
    end
    if task ~= nil and task.taskType == ETaskType.Guild then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(GetColorText(Common.Utils.Lang("TASK_GIVEUP"), RoColorTag.Yellow) .. task.name)
    end
end
------------------------不同任务目标完成上报begin------------------------
--上报目标完成请求
function RequestTaskReportWithTarget(sendInfo, customData, callback)
    DebugTaskYellow("RequestTaskReportWithTarget")
    local l_msgId = Network.Define.Rpc.TaskReport
    Network.Handler.SendRpc(l_msgId, sendInfo, customData, callback, nil, function(...)
        TaskRpcTimeOut()
    end)
end
--上报目标完成请求回调
function OnTaskReport(msg)
    ---@type TaskReportRes
    local l_info = ParseProtoBufToTable("TaskReportRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end
--推荐职业选择上报
function RequestTaskTrialChoice(luaType, command, param)
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.trialchoice = tonumber(param[1].Value)
    RequestTaskReportWithTarget(l_sendInfo)
end
--二转职业选择上报
function RequestJobChoice(proID)
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.profess_choice = proID
    RequestTaskReportWithTarget(l_sendInfo)
end
--npc对话上报
function RequestTalkTaskReport(taskId, npcId, customData, callback)
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.npc.npcid = npcId
    l_sendInfo.npc.taskid = taskId
    RequestTaskReportWithTarget(l_sendInfo, customData, callback)
end
--获取护送NPC当前位置信息
function GetConvoyNpcPosition(taskId, targetIndex, navType, callback)
    ---@type GetConvoyNpcPosArg
    local l_sendInfo = GetProtoBufSendTable("GetConvoyNpcPosArg")
    l_sendInfo.task_id = taskId
    l_sendInfo.target_index = targetIndex - 1
    local l_customData = {}
    l_customData.navType = navType
    l_customData.callback = callback
    local l_msgId = Network.Define.Rpc.GetTaskConvoyPosition
    Network.Handler.SendRpc(l_msgId, l_sendInfo, l_customData, callback)
end
--获取护送NPC当前位置信息回回调
function OnGetConvoyNpcPosition(msg, arg, customData)
    ---@type GetConvoyNpcPosRes
    local l_info = ParseProtoBufToTable("GetConvoyNpcPosRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end
------------------------不同任务目标完成上报end------------------------
--请求进入副本
function RequestGotoDungeon(eventID)
    local l_msgId = Network.Define.Rpc.TaskTrackGotoDungeon
    ---@type TaskTrackGotoDungeonArg
    local l_sendInfo = GetProtoBufSendTable("TaskTrackGotoDungeonArg")
    l_sendInfo.taskid = eventID
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
--请求进入副本回调
function OnTaskTrackGotoDungeon(msg)
    ---@type TaskTrackGotoDungeonRes
    local l_info = ParseProtoBufToTable("TaskTrackGotoDungeonRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

function UpdateSelectTaskNavigation(taskData)
    if TaskInfo.currentSelectTaskData == taskData then
        UpdateTaskNavigation()
    end
end

function ClearAllMapIcon(...)
    MapObjMgr:RmObj(MapObjType.TaskNavIcon)
    MapObjMgr:RmObj(MapObjType.TaskNavIconBigMap)
    MapObjMgr:RmDynamicEffectObj(MapObjType.TaskNavIcon, 1)
    MapObjMgr:RmDynamicEffectObj(MapObjType.TaskNavIconBigMap, 1)
end

function UpdateTaskNavigation()
    UpdateTaskNavigationFx()
    --无当前导航数据则清理小地图标识
    if TaskInfo.currentSelectTaskData == nil then
        ClearAllMapIcon()
        return
    end
    local l_navData = TaskInfo.currentSelectTaskData:GetNavigationData()
    if l_navData == nil then
        --此处针对泡点跳舞目标特判处理  由于跑点任务目的地需要服务器随机合法点 走的异步  其他走的都是同步
        --再使用多态改动成本较高  此处直接特判处理在随机点请求的回掉里进行请求
        --后续考虑把所有目标的目的地标识加载全都走回调  最好的实现应该是寻路库底层合并接口
        if TaskInfo.currentSelectTaskData.currentTaskTarget ~= nil and TaskInfo.currentSelectTaskData.currentTaskTarget.targetType == ETaskTargetType.Dance then
            TaskInfo.currentSelectTaskData.currentTaskTarget:UpdateNavigationAsync(UpdateDanceNavigation)
            return
        end
        ClearAllMapIcon()
        return
    end
    RequestTaskNavigation(l_navData.sceneId, l_navData.position, function(...)
        UpdateBigMapIcon()
        UpdateMiniMapIcon()
        UpdateTaskNavigationFx()
    end)
end

function UpdateDanceNavigation(navData)
    if navData == nil then
        ClearAllMapIcon()
        return
    end
    RequestTaskNavigation(navData.sceneId, navData.position, function(...)
        UpdateBigMapIcon()
        UpdateMiniMapIcon()
        UpdateTaskNavigationFx()
    end)

end

--请求任务寻路路径
function RequestTaskNavigation(sceneId, position, callBack, need_running)
    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon() then
        TaskInfo.tempNavPosition = position
        callBack()
        return
    end
    l_taskNavCallback = callBack
    local l_msgId = Network.Define.Rpc.EasyShowNavigate
    ---@type EasyShowNavigateArg
    local l_sendInfo = GetProtoBufSendTable("EasyShowNavigateArg")
    l_sendInfo.scene_map_id = sceneId
    l_sendInfo.position.x = position.x
    l_sendInfo.position.y = position.y
    l_sendInfo.position.z = position.z
    l_sendInfo.dest_type = 0
    l_sendInfo.need_running = need_running or false
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnTaskNavigation(msg)
    ---@type EasyShowNavigateRes
    local l_info = ParseProtoBufToTable("EasyShowNavigateRes", msg)
    if l_info.result == 0 then
        if #l_info.paths > 0 then
            TaskInfo.tempNavPosition = l_info.paths[1].end_pos
            if l_taskNavCallback ~= nil then
                l_taskNavCallback(l_info)
            end
        end
    else
        TaskInfo.tempNavPosition = nil
        ClearAllMapIcon()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
    l_taskNavCallback = nil
end

function RequestTaskRandomNavigation(sceneId, position, range, callBack)
    local l_msgId = Network.Define.Rpc.RandomNavigate
    ---@type RandomNavigateArg
    local l_sendInfo = GetProtoBufSendTable("RandomNavigateArg")
    l_sendInfo.scene_map_id = sceneId
    l_sendInfo.position.x = position.x
    l_sendInfo.position.y = position.y
    l_sendInfo.position.z = position.z
    l_sendInfo.search_radius = range
    Network.Handler.SendRpc(l_msgId, l_sendInfo, callBack)
end

function OnTaskRandomNavigation(msg, arg, customData)
    ---@type RandomNavigateRes
    local l_info = ParseProtoBufToTable("RandomNavigateRes", msg)
    if l_info.result == 0 then
        if customData then
            customData(l_info)
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

------------------------服务器协议处理--end------------------------
------------------------任务逻辑相关事件--begin------------------------
--对话事件
function TaskEventTalk(eventData, customData, callback)
    if CheckTaskTaked(eventData.taskId) then
        local l_targetData = TaskInfo.taskList[eventData.taskId]:GetTargetByStep(eventData.step)
        if l_targetData == nil then
            return
        end
        RequestTalkTaskReport(eventData.taskId, l_targetData.targetId, customData, callback)
    end
end
--跳舞状态改变派发事件
function OnDanceStatusModified(eventData)
    ---@type DanceStatusData
    local l_info = ParseProtoBufToTable("DanceStatusData", eventData)
    GlobalEventBus:Dispatch(EventConst.Names.OnDanceStatusModified, l_info)
end
--派发拍照事件
function CheckAblumPhoto(idList, photoType)
    --拍照完成事件抛出 为啥不直接监听EventConst.Names.PhotographCompleted？ 目前没时间改 下次再说 20200525 cmd
    GlobalEventBus:Dispatch(EventConst.Names.OnPhotoGraphComplete, { idList, photoType })
    --判断是否满足任务触发
    CheckPhotoCondition(idList, photoType)
end
--派发QTE事件
function CheckQteComplete(eventData)
    GlobalEventBus:Dispatch(EventConst.Names.OnQTEComplete, eventData)
end
--打开相机
function OpenShowPhotograph(...)
    UIMgr:ActiveUI(UI.CtrlNames.Photograph)
end
--派发场景交互事件
function TaskSceneObjectStart(luaType, sceneObject)
    GlobalEventBus:Dispatch(EventConst.Names.OnSceneObjectComplete, sceneObject)
end
--停止场景交互事件
function TaskSceneObjectStop(luaType, sceneObject)
    if currentObjectID == tonumber(sceneObject.Id) then
        TaskEventStopSceneObject()
    end
end
currentObjectID = 0   --场景交互任务相关 当前交互的场景物件Id
function TaskEventStopSceneObject(...)
    if actionProgress ~= nil then
        actionProgress:Release()
        actionProgress = nil
    end
    MPlayerInfo:ExitAdaptiveState()
    currentObjectID = 0
end
------------------------任务逻辑相关事件--end------------------------
------------------------任务npc数据--begin------------------------
--添加任务NPC数据
--sceneId  NPC所在场景ID
--npcId    NPC的ID
--tableInfo 任务表数据
--status 当前任务状态
-- function AddNpcInfo(sceneId, npcId, tableInfo, status,targetIndex)
function AddNpcInfo(sceneId, npcId, taskData, targetIndex)
    -- logError("AddNpcInfo taskId:"..taskData.taskId..",taskStatus:"..taskData.taskStatus..",targetIndex:"..tostring(targetIndex)..",sceneId:"..sceneId..",npcId:"..npcId)
    if npcInfo[sceneId] == nil then
        npcInfo[sceneId] = {}
    end
    local l_npcData = npcInfo[sceneId][npcId]
    if l_npcData == nil then
        npcInfo[sceneId][npcId] = {}
        l_npcData = npcInfo[sceneId][npcId]
    end
    local l_oneNpcInfo = {}
    l_oneNpcInfo.taskData = taskData
    l_oneNpcInfo.tableInfo = taskData.tableData
    l_oneNpcInfo.status = taskData.taskStatus
    l_oneNpcInfo.step = targetIndex or 0
    l_oneNpcInfo.subTaskId = taskData.subTaskId
    table.insert(l_npcData, l_oneNpcInfo)
    if taskData.tableData.taskType == ETaskType.Commission then
        local l_delegateNpcInfo = {}
        l_delegateNpcInfo.npcId = npcId
        l_delegateNpcInfo.sceneId = sceneId
        l_delegateNpcInfo.taskStatus = taskData.taskStatus
        MgrMgr:GetMgr("DelegateModuleMgr").AddTaskNpcInfo(l_delegateNpcInfo)
    end
    table.sort(l_npcData, npcComp)

    if taskData:MiniMapFilter() then
        return
    end
    --如果配置设定隐藏该任务NPC的显示则直接返回 不加入小地图显示
    if taskData.tableData.HideSymbol then
        return
    end
    MgrMgr:GetMgr("MapInfoMgr").AddNpcInfo(sceneId, npcId, taskData.taskId)
end
--删除任务NPC数据
function RemoveNpcInfo(sceneId, npcId, taskData, targetIndex)
    -- logError("RemoveNpcInfo taskId:"..taskData.taskId..",taskStatus:"..taskData.taskStatus..",targetIndex:"..tostring(targetIndex)..",sceneId:"..sceneId..",npcId:"..npcId)
    if npcInfo[sceneId] == nil then
        return
    end
    local l_npcData = npcInfo[sceneId][npcId]
    if l_npcData == nil then
        return
    end
    for i = #l_npcData, 1, -1 do
        local l_npcInfo = l_npcData[i]
        if l_npcInfo.taskData == taskData then
            if targetIndex ~= nil then
                if l_npcInfo.status == ETaskStatus.Taked and l_npcInfo.step == targetIndex then
                    RemoveOneNpcInfo(l_npcData, i, taskData, npcId, sceneId)
                    break
                end
            else
                if l_npcInfo.status == taskData.taskStatus then
                    RemoveOneNpcInfo(l_npcData, i, taskData, npcId, sceneId)
                    break
                end
            end
        end
    end
    table.sort(l_npcData, npcComp)
end

function RemoveOneNpcInfo(npcInfo, idx, taskData, npcId, sceneId)
    table.remove(npcInfo, idx)
    if taskData.tableData.taskType == ETaskType.Commission then
        local l_delegateNpcInfo = {}
        l_delegateNpcInfo.npcId = npcId
        l_delegateNpcInfo.sceneId = sceneId
        l_delegateNpcInfo.taskStatus = taskData.taskStatus
        MgrMgr:GetMgr("DelegateModuleMgr").RemoveTaskInfo(l_delegateNpcInfo)
    end
    if taskData:MiniMapFilter() then
        return
    end
    MgrMgr:GetMgr("MapInfoMgr").RemoveNpcInfo(sceneId, npcId, taskData.taskId)
end

--清理所有任务NPC数据
function ClearNpcInfo(...)
    for k, v in pairs(npcInfo) do
        RemoveOneNpcData(k, v)
    end
    npcInfo = {}
end

function RemoveOneNpcData(sceneId, npcData)
    for k, v in pairs(npcData) do
        for i = #v, 1, -1 do
            local l_npcInfo = v[i]
            RemoveOneNpcInfo(l_npcInfo, i, l_npcInfo.taskData, v, k)
        end
    end
end
--npc排序
function npcComp(a, b)
    if a.status == b.status then
        if a.taskData.showPriority == b.taskData.showPriority then
            return a.tableInfo.taskId < b.tableInfo.taskId
        else
            return a.taskData.showPriority < b.taskData.showPriority
        end
    end
    return a.status > b.status
end

--根据任务数据获取NPC头顶特效
function GetTaskNpcFx(table, sceneId, npcId)
    local npcStatus = GetNpcStatus(sceneId, npcId)
    if npcStatus ~= nil and #npcStatus > 0 then
        --判断是否有隐藏的需求
        local l_isHide = npcStatus[1].tableInfo.HideSymbol
        if l_isHide then
            return nil
        end
        local l_npcState = npcStatus[1].status
        local l_signTip = npcStatus[1].tableInfo.signTip
        return GetNpcFxByTask(l_signTip, l_npcState)
    end
    return nil
end

function GetNpcFxByTask(signTip, taskStatus)
    if signTip > 4 or signTip == 0 then
        return nil
    end
    local l_tmp = TaskNpcFx[taskStatus]
    if l_tmp == nil then
        return nil
    end
    return StringEx.Format("{0}{1}", l_tmp, signTip)
end

--获取小地图显示图标
function GetTaskMapIconByNpc(signTip, taskStatus)
    local l_taskIconData = TaskMapIcon[signTip]
    if l_taskIconData == nil then
        return nil
    end
    return l_taskIconData[taskStatus]
end

--获取NPC优先级最高的任务状态
function GetNpcStatus(sceneId, npcId)
    if npcInfo[sceneId] == nil then
        return nil
    end
    if npcInfo[sceneId][npcId] == nil then
        return nil
    end
    return npcInfo[sceneId][npcId]
end
--根据任务ID获取NPC任务状态
function GetNpcStatusById(table, sceneId, npcId)
    local npcStatus = GetNpcStatus(sceneId, npcId)

    if npcStatus ~= nil and #npcStatus > 0 then
        return npcStatus[1].status
    end
    return ETaskStatus.NotTake
end
--根据任务ID获取NPC任务类型
function GetNpcTaskTypeById(table, sceneId, npcId)
    if npcInfo[sceneId] == nil then
        return 0
    end
    if npcInfo[sceneId][npcId] == nil then
        return 0
    end
    local npcData = npcInfo[sceneId][npcId][1]
    if npcData == nil then
        return 0
    end
    local taskData = npcData.tableInfo
    if taskData == nil then
        return 0
    end
    return taskData.taskType
end
--获取任务NPC地图标识数据
function GetNpcMapInfo(sceneId, npcId)
    local npcStatus = GetNpcStatus(sceneId, npcId)
    if npcStatus == nil or #npcStatus == 0 then
        return nil
    end
    local l_npcInfo = npcStatus[1]
    if l_npcInfo == nil then
        return nil
    end
    local l_taskData = l_npcInfo.taskData
    if l_taskData == nil then
        return nil
    end
    if l_taskData:MiniMapFilter() then
        return nil
    end
    local l_showNpcInfo = {}
    l_showNpcInfo.taskStatus = l_npcInfo.status
    l_showNpcInfo.signTip = l_npcInfo.tableInfo.signTip
    return l_showNpcInfo
end

function GetTaskNpcInfo(sceneId, npcId)
    local npcStatus = GetNpcStatus(sceneId, npcId)
    if npcStatus == nil or #npcStatus == 0 then
        return nil
    end
    local l_npcInfo = npcStatus[1]
    if l_npcInfo == nil then
        return nil
    end
    if l_npcInfo.tableInfo == nil then
        return nil
    end
    if l_npcInfo.taskData == nil then
        return nil
    end
    return l_npcInfo
end
-- TASK_MAP_ICON_FXID = -1

--更新任务小地图
function UpdateMiniMapIcon()
    if TaskInfo.currentSelectTaskData == nil then
        MapObjMgr:RmObj(MapObjType.TaskNavIcon, 1)
        MapObjMgr:RmDynamicEffectObj(MapObjType.TaskNavIcon, 1)
        return
    end
    local l_navData = TaskInfo.currentSelectTaskData:GetNavigationData()
    if l_navData == nil or TaskInfo.tempNavPosition == nil then
        MapObjMgr:RmObj(MapObjType.TaskNavIcon, 1)
        MapObjMgr:RmDynamicEffectObj(MapObjType.TaskNavIcon, 1)
        return
    end

    local l_nowSceneId = MScene.SceneID
    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon()
            and l_navData.sceneId ~= l_nowSceneId then
        MapObjMgr:RmObj(MapObjType.TaskNavIcon, 1)
        MapObjMgr:RmDynamicEffectObj(MapObjType.TaskNavIcon, 1)
        return
    end

    local l_v2 = Vector2.New(l_navData.position.x, l_navData.position.z)
    if l_navData.sceneId ~= l_nowSceneId then
        l_v2 = Vector2.New(TaskInfo.tempNavPosition.x, TaskInfo.tempNavPosition.z)
    end
    local l_mapInfoMgr = MgrMgr:GetMgr("MapInfoMgr")
    l_mapInfoMgr.EventDispatcher:Dispatch(l_mapInfoMgr.EventType.UpdateNavIconPos, l_mapInfoMgr.EUpdateNavIconType.TaskNav, l_v2)
end

function UpdateBigMapIcon(...)
    MapObjMgr:RmObj(MapObjType.TaskNavIconBigMap, 1)
    MapObjMgr:RmDynamicEffectObj(MapObjType.TaskNavIconBigMap, 1)
    if TaskInfo.currentSelectTaskData == nil then
        return
    end
    local l_navData = TaskInfo.currentSelectTaskData:GetNavigationData()
    if l_navData == nil or TaskInfo.tempNavPosition == nil then
        return
    end

    local l_nowSceneId = MScene.SceneID
    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon()
            and l_navData.sceneId ~= l_nowSceneId then
        return
    end

    local l_v2 = Vector2.New(l_navData.position.x, l_navData.position.z)
    if l_navData.sceneId ~= l_nowSceneId then
        l_v2 = Vector2.New(TaskInfo.tempNavPosition.x, TaskInfo.tempNavPosition.z)
    end
    MapObjMgr:AddObj(MapObjType.TaskNavIconBigMap, 1, l_v2)
    MapObjMgr:MdObj(MapObjType.TaskNavIconBigMap, 1, true, false)
    Common.CommonUIFunc.AddDynamicMapEffect(MapObjType.TaskNavIconBigMap, 1, MoonClient.DynamicEffectType.Scale
    , MoonClient.DynamicPlayMode.YoYo, Vector3.New(0.8, 0.8, 0.8), Vector3.New(1.1, 1.1, 1.1), -1, 0.5)
end

-- function RemoveTaskMapIconFx( ... )
--     if TASK_MAP_ICON_FXID ~= -1 then
--         Common.CommonUIFunc.RemoveMapEffect(TASK_MAP_ICON_FXID)
--         TASK_MAP_ICON_FXID = -1
--     end
-- end

function RemoveTaskNavigationFx(...)
    if TASK_NAV_FX_ID > 0 then
        MFxMgr:DestroyFx(TASK_NAV_FX_ID)
        TASK_NAV_FX_ID = 0
    end
end

function UpdateTaskNavigationFx(...)

    RemoveTaskNavigationFx()
    -- RemoveTaskMapIconFx()

    if TaskInfo.currentSelectTaskData == nil then
        return
    end
    local l_navData = TaskInfo.currentSelectTaskData:GetNavigationData()
    if l_navData == nil or TaskInfo.tempNavPosition == nil then
        return
    end

    local l_nowSceneId = MScene.SceneID
    --如果在副本中且特效点的指定场景不一致则不显示
    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon() and l_nowSceneId ~= l_navData.sceneId then
        return
    end

    local fxData = MFxMgr:GetDataFromPool()
    if l_navData.sceneId == l_nowSceneId then
        fxData.position = l_navData.position
    else
        fxData.position = TaskInfo.tempNavPosition
    end
    TASK_NAV_FX_ID = MFxMgr:CreateFx(TASK_NAV_FX, fxData)
    MFxMgr:ReturnDataToPool(fxData)
    -- TASK_MAP_ICON_FXID = Common.CommonUIFunc.AddMapEffect(Vector2.New(fxData.position.x,fxData.position.z),TASK_MAP_ICON_FX,Vector2.New(80,80),nil,-1,false,true,false)
end
------------------------任务npc数据--end------------------------
------------------------任务奖励-begin--------------------------
local C_CONST_TASK_MAP = {
    [ItemChangeReason.ITEM_REASON_TASK_TAKE] = 1,
    [ItemChangeReason.ITEM_REASON_TASK_REWARD] = 1,
}

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[TaskMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleItemUpdateData = itemUpdateDataList[i]
        if nil ~= singleItemUpdateData.NewItem and nil ~= C_CONST_TASK_MAP[singleItemUpdateData.Reason]
        then
            local oldCount = 0
            if nil ~= singleItemUpdateData.OldItem then
                oldCount = singleItemUpdateData.OldItem.ItemCount
            end

            local diffValue = singleItemUpdateData.NewItem.ItemCount - oldCount
            taskItemInfo[singleItemUpdateData.NewItem.TID] = diffValue
        end
    end

    local l_ui = UIMgr:GetUI(UI.CtrlNames.TalkDlg2)
    if l_ui == nil then
        ShowTaskItem()
    end
end

--展示奖励道具
function ShowTaskItem()
    if table.ro_size(taskItemInfo) > 0 then
        for k, v in pairs(taskItemInfo) do
            if tonumber(v) > 0 then
                local l_opt = {
                    itemId = k,
                    itemOpts = { num = v, icon = { size = 18, width = 1.4 } },
                }

                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
            end
        end
    end

    taskItemInfo = {}
end
------------------------任务奖励-end--------------------------

------------------------外部接口--begin------------------------------
function GetNewTaskTagCache(...)
    return TaskInfo.newTaskTagCache
end
function GetTaskSelectProId()
    return TaskInfo.taskSelectProId
end
--根据任务ID验证是否任务可接取
function CheckTaskCanAcceptByTaskId(taskId)
    local l_taskTableData = GetTaskTableInfoByTaskId(taskId)
    if l_taskTableData == nil then
        return false
    end
    return CanTakeTask(l_taskTableData)
end
--根据任务表格数据验证是否任务可接取
function CanTakeTask(tableInfo)
    if tableInfo.taskType == ETaskType.Couple then
        return true
    end
    --等级限制
    local l_minBaseLv = tableInfo.minBaseLevel
    local l_maxBaseLv = tableInfo.maxBaseLevel
    local l_minJobLv = tableInfo.minJobLevel
    local l_maxJobLv = tableInfo.maxJobLevel
    local l_playerLv = MPlayerInfo.Lv
    local l_playerJobLv = MPlayerInfo.JobLv
    if l_minBaseLv ~= 0 and l_playerLv < l_minBaseLv then
        return false
    end
    if l_maxBaseLv ~= 0 and l_playerLv > l_maxBaseLv then
        return false
    end

    if l_minJobLv ~= 0 and l_playerJobLv < l_minJobLv then
        return false
    end
    if l_maxJobLv ~= 0 and l_playerJobLv > l_maxJobLv then
        return false
    end
    return true
end
--获取所有任务数据
function GetTaskList()
    return TaskInfo.taskList
end

function GetTaskData(taskId)
    return TaskInfo.taskList[taskId]
end

--获取当前主线任务ID
function GetCurrentMainTaskId()
    local l_taskList = TaskInfo.taskList
    for k, v in pairs(l_taskList) do
        if v.tableData.taskType == ETaskType.Main then
            return k
        end
    end
    return nil
end

--通过ID获取所有任务数据 返回值是list
function GetTakedDescByTaskId(taskId)
    local l_taskData = TaskInfo.taskList[taskId]
    if l_taskData == nil then
        return nil
    end
    return l_taskData:GetTaskTargetDescribeQuick()
end
--获取当前选中任务ID
function GetSelectTaskID()
    if TaskInfo and TaskInfo.currentSelectTaskData then
        return TaskInfo.currentSelectTaskData.taskId
    end
    return -1
end
--获取当前选中任务页签
function GetSelectTaskTag()
    return TaskInfo.currentSelectTaskTag
end
--获取任务可接最小等级  无任务数据返回 -1
function GetTaskAcceptBaseLv(taskId)
    local l_taskData = GetTaskTableInfoByTaskId(taskId)
    if l_taskData == nil then
        return -1
    end
    return l_taskData.minBaseLevel
end
--检测任务是否已经接取
function CheckTaskTaked(taskId)
    for k, v in pairs(TaskInfo.taskList) do
        if k == taskId then
            if v.taskStatus == ETaskStatus.CanFinish or v.taskStatus == ETaskStatus.Taked or v.taskStatus == ETaskStatus.Failed then
                return true
            end
        end
    end
    return false
end
--检测任务可否完成
function CheckTaskCanFinish(taskId)
    for k, v in pairs(TaskInfo.taskList) do
        if k == taskId and v.taskStatus == ETaskStatus.CanFinish then
            return true
        end
    end
    return false
end
--检测任务是否完成
function CheckTaskFinished(taskId)
    return TaskInfo.finishedTask[taskId] ~= nil
end
--获取任务完成时间，若无数据则返回 -1
function GetTaskFinishedTime(taskId)
    if TaskInfo.finishedTask[taskId] == nil then
        return -1
    end
    return TaskInfo.finishedTask[taskId]
end

--等级改变的事件监听
function TaskInfoUpdateByBaseLvChanged(...)
    for k, v in pairs(TaskInfo.taskList) do
        v:UpdateTaskStatuWithLvUp()
    end
    -- CheckShouldShowTaskMailReceive()
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
end

function TaskInfoUpdateByJobLvChanged(...)
    for k, v in pairs(TaskInfo.taskList) do
        v:UpdateTaskStatuWithLvUp()
    end
    -- CheckShouldShowTaskMailReceive()
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
end

--根据子任务ID获取对应父任务ID
function GetParentTaskIdWithSubTaskId(taskId)
    for k, v in pairs(TaskInfo.taskList) do
        if v.isParentTask then
            for i = 1, #v.taskTargetList do
                local l_target = v.taskTargetList[i]
                if l_target.targetId == taskId then
                    return v.taskId
                end
            end
        end
    end
    return nil
end

function GetTaskStatusAndStep(taskId)
    local l_taskData = TaskInfo.taskList[taskId]
    if l_taskData == nil then
        return ETaskStatus.NotTake, 0
    end
    if l_taskData.taskStatus == ETaskStatus.Taked then
        return ETaskStatus.Taked, l_taskData:GetCurrentStep()
    end
    return l_taskData.taskStatus, 0
end

--根据任务ID获取任务状态
function GetPreShowTaskStatusWithTaskId(taskId)
    local l_taskData = TaskInfo.taskList[taskId]
    if l_taskData == nil then
        return ETaskStatus.NotTake
    end
    return l_taskData.taskStatus
end
--根据任务ID导航
function OnQuickTaskClickWithTaskId(taskId)
    if taskId == nil then
        logError("taskid  is nil")
        return
    end
    local l_taskData = TaskInfo.taskList[taskId]
    if l_taskData ~= nil then
        l_taskData:TaskNavigation()
    end
end

--切换页签
function OnQuickTaskTagClick(tag)
    TaskInfo.currentSelectTaskTag = tag
    GlobalEventBus:Dispatch(EventConst.Names.RefreshSelectTaskTag)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel, true)
end
--飞鸽-begin-
function ShowTaskAcceptMail(taskId)
    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon() then
        return
    end

    if taskId == 0 then
        return
    end

    local l_taskMailInfo = TableUtil.GetTaskFlyAcceptTable().GetRowByTaskId(taskId)
    if l_taskMailInfo == nil then
        logError("task <" .. taskId .. "> not exists in TaskFlyAcceptTable @王倩雯")
        return
    end

    if l_taskMailInfo.Type == 2 then
        UIMgr:ActiveUI(UI.CtrlNames.StoryBoard, { storyBoardId = l_taskMailInfo.StoryBoardId, callback = function(acceptTaskId)
            RequestTaskAccept(acceptTaskId)
        end, args = taskId })
        return
    end

    UIMgr:ActiveUI(UI.CtrlNames.Flying, function(ctrl)
        ctrl:ShowDetail(taskId)
    end)
end

-- function CheckShouldShowTaskMailReceive()
--     if TaskInfo.taskList == nil then return end
--     for k,v in pairs(TaskInfo.taskList) do
--         if v:AcceptMail() and v.taskStatus == ETaskStatus.CanTake  then
--             if not CheckMailTaskExists(k) then
--                 ShowTaskMailReceive(k)
--                 return
--             end
--         end
--     end
-- end
-- function ShowTaskMailReceive(taskId)
--     if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon() then
--         return
--     end
--     UIMgr:ActiveUI(UI.CtrlNames.TaskMail,function(ctrl)
--         ctrl:ShowTaskMailReceive(taskId)
--     end)
-- end
-- function CheckMailTaskExists(taskId)
--     for i=1,#taskShowMailFlag do
--         if taskId == taskShowMailFlag[i] then
--             return true
--         end
--     end
--     return false
-- end

--飞鸽-end-

--获取显示任务列表并排序
function ShowTaskFilter(isTaskUI, includeAcceptable)
    local l_showList = {}
    if isTaskUI == nil then
        isTaskUI = false
    end
    if includeAcceptable == nil then
        includeAcceptable = true
    end

    local l_unacceptableTasks = {}
    for k, v in pairs(TaskInfo.taskList) do
        if v:NeedShowOnUI(isTaskUI, includeAcceptable, TaskInfo.currentSelectTaskTag) then
            if v.taskStatus == ETaskStatus.NotTake then
                table.insert(l_unacceptableTasks, v)
            else
                table.insert(l_showList, v)
            end
        end
    end

    table.sort(l_showList, sortTask)
    table.sort(l_unacceptableTasks, sortTask)
    for i = 1, #l_unacceptableTasks do
        table.insert(l_showList, l_unacceptableTasks[i])
    end
    if isTaskUI then
        return l_showList
    end
    local l_quickShowList = {}
    for i = 1, MAX_PRE_SHOW_NUM do
        table.insert(l_quickShowList, l_showList[i])
    end

    return l_quickShowList
end

function sortTask(a, b)
    if a.showPriority == b.showPriority then
        return a.showTime > b.showTime
    else
        return a.showPriority < b.showPriority
    end
end

--验证任务是否可接并返回相应error
function TaskAcceptValidateIdentity(taskId)
    local taskTableInfo = GetTaskTableInfoByTaskId(taskId)

    --社交限制
    for i = 1, table.maxn(taskTableInfo.acceptLimitIdentity) do
        --队长
        if taskTableInfo.acceptLimitIdentity[i] == 2 then
            local captainUin, teamNum, member = DataMgr:GetData("TeamData").ReturnTaskNeededInfo()

            if captainUin == -1 or teamNum == 0 or #member == 0 then
                return ETaskAcceptFailed.Level
            end

            if taskTableInfo.minBaseLevel == 0 and taskTableInfo.maxBaseLevel == 0 then
            elseif taskTableInfo.minBaseLevel == 0 then
                for j = 1, table.maxn(member) do
                    if member[j].cLevel > taskTableInfo.maxBaseLevel then
                        return ETaskAcceptFailed.Level
                    end
                end
            elseif taskTableInfo.maxBaseLevel == 0 then
                for j = 1, table.maxn(member) do
                    if member[j].cLevel < taskTableInfo.minBaseLevel then
                        return ETaskAcceptFailed.Level
                    end
                end
            else
                for j = 1, table.maxn(member) do
                    if member[j].cLevel < taskTableInfo.minBaseLevel
                            or member[j].cLevel > taskTableInfo.maxBaseLevel then
                        return ETaskAcceptFailed.Level
                    end
                end
            end

            if taskTableInfo.minJobLevel == 0 and taskTableInfo.maxJobLevel == 0 then
            elseif taskTableInfo.minJobLevel == 0 then
                for j = 1, table.maxn(member) do
                    if member[j].cRoleJobLevel > taskTableInfo.maxJobLevel then
                        return ETaskAcceptFailed.Level
                    end
                end
            elseif taskTableInfo.maxJobLevel == 0 then
                for j = 1, table.maxn(member) do
                    if member[j].cRoleJobLevel < taskTableInfo.minJobLevel then
                        return ETaskAcceptFailed.Level
                    end
                end
            else
                for j = 1, table.maxn(member) do
                    if member[j].cRoleJobLevel < taskTableInfo.minJobLevel
                            or member[j].cRoleJobLevel > taskTableInfo.maxJobLevel then
                        return ETaskAcceptFailed.Level
                    end
                end
            end

            if MPlayerInfo.UID:tostring() ~= captainUin then
                return ETaskAcceptFailed.Captain
            end

            if #member ~= 2 then
                return ETaskAcceptFailed.Sex
            end

            if member[1].cSex == member[2].cSex then
                return ETaskAcceptFailed.Sex
            end
        end
    end

    --道具限制还没写
    for i = 1, table.maxn(taskTableInfo.acceptLimitItem) do
        local itemId = tonumber(taskTableInfo.acceptLimitItem[i][1])
        local itemNum = tonumber(taskTableInfo.acceptLimitItem[i][2])
        local propNum = Data.BagModel:GetCoinOrPropNumById(itemId)
        if propNum < itemNum then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_CAN_NOT_ACCEPT_TIP_5", Data.BagModel:GetItemNameText(itemId)))
            return ETaskAcceptFailed.ItemLimit
        end
    end

    if taskTableInfo.taskType == ETaskType.Commission and not MgrMgr:GetMgr("DelegateModuleMgr").IsCertifatesEnough(taskId) then
        return ETaskAcceptFailed.Commission
    end

    return ETaskAcceptFailed.None, taskTableInfo.taskType
end
--获取收集任务所需要的道具
function GetTaskItemInfo()
    local l_items = {}
    for k, v in pairs(TaskInfo.taskList) do
        local l_tmpItems = v:GetTaskNeedItem()
        for i = 1, #l_tmpItems do
            --table.insert(l_items, l_tmpItems[i])
            if not l_items[l_tmpItems[i].ID] then
                l_items[l_tmpItems[i].ID] = 0
            end
            l_items[l_tmpItems[i].ID] = l_items[l_tmpItems[i].ID] + l_tmpItems[i].Count
        end
    end
    return l_items
end

--根据任务ID获取接取npc 对话接取及飞鸽传书
function GetTaskAcceptNpc(taskId)
    local l_taskData = nil
    local l_taskInfo = TaskInfo.taskList[taskId]
    if l_taskInfo ~= nil then
        l_taskData = l_taskInfo.tableData
    end
    if l_taskData == nil then
        l_taskData = GetTaskTableInfoByTaskId(taskId)
    end
    if l_taskData == nil then
        return 0
    end
    if l_taskData.acceptType ~= ETaskAcceptType.Normal and l_taskData.acceptType ~= ETaskAcceptType.Mail then
        logError("task <" .. taskId .. "> is a auto accept task !")
        return 0
    end
    return l_taskData.acceptNpcId
end

--根据任务ID导航至接取npc  仅限正常接取类型的任务
function NavToTaskAcceptNpc(taskId)
    local l_taskData = nil
    local l_taskInfo = TaskInfo.taskList[taskId]
    if l_taskInfo ~= nil then
        l_taskData = l_taskInfo.tableData
    end
    if l_taskData == nil then
        l_taskData = GetTaskTableInfoByTaskId(taskId)
    end
    if l_taskData == nil then
        return
    end
    MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
    MgrMgr:GetMgr("ActionTargetMgr").StopAutoBattle()
    if l_taskData.acceptType ~= ETaskAcceptType.Normal then
        logError("task <" .. taskId .. "> is a auto accept task !")
        return
    end
    MgrMgr:GetMgr("ActionTargetMgr").MoveToTalkWithNpc(l_taskData.acceptNpcMapId, l_taskData.acceptNpcId)
end
--获取NPC名称
function GetNpcNameById(id)
    local l_npcData = TableUtil.GetNpcTable().GetRowById(id)
    if l_npcData == nil then
        logError("npc:<" .. tostring(id) .. "> not exists in NpcTable !")
        return ""
    end
    return l_npcData.Name
end
--获取怪物名称
function GetEnemyNameById(id)
    local entityTableRow = TableUtil.GetEntityTable().GetRowById(id)
    if entityTableRow == nil then
        logError("entity:<" .. id .. "> not exists in EntityTable")
        return ""
    end
    return entityTableRow.Name
end
--获取任务表格转换数据
function GetTaskTableInfoByTaskId(taskId, forValidate)
    local l_taskTable = TableUtil.GetTaskTable()
    if l_taskTable == nil then
        return nil
    end
    local l_tableData = l_taskTable.GetRowById(taskId)
    if l_tableData == nil then
        logError("task:<" .. taskId .. "> not exists in TaskTable !")
        return nil
    end
    return ParseTaskTableInfo(l_tableData, forValidate)
end
--根据任务id获取任务名称
function GetTaskNameByTaskId(taskId)
    local l_taskInfo = GetTaskTableInfoByTaskId(taskId)
    if l_taskInfo == nil then
        return StringEx.Format("NO_TASK_ID:<{0}>", tostring(taskId))
    end
    return l_taskInfo.name
end

------------------------外部接口--end------------------------------

--- 读出并转换任务表中的一行数据，读入的字段请在TaskTableData类声明处标明注释
---@param oneline any 表中的一行数据
---@param forValidate boolean true若只需数据用于校验任务是否可接，只返回部分数据
function ParseTaskTableInfo(oneLine, forValidate)
    ---@type TaskTableData
    local oneTaskTableInfo = {}
    oneTaskTableInfo.taskId = oneLine.Id
    oneTaskTableInfo.preTaskId = Common.Functions.VectorToTable(oneLine.PreId)
    oneTaskTableInfo.togetherPreId = Common.Functions.VectorToTable(oneLine.TogetherPreId)
    oneTaskTableInfo.taskType = oneLine.Type

    local lBaseLevelLimit = Common.Functions.SequenceToTable(oneLine.AcceptLimitBaseLevel)
    oneTaskTableInfo.minBaseLevel = lBaseLevelLimit[1]
    oneTaskTableInfo.maxBaseLevel = lBaseLevelLimit[2]
    local lJobLevelLimit = Common.Functions.SequenceToTable(oneLine.AcceptLimitJobLevel)
    oneTaskTableInfo.minJobLevel = lJobLevelLimit[1]
    oneTaskTableInfo.maxJobLevel = lJobLevelLimit[2]
    local l_pushLevelLimit = Common.Functions.SequenceToTable(oneLine.PushLevel)
    --特判奇闻 奇闻不需要pushBaseLevel
    if l_pushLevelLimit[1] == 0 and oneTaskTableInfo.taskType ~= ETaskType.WorldEvent then
        oneTaskTableInfo.pushBaseLevel = oneTaskTableInfo.minBaseLevel
    else
        oneTaskTableInfo.pushBaseLevel = l_pushLevelLimit[1]
    end

    if l_pushLevelLimit[2] == 0 then
        oneTaskTableInfo.hideBaseLevel = 0
    else
        oneTaskTableInfo.hideBaseLevel = l_pushLevelLimit[2]
    end

    oneTaskTableInfo.acceptLimitProfession = Common.Functions.VectorToTable(oneLine.AcceptLimitProfession)
    oneTaskTableInfo.acceptLimitGender = oneLine.AcceptLimitSex

    ---------- 与任务是否可接相关的数据请在return之前读出 ----------
    if forValidate then
        return oneTaskTableInfo
    end

    if oneLine.Name.Count < 1 then
        logError("taskId = <" .. oneLine.Id .. "> name is empty !@沈天考")
        oneTaskTableInfo.name = StringEx.Format("UnKnowName:<{0}>", tostring(oneLine.Id))
        oneTaskTableInfo.branchName = StringEx.Format("UnKnowName:<{0}>", tostring(oneLine.Id))
    else
        oneTaskTableInfo.name = oneLine.Name[0]
        oneTaskTableInfo.branchName = oneLine.Name[0]
        if oneLine.Name.Count == 2 then
            oneTaskTableInfo.branchName = oneLine.Name[1]
        end
    end

    oneTaskTableInfo.taskDesc = oneLine.TaskDes

    oneTaskTableInfo.acceptLimitIdentity = Common.Functions.VectorToTable(oneLine.AcceptLimitIdentity)
    oneTaskTableInfo.acceptLimitItem = Common.Functions.VectorSequenceToTable(oneLine.AcceptLimitItem)
    oneTaskTableInfo.acceptShowType = oneLine.ShortcutShowType
    oneTaskTableInfo.acceptType = oneLine.Accepttype
    oneTaskTableInfo.itemBeforeFinish = Common.Functions.VectorSequenceToTable(oneLine.ItemBeforeFinish)
    oneTaskTableInfo.finishType = oneLine.Finishtype

    oneTaskTableInfo.descAcceptable = oneLine.DescAcceptable
    -- oneTaskTableInfo.descAccepted = oneLine.DescAccepted
    oneTaskTableInfo.descCanFinish = oneLine.DescCanFinish

    local lAcceptNpc = Common.Functions.SequenceToTable(oneLine.AcceptNpc)
    oneTaskTableInfo.acceptNpcId = lAcceptNpc[1]
    oneTaskTableInfo.acceptNpcMapId = lAcceptNpc[2]
    local lFinishNpc = Common.Functions.SequenceToTable(oneLine.FinishNpc)
    oneTaskTableInfo.finishNpcId = lFinishNpc[1]
    oneTaskTableInfo.finishNpcMapId = lFinishNpc[2]

    oneTaskTableInfo.isAutoDrop = oneLine.AbandonType > 0
    oneTaskTableInfo.targetSubTasks = Common.Functions.VectorToTable(oneLine.TargetSubTasks)
    oneTaskTableInfo.targetSubTaskChoose = oneLine.TargetSubTaskChoose
    oneTaskTableInfo.talkScript = oneLine.TalkScript
    oneTaskTableInfo.talkAcceptScriptTag = oneLine.TaskAcceptScriptTag
    oneTaskTableInfo.talkFinishScriptTag = oneLine.TaskFinishScriptTag
    oneTaskTableInfo.target = {}
    oneTaskTableInfo.targetArg = {}
    oneTaskTableInfo.targetPosition = {}
    oneTaskTableInfo.dungeonPosition = {}
    oneTaskTableInfo.ignoreNav = {}
    oneTaskTableInfo.targetMsgEx = {}
    oneTaskTableInfo.targetDesc = {}
    oneTaskTableInfo.taskTriggers = Common.Functions.VectorVectorToTable(oneLine.TaskTrigger)
    oneTaskTableInfo.limitTime = oneLine.FinishLimitCD

    for i = 1, MAX_TASK_TARGET_COUNT do
        local tableInfo = oneLine["Target" .. i]
        if tableInfo.Count > 0 then
            local targetInfo = Common.Functions.VectorSequenceToTable(tableInfo)
            oneTaskTableInfo.target[i] = targetInfo[1][1]
            oneTaskTableInfo.targetArg[i] = targetInfo[2]
            oneTaskTableInfo.targetPosition[i] = targetInfo[3]
            oneTaskTableInfo.dungeonPosition[i] = nil
            if tableInfo.Count > 3 then
                oneTaskTableInfo.dungeonPosition[i] = targetInfo[4]
            end
            if tableInfo.Count > 4 then
                oneTaskTableInfo.ignoreNav[i] = targetInfo[5][1] == 1
            else
                oneTaskTableInfo.ignoreNav[i] = false
            end
        end
        oneTaskTableInfo.targetMsgEx[i] = oneLine["SpecialMes" .. i]
        oneTaskTableInfo.targetDesc[i] = oneLine["TargetDes" .. i]
    end

    oneTaskTableInfo.targetRunType = oneLine.TargetRunType
    oneTaskTableInfo.isReminder = oneLine.IsReminder

    local npcFavors = Common.Functions.VectorSequenceToTable(oneLine.NpcFavors)
    if table.maxn(npcFavors) > 0 then
        oneTaskTableInfo.delegateNpcId = npcFavors[1][1]
        oneTaskTableInfo.delegateNpcFavors = npcFavors[1][2]
    else
        oneTaskTableInfo.delegateNpcId = 0
        oneTaskTableInfo.delegateNpcFavors = 0
    end

    if #npcFavors > 1 then
        oneTaskTableInfo.taskLocationMap = npcFavors[2][1]
    else
        oneTaskTableInfo.taskLocationMap = 0
    end

    oneTaskTableInfo.rewardId = oneLine.RewardID
    -- 获取任务类型id所映射的数据
    local l_tagData = TableUtil.GetTaskTypeTable().GetRowById(oneTaskTableInfo.taskType)
    if l_tagData == nil then
        logError("task type <" .. oneTaskTableInfo.taskType .. "> not exists in TaskTypeTable !")
        oneTaskTableInfo.typeTag = ETaskTag.Adventure
        oneTaskTableInfo.typeTitle = "Error task type, please check!"
        oneTaskTableInfo.targetSelectionType = 1
        oneTaskTableInfo.signTip = 1
    else
        oneTaskTableInfo.typeTag = l_tagData.Theme
        oneTaskTableInfo.typeTitle = l_tagData.Title
        local l_selectType = l_tagData.TargetSelectionType
        if l_selectType == 0 then
            oneTaskTableInfo.targetSelectionType = 1
        else
            oneTaskTableInfo.targetSelectionType = l_tagData.TargetSelectionType
        end
        local l_signTip = l_tagData.TaskSignTip
        if l_signTip == 0 then
            oneTaskTableInfo.signTip = 1
        else
            oneTaskTableInfo.signTip = l_signTip
        end
    end
    oneTaskTableInfo.finishTips = oneLine.FinishTips
    local l_findWayType = oneLine.FindwayType
    if l_findWayType == 0 then
        oneTaskTableInfo.navType = 1
    else
        oneTaskTableInfo.navType = oneLine.FindwayType
    end
    oneTaskTableInfo.AcceptAutoPath = oneLine.AcceptAutoPath
    oneTaskTableInfo.HideSymbol = oneLine.HideSymbol
    oneTaskTableInfo.AwardExhibition = oneLine.AwardExhibition
    return oneTaskTableInfo
end
--全局事件注册
GlobalEventBus:Add(EventConst.Names.TalkDlgClosed,
        function()
            ShowTaskItem()
            CheckNewTaskNavigation()
        end
)

GlobalEventBus:Add(EventConst.Names.PhotographCompleted,
        function(idList, photoType)
            CheckAblumPhoto(idList, photoType)
        end)

MgrMgr:GetMgr("SmallGameMgr").EventDispatcher:Add(MgrMgr:GetMgr("SmallGameMgr").NOTIFY_GAME_RESULT,
        function(eventData)
            CheckQteComplete(eventData)
        end)

--检测任务是否是可接状态
function ValidateTaskAcceptable(taskId)
    local l_oneTaskData = GetTaskTableInfoByTaskId(taskId, true)
    if l_oneTaskData == nil then
        return false
    end
    return ValidateTaskAcceptableByTableData(l_oneTaskData)
end

function ValidateTaskAcceptableByTableData(tableData)
    local taskId = tableData.taskId
    if tableData.pushBaseLevel > MPlayerInfo.Lv then
        --DebugTaskError(taskId .. "推送Base等级不足")
        return false
    end
    -- if tableData.pushJobLevel > MPlayerInfo.JobLv then
    --     DebugTaskError(taskId.."推送Job等级不足")
    --     return false
    -- end
    local l_genderLimit = tableData.acceptLimitGender
    if l_genderLimit ~= 2 then
        local l_genderInt = MPlayerInfo.IsMale and 0 or 1
        if l_genderInt ~= l_genderLimit then
            DebugTaskError(taskId .. "性别不满足")
            return false
        end
    end

    local l_classIds = tableData.acceptLimitProfession
    --如果配置了职业限制  并且职业限制不为0
    if #l_classIds > 0 and l_classIds[1] ~= 0 then
        local l_classLimited = false
        for i = 1, #l_classIds do
            local l_classId = l_classIds[i]
            if l_classId == MPlayerInfo.ProfessionId then
                l_classLimited = true
                break
            end
        end
        if not l_classLimited then
            DebugTaskError(taskId .. "职业不符合")
            return false
        end
    end

    local l_preTaskIds = tableData.preTaskId
    local l_preTaskFinished = false
    if #l_preTaskIds == 0 then
        l_preTaskFinished = true
    else
        for i = 1, #l_preTaskIds do
            local l_preTaskId = l_preTaskIds[i]
            if CheckTaskFinished(l_preTaskId) then
                l_preTaskFinished = true
                break
            end
        end
    end

    if not l_preTaskFinished then
        DebugTaskError(taskId .. "前置任务未完成")
        return false
    end

    local l_togetherPreIds = tableData.togetherPreId
    if #l_togetherPreIds > 0 then
        for i = 1, #l_togetherPreIds do
            local l_preTaskId = l_togetherPreIds[i]
            if not CheckTaskFinished(l_preTaskId) then
                DebugTaskError(taskId .. "前置任务未完成")
                return false
            end
        end
    end
    return true
end

--检测是否可以寻路
function TaskNavigationLocked()
    --timeline播放过程|黑幕|切场景中不导航
    return MCutSceneMgr.IsPlaying or MgrMgr:GetMgr("BlackCurtainMgr").IsInBlackCurtain() or MStageMgr.IsSwitchingScene
end

--任务触发播放timeline
function PlayTaskTimeLine(timelineId)
    if MCutSceneMgr.IsPlaying then
        return
    end
    local l_timeLineInfo = TableUtil.GetCutSceneTable().GetRowByID(timelineId)
    if l_timeLineInfo == nil then
        logError("timeline id:" .. timelineId .. " not exists in CutSceneTable ")
        return
    end
    MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
    MCutSceneMgr:PlayImmById(timelineId, DirectorWrapMode.Hold)
end

function StopAllCoroutines(...)
    StopCameraCoroutine()
    StopHideUICoroutine()
end

function StopCameraCoroutine(...)
    if TaskTimer.changeCamera ~= nil then
        TaskTimer.changeCamera:Stop()
        TaskTimer.changeCamera = nil
    end
end

function StopHideUICoroutine(...)
    if TaskTimer.hideUI ~= nil then
        TaskTimer.hideUI:Stop()
        TaskTimer.hideUI = nil
    end
end

--使用任务道具
function TaskUseItem(itemId, time)
    local l_itemInfo = TableUtil.GetTaskItemUseTable().GetRowByUseItem(itemId)
    if l_itemInfo == nil and time > 0 then
        TaskHideTriggerUI(time)
        return
    end
    local l_cameraId = l_itemInfo.CameraId
    local l_cameraTime = l_itemInfo.CameraTime
    if l_cameraId == 0 or l_cameraTime == 0 then
        return
    end
    TaskChangeCamera(l_cameraId, 0, l_cameraTime)
end

--通过任务改变镜头
function TaskChangeCamera(cameraId, focusId, time)
    if cameraId == 0 then
        return
    end
    StopCameraCoroutine()
    if time == nil then
        time = 5
    end
    if focusId == nil or focusId == 0 then
        MPlayerInfo:Focus2Player(cameraId)
    else
        MPlayerInfo:Focus2Npc(cameraId, focusId)
    end
    TaskTimer.changeCamera = Timer.New(function(b)
        MPlayerInfo:ExitAdaptiveState()
    end, time)
    TaskTimer.changeCamera:Start()
end

--通过任务事件隐藏触发器UI
function TaskHideTriggerUI(time)
    if time == 0 then
        return
    end
    StopHideCoroutine()
    HideTriggerUI()
    TaskTimer.hideUI = Timer.New(function(b)
        ShowTriggerUI()
    end, time)
    TaskTimer.hideUI:Start()
end

function HideTriggerUI()
    TaskInfo.hideTriggerUICnt = TaskInfo.hideTriggerUICnt + 1
    if TaskInfo.hideTriggerUICnt == 1 then
        MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.TASK, false)
    end
end

function ShowTriggerUI()
    TaskInfo.hideTriggerUICnt = TaskInfo.hideTriggerUICnt - 1
    if TaskInfo.hideTriggerUICnt < 0 then
        TaskInfo.hideTriggerUICnt = 0
    end
    if TaskInfo.hideTriggerUICnt == 0 then
        MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.TASK, true)
    end
end

--服务器协议处理
--超时重新拉取服务器任务数据
function TaskRpcTimeOut()
    RequestGetTaskRecord()
end

function RequestGetTaskRecord()
    local l_msgId = Network.Define.Rpc.GetTaskRecord
    ---@type GetTaskRecordArg
    local l_sendInfo = GetProtoBufSendTable("GetTaskRecordArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, function(...)
        TaskRpcTimeOut()
    end)
end

function OnGetTaskRecord(msg)
    ---@type GetTaskRecordRes
    local l_info = ParseProtoBufToTable("GetTaskRecordRes", msg)
    if l_info.result ~= 0 then
        return
    end
    local l_selectedTaskId = GetSelectTaskID()  --获取当前选择的任务ID  用于之后还原
    ClearAllTaskInfo()
    MgrMgr:GetMgr("TaskTriggerMgr").OnTaskTriggerAll(l_info.task_triggers)
    InitTaskInfo(l_info.taskrecord, l_selectedTaskId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
end

--接取任务请求
function RequestTaskAccept(taskId, subTaskIndex, customData, callback)
    local l_validate, l_taskType = TaskAcceptValidateIdentity(taskId)
    if l_validate == ETaskAcceptFailed.None then
        --委托任务特判
        local l_isNotBranch = subTaskIndex == nil or subTaskIndex == 0
        if l_taskType == ETaskType.Commission and l_isNotBranch then
            MgrMgr:GetMgr("SystemFunctionEventMgr").EnterTaskEvent(taskId, function(eventData)
                SendTaskAcceptRequest(taskId, subTaskIndex, customData, callback)
            end, nil)
        else
            SendTaskAcceptRequest(taskId, subTaskIndex, customData, callback)
        end
        return
    elseif l_validate == ETaskAcceptFailed.ItemLimit then
        --道具不足提示在判断时候提示 因为那时候才能获取道具ID 这边直接返回
        return
    end
    local l_tipsKey = StringEx.Format("TASK_CAN_NOT_ACCEPT_TIP_{0}", l_validate)
    local l_tips = Common.Utils.Lang(l_tipsKey)
    if l_validate == ETaskAcceptFailed.Level then
        local l_limitedLv = GetTaskTableInfoByTaskId(taskId).minBaseLevel
        l_tips = StringEx.Format(l_tips, tostring(l_limitedLv))
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
end

--发送接取任务请求
function SendTaskAcceptRequest(taskId, subTaskIndex, customData, callback)
    if not subTaskIndex then
        subTaskIndex = 0
    end
    if customData == nil then
        customData = {}
    end
    local l_msgId = Network.Define.Rpc.TaskAccept
    ---@type TaskAcceptArg
    local l_sendInfo = GetProtoBufSendTable("TaskAcceptArg")
    l_sendInfo.task_id = taskId
    l_sendInfo.sub_task_id = subTaskIndex
    customData.callback = callback
    Network.Handler.SendRpc(l_msgId, l_sendInfo, customData, nil, nil, function(...)
        TaskRpcTimeOut()
    end)
end

--接取任务请求回调
function OnTaskAccept(msg, arg, customData)
    ---@type TaskAcceptRes
    local l_info = ParseProtoBufToTable("TaskAcceptRes", msg)
    if l_info.result == 0 then
        local task = GetTaskTableInfoByTaskId(l_info.task_id)
        if task ~= nil and task.taskType == ETaskType.Guild then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(GetColorText(Common.Utils.Lang("TASK_ACCEPT"), RoColorText.Yellow) .. task.name)
        end
        UpdateTaskList(l_info.task.tasks)
        if customData.callback then
            customData.callback()
        end
    else
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        local task = GetTaskTableInfoByTaskId(l_info.task_id)
        --奇闻任务接取任务的回调特判 不走这个协议
        if task and task.taskType == ETaskType.WorldEvent then
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
    UpdateExTaskInfo()
end

--任务完成协议处理
--完成任务请求
function RequestTaskFinish(taskId, customData, callback)
    if customData == nil then
        customData = {}
    end
    local l_msgId = Network.Define.Rpc.TaskFinish
    ---@type TaskFinishArg
    local l_sendInfo = GetProtoBufSendTable("TaskFinishArg")
    l_sendInfo.task_id = taskId
    customData.callback = callback
    Network.Handler.SendRpc(l_msgId, l_sendInfo, customData, nil, nil, function(...)
        TaskRpcTimeOut()
    end)
end

--完成任务请求回掉
function OnTaskFinish(msg, arg, customData)
    ---@type TaskFinishRes
    local l_info = ParseProtoBufToTable("TaskFinishRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        --完成的需求道具不足提示特判
        if l_info.result == ErrorCode.ERR_TASK_ITEM then
            local l_taskTableInfo = GetTaskTableInfoByTaskId(arg.task_id)
            for i = 1, table.maxn(l_taskTableInfo.itemBeforeFinish) do
                local l_itemId = tonumber(l_taskTableInfo.itemBeforeFinish[i][1])
                local l_itemNum = tonumber(l_taskTableInfo.itemBeforeFinish[i][2])
                local l_propNum = Data.BagModel:GetCoinOrPropNumById(l_itemId)
                if l_propNum < l_itemNum then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_CAN_NOT_FINISH_TIP_5", Data.BagModel:GetItemNameText(l_itemId)))
                end
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
    else
        if customData.callback then
            customData.callback()
        end
    end
end

--任务放弃协议处理
--放弃逻辑
function GiveUpTask(taskId)
    local l_key = Lang("TASK_GIVEUP_CONFIRM")
    local l_taskInfo = GetTaskTableInfoByTaskId(taskId)
    if l_taskInfo.taskType == ETaskType.Commission then
        l_key = MgrMgr:GetMgr("DelegateModuleMgr").GetDelegateTaskGiveUpTips()
    end
    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_key, function(...)
        RequestTaskGiveup(taskId)
    end)
end

--重新接取任务
function ReAcceptTask(taskId)
    local l_taskId = GetParentTaskIdWithSubTaskId(taskId)
    --没有父任务 就直接重新接取该任务
    if l_taskId == nil then
        TaskInfo.reacceptTaskId = taskId
    else
        --有父任务 保存下要重新接取的父任务ID
        TaskInfo.reacceptTaskId = l_taskId
    end
    RequestTaskGiveup(TaskInfo.reacceptTaskId)
end

--放弃任务请求
function RequestTaskGiveup(taskId, customData, callback)
    if customData == nil then
        customData = {}
    end
    local l_msgId = Network.Define.Rpc.TaskGiveup
    ---@type TaskGiveupArg
    local l_sendInfo = GetProtoBufSendTable("TaskGiveupArg")
    local l_parentTaskId = GetParentTaskIdWithSubTaskId(taskId)
    if l_parentTaskId ~= nil then
        l_sendInfo.task_id = l_parentTaskId
    else
        l_sendInfo.task_id = taskId
    end
    customData.callback = callback
    Network.Handler.SendRpc(l_msgId, l_sendInfo, customData, nil, nil, function(...)
        TaskRpcTimeOut()
    end)
end

--放弃任务请求回掉
function OnTaskGiveup(msg, arg, customData)
    ---@type TaskGiveupRes
    local l_info = ParseProtoBufToTable("TaskGiveupRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        local l_taskId = l_info.task_id

        if l_info.task == nil or l_info.task.task_id == 0 then
            RemoveOneTaskInfo(l_taskId)
        else
            RemoveOneTaskInfo(l_info.task_id)
            CacheTaskNpcData(l_info.task.task_id, l_info.task.accept_npc, l_info.task.finish_npc)
            OneTaskGiveUp(l_info.task)
            l_taskNpcCache[l_info.task.task_id] = nil
        end

        local task = GetTaskTableInfoByTaskId(l_taskId)
        if task ~= nil and #task.targetSubTasks == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(GetColorText(Common.Utils.Lang("TASK_GIVEUP"), RoColorTag.Yellow) .. task.name)
        end
        if l_taskId == TaskInfo.reacceptTaskId then
            TaskInfo.reacceptTaskId = -1
            NavToTaskAcceptNpc(l_taskId)
        end
        RemoveTasks(l_info.delete_tasks.task_ids)
        if customData.callback then
            customData.callback()
        end
    end
    UpdateExTaskInfo()
end

--放弃任务回调
function OneTaskGiveUp(taskInfo)
    if taskInfo.task_id == GetSelectTaskID() then
        ResetSelectTask()
        MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
    end
    -- local l_taskInfo = TaskInfo.taskList[taskInfo.task_id]
    -- DebugTaskYellow("OneTaskGiveUptaskInfo id:" .. taskInfo.task_id)
    -- if l_taskInfo ~= nil then
    --     DebugTaskYellow("OneTaskGiveUp GiveUp:" .. taskInfo.task_id)
    --     l_taskInfo:GiveUp()
    -- end
    UpdateOneTask(taskInfo)
end

--- 为true若当前已将任务数据清空（由于GM指令或跨线切换服务器）
local l_GSChange = false
--- 记录清空任务数据前的任务id
local l_GSChangeTaskId = 0
--- 记录清空任务数据前的任务归属页签
local l_GSChangeTagId = 0

--- 处理服务器下发的任务更新数据，来自Ptc.TaskUpdate协议
function OnTaskUpdate(msg)
    ---@type TaskUpdateData
    local l_info = ParseProtoBufToTable("TaskUpdateData", msg)
    --仅在GM指令cleartask 或跨线切换服务器 时才会进入该分支  用来重新刷新任务数据
    if l_info.tasks == nil or #l_info.tasks == 0 then
        l_GSChange = true
        l_GSChangeTagId = TaskInfo.currentSelectTaskTag -- 这边需要临时记录选中任务标签
        l_GSChangeTaskId = GetSelectTaskID() -- 这边需要临时记录选中任务
        InitTaskInfo()
        return
    end
    UpdateTaskList(l_info.tasks)
    UpdateExTaskInfo()

    --重置选中的任务标签 虽然直接选中任务会转换标签 但是任务存在丢失的可能
    if l_GSChangeTagId and l_GSChangeTagId > 0 then
        TaskInfo.currentSelectTaskTag = l_GSChangeTagId
        l_GSChangeTagId = 0
    end

    --重置选中的任务
    if l_GSChangeTaskId and l_GSChangeTaskId > 0 then
        local l_selectTaksData = GetTaskData(l_GSChangeTaskId)
        if l_selectTaksData then
            SetSelectTask(l_selectTaksData)
        end
        l_GSChangeTaskId = 0
    end

    --跨线之后任务重置完毕，清理new标记
    if l_GSChange then
        if TaskInfo and TaskInfo.newTaskTagCache then
            for k,v in pairs(TaskInfo.newTaskTagCache) do
                TaskInfo.newTaskTagCache[k] = false
            end
        end
        GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
        l_GSChange = false
    end
end

--任务删除下发处理
function OnTaskDelete(msg)
    ---@type TaskDeleteData
    local l_info = ParseProtoBufToTable("TaskDeleteData", msg)
    RemoveTasks(l_info.task_ids)
    UpdateExTaskInfo()
end

function UpdateExTaskInfo()
    UpdateNpcFxInViewport()
    GlobalEventBus:Dispatch(EventConst.Names.TaskInfoUpdate)
    GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskDetail)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshSelectTaskTag)
    --GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)  更新特效没必要刷新快捷任务面板
end

--检测是否有新接到的任务需要立即导航
function CheckNewTaskNavigation()
    if TaskInfo.lastAcceptTask ~= nil then
        TaskInfo.lastAcceptTask:TaskNavigation()
        TaskInfo.lastAcceptTask = nil
    end
end

--更新现有的任务列表
function UpdateTaskList(tasks, isLogin)
    if #tasks == 0 then
        return
    end
    --缓存所有接取和交付NPC数据 npcId和场景ID
    for i = 1, #tasks do
        local l_taskId = tasks[i].task_id
        CacheTaskNpcData(l_taskId, tasks[i].accept_npc, tasks[i].finish_npc)
    end
    local l_newTaskList = {}
    local l_nextTask = nil
    --筛选新接到的任务
    for i = 1, #tasks do
        local l_oneTaskData, l_acceptedOnce, l_newTask = UpdateOneTask(tasks[i], isLogin)
        if l_oneTaskData ~= nil then
            if l_acceptedOnce then
                table.insert(l_newTaskList, l_oneTaskData)
            end
            if l_newTask and l_oneTaskData:NeedShow() and not isLogin then
                local l_typeTag = l_oneTaskData.tableData.typeTag
                TaskInfo.newTaskTagCache[l_typeTag] = true
                if TaskInfo.preSelectTaskId ~= 0 and l_oneTaskData:CheckIsPreTask(TaskInfo.preSelectTaskId) then
                    local l_preTaskData = GetTaskTableInfoByTaskId(TaskInfo.preSelectTaskId)
                    if l_preTaskData ~= nil and l_preTaskData.taskType == l_oneTaskData.tableData.taskType then
                        l_nextTask = l_oneTaskData
                    end
                end
            end
        end
    end
    if #l_newTaskList == 0 and l_nextTask ~= nil then
        SetSelectTask(l_nextTask, nil)
        l_taskNpcCache = {}
        GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
        GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskUIFx, l_nextTask.taskId)
        return
    end
    for i = 1, #l_newTaskList do
        local l_taskData = l_newTaskList[i]
        if l_taskData:NeedShow() then
            if l_taskData.tableData.taskType == ETaskType.WorldEvent and #l_taskData.tableData.preTaskId == 0 then
                local l_taskName = l_taskData.tableData.name
                local l_tips = StringEx.Format(Common.Utils.Lang("WROLD_TASK_ACCEPTED"), l_taskName)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
                SetSelectTag(l_taskData.tableData.typeTag)
            end
            --如果该任务是接到后立即寻路则认为该任务是新接取的任务
            if l_taskData:NavigateAtOnce() and not isLogin then
                TaskInfo.lastAcceptTask = l_taskData
            end
        end
    end
    --新接到的任务立即导航
    if TaskInfo.lastAcceptTask ~= nil then
        if TaskInfo.lastAcceptTask.tableData.AcceptAutoPath and not MPlayerInfo.IsTalking then
            TaskInfo.lastAcceptTask:TaskNavigation()
        else
            SetSelectTask(TaskInfo.lastAcceptTask)
        end
    end
    l_taskNpcCache = {}
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
    if TaskInfo.lastAcceptTask ~= nil then
        GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskUIFx, TaskInfo.lastAcceptTask.taskId)
    end
    TaskInfo.lastAcceptTask = nil

end

function RemoveTasks(tasks)
    for i = 1, #tasks do
        --RemoveOneTaskInfo 不会处理完成任务列表  所以要先行处理
        local l_taskId = tasks[i].value
        if TaskInfo.finishedTask[l_taskId] then
            TaskInfo.finishedTask[l_taskId] = nil
        end
        RemoveOneTaskInfo(l_taskId)
    end
end

--从任务列表里移除一个任务
function RemoveOneTaskInfo(taskId)
    local l_taskData = TaskInfo.taskList[taskId]
    DebugTaskYellow("RemoveOneTaskInfo id:" .. taskId)
    if l_taskData ~= nil then
        l_taskData:Destroy()
        TaskInfo.taskList[taskId] = nil
    end
    if taskId == GetSelectTaskID() then
        TaskInfo.preSelectTaskId = taskId
        ResetSelectTask()
        MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
    end
    GlobalEventBus:Dispatch(EventConst.Names.OneTaskRemove, taskId)
end

--有一个任务完成
function OneTaskFinished(taskInfo)
    TaskInfo.finishedTask[taskInfo.taskId] = taskInfo.time
    --任务列表里有说明是刚完成的
    if TaskInfo.taskList[taskInfo.taskId] ~= nil then
        RemoveOneTaskInfo(taskInfo.taskId)
        local l_taskData = GetTaskTableInfoByTaskId(taskInfo.taskId)
        if l_taskData ~= nil then
            if l_taskData.isReminder then
                ShowTaskFinishTips()
            end
            if not string.ro_isEmpty(l_taskData.finishTips) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_taskData.finishTips)
            end
            -- MAudioMgr:Play("event:/UI/MissionComplete")
        end
        GlobalEventBus:Dispatch(EventConst.Names.OnTaskFinishNotify, taskInfo.taskId)
        GlobalEventBus:Dispatch(EventConst.Names.TaskStatusUpdate, taskInfo.taskId, ETaskStatus.Finished, 0)
    else
        --不是刚完成的任务需要根据任务状态设置引导NPC的位置
        MgrMgr:GetMgr("TaskGuideNpcMgr").OnTaskInit(taskInfo.taskId, ETaskStatus.Finished, 0)
    end
end

--更新单个任务
function UpdateOneTask(taskInfo, isLogin)
    local l_taskInfo = ParseTaskInfo(taskInfo)
    DebugTaskYellow("UpdateOneTask taskInfo:" .. l_taskInfo.taskId .. ",status:" .. l_taskInfo.taskStatus)
    local l_taskStats = l_taskInfo.taskStatus

    if l_taskStats == ETaskStatus.Finished then
        OneTaskFinished(l_taskInfo)
        return
    end
    if l_taskStats == ETaskStatus.Abandoned then
        RemoveOneTaskInfo(l_taskInfo.taskId)
        return
    end
    --取名任务特殊处理
    if l_taskInfo.taskId == NameTaskID and l_taskStats == ETaskStatus.Taked then
        TaskInfo.hasNameTask = true
    end

    local l_taskData = TaskInfo.taskList[l_taskInfo.taskId]
    local l_first = false
    local l_newTask = false
    if l_taskData == nil then
        local l_taskTableInfo = GetTaskTableInfoByTaskId(l_taskInfo.taskId)
        if l_taskTableInfo == nil then
            logError("task <" .. l_taskInfo.taskId .. "> not exists in TaskTable!")
            return
        end
        OverrideNpcData(l_taskTableInfo)
        if IsParentTask(l_taskTableInfo) then
            require "Task/TaskParent"
            l_taskData = Task.TaskParent.new(l_taskTableInfo)
        elseif IsCycTask(l_taskTableInfo) then
            require "Task/TaskCircle"
            l_taskData = Task.TaskCircle.new(l_taskTableInfo)
        else
            l_taskData = Task.TaskBase.new(l_taskTableInfo)
        end
        TaskInfo.taskList[l_taskInfo.taskId] = l_taskData
        if l_taskStats == ETaskStatus.CanTake then
            l_newTask = true
        end
    else
        OverrideNpcData(l_taskData.tableData)
    end
    --同步任务数据
    local l_first = l_taskData:SyncTaskData(l_taskInfo, isLogin)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickOneTask, l_taskInfo.taskId)
    return l_taskData, l_first, l_newTask
end

--缓存服务器下发任务NPC数据
function CacheTaskNpcData(taskId, acceptNpc, finishNpc)

    local l_acceptNpc = {
        npcId = acceptNpc.npc_id,
        sceneId = acceptNpc.scene_id
    }
    local l_finishNpc = {
        npcId = finishNpc.npc_id,
        sceneId = finishNpc.scene_id
    }
    local l_npcData = {
        accept = l_acceptNpc,
        finish = l_finishNpc
    }

    l_taskNpcCache[taskId] = l_npcData
end

--根据服务器重写npc数据
function OverrideNpcData(tableData)
    local l_taskId = tableData.taskId
    local l_npcData = l_taskNpcCache[l_taskId]
    if l_npcData == nil then
        return
    end
    tableData.acceptNpcId = l_npcData.accept.npcId
    tableData.acceptNpcMapId = l_npcData.accept.sceneId
    tableData.finishNpcId = l_npcData.finish.npcId
    tableData.finishNpcMapId = l_npcData.finish.sceneId
end

function IsParentTask(tableData)
    --第一个目标类型是PARENT_TASK 并且子任务列表不为空则为父任务
    return tableData.target[1] == ETaskTargetType.ParentTask
end

function IsCycTask(tableData)
    --第一个目标类型是CYC_TASK为环任务
    return tableData.target[1] == ETaskTargetType.CycTask
end

function ParseTaskInfo(taskInfo)
    local oneTaskInfo = {}
    oneTaskInfo.taskId = taskInfo.task_id
    local l_status = taskInfo.status
    if l_status == nil then
        l_status = 0
    end
    oneTaskInfo.taskStatus = l_status
    oneTaskInfo.time = tonumber(taskInfo.status_time)
    oneTaskInfo.showTime = tonumber(taskInfo.acceptting_time)
    oneTaskInfo.targets = nil
    local l_targets = taskInfo.targets
    if l_targets == nil or #l_targets == 0 then
        return oneTaskInfo
    end
    oneTaskInfo.targets = {}
    local l_completedCnt = 0
    for i = 1, #l_targets do
        local l_targetInfo = l_targets[i]
        local l_target = {}
        l_target.Id = l_targetInfo.id
        if l_target.Id == nil then
            l_target.Id = 0
        end
        l_target.type = l_targetInfo.type
        l_target.targetId = l_targetInfo.target_id
        if l_target.type == ETaskTargetType.NpcTalk or l_target.type == ETaskTargetType.SpTalk then
            l_target.targetArg = l_targetInfo.scene_id
        end
        l_target.index = l_targetInfo.index
        l_target.step = l_targetInfo.step
        l_target.maxStep = l_targetInfo.max_step
        if l_target.step >= l_target.maxStep then
            l_completedCnt = l_completedCnt + 1
        end
        l_target.customTime = tonumber(l_targetInfo.time) or 0
        table.insert(oneTaskInfo.targets, l_target)
    end
    if l_completedCnt >= #oneTaskInfo.targets and oneTaskInfo.taskStatus == ETaskStatus.Taked then
        oneTaskInfo.taskStatus = ETaskStatus.CanFinish
    end
    return oneTaskInfo
end
-- ===================================虚拟任务 begin===================================
--该ID段中的任务均为前端伪造任务 无配置依赖 无服务器数据 用于给制造相关的需求用
--注意 18000000~18999999之间的任务Id为保留Id段 其他任务数据不可复用
--具体逻辑@周阳清楚
local l_virtualTaskIdCache = {

}

local l_virtualTaskIdMin = 18000000
local l_virtualTaskIdMax = 18999999
local l_virtualGlobalId = 0 --全局虚拟任务Id  应该不会同时创建出999999这么多个任务吧
function GetVirtualTask(virtualId)
    local l_virtualId = l_virtualTaskIdCache[virtualId]
    if l_virtualId ~= nil then
        return l_virtualId
    end
    l_virtualGlobalId = l_virtualGlobalId + 1
    l_virtualId = l_virtualTaskIdMin + l_virtualGlobalId
    --如果当前虚拟任务Id超限 放大10倍构建任务Id
    if l_virtualId > l_virtualTaskIdMax then
        l_virtualId = l_virtualTaskIdMin * 10 + l_virtualGlobalId
    end
    l_virtualTaskIdCache[virtualId] = l_virtualId
    return l_virtualId
end

--根据不同的制作类型伪造虚拟任务
function CreateVirtualTask(virtualType, virtualId, navigate)
    local l_taskId = GetVirtualTask(virtualId)
    if TaskInfo.taskList[l_taskId] ~= nil then
        return
    end
    local oneTaskInfo = {}
    oneTaskInfo.taskStatus = ETaskStatus.Taked
    oneTaskInfo.time = 0
    oneTaskInfo.showTime = 0
    oneTaskInfo.targets = nil
    local l_taskName = ""
    --扩展此处处理不同的制作类型需求
    if virtualType == ETaskVirtualType.EquipForge then
        local l_equipForgeTableInfo = TableUtil.GetEquipForgeTable().GetRowById(virtualId)
        if l_equipForgeTableInfo == nil then
            return nil
        end
        local l_forgeMaterials = Common.Functions.VectorSequenceToTable(l_equipForgeTableInfo.ForgeMaterials)
        oneTaskInfo.targets, oneTaskInfo.taskStatus = CreateVirutalTargetInfo(l_forgeMaterials)
        l_taskName = l_equipForgeTableInfo.Name
    end

    if oneTaskInfo.targets == nil then
        return nil
    end
    oneTaskInfo.taskId = l_taskId
    local l_taskTableData = {}
    l_taskTableData.taskId = l_taskId
    l_taskTableData.name = l_taskName
    l_taskTableData.taskType = ETaskType.Virtual
    l_taskTableData.taskDesc = ""
    local l_tagData = TableUtil.GetTaskTypeTable().GetRowById(l_taskTableData.taskType)
    if l_tagData == nil then
        logError("task type <" .. l_taskTableData.taskType .. "> not exists in TaskTypeTable !")
        l_taskTableData.typeTag = ETaskTag.Adventure
        l_taskTableData.typeTitle = "Error task type, please check"
        l_taskTableData.targetSelectionType = 1
    else
        l_taskTableData.typeTag = l_tagData.Theme
        l_taskTableData.typeTitle = l_tagData.Title
        local l_selectType = l_tagData.TargetSelectionType
        if l_selectType == 0 then
            l_taskTableData.targetSelectionType = 1
        else
            l_taskTableData.targetSelectionType = l_tagData.TargetSelectionType
        end
    end
    l_taskTableData.limitTime = 0
    l_taskTableData.targetRunType = ETargetRunType.Parallel
    l_taskTableData.navType = ETaskNavType.Normal
    require "Task/TaskVirtual"
    local l_taskData = Task.TaskVirtual.new(l_taskTableData, virtualType, virtualId)
    l_taskData:SyncTaskData(oneTaskInfo)

    if TaskInfo.taskList[oneTaskInfo.taskId] == nil then
        TaskInfo.taskList[oneTaskInfo.taskId] = l_taskData
        if navigate then
            SetSelectTag(l_taskTableData.typeTag)
        end
    end
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
end

function DeleteVirtualTask(virtualId)
    local l_taskId = GetVirtualTask(virtualId)
    DeleteVirtualTaskByTaskId(l_taskId)
end

function DeleteVirtualTaskByTaskId(taskId)
    RemoveOneTaskInfo(taskId)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
end

function CreateVirutalTargetInfo(requirements)
    local l_virtualTargets = {}
    local l_idx = 0
    local l_completedCnt = 0
    for i = 1, #requirements do
        local l_id = requirements[i][1]
        local l_count = requirements[i][2]
        if not MgrMgr:GetMgr("PropMgr").IsCoin(l_id) then
            l_idx = l_idx + 1
            local l_target = {}
            l_target.type = ETaskTargetType.Virtual
            l_target.targetId = l_id
            l_target.targetArg = 0
            l_target.step = Data.BagModel:GetCoinOrPropNumById(l_id)
            l_target.maxStep = l_count
            l_target.index = l_idx
            if l_target.step >= l_target.maxStep then
                l_completedCnt = l_completedCnt + 1
            end

            table.insert(l_virtualTargets, l_target)
        end
    end

    local l_taskStatus = ETaskStatus.Taked
    if l_completedCnt >= l_idx then
        l_taskStatus = ETaskStatus.CanFinish
    end

    return l_virtualTargets, l_taskStatus
end
-- ===================================虚拟任务 end===================================

-- ===================================客户端判断拍照触发任务条件 begin===================================
--任务触发一般由服务器触发 但是拍照时客户端的数据 所以有三个触发条件需要由客户端添加监听
--ETaskConditionType.PhotoNpc      拍照到NPC
--ETaskConditionType.PhotoEntity   拍照到怪物
--ETaskConditionType.PhotoPlace    拍摄到指定地点
--具体逻辑@刘立然

--CheckInCameraTable到TaskConditionTable的ID对应关联字典
local l_checkToConditionDic = {

}

--初始化需要监听拍照的条件项对应事件
function InitPhotoConditionEvent()
    --清空关联字典
    l_checkToConditionDic = {}
    --遍历TaskConditionTable
    local l_conditionTable = TableUtil.GetTaskConditionTable().GetTable()
    for k, v in pairs(l_conditionTable) do
        if v.Type == ETaskConditionType.PhotoNpc 
            or v.Type == ETaskConditionType.PhotoEntity 
            or v.Type == ETaskConditionType.PhotoPlace then

            --添加到拍照记录数据中
            MoonClient.MCheckInCameraManager.AddCheckInCameraById(v.TargetID)
            --记录关联关系
            l_checkToConditionDic[v.TargetID] = v.ID
            --调试用
            --logGreen("v.TargetID = "..tostring(v.TargetID))
            --logGreen("v.ID = "..tostring(v.ID))
        end
    end
end

--检测是否满足拍照触发任务条件
function CheckPhotoCondition(idList, photoType)
    --相机触发ID列表为空直接返回
    if not idList then return end
    --遍历ID看是否存在对应的condition
    local l_conditionIds = {}
    for i = 0, idList.Count - 1 do
        local l_tempId = idList[i]
        --调试用
        -- logGreen("l_tempId = "..l_tempId)
        -- logGreen("l_checkToConditionDic[l_tempId] = "..tostring(l_checkToConditionDic[l_tempId]))
        if l_checkToConditionDic[l_tempId] then
            local l_conditionId = l_checkToConditionDic[l_tempId]
            --如果存在对应condition则进一步判断
            local l_row = TableUtil.GetTaskConditionTable().GetRowByID(l_conditionId)
            --判断是否存在条件记录 是否有场景限制 是否满足
            if l_row and (l_row.Args == 0 or MScene.SceneID == l_row.Args) then
                --满足条件的对应的条件ID记录进列表
                table.insert(l_conditionIds, l_conditionId)
            end
        end
    end
    --发送给服务器
    if #l_conditionIds > 0 then
        --调试用
        -- logGreen("l_conditionIds[1] = "..tostring(l_conditionIds[1]))
        local l_msgId = Network.Define.Ptc.TakePhotoCondition
        local l_sendInfo = GetProtoBufSendTable("CondData")
        l_sendInfo.cond_id = l_conditionIds
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end
end


-- ===================================客户端判断拍照触发任务条件 end===================================

function GetTaskAcceptLifeSkillLimited(taskId)
    local l_acceptLimites = {}
    local l_acceptTable = TableUtil.GetTaskAcceptTable().GetTable()
    local l_acceptData = nil
    for c, v in pairs(l_acceptTable) do
        if v.TaskID == taskId then
            l_acceptData = v
            break
        end
    end
    if l_acceptData == nil then
        return l_acceptLimites
    end
    local l_regular = Common.Functions.VectorSequenceToTable(l_acceptData.Regular)
    for i = 1, #l_regular do
        local l_limited = l_regular[i]
        local l_limitedId = l_limited[1]
        local l_limitedArg = l_limited[2]
        local l_limitedData = TableUtil.GetTaskConditionTable().GetRowByID(l_limitedId)
        if l_limitedData ~= nil and l_limitedData.Type == 14 then
            table.insert(l_acceptLimites, { ID = l_limitedData.TargetID, level = l_limitedArg + 1 })
        end
    end

    local l_conds = Common.Functions.VectorSequenceToTable(l_acceptData.Triggercondition)
    for i = 1, #l_conds do
        local l_limited = l_conds[i]
        local l_limitedId = l_limited[1]
        local l_limitedArg = l_limited[2]
        local l_limitedData = TableUtil.GetTaskConditionTable().GetRowByID(l_limitedId)
        if l_limitedData ~= nil and l_limitedData.Type == 14 then
            table.insert(l_acceptLimites, { ID = l_limitedData.TargetID, level = l_limitedArg + 1 })
        end
    end
    return l_acceptLimites
end

function TestSwitchScene(...)
    MgrMgr:GetMgr("GmMgr").SendCommand("goto 52")
end

return ModuleMgr.TaskMgr