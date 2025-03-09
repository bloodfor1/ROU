require "SmallGames/QTEBase"
module("SGame", package.seeall)

local super=SGame.QTEBase

RotateQTE=class("RotateQTE",super)

function RotateQTE:ctor(qteCtrl)
    super.ctor(self,qteCtrl)
end
function RotateQTE:Init(argData)
    super:Init()
    self.argData=argData
    self.startDrag=false
    if not MLuaCommonHelper.IsNull(self.argData.operaRectT) then
        self.currentOulerAngle=self.argData.operaRectT.localEulerAngles
    end
end
function RotateQTE:CanDrag(clickpos)
    local l_disToTarSquar= self:Get2DPointDisSquare(clickpos,self.argData.beginPos)
    if l_disToTarSquar<=self.argData.scopeSquare then
        return true
    end
    return false
end
function RotateQTE:OnBeginDrag(uobj,event)
    if self.startDrag then
        return
    end
    if not self:CanDrag(event.position) then
        self:SendQTEResult(true,false,nil)
        self.startDrag=false
        return
    end
    local _,l_lerpValue=self:CountProjPointAtLine(self.argData.beginPos,self.argData.endPos,event.position,true)
    self:SetRotateAngle(l_lerpValue)
    self.startDrag=true
end
function RotateQTE:OnDrag(uobj,event)
    if not self.startDrag then
        return
    end
    local l_rectPos,l_lerpValue=self:CountProjPointAtLine(self.argData.beginPos,self.argData.endPos,event.position,true)
    if l_lerpValue>=1 then
        self.startDrag=false
        self:SetRotateAngle(1)
        self:SendQTEResult(true,true,nil)
    else
        self:SetRotateAngle(l_lerpValue)
    end

end

function RotateQTE:OnEndDrag(uobj,event)
    if not self.startDrag then
        return
    end
    self.startDrag=false
    if self:IsDragToTarget(event.position) then
        self:SetRotateAngle(1)
        self:SendQTEResult(true,true,nil)
    else
        self:SetRotateAngle(0)
        self:SendQTEResult(true,false,nil)
    end
end
function RotateQTE:SetRotateAngle(dragLerp)
    if MLuaCommonHelper.IsNull(self.argData.operaRectT) then
        return
    end
    local l_rotateZ= self.argData.sourceAngle+(self.argData.targetAngle-self.argData.sourceAngle)*dragLerp
    self.currentOulerAngle.z=l_rotateZ
    self.argData.operaRectT.localEulerAngles=self.currentOulerAngle
    if self.argData.enableMove then
        local l_moveToPos=Vector2.Lerp(self.argData.beginPos,self.argData.moveToPos,dragLerp)
        self:SetAnchorePosByScreenPos(self.argData.operaRectT,l_moveToPos)
    end
end
function RotateQTE:IsDragToTarget(currentPos)
    local l_disToTarSquar= self:Get2DPointDisSquare(currentPos,self.argData.endPos)
    if l_disToTarSquar<=self.argData.scopeSquare then
        return true
    end
    return false
end
function RotateQTE:ParseArg(arg)
    local l_data={}
    if not MLuaCommonHelper.IsNull(arg.gameObjCom) and not MLuaCommonHelper.IsNull(arg.gameObjCom.RectTransform) then
        l_data.operaRectT=arg.gameObjCom.RectTransform
    end
    l_data.beginPos=Vector2.New(0,0)
    l_data.endPos=Vector2.New(0,0)
    l_data.moveToPos=Vector2.New(0,0)
    l_data.scopeSquare=9
    l_data.sourceAngle=0
    l_data.targetAngle=90
    l_data.enableMove=false --开启旋转伴随适当移动
    local l_argSplitArray=Common.Utils.ParseString(arg.arg,"_",7)
    if l_argSplitArray==nil then
        logError("Rotate:ParseArg arg error!")
        return l_data
    end
    local l_localBegin=Vector3.New(tonumber(l_argSplitArray[1])/1000,tonumber(l_argSplitArray[2])/1000,tonumber(l_argSplitArray[3])/1000)
    local l_localEnd=Vector3.New(tonumber(l_argSplitArray[4])/1000,tonumber(l_argSplitArray[5])/1000,tonumber(l_argSplitArray[6])/1000)
    l_data.beginPos= self:GetScreenPosByLocalPosition(l_localBegin,l_data.operaRectT)
    l_data.endPos= self:GetScreenPosByLocalPosition(l_localEnd,l_data.operaRectT)

    local l_screenWidth=Screen.width

    l_data.sourceAngle=tonumber(l_argSplitArray[7])
    l_data.targetAngle=tonumber(l_argSplitArray[8])
    local l_scope=tonumber(l_argSplitArray[9])/1000*l_screenWidth
    l_data.scopeSquare=l_scope*l_scope

    if #l_argSplitArray>11 then
        l_data.enableMove=true
        local l_localMoveToPos=Vector3.New(tonumber(l_argSplitArray[10])/1000,tonumber(l_argSplitArray[11])/1000,tonumber(l_argSplitArray[12])/1000)
        l_data.moveToPos= self:GetScreenPosByLocalPosition(l_localMoveToPos,l_data.operaRectT)
    end
    return l_data
end