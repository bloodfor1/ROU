require "Data/Model/PlayerCustomDataApi"

--- 为什么有了api还搞一个mgr，因为生命周期和初始化等行为不希望对其他具体业务的mgr产生依赖
---@module ModuleMgr.PlayerCustomDataMgr
module("ModuleMgr.PlayerCustomDataMgr", package.seeall)

function OnInit()
    Data.PlayerCustomDataApi:Reset()
end

function OnLogout()
    -- do nothing
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    -- do nothing
end

function SetIconFrame(frameID)
    Data.PlayerCustomDataApi.IconFrameID = frameID
    MPlayerInfo.FrameID = frameID
    if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
        MEntityMgr.PlayerEntity.AttrComp:SetHeadIconFrame(frameID)
    end
end

function GetIconFrame()
    return Data.PlayerCustomDataApi.IconFrameID
end

function SetBubbleID(id)
    Data.PlayerCustomDataApi.ChatBubbleID = id
end

function GetBubbleID()
    return Data.PlayerCustomDataApi.ChatBubbleID
end

function SetChatTagID(id)
    Data.PlayerCustomDataApi.ChatTagID = id
end

function GetChatTagID()
    return Data.PlayerCustomDataApi.ChatTagID
end