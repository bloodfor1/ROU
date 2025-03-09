require "SmallGames/QTEBase"
module("SGame", package.seeall)

local super=SGame.QTEBase

ClickQTE=class("ClickQTE",super)

function ClickQTE:ctor(qteCtrl)
    super.ctor(self,qteCtrl)
end
function ClickQTE:Init(argData)
    super:Init()
    self.argData=argData
    self.transData={}
    self.transData.clickNum=0
    self.limitTimer=self:DelayTimer(function()
        self:OnTimeUp()
    end ,self.argData.timeLimit)
end
function ClickQTE:OnClick(uobj,event)
    if self.argData.fullScreenClick then
        self:OnClickSuc()
        return
    end
    if self:IsPosInScope(event.position,self.argData.clickPos,self.argData.scopeSquare) then
        self:OnClickSuc()
    end
end
function ClickQTE:OnClickSuc()
    self.transData.clickNum=self.transData.clickNum+1
    if self.transData.clickNum>=self.argData.needClickNum then
        self:SendQTEResult(true,true,self.transData)
    else
        self:SendQTEResult(false,false,self.transData)
    end
end
function ClickQTE:OnTimeUp()
    self:SendQTEResult(true,false,self.transData)
end
function ClickQTE:CanDrag(clickpos)
    local l_disToTarSquar= self:Get2DPointDisSquare(clickpos,self.argData.beginPos)
    if l_disToTarSquar<=self.argData.scopeSquare then
        return true
    end
    return false
end
function ClickQTE:ParseArg(arg)
    local l_data={}
    l_data.needClickNum=1
    l_data.timeLimit=3600
    l_data.fullScreenClick=true
    l_data.clickPos=Vector2.New(0,0)
    l_data.scopeSquare=9
    if arg.arg==nil then
        return l_data
    end
    local l_argSplitArray=Common.Utils.ParseString(arg.arg,"_",1)
    local l_paramCount=#l_argSplitArray
    if l_paramCount>2 then
        l_data.needClickNum=tonumber(l_argSplitArray[1])
        l_data.timeLimit=tonumber(l_argSplitArray[2])
    end
    if l_paramCount>5 then
        l_data.clickPos.x=tonumber(l_argSplitArray[3])/1000*Screen.width
        l_data.clickPos.y=tonumber(l_argSplitArray[4])/1000*Screen.height
        local l_scope=tonumber(l_argSplitArray[5])/1000*Screen.width
        l_data.scopeSquare=l_scope*l_scope
        l_data.fullScreenClick=false
    end

    return l_data
end
function ClickQTE:Clear()
    super:Clear()
    if self.limitTimer~=nil then
        self.limitTimer:Stop()
        self.limitTimer=nil
    end
end