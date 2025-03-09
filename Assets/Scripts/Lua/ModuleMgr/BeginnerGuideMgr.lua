---
--- Created by cmd(TonyChen).
--- DateTime: 2018/9/19 23:14
---
---@module ModuleMgr.BeginnerGuideMgr
module("ModuleMgr.BeginnerGuideMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--快捷任务面板指引事件
QUICK_TASK_GUIDE_EVENT = "QUICK_TASK_GUIDE_EVENT"
--新手指引一步完成事件
BEGINER_GUIDE_ONE_STEP_OVER = "BEGINER_GUIDE_ONE_STEP_OVER"
--玩法说明界面关闭事件
HOW_TO_PLAY_PANEL_CLOSE = "HOW_TO_PLAY_PANEL_CLOSE"
--主界面系统按钮指引事件
OPEN_SYSTEM_BUTTON_GUIDE_EVENT = "OPEN_SYSTEM_BUTTON_GUIDE_EVENT"
--快捷物品使用界面指引事件
PROP_ICON_GUIDE_EVENT = "PROP_ICON_GUIDE_EVENT"
--OX按钮指引事件
OX_BUTTON_GUIDE_EVENT = "OX_BUTTON_GUIDE_EVENT"
--技能加点按钮指引事件
SKILL_ADD_BUTTON_GUIDE_EVENT = "SKILL_ADD_BUTTON_GUIDE_EVENT"
--NPC对话界面选项按钮指引事件
TALKDLG_OPTION_BUTTON_GUIDE_EVENT = "TALKDLG_OPTION_BUTTON_GUIDE_EVENT"

--显示新手引导
ShowSceneObjControllerGuideEvent="ShowSceneObjControllerGuideEvent"
------------- END 事件相关  -----------------

--新手指引数据
l_guideData = DataMgr:GetData("BeginnerGuideData")

isLoginEnter = false  -- 是否是登录进入
local l_timer = nil  --技能切换延迟计时器

function OnInit()
    GlobalEventBus:Add(EventConst.Names.CutSceneStop, OnCutSceneStop, ModuleMgr.BeginnerGuideMgr)
    GlobalEventBus:Add(EventConst.Names.TaskStatusUpdate, OnTaskStatusUpdate, ModuleMgr.BeginnerGuideMgr)
    Data.PlayerInfoModel.BASELV:Add(Data.onDataChange, OnBaseLevelUp, ModuleMgr.BeginnerGuideMgr)
end

function OnUninit()
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.CutSceneStop, ModuleMgr.BeginnerGuideMgr)
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.TaskStatusUpdate, ModuleMgr.BeginnerGuideMgr)
    Data.PlayerInfoModel.BASELV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.BeginnerGuideMgr)
end

--断线重连 新手指引无需变化
function OnReconnected(reconnectData)

end

--登出时初始化相关信息
function OnLogout()
    isLoginEnter = false
    if l_timer then
        l_timer:Stop()
        l_timer = nil
    end
end

--获取服务器base上限等级
function GetBaseLevelUpperLimitByServerLevel(serverLv)
    local l_rows = TableUtil.GetServerLevelTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        if l_row.ServeLevel == serverLv then
            return l_row.BaseLevelUpperLimit
        end
    end
    return 0
end

--玩法说明界面关闭
function HowToPlayClose()
    EventDispatcher:Dispatch(HOW_TO_PLAY_PANEL_CLOSE)
end

--确认是否展示新手指引 来自CS的消息
function CheckShowBeginnerGuideFromCS(luaType, ...)
    local l_checkTable = { ... }
    CheckShowBeginnerGuide(l_checkTable)
end

--确认是否展示新手指引 来自CS的消息 通过数组传递
function CheckShowBeginnerGuideFromCSWithArray(luaType, args)
    local l_res = {}
    for i = 0, args.Length - 1 do
        table.insert(l_res, args[i])
    end
    CheckShowBeginnerGuide(l_res)
