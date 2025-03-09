---@class MoonClient.MScene : MoonCommonLib.MSingleton_MoonClient.MScene
---@field public SwitchSceneType number
---@field public SceneUID number
---@field public SceneID number
---@field public ServerSceneId number
---@field public SceneLine number
---@field public ToSceneID number
---@field public ActivedSceneName string
---@field public GameCamera MoonClient.MCamera
---@field public SceneEntered boolean
---@field public SceneServerReady boolean
---@field public IsPvp boolean
---@field public IsPvpPre boolean
---@field public IsWild boolean
---@field public OpenShakeFunc boolean
---@field public SceneData MoonClient.SceneTable.RowData
---@field public SceneLineDatas System.Collections.Generic.List_KKSG.SceneLineData
---@field public SceneLineCount number
---@field public SceneLoader MoonClient.MSceneLoader
---@field public LoadingLoader MoonClient.MLoadingLoader
---@field public SceneTransfer MoonClient.MSceneTransfer
---@field public IsWaitForServer boolean
---@field public EnvironmentMgr MoonClient.MSceneEnvoriment.MEnvironMgr
---@field public PeriodType number
---@field public WeatherType number
---@field public TimeMgr MoonClient.MSceneTimeMgr
---@field public IsPlayOtherBGM boolean

---@type MoonClient.MScene
MoonClient.MScene = { }
---@return MoonClient.MScene
function MoonClient.MScene.New() end
---@param listSceneLineData Google.Protobuf.Collections.RepeatedField_KKSG.SceneLineData
function MoonClient.MScene:UpdateSceneLineData(listSceneLineData) end
function MoonClient.MScene:MarkChangingLine() end
function MoonClient.MScene:ClearListSceneLine() end
---@return boolean
function MoonClient.MScene:Init() end
function MoonClient.MScene:Uninit() end
---@param fDeltaT number
function MoonClient.MScene:Update(fDeltaT) end
---@param fDeltaT number
function MoonClient.MScene:LateUpdate(fDeltaT) end
---@param transfer boolean
function MoonClient.MScene:OnLeaveScene(transfer) end
---@param sceneId number
---@param sceneLine number
---@param transfer boolean
---@param activedSceneIdx number
---@param sceneUid number
function MoonClient.MScene:OnSceneLoaded(sceneId, sceneLine, transfer, activedSceneIdx, sceneUid) end
---@param sceneId number
---@param toSceneLine number
---@param transfer boolean
function MoonClient.MScene:OnEnterScene(sceneId, toSceneLine, transfer) end
function MoonClient.MScene:BeforeLoadScene() end
function MoonClient.MScene:AfterLoadScene() end
function MoonClient.MScene:ResendDoEnterScene() end
function MoonClient.MScene:OnReceivedDoEnterScene() end
---@param toSceneID number
---@param activedIdx number
---@param toSceneLine number
---@param cameraFadeType number
function MoonClient.MScene:TransferScene(toSceneID, activedIdx, toSceneLine, cameraFadeType) end
---@param sceneID number
---@param activedIdx number
---@param toSceneLine number
---@param sceneUId number
function MoonClient.MScene:SwitchScene(sceneID, activedIdx, toSceneLine, sceneUId) end
---@param sceneNameIdx number
function MoonClient.MScene:SetActivedScene(sceneNameIdx) end
---@return number
function MoonClient.MScene:GetReviveIndex() end
function MoonClient.MScene:SetCameraRotAtRevive() end
---@return number
---@param toSceneId number
function MoonClient.MScene:IsThemeDungeon(toSceneId) end
---@return boolean
---@param id number
function MoonClient.MScene:IsLineCrowd(id) end
---@return boolean
---@param toSceneID number
function MoonClient.MScene:IsTransfer(toSceneID) end
return MoonClient.MScene
