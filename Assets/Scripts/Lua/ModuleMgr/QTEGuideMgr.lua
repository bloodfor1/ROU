---
--- Created by cmd(TonyChen).
--- DateTime: 2018/12/27 10:28
---
---@module ModuleMgr.QTEGuideMgr
module("ModuleMgr.QTEGuideMgr", package.seeall)


-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()

------------- END 事件相关  -----------------


--登出时初始化相关信息
function OnLogout()
    
end

function ShowQTEGuide(guideId)
    local l_row = TableUtil.GetQTEGuideTable().GetRowById(guideId)
    if l_row and l_row.SkillId ~= 0 then
        --策划说AI 那边做时间控制太麻烦 上buff之后调QTE指引 可能是同时到达 所以这边加一个固定0.1S的延时
        local l_timer = Timer.New(function(b)
            ShowSkillQTEGuide(l_row)
        end, 0.1)
        l_timer:Start()
    end
end

--展示技能的QTE指引
function ShowSkillQTEGuide(guideTableDate)
    local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")
    local l_skillController = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
    local l_skillId_slot = guideTableDate.SkillId == 100006 and 100003 or guideTableDate.SkillId
    --主界面操作切换加锁
    l_mainUIMgr.IsSwitchUILock = true
    --判断当前的显示
    if l_mainUIMgr.IsShowSkill and l_skillController and l_skillController.IsShowing then
        --如果当前操作面板为技能操作面板 且 没有别的界面打开 导致技能面板隐藏 
        if not l_mainUIMgr.IsSwitching then
            --如果不是正在播放切换动画 直接展示 并返回
            local l_soltObj = l_skillController:GetSkillSlotGameObjectBySkillId(l_skillId_slot)
            if l_soltObj then
                UIMgr:ActiveUI(UI.CtrlNames.QTEGuide, function (ctrl)
                    ctrl:SetSkillGuide(l_soltObj, guideTableDate)
                    --因为是异步的 这里不解锁切换按钮的锁定状态 在QTE指引界面关闭的时候才解锁
                end)
            else
                --ActiveUI是异步的 所以不开启直接解锁
                l_mainUIMgr.IsSwitchUILock = false
            end
            return
        end
    else
        --如果技能面板因为 被切换 或者 被别的界面隐藏 则切换回来并展示主界面
        l_mainUIMgr.ShowSkill(true) -- 切换到技能面板
        game:ShowMainPanel()  --展示主界面
    end
    --如果当前正在播放切换回技能面板的动画 或者 需要切换回来 则注册对应事件等待切换动画完成
    --主界面切换动画播放完成后事件
    l_mainUIMgr.EventDispatcher:Add(l_mainUIMgr.ON_MAIN_UI_SWITCH_OVER,
        function()
            --局部参数重新获取
            local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")
            local l_skillController = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
            if l_skillController and l_skillController.IsShowing then
                local l_soltObj = l_skillController:GetSkillSlotGameObjectBySkillId(l_skillId_slot)
                if l_soltObj then
                    UIMgr:ActiveUI(UI.CtrlNames.QTEGuide, function (ctrl)
                        ctrl:SetSkillGuide(l_soltObj, guideTableDate)
                    end)
                    --因为是异步的 这里不解锁切换按钮的锁定状态 在QTE指引界面关闭的时候才解锁
                    l_mainUIMgr.EventDispatcher:RemoveObjectAllFunc(l_mainUIMgr.ON_MAIN_UI_SWITCH_OVER, ModuleMgr.QTEGuideMgr)
                    return
                end
            end
            --主界面切换解锁 移除事件 无论是否正常开启指引 必须解锁
            l_mainUIMgr.IsSwitchUILock = false
            l_mainUIMgr.EventDispatcher:RemoveObjectAllFunc(l_mainUIMgr.ON_MAIN_UI_SWITCH_OVER, ModuleMgr.QTEGuideMgr)
        end, ModuleMgr.QTEGuideMgr)
end



-------------------------------其他协议接收后的分支方法-----------------------------------------------





---------------------------END 其他协议接收后的分支方法-----------------------------------------


--------------------------以下是服务器交互PRC------------------------------------------






------------------------------PRC  END------------------------------------------

---------------------------以下是单项协议 PTC------------------------------------

--接收服务器发送的展示QTE指引的请求
function OnQteGuideNotify(msg)
    ---@type QteGuideData
    local l_info = ParseProtoBufToTable("QteGuideData", msg)

    ShowQTEGuide(l_info.guide_id)
end

------------------------------PTC  END------------------------------------------