end

--确认新手指引mask是否开启过
---@param maskId number 新手引导Mask表ID
---@return boolean
function CheckGuideMask(maskId)
    if l_guideData and l_guideData.guideState then
        return l_guideData.guideState[maskId]
    end
    return false
end

--确认是否展示新手指引
--checkTable 待检查是否触发的新手指引标签表  现在TutorialIndexTable表ID是字符串 其实我觉得换成数字会比较好 无时间改 暂缓 cmd
--parentPanelName 父界面名称
--customSortingOrder 自定义层级
function CheckShowBeginnerGuide(checkTable, parentPanelName, customSortingOrder)
    --登录初始化未完毕 不接受任何指引操作
    if not isLoginEnter then
        return
    end
    --依序遍历要展示指引Key
    for i = 1, #checkTable do
        local l_row_check = TableUtil.GetTutorialIndexTable().GetRowByID(checkTable[i])
        if not l_row_check then
            logError("@litao TutorialIndexTable can find checkId , checkId = " .. tostring(checkTable[i]))
            return
        end
        local l_conditions = l_row_check.Condition
        --初始化是否可展示新手指引标志
        local l_isCheck = l_row_check.Enable
        --判断是否已完成
        if l_isCheck then
            for i = 0, l_conditions.Count - 1 do
                if l_guideData.guideState[l_conditions[i][0]] ~= (l_conditions[i][1] == 1) then
                    l_isCheck = false
                    break
                end
            end
        end

        --职业限制确认
        if l_isCheck then
            l_isCheck = CheckProfessionLimit(l_row_check.ProfessionLimit)
        end

        --等级限制确认
        if l_isCheck then
            l_isCheck = CheckLevelLimit(l_row_check.LevelLimit)
        end

        -- 特殊需求特判处理
        if l_isCheck then
            l_isCheck = SpecialConditionCheck(checkTable[i])
        end

        -- 如果符合当前的条件则执行 不再确认后续的Key
        if l_isCheck then
            ShowBeginnerGuide(l_row_check.StepID, parentPanelName, customSortingOrder)
            break
        end
    end
end

--确认职业限定
function CheckProfessionLimit(professionLimit)
    if professionLimit and professionLimit.Count > 0 then
        for i = 0, professionLimit.Count - 1 do
            if professionLimit[i] == MPlayerInfo.ProfessionId then
                return true
            end
        end
        return false
    else
        return true
    end
end

--确认等级限定
function CheckLevelLimit(levelLimit)
    if levelLimit then
        --存在等级下限 并且不到等级下限 则失败
        if levelLimit[0] ~= 0 and MPlayerInfo.Lv < levelLimit[0] then
            return false
        end
        --存在等级上限 并且超过等级下限 则失败
        if levelLimit[1] ~= 0 and MPlayerInfo.Lv > levelLimit[1] then
            return false
        end
    end

    return true
end

--特殊条件确认
function SpecialConditionCheck(checkKey)

    if checkKey == "ProfQualityPoint" then
        -- 属性点界面 特判是否已达到一转
        local l_proType = DataMgr:GetData("SkillData").CurrentProTypeAndId()
        if l_proType == 0 then
            return false
        end
    elseif checkKey == "ServerLevel" then
        -- 属性点界面 特判是否已达到服务器等级上限
        local l_severData = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData
        if l_severData.serverlevel ~= nil then
            local serverBaseLimit = GetBaseLevelUpperLimitByServerLevel(l_severData.serverlevel)
            if MPlayerInfo.Lv < serverBaseLimit then
                return false
            end
        else
            return false
        end
    elseif checkKey == "Entrust3" then
        -- 委托界面 特判是否已经消耗20点委托
        return MgrMgr:GetMgr("DelegateModuleMgr").IsHistroyCost(20)
    elseif checkKey == "Entrust4" then
        -- 委托界面 特判完成过委托的第二天
        return MgrMgr:GetMgr("DelegateModuleMgr").IsHistroyRefresh()
    elseif checkKey == "Entrust1" or checkKey == "Entrust5" then
        -- 主界面委托按钮 如果委托按钮没有显示 则不显示新手指引
        local l_mainUi = UIMgr:GetUI(UI.CtrlNames.Main)
        if l_mainUi then
            local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
            return l_openSystemMgr.IsSystemButtonCanShow(l_openSystemMgr.eSystemId.Delegate)
        end
        return false
    elseif checkKey == "NewRoleGuide" then
        -- 角色信息界面 经验加成引导
        local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
        if l_roleInfoMgr and l_roleInfoMgr.SeverLevelData and l_roleInfoMgr.SeverLevelData.basebonus then
            return l_roleInfoMgr.SeverLevelData.basebonus > 0
        end
        return false
    end

    return true
