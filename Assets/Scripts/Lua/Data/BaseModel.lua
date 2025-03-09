---
--- Created by dieseldong.
--- DateTime: 2017/10/12 14:54
---

module("Data", package.seeall)

-- 数据模型的基类
BaseModel = class("BaseModel")

Data.onDataChange = "OnDataChange"
Data.onInput = "OnInput"

function BaseModel:ctor(name)
    self.name = name
end

-- 初始化
function BaseModel:Init() -- virtual
end

-- 销毁
function BaseModel:Uninit() -- virtual
end
