--红点功能的管理
---@module ModuleMgr.WeakGuideMgr
module("ModuleMgr.WeakGuideMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

eSignEventName=
{
    Skill="Skill",
    LearnNewSkill="LearnNewSkill",
    StatusPoint="StatusPoint",
    Forge="Forge",
    Switch="Switch",
    Vehicle="Vehicle",
    BattleVehicle="BattleVehicle",
    Friend="Friend",
    Email="Email",
    LandingAward="LandingAward",
}
eSignEventRelevance=
{
    Switch={"Forge"},
    Skill={"LearnNewSkill"},
}

local RedSignShows={}

--红点消息协议
function OnHintNotifyMS(msg)
    -----@type HintNotifyMSData
    --local l_resInfo = ParseProtoBufToTable("HintNotifyMSData", msg)
    --
    --if l_resInfo.system_type == PbcMgr.get_enumc_unclassified_pb().System_Mail then
    --    if not l_resInfo.is_hint then
    --        return
    --    end
    --    if UIMgr:IsActiveUI(UI.CtrlNames.Community) then
    --        if UIMgr:GetUI(UI.CtrlNames.Community):GetHandlerByName(UI.HandlerNames.Email)~=nil then
    --            return
    --        end
    --    end
    --    ShowRedSign(eSignEventName.Email,l_resInfo.is_hint)
    --
    --    if l_resInfo.is_hint then
    --        logError("youjianshuju:"..tostring(l_resInfo.is_hint))
    --        --MgrMgr:GetMgr("RedSignMgr").ShowRedSign(eRedSignKey.Email,1)
    --    else
    --        logError("youjianshuju:"..tostring(l_resInfo.is_hint))
    --        --MgrMgr:GetMgr("RedSignMgr").ShowRedSign(eRedSignKey.Email,0)
    --    end
    --end
end

--显示或隐藏红点
function ShowRedSign(type,isShow,isMustShow)
    if isShow then
        if type==eSignEventName.Skill then
            if MPlayerInfo.Lv%3~=0 then
                return
            end
        elseif type==eSignEventName.StatusPoint then
            if MPlayerInfo.Lv%5~=0 then
                return
            end
        end
    end

    SetSignRelevance(type,isShow,isMustShow)

end

--添加红点事件
--添加的时候会进行一次显示
function AddRedSignEvent(eventName, method, object)
    EventDispatcher:Add(eventName,method,object)
    SetSignRelevance(eventName)
end
--移除红点事件
function RemoveEvent(eventName,object)
    EventDispatcher:RemoveObjectAllFunc(eventName, object)
end

--设置当前红点和关联的红点
--如果状态没有改变就不设置
function SetSignRelevance(type,isShow,isMustShow)
    if isMustShow==nil or isMustShow==false then
        local isRealShow=IsRelevanceSignShow(type)
        if isRealShow==isShow then
            return
        end
    end
    SetShowSign(type,isShow)
    for i, v in pairs(eSignEventRelevance) do
        if table.ro_contains(v,type) then
            SetShowSign(i)
        end
    end
end
--设置红点状态
function SetShowSign(type,isShow)
    if isShow~=nil then
        SetShowSignWithPlayerPrefs(type,isShow)
    end
    local isRelevanceShow=IsRelevanceSignShow(type)
    EventDispatcher:Dispatch(type,isRelevanceShow)
end

--根据此系统类型和关联类型得到此红点真实的显示状态
function IsRelevanceSignShow(type)
    local relevance=eSignEventRelevance[type]
    if relevance~=nil then
        for i, v in pairs(relevance) do
            local isShow=IsSignShow(v)
            if isShow then
                return true
            end
        end
    end
    return IsSignShow(type)
end
--得到此功能类型的红点显示状态
function IsSignShow(type)
    local isShow=RedSignShows[type]
    if isShow==nil then
        isShow=IsSignShowWithPlayerPrefs(type)
    end
    return isShow
end
--得到客户端存储的红点状态
function IsSignShowWithPlayerPrefs(type)
    local showPrefs=PlayerPrefs.GetInt(Common.Functions.GetPlayerPrefsKey(type),0)
    local isShow
    if showPrefs==1 then
        isShow=true
    else
        isShow=false
    end
    RedSignShows[type]=isShow
    return isShow
end
--存红点状态
function SetShowSignWithPlayerPrefs(type,isShow)
    RedSignShows[type]=isShow
    local showPrefs
    if isShow then
        showPrefs=1
    else
        showPrefs=0
    end
    PlayerPrefs.SetInt(Common.Functions.GetPlayerPrefsKey(type),showPrefs)
end

function OnSelectRoleNtf(info)

    OnLogIn()
end

function OnLogIn()
    for i, eventName in pairs(eSignEventName) do
        SetSignRelevance(eventName)
    end
end

--MgrMgr
function OnLogout()
    RedSignShows={}
end
