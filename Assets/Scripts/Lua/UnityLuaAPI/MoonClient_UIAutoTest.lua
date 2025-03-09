---@class MoonClient.UIAutoTest : UnityEngine.MonoBehaviour
---@field public clickInterval number
---@field public randomGroup System.Single[]

---@type MoonClient.UIAutoTest
MoonClient.UIAutoTest = { }
---@return MoonClient.UIAutoTest
function MoonClient.UIAutoTest.New() end
---@return MoonClient.UIAutoTest
function MoonClient.UIAutoTest.AddToGo() end
function MoonClient.UIAutoTest:InitAutoTransList() end
function MoonClient.UIAutoTest:StartAutoTest() end
function MoonClient.UIAutoTest:StartRandomAutoTest() end
function MoonClient.UIAutoTest:RandomAutoTest() end
---@return System.Collections.Generic.List_UnityEngine.UI.Button
function MoonClient.UIAutoTest:GetAllButton() end
function MoonClient.UIAutoTest:StopAutoTest() end
function MoonClient.UIAutoTest:StopRandomTest() end
function MoonClient.UIAutoTest:OnGUI() end
return MoonClient.UIAutoTest
