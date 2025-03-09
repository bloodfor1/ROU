--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CommunityPanel"


--lua requires end

--lua model
module("UI", package.seeall)

ECommunityType={
    Friend=Lang("CommunityType_Friend"),
    Email=Lang("CommunityType_Email"),
}
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CommunityCtrl = class("CommunityCtrl", super)
--lua class define end

--lua functions
function CommunityCtrl:ctor()

	super.ctor(self, CtrlNames.Community, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function CommunityCtrl:Init()

	self.panel = UI.CommunityPanel.Bind(self)
	super.Init(self)

    self.RedSignProcessorFriend=nil
    self.RedSignProcessorEmail=nil

    self.panel.CloseBtn:AddClick(function ()
        UIMgr:DeActiveUI(CtrlNames.Community)
    end)

    self.panel.Friend:SetActiveEx(false)

end --func end
--next--
function CommunityCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function CommunityCtrl:OnActive()
    self:_showHandler()


end --func end
--next--
function CommunityCtrl:OnDeActive()

    if self.RedSignProcessorFriend~=nil then
        self:UninitRedSign(self.RedSignProcessorFriend)
        self.RedSignProcessorFriend=nil
    end
    if self.RedSignProcessorEmail~=nil then
        self:UninitRedSign(self.RedSignProcessorEmail)
        self.RedSignProcessorEmail=nil
    end

end --func end

function CommunityCtrl:SetupHandlers()
    local l_handlerTb = {}

    local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    if l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Friend) then
        table.insert(l_handlerTb,{HandlerNames.Friends, ECommunityType.Friend})
    end
    if l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Email) then
        table.insert(l_handlerTb,{HandlerNames.Email, ECommunityType.Email})
    end

    self:InitHandler(l_handlerTb, self.panel.Friend, nil, false)
end

--next--
function CommunityCtrl:Update()
    super.Update(self)
end --func end

--next--
function CommunityCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function CommunityCtrl:OnHandlerActive(handlerName)
    if handlerName==HandlerNames.Friends then
        if self.RedSignProcessorFriend~=nil then
            self.RedSignProcessorFriend:ShowTemplateRedSign(0)
        end
    end
end

function CommunityCtrl:ChangePositionY(toPosition)

    local l_toPosition = self.uObj.transform.localPosition
    l_toPosition.y=toPosition
    MUITweenHelper.TweenPos(self.uObj.gameObject,self.uObj.transform.localPosition,l_toPosition, 0.2)
end

function CommunityCtrl:_showHandler()

    local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    local l_isFriendOpen=l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Friend)
    local l_isEmailOpen=l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Email)

    local l_defaultHandlerName

    local l_redMgr=MgrMgr:GetMgr("RedSignMgr")
    if not self.curHandler then
        local l_weakF=l_redMgr.IsRedSignShow(eRedSignKey.Friend)
        local l_weakE=l_redMgr.IsRedSignShow(eRedSignKey.Email)

        if l_weakF and l_isFriendOpen then
            l_defaultHandlerName=HandlerNames.Friends
        elseif l_weakE and l_isEmailOpen then
            l_defaultHandlerName=HandlerNames.Email
        elseif l_isFriendOpen then
            l_defaultHandlerName=HandlerNames.Friends
        elseif l_isEmailOpen then
            l_defaultHandlerName=HandlerNames.Email
        end
    end

    if l_defaultHandlerName then
        self:SelectOneHandler(l_defaultHandlerName)
    end

    self:_showFriend(l_isFriendOpen)
    self:_showEmail(l_isEmailOpen)


end
function CommunityCtrl:_showFriend(isOpen)

    if not isOpen then
        return
    end

    local l_tog = self:GetHandlerTogExByName(HandlerNames.Friends)
    if l_tog then
        local l_offObj = l_tog.transform:Find("OFF/OFFIcon")
        l_offObj = l_offObj.gameObject:GetComponent("MLuaUICom")
        l_offObj:SetSprite("CommonIcon","UI_CommonIcon_FriendsTab_Friends_02.png", true)
        local l_onObj = l_tog.transform:Find("ON/ONIcon")
        l_onObj = l_onObj.gameObject:GetComponent("MLuaUICom")
        l_onObj:SetSprite("CommonIcon","UI_CommonIcon_FriendsTab_Friends_01.png", true)
    end

    if self.RedSignProcessorFriend==nil then
        self.RedSignProcessorFriend=self:NewRedSign({
            Key=eRedSignKey.FriendAndHelper,
            ClickButton=self:GetHandlerByName(HandlerNames.Friends).toggle:GetComponent("MLuaUICom"),
            OnRedSignShow=function(template,redTableInfo,redCounts)

                if self.curHandler.name==HandlerNames.Friends then
                    local l_currentRedCount=0
                    for i = 1, #redCounts do
                        l_currentRedCount=l_currentRedCount+redCounts[i]
                    end
                    if l_currentRedCount>0 then

                        template:ShowRedSign(redTableInfo,{0})
                    end
                end

            end
        })
    end
end

function CommunityCtrl:_showEmail(isOpen)

    if not isOpen then
        return
    end

    local l_tog = self:GetHandlerTogExByName(HandlerNames.Email)
    if l_tog then
        local l_offObj = l_tog.transform:Find("OFF/OFFIcon")
        l_offObj = l_offObj.gameObject:GetComponent("MLuaUICom")
        l_offObj:SetSprite("CommonIcon","UI_CommonIcon_FriendsTab_Email_02.png", true)
        local l_onObj = l_tog.transform:Find("ON/ONIcon")
        l_onObj = l_onObj.gameObject:GetComponent("MLuaUICom")
        l_onObj:SetSprite("CommonIcon","UI_CommonIcon_FriendsTab_Email_01.png", true)
    end

    if self.RedSignProcessorEmail==nil then
        self.RedSignProcessorEmail=self:NewRedSign({
            Key=eRedSignKey.Email,
            ClickButton=self:GetHandlerByName(HandlerNames.Email).toggle:GetComponent("MLuaUICom")
        })
    end
end

--lua custom scripts end
return CommunityCtrl