---@class th_object : object
local th_object = Class("th_object", object)

---comment
---@param cb_new? function
---@param cb_kill? function
---@param cb_delete? function
function th_object:initialize(cb_new, cb_kill, cb_delete)
	object:initialize()
	--- y轴坐标，在屏幕内可见的最大值为 `SCREEN_ORIGIN_WIDTH` 的值
	--- @type number
	self.x = 0.

	--- x轴坐标，在屏幕内可见的最大值为 `SCREEN_ORIGIN_HEIGHT` 的值
	--- @type number
	self.y = 0.

	--- 旋转（弧度制）
	--- @type number
	self.rot = 0.

	--- 碰撞类型
	--- @type integer?
	self.collision = COLLI_NONE

	--- 碰撞大小
	--- @type number
	self.collisionSize = 1.

	--- 碰撞组
	--- @type integer?
	self.collisionGroup = COLLI_GROUP_GHOST

	--- 图像（在 `image` 中的名字）
	--- @type string
	self.image = nil

	--- 切片（在 `quad` 中的名字）
	--- @type string
	self.quad = nil

	--- 切片组（在 `quadGroup` 中的名字）
	--- @type string
	self.quadGroup = nil

	--- 切片组的帧（在 `quadGroup[self.quadGeoup]` 中的名字）
	--- @type string|integer
	self.quadGroupFrame = 1

	--- 给 `self.isRotToV` 用的速度
	--- @type number
	self.v = 0.

	--- 根据角度求速度，会使 `self.vx` 与 `self.vy` 只读
	--- @type boolean
	self.isRotToV = false

	--- 如果 `self.isRotToV` 为 `true` 则受到 `self.v` 的影响
	--- @type number
	self.vx = 0.

	--- 如果 `self.isRotToV` 为 `true` 则受到 `self.v` 的影响
	--- @type number
	self.vy = 0.

	--- x轴缩放
	--- @type number
	self.sx = 1.

	--- y轴缩放
	--- @type number
	self.sy = 1.

	--- x轴原点，默认为左边
	--- @type number
	self.ox = 0.

	--- y轴原点，默认为上边
	--- @type number
	self.oy = 0.

	--- x轴剪切
	--- @type number
	self.kx = 0.

	--- y轴剪切
	--- @type number
	self.ky = 0.

	---出屏以后是否销毁（不是反弹！！！）
	---@type boolean
	self.bound = true

	self.boundox = 0
	self.boundoy = 0
	self.boundwidth = SCREEN_ORIGIN_WIDTH
	self.boundheight = SCREEN_ORIGIN_HEIGHT

	self.cb_new = cb_new or function()end
	self.cb_kill = cb_kill or function()end
	self.cb_delete = cb_delete or function()end
end

function th_object:render(srw, srh)
	love.graphics.setColor(self._r, self._g, self._b, self._a)
	if self.quad then
		if self.quadGroup then
			love.graphics.draw(image[self.image], quadGroup[self.quadGroup][self.quad], self.x*srw, self.y*srh, self.rot, self.sx*srw, self.sy*srh, self.ox, self.oy, self.kx*srw, self.ky*srh)
		else
			love.graphics.draw(image[self.image], quad[self.quad], self.x*srw, self.y*srh, self.rot, self.sx*srw, self.sy*srh, self.ox, self.oy, self.kx*srw, self.ky*srh)
		end
	elseif self.image then
		love.graphics.draw(image[self.image], self.x*srw, self.y*srh, self.rot, self.sx*srw, self.sy*srh, self.ox, self.oy, self.kx*srw, self.ky*srh)
	end
end

function th_object:frame(dt)
	if self.isActive then
		if self.vx ~= 0 then
			self.x = self.x + self.vx * dt
		end
		if self.vy ~= 0 then
			self.y = self.y + self.vy * dt
		end
		if self.isRotToV then
			self.vx = math.cos(self.rot) * self.v * dt
			self.vy = math.sin(self.rot) * self.v * dt
		end
		if self.bound and not BoxCheck(self, self.boundox, self.boundoy, self.boundwidth, self.boundheight) then
			self:Delete()
		end
	end
end

return th_object