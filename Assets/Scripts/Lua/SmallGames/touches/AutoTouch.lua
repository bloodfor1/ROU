require "SmallGames/SGameTouchBase"
module("SGame", package.seeall)

local super=SGame.SGameTouchBase

AutoTouch=class("AutoTouch",super)

function AutoTouch:ctor()
    self.touchType=TouchType.Auto
end
function AutoTouch:Touch(resultData,touchArgData)
    self:ExecuteHandlers(touchArgData.handlerData,resultData)
end