module("ModuleMgr.AlbumMgr", package.seeall)
local cjson = require "cjson"

defaultAlbumName = Lang("ALBUM_DEFAULT_ALBUM")
loverAlbumName = Lang("ALBUM_LOVER_ALBUM")

ShowPothoChannel = {        -- 当前打开showphoto ui的渠道
    None = 0,
    Texture = 1, --从相机打开
    Path = 2,--从相册打开
    ScreenCapture = 3,--从截图打开
}

CurShowPothoChannel = ShowPothoChannel.None

function HasLoverAlbum()
	return false
end

function InitFolder()
    local l_defaultAlbumPath = GetAlbumPath(defaultAlbumName)
    if not Directory.Exists(l_defaultAlbumPath) then
        Directory.CreateDirectory(l_defaultAlbumPath)
    end
    local l_loverAlbumPath = GetAlbumPath(loverAlbumName)
    if not Directory.Exists(l_loverAlbumPath) then
        Directory.CreateDirectory(l_loverAlbumPath)
    end
end
-----------------------------相册操作--------------------------------
function GetAlbumRoot()
    local l_rootPath = PathEx.GetCachePath() .. "Users/" .. MoonCommonLib.StringEx.ConverToString(MEntityMgr.PlayerEntity.UID) .. "/Albums"
    if not Directory.Exists(l_rootPath) then
        Directory.CreateDirectory(l_rootPath)
    end
	return l_rootPath
end

function GetAlbumPath(albumName)
	return GetAlbumRoot() .. "/" .. EncodeAlbumName(albumName)
end

function ShowAlbum(albumName)
    UIMgr:ActiveUI(UI.CtrlNames.AlbumOpenAlbum, function(ctrl)
        ctrl:OpenAlbum(albumName)
    end)
end

function GetPhotoNumber(albumName)
	if not Directory.Exists(MgrMgr:GetMgr("AlbumMgr").GetAlbumPath(albumName)) then
		return 0
	end
	return Directory.GetFiles(MgrMgr:GetMgr("AlbumMgr").GetAlbumPath(albumName), "*.png").Length
end

function GetAlbumName(photoPath)
    return DecodeAlbumName(Path.GetFileName(Path.GetDirectoryName(photoPath)))
end

