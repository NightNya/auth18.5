ui = {}

LoadImage("board", "assets/ui/board.png")

LoadImage("title_logo", "assets/ui/logo.png")
LoadImage("title_circle", "assets/ui/titlecircle.png")
LoadImage("title_bg", "assets/ui/title_background.png")
LoadImage("title_option", "assets/ui/titleopt.png")
LoadImage("title_diffSele", "assets/ui/diffcultySelect.png")
LoadImage("title_diffculty", "assets/ui/diffculty.png")

LoadImage("game_front", "assets/ui/game_front.png")
LoadImage("game_logo", "assets/ui/logo2.png")

NewQuadGroupY("title_option", "title_option", 10)
NewQuadGroupX("title_diffculty", "title_diffculty", 5)

---comment
---@param ui_type "title"|"game"|"ending"|"staff"
function ui.DrawUI(ui_type)
	if ui_type == "title" then
		local opt = 1
		local room = "title"
		local isKeyDown = false
		New(th_ui, function (self)
			self.image = "title_logo"
			self.layer = LAYER_UI
			self.sx = 0.4
			self.sy = 0.4
			self.ofy = 310
			self.ofx = -100
			self._a = 0
			self.show = false
			task.New(function ()
				while true do
					if room == "title" and not self.show then
						task.New(function ()
							for i = 0, 100, 100/10 do
								self._a = i*0.01
								coroutine.yield()
							end
						end)
						task._moveToEx(self, 100, 0, 30, 3, true)
						self.show = true
					elseif room ~= "title" and self.show then
						self.show = false
						task.New(function ()
							for i = 100, 0, -100/10 do
								self._a = i*0.01
								coroutine.yield()
							end
						end)
						task._moveToEx(self, -100, 0, 30, 1, true)
						self.show = false
					end
					coroutine.yield()
				end
			end)
		end)
		New(th_ui, function (self)
			self.image = "title_bg"
			self.layer = LAYER_BACKGROUND
		end)
		--[[New(th_ui, function (self)
			self.image = "title_circle"
			self.layer = LAYER_UI + 1
			self.sx = 0.8
			self.sy = 0.8
			self.ox = 420
			self.oy = 420
			self.ofx = 800
			self.trot = 0
			task.New(function ()
				while true do
					if self.rot >= 360 then
						self.rot = 0
					end
					self.trot = self.trot + 5
					self.rot = self.trot*0.001
					coroutine.yield()
				end
			end)
			task.New(function ()
				task._moveTo(self, SCREEN_ORIGIN_WIDTH - 30, 150, 40, 3, true)
				while true do
					if love.keyboard.isDown("z") or love.keyboard.isDown("x") then
						if room == "title" then
							task._moveTo(self, SCREEN_ORIGIN_WIDTH - 30, 150, 40, 3, true)
						elseif room ~= "title" then
							task._moveTo(self, SCREEN_ORIGIN_WIDTH/2, SCREEN_ORIGIN_HEIGHT/2, 40, 3, true)
						end
					end
					coroutine.yield()
				end
			end)
		end)]]
		task.New(function ()
			while true do
				if room == "title" then
					if love.keyboard.isDown("up") and isKeyDown then
						if opt ~= 1 then
							if opt == 3 then
								if playerData.isCleared then
									opt = 2
								else
									opt = 1
								end
							else
								opt = opt - 1
							end
						else
							opt = 10
						end
						PlaySound("select")
						while love.keyboard.isDown("up") and isKeyDown do
							coroutine.yield()
						end
					end
					if love.keyboard.isDown("down") and isKeyDown then
						if opt ~= 10 then
							if opt == 1 then
								if playerData.isCleared then
									opt = 2
								else
									opt = 3
								end
							else
								opt = opt + 1
							end
						else
							opt = 1
						end
						PlaySound("select")
						while love.keyboard.isDown("down") and isKeyDown do
							coroutine.yield()
						end
					end
					if love.keyboard.isDown("x") and isKeyDown then
						if opt == 10 then
							love.event.quit()
						else
							opt = 10
						end
						PlaySound("cancel")
						while love.keyboard.isDown("x") and isKeyDown do
							coroutine.yield()
						end
					end
					if love.keyboard.isDown("z") and isKeyDown then
						if opt == 1 then
							room = "diffculty"
							opt = 2
						elseif opt == 10 then
							love.event.quit()
						end
						PlaySound("ok")
						task._wait(40)
					end
				elseif room == "diffculty" then
					if love.keyboard.isDown("left") and isKeyDown then
						if opt ~= 1 then
							opt = opt - 1
						else
							opt = 5
						end
						thlog(opt)
						PlaySound("select")
						while love.keyboard.isDown("left") and isKeyDown do
							coroutine.yield()
						end
					end
					if love.keyboard.isDown("right") and isKeyDown then
						if opt ~= 5 then
							opt = opt + 1
						else
							opt = 1
						end
						thlog(opt)
						PlaySound("select")
						while love.keyboard.isDown("right") and isKeyDown do
							coroutine.yield()
						end
					end
					if love.keyboard.isDown("x") and isKeyDown then
						room = "title"
						opt = 1
						PlaySound("cancel")
						while love.keyboard.isDown("x") and isKeyDown do
							coroutine.yield()
						end
					end
				end
				coroutine.yield()
			end
		end)
		for i = 1, 10 do
			New(th_ui, function (self)
				self.image = "title_option"
				self.quadGroup = "title_option"
				self.quad = i
				self.align = UI_ALIGN_CORNER_RIGHT_TOP
				self.layer = LAYER_UI
				self.ofx = -240 + 100
				self.ofy = 35*i
				self.sx = 0.8
				self.sy = 0.8
				self._a = 0
				self.opt = i
				self.show = false
				task.New(function ()
					while true do
						if self.show and room == "title" then
							if self.opt == 2 then
								if opt == 2 then
									if playerData.isCleared then
										self._a = 1
									end
								else
									if playerData.isCleared then
										self._a = 0.5
									end
								end
							else
								if opt == self.opt then
									self._a = 1
								else
									self._a = 0.5
								end
							end
						end
						coroutine.yield()
					end
				end)
				task.New(function ()
					while true do
						if room == "title" and not self.show then
							task._wait(1*self.opt)
							task.New(function ()
								if self.opt == 2 then
									if playerData.isCleared then
										if self.opt == opt then
											for j = 0, 100, 100/10 do
												self._a = j*0.01
												coroutine.yield()
											end
										else
											for j = 0, 50, 50/10 do
												self._a = j*0.01
												coroutine.yield()
											end
										end
									else
										for j = 0, 20, 20/10 do
											self._a = j*0.01
											coroutine.yield()
										end
									end
								else
									if self.opt == opt then
										for j = 0, 100, 100/10 do
											self._a = j*0.01
											coroutine.yield()
										end
									else
										for j = 0, 50, 50/10 do
											self._a = j*0.01
											coroutine.yield()
										end
									end
								end
							end)
							task._moveTo(self, self.ofx - 100, self.ofy, 30, 3, true)
							self.show = true
						elseif room ~= "title" and self.show then
							task._wait(1*self.opt)
							task.New(function ()
								if self.opt == 2 then
									if playerData.isCleared then
										if self.opt == opt then
											for j = 100, 0, -100/10 do
												self._a = j*0.01
												coroutine.yield()
											end
										else
											for j = 50, 0, -50/10 do
												self._a = j*0.01
												coroutine.yield()
											end
										end
									else
										for j = 20, 0, -20/10 do
											self._a = j*0.01
											coroutine.yield()
										end
									end
								else
									if self.opt == opt then
										for j = 100, 0, -100/10 do
											self._a = j*0.01
											coroutine.yield()
										end
									else
										for j = 50, 0, -50/10 do
											self._a = j*0.01
											coroutine.yield()
										end
									end
								end
							end)
							task._moveTo(self, self.ofx + 100, self.ofy, 30, 1, true)
							self.show = false
						end
						coroutine.yield()
					end
				end)
			end)
			task.New(function ()
				task._wait(31)
				isKeyDown = true
			end)
		end
		New(th_ui, function (self)
			self.image = "board"
			self.align = UI_ALIGN_CORNER_RIGHT_TOP
			self.layer = LAYER_UI + 1
			self.ofx = -240 + 5
			self.ofy = 53 * opt
			self._r = 0
			self._g = 0
			self._b = 0
			self._a = 0.3
			self.sx = 13
			self.sy = 2
			self.show = false
			task.New(function ()
				while true do
					if room == "title" and not self.show then
						for i = 0, 30, 30/10 do
							self._a = i*0.01
							coroutine.yield()
						end
						self.show = true
					elseif room ~= "title" and self.show then
						for i = 30, 0, -30/10 do
							self._a = i*0.01
							coroutine.yield()
						end
						self.show = false
					end
					coroutine.yield()
				end
			end)
			task.New(function ()
				local topt
				while true do
					if room == "title" and (love.keyboard.isDown("up") or love.keyboard.isDown("down") or love.keyboard.isDown("x")) and topt ~= opt and isKeyDown then
						if opt == 1 then
							self.ofy = 53
						elseif opt == 2 then
							self.ofy = 87
						elseif opt == 3 then
							self.ofy = 120
						elseif opt == 4 then
							self.ofy = 154
						elseif opt == 5 then
							self.ofy = 187
						elseif opt == 6 then
							self.ofy = 220
						elseif opt == 7 then
							self.ofy = 251
						elseif opt == 8 then
							self.ofy = 286
						elseif opt == 9 then
							self.ofy = 317
						elseif opt == 10 then
							self.ofy = 350
						end
						topt = opt
						for i = 0, 13, 13/15 do
							if opt ~= topt then
								break
							end
							self.sx = i
							coroutine.yield()
						end
					end
					coroutine.yield()
				end
			end)
		end)
		New(th_ui, function (self)
			self.image = "board"
			self.sx = 64
			self.sy = 36
			self._r = 0
			self._g = 0
			self._b = 0
			self._a = 0
			self.show = false
			task.New(function ()
				while true do
					if room ~= "title" and not self.show then
						for i = 0, 50, 50/20 do
							self._a = i*0.01
							coroutine.yield()
						end
						self.show = true
					elseif room == "title" and self.show then
						for i = 50, 0, -50/20 do
							self._a = i*0.01
							coroutine.yield()
						end
						self.show = false
					end
					coroutine.yield()
				end
			end)
		end)
		New(th_ui, function (self)
			self.image = "title_diffSele"
			self.ofx = 20
			self._a = 0
			self.show = false
			task.New(function ()
				while true do
					if room == "diffculty" and not self.show then
						for i = 0, 100, 100/30 do
							self._a = i*0.01
							coroutine.yield()
							--thlog(self._a)
						end
						self.show = true
					elseif room ~= "diffculty" and self.show then
						for i = 100, 0, -100/20 do
							self._a = i*0.01
							coroutine.yield()
							--thlog(self._a)
						end
						self.show = false
					end
					coroutine.yield()
				end
			end)
		end)
		for i = 1, 5 do
			New(th_ui, function (self)
				self.image = "title_diffculty"
				self.quadGroup = "title_diffculty"
				self.align = UI_ALIGN_CENTER
				self.quad = i
				self.opt = i
				self._a = 0
				self.show = false
				self.move = false
				self.sx = 0.35
				self.sy = 0.35
				self.ox = 570
				self.oy = 270
				self.posx = 0
				self.posy = 0
				task.New(function ()
					while true do
						if room == "diffculty" and not self.show then
							for j = 0, 100, 100/30 do
								self._a = j*0.01
								coroutine.yield()
							end
							self.show = true
						elseif room ~= "diffculty" and self.show then
							for j = 100, 0, -100/20 do
								self._a = j*0.01
								coroutine.yield()
							end
							self.show = false
						end
						coroutine.yield()
					end
				end)
				--[[task.New(function ()
					while true do
						if room == "diffculty" and self.show and (love.keyboard.isDown("left") or love.keyboard.isDown("right")) and not self.move then
							self.move = true
							if opt == self.opt then
								self.posx = 0
							else
								if opt > self.opt then
									self.posx = 50 * opt - self.opt
								elseif opt < self.opt then
									self.posx = 50 * self.opt
								end
							end
							task.New(function ()
								local xs = self.ofx
								local ys = self.ofy
								local dx = self.posx - self.ofx
								local dy = self.posy - self.ofy
								for s = 1 / 60, 1 + 0.5 / 60, 1 / 60 do
									if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
										self.move = false
										break
									end
									s = s * 2 - s * s
									self.ofx = xs + s * dx
									self.ofy = ys + s * dy
									coroutine.yield()
								end
								self.move = false
							end)
						end
						coroutine.yield()
					end
				end)]]
			end)
		end
	elseif ui_type == "game" then
		task.New(function ()
			New(th_ui, function (self) self.image = "game_front" self.layer = LAYER_UI + 1 end)
			New(th_ui, function (self)
				self.image = "game_logo"
				self.layer = LAYER_UI
				self.sx = 0.56
				self.sy = 0.56
				self.ofx = -60
				self.ofy = 10
				self._a = 0
				task.New(function ()
					task._moveToEx(self, 60, 0, 70, 1, true)
				end)
				task.New(function ()
					for i = 0, 100, 2 do
						self._a = i*0.01
						coroutine.yield()
					end
				end)
			end)
			New(th_text, "Highest Score\n" .. tostring(playerData.highestScore) .. "\nScore\n" .. tostring(playerAction.score), "twcen_ui", nil, nil, false, function (self)
				self.align = UI_ALIGN_CORNER_RIGHT_TOP
				self.ofx = -270
				self.ofy = 30
				self.layer = LAYER_UI
				self.frame = function (dt)
					th_ui.frame(dt)
					self.text = "Highest Score\n" .. tostring(playerData.highestScore) .. "\nScore\n" .. tostring(playerAction.score)
				end
			end)
		end)
	end
end
