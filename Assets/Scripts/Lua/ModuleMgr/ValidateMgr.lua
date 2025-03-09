module("ModuleMgr.ValidateMgr", package.seeall)


function ValidateWithLevel(lv,min,max)
	if min == nil and max == nil then
		return true
	end
	if min ~= nil and max == nil then
		return lv > min
	end
	if min == nil and max ~= nil then
		return lv < max
	end
	if min~= nil and max ~= nil then
		return lv < max and lv > min
	end
	return true
end

function ValidateWithTeam()
	local captainUin,teamNum,member= DataMgr:GetData("TeamData").ReturnTaskNeededInfo()
	--无队伍
    if captainUin == -1 or teamNum == 0 or #member == 0 then
        return false
    end
    return true
end

function ValidateWithCaptain()
	local captainUin,teamNum,member= DataMgr:GetData("TeamData").ReturnTaskNeededInfo()
	--不是队长
    if MPlayerInfo.UID:tostring() ~= captainUin then
        return false
    end
    return true
end

function ValidateWithTeamCapacity(cnt)
	local captainUin,teamNum,member= DataMgr:GetData("TeamData").ReturnTaskNeededInfo()
	--队伍人数不对
    if #member ~= cnt then
        return false
    end
    return true
end

function ValidateWithOppositeSex()
	local captainUin,teamNum,member= DataMgr:GetData("TeamData").ReturnTaskNeededInfo()

	--人数不对 
	if #member ~= 2 then
		return false
	end
	--不是异性
	if member[1].cSex == member[2].cSex then
		return false
	end
	return true
end