function GetAlbumNameList()
    local l_albumFolders = Directory.GetDirectories(GetAlbumRoot())
    local l_albumNameList = {}
    for i = 0,l_albumFolders.Length-1  do

        local v = l_albumFolders[i]
        local l_folderName = DecodeAlbumName(Path.GetFileName(v))
        if not HasLoverAlbum() and l_folderName == loverAlbumName then
        else
            l_albumNameList[#l_albumNameList + 1] = l_folderName
        end
    end
    return l_albumNameList
end

--重名名相册
function AlbumReName(albumName, newName)
    local l_oldPath = GetAlbumPath(albumName)
    local l_newPath = GetAlbumPath(newName)

    if not Directory.Exists(l_oldPath) or albumName == newName then
        return
    end
    if Directory.Exists(l_newPath) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_HAS_SAME_ALBUM"))
        return
    end

    Directory.Move(l_oldPath, l_newPath)
end

function RemoveAlbum(albumName)
    Directory.Delete(MgrMgr:GetMgr("AlbumMgr").GetAlbumPath(albumName), true)
    GlobalEventBus:Dispatch(EventConst.Names.PhotoNumberChange)
end

function ExistsAlbum(albumName)
    return Directory.Exists(MgrMgr:GetMgr("AlbumMgr").GetAlbumPath(albumName))
end

function IsValidName(albumName)
    if #albumName == 0 then
        return Lang("ALBUM_ALBUMNAME_IS_ZERO")
    elseif #albumName > 18 then
        return Lang("ALBUM_ALBUMNAME_TOO_LONG")
    end
    if string.find(albumName, "/") or string.find(albumName, "/")  or string.find(albumName, "\\") or string.find(albumName, ":") or string.find(albumName, "*") or string.find(albumName, "<") or string.find(albumName, ">") or string.find(albumName, "|") then
        return Lang("ALBUM_ALBUMNAME_CONTAIN_INVALIDWORD")
    end

    if ExistsAlbum(albumName) then
        return Lang("ALBUM_ALBUMNAME_REPEAT")
    end
    local l_nameList = GetAlbumNameList()
    for k,v in pairs(l_nameList) do
        if v == albumName then
            return Lang("ALBUM_ALBUMNAME_REPEAT")
        end
    end
end

-----------------------------相册操作--------------------------------
-----------------------------照片操作--------------------------------
--获取照片信息
function GetPhotoMessage(photoPath)
   return MPlayerInfo.albumInfo:GetPhotoMessage(photoPath)
end

--设置照片信息
function SetPhotoMessage(photoPath, msg)
    MPlayerInfo.albumInfo:SetPhotoMessage(photoPath, msg)
end

--获取照片贴图
function GetPhotoTexture(photoPath, fromStreamingAssets, format)
    if fromStreamingAssets == nil then
        fromStreamingAssets = false
    end
    if format == nil then
        format = TextureFormat.RGBA32
    end
    if not fromStreamingAssets and not File.Exists(photoPath) then
        logError("照片不存在"..photoPath)
        return
    end
    return MoonClient.NativeTexture.New(photoPath, fromStreamingAssets, format) --MoonCommonLib.FileEx.OpenTexture(1280, 720, photoPath)
end

function SavePhotoToSystemAlbum(texture, callback)
    --TODO
    if MLuaCommonHelper.IsNull(texture) then
        return
    end

    local l_succFunc = function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_SAVE_TO_PHONE_SUCC"))
        MoonCommonLib.FileEx.SaveTextureToPlatformAlbum(texture)
        if callback ~= nil then
            callback(true)
        end
    end
    local l_failFunc = function()
        if callback ~= nil then
            callback(false)
        end
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("PHONE_PHOTOGRAPH_NOT_PERMISSION"),
                function()
                    MDevice.OpenSettingPermission()
                end)
    end
    -- android 默认用户允许了相册访问权限，iOS需要特殊处理
    if MGameContext.IsIOS then
        permissionType = tostring(EDevicePermissionType.Photos)
        MDevice.CheckPermissionByType(CJson.encode({permission = permissionType}), function(result, permission)
            logGreen("[CheckPermissionByType] result = " .. result .. "  permission = " .. permission)
            if result == tostring(EDevicePermissionResult.Authorized) then
                l_succFunc()
            elseif result == tostring(EDevicePermissionResult.NotDetermined) then
                MDevice.RequestPermissionByType(CJson.encode({permission = tostring(permissionType)}), function(ret, per)
                    logGreen("[RequestPermissionByType] ret = " .. ret .. "  per = " .. per)
                    if ret == tostring(EDevicePermissionResult.Authorized) then
                        l_succFunc()
                    elseif ret == tostring(EDevicePermissionResult.Denied) then
                        l_failFunc()
                    end
                end)
            elseif result == tostring(EDevicePermissionResult.Denied) then
                l_failFunc()
            end
        end)
    else
        l_succFunc()
    end
end

--保存照片
function SavePhotoToAlbum(albumName, texture, destroy)
    if destroy == nil then
        destroy = true
    end
    SelectSavePhotoToAlbum(albumName,texture,destroy)
end

--保存照片
function SelectSavePhotoToAlbum(albumName, texture,destroy)
    local l_savePath = GetAlbumPath(albumName) .. "/".. tostring(Common.TimeMgr.GetNowTimestamp()) .."_"..EncodeAlbumName(TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).MiniMap) ..".png"
    MoonCommonLib.FileEx.SaveTexture(texture, l_savePath,destroy)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshAlbum)
    GlobalEventBus:Dispatch(EventConst.Names.PhotoNumberChange)
end

--移动相册
function MovePhoto(photoPath, newAlbum)

    local l_newAlbumPath = GetAlbumPath(newAlbum)
    if not Directory.Exists(l_newAlbumPath) then
        logError("不存在相册".. tostring(newAlbum))
    end
    local l_newPhotoPath = l_newAlbumPath .."/".. Path.GetFileName(photoPath)
    File.Move(photoPath, l_newPhotoPath)
    File.Move(photoPath..".mip", l_newPhotoPath..".mip")
    GlobalEventBus:Dispatch(EventConst.Names.RefreshAlbum)
	GlobalEventBus:Dispatch(EventConst.Names.RefreshPhoto)
    return l_newPhotoPath
end

--移除照片
function RemovePhoto(photoPath)
    RemovePhotoWithoutMessage(photoPath)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshAlbum)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshPhoto)
    GlobalEventBus:Dispatch(EventConst.Names.PhotoNumberChange)
end

function RemovePhotoWithoutMessage(photoPath)
    File.Delete(photoPath)
    File.Delete(photoPath..".mip")
    MPlayerInfo.albumInfo:RemovePhotoMessage(photoPath)
end