end

--确认任务状态是否可以展示指引
function CheckTaskStatus(stepInfo)
    local l_isCheck = true
    --如果有指定任务状态的需求 则判断 不符合则不展示
    if stepInfo.Type == 2 and stepInfo.ValueId and stepInfo.ValueId > 0 and stepInfo.TaskStatus.Count > 0 then
        local l_aimTaskState = MgrMgr:GetMgr("TaskMgr").GetPreShowTaskStatusWithTaskId(stepInfo.ValueId)
        local l_isAimStatus = false
        for i = 0, stepInfo.TaskStatus.Count - 1 do
            if l_aimTaskState == stepInfo.TaskStatus[i] then
                l_isAimStatus = true
                break
            end
        end
        if not l_isAimStatus then
            l_isCheck = false
        end
    end
    return l_isCheck
end

--展示新手指引
--guideStepId  新手指引的编号
--parentPanelName  指定父界面 NPC界面用
function ShowBeginnerGuide(guideStepId, parentPanelName, customSortingOrder)
    --登录初始化未完毕 不接受任何指引操作
    if not isLoginEnter then
        return
    end
    --指引ID判空
    if not guideStepId then
        logError("get guildStep is nil no guideStepId get")
        return
    end
    --如果当前步骤正在展示 则不做处理
    if l_guideData.curGuideId == guideStepId then
        return
    end
    --如果有当前正在展示的 优先停止
    if l_guideData.curGuideId then
        OnOneGuideOver(true, l_guideData.curGuideId)
        UIMgr:DeActiveUI(UI.CtrlNames.GuideDescribe)  --强制关闭一次说明界面 防止卡死
    end
    --获取步骤信息
    local l_row = TableUtil.GetTutorialConfigTable().GetRowByID(guideStepId)
    if not l_row then
        l_guideData.curGuideId = nil
        logError("Guide Id is error @DaiRuiXuan , guideStepId = " .. tostring(guideStepId))
        return
    end
    --如果有指定任务状态的需求 则判断 不符合则不展示
    if not CheckTaskStatus(l_row) then
        l_guideData.curGuideId = nil
        return
    end
    --延时开始前计入当前的步骤ID
    l_guideData.curGuideId = guideStepId
    --根据表中的时延 展示指引
    local l_timer = Timer.New(function(b)
        --时延结束后先检查步骤ID是否对应 不对应则表示 已被覆盖 本次展示取消
        if guideStepId ~= l_guideData.curGuideId then
            return
        end
        --时延后再次判断 任务状态是否可以开启指引
        if not CheckTaskStatus(l_row) then
            l_guideData.curGuideId = nil
            return
        end
        if l_row.Type == l_guideData.EGuideType.NpcDescribe then
            ShowNpcDescribeGuide(l_row, parentPanelName, customSortingOrder)
        elseif l_row.Type == l_guideData.EGuideType.SelectControlMod then
            ShowSelectControlMod(l_row.UIText)
        elseif l_row.Type == l_guideData.EGuideType.Task then
            ShowQuickTaskGuide(l_row)
        elseif l_row.Type == l_guideData.EGuideType.Skill or l_row.Type == l_guideData.EGuideType.SkillForce then
            ShowSkillControllerGuide(l_row)
        elseif l_row.Type == l_guideData.EGuideType.MainUI then
            ShowMianIntroductionGuide()
        elseif l_row.Type == l_guideData.EGuideType.SceneObjButton then
            ShowSceneObjControllerGuide(l_row)
        elseif l_row.Type == l_guideData.EGuideType.HowToPlay then
            ShowHowToPlayPanel(l_row.ValueId)
        elseif l_row.Type == l_guideData.EGuideType.OpenSystemButton then
            ShowOpenSystemButtonGuide(l_row)
        elseif l_row.Type == l_guideData.EGuideType.PropIcon then
            ShowPropIconButtonGuide(l_row)
        elseif l_row.Type == l_guideData.EGuideType.OXButton then
            ShowOXButtonGuide(l_row)
        elseif l_row.Type == l_guideData.EGuideType.SkillAddBtn then
            ShowSkillAddButtonGuide(l_row)
        elseif l_row.Type == l_guideData.EGuideType.TalkDlgOptionBtn then
            ShowTalkDlgOptionButtonGuide(l_row)
        else
            logError("Guide type is error @阿黛尔 , guideStepId = " .. tostring(guideStepId))
        end
        --定时关闭  技能面板如果没开启 现在会重置l_guideData.curGuideId 所以如果有l_guideData.curGuideId 才开启定时关闭
        if l_guideData.curGuideId and l_row.CountDownData[1] > 0 then
            CountTimeToOverStep(l_row.ID, l_row.Type, l_row.CountDownData[1])
        end
    end, l_row.CountDownData[0] / 1000)
    l_timer:Start()
