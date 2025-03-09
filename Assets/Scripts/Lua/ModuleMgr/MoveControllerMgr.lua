module("ModuleMgr.MoveControllerMgr", package.seeall)

function ActiveMoveController()

    UIMgr:ActiveUI(UI.CtrlNames.MoveControllerContainer)
end

function DeActiveMoveController()
    UIMgr:DeActiveUI(UI.CtrlNames.MoveControllerContainer)
end

function ShowMoveController()

    UIMgr:ShowUI(UI.CtrlNames.MoveControllerContainer)
end

function HideMoveController()
    UIMgr:HideUI(UI.CtrlNames.MoveControllerContainer)
end