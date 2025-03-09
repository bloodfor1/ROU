module("System", package.seeall)

Stack = class("Stack")

function Stack:ctor()

    self.stack = {}

    self.count = 0

end

function Stack:Push(data)

    table.insert(self.stack, data)
    self.count = self.count + 1

end

function Stack:Peek()

    if self.count == 0 then
        return nil
    end

    return self.stack[self.count]

end

function Stack:Pop()

    if self.count == 0 then
        return nil
    end

    local data = self.stack[self.count]

    table.remove(self.stack, self.count)

    self.count = self.count - 1

    return data

end

function Stack:IsContains(data)

    if self.count == 0 then
        return false
    end

    for i = self.count, 1, -1 do

        if self.stack[i] == data then
            return true
        end

    end

    return false

end

function Stack:Remove(data)

    if self.count == 0 then
        return
    end

    for i = self.count, 1, -1 do

        if self.stack[i] == data then
            table.remove(self.stack, i)
            self.count = self.count - 1
            break
        end

    end

end

function Stack:Clear()

    self.stack = {}

end

function Stack:GetCount()

    return self.count

end

function Stack:Iterator(index)

    if index <= 0 then
        return nil, nil
    end

    if index > self.count then
        return nil, nil
    end

    local l_stackIndex = self.count + 1 - index

    return index + 1, self.stack[l_stackIndex]

end