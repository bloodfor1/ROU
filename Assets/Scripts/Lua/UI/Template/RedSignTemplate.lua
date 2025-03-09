--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class RedSignTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedSignPrompt MoonClient.MLuaUICom
---@field PromptCountText MoonClient.MLuaUICom
---@field ImagePrompt MoonClient.MLuaUICom
---@field EmailPrompt MoonClient.MLuaUICom
---@field EffectPrompt MoonClient.MLuaUICom
---@field CountPrompt MoonClient.MLuaUICom

---@class RedSignTemplate : BaseUITemplate
---@field Parameter RedSignTemplateParameter

RedSignTemplate = class("RedSignTemplate", super)
--lua class define end
local eRedSignShowType =
{
    CommonRedSign = 1,
    CountRedSign = 2,
    EmailRedSign = 3,
    EffectRedSign = 4,
    ImageRedSign = 5,
}
RedSignTemplate.TemplatePath = "UI/Prefabs/RedSignPrefab"
--lua functions
function RedSignTemplate:Init()
	
	    super.Init(self)
	    self._redTableInfo = nil
	    --特效的id,有可能一次显示好几个特效
	    self.effectIds = {}
	    --当前显示的所有红点个数
	    self._currentShowRedCounts = {}
	    --所有红点的显示状态
	    self._allRedSignShowStatus = {}
	    --存储几个红点类型的gameObject
	    --1是普通红点图片
	    --2是带个数的红点
	    --3是邮件红点
	    --4是特效
        --5是图片
	    self._redSignGameObject = {}
	    self._redSignGameObject[1] = self:_getRedSignGameObjectWithShowType(1)
	    self._redSignGameObject[2] = self:_getRedSignGameObjectWithShowType(2)
	    self._redSignGameObject[3] = self:_getRedSignGameObjectWithShowType(3)
	    self._redSignGameObject[4] = self:_getRedSignGameObjectWithShowType(4)
        self._redSignGameObject[5] = self:_getRedSignGameObjectWithShowType(5)
	    for i = 1, self:transform().childCount do
	        self:transform():GetChild(i - 1).gameObject:SetActiveEx(false)
	    end
	
end --func end
--next--
function RedSignTemplate:OnDeActive()
	
	    self:_destroyEffect()
	
end --func end
--next--
function RedSignTemplate:OnSetData(data)
	
	
end --func end
--next--
function RedSignTemplate:OnDestroy()
	
	    self:_destroyEffect()
	    self._redTableInfo = nil
	    self._allRedSignShowStatus = nil
	
end --func end
--next--
function RedSignTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function RedSignTemplate:ctor(templateData)

    if templateData == nil then
        templateData = {}
    end
    super.ctor(self, templateData)

end

function RedSignTemplate:OnActive()

    if self._redTableInfo == nil then
        return
    end
    local currentRedCounts = {}
    table.ro_insertRange(currentRedCounts, self._currentShowRedCounts)
    self._currentShowRedCounts = {}
    self:ShowRedSign(self._redTableInfo, currentRedCounts)

end

function RedSignTemplate:ShowRedSign(redTableInfo, redCounts)

    self._redTableInfo = redTableInfo
    local l_rectTransform = self:transform()
    l_rectTransform.anchorMin = Vector2.New(0, 0)
    l_rectTransform.anchorMax = Vector2.New(1, 1)
    self._allRedSignShowStatus = {}
    local l_currentRedCount
    for i = 1, #redCounts do
        --取当前存储的红点个数，有可能当前的数量少于将要显示的数量
        l_currentRedCount = 0
        if #self._currentShowRedCounts >= i then
            l_currentRedCount = self._currentShowRedCounts[i]
        end
        self:_DealWithRedCount(redTableInfo, i, l_currentRedCount, redCounts[i])
    end
    --根据存储的红点显示状态，对红点做显示隐藏处理
    local l_isShow
    for i = 1, #self._redSignGameObject do
        l_isShow = self._allRedSignShowStatus[i]
        if l_isShow == nil then
            l_isShow = false
        end
        --如果是特效红点的话只处理隐藏，在特效显示流程会处理显示
        if i == eRedSignShowType.EffectRedSign then
            if l_isShow == false then
                self:_destroyEffect()
                self._redSignGameObject[i]:SetActiveEx(false)
            end
        else
            self._redSignGameObject[i]:SetActiveEx(l_isShow)
        end
    end
    self._currentShowRedCounts = redCounts

end

