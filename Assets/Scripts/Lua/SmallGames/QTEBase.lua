module("SGame", package.seeall)

QTEBase=class("QTEBase")

function QTEBase:ctor(qteCtrl)
    self.resultInfo={}
    self.qteCtrl=qteCtrl
end
function QTEBase:Init(data)

end
function QTEBase:ParseArg(arg)
end
function QTEBase:Clear()
    self.resultInfo={}
end
function QTEBase:OnClick(uobj,event)
end
function QTEBase:OnBeginDrag(uobj,event)
end
function QTEBase:OnDrag(uobj,event)
end
function QTEBase:OnEndDrag(uobj,event)
end
function QTEBase:IsPosInScope(pos,scopeCenterPos,radiusSquare)
    local l_disToTarSquar= self:Get2DPointDisSquare(pos,scopeCenterPos)
    if l_disToTarSquar<=radiusSquare then
        return true
    end
    return false
end
function QTEBase:CountProjPointAtLine(lineSourcePoint,lineEndPoint,needProjPoint,limitRegion) --计算needProjPoint点线上的投影点
    local l_lineVec=lineEndPoint-lineSourcePoint
    local l_lineLength=l_lineVec.magnitude
    local l_projPointLerpValue=0   --投影点在直线中的lerp值
    if l_lineLength==0 then
        return lineSourcePoint,l_projPointLerpValue
    end
    local l_lineVecNormalize=l_lineVec/l_lineLength
    local l_projLen=Vector2.Dot(needProjPoint-lineSourcePoint,l_lineVecNormalize)
    local l_projPoint=lineSourcePoint
    if l_projLen>0 then
        l_projPointLerpValue=l_projLen/l_lineLength
        if l_projPointLerpValue>1 then
            l_projPointLerpValue=1
        end
    end
    l_projPoint=l_projLen*l_lineVecNormalize+lineSourcePoint
    if limitRegion then
        if l_projPointLerpValue<=0 then
            l_projPoint=lineSourcePoint
        elseif l_projPointLerpValue>=1 then
            l_projPoint=lineEndPoint
        end
    end
    return l_projPoint,l_projPointLerpValue
end
function QTEBase:Get2DPointDisSquare(sourcePoint,targetPoint)
    local l_xDis=sourcePoint.x-targetPoint.x
    local l_yDis=sourcePoint.y-targetPoint.y
    return l_xDis*l_xDis+l_yDis*l_yDis
end
function QTEBase:SendQTEResult(finished,win,data)
    local l_sendData=nil
    if finished then
        l_sendData={}
    else
        l_sendData=self.resultInfo
    end
    l_sendData.finished=finished
    l_sendData.win=win
    l_sendData.data=data

    if self.qteCtrl~=nil then
        self.qteCtrl:SendResultInfo(l_sendData)
    end
end
function QTEBase:SetAnchorePosByScreenPos(rectTran,screenPos) --根据屏幕坐标设置RectTransform位置
    local uiCamera = MUIManager.UICamera
    if MLuaCommonHelper.IsNull(uiCamera) then
        return
    end
    MLuaCommonHelper.SetRectTransformPosBySceenPos(screenPos,uiCamera,rectTran)
end
function QTEBase:GetScreenPosByLocalPosition(localPos,trans) --根据localposition获得屏幕坐标
    local uiCamera = MUIManager.UICamera
    if MLuaCommonHelper.IsNull(uiCamera) then
        return Vector2.New(0,0)
    end
    return MLuaCommonHelper.LocalPositionToScreenPos(localPos, uiCamera, trans)
end
function QTEBase:NotifyShakeDegree(shakeDegree) --通知摇一摇的晃动值

end
function QTEBase:DelayTimer(func,duration)
    local l_timer= Timer.New(func, duration, 1, false)
    l_timer:Start()
    return l_timer
end