end

--NPC介绍型指引展示
function ShowNpcDescribeGuide(stepInfo, parentPanelName, customSortingOrder)

    local l_isNeedClose = true
    if stepInfo.NextStepId and stepInfo.NextStepId > 0 then
        local l_rowNext = TableUtil.GetTutorialConfigTable().GetRowByID(stepInfo.NextStepId)
        if l_rowNext and l_rowNext.Type == 0 then
            l_isNeedClose = false
        end
    end

    local l_openData = {
        type = l_guideData.EUIOpenType.GuideDescribeShow,
        stepInfo = stepInfo,
        isNeedClose = l_isNeedClose,
        ParentPanelName = parentPanelName,
        CustomSortingOrder = customSortingOrder
    }


    if parentPanelName then
        local l_insertGroupName = UIMgr:GetGroupNameAccordingToActivePanelName(parentPanelName)
        if l_insertGroupName then
            local l_uiPanelConfigData= {}
            l_uiPanelConfigData.InsertGroupName = l_insertGroupName
            UIMgr:ActiveUI(UI.CtrlNames.GuideDescribe, l_openData, l_uiPanelConfigData)
        end
    else
        UIMgr:ActiveUI(UI.CtrlNames.GuideDescribe, l_openData)
    end

end

--展示操作模式选择界面
function ShowSelectControlMod(describeText)
    local describes = string.ro_split(describeText, "|")
    UIMgr:ActiveUI(UI.CtrlNames.SelectControllMod, function(ctrl)
        if describes and #describes > 1 then
            ctrl:SetModTitle(describes[1], describes[2])
        end
    end)
end

--快捷任务面板指引展示
function ShowQuickTaskGuide(stepInfo)
    if not UIMgr:IsActiveUI(UI.CtrlNames.QuickPanel) then
        l_guideData.curGuideId = nil
        return
    end
    EventDispatcher:Dispatch(QUICK_TASK_GUIDE_EVENT, stepInfo)
end

