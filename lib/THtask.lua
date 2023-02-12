---禁止实例
----@class task
--task = Class("task")
local task = {}

function task.getTaskQueueLeng()
	local l = 0
	for k, v in pairs(objectPool) do
		l=l+1
	end
	return l
end

---插入任务, name为空字符串或函数时返回自动寻找的键
---@param name string
---@param func function
---@return integer?
---@overload fun(name:function)
function task.New(name,func)
	if type(name) ~= "function" then
		if name ~= "" then
			taskQueue[name] = coroutine.create(func)
		else
			for k, v in pairs(taskQueue) do
				if v == nil then
					taskQueue[k] = coroutine.create(func)
					return k
				end
			end
			table.insert(taskQueue, coroutine.create(func))
			return taskQueue[task.getTaskQueueLeng()]
		end
	else
		for k, v in pairs(taskQueue) do
			if v == nil then
				taskQueue[k] = coroutine.create(name)
				return k
			end
		end
		table.insert(taskQueue, coroutine.create(name))
		return taskQueue[task.getTaskQueueLeng()]
	end
end

---运行或重启任务（这个有什么用吗？）
---@param name string | integer
---@param ... any
function task.Resume(name, ...)
	if taskQueue[name] ~= nil then
		coroutine.resume(taskQueue[name], ...)
	else
		therror("task - resume " .. "\"" .. name .. "\"" .. " 任务不存在")
	end
end

---以字符串形式返回任务的状态
---@param name string
function task.Status(name)
	if taskQueue[name] ~= nil then
		return coroutine.status(taskQueue[name])
	else
		therror("task - status " .. "\"" .. name .. "\"" .. " 任务不存在")
		return nil
	end
end

function task.Remove(name)
	if taskQueue[name] ~= nil then
		taskQueue[name] = nil
	else
		therror("task - remove " .. "\"" .. name .. "\"" .. " 任务不存在")
	end
end
local isPause = false

function task.frame()
	if not isPause then
		for k,v in pairs(taskQueue) do
			if coroutine.status(v) == "suspended" then
				coroutine.resume(v)
			elseif coroutine.status(v) == "dead" then
				if type(k) == "number" then
					table.remove(taskQueue, k)
				else
					taskQueue[k] = nil
				end
			end
		end
	end
end

---------------以下方法仅在task中使用---------------

---@param t integer
function task._wait(t)
	for i=1,t do
		coroutine.yield()
	end
end

---LuaSTG的移动
---@param self th_object
---@param x number
---@param y number
---@param t integer
---@param mode 1|2|3|4 1: 普通 | 2: 渐快 | 3: 渐慢 | 4: 渐快与渐慢
---@param isUI? boolean
function task:_moveTo(x, y, t, mode, isUI)
	local value_a = "x"
	local value_b = "y"
	if isUI then
		value_a = "ofx"
		value_b = "ofy"
	end
	local dx = x - self[value_a]
	local dy = y - self[value_b]
	local xs = self[value_a]
	local ys = self[value_b]
	if mode == 1 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			self[value_a] = xs + s * dx
			self[value_b] = ys + s * dy
			coroutine.yield()
		end
	elseif mode == 2 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			s = s * s
			self[value_a] = xs + s * dx
			self[value_b] = ys + s * dy
			coroutine.yield()
		end
	elseif mode == 3 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			s = s * 2 - s * s
			self[value_a] = xs + s * dx
			self[value_b] = ys + s * dy
			coroutine.yield()
		end
	elseif mode == 4 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			if s < 0.5 then
				s = s * s * 2
			else
				s = -2 * s * s + 4 * s - 1
			end
			self[value_a] = xs + s * dx
			self[value_b] = ys + s * dy
			coroutine.yield()
		end
	end
end

--遗留，极其脑残，以后可能会用
function task:_translate(sfunc, func, t, mode)
	local tab = sfunc()
	if mode == 1 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			func(s, tab)
			coroutine.yield()
		end
	elseif mode == 2 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			s = s * s
			func(s, tab)
			coroutine.yield()
		end
	elseif mode == 3 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			s = s * 2 - s * s
			func(s, tab)
			coroutine.yield()
		end
	elseif mode == 4 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			if s < 0.5 then
				s = s * s * 2
			else
				s = -2 * s * s + 4 * s - 1
			end
			func(s, tab)
			coroutine.yield()
		end
	end
end

---LuaSTG的移动EX
---@param self th_object
---@param x number
---@param y number
---@param t integer
---@param mode 1|2|3|4 1: 普通 | 2: 渐快 | 3: 渐慢 | 4: 渐快与渐慢
---@param isUI boolean
function task:_moveToEx(x, y, t, mode, isUI)
	local value_a = "x"
	local value_b = "y"
	if isUI then
		value_a = "ofx"
		value_b = "ofy"
	end
	local dx = x
	local dy = y
	local slast = 0
	if mode == 1 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			self[value_a] = self[value_a] + (s - slast) * dx
			self[value_b] = self[value_b] + (s - slast) * dy
			coroutine.yield()
			slast = s
		end
	elseif mode == 2 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			s = s * s
			self[value_a] = self[value_a] + (s - slast) * dx
			self[value_b] = self[value_b] + (s - slast) * dy
			coroutine.yield()
			slast = s
		end
	elseif mode == 3 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			s = s * 2 - s * s
			self[value_a] = self[value_a] + (s - slast) * dx
			self[value_b] = self[value_b] + (s - slast) * dy
			coroutine.yield()
			slast = s
		end
	elseif mode == 4 then
		for s = 1 / t, 1 + 0.5 / t, 1 / t do
			if s < 0.5 then
				s = s * s * 2
			else
				s = -2 * s * s + 4 * s - 1
			end
			self[value_a] = self[value_a] + (s - slast) * dx
			self[value_b] = self[value_b] + (s - slast) * dy
			coroutine.yield()
			slast = s
		end
	end
end

return task