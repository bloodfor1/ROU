require "SmallGames/SGameTouchBase"
module("SGame", package.seeall)

local super=SGame.SGameTouchBase

WinTouch=class("WinTouch",super)

function WinTouch:ctor()
    self.touchType=TouchType.Win
end
function WinTouch:Touch(resultData,touchArgData)
    if resultData==nil or resultData.data==nil then
        logError("WinTouch:Touch resultData is null!")
        return
    end
    if resultData.data.finished and resultData.data.win then
        self:ExecuteHandlers(touchArgData.handlerData,resultData)
    end
end