--技能操作面板指引展示
function ShowSkillControllerGuide(stepInfo)

    local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")
    --主界面操作切换加锁
    l_mainUIMgr.IsSwitchUILock = true
    if not l_mainUIMgr.IsShowSkill then
        l_mainUIMgr.ShowSkill(true) -- 切换到技能面板

        --主界面切换动画播放完成后事件
        l_mainUIMgr.EventDispatcher:Add(l_mainUIMgr.ON_MAIN_UI_SWITCH_OVER,
            function()
                --局部参数重新获取
                local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")
                local l_skillController = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
                if l_skillController and l_skillController.IsShowing then
                    l_skillController:SetAsLastSibling()
                    l_skillController:ShowBeginnerGuide(stepInfo.ID)
                else
                    l_guideData.curGuideId = nil
                end
                --主界面切换解锁 移除事件 无论是否正常开启指引 必须解锁
                l_mainUIMgr.IsSwitchUILock = false
                l_mainUIMgr.EventDispatcher:RemoveObjectAllFunc(l_mainUIMgr.ON_MAIN_UI_SWITCH_OVER, ModuleMgr.BeginnerGuideMgr)
            end, ModuleMgr.BeginnerGuideMgr)

    else
        local l_skillController = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
        if l_skillController and l_skillController.IsShowing then
            l_skillController:SetAsLastSibling()
            l_skillController:ShowBeginnerGuide(stepInfo.ID)
        else
            l_guideData.curGuideId = nil
        end
        --无论是否正常开启指引 必须解锁
        l_mainUIMgr.IsSwitchUILock = false
    end

end

--主界面介绍指引展示
function ShowMianIntroductionGuide()
    UIMgr:ActiveUI(UI.CtrlNames.GuideMainIntroduction)
end

--场景交互按钮指引展示
function ShowSceneObjControllerGuide(stepInfo)
    EventDispatcher:Dispatch(ShowSceneObjControllerGuideEvent, stepInfo)
end

--玩法说明
function ShowHowToPlayPanel(gameTipsID)
    UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
        ctrl:ShowPanel(gameTipsID)
    end)
    OnOneGuideOver()
end

--主界面系统按钮指引展示
function ShowOpenSystemButtonGuide(stepInfo)
    local l_mainUi = UIMgr:GetUI(UI.CtrlNames.Main)
    if not l_mainUi then
        l_guideData.curGuideId = nil
        return
    end

    EventDispatcher:Dispatch(OPEN_SYSTEM_BUTTON_GUIDE_EVENT, stepInfo)
end

--快捷物品使用指引展示
function ShowPropIconButtonGuide(stepInfo)
    if not UIMgr:IsActiveUI(UI.CtrlNames.PropIcon) then
        l_guideData.curGuideId = nil
        return
    end
    EventDispatcher:Dispatch(PROP_ICON_GUIDE_EVENT, stepInfo)
end

--OX按钮指引展示
function ShowOXButtonGuide(stepInfo)
    --OX类型不确定界面 所以需要先置空 如果有接收事件的地方再设置
    l_guideData.curGuideId = nil
    EventDispatcher:Dispatch(OX_BUTTON_GUIDE_EVENT, stepInfo)
end

--技能加点面板技能加点按钮指引展示
function ShowSkillAddButtonGuide(stepInfo)
    if not UIMgr:IsActiveUI(UI.CtrlNames.SkillLearning) then
        l_guideData.curGuideId = nil
        return
    end
    EventDispatcher:Dispatch(SKILL_ADD_BUTTON_GUIDE_EVENT, stepInfo)
end

--Npc对话界面按钮点击关闭指引类型指引展示
function ShowTalkDlgOptionButtonGuide(stepInfo)
    if not UIMgr:IsActiveUI(UI.CtrlNames.TalkDlg2) then
        l_guideData.curGuideId = nil
        return
    end
    EventDispatcher:Dispatch(TALKDLG_OPTION_BUTTON_GUIDE_EVENT, stepInfo)
end

