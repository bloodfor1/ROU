module("ModuleMgr.CapraRewardMgr", package.seeall)

function OnInit()

end


function GetGiftPackageList()
    local l_giftPackageList = {}
    local l_festivalData = DataMgr:GetData("FestivalData")
    local l_activityDatas = l_festivalData.GetDatasByFatherType(l_festivalData.EFatherType.GiftPackage)
    for _, activityData in ipairs(l_activityDatas) do
        for _, giftId in ipairs(activityData.giftIds) do
            table.insert(l_giftPackageList, {
                giftId = giftId,
                actId = activityData.id
            })
        end
    end
    return l_giftPackageList
end


return ModuleMgr.CapraRewardMgr