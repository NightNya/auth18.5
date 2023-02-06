LoadImage("pl00", "assets/player/reimu/pl00.png")
LoadImage("pl00b", "assets/player/reimu/pl00b.png")
LoadImage("pslow", "assets/player/eff_sloweffect.png")

NewQuadGroupBatch("pslow", "pslow", {
	{0,0,64,64,1}, {64,0,64,64,2}
})

NewQuadGroupBatch("pl00_normal", "pl00", {
    {0,0,32,48,1}, {32,0,32,48,2}, {64,0,32,48,3}, {96,0,32,48,4},
    {128,0,32,48,5}, {160,0,32,48,6}, {192,0,32,48,7}, {224,0,32,48,8}
})

NewQuadGroupBatch("pl00_turning-left", "pl00", {
    {0,48,32,48,1}, {32,48,32,48,2}, {64,48,32,48,3}, {96,48,32,48,4}
})

NewQuadGroupBatch("pl00_turning-right", "pl00", {
    {0,96,32,48,1}, {32,96,32,48,2}, {64,96,32,48,3}, {96,96,32,48,4}
})

NewQuadGroupBatch("pl00_left", "pl00", {
    {128,48,32,48,1}, {160,48,32,48,2}, {192,48,32,48,3}, {224,48,32,48,4}
})

NewQuadGroupBatch("pl00_right", "pl00", {
    {128,96,32,48,1}, {160,96,32,48,2}, {192,96,32,48,3}, {224,96,32,48,4}
})

NewQuadGroupBatch("pl00_bullet", "pl00", {
	{192,144,64,16,1}
})

