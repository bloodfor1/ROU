
--通用对象池--

ObjectPool = class("ObjectPool")

local pool = {}

function ObjectPool:ctor(onCreate, onGet, onReturn)

    self.onCreate = onCreate
    self.onGet = onGet
    self.onReturn = onReturn
    
end