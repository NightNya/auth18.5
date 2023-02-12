---@class object : class
local object = Class("object")

function object:initialize(cb_new, cb_kill, cb_delete)
    --- 是否使用（只读）
	--- @type boolean
	self.isUsing = true

	--- 是否启用 `self:frame()` 回调
	--- @type boolean
	self.isActive = true

	--- 是否启用 `self:render()` 回调
	--- @type boolean
	self.isRender = true

    --- 颜色 R（0 ~ 1 之间）
	--- @type number
	self._r = 1

	--- 颜色 G（0 ~ 1 之间）
	--- @type number
	self._g = 1

	--- 颜色 B（0 ~ 1 之间）
	--- @type number
	self._b = 1

	--- 颜色 A（0 ~ 1 之间）
	--- @type number
	self._a = 1

    --- 图层
	--- @type integer
	self.layer = LAYER_DEBUG

    self.cb_new = cb_new or function()end
    self.cb_kill = cb_kill or function()end
    self.cb_delete = cb_delete or function()end
    self.frame = function()end
    self.render = function()end
end

---删除对象
function object:Delete()
    if self.cb_delete then
        self:cb_delete()
    end
    self.isUsing = false
end

---杀死对象
function object:Kill()
    if self.cb_kill then
        self:cb_kill()
    end
    self:Delete()
end

function object.getObjectPoolLeng()
	local l = 0
	for k, v in pairs(objectPool) do
		l=l+1
	end
	return l
end

function object.getObjectsNumber()
	local t = 0
	for k, v in pairs(objectPool) do
		if v.isUsing then
			t=t+1
		end
	end
	return t
end

---实例化类到对象池
---@param class class 类
---@param ... any 参数
---@return integer key 实例所在的键
---@overload fun(class: class)
function New(class, ...)
	if class ~= task then
		for k, v in pairs(objectPool) do
			if v.isUsing == false then
				objectPool[k] = class:new(...)
				last = objectPool[k]
				if class == th_player then
					table.insert(player, last)
				end
				if last.cb_new then
					last:cb_new()
				end
				-- RDO: Replace Deleted Object
				thlog("(RDO) New Object, Key: " .. tostring(k))
				return k
			end
		end
		table.insert(objectPool, class:new(...))
		last = objectPool[th_object.getObjectPoolLeng()]
		if class == th_player then
			table.insert(player, last)
		end
		if last.cb_new then
			last:cb_new()
		end
		thlog("New Object, Key: " .. tostring(th_object.getObjectPoolLeng()))
		return th_object.getObjectPoolLeng()
	else
		therror("New - 实例化了错误的类")
	end
end

return object