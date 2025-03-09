module("ModuleMgr.ReviveMgr", package.seeall)

function OnReviveClick(entity)
    CommonUI.Dialog.ShowYesNoDlg(true, nil,StringEx.Format(Common.Utils.Lang("REVIVE_ROLE_CLICK"),entity.Name),
    function()
        MEventMgr:LuaFireEvent(MEventType.MEvent_Revive_Confirm, entity)
    end)
end

