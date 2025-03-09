require "Data/Model/BagModel"
require "Data/Model/BagApi"

---@module ModuleMgr.ShareMgr
module("ModuleMgr.ShareMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
ShareSDKIsOn = MDevice.EnableSDKInterface("JoyyouShare") and (g_Globals.IsOneStore == false)            -- 是否开启分享sdk
ShareSDKFBIsOn = ShareSDKIsOn                                       -- 是否开启fb分享
ShareSDKKaKaoIsOn = false                                           -- 是否开启kakao分享

local luaBaseType = GameEnum.ELuaBaseType

local gameEventMgr = MgrProxy:GetGameEventMgr()

QRcodeType = {
    tencent_qrcode = "Others/tencent_qrcode.png",
    korea_qrcode = "Others/korea_qrcode.png"
}

ShareID = {
    GarderobeShare = 10001,
    RoleShare = 10002,
    PhotoShare = 10003,
    ScreenShot = 10004,
    StoryShare = 10005,
    CutSceneShare = 10006,
    OrnamentShare = 11006,
    FashionShare = 11007,
    CardShare = 11008,
}
ShareStyle = {
    Picture = 1,
    FullScreenPicture = 2,
    Link = 3,
}
ShareSDKChannel = {
    FBLink = "fb_share_link",
    FBImg = "fb_share_img",
    KakaoLink = "kakao_share_link",
    KakaoImg = "kakao_share_bytes_img",
}

LastShareID = ""            -- 上一次分享的id
LastShareStyle = ""         -- 上一次分享的类型
LastShareSDKType = ""       -- 上一次分享的sdk类型

function OnInit()
    GlobalEventBus:Add(EventConst.Names.CutScenePause, function(cutSceneID, shareId)
        UIMgr:ActiveUI(UI.CtrlNames.ShareSingleChannels, function(ctrl)
            ctrl:SetShareInfo(shareId,nil,ShareID.CutSceneShare,cutSceneID)
        end)
    end)
end

function ClearUISelectItem()
    UISelectItem = {}
end

---@param info RoleAllInfo
function OnSync(info)

end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    if nil == reconnectData then
        logError("[ShareMgr] reconnected data got nil")
        return
    end
end
function OpenShareUI(shareID,Model,type,paramID)
    local row = TableUtil.GetShareTable().GetRowByShareId(shareID,true)
    if row ~= nil then
        UIMgr:ActiveUI(row.SharePrefab, function(ctrl)
            ctrl:SetShareInfo(shareID,Model,type,paramID)
        end)
    end
end

function Savephone(data)
    MgrMgr:GetMgr("AlbumMgr").SavePhotoToSystemAlbum(data)
end
function Savexiangce(data)
end

function SendFacebook(shareStyle, data, shareID, callback, imgQuality)
    ShareSDK(shareStyle, data, data, shareID, GameEnum.EJoyyouShareSDKType.Facebook, callback, imgQuality)
end

function SendKakao(shareStyle, data, shareID, callback, imgQuality)
    ShareSDK(shareStyle, data, data, shareID, GameEnum.EJoyyouShareSDKType.KakaoTalk, callback, imgQuality)
end

function ShareSDK(shareStyle, texture, link, shareID, shareSDKType, callback, imgQuality)
    LastShareID = shareID
    LastShareStyle = shareStyle
    LastShareSDKType = shareSDKType
    local arg = { shareSDKType = shareSDKType }
    if shareStyle == ShareStyle.Link then
        if link == nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SHARE_FAILED"))
            return
        end
        arg.url = link
        if shareSDKType == GameEnum.EJoyyouShareSDKType.Facebook then
            arg.shareChannel = ShareSDKChannel.FBLink
        elseif shareSDKType == GameEnum.EJoyyouShareSDKType.KakaoTalk then
            arg.shareChannel = ShareSDKChannel.KakaoLink
        end
        ShareLink(CJson.encode(arg))
    elseif shareStyle == ShareStyle.Picture or shareStyle == ShareStyle.FullScreenPicture then
        if texture == nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SHARE_FAILED"))
            return
        end
        if shareSDKType == GameEnum.EJoyyouShareSDKType.Facebook then
            arg.shareChannel = ShareSDKChannel.FBImg
        elseif shareSDKType == GameEnum.EJoyyouShareSDKType.KakaoTalk then
            arg.shareChannel = ShareSDKChannel.KakaoImg
        end
        ShareImg(texture, CJson.encode(arg), callback, imgQuality)
    end
end

function ShareLink(data)
    if ShareSDKIsOn then
        logGreen("[ShareMgr]ShareLink")
        logGreen(ToString(data))
        MShare.ShareLink(CJson.encode({json = data}))
    end
end

function ShareImg(texture, data, callback, imgQuality)
    if ShareSDKIsOn then
        logGreen("[ShareMgr]ShareImg")
        logGreen(ToString(data))
        CommonUI.Dialog.ShowWaiting()
        MScreenCapture.ShareSDKImg(texture, CJson.encode({json = data}), callback, imgQuality and imgQuality or 75)
    end
end

-- sdk分享结果回调
function OnSDKShareCallback(jsondata)
    CommonUI.Dialog.HideWaiting()
    logGreen("[ShareMgr]OnSDKShareCallback")
    log(ToString(jsondata))
    log("LastShareID: " .. LastShareID .. " LastShareStyle: " .. LastShareStyle .. " LastShareSDKType" .. LastShareSDKType )
    local data = CJson.decode(jsondata)
    if data and data.result and data.shareSDKType then
        if data.result == GameEnum.JoyyouSDKResult.SUCCESS then
            if data.shareSDKType == GameEnum.EJoyyouShareSDKType.Facebook then
                -- TODO

            end
            if data.shareSDKType == GameEnum.EJoyyouShareSDKType.KakaoTalk then
                -- TODO

            end
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ShareSucceedText"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SHARE_FAILED"))
        end
    end
end

-- 手机系统截图事件通知
-- MgrMgr:GetMgr("ShareMgr").OnScreenShot()
function OnScreenShot(_)
    logGreen("[ShareMgr]OnScreenShot")
    if not CanShare_merge() then
        return
    end

    -- 未加载好UIRoot
    if not MUIManager.UIRoot then
        return
    end

    if MPlayerSetting.OpenScreenCaptureShare then
        local l_data = TableUtil.GetShareTable().GetRowByShareId(ShareID.ScreenShot)
        if l_data then
            local l_uiname = l_data.SharePrefab
            if UIMgr:IsActiveUI(l_uiname) then
                logWarn(l_uiname .. " already open")
                return
            end
            MScreenCapture.TakeScreenShotWithRatio(16 / 9, nil, function(l_photo)
                MgrMgr:GetMgr("AlbumMgr").OpenPhotoByScreenCapture(l_photo,nil , nil, false, false, false, l_uiname)
            end)
        else
            logError("@徐波检查shareTable配置")
        end
    end
end

function CanShare()
    if g_Globals.IsOneStore then
        return false
    else
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Share_Story)
    end
end

function CanShare_merge()
    if g_Globals.IsOneStore then
        return false
    else
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Share_Sdk)
    end
end


function OnLogout()

end
return ModuleMgr.ShareMgr