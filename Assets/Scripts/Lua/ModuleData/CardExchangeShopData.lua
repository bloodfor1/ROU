
module("ModuleData.CardExchangeShopData", package.seeall)

local _cardDestroyDisplayData=nil

function SetCardDestroyDisplayData(id)
    if _cardDestroyDisplayData == nil then
        _cardDestroyDisplayData={}
    end
    table.insert(_cardDestroyDisplayData,id)
end

function GetCardDestroyDisplayData()
    return _cardDestroyDisplayData
end

function ClearCardDestroyDisplayData()
    _cardDestroyDisplayData=nil
end

function Init()

end

function Logout()
    _cardDestroyDisplayData=nil
end

return ModuleData.CardExchangeShopData