--计时关闭指引
function CountTimeToOverStep(stepId, stepType, stepLastTime)
    if l_timer then
        l_timer:Stop()
        l_timer = nil
    end
    l_timer = Timer.New(function()
        if stepId == l_guideData.curGuideId then
            if stepType == 0 then
                --NPC介绍
            elseif stepType == 1 then
                --操作选择面板
            elseif stepType == 2 then
                --快捷任务面板
            elseif stepType == 3 then
                --技能操作面板
                local l_skillController = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
                if l_skillController and l_skillController.IsShowing then
                    l_skillController:CloseBeginnerGuideArrow(false)
                end
            elseif stepType == 4 then
                --主界面介绍
            else
                logError("stepType is error @litao  guideStepId = " .. tostring(stepId))
            end
            OnOneGuideOver()
        else
            if l_timer then
                l_timer:Stop()
                l_timer = nil
            end
        end
    end, stepLastTime / 1000, 1, true)
    l_timer:Start()
end


--完成某一步指引
--isForce 是否强制结束 （强制结束的话 不管是否有后续步骤直接关闭）
--stepID 目前针对NPC介绍界面 防止点击失效(极小概率)
--parentPanelName 父界面
--customSortingOrder 自定义层级
--返回值 是否需要强制关闭
function OnOneGuideOver(isForce, stepID, parentPanelName, customSortingOrder)

    if not l_guideData.curGuideId then
        if stepID then
            l_guideData.curGuideId = stepID
        else
            return true
        end
    end
    --计时器关闭
    if l_timer then
        l_timer:Stop()
        l_timer = nil
    end
    local l_row = TableUtil.GetTutorialConfigTable().GetRowByID(l_guideData.curGuideId)
    if l_row.MarkIndex and l_row.MarkIndex > 0 then
        ReqFinishOneGuide(l_row.MarkIndex)
    end
    --重置当前步骤ID
    l_guideData.curGuideId = nil
    --非强制结束时 检查时候存在下一步 或 下一组
    if not isForce then
        --下一步 优先于 下一组
        if l_row.NextStepId and l_row.NextStepId > 0 then
            ShowBeginnerGuide(l_row.NextStepId, parentPanelName, customSortingOrder)
            return false
        elseif l_row.NextIndexId and l_row.NextIndexId.Count > 0 then
            --新手指引相关
            local l_nextGuideChecks = {}
            for i = 0, l_row.NextIndexId.Count - 1 do
                table.insert(l_nextGuideChecks, l_row.NextIndexId[i])
            end
            CheckShowBeginnerGuide(l_nextGuideChecks, parentPanelName, customSortingOrder)
            return false
        end
    end
    --若没有下一步则发送事件 通知新手指引一步完成
    EventDispatcher:Dispatch(BEGINER_GUIDE_ONE_STEP_OVER, stepID)
    return true
end

--来自CS的完成回调
function OnOneGuideOverFormCS(luaType, stepId, isForce)
    if stepId and stepId ~= l_guideData.curGuideId then
        return
    end
    OnOneGuideOver(isForce)
end

-------------------------------其他协议接收后的分支方法-----------------------------------------------





---------------------------END 其他协议接收后的分支方法-----------------------------------------


