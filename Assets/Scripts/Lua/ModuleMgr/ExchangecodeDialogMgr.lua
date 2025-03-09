--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.ExchangecodeDialogMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

CDKEY_EXCHANGE_SUCCESS = "ExchangecodeDialogMgr.CDKEY_EXCHANGE_SUCCESS"
--lua model end

--lua custom scripts

function OnCDKeyExchangeRes(msg)
    ---@type ExchangeCDKeyRes
    local l_resInfo = ParseProtoBufToTable("ExchangeCDKeyRes", msg)
    if l_resInfo.result ~= ErrorCode.ERR_SUCCESS then            --如果成功会推PTC,这里不处理成功情况
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_errorCode)
    end
end

--lua custom scripts end
return ModuleMgr.ExchangecodeDialogMgr