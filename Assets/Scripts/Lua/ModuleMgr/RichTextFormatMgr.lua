module("ModuleMgr.RichTextFormatMgr", package.seeall)



local string_format = StringEx.Format
local table_insert = table.insert
local string_gsub = string.gsub
-- 辅助格式化文本(将字符串中的<RichText=%d->的内容替换成对应的RichText,配置位于RichTextImageTable)
--[[比如
        "测试代码<RichText=1><RichText=2>"，返回内容为
        "测试代码<quad spname=UI_map_Battle_tower_1.png atname=map size=30 width=1.8 anim=false/><quad spname=UI_map_Battle_tower_2.png atname=map size=30 width=1.8 anim=false/>"
  ]]
function FormatRichTextContent(content)

    if not content then
        return ""
    end

    local l_matches = {}
    -- 捕获所有符合格式的字符串(-表示最短匹配)
    for id, k in string.gmatch(content, "<RichText=(%d-)>") do
        local l_id = tonumber(id)
        local l_row = TableUtil.GetRichTextImageTable().GetRowByID(l_id)
        if l_row then
            -- 文本内容和richtext内容一致
        	local l_content = GetImageText(l_row.spname, l_row.atname, l_row.size, l_row.width, l_row.anim)
        	table_insert(l_matches, {
        	    content = l_content,
        	    id = l_id,
        	})
        end
    end

    local l_marks = {}
    for i, v in ipairs(l_matches) do
        if not l_marks[v.id] then
            -- 文本替换
            content = string_gsub(content, string_format("<RichText={0}->", v.id), v.content)
        end
    end

    return content
end