function GetPhotoList(albumName)
    if albumName == nil then
        local l_photoFiles = Directory.GetFiles(GetAlbumRoot(), "*.png", System.IO.SearchOption.AllDirectories)
        return l_photoFiles
    end

    local l_albumPath = GetAlbumPath(albumName)
    local l_photoFiles = Directory.GetFiles(l_albumPath, "*.png", System.IO.SearchOption.AllDirectories)
    return l_photoFiles

end

-----------------------------照片操作--------------------------------
-----------------------------分享操作--------------------------------
function ShareOnWechat()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
end

function ShareOnFriendCircle()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
end

function ShareOnSina()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
end

function ShareOnQQ()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
end
-----------------------------分享操作--------------------------------
-----------------------------显示大图--------------------------------

--通过贴图打开：包含保存到相册的按钮
function OpenPhotoByTexture(texture, lastCtrlName, cached_info, keeplastUI, autoSave, isShare)
    if keeplastUI == nil then
        keeplastUI = true
    end
    if autoSave == nil then
        autoSave = false
    end

    CurShowPothoChannel = ShowPothoChannel.Texture
    UIMgr:ActiveUI(UI.CtrlNames.ShowPhoto, function(ctrl)
        --UIMgr:DeActiveUI(lastCtrlName)
        ctrl:SetShowPhotoByTexture(texture, lastCtrlName, cached_info, keeplastUI, autoSave, isShare)
    end)
end

--通过路径打开：包含操作相册的按钮
--lastCtrl 由何处打开该相册
--inAlbum 在相册中浏览
function OpenPhotoByPath(path, lastCtrlName, inAlbum)
    CurShowPothoChannel = ShowPothoChannel.Path
    UIMgr:ActiveUI(UI.CtrlNames.ShowPhoto, function(ctrl)
        --UIMgr:DeActiveUI(lastCtrlName)
        ctrl:SetShowPhotoByPath(path, lastCtrlName, inAlbum or false)
    end)
end

--通过截图打开：包含保存到相册的按钮
function OpenPhotoByScreenCapture(texture, lastCtrlName, cached_info, keeplastUI, autoSave, isShare, screenShotUIName)
    if keeplastUI == nil then
        keeplastUI = true
    end
    if autoSave == nil then
        autoSave = false
    end

    CurShowPothoChannel = ShowPothoChannel.ScreenCapture
    UIMgr:ActiveUI(screenShotUIName, function(ctrl)
        ctrl:SetShowPhotoByScreenCapture(texture, lastCtrlName, cached_info, keeplastUI, autoSave, isShare)
    end)
end

-----------------------------显示大图--------------------------------

-----------------------------埋点相关
function PhotoFlowTlog(l_cache_info, result)
    local l_msgId = Network.Define.Ptc.PhotoFlowTlog
    ---@type PhotoFlow
    local l_sendInfo = GetProtoBufSendTable("PhotoFlow")

    l_sendInfo.role_id = MPlayerInfo.UID
    l_sendInfo.operate_type = l_cache_info.operate_type
    l_sendInfo.scene_id = l_cache_info.scene_id
    l_sendInfo.position.x = l_cache_info.x
    l_sendInfo.position.y = l_cache_info.y
    l_sendInfo.position.z = l_cache_info.z

    if l_cache_info.decals then
        for i, v in ipairs(l_cache_info.decals) do
            local l_stick = l_sendInfo.sticker_id:add()
            l_stick.value = v
        end
    end

    local l_cur_time = Time.realtimeSinceStartup

    l_sendInfo.emoji_id = l_cache_info.expression_id or 0

    l_sendInfo.message = ""
    -- if l_cache_info.message then
    --     if l_cur_time < l_cache_info.message_time then
    --         l_sendInfo.message = l_cache_info.message
    --     end
    -- end

    l_sendInfo.action_id = l_cache_info.action_id or 0

    l_sendInfo.frame_id = l_cache_info.borderID or 0
    l_sendInfo.result = result or 0

    Network.Handler.SendPtc(l_msgId, l_sendInfo)


    log(l_sendInfo)

end

function EncodeAlbumName(name)
    local base64Code= Base64Helper.EncodeBase64(name)
    local encodeAlbumName= (string.gsub(base64Code,'/','#'))
    return encodeAlbumName
end

function DecodeAlbumName(path)
    local base64Code= (string.gsub(path,'#','/'))
    local decodeAlbumName= Base64Helper.DecodeBase64(base64Code)
    return decodeAlbumName
end

return ModuleMgr.AlbumMgr