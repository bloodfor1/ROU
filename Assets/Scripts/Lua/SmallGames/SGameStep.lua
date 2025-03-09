module("SGame", package.seeall)

SGameStep=class("SGameStep")

function SGameStep:ctor(infoStr,sGameObject)
    self.stepID=0
    self.operaType=0
    self.touchTable={}
    self.operaArg={}
    self.transData={}
    self.transData.sGameObj=sGameObject
    self.waitOperaResult=false
    self.finished=false
    self.autoExecNextStep=true
    self:ParseStepStr(infoStr)
end
function SGameStep:ParseStepStr(infoStr)
    local l_stepSplitArray=Common.Utils.ParseString(infoStr,SGame.ParseSeparator.Touch,1)

    self:ParseStepInfo(l_stepSplitArray[1])
    for i = 2, #l_stepSplitArray do
        local touchData=MgrMgr:GetMgr("SmallGameMgr").ParseTouchData(l_stepSplitArray[i])
        if touchData~=nil then
            table.insert(self.touchTable,touchData)
        end
    end
end
function SGameStep:PrintObjectInfo()
    logError("StepID:"..tostring(self.stepID))
end
function SGameStep:ParseStepInfo(infoStr)
    local l_stepSplitArray=Common.Utils.ParseString(infoStr,SGame.ParseSeparator.StepParam,2)
    if l_stepSplitArray==nil then
        logError("SGameStep:ParseStepInfo error!")
        return
    end

    local l_stepInfoArray=Common.Utils.ParseString(l_stepSplitArray[1],SGame.ParseSeparator.StepInfo,1)
    self.stepID=tonumber(l_stepInfoArray[1])
    if #l_stepInfoArray>1 then
        self.autoExecNextStep=(tonumber(l_stepInfoArray[2])==0 and {false} or {true})[1]
    end

    local l_operaSplitArray=Common.Utils.ParseString(l_stepSplitArray[2],SGame.ParseSeparator.OperaInfo,1)
    self.operaType=tonumber(l_operaSplitArray[1])
    if #l_operaSplitArray>1 then
        self.operaArg.arg=l_operaSplitArray[2]
    end
end

function SGameStep:ExcuteStep()
    if self.finished then
        logYellow("当前步骤已经结束，StepID:"..tostring(self.stepID))
        return
    end
    if self.waitOperaResult then
        logYellow("当前步骤正在等待结果中，StepID:"..tostring(self.stepID))
        return
    end
    local l_operaResultCallBack= function(data)
        if self.finished then
            return
        end
        self.transData.data=data
        for i = 1,#self.touchTable do
            local l_touchData=self.touchTable[i]
            MgrMgr:GetMgr("SmallGameMgr").ExecuteTouch(l_touchData,self.transData)
        end
        if data.finished then
            if self.transData.sGameObj~=nil then
                self.transData.sGameObj:OnCurrentStepComplete(data.win,self.autoExecNextStep)
            end
        end
    end
    if self.operaType==0 then
        local l_data={}
        l_data.finished=true
        l_data.win=true
        l_operaResultCallBack(l_data)
    else
        self:ExecuteQTEOpera(self.operaType,l_operaResultCallBack)
    end
end
function SGameStep:Reset()
    self.waitOperaResult=false
    self.finished=false
end
function SGameStep:ExecuteSelfDefineOpera(operaType, operaResultCallBack)
    self.waitOperaResult=true
    if operaType==SGame.SelfDefOperaType.ActiveObject then
    else
        self.waitOperaResult=false
    end
end
function SGameStep:ExecuteQTEOpera(operaType,operaResultCallBack)
    self.waitOperaResult=true
    if self.transData.sGameObj~=nil then
        self.operaArg.gameObjCom=self.transData.sGameObj.gameObjCom
    end
    MgrMgr:GetMgr("SmallGameMgr").ShowQTE(operaType,self.operaArg,operaResultCallBack)
end
return SGameStep