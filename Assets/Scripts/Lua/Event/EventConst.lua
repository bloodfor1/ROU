module("EventConst", package.seeall)

Names = {
    UpdateAutoBattleState = "UpdateAutoBattleState",
    PlayerDead = "PlayerDead",

    --收到聊天消息
    NewChatMsg = "NewChatMsg",

    --语音音量变化
    ChatAudioChanged="ChatAudioChanged",
    --显示主界面的聊天
    ShowMainChatCtrl = "ShowMainChatCtrl",
    --照相
    PhotoNumberChange = "PhotoNumberChange",
    CameraDistanceChange = "CameraDistanceChange",
    RefreshAlbum = "RefreshAlbum",
    DeleteAlbum = "DeleteAlbum",
    RefreshPhoto = "RefreshPhoto",
    PhotographCompleted = "PhotographCompleted",
    ClosePhotograph = "CLOSE_PHOTOGRAPH",
    TalkDlgClosed = "TalkDlgClosed",
    --头像
    HEAD_SET_HEDA = "HEAD_SET_HEDAINFO",

    --任务相关
    TaskInfoUpdate = "TaskInfoUpdate",
    --任务状态改变
    TaskStatusUpdate = "TaskStatusUpdate",
    --显示下一条提示
    ShowNextSpecialTip = "ShowNextSpecialTip",
    UpdateTaskUIFx = "UpdateTaskUIFx",
    HasNewSelectInfo = "HasNewSelectInfo",--有新的对话选项出现

    RefreshQuickTaskPanel = "RefreshQuickTaskPanel",--刷新快速任务面板
    RefreshQuickOneTask = "RefreshQuickOneTask", --刷新一个任务
    CancelSelectQuickTask = "CancelSelectQuickTask",--取消面板选中状态
    UpdateTaskTime = "UpdateTaskTime",--取消面板选中状态
    RefreshSelectTaskTag = "RefreshSelectTaskTag",
    RefreshTaskNavState = "RefreshTaskNavState", --刷新任务选中状态
    UpdateTaskDetail = "UpdateTaskDetail",
    OneTaskRemove = "OneTaskRemove",    --有任务删除了
    OnTaskFinishNotify = "OnTaskFinishNotify", -- 有任务完成了
    OnTaskFinishGiveUp = "OnTaskFinishGiveUp", --有任务放弃了
    TaskEventCastSkill = "TaskEventCastSkill",

    OnCloseShowPhoto = "OnCloseShowPhoto",--当关闭相册的时候

    OnPlayBlackCurtainCompleted = "OnPlayBlackCurtainCompleted",
    OnPhotoGraphComplete = "OnPhotoGraphComplete",
    OnQTEComplete = "OnQTEComplete",
    OnSingleCooingComplete = "OnSingleCooingComplete",
    OnSceneObjectComplete = "OnSceneObjectComplete",
    OnPlayerStopMoveForTask = "OnPlayerStopMoveForTask",
    OnUseItemForTask = "OnUseItemForTask",
    OnTaskNpcAction = "OnTaskNpcAction",
    OnShowAction = "OnShowAction",
    OnDanceStatusModified = "OnDanceStatusModified",

    PlayerOutLookChange = "PlayerOutLookChange",
    UpdateAllInfo = "UpdateAllInfo", --更新所有任务信息

    SkillCtrlTypeChange = "SkillCtrlTypeChange", --技能操作模式变化
    TAKEVEHICLE = "TAKEVEHICLE", -- 上下载具
    LEAVESCENEOBJ = "LEAVESCENEOBJ", --离开场景交互

    MAIN_UI_UPDATE_WITH_SCENE = "MAIN_UI_UPDATE_WITH_SCENE", -- 根据场景刷新主ui
    ARENA_MIN_OFFER = "ARENA_MIN_OFFER", -- 最小化请求
    ARENA_CLOSE_OFFER = "ARENA_CLOSE_OFFER", -- 关闭擂台请求

    RefreshFightAutoPanel = "REFRESH_FIGHT_AUTO_PANEL",--刷新自动战斗列表
    DragJoyStick = "DragJoyStick", -- 移动遥杆
    ScrollOperation = "ScrollOperation", --滚动或放大缩小操作

    ChangeScene = "ChangeScene", --切换场景
    EnterScene = "EnterScene", --进入场景
    LeaveScene = "LeaveScene", --离开场景
    BeginTouchJoyStack = "BeginTouchJoyStack", --移动
    OnClickGroud = "OnClickGroud",  --点击地板
    OnNavigationMove = "OnNavigationMove",      --寻路
    SceneInteractClick = "SceneInteractClick",  --场景交互物件点击交互按钮
    QualityLevelChange = "QualityLevelChange",  --场景画面质量
    SceneLineChange = "SceneLineChange",        --所在线路
    ---显示/隐藏线路面板，若显示则同时更新可切线路信息
    UpdateSceneLinesPanel = "UpdateSceneLinesPanel",
    ---获取场景线路信息
    GetStaticSceneLine = "GetStaticSceneLine",

    UnitAppearChatRoomData = "UnitAppearChatRoomData", --聊天室数据

    --剧情
    CutSceneStart = "CutSceneStart",
    CutSceneStop = "CutSceneStop",
    CutScenePause = "CutScenePause",

    --polly
    OnDiscoverPolly = "OnDiscoverPolly",
    OnDiscoverPollyToRegion = "OnDiscoverPollyToRegion",
    OnModifyPollyRegionAward = "OnModifyPollyRegionAward",
    OnModifyPollyTypeAward = "OnModifyPollyTypeAward",

	--公会绑群相关
    WXQueryGroupStatusEvent = "WXQueryGroupStatusEvent",  --微信 查询工会群状态回调
    QQQueryGroupStatusEvent = "QQQueryGroupStatusEvent",  --QQ 查询工会是否绑定QQ群回调
    QQQueryGroupInfoEvent = "QQQueryGroupInfoEvent",  --QQ 查询用户与群的关系回调
    GuildGroupCreatEvent = "GuildGroupCreatEvent",  --创建公会群
    GuildGroupJoinEvent = "GuildGroupJoinEvent",  --加入公会群
    GuildGroupUnbindEvent = "GuildGroupUnbindEvent",  --解绑公会群
    GuildGroupRemindLeaderEvent = "GuildGroupRemindLeaderEvent",  --提醒会长创建公会群
	--后台返回
    GetBackGame = "GetBackGame",
    SetYesNoDlgBtnGray = "SetYesNoDlgBtnGray",   --将双按钮对话框的按钮置灰

    SendAimTarget = "SendAimTarget",   --获取周围敌方单位
    BossAimOut = "BossAimOut",      --BOSS出现在玩家技能范围内
    BossAimIn = "BossAimIn",        --BOSS离开玩家技能范围内
    BossAimSettingChange = "BossAimSettingChange",  -- BOSS进出视野设置改变
    BossHPUpdate = "BossHPUpdate",  -- BOSS血量更新


    ----------------登录流程相关-----------------
    REQ_QUREY_GATE_IP_SUCCESS = "REQ_QUREY_GATE_IP_SUCCESS",
    REQ_QUREY_GATE_IP_ERROR = "REQ_QUREY_GATE_IP_ERROR",
    ON_AUTH_SUCCESS = "ON_AUTH_SUCCESS",
    ON_AUTH_FAILED = "ON_AUTH_FAILED",

    REQ_LOGIN_CONNECT_ERROR = "REQ_LOGIN_CONNECT_ERROR",
    ON_GAME_LOGOUT_EVENT = "ON_GAME_LOGOUT_EVENT",
    ON_ACCOUNT_LOGOUT_EVENT = "ON_ACCOUNT_LOGOUT_EVENT",
    UI_SET_TARGET_SERVER = "UI_SET_TARGET_SERVER",
    ON_SDK_GET_USER_INFO_CALLBACK = "ON_SDK_GET_USER_INFO_CALLBACK",
    ON_SDK_BIND_ACCOUNT_CALLBACK = "ON_SDK_BIND_ACCOUNT_CALLBACK",
}
