--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.MaintenanceDialogMgr", package.seeall)

--lua model end

--lua custom scripts
function ShowMaintenanceDialog(maintainInfo,maintainEndTime)
    local l_finalMaintainEndTime = maintainEndTime + GetTimeZoneOffSet()
    local l_maintainEndTimeStr=os.date("!%Y-%m-%d %H:%M:%S",tonumber(l_finalMaintainEndTime))
    if maintainInfo == nil or string.ro_isEmpty(maintainInfo) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("LOGIN_SERVER_MAINTENANCE_TIP"))
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.MaintenanceDialog,{maintenanceInfo=maintainInfo,endTime=l_maintainEndTimeStr,utcEndTime=maintainEndTime})
end

--这个时候还拿不到 SyncTimeRes 这个协议返回的时区偏移 所以才在本地自己写了一个偏移
function GetTimeZoneOffSet()
    local l_utcTimeOffSset = 0
    if MGameContext.CurrentChannel == MoonCommonLib.MGameArea.China or
        MGameContext.CurrentChannel == MoonCommonLib.MGameArea.HongKong then
        l_utcTimeOffSset = 8 * 60 * 60
    elseif MGameContext.CurrentChannel == MoonCommonLib.MGameArea.Korea or
        MGameContext.CurrentChannel == MoonCommonLib.MGameArea.Japan then
        l_utcTimeOffSset = 9 * 60 * 60
    end
    return l_utcTimeOffSset
end
--lua custom scripts end
return ModuleMgr.MaintenanceDialogMgr