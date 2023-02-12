---@class th_item : th_object
local th_item = Class("th_item", th_object)

---@alias th_item.type "power"|"point"|"paradox"|"lives"|"bomb"|"full"|"power_big"|"bomb_big"|"lives_big"|"small_point_0"|"small_point_1"|"small_point_2"

local item = {
	collect = 20,
	slowCollect = 30,
	line = FRONT_Y + 130,
	speed = 1.5,
	delete = 10,
	collectSpeed = 5,
	lineCollectSpeed = 12,
}

---comment
---@param _type th_item.type
---@param cb_new function
---@param cb_kill function
---@param cb_delete function
function th_item:initialize(_type, cb_new, cb_kill, cb_delete)
	th_object:initialize(cb_new, cb_kill, cb_delete)
	if _type == "power" or _type == "point" or _type == "small_point_0" or _type == "small_point_1" or _type == "small_point_2" then
		self.ox = 8
		self.oy = 8
	elseif _type == "lives" or _type == "bomb" or _type == "full" or _type == "power_big" or _type == "bomb_big" or _type == "lives_big" then
		self.ox = 16
		self.oy = 16
	end
	self.layer = LAYER_ITEM
	self.image = "item"
	self.quadGroup = "item"
	self.quad = _type
	self.type = _type
	self.isCollected = false
	self.lineCollect = false
end

---生成在矩形范围内掉落物，如果 `x == width` `y == height` 或不存在 `width` 与 `height` ，则只在 `x` 与 `y` 坐标上生成
---@param _type th_item.type
---@param num integer
---@param x number
---@param y number
---@param width? number
---@param height? number
function th_item.New(_type, num, x, y, width, height)
	for i = 1, num do
		New(th_item, _type, function (self)
			if x ~= width and y ~= height and width and height then
				self.x = math.random(x, width)
				self.y = math.random(y, height)
			else
				self.x = x
				self.y = y
			end
			self._a = 0
			task.New(function ()
				for j = 0, 10 do
					self._a = j*0.1
					coroutine.yield()
				end
			end)
		end)
	end
end

function th_item:frame()
	if self.isCollected then
		if th_object.CircleCheck(self, player[1].x, player[1].y, item.delete) then
			if self.type == "power" then
				playerAction.power = playerAction.power + 1
			elseif self.type == "point" then
				playerAction.point = playerAction.point + 1
			elseif self.type == "paradox" then
				playerAction.paradox = playerAction.paradox + 1
			elseif self.type == "lives" then
				playerAction.lives = playerAction.lives + 25
			elseif self.type == "bomb" then
				playerAction.bomb = playerAction.bomb + 25
			elseif self.type == "full" then
				playerAction.power = playerAction.bomb + 400
			elseif self.type == "power_big" then
			end
			self:Kill()
		else
			if self.lineCollect then
				self.x = math.cos(math.atan2(player[1].y-self.y, player[1].x-self.x)) * item.lineCollectSpeed + self.x
				self.y = math.sin(math.atan2(player[1].y-self.y, player[1].x-self.x)) * item.lineCollectSpeed + self.y
			else
				self.x = math.cos(math.atan2(player[1].y-self.y, player[1].x-self.x)) * item.collectSpeed + self.x
				self.y = math.sin(math.atan2(player[1].y-self.y, player[1].x-self.x)) * item.collectSpeed + self.y
			end
		end
	elseif player[1].y < item.line then
		self.isCollected = true
		self.lineCollect = true
	elseif player[1] and th_object.CircleCheck(self, player[1].x, player[1].y, item.collect) or playerAction.isSlow and th_object.CircleCheck(self, player[1].x, player[1].y, item.slowCollect) then
		self.isCollected = true
	elseif self.y < SCREEN_ORIGIN_HEIGHT then
		self.y = self.y + item.speed
	else
		self:Delete()
	end
end

return th_item