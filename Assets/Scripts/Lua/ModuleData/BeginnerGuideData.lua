--lua model
module("ModuleData.BeginnerGuideData", package.seeall)
--lua model end

---------------------- 枚举 --------------------------
--UI激活对应函数枚举
EUIOpenType = 
{
    GuideDescribeShow = 1,
}

--新手指引类型枚举
EGuideType = {
    NpcDescribe = 0,        -- 文字说明指引（带或不带卡普拉）
    SelectControlMod = 1,   -- 操作模式选择
    Task = 2,               -- 任务追踪
    Skill = 3,              -- 技能面板（操作放技能的地方 不是点技能的地方）
    MainUI = 4,             -- 主界面UI（目前貌似已弃用 主界面全按钮介绍）
    SceneObjButton = 5,     -- 场景交互按钮
    HowToPlay = 6,          -- 通用玩法说明
    OpenSystemButton = 7,   -- 系统开启按钮
    PropIcon = 8,           -- 快捷物品使用
    OXButton = 9,           -- OX按钮
    SkillAddBtn = 10,       -- 技能加点按钮
    SkillForce  = 11,       -- 技能面板强指引（只有明确释放出技能后才消失）
    TalkDlgOptionBtn = 12,  -- NPC对话界面选项按钮
}
-------------------- END 枚举  ------------------------

---------------------- 常量 ---------------------------
--技能加点确认引导ID
SKILL_ADD_POINT_CHECK_GUIDE_ID = 139001
-------------------- END 常量  ------------------------

---------------------- 变量数据 ---------------------------

-- 新手指引的状态列表
guideState = {}
--当前指引的ID
curGuideId = nil
-------------------- END 变量数据  ------------------------

---------------------- 生命周期 ---------------------------
--初始化
function Init( ... )
    guideState = {}
    curGuideId = nil
end

--登出重置
function Logout( ... )
    guideState = {}
    curGuideId = nil
end
-------------------- END 生命周期  ------------------------

--初始化新手引导状态信息
function InitGuideState()
    local l_table = TableUtil.GetTutorialMarkTable().GetTable()
    guideState = {}
    for i = 1, #l_table do
        local l_row = l_table[i]
        guideState[l_row.ID] = false
    end
end

--获取当前步骤ID
function GetCurGuideId()
    return curGuideId
end

--设置当前步骤ID
function SetCurGuideId(guideId)
    curGuideId = guideId
end


return ModuleData.BeginnerGuideData