---@module ModuleMgr.CookingSingleMgr
module("ModuleMgr.CookingSingleMgr", package.seeall)

require "UI/UIConst"

CookingQTEType =
{
	NONE = 0,
	FIRE = 1,
	STIR = 2
}


CookingTiming = {
    NONE = 0,
    BEGIN = 1,
    QTE_BEGIN =2,
    QTE_SUCCESS = 3,
    QTE_FAILED = 4
}

CookingQTE = {
	UI.CtrlNames.CookingQTE_1,
	UI.CtrlNames.CookingQTE_1
}

qte = CookingQTEType.NONE
qteSuccess = false
cookingRepice = nil
cookingCount = 0
potGameobject = nil
selectTaskRecipe = nil
cookingEffect = nil
COOKING_EFFECT = "Effects/Prefabs/Scene/Fx_Scene_Nomal_ChuFangBaiYan_01"


function ResetData( ... )
	qte = CookingQTEType.NONE
	cookingRepice = nil
	cookingCount = 0
	qteSuccess = false
    PlayPotAnimation(false)
    ClearCookingEffect()
end

function ClearCookingEffect( ... )
    if cookingEffect ~= nil then
        MFxMgr:DestroyFx(cookingEffect)
        cookingEffect = nil
    end
end

function CookingEffect()
    ClearCookingEffect()
    if potGameobject ~= nil then
        local l_fxData = MFxMgr:GetDataFromPool()
        local l_pos = potGameobject.transform.position
        l_pos.y = l_pos.y + 0.3
        l_fxData.position = l_pos
        cookingEffect = MFxMgr:CreateFx(COOKING_EFFECT,l_fxData)
        MFxMgr:ReturnDataToPool(l_fxData)
    end
end

function RequsetSingleCookingStart(recipeid ,count)
    cookingCount = MLuaCommonHelper.Long2Int(count)
    cookingRepice = recipeid
    local l_msgId = Network.Define.Rpc.SingleCookingStart
    ---@type SingleCookingStartArg
    local l_sendInfo = GetProtoBufSendTable("SingleCookingStartArg")
    l_sendInfo.recipeid  = recipeid
    l_sendInfo.count = MLuaCommonHelper.Long2Int(count)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end


function OnSingleCookingStart( msg )
    ---@type SingleCookingStartRes
    local l_info = ParseProtoBufToTable("SingleCookingStartRes", msg)
    -- Common.Functions.DumpTable(l_info)
    if l_info.err == 0 then
    	if l_info.qte == nil then
    		qte = CookingQTEType.NONE
    	else
    		qte = l_info.qte
    	end
    	-- logGreen("qte:"..qte)
    	local l_ui = UIMgr:GetUI(UI.CtrlNames.CookingSingle)
    	if l_ui ~= nil then
    		l_ui:CookingStart()
    	end
        PlayPotAnimation(true)
        CookingEffect()

    else
        -- logGreen("error:"..l_info.err)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.err))
    end
end

function PlayPotAnimation( cooking )
    if potGameobject ~= nil then
        local anim = potGameobject:GetComponent("Animation")
        if anim ~= nil then
            local animPath = "state0"
            if cooking then
                animPath = "state1"
            end
            local clip = anim:GetClip(animPath)
            if clip ~= nil then
                anim.clip = clip
            end
            anim:Play()
        end
    end
end

function RequsetSingleCookingFinish(success)
	local l_msgId = Network.Define.Rpc.SingleCookingFinish
    ---@type SingleCookingFinishArg
    local l_sendInfo = GetProtoBufSendTable("SingleCookingFinishArg")
    logGreen("cookingRepice:"..cookingRepice..",cookingCount:"..cookingCount)
    l_sendInfo.recipeid  = cookingRepice
    l_sendInfo.count = cookingCount
    if qte == CookingQTEType.NONE then
    	l_sendInfo.qtesuccess = false
    	qteSuccess = false
    else
    	l_sendInfo.qtesuccess = success
    	qteSuccess = success
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnSingleCookingFinish( msg )
    ---@type SingleCookingFinishRes
    local l_info = ParseProtoBufToTable("SingleCookingFinishRes", msg)
    if l_info.err == 0 then
    	-- logGreen("烹饪成功:"..l_info.recipeid..",cooking:"..l_info.resultid..",count:"..l_info.resultcount)

        GlobalEventBus:Dispatch(EventConst.Names.OnSingleCooingComplete,l_info.recipeid)

    	local l_ui = UIMgr:GetUI(UI.CtrlNames.CookingSingle)
    	if l_ui ~= nil then
    		l_ui:CookingFinishSuccess(l_info.resultid,l_info.resultcount)
    	end
    else
        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.err))
    end
end

function ShowCookingSingleUI(luaType,pot)
    potGameobject = pot
    UIMgr:ActiveUI(UI.CtrlNames.CookingSingle)
end


function PlayAudioWithTiming(timing)

    if cookingRepice ~= nil then
        local l_recipeTableData = TableUtil.GetRecipeTable().GetRowByID(cookingRepice)
        if l_recipeTableData == nil then
            logError("repice :"..MgrMgr:GetMgr("CookingSingleMgr").cookingRepice.."not exists in RecipeTable !")
            return
        end
        local l_audioId = Common.Functions.VectorToTable(l_recipeTableData.AudioID)[timing]
        local l_audioEventTable = TableUtil.GetAudioCommonTable().GetRowById(l_audioId)
        if l_audioEventTable == nil then
            logError("audio event :"..l_audioId.."not exists in AudioCommonTable !")
            return
        end
        local l_audioPath ="BGM/"..l_audioEventTable.AudioBank.."/"..l_audioEventTable.AudioPath
        MAudioMgr:PlayBGM(l_audioPath)
    end

end

function ResumePlayBGM( ... )
    local l_audioPath = "BGM/"..TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).BGM
    MAudioMgr:PlayBGM(l_audioPath)
end