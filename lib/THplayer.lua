---@class th_player : th_object
th_player = Class("th_player", th_object)

---字符串是减号，值是下划线！！！
---@alias th_player.state "normal"|"left"|"right"|"turning-left"|"turning-right"

local players = {}

---@param name string
---@param cb_new? function
---@param cb_kill? function
---@param cb_delete? function
function th_player:initialize(name, cb_new, cb_kill, cb_delete)
	th_object:initialize(cb_new, cb_kill, cb_delete)
	self.layer = LAYER_PLAYER
	self.pName = name
	self.pQuadGroup = players[name].quadGroup
	self.pSpeedStr = math.sqrt(players[name].speed^2*2)
	self.pSpeedSla = players[name].speed
	self.pSpeedSlowStr = math.sqrt(players[name].speedSlow^2*2)
	self.pSpeedSlowSla = players[name].speedSlow
	self.cb_new = cb_new or players[name].new or function()end
	self.pcb_shot = players[name].shot or function()end
	self.pcb_bomb = players[name].bomb or function()end
	self.pcb_slow = players[name].slow or function()end
	self.pcb_dead = players[name].dead or function()end
	self.pcb_frame = players[name].frame or th_object.frame
	self.pcb_render = players[name].render or th_object.render
	self.pnQuadGroup = "normal"
	self.quad = 1
end

---定义自机
---此类（大概）仅提供动画功能
---@param name string 名称
---@param qgnormal string 正常时动画的切片组
---@param qgturning_left string 左转中动画的切片组
---@param qgturning_right string 右转中动画的切片组
---@param qgleft string 左转动画的切片组
---@param qgright string 右转动画的切片组
---@param speed number 速度
---@param speedslow number 慢速速度
---@param cb_new function 实例后的回调
---@param cb_shot function 当按下射击键时的回调（不提供调用）
---@param cb_bomb function 当按下炸弹键时的回调（不提供调用）
---@param cb_slow function 进入慢速时的回调（不提供调用）
---@param cb_dead function （玩家）死亡时的回调（不提供调用）
---@param cb_frame? function 帧回调
---@param cb_render? function 渲染回调
function DefinePlayer(name, qgnormal, qgturning_left, qgturning_right, qgleft, qgright, speed, speedslow, cb_new, cb_shot, cb_bomb, cb_slow, cb_dead, cb_frame, cb_render)
	players[name] = {}
	players[name].quadGroup = {}
	players[name].quadGroup.normal = qgnormal
	players[name].quadGroup.turning_left = qgturning_left
	players[name].quadGroup.turning_right = qgturning_right
	players[name].quadGroup.left = qgleft
	players[name].quadGroup.right = qgright
	players[name].speed = speed
	players[name].speedSlow = speedslow
	players[name].shot = cb_shot
	players[name].bomb = cb_bomb
	players[name].new = cb_new
	players[name].slow = cb_slow
	players[name].dead = cb_dead
	players[name].frame = cb_frame
	players[name].render = cb_render
end

---还是要注意，输入值的字符串单词中间是减号，调用的是下划线
---@param name th_player.state
function th_player:ChangeState(name)
	if name == "normal" then
		if self.pnQuadGroup == "normal" then
			if #quadGroup[self.pQuadGroup.normal] == self.quad then
				self.quad = 1
			else
				self.quad = self.quad + 1
			end
		else
			self.quad = 1
			self.pnQuadGroup = "normal"
		end
	elseif name == "turning-left" then
		if self.pnQuadGroup == "turning_left" then
			if #quadGroup[self.pQuadGroup.turning_left] == self.quad then
				self.quad = 1
				self.pnQuadGroup = "left"
			end
			self.quad = self.quad + 1
		else
			self.quad = 1
			self.pnQuadGroup = "turning_right"
		end
	elseif name == "turning-right" then
		if self.pnQuadGroup == "turning_right" then
			if #quadGroup[self.pQuadGroup.turning_right] == self.quad then
				self.quad = 1
				self.pnQuadGroup = "right"
			end
			self.quad = self.quad + 1
		else
			self.quad = 1
			self.pnQuadGroup = "turning_right"
		end
	elseif name == "left" then
		if self.pnQuadGroup == "left" then
			if #quadGroup[self.pQuadGroup.left] == self.quad then
				self.quad = 1
			else
				self.quad = self.quad + 1
			end
		else
			self.quad = 1
			self.pnQuadGroup = "left"
		end
	elseif name == "right" then
		if self.pnQuadGroup == "right" then
			if #quadGroup[self.pQuadGroup.right] == self.quad then
				self.quad = 1
			else
				self.quad = self.quad + 1
			end
		else
			self.quad = 1
			self.pnQuadGroup = "right"
		end
	end
end

function th_player:frame(dt)
	self:pcb_frame(dt)
	self.quadGroup = self.pQuadGroup[self.pnQuadGroup]
end
function th_player:render(srw, srh)
	self:pcb_render(srw, srh)
end
