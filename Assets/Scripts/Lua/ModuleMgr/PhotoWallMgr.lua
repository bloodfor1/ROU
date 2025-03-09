module("ModuleMgr.PhotoWallMgr", package.seeall)

PHOTOWALL_ACHIEVEMENT_ID = 60202201
local l_cameraTriggerId = 0
local l_guideTriggerId = 0   --照片墙新手引导触发器限定ID
local l_guideSceneId = 0     --照片墙新手引导场景限定ID
local l_photoWallGuideId = 117001  --照片墙引导Id

function OnInit()
    local l_beginnerMgr = MgrMgr:GetMgr("BeginnerGuideMgr")
    local l_photoWallMgr = MgrMgr:GetMgr("PhotoWallMgr")

    --照片墙新手指引相关数据
    local l_guideConfig = MGlobalConfig:GetSequenceOrVectorInt("PhotoWallEnterRookieIntroID")
    if l_guideConfig then
        l_guideTriggerId = l_guideConfig[0]
        l_guideSceneId = l_guideConfig[1]
    end
    --新手指引期间照片墙高亮
    l_beginnerMgr.EventDispatcher:Add(l_beginnerMgr.BEGINER_GUIDE_ONE_STEP_OVER, function(_, id)
        --照片墙引导Id
        if id == l_photoWallGuideId then
            ShowPhotoWallHighLight(id)
        end
    end, l_photoWallMgr)
end

function OnUnInit()
    local l_beginnerMgr = MgrMgr:GetMgr("BeginnerGuideMgr")
    local l_photoWallMgr = MgrMgr:GetMgr("PhotoWallMgr")

    l_beginnerMgr.EventDispatcher:RemoveObjectAllFunc(l_beginnerMgr.BEGINER_GUIDE_ONE_STEP_OVER, l_photoWallMgr)
end

function ShowPhotoWallWithGroupId(groupName, startid)
    local l_row = TableUtil.GetPhotoWallGroupTable().GetRowByGroupName(groupName)
    if l_row == nil then
        logError("cannot find gourp named "..tostring(groupName))
        return
    end
    local l_photoNames = l_row.PhotoNames
    local l_photoPaths = {}

    for i = 1,l_photoNames.Count do
        l_photoPaths[i] = "Photo/photowall/"..groupName.."/"..l_photoNames[i-1]..".png"
    end

    local l_rowPhotoDesc = l_row.PhotoDesc
    local l_photoDesc = {}
    
    for i = 1,l_photoNames.Count do
        if l_rowPhotoDesc.Count >= i then
            l_photoDesc[i] = l_rowPhotoDesc[i-1]
        else
            l_photoDesc[i] = ""
        end
    end 

    UIMgr:ActiveUI(UI.CtrlNames.PhotoWall, function(ctrl)
        ctrl:InitWithPhotoPathTable(l_photoPaths, l_photoDesc, startid) 
    end)

    local AchievementMgr = MgrMgr:GetMgr("AchievementMgr")
    AchievementMgr.ClientFinishAchievement(PHOTOWALL_ACHIEVEMENT_ID, ClientAchievementType.UsePhotoWall)
    MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_PhotoWallHighLight, nil, nil, false);

end

function ShowPhotoWallPlayerWithGroupId(groupName, startid)
    local l_row = TableUtil.GetPhotoWallGroupTable().GetRowByGroupName(groupName)
    if l_row == nil then
        logError("cannot find gourp named "..groupName)
        return
    end
    local l_photoNames = l_row.PhotoNames
    local l_photoPaths = {}

    for i = 1,l_photoNames.Count do
        l_photoPaths[i] = "Photo/photowall/"..groupName.."/"..l_photoNames[i-1]..".png"
    end

    UIMgr:ActiveUI(UI.CtrlNames.PhotoWallPlayer, function(ctrl)
        ctrl:InitWithPhotoPathTable(l_photoPaths, startid)  
    end)
end

function ShowPhotoWallHighLight(id)
    --参数1 要高亮的照片组
    --参数2 要高亮的照片名
    --参数3 亮起还是关闭
    MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_PhotoWallHighLight, "group8", "7", true);
end

--获取进入的相机触发器的ID
function GetEnterAutoCameraTriggerId(luaType, ...)
    local l_arg = {...}
    l_cameraTriggerId = tonumber(l_arg[1])
end

--获取触发器引起的相机移动结束事件
function GetTriggerCameraMoveOver(luaType, ...)
    if l_cameraTriggerId == l_guideTriggerId and MScene.SceneID == l_guideSceneId then
        local l_beginnerGuideChecks = {"PhotoWall"}
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks)
    end
end

--获取离开相机触发器事件
function GetExitTriggerAutoCamera(luaType, ...)
    if l_cameraTriggerId == l_guideTriggerId and MScene.SceneID == l_guideSceneId then
        if UIMgr:IsActiveUI(UI.CtrlNames.GuideDescribe) then
            UIMgr:DeActiveUI(UI.CtrlNames.GuideDescribe)
            MgrMgr:GetMgr("BeginnerGuideMgr").OnOneGuideOver(true)
        end
    end
    l_cameraTriggerId = 0  --重置触发器ID
end

return PhotoWallMgr