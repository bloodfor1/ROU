--- 这个Api作用是集中处理玩家身上的一些零碎数据
--- 现在包括了聊天标签，头像框，聊天气泡框的数据
--- 暂时不确定这些数据会随什么东西下来
module("Data", package.seeall)

---@class PlayerCustomDataApi
PlayerCustomDataApi = class("PlayerCustomDataApi")

function PlayerCustomDataApi:ctor()
    self.ChatBubbleID = 0
    self.IconFrameID = 0
    self.ChatTagID = 0
end

function PlayerCustomDataApi:Reset()
    self.ChatBubbleID = 0
    self.IconFrameID = 0
    self.ChatTagID = 0
end