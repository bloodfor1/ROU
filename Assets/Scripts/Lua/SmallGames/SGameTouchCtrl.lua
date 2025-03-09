module("SGame", package.seeall)

SGameTouchCtrl=class("SGameTouchCtrl")

function SGameTouchCtrl:ctor()
    self.touchTable={}
end
function SGameTouchCtrl:HandleTouch(touchArgData,resultData)
    local l_touchObj=self:GetTouchObj(touchArgData.touchType)
    if l_touchObj==nil then
        return
    end
    l_touchObj:Touch(resultData,touchArgData)
end
function SGameTouchCtrl:ParseTouchArg(infoStr)
    local parseData=nil
    local l_splitArray=Common.Utils.ParseString(infoStr,SGame.ParseSeparator.TouchInfo,2)
    if l_splitArray==nil then
        logError("ParseTouchArg error!")
        return parseData
    end
    local l_touchType=tonumber(l_splitArray[1])
    local touchArg=l_splitArray[2]

    local l_touchObj=self:GetTouchObj(l_touchType)

    if l_touchObj~=nil then
        parseData=l_touchObj:ParseTouchArg(touchArg)
    end
    return parseData
end
function SGameTouchCtrl:GetTouchObj(touchType)
    local l_touchObj=nil
    l_touchObj=self.touchTable[touchType]
    if l_touchObj~=nil then
        return l_touchObj
    end
    if touchType==TouchType.Auto then
        require("SmallGames/touches/AutoTouch")
        l_touchObj=SGame.AutoTouch.new()
    elseif touchType==TouchType.Win then
        require("SmallGames/touches/WinTouch")
        l_touchObj=SGame.WinTouch.new()
    elseif touchType==TouchType.Fail then
        require("SmallGames/touches/FailTouch")
        l_touchObj=SGame.FailTouch.new()
    elseif touchType==TouchType.CheckStep then
        require("SmallGames/touches/CheckObjectStepTouch")
        l_touchObj=SGame.CheckObjectStepTouch.new()
    else
        logError("SGameTouchCtrl:GetTouchObj not exist touchType:"..tostring(touchType))
    end
    self.touchTable[touchType]=l_touchObj
    return l_touchObj
end
