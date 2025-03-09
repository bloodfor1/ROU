---@class MoonClient.MCookingMgr : MoonCommonLib.MSingleton_MoonClient.MCookingMgr
---@field public IsPlaying boolean
---@field public RemainTime number
---@field public TableRow MoonClient.CookLevelTable.RowData
---@field public PlayerCurrentObj MoonClient.MCookingObj
---@field public FinishCount number
---@field public FinishScore number
---@field public FailedCount number

---@type MoonClient.MCookingMgr
MoonClient.MCookingMgr = { }
---@return MoonClient.MCookingMgr
function MoonClient.MCookingMgr.New() end
---@return System.Collections.Generic.List_MoonClient.MCookingMenu
function MoonClient.MCookingMgr:GetMenus() end
---@return boolean
function MoonClient.MCookingMgr:Init() end
function MoonClient.MCookingMgr:Uninit() end
---@return MoonClient.MCookingObj
---@param uid uint64
function MoonClient.MCookingMgr:GetCookingObj(uid) end
---@return MoonClient.MCookingObj
---@param trigger MoonClient.MSceneTriggerHUD
function MoonClient.MCookingMgr:AddTrigger(trigger) end
---@param uid uint64
---@param itemId number
---@param state number
---@param remainTime number
---@param entityUID uint64
function MoonClient.MCookingMgr:UpdateTrigger(uid, itemId, state, remainTime, entityUID) end
---@param uid uint64
---@param foodIds System.Int32[]
---@param state number
function MoonClient.MCookingMgr:UpdatePot(uid, foodIds, state) end
---@param score number
---@param num number
function MoonClient.MCookingMgr:UpdateFinishedInfo(score, num) end
---@param levelId number
---@param remainTime number
---@param finishedCount number
---@param failedCount number
---@param finishedScore number
function MoonClient.MCookingMgr:Start(levelId, remainTime, finishedCount, failedCount, finishedScore) end
---@param finishCount number
---@param finishScore number
---@param failedCount number
function MoonClient.MCookingMgr:End(finishCount, finishScore, failedCount) end
---@param clearAccountData boolean
function MoonClient.MCookingMgr:OnLogout(clearAccountData) end
function MoonClient.MCookingMgr:Reset() end
---@param menuId number
---@param uid uint64
---@param remainTime number
function MoonClient.MCookingMgr:AddMenu(menuId, uid, remainTime) end
---@param uid uint64
function MoonClient.MCookingMgr:RemoveMenu(uid) end
---@return boolean
---@param foods System.Collections.Generic.List_System.Int32
function MoonClient.MCookingMgr:InMenu(foods) end
---@param fDelta number
function MoonClient.MCookingMgr:Update(fDelta) end
---@param fDelta number
function MoonClient.MCookingMgr:LateUpdate(fDelta) end
---@param extraTime number
function MoonClient.MCookingMgr:AddExtraTime(extraTime) end
return MoonClient.MCookingMgr
