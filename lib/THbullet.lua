---@class th_bullet : th_object
th_bullet = Class("th_bullet", th_object)

---@alias th_bullet.type "scale"|"ring"|"circle"|"rice"|"sharp"|"prism"|"square"|"ammo"|"stripedBacteria"|"star"|"ghost"|"bacteria"|"point"
---@alias th_bullet.color "black"|"deepRed"|"red"|"purple"|"pink"|"deepBlue"|"blue"|"deepCyan"|"cyan"|"deepGreen"|"green"|"greenish-Yellow"|"deepYellow"|"yellow"|"golden"|"white"

---comment
---@param _type th_bullet.type
---@param color th_bullet.color
---@param cb_new? function
---@param cb_kill? function
---@param cb_delete? function
function th_bullet:initialize(_type, color, cb_new, cb_kill, cb_delete)
	th_object:initialize(function (obj)
		if cb_new then
			cb_new(obj)
		end
		if self.bulColor == "black" then
			obj.quad = "fog_black"
		elseif self.bulColor == "deepRed" or obj.bulColor == "red" then
			obj.quad = "fog_red"
		elseif self.bulColor == "purple" or obj.bulColor == "pink" then
			obj.quad = "fog_pink"
		elseif self.bulColor == "deepBlue" or obj.bulColor == "blue" then
			obj.quad = "fog_blue"
		elseif self.bulColor == "deepCyan" or obj.bulColor == "cyan" then
			obj.quad = "fog_cyan"
		elseif self.bulColor == "deepGreen" or obj.bulColor == "green" or obj.bulColor == "greenish-Yellow" then
			obj.quad = "fog_green"
		elseif self.bulColor == "deepYellow" or obj.bulColor == "yellow" or obj.bulColor == "golden" then
			obj.quad = "fog_yellow"
		elseif self.bulColor == "white" then
			obj.quad = "fog_white"
		end
		obj.layer = LAYER_ENEMY_BULET
		obj.ox = 16
		obj.oy = 16
		obj.sx = 2
		obj.sy = 2
		obj._a = 0
		task.New(function ()
			for i = 1, 10 do
				obj.sx = 2 - i * 0.1
				obj.sy = 2 - i * 0.1
				obj._a = i * 0.1
				coroutine.yield()
			end
			obj.ox = 8
			obj.oy = 8
			obj.quad = _type .. "_" .. color
		end)
	end, function (obj)
		if cb_kill then
			cb_kill(obj)
		end
		New(th_object, function (obj2)
			obj2.layer = LAYER_ENEMY_BULET - 9
			obj2.image = "etbreak"
			obj2.quadGroup = "etbreak"
			obj2.quad = 1
			obj2.x = obj.x
			obj2.y = obj.y
			obj2.ox = 32
			obj2.oy = 32
			obj2._a = 0.5
			obj2.sx = 0.7
			obj2.sy = 0.7
			if self.bulColor == "black" or self.bulColor == "white" then
				obj2._r = 1
				obj2._g = 1
				obj2._b = 1
			elseif self.bulColor == "deepRed" or self.bulColor == "red" then
				obj2._r = 240/255
				obj2._g = 50/255
				obj2._b = 50/255
			elseif self.bulColor == "purple" or self.bulColor == "pink" then
				obj2._r = 238/255
				obj2._g = 60/255
				obj2._b = 235/255
			elseif self.bulColor == "deepBlue" or self.bulColor == "blue" then
				obj2._r = 7/255
				obj2._g = 18/255
				obj2._b = 243/255
			elseif self.bulColor == "deepCyan" or self.bulColor == "cyan" then
				obj2._r = 45/255
				obj2._g = 1
				obj2._b = 1
			elseif self.bulColor == "deepGreen" or self.bulColor == "green" or self.bulColor == "greenish-Yellow" then
				obj2._r = 21/255
				obj2._g = 245/255
				obj2._b = 121/255
			elseif self.bulColor == "deepYellow" or self.bulColor == "yellow" or self.bulColor == "golden" then
				obj2._r = 247/255
				obj2._g = 247/255
				obj2._b = 72/255
			end
			task.New(function ()
				for i = 1, 8 do
					obj2.quad = i
					task._wait(2)
				end
				obj2:Delete()
			end)
		end)
	end, cb_delete)
	self.bulColor = color
	self.image = "bulletMap-1"
	self.quadGroup = "bulletMap-1"
	self.boundox = FRONT_X - 20
	self.boundoy = FRONT_Y - 20
	self.boundwidth = FRONT_WIDTH + 40
	self.boundheight = FRONT_HEIGHT + 40
end

function th_bullet:frame(dt)
	th_object.frame(self, dt)
	if player[1] then
		if CircleCheck(player[1], self.x, self.y, 7) then
			thlog("www")
		end
	end
end
