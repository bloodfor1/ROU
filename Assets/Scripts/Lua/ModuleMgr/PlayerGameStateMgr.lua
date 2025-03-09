---@module ModuleMgr.PlayerGameStateMgr
module("ModuleMgr.PlayerGameStateMgr", package.seeall)

--显示玩家零收益信息
function ShowPlayerZeroProfitDlg()
    CommonUI.Dialog.ShowOKDlg(true, nil,
            Lang("IDIP_ZERO_EARNINGS_DES") .. '\n'..Lang("IDIP_ZERO_EARNINGS_TIME", Common.Functions.TimeSpanToString(MPlayerInfo.ZeroProfitTime - System.DateTime.Now)),
            nil, nil, nil, nil, function(ctrl)
        ctrl:AddCustomUpdateFuncs(function(c)
            c:SetText(Lang("IDIP_ZERO_EARNINGS_DES") .. '\n'.. Lang("IDIP_ZERO_EARNINGS_TIME", Common.Functions.TimeSpanToString(MPlayerInfo.ZeroProfitTime - System.DateTime.Now)))
        end)
    end)
end

function ShowRecoverPayDlgForKick(info, callback)
    local recoverInfo = {}
    recoverInfo.infos = info.recover_info
    recoverInfo.time = info.endtime
    ShowRecoverPayDlg(recoverInfo, callback)
end

function ShowRecoverPayDlg(recoverInfo, callback)
    local l_recoverInfos = recoverInfo.infos
    local l_time = MoonCommonLib.DateTimeEx.FromCppSecond2CsDateTime(recoverInfo.time)

    local l_reasonsText = ""
    for i=1,#l_recoverInfos do
        if i ~= 1 then
            l_reasonsText = l_reasonsText..", "
        end
        l_reasonsText = l_reasonsText..l_recoverInfos[i].reason
    end

    local l_coinText = ""
    for i=1,#l_recoverInfos do
        if i ~= 1 then
            l_coinText = l_coinText..", "
        end
        local l_coinName = TableUtil.GetItemTable().GetRowByItemID(l_recoverInfos[i].coin_type).ItemName
        l_coinText = l_coinText..l_recoverInfos[i].count..l_coinName
    end

    local l_dlgTxt = Lang("IDIP_RECOVER_ARREARS_DES", l_reasonsText, l_coinText).."\n"..Lang("IDIP_RECOVER_ARREARS_TIME", l_time)
    
    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true, nil, l_dlgTxt, 
        Lang("RECOVER_PAY"), Lang("I_KNOW"), 
        function()
            PayFine(callback)
        end, function()
            if callback ~= nil then
                callback()
            end
        end)
end

function PayFine(callback)
    local l_msgId = Network.Define.Rpc.PayFine
    ---@type PayFineArg
    local l_sendInfo = GetProtoBufSendTable("PayFineArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo, callback)
end

function OnPayFine(msg, arg, callback)
    ---@type PayFineRes
    local l_info = ParseProtoBufToTable("PayFineRes", msg)

    if l_info.error ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        return
    end

    CommonUI.Dialog.ShowOKDlg(true, nil, Lang("IDIP_RECOVER_ARREARS_INFORM"), nil)
end

function ShowPlayerBanInfo(baninfo, isRole, callback)
    local _getText = function(isRole)
        -- local timeStr = Common.TimeMgr.GetLeftTimeStrEx(baninfo.endtime - Common.TimeMgr.GetUtcTimeByTimeTable())
        local l_endtime = MoonCommonLib.DateTimeEx.FromCppSecond2CsDateTime(MLuaCommonHelper.Long(baninfo.endtime))
        local l_timeStr = Common.Functions.TimeSpanToString(l_endtime - System.DateTime.Now)
        local l_text = isRole and "ERR_ROLE_BAN" or "ERR_ACCOUNT_BAN"
        if g_Globals.IsKorea then
            l_text = StringEx.Format(Common.Utils.Lang(l_text), baninfo.reason, l_timeStr)
        else
            l_text = StringEx.Format(Common.Utils.Lang(l_text.."_KR"), l_timeStr)
        end

        return l_text
    end

    CommonUI.Dialog.ShowOKDlg(true, nil,
        _getText(isRole),
        callback, nil, nil, nil, 
        function(ctrl)
            ctrl:AddCustomUpdateFuncs(function(c)
                c:SetText(_getText(isRole))
            end)
        end
    )
end

return ModuleMgr.PlayerGameStateMgr