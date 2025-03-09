module("ModuleMgr.RefineUnsealMgr", package.seeall)

--SelectEquip
function GetSelectEquips(data)
    local equips = {}
    for i = 1, #data do
        if MgrMgr:GetMgr("RefineTransferMgr").CheckCanUnseal(data[i]) then
            table.insert(equips,data[i])
        end
    end
    return equips
end

function GetNoneEquipText()
    return Lang("NOREFINEUNSEALERQUIP")
end
--SelectEquip