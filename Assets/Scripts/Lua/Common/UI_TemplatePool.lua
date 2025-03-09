---@module Common.UI_TemplatePool
module("Common.UI_TemplatePool", package.seeall)

---@return UI_TemplatePoolCommon
function new(templateInstantiateData)
    local l_temp = nil
    if not templateInstantiateData.ScrollRect then
        require "Common/UI_TemplatePoolCommon"
        l_temp = Common.UI_TemplatePool.UI_TemplatePoolCommon.new(templateInstantiateData)
    elseif not templateInstantiateData.GetTemplateAndPrefabMethod then
        require "Common/UI_TemplatePoolScrollRect"
        l_temp = Common.UI_TemplatePool.UI_TemplatePoolScrollRect.new(templateInstantiateData)
    else
        require "Common/UI_TemplatePoolMultipleTemplate"
        l_temp = Common.UI_TemplatePool.UI_TemplatePoolMultipleTemplate.new(templateInstantiateData)
    end
    return l_temp
end


