--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SceneObjControllerPanel"
require "UI/Template/ParallelSceneUITemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
SceneObjControllerCtrl = class("SceneObjControllerCtrl", super)
--lua class define end

--lua functions
function SceneObjControllerCtrl:ctor()

    super.ctor(self, CtrlNames.SceneObjController, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function SceneObjControllerCtrl:Init()

    self.panel = UI.SceneObjControllerPanel.Bind(self)
    super.Init(self)

    self.BUTTON_FX_ID = 120032
    
    --self.sceneUITemplates={}
    self.sceneUIInfoDic={}
end --func end
--next--
function SceneObjControllerCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function SceneObjControllerCtrl:OnActive()
	if self.uiPanelData then
        self:showSceneUI(true,self.uiPanelData)
	end
end --func end
--next--
function SceneObjControllerCtrl:OnDeActive()
    MSceneObjControllerCSharpMgr.IsPlaying=false
    self:clearSceneUIInfo()
end --func end
--next--
function SceneObjControllerCtrl:Update()
    self:updateSceneUIInfo()
end --func end
--next--
function SceneObjControllerCtrl:BindEvents()
	local l_mgr=MgrMgr:GetMgr("SceneObjControllerMgr")
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.SetProgressTimeEvent, self.setProgressTime)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.ControleSceneUIActiveStateEvent, self.showSceneUI,self)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param sceneObjInfo MoonClient.MSceneObjInfo
function SceneObjControllerCtrl:setProgressTime(sceneObjInfo)
    if sceneObjInfo.triggerId == -1 then --老的设计存在不设triggerID的情况必须比对对象来识别对应场景交互UI
        for k,v in pairs(self.sceneUIInfoDic) do
            if v~=nil then
                if v.sceneUIInfo == sceneObjInfo then
                    if MLuaCommonHelper.IsNull(v.template) then
                        logError("SceneObjControllerCtrl:setProgressTime template==null!")
                        return
                    end
                    v.template:SetProgressTime(sceneObjInfo.progressTime)
                    return
                end
            end
        end
        logError("SceneObjControllerCtrl:setProgressTime 未找到trigger!TriggerID:"..tostring(sceneObjInfo.triggerId))
        return
    end
    local l_tempSceneUIInfo = self.sceneUIInfoDic[sceneObjInfo.triggerId]
    if l_tempSceneUIInfo==nil or MLuaCommonHelper.IsNull(l_tempSceneUIInfo.template) then
        logError("SceneObjControllerCtrl:setProgressTime 未找到trigger!TriggerID:"..tostring(sceneObjInfo.triggerId))
        return
    end
    ---@type ParallelSceneUITemplateParameter
    l_tempSceneUIInfo.template:SetProgressTime(sceneObjInfo.progressTime)
end
function SceneObjControllerCtrl:showSceneUI(isShow,sceneUIInfo)
    if MLuaCommonHelper.IsNull(sceneUIInfo) then
        return
    end
    local l_localSceneUIInfo=self.sceneUIInfoDic[sceneUIInfo.triggerId]
    if isShow then
        if l_localSceneUIInfo~=nil then
            l_localSceneUIInfo.sceneUIInfo = sceneUIInfo
        else
            l_localSceneUIInfo=
            {
                sceneUIInfo = sceneUIInfo,
                template = nil,
            }
            self.sceneUIInfoDic[sceneUIInfo.triggerId]=l_localSceneUIInfo
        end
        if MLuaCommonHelper.IsNull(l_localSceneUIInfo.template) then
            l_localSceneUIInfo.template = self:getSceneUITemplate(sceneUIInfo)
        else
            l_localSceneUIInfo.template:SetData(sceneUIInfo)
        end
    else
        if l_localSceneUIInfo~=nil then
            l_localSceneUIInfo.sceneUIInfo=nil
            if not MLuaCommonHelper.IsNull(l_localSceneUIInfo.template) then
                self:UninitTemplate(l_localSceneUIInfo.template)
            end
            self.sceneUIInfoDic[sceneUIInfo.triggerId]=nil
        end
        self:tryToDeActiveSceneUI()
    end
end
function SceneObjControllerCtrl:getSceneUITemplate(sceneUIInfo)
    local l_prefabObj=self.panel.ParallelSceneUITemplate.gameObject
     local l_template=self:NewTemplate("ParallelSceneUITemplate",{
         TemplatePrefab = l_prefabObj,
         TemplateParent = l_prefabObj.transform.parent,
         Data ={
             sceneUIInfo = sceneUIInfo,
             fxId = self.BUTTON_FX_ID,
         },
     })
    return l_template
end
function SceneObjControllerCtrl:tryToDeActiveSceneUI()
    for k,v in pairs(self.sceneUIInfoDic) do
        if v~=nil then
            return
        end
    end
    UIMgr:DeActiveUI(UI.CtrlNames.SceneObjController)
end
function SceneObjControllerCtrl:clearSceneUIInfo()
    self.sceneUIInfoDic={}
end
function SceneObjControllerCtrl:updateSceneUIInfo()
    for k,v in pairs(self.sceneUIInfoDic) do
        if not MLuaCommonHelper.IsNull(v.template) then
            v.template:Update()
        end
    end
end
--lua custom scripts end
return SceneObjControllerCtrl