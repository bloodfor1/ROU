---@class MoonClient.MSceneObjInfo
---@field public triggerId number
---@field public needOutline boolean
---@field public needButton boolean
---@field public needAddItem boolean
---@field public sceneObjTableType number
---@field public atlas string
---@field public icon string
---@field public sceneObj UnityEngine.GameObject
---@field public getContextTextCallback (fun():string)
---@field public getTitleTextCallback (fun():string)
---@field public getIconCallback (fun():string)
---@field public clickCallback (fun():void)
---@field public isInTriggerRange (fun():boolean)
---@field public cd number
---@field public progressTime number
---@field public objPosition UnityEngine.Vector3
---@field public addItemID number
---@field public collectType number
---@field public needCircleFx boolean
---@field public anchoredPosition UnityEngine.Vector3
---@field public scale number
---@field public isPlaying boolean
---@field public hasPlayedTime number
---@field public isStandAlone boolean

---@type MoonClient.MSceneObjInfo
MoonClient.MSceneObjInfo = { }
---@return MoonClient.MSceneObjInfo
function MoonClient.MSceneObjInfo.New() end
function MoonClient.MSceneObjInfo:Destory() end
function MoonClient.MSceneObjInfo:Get() end
function MoonClient.MSceneObjInfo:Release() end
function MoonClient.MSceneObjInfo:Reset() end
function MoonClient.MSceneObjInfo:OnClick() end
return MoonClient.MSceneObjInfo
