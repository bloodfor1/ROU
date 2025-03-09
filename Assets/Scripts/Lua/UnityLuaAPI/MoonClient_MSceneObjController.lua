---@class MoonClient.MSceneObjController : MoonCommonLib.MSingleton_MoonClient.MSceneObjController
---@field public nowSceneObjInfo MoonClient.MSceneObjInfo
---@field public IsForceShow boolean
---@field public IsPlaying boolean
---@field public TriggerID number

---@type MoonClient.MSceneObjController
MoonClient.MSceneObjController = { }
---@return MoonClient.MSceneObjController
function MoonClient.MSceneObjController.New() end
---@param sceneObjInfo MoonClient.MSceneObjInfo
---@param value number
function MoonClient.MSceneObjController:ProgressTime(sceneObjInfo, value) end
---@param clearAccountData boolean
function MoonClient.MSceneObjController:OnLogout(clearAccountData) end
function MoonClient.MSceneObjController:Uninit() end
---@return boolean
function MoonClient.MSceneObjController:Init() end
---@param objInfo MoonClient.MSceneObjInfo
function MoonClient.MSceneObjController:SetProgress(objInfo) end
---@param info MoonClient.MSceneObjInfo
---@param forceChange boolean
function MoonClient.MSceneObjController:ShowButton(info, forceChange) end
---@overload fun(triggerId:number): void
---@param info MoonClient.MSceneObjInfo
function MoonClient.MSceneObjController:HideButton(info) end
function MoonClient.MSceneObjController:OnClicked() end
---@param triggerID number
function MoonClient.MSceneObjController:OnClickedStandAloneSceneUI(triggerID) end
function MoonClient.MSceneObjController:UpdateVisible() end
---@param fDeltaT number
function MoonClient.MSceneObjController:Update(fDeltaT) end
return MoonClient.MSceneObjController
