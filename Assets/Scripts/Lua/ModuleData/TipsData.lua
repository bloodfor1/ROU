module("ModuleData.TipsData", package.seeall)

------------------------事件相关定义------------------------
--Tips打开的类型枚举
ETipsOpenType = 
{
    GuildLikesOpen = 1
}


ETipsEvent = 
{
    Show_Fx_Tips_Event = "Show_Fx_Tips_Event",

    Show_Normal_Tips_Event = "Show_Normal_Tips_Event",

    Show_Attr_Tips_Event = "Show_Attr_Tips_Event",

    Show_Attr_2_Tips_Event = "Show_Attr_2_Tips_Event",

    Show_Attr_2_List_Tips_Event = "Show_Attr_2_List_Tips_Event",

    Show_Attr_List_Tips = "Show_Attr_List_Tips",

    Show_Task_Tips_Event = "Show_Task_Tips_Event",

    Show_Important_Notice_Event = "Show_Important_Notice_Event",

    Clear_Important_Notice_Event = "Clear_Important_Notice_Event",

    Show_Secondary_Notice_Event = "Show_Secondary_Notice_Event",

    Show_Normal_Trumpet_Event = "Show_Normal_Trumpet_Event",

    Show_Item_Drop_Notice_Event = "Show_Item_Drop_Notice_Event",

    Show_Question_Tip_Event = "Show_Item_Praise_Notice_Event",

    Show_Item_Praise_Notice_Event = "Show_Question_Tip_Event",

    Show_Battle_Tip_Event = "Show_Battle_Tip_Event",

    Show_Dungeon_Tips_Event = "Show_Dungeon_Tips_Event",

    Hide_Question_Tip_Event = "Hide_Question_Tip_Event",

    Show_Middle_UpTips_Event = "Show_Middle_UpTips_Event",

    Show_Middle_DownTips_Event = "Show_Middle_DownTips_Event",

    Show_COUNT_DOWN_EFFECT = "Show_COUNT_DOWN_EFFECT",

    Close_Dungeon_Hints_Story = "Close_Dungeon_Hints_Story",   --关闭副本旁白

    EnterScene = "EnterScene"
}
------------------------事件相关定义------------------------

------------------------openType相关-----------------------
MonsterInfoTipsOpenType = {
    ShowEntityTips = "ShowEntityTips",
    ShowTips = "ShowTips",
}
MainTargetInfoOpenType = {
    RefreshTargetInfo = "RefreshTargetInfo",
    RefreshTargetHP = "RefreshTargetHP",
    RefreshTargetSP = "RefreshTargetSP",
    RefreshTargetTargetName = "RefreshTargetTargetName",
}

ESpecialTipsOpenType = 
{
    ShowSpecialItem = "ShowSpecialItem",
    ShowSpecialStr = "ShowSpecialStr",
    ShowSpecialItemList = "ShowSpecialItemList",
}

local l_pendingNormalTips = {}
local l_eventWarningTime1 = nil
local l_eventWarningTime2 = nil

function Logout( ... )
    -- body
end

function Init( ... )
    l_eventWarningTime1 =  MGlobalConfig:GetInt("EventWarningTime1")
    l_eventWarningTime2 =  MGlobalConfig:GetInt("EventWarningTime2")
end

function GetPendingNormalTips()
    return l_pendingNormalTips
end

function ResetPendingNormalTips()
    l_pendingNormalTips = {}
end

function GetEventWarningTime1()
    return l_eventWarningTime1
end

function GetEventWarningTime2()
    return l_eventWarningTime2
end

return ModuleData.TipsData