module("SGame", package.seeall)

--@Description:小游戏配置解析分隔符（如有改动，需同步至小游戏配置工具）
--*一级分隔符";"，二级分隔符"|"
ParseSeparator=
{
    SmallGameObject=";", --小游戏对象间的分隔符
    Step="|",--小游戏对象步骤分隔符
    SmallGameObjectInfo=":",--小游戏对象名和对应参数信息分隔符
    ObjectInfoParam=",",--小游戏对象参数信息分隔符
    Touch="~",--小游戏触发器信息分隔符
    TouchInfo="=",--小游戏触发器信息分隔符
    TouchArg="_",--触发器参数分隔符
    StepParam="=",--小游戏步骤参数信息分隔符
    StepInfo=",",--步骤信息分隔符
    OperaInfo=",",--QTE操作信息分隔符
    HandlerInfo=":",--行为信息分隔符
    HandlerArg="_",--行为参数分隔符
}
QTEType=
{
    None=0,
    Drag_QTE=1,
    Rotate_QTE=2,
    Shake_QTE=3,
    Click_QTE=4,
}
TouchType=
{
    Auto=0,
    Win=1,
    Fail=2,
    CheckStep=3,
}
HandlerType=
{
    JumpStep=1,--跳转步骤
    SetGameObj=2, --更改gameobject状态
    AwakeSGameObj=3, --唤醒小游戏对象
    UpdateSlideValue=4, --更新进度条
    NotifyResult=5,--通知游戏结果
    PlayEffect=6, --播放特效
    PlaySound=7, --播放音效
}
ObjectActiveMode=
{
    NATURAL=1,--自然出生
    AWAKE_NUM=2,--唤醒次数出生
}
EventDeliverType=
{
    BeginDrag=1,
    Drag=2,
    EndDrag=3,
}