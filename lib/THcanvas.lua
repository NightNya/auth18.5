---@class th_canvas : th_object
local th_canvas = Class("th_canvas", th_object)

---@param canw number 画布长
---@param canh number 画布高
---@param renderother function 在渲染完画布对象池后额外的渲染函数
---@param cb_new? function
---@param cb_kill? function
---@param cb_delete? function
function th_canvas:initialize(canw, canh, renderother, cb_new, cb_kill, cb_delete)
	th_object:initialize(cb_new, cb_kill, cb_delete)
	self.canvas = love.graphics.newCanvas(canw, canh)
	self.clear = false
	self.objectPool = {}
	self.last = nil
	self.cb_render_canvas_other = renderother or function()end -- 谁取的b名字啊
end

function th_canvas:getObjectPoolLeng()
	local l = 0
	for k, v in pairs(self.objectPool) do
		l=l+1
	end
	return l
end

---实例化类到背景的对象池（与 `th_object` 类的 `New` 函数相同）
---@param class class 类
---@param ... any 参数
---@return integer key 实例所在的键
---@overload fun(class: class)
function th_canvas:New(class, ...)
	if class ~= task then
		for k, v in pairs(self.objectPool) do
			if v.isUsing == false then
				self.objectPool[k] = class:new(...)
				self.last = self.objectPool[k]
				if self.last.cb_new then
					self.last:cb_new()
				end
				-- RDO: Replace Deleted Object
				thlog("th_canvas - (RDO) New Object, Key: " .. tostring(k))
				return k
			end
		end
		table.insert(self.objectPool, class:new(...))
		self.last = self.objectPool[self:getObjectPoolLeng()]
		if self.last.cb_new then
			self.last:cb_new()
		end
		thlog("th_canvas - New Object, Key: " .. tostring(self:getObjectPoolLeng()))
		return self:getObjectPoolLeng()
	else
		therror("th_canvas - New - 实例化了错误的类")
	end
end

function th_canvas:render_canvas()
	self.canvas:renderTo(function ()
		if self.clear then
			love.graphics.clear()
		end
		for i = 90, 1, -1 do
			for k, obj in pairs(self.objectPool) do
				if obj.layer == i and obj.render and obj.isRender and obj.isUsing then
					obj:render(screenRatioWidth, screenRatioHeight)
				end
			end
		end
		self.cb_render_canvas_other()
	end)
end


function th_canvas:render(srw, srh)
	love.graphics.draw(self.canvas, self.x*srw, self.y*srh, self.rot, self.sx*srw, self.sy*srh, self.ox, self.oy, self.kx*srw, self.ky*srh)
end

return th_canvas