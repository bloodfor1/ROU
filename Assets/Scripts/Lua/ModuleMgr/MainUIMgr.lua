module("ModuleMgr.MainUIMgr", package.seeall)
require "UI/UIConst"

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
ON_STOP_AUTO_FIGHT = "ON_STOP_AUTO_FIGHT"
ON_ENTER_STUCK = "ON_ENTER_STUCK"
ON_EXIT_STUCK = "ON_EXIT_STUCK"
--主界面操作UI 切换完成
ON_MAIN_UI_SWITCH_OVER = "ON_MAIN_UI_SWITCH_OVER"

FadeMainEvent="FadeMainEvent"
FadeQuickItemEvent="FadeQuickItemEvent"
FadeVehicleEvent="FadeVehicleEvent"
FadeFishMainEvent="FadeFishMainEvent"
------------- END 事件相关  -----------------

local l_switchTimer = nil
IsSwitching = false  --操作界面是否正在切换中
IsSwitchUILock = false  --操作UI切换是否加锁 出指引的时候防止异常需要挂锁
IsShowSkill = true
ANI_TIME = 0.35

function ResetMainUICache()
    local l_oldShowSkill = IsShowSkill
    IsShowSkill = true

    if not l_oldShowSkill then
        -- 恢复快捷栏
        local l_ui_quickItem = UIMgr:GetUI(UI.CtrlNames.QuickItem)
        if l_ui_quickItem ~= nil then
            l_ui_quickItem:ClearFadeAction()
            l_ui_quickItem:CheckShow()
        end
    end

    MgrMgr:GetMgr("SkillControllerMgr").SetSwitchMainSkill(IsShowSkill)
    --MUIManager.SwitchMainSkill = IsShowSkill
end

--切换操作界面
function SwitchUI()
    ShowSkill(not IsShowSkill)
end

function ShowSkill(isShowSkill)

    if game:IsLogout() then
        return
    end

    IsShowSkill=isShowSkill

    MgrMgr:GetMgr("SkillControllerMgr").SetSwitchMainSkill(isShowSkill)

    EventDispatcher:Dispatch(FadeMainEvent,isShowSkill,ANI_TIME)

    EventDispatcher:Dispatch(FadeQuickItemEvent, not isShowSkill,ANI_TIME)

    --特殊的主界面控制
    MgrMgr:GetMgr("ArrowMgr").FreshMainArrow()
    local player = MEntityMgr.PlayerEntity
    if player and player.IsFly then
        EventDispatcher:Dispatch(FadeVehicleEvent, not isShowSkill,ANI_TIME)
        if isShowSkill then
            SwitchUIToSpecial()
        end
    elseif player and player.IsFishing then
        EventDispatcher:Dispatch(FadeFishMainEvent, not isShowSkill,ANI_TIME)
    end

    if not isShowSkill then
        MgrMgr:GetMgr("SkillControllerMgr").HideSkillController()
    else
        local l_skillUI = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
        if l_skillUI and l_skillUI.IsActived then
            MgrMgr:GetMgr("SkillControllerMgr").ShowSkillController()
        else
            MgrMgr:GetMgr("SkillControllerMgr").ActiveSkillController()
        end
    end

    local ui = UIMgr:GetUI(UI.CtrlNames.MainArrows)
    if ui then
        ui:FadeAction(not isShowSkill, ANI_TIME)
    elseif ui then
        MgrMgr:GetMgr("ArrowMgr").RefreshArrowPanel()
    end

    --记录正在切换 切换用的是原生的Dotween没有callback只能自己根据事件记录
    if l_switchTimer then
        l_switchTimer:Stop()
        l_switchTimer = nil
    end
    IsSwitching = true
    l_switchTimer = Timer.New(function()
        IsSwitching = false
        EventDispatcher:Dispatch(ON_MAIN_UI_SWITCH_OVER)
        if l_switchTimer then
            l_switchTimer:Stop()
            l_switchTimer = nil
        end
    end, ANI_TIME, 1, true)
    l_switchTimer:Start()
end

--切换到特殊主界面 做一次确认 如果是功能按钮界面则切换
function SwitchUIToSpecial()
    if IsShowSkill then return end --如果原本是技能展示面板 直接返回
    --如果原本显示的功能按钮 则做一次切换
    IsShowSkill = not IsShowSkill
    --MUIManager.SwitchMainSkill = IsShowSkill

    MgrMgr:GetMgr("SkillControllerMgr").SetSwitchMainSkill(IsShowSkill)
    local l_ui_main = UIMgr:GetUI(UI.CtrlNames.Main)
    if l_ui_main ~= nil then
        l_ui_main:FadeAction(IsShowSkill,ANI_TIME)
    end
    local l_ui_quickItem = UIMgr:GetUI(UI.CtrlNames.QuickItem)
    if l_ui_quickItem ~= nil then
        l_ui_quickItem:FadeAction(not IsShowSkill,ANI_TIME)
    end
end

--主界面按钮上显示通知
--args{}: params是一个列表用来做字符串填充的参数，activityId表示活动id
--example: MgrMgr:GetMgr("MainUIMgr").ShowMainButtonNotice(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk, 1, {activityId = 2, params = {"aaaa"}})
function ShowMainButtonNotice(systemId, pushId, args)
    local l_ui_main = UIMgr:GetUI(UI.CtrlNames.Main)
    if l_ui_main ~= nil then
        l_ui_main:ShowMainButtonNotice(systemId, pushId, args)
    end
end

--接收服务器传来的关闭自动战斗请求
function OnStopAutoFight( ... )
    EventDispatcher:Dispatch(ON_STOP_AUTO_FIGHT)
end

return MainUIMgr