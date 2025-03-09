---
--- Created by chauncyhu.
--- DateTime: 2018/8/13 17:13
---

module("ModuleMgr.LoadingMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

ON_LOADING_START = "ON_LOADING_START"
ON_LOADING_END = "ON_LOADING_END"

m_bgIdx = 0

local l_loginSceneId = 46
local l_firstSceneId = 31

function OnLoadingStart(sceneId, bgIdx)
    m_bgIdx = bgIdx

    UIMgr:ActiveUI(UI.CtrlNames.Loading, sceneId)
    OnShowLoading()

    EventDispatcher:Dispatch(ON_LOADING_START)
end

function OnLoadingEnd()
    m_bgIdx = 0
    OnHideLoading()

    EventDispatcher:Dispatch(ON_LOADING_END)
end

function GetLoadingBGIdx()
    return m_bgIdx
end

function OnShowLoading()
    MgrMgr:GetMgr("DungeonMgr").OnShowLoading()
    MgrMgr:GetMgr("NoticeMgr").OnShowLoading()
end

function OnHideLoading()
    MgrMgr:GetMgr("DungeonMgr").OnHideLoading()
    MgrMgr:GetMgr("NoticeMgr").OnHideLoading()
end

-- 第一次出现在初始场景需要预加载黑幕
local function _checkPreloadBlackCurtain(sceneId, toStage)
    if sceneId ~= l_firstSceneId then
        return
    end

    local l_key = tostring(MPlayerInfo.UID) .. "|" .. tostring(sceneId)
    local l_dateSave = UserDataManager.GetStringDataOrDef(MPlayerSetting.FIRST_IN_SCENE, l_key, "")
    if string.len(l_dateSave) > 0 then 
        return 
    end

    local l_ctrl = UIMgr:GetOrInitUI(UI.CtrlNames.BlackCurtain)
    if l_ctrl:_isGameObjectExist() then
        return
    end
    UIMgr:_loadUI(UI.CtrlNames.BlackCurtain)
end

-- Login需要提前预加载
local function _checkPreloadLogin(sceneId, toStage)
    if toStage == MStageEnum.Login and MScene.LoadingLoader ~= nil then
        MScene.LoadingLoader:SendMessage("PreloadSharedGameObject", "UI/Prefabs/Login")
    end
end

function StartPreload(...)

    _checkPreloadBlackCurtain(...)
    _checkPreloadLogin(...)
end


return ModuleMgr.LoadingMgr