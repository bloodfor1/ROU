require "SmallGames/QTEBase"
module("SGame", package.seeall)

local super=SGame.QTEBase

ShakeQTE=class("ShakeQTE",super)

function ShakeQTE:ctor(qteCtrl)
    super.ctor(self,qteCtrl)
end

function ShakeQTE:Init(argData)
    super:Init()
    self.argData=argData
    self.startDrag=false
    MScene.OpenShakeFunc=true
    self.transData={}
    self.transData.percent=0
    self.shakeValue=0
    self.lastDragPos=Vector2.New(0,0)
    self:SendShakeResult(0)
end

function ShakeQTE:OnClick(uobj,event)
    self.shakeValue=self.shakeValue+20
    self:SendShakeResult(self.shakeValue*100/self.argData.shakeMaxValue)
end

function ShakeQTE:isOperaValid(clickpos)
    local l_disToTarSquar= self:Get2DPointDisSquare(clickpos,self.argData.beginPos)
    if l_disToTarSquar<=self.argData.scopeSquare then
        return true
    end
    return false
end

function ShakeQTE:OnBeginDrag(uobj,event)
    if self.startDrag or not self.argData.enableDrag then
        return
    end
    if not self:isOperaValid(event.position) then
        self.startDrag=false
        return
    end
    self.lastDragPos=event.position
    self.startDrag=true
end
function ShakeQTE:OnDrag(uobj,event)
    if not self.startDrag then
        return
    end
    if not self:isOperaValid(event.position) then
        self.startDrag=false
    end
    local l_shakeValueY= (event.position.y-self.lastDragPos.y)*100/Screen.height
    local l_shakeValueX= (event.position.x-self.lastDragPos.x)*100/Screen.width
    local l_shakeValue=math.abs(l_shakeValueY)+math.abs(l_shakeValueX)
    self.lastDragPos=event.position
    self.shakeValue=self.shakeValue+l_shakeValue
    self:SendShakeResult(self.shakeValue*100/self.argData.shakeMaxValue)
end
function ShakeQTE:NotifyShakeDegree(shakeDegree)
    self.shakeValue=self.shakeValue+shakeDegree*self.argData.shakeFactor
    self:SendShakeResult(self.shakeValue*100/self.argData.shakeMaxValue)
end
function ShakeQTE:SendShakeResult(shakePercent)
    self.transData.percent=shakePercent
    if shakePercent>=100 then
        self:SendQTEResult(true,true,self.transData)
    else
        self:SendQTEResult(false,false,self.transData)
    end
end
function ShakeQTE:OnEndDrag(uobj,event)
    if not self.startDrag then
        return
    end
    self.startDrag=false
end

function ShakeQTE:ParseArg(arg)
    local l_data={}

    l_data.beginPos=Vector2.New(0,0)
    l_data.scopeSquare=20

    local l_argSplitArray=Common.Utils.ParseString(arg.arg,"_",4)
    if l_argSplitArray==nil then
        logError("ShakeQTE:ParseArg arg error!")
        return l_data
    end
    local l_screenWidth=Screen.width
    local l_screenHeight=Screen.height

    l_data.beginPos.x=tonumber(l_argSplitArray[1])/1000*l_screenWidth
    l_data.beginPos.y=tonumber(l_argSplitArray[2])/1000*l_screenHeight

    local l_scope=tonumber(l_argSplitArray[3])/1000*l_screenWidth
    l_data.scopeSquare=l_scope*l_scope

    l_data.shakeMaxValue=tonumber(l_argSplitArray[4])
    if l_data.shakeMaxValue==0 then
        l_data.shakeMaxValue=100
    end
    l_data.enableDrag=true
    l_data.shakeFactor=1  --摇一摇值权重系数
    if #l_argSplitArray>4 then
        l_data.enableDrag=(tonumber(l_argSplitArray[5])==1 and {true} or {false})[1]
    end
    if #l_argSplitArray>5 then
        l_data.shakeFactor=tonumber(l_argSplitArray[6])
    end
    return l_data
end
function ShakeQTE:Clear()
    super:Clear()
    MScene.OpenShakeFunc=false
end

return ShakeQTE