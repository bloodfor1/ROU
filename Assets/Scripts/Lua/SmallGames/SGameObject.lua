require("SmallGames/SGameStep")

module("SGame", package.seeall)

SGameObject=class("SGameObject")

function SGameObject:ctor(infoStr,procedureCtrl)
    self.steps={}
    self.objectName=""
    self.active=false
    self.needAwakeNum=0
    self.awakeNum=0
    self.currentStepId=1
    self.nextStepId=2
    self.gameObjCom=nil
    self.procedureCtrl=procedureCtrl
    self:ParseObjectStr(infoStr)
end
function SGameObject:ParseObjectStr(infoStr)
    local l_stepArray=Common.Utils.ParseString(infoStr,SGame.ParseSeparator.Step,2)--小游戏 步骤间用‘|’分隔
    if l_stepArray==nil then
        logError("SGameObject:ParseObjectStr error!")
        return
    end
    self:ParseObjectInfo(l_stepArray[1])

    for i = 2, #l_stepArray do
        local l_step= SGame.SGameStep.new(l_stepArray[i],self)
        self.steps[l_step.stepID]=l_step
    end
end
function SGameObject:PrintObjectInfo()
    logError(self.objectName)
    for k,v in pairs(self.steps) do
        v:PrintObjectInfo()
    end
end
function SGameObject:ParseObjectInfo(objectStr)
    local l_splitArray=Common.Utils.ParseString(objectStr,SGame.ParseSeparator.SmallGameObjectInfo,2)
    if l_splitArray==nil then
        logError("SGameObject:ParseObjectInfo error!")
        return
    end

    self.objectName=l_splitArray[1]
    if self.procedureCtrl~=nil then
        self.gameObjCom=self.procedureCtrl.sGameCtrl:GetOperableObject(self.objectName)
    end
    local l_objParamSplitArray=Common.Utils.ParseString(l_splitArray[2],SGame.ParseSeparator.ObjectInfoParam,1)
    local l_awakeContion=tonumber(l_objParamSplitArray[1])
    if l_awakeContion==SGame.ObjectActiveMode.NATURAL then
        self.active=true
        self.currentStepId=1
    elseif l_awakeContion==SGame.ObjectActiveMode.AWAKE_NUM then
        if #l_objParamSplitArray<2 then
            self.needAwakeNum=1
            logError(self.objectName.." 次数唤醒对象模式缺少次数参数！")
        else
            self.needAwakeNum=tonumber(l_objParamSplitArray[2])
        end
    else
        logError(self.objectName.." 不存在的唤醒模式："..tostring(l_awakeContion))
    end
end
function SGameObject:AwakeObject(isExecuteOneStep)
    if self.active then
        return
    end
    self.awakeNum=self.awakeNum+1
    if self.needAwakeNum<=self.awakeNum then
        self.active=true
        self.currentStepId=1
        if isExecuteOneStep then
            self:ExecuteOneStep()
        end
    end
end
function SGameObject:SetNextStep(stepId)
    if not self.active then
        logYellow("SGameObject:ExecuteOneStep error:object not active!")
        return
    end
    self.nextStepId=stepId
end
function SGameObject:OnCurrentStepComplete(isWin,execNextStep)
    if not isWin then
        local l_step=self.steps[self.currentStepId]
        if l_step~=nil then
            l_step:Reset()
        end
        return
    end
    self.currentStepId=self.nextStepId
    self.nextStepId=self.currentStepId+1
    if execNextStep then
        self:ExecuteOneStep()
    end
end
function SGameObject:ExecuteOneStep()
    if not self.active then
        logYellow("SGameObject:ExecuteOneStep error:object not active!")
        return
    end
    if self.currentStepId>#self.steps then
        logYellow("SGameObject has no remain step!")
        return
    end
    local l_step=self.steps[self.currentStepId]
    if l_step==nil then
        logError("SGameObject:ExecuteOneStep error:step is nil!currentStepId:"..tostring(self.currentStepId))
        return
    end
    l_step:ExcuteStep()
end
return SGameObject