DefinePlayer("reimu", "pl00_normal", "pl00_turning-left", "pl00_turning-right", "pl00_left", "pl00_right", 3.6, 2,
function(self) -- cb_new
    self.image = "pl00"
	self.ox = 16
	self.oy = 24
	self.x = FRONT_X + FRONT_WIDTH/2
	self.y = FRONT_HEIGHT - 20
	task.New(function ()
		while true do
			if love.keyboard.isDown("left") then
				if self.pnQuadGroup == "normal" or self.pnQuadGroup == "right" then
					self:ChangeState("turning-left")
				else
					self:ChangeState("left")
				end
			elseif love.keyboard.isDown("right") then
				if self.pnQuadGroup == "normal" or self.pnQuadGroup == "left" then
					self:ChangeState("turning-right")
				else
					self:ChangeState("right")
				end
			else
				self:ChangeState("normal")
			end
			task._wait(4)
		end
	end)
	task.New(function ()
		while true do
			if not (love.keyboard.isDown("up") and love.keyboard.isDown("down") and love.keyboard.isDown("left") and love.keyboard.isDown("right")) then -- 防止某些人四个键一起按然后自机跑到边缘鬼畜
				if love.keyboard.isDown("up") and love.keyboard.isDown("left") and not love.keyboard.isDown("down") and not love.keyboard.isDown("right") and self.x > FRONT_X + 10 and self.y > FRONT_Y + 25 then
					if not love.keyboard.isDown("lshift") then
						self.x = self.x - self.pSpeedSla
						self.y = self.y - self.pSpeedSla
					else
						self.x = self.x - self.pSpeedSlowSla
						self.y = self.y - self.pSpeedSlowSla
					end
				elseif love.keyboard.isDown("up") and love.keyboard.isDown("right") and not love.keyboard.isDown("down") and not love.keyboard.isDown("left") and self.x < FRONT_WIDTH + FRONT_X - 10 and self.y > FRONT_Y + 25 then
					if not love.keyboard.isDown("lshift") then
						self.x = self.x + self.pSpeedSla
						self.y = self.y - self.pSpeedSla
					else
						self.x = self.x + self.pSpeedSlowSla
						self.y = self.y - self.pSpeedSlowSla
					end
				elseif love.keyboard.isDown("down") and love.keyboard.isDown("left") and not love.keyboard.isDown("up") and not love.keyboard.isDown("right") and self.x > FRONT_X + 10 and self.y < FRONT_HEIGHT + FRONT_Y - 20 then
					if not love.keyboard.isDown("lshift") then
						self.x = self.x - self.pSpeedSla
						self.y = self.y + self.pSpeedSla
					else
						self.x = self.x - self.pSpeedSlowSla
						self.y = self.y + self.pSpeedSlowSla
					end
				elseif love.keyboard.isDown("down") and love.keyboard.isDown("right") and not love.keyboard.isDown("up") and not love.keyboard.isDown("left") and self.x < FRONT_WIDTH + FRONT_X - 10 and self.y < FRONT_HEIGHT + FRONT_Y - 20 then
					if not love.keyboard.isDown("lshift") then
						self.x = self.x + self.pSpeedSla
						self.y = self.y + self.pSpeedSla
					else
						self.x = self.x + self.pSpeedSlowSla
						self.y = self.y + self.pSpeedSlowSla
					end
				else
					if love.keyboard.isDown("up") and not love.keyboard.isDown("down") and self.y > FRONT_Y + 25 then
						if not love.keyboard.isDown("lshift") then
							self.y = self.y - self.pSpeedStr
						else
							self.y = self.y - self.pSpeedSlowStr
						end
					elseif love.keyboard.isDown("down") and not love.keyboard.isDown("up") and self.y < FRONT_HEIGHT + FRONT_Y - 20 then
						if not love.keyboard.isDown("lshift") then
							self.y = self.y + self.pSpeedStr
						else
							self.y = self.y + self.pSpeedSlowStr
						end
					end
					if love.keyboard.isDown("left") and not love.keyboard.isDown("right") and self.x > FRONT_X + 10 then
						if not love.keyboard.isDown("lshift") then
							self.x = self.x - self.pSpeedStr
						else
							self.x = self.x - self.pSpeedSlowStr
						end
					elseif love.keyboard.isDown("right") and not love.keyboard.isDown("left") and self.x < FRONT_WIDTH + FRONT_X - 10 then
						if not love.keyboard.isDown("lshift") then
							self.x = self.x + self.pSpeedStr
						else
							self.x = self.x + self.pSpeedSlowStr
						end
					end
				end
			end
			coroutine.yield()
		end
	end)
	task.New(function ()
		while true do
			if love.keyboard.isDown("z") then
				self:pcb_shot()
			end
			coroutine.yield()
		end
	end)
	task.New(function ()
		while true do
			if love.keyboard.isDown("x") then
				self:pcb_bomb()
				task._wait(200)
			end
			coroutine.yield()
		end
	end)
	task.New(function ()
		while true do
			if love.keyboard.isDown("lshift") then
				self:pcb_slow()
				playerAction.isSlow = true
				while love.keyboard.isDown("lshift") do
					coroutine.yield()
				end
				playerAction.isSlow = false
			end
			coroutine.yield()
		end
	end)
end, function(self) -- shot
	for i = 1, 2 do
		New(th_object, function(self2)
			self2.image = "pl00"
			self2.quadGroup = "pl00_bullet"
			self2.quad = 1
			self2.layer = LAYER_PLAYER_BULLET
			if i == 1 then
				self2.x = self.x + 10
			else
				self2.x = self.x - 10
			end
			self2.y = self.y + 15
			self2.ox = 32
			self2.oy = 8
			self2.rot = AngToRad(-90)
			self2._a = 0.3
			task.New(function()
				while self2.y > 0 do
					self2.y = self2.y - 35
					coroutine.yield()
				end
				self2:Delete()
			end)
		end)
	end
end, function(self) -- bomb
	thlog("bomb")
end, function(self) -- slow
	task.New(function ()
		for i=1, 2 do
			New(th_object, function (self2)
				self2.layer = LAYER_PLAYER - 1
				self2.image = "pslow"
				self2.quadGroup = "pslow"
				self2.quad = 1
				self2.x = self.x
				self2.y = self.y
				self2.ox = 32
				self2.oy = 32
				self2.sx = 1.4
				self2.sy = 1.4
				self2._a = 0
				local rotv
				if i == 1 then --判断是正方向还是反方向旋转
					rotv = 0.03
				else
					rotv = -0.03
				end
				task.New(function () -- 微小的缩放动画
					for j = 20, 1, -2 do
						if not love.keyboard.isDown("lshift") then
							break
						end
						self2.sx = 1 + j * 0.01
						self2.sy = 1 + j * 0.01
						coroutine.yield()
					end
				end)
				task.New(function () -- 渐显
					for j = 1, 10, 1 do
						if not love.keyboard.isDown("lshift") then
							break
						end
						self2._a = j * 0.1
						coroutine.yield()
					end
				end)
				task.New(function () -- 渐隐
					while love.keyboard.isDown("lshift") do
						coroutine.yield()
					end
					for j = 10, 1, -1 do
						if love.keyboard.isDown("lshift") then
							break
						end
						self2._a = j * 0.1
						coroutine.yield()
					end
					self2:Delete()
				end)
				task.New(function () -- 旋转
					while love.keyboard.isDown("lshift") do
						self2.x = self.x
						self2.y = self.y
						self2.rot = self2.rot + rotv
						coroutine.yield()
					end
					for j = 1, 10 do -- 还得等隐藏的那十帧
						self2.x = self.x
						self2.y = self.y
						self2.rot = self2.rot + rotv
						coroutine.yield()
					end
				end)
			end)
		end
	end)
end, function(self) -- dead
	thlog("dead")
end)
