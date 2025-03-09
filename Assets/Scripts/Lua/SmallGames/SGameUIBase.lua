require "UI/UIBaseCtrl"
--lua requires end

--lua model
module("SGame", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
SGameUIBase = class("SGameUIBase", super)
function SGameUIBase:ctor(name, sortLayer, tweenType, activeType)
    super.ctor(self, name,sortLayer, tweenType, activeType)
    self.operatebleObject={}
end
function SGameUIBase:RegisteOperableObject(objectName,gameObj)
    self.operatebleObject[objectName]=gameObj
end
function SGameUIBase:UnRegisteOperableObject(objectName)
    self.operatebleObject[objectName]=nil
end
function SGameUIBase:ClearOperableObject()
    self.operatebleObject={}
end
function SGameUIBase:GetOperableObject(objectName)
    return self.operatebleObject[objectName]
end
function SGameUIBase:OnSGameObjectClick(objectName) --废弃
    MgrMgr:GetMgr("SmallGameMgr").ExecuteOneStep(objectName)
end
function SGameUIBase:CloseSmallGame()
    MgrMgr:GetMgr("SmallGameMgr").CloseSmallGame(self.name)
end
function SGameUIBase:ExecuteOneStep(objectName)
    MgrMgr:GetMgr("SmallGameMgr").ExecuteOneStep(objectName)
end
function SGameUIBase:DeliverEvent(event,eventType)
    MgrMgr:GetMgr("SmallGameMgr").DeliverEvent(event,eventType)
end
function SGameUIBase:OnLeaveSmallGame()
    self:ClearOperableObject()
    MgrMgr:GetMgr("SmallGameMgr").OnLeaveSmallGame()
end
function SGameUIBase:ParseGameInfo(infoStr)
end
function SGameUIBase:NoticeShowEffect(effectName,showState)
end