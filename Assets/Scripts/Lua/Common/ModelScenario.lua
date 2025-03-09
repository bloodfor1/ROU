module("UI", package.seeall)

require "ModuleMgr/CoroutineMgr"
require "Common/CoProcessor"
require "UI/Template/ScenarioBubbleTem"

ModelScenario = class("ModelScenario")

function ModelScenario:ctor(name)

end

function ModelScenario:Init(npcID,root)
    self.Row = TableUtil.GetNpcTable().GetRowById(npcID)
    self.CommandId = self.Row.NPCShowScript[0]
    self.CommandTag = self.Row.NPCShowScript[1]
    if (not self.Row) or string.ro_isEmpty(self.CommandTag) or string.ro_isEmpty(self.CommandId) then
        logError("不存在的剧本ID => {0}", npcID)
        return
    end
    self.Root = root
    self.Tem = UITemplate.ScenarioBubbleTem.new({
        TemplateParent=self.Root.transform,
    })

    self.Scenaraio = CommandBlock.CreateBlockWithLocation("CommandScript/NPC/"..tostring(self.CommandId));
    if self.Scenaraio ~= nil then
        self.Scenaraio:AddBlockConst("model", self)
        self.Scenaraio:StartBlock(self.CommandTag);
    else
        logError("不存在剧本", "CommandScript/NPC/"..tostring(self.CommandId))
    end
end

function ModelScenario:Uninit()
    if self.Scenaraio then
        self.Scenaraio:Quit()
        self.Scenaraio = nil
    end
    if self.Tem then
        self.Tem:Uninit()
        self.Tem = nil
    end
    self.Root = nil
end

---------------------------------------------
function ModelScenario:SetFontSize(size)
    self.Tem:SetFontSize(size)
end

function ModelScenario:SetPos(x,y)
    self.Tem:gameObject():SetRectTransformPos(x,y)
end

function ModelScenario:Emoji(emojiID,showTime)
    emojiID = emojiID and tonumber(emojiID) or 0
    showTime = showTime and tonumber(showTime) or 3
    self.Tem:Emoji(emojiID,showTime)
end

function ModelScenario:Chat(content,showTime)
    showTime = showTime and tonumber(showTime) or 3
    self.Tem:Chat(content,showTime)
end
