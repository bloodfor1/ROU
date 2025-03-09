require "SmallGames/SGameTouchBase"
module("SGame", package.seeall)

local super=SGame.SGameTouchBase

CheckObjectStepTouch=class("CheckObjectStepTouch",super)

function CheckObjectStepTouch:ctor()
    self.touchType=TouchType.CheckStep
end
function CheckObjectStepTouch:Touch(resultData,touchArgData)
    if resultData==nil or resultData.data==nil then
        logError("CheckObjectStepTouch:Touch resultData is null!")
        return
    end
    if resultData.data.finished then
        local l_procedureCtrl=self:GetProcedureCtrl()
        if l_procedureCtrl~=nil then
            local l_smallGameObj= l_procedureCtrl:GetObjectInfo(touchArgData.data.checkObjName)

            if l_smallGameObj~=nil then
                local l_isTouch=false
                if touchArgData.data.finishStepTouch then   --完成指定对象指定步骤触发
                    l_isTouch=l_smallGameObj.currentStepId>touchArgData.data.completeStep
                else  --未完成指定对象指定步骤触发
                    l_isTouch=l_smallGameObj.currentStepId<=touchArgData.data.completeStep
                end
                if l_isTouch then
                    self:ExecuteHandlers(touchArgData.handlerData,resultData)
                end
            end
        end
    end
end
function CheckObjectStepTouch:ParseArg(infoStr)
    local l_splitArray=Common.Utils.ParseString(infoStr,"_",2)
    if l_splitArray==nil then
        logError("CheckObjectStepTouch ParseArg error:"..tostring(infoStr))
        return
    end
    local data={}
    data.checkObjName=l_splitArray[1]
    data.completeStep=tonumber(l_splitArray[2])
    data.finishStepTouch=true
    if #l_splitArray>2 then
        local l_touchCondition=tonumber(l_splitArray[3])
        data.finishStepTouch=l_touchCondition==1 and true or false
    end
    return data
end
return CheckObjectStepTouch
