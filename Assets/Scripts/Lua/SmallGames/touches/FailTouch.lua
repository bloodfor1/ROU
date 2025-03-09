require "SmallGames/SGameTouchBase"
module("SGame", package.seeall)

local super=SGame.SGameTouchBase

FailTouch=class("FailTouch",super)

function FailTouch:ctor()
    self.touchType=TouchType.Fail
end
function FailTouch:Touch(resultData,touchArgData)
    if resultData==nil or resultData.data==nil then
        logError("FailTouch:Touch resultData is null!")
        return
    end
    if resultData.data.finished and not resultData.data.win then
        self:ExecuteHandlers(touchArgData.handlerData,resultData)
    end
end