function RedSignTemplate:_DealWithRedCount(redTableInfo, index, currentRedCount, toBeDisplayedRedCount)

    --取当前红点的显示类型
    local l_showType = redTableInfo.ShowType
    if l_showType == nil then
        logError("红点ShowType取的数据有问题：id:" .. tostring(redTableInfo.ID))
        return
    end
    --类型是0的话不显示
    if l_showType == 0 then
        return
    end
    --此时类型配的不对
    if l_showType > 5 then
        logError("此类型暂时没有处理，ShowType:" .. tostring(l_showType))
        return
    end
	--当将要显示的红点个数为0时，隐藏相应的红点(默认为隐藏)
	if toBeDisplayedRedCount <= 0 then
		return
	end
	--设置此红点状态是显示的
	self:_setRedSignShowStatus(l_showType, true)

    --当红点数据一样时,无需变化
    if currentRedCount == toBeDisplayedRedCount then
        return
    end
	--两次都大于0,只有数量型红点会变化,其他都无需变化
	if currentRedCount > 0 then
		if l_showType ~= eRedSignShowType.CountRedSign then
			return
		end
	end
    local l_offset = redTableInfo.OffSet
    if l_offset == nil then
        logError("红点OffSet取的数据有问题：id:" .. tostring(redTableInfo.ID))
        return
    end
    local l_size = redTableInfo.Size
    if l_size == nil then
        logError("红点Size取的数据有问题：id:" .. tostring(redTableInfo.ID))
        return
    end
    local l_redSignGameObject = self._redSignGameObject[l_showType]
    --设置位置、偏移和大小
    self:_setAnchors(l_redSignGameObject.transform, l_offset[0])
    l_redSignGameObject:SetRectTransformPos(l_offset[1], l_offset[2])
    l_redSignGameObject:SetRectTransformSize(l_size[0], l_size[1])
    --如果类型是2，显示个数
    if l_showType == eRedSignShowType.CountRedSign then
        if toBeDisplayedRedCount >= 10 then
            self.Parameter.PromptCountText.LabText = "N"
        else
            self.Parameter.PromptCountText.LabText = tostring(toBeDisplayedRedCount)
        end
    elseif l_showType == eRedSignShowType.EmailRedSign then
        self.Parameter.EmailPrompt:PlayChildrenFx()
    elseif l_showType == eRedSignShowType.EffectRedSign then
        --类型是4显示特效
        local l_effectPath = redTableInfo.EffectPath
        if l_effectPath == nil then
            logError("红点EffectPath取的数据有问题：id:" .. tostring(redTableInfo.ID))
            return
        end
        local l_fxData = {}
        l_fxData.rawImage = self.Parameter.EffectPrompt.RawImg
        local l_effectId = self:CreateUIEffect(l_effectPath, l_fxData)
        table.insert(self.effectIds, l_effectId)
    elseif l_showType == eRedSignShowType.ImageRedSign then
        local l_effectPath = redTableInfo.EffectPath
        local l_luaCom = l_redSignGameObject:GetComponent("MLuaUICom")
        l_luaCom:SetRawTexAsync(l_effectPath)
    end

end

function RedSignTemplate:_setRedSignShowStatus(showType, isShow)
    self._allRedSignShowStatus[showType] = isShow
end

function RedSignTemplate:_getRedSignGameObjectWithShowType(showType)

    local l_redSignGameObject
    if showType == eRedSignShowType.CommonRedSign then
        l_redSignGameObject = self.Parameter.RedSignPrompt
    elseif showType == eRedSignShowType.CountRedSign then
        l_redSignGameObject = self.Parameter.CountPrompt
    elseif showType == eRedSignShowType.EmailRedSign then
        l_redSignGameObject = self.Parameter.EmailPrompt
    elseif showType == eRedSignShowType.EffectRedSign then
        l_redSignGameObject = self.Parameter.EffectPrompt
    elseif showType == eRedSignShowType.ImageRedSign then
        l_redSignGameObject = self.Parameter.ImagePrompt
    else
        --这个没有地方会用
        l_redSignGameObject = self.Parameter.LuaUIGroup
    end
    return l_redSignGameObject.gameObject

end

function RedSignTemplate:_destroyEffect()

    for i = 1, #self.effectIds do
        self:DestroyUIEffect(self.effectIds[i])
    end
    self.effectIds = {}

end

function RedSignTemplate:_setAnchors(transform, anchorsType)

    if anchorsType == 1 then
        transform.anchorMin = Vector2.New(0, 1)
        transform.anchorMax = Vector2.New(0, 1)
    elseif anchorsType == 2 then
        transform.anchorMin = Vector2.New(0.5, 1)
        transform.anchorMax = Vector2.New(0.5, 1)
    elseif anchorsType == 3 then
        transform.anchorMin = Vector2.New(1, 1)
        transform.anchorMax = Vector2.New(1, 1)
    elseif anchorsType == 4 then
        transform.anchorMin = Vector2.New(0, 0.5)
        transform.anchorMax = Vector2.New(0, 0.5)
    elseif anchorsType == 5 then
        transform.anchorMin = Vector2.New(0.5, 0.5)
        transform.anchorMax = Vector2.New(0.5, 0.5)
    elseif anchorsType == 6 then
        transform.anchorMin = Vector2.New(1, 0.5)
        transform.anchorMax = Vector2.New(1, 0.5)
    elseif anchorsType == 7 then
        transform.anchorMin = Vector2.New(0, 0)
        transform.anchorMax = Vector2.New(0, 0)
    elseif anchorsType == 8 then
        transform.anchorMin = Vector2.New(0.5, 0)
        transform.anchorMax = Vector2.New(0.5, 0)
    elseif anchorsType == 9 then
        transform.anchorMin = Vector2.New(1, 0)
        transform.anchorMax = Vector2.New(1, 0)
    end

end
--lua custom scripts end
return RedSignTemplate