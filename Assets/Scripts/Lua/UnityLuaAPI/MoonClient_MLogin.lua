---@class MoonClient.MLogin

---@type MoonClient.MLogin
MoonClient.MLogin = { }
function MoonClient.MLogin.ShowUserCenter() end
function MoonClient.MLogin.ShowAgreement() end
---@param jsondata string
function MoonClient.MLogin.SetLang(jsondata) end
function MoonClient.MLogin.GetUserInfo() end
---@param jsondata string
function MoonClient.MLogin.BindAccount(jsondata) end
---@param jsondata string
function MoonClient.MLogin.SetClientChannelCode(jsondata) end
---@param jsondata string
function MoonClient.MLogin.Login(jsondata) end
function MoonClient.MLogin.Logout() end
function MoonClient.MLogin.AutoLogin() end
---@return System.Object
function MoonClient.MLogin.IsLogin() end
---@param jsondata string
function MoonClient.MLogin.OpenURL(jsondata) end
---@param jsondata string
function MoonClient.MLogin.OpenFullScreenWebViewWithJson(jsondata) end
function MoonClient.MLogin.QryMyInfo() end
---@param jsondata string
function MoonClient.MLogin.ReportPrajna(jsondata) end
---@param jsondata string
function MoonClient.MLogin.ReportEvent(jsondata) end
---@param jsondata string
function MoonClient.MLogin.WXCreatGroup(jsondata) end
---@param jsondata string
function MoonClient.MLogin.WXJoinGroup(jsondata) end
---@param jsondata string
function MoonClient.MLogin.WXQueryGroupStatus(jsondata) end
---@param jsondata string
function MoonClient.MLogin.WXUnbindGroup(jsondata) end
---@param jsondata string
function MoonClient.MLogin.QQQueryGroupStatus(jsondata) end
---@param jsondata string
function MoonClient.MLogin.QQCreatGroup(jsondata) end
---@param jsondata string
function MoonClient.MLogin.QQRemindGuildLeader(jsondata) end
---@param jsondata string
function MoonClient.MLogin.QQQueryGroupInfo(jsondata) end
---@param jsondata string
function MoonClient.MLogin.QQJoinGroup(jsondata) end
---@param jsondata string
function MoonClient.MLogin.QQUnbindGroup(jsondata) end
---@return System.Object
function MoonClient.MLogin.GetLoginData() end
---@return System.Object
function MoonClient.MLogin.GetMyInfo() end
---@return System.Object
function MoonClient.MLogin.GetLoginType() end
---@return System.Object
function MoonClient.MLogin.GetChannelId() end
---@return System.Object
function MoonClient.MLogin.GetRegisterChannelId() end
return MoonClient.MLogin
