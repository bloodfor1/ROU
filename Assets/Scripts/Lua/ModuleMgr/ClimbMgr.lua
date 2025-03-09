module("ModuleMgr.ClimbMgr", package.seeall)


-- proto begin
function OnSelectRoleNtf(info)
    MPlayerInfo.ClimbUid=0
    local l_climbData = info.climbing
    if l_climbData == nil then
        return
    end
    MPlayerInfo.ClimbUid = l_climbData.wall_uuid
end