--------------------------以下是服务器交互PRC------------------------------------------
--请求玩家新手指引相关状态信息
function ReqBeginnerGuideState()
    local l_msgId = Network.Define.Rpc.GetTutorialMark
    ---@type GetTutorialMarkArg
    local l_sendInfo = GetProtoBufSendTable("GetTutorialMarkArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
--接收玩家新手指引相关状态信息
function OnReqBeginnerGuideState(msg)
    ---@type GetTutorialMarkRes
    local l_info = ParseProtoBufToTable("GetTutorialMarkRes", msg)
    for i = 1, #l_info.tutorial_mark.tutorial do
        local l_temp = l_info.tutorial_mark.tutorial[i]
        l_guideData.guideState[l_temp.tutorial_id] = true
    end
    --设置是否是登录进来的标志
    isLoginEnter = true
end

--请求完成某项新手指引
function ReqFinishOneGuide(tutorialId)
    local l_msgId = Network.Define.Rpc.UpdateTutorialMark
    ---@type UpdateTutorialMarkArg
    local l_sendInfo = GetProtoBufSendTable("UpdateTutorialMarkArg")
    l_sendInfo.tutorial_id = tutorialId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
--接收完成某项新手指引的结果
function OnReqFinishOneGuide(msg, arg)
    ---@type UpdateTutorialMarkRes
    local l_info = ParseProtoBufToTable("UpdateTutorialMarkRes", msg)
    if l_info.result == 0 then
        l_guideData.guideState[arg.tutorial_id] = true
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end

end





------------------------------PRC  END------------------------------------------

---------------------------以下是单项协议 PTC------------------------------------

function OnSelectRoleNtf(info)
    l_guideData.InitGuideState()
    ReqBeginnerGuideState()
end


--接收服务器发送的展示QTE指引的请求
function OnWeakQteGuideNotify(msg)
    ---@type WeakQteGuideData
    local l_info = ParseProtoBufToTable("WeakQteGuideData", msg)
    --强行延迟0.1S 防止技能还未挂载上
    local l_timer = Timer.New(function(b)
        ShowBeginnerGuide(l_info.guide_id)
    end, 0.1)
    l_timer:Start()
end



------------------------------PTC  END------------------------------------------

------------------------------------- CutScene触发 ----------------------------------------------

function OnCutSceneStop()
    if MPlayerInfo.Lv == 1 then
        --判断是否是预注册
        if DataMgr:GetData("SelectRoleData").IsPreRegister then
            CheckShowBeginnerGuide({"YuzhuceFirstTask"})  --预注册登录
        else
            CheckShowBeginnerGuide({"FirstTask"})   --普通注册登录
        end
    end
end

-----------------------------------CutScene触发  END-------------------------------------------------

--------------------------------------任务完成触发------------------------------------------------
function OnTaskStatusUpdate(eventType, taskId, taskStatus, taskStep)
    --普攻演示特殊情况特判
    if l_guideData.curGuideId then
        if taskId == MGlobalConfig:GetInt("GuideNormalAttackTask") then
            if taskStatus == MgrMgr:GetMgr("TaskMgr").ETaskStatus.CanFinish then
                local l_skillController = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
                if l_skillController and l_skillController.IsShowing then
                    l_skillController:CloseBeginnerGuideArrow(true)
                else
                    l_guideData.curGuideId = nil
                end
            end
        end
    end

    --任务状态改变触发新手指引
    local l_tutorialData = TableUtil.GetTutorialTaskTable().GetRowByTaskID(taskId, true)
    if l_tutorialData ~= nil and l_tutorialData.TaskStatus == taskStatus then
        CheckShowBeginnerGuide({l_tutorialData.TutorialID})
    end
end

------------------------------------任务完成触发  END-------------------------------------------

------------------------------------- 等级触发 ----------------------------------------------

function OnBaseLevelUp()
    -- 20级以后提示委托
    if MPlayerInfo.Lv >= 20 then
        local l_delegateFuncId = 117
        if UIMgr:IsActiveUI(UI.CtrlNames.Main) then
            local l_MainUiTableData = MgrMgr:GetMgr("SceneEnterMgr").CurrentMainUiTableData
            local l_h1 = l_MainUiTableData.MainIcon
            local l_MainIcons = Common.Functions.VectorToTable(l_h1)
            if table.ro_contains(l_MainIcons, l_delegateFuncId) then
                local l_beginnerGuideChecks = { "Entrust5" }
                CheckShowBeginnerGuide(l_beginnerGuideChecks, UI.CtrlNames.Main)
            end
        end
    end
end

-----------------------------------等级触发  END-------------------------------------------------


-----------------------------------LUA界面绑定挂载型指引------------------------------------------------
--为Lua的UI按钮设置新手指引箭头
--aimCtrl ctrl 目标UI的ctrl类
--aimWorldPos vector3  指向目标的世界坐标
--parentPanel transform 箭头的挂载节点
--stepInfo 新手指引表数据
function SetGuideArrowForLuaBtn(aimCtrl, aimWorldPos, parentPanel, stepInfo)
    --该函数注释部分代码为精准定位用的扩展代码
    --目前lua部分暂时用不到 为节省性能注释掉 使用简单逻辑的定位
    --扩展时需要增加一个判断 挂载点 和 定位点是否是一个点 详细可以参考CS部分MBaseUI.cs的SetBeginnerGuideArrow函数

    --因为挂载节点不一定是那个按钮本身 所以需要通过按钮的POS做转换  精准定位用lua这边暂时用不到
    -- local l_screenSize = MUIManager:GetUIScreenSize()
    -- local l_aimViewPos = MUIManager.UICamera:WorldToViewportPoint(aimWorldPos)

    aimCtrl.guideArrow = aimCtrl:NewTemplate("GuideArrowPointTemplate", { IsActive = true,
                                                                          TemplateParent = parentPanel })
    aimCtrl.guideArrow:SetData({
        npcShowModel = stepInfo.NpcShowModel,
        infoText = stepInfo.UIText,
        arrowType = stepInfo.arrowType,
        effectData = stepInfo.EffectData,
        aimCtrl = aimCtrl,
        parentTrans = parentPanel,
    })
    --异步加载后位置设置
    aimCtrl.guideArrow:AddLoadCallback(function()
        -- 调试用
        -- local l_x = (l_aimViewPos.x - 0.5) * l_screenSize.x + stepInfo.UIOffset[1]
        -- local l_y = (l_aimViewPos.y - 0.5) * l_screenSize.y + stepInfo.UIOffset[2]
        -- logGreen("l_aimViewPos.x = "..tostring(l_aimViewPos.x))
        -- logGreen("l_aimViewPos.y = "..tostring(l_aimViewPos.y))
        -- logGreen("l_screenSize.x = "..tostring(l_screenSize.x))
        -- logGreen("l_screenSize.y = "..tostring(l_screenSize.y))
        -- logGreen("stepInfo.UIOffset[1] = "..tostring(stepInfo.UIOffset[1]))
        -- logGreen("stepInfo.UIOffset[2] = "..tostring(stepInfo.UIOffset[2]))
        -- logGreen("l_x = "..tostring(l_x))
        -- logGreen("l_y = "..tostring(l_y))
        -- 扩展用 用于精准定位 不过目前lua这边好像用不到
        -- MLuaCommonHelper.SetPos(aimCtrl.guideArrow:gameObject(),
        --     (l_aimViewPos.x - 0.5) * l_screenSize.x + stepInfo.UIOffset[1],
        --     (l_aimViewPos.y - 0.5) * l_screenSize.y + stepInfo.UIOffset[2],0)
        aimCtrl.guideArrow:SetArchors(stepInfo.UIOffset[0])
        MLuaCommonHelper.SetRectTransformPos(aimCtrl.guideArrow:gameObject(),
                stepInfo.UIOffset[1], stepInfo.UIOffset[2])
    end)
end
--新手指引对应的Lua按钮点击关闭事件
--aimCtrl ctrl 目标UI的ctrl类
function LuaBtnGuideClickEvent(aimCtrl)
    --箭头关闭
    if aimCtrl.guideArrow then
        aimCtrl:UninitTemplate(aimCtrl.guideArrow)
        aimCtrl.guideArrow = nil
        --驱动下一步
        OnOneGuideOver()
    end
end

---------------------------------LUA界面绑定挂载型指引  END-----------------------------------------