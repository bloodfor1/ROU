require "SmallGames/QTEBase"
module("SGame", package.seeall)

local super=SGame.QTEBase

DragQTE=class("DragQTE",super)

function DragQTE:ctor(qteCtrl)
    super.ctor(self,qteCtrl)
end
function DragQTE:Init(argData)
    super:Init()
    self.argData=argData
    self.startDrag=false
end
function DragQTE:CanDrag(clickpos)
    local l_disToTarSquar= self:Get2DPointDisSquare(clickpos,self.argData.beginPos)
    if l_disToTarSquar<=self.argData.scopeSquare then
        return true
    end
    return false
end
function DragQTE:OnBeginDrag(uobj,event)
    if self.startDrag then
        return
    end
    if not self:CanDrag(event.position) then
        self.startDrag=false
        self:SendQTEResult(true,false,nil)
        return
    end
    local l_rectPos=self:CountProjPointAtLine(self.argData.beginPos,self.argData.endPos,event.position,true)
    self:SetAnchorePosByScreenPos(self.argData.operaRectT,l_rectPos)
    self.startDrag=true
end
function DragQTE:OnDrag(uobj,event)
    if not self.startDrag then
        return
    end
    local l_rectPos,l_lerpValue=self:CountProjPointAtLine(self.argData.beginPos,self.argData.endPos,event.position,true)
    if l_lerpValue>=1 then
        self.startDrag=false
        self:SetAnchorePosByScreenPos(self.argData.operaRectT,self.argData.endPos)
        self:SendQTEResult(true,true,nil)
    else
        self:SetAnchorePosByScreenPos(self.argData.operaRectT,l_rectPos)
    end

end

function DragQTE:OnEndDrag(uobj,event)
    if not self.startDrag then
        return
    end
    self.startDrag=false
    if self:IsDragToTarget(event.position) then
        self:SetAnchorePosByScreenPos(self.argData.operaRectT,self.argData.endPos)
        self:SendQTEResult(true,true,nil)
    else
        self:SetAnchorePosByScreenPos(self.argData.operaRectT,self.argData.beginPos)
        self:SendQTEResult(true,false,nil)
    end
end
function DragQTE:IsDragToTarget(currentPos)
    local l_disToTarSquar= self:Get2DPointDisSquare(currentPos,self.argData.endPos)
    if l_disToTarSquar<=self.argData.scopeSquare then
        return true
    end
    return false
end
function DragQTE:ParseArg(arg)
    local l_data={}
    if not MLuaCommonHelper.IsNull(arg.gameObjCom) and not MLuaCommonHelper.IsNull(arg.gameObjCom.RectTransform) then
        l_data.operaRectT=arg.gameObjCom.RectTransform
    end
    l_data.beginPos=Vector2.New(0,0)
    l_data.endPos=Vector2.New(0,0)
    l_data.scopeSquare=9

    local l_argSplitArray=Common.Utils.ParseString(arg.arg,"_",7)
    if l_argSplitArray==nil then
        logError("DragQTE:ParseArg arg error!")
        return l_data
    end
    local l_localBegin=Vector3.New(tonumber(l_argSplitArray[1])/1000,tonumber(l_argSplitArray[2])/1000,tonumber(l_argSplitArray[3])/1000)
    local l_localEnd=Vector3.New(tonumber(l_argSplitArray[4])/1000,tonumber(l_argSplitArray[5])/1000,tonumber(l_argSplitArray[6])/1000)
    l_data.beginPos= self:GetScreenPosByLocalPosition(l_localBegin,l_data.operaRectT)
    l_data.endPos= self:GetScreenPosByLocalPosition(l_localEnd,l_data.operaRectT)

    local l_screenWidth=Screen.width
    local l_scope=tonumber(l_argSplitArray[7])/1000*l_screenWidth
    l_data.scopeSquare=l_scope*l_scope

    return l_data
end