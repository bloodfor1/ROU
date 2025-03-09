module("ModuleData.SuitData", package.seeall)


ESuitEquipComponentType = {
    EquipSecondID = 1,
    ItemID = 2,
}


ESuitInfoMask = {
    Simple = 0,
    IgnoreMatch = 1, -- 套装信息输出(不需要成套)
    ComponentID = 2, -- 输出componentid

    ALL = 0xffff, -- 全部
}


SuitDescKey =
{
    [2] = "TwoBuffidDec",
    [3] = "ThreeBuffidDec",
    [4] = "FourBuffidDec",
    [5] = "FiveBuffidDec",
    [6] = "SixBuffidDec",
    [7] = "SevenBuffidDec",
}

SuitGrayColor = RoColor.UIDefineColorValue.DeclarativeAssistColor
SuitActiveColor = RoColor.UIDefineColorValue.SmallTitleColor


return ModuleData.SuitData