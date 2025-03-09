module("SGame", package.seeall)

SGameTouchBase=class("SGameTouchBase")

function SGameTouchBase:ctor(infoStr)
end
function SGameTouchBase:ExecuteHandlers(handlerData,resultData)
    if handlerData==nil then
        logError("SGameTouchBase:ExecuteHandlers no handlerData!")
        return
    end
    for i = 1, #handlerData do
        MgrMgr:GetMgr("SmallGameMgr").ExecuteHandler(handlerData[i],resultData)
    end
end
function SGameTouchBase:Touch(resultData,touchArgData)
end
function SGameTouchBase:ParseArg(arg)
end
function SGameTouchBase:ParseTouchArg(infoStr)
    local l_splitArray=Common.Utils.ParseString(infoStr,",",2)
    if l_splitArray==nil then
        self:LoadErrorLog("ParseTouchStr error!")
        return nil
    end

    local touchData={}
    touchData.touchType=self.touchType
    touchData.data=self:ParseArg(l_splitArray[1])
    touchData.handlerData={}
    for i = 2, #l_splitArray do
        local l_handlerData= MgrMgr:GetMgr("SmallGameMgr").ParseHandlerData(l_splitArray[i])
        if l_handlerData~=nil then
            table.insert(touchData.handlerData,l_handlerData)
        end
    end
    return touchData
end
function SGameTouchBase:GetProcedureCtrl()
    return MgrMgr:GetMgr("SmallGameMgr").GetProcedureCtrl()
end