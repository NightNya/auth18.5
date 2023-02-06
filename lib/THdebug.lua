---@class th_debug : class
th_debug = Class("th_debug")

local debugobj = nil

local function UpdateValue(key, name, value)
	debugobj.values[key] = name .. ": " .. tostring(value)
end

function th_debug:initialize()
	self.isUsing = true
	self.isRender = true
	self.isActive = true
	self.layer = 1
	self.debugMode = false
	---需要在 debug 界面显示的值的索引
	self.values = {}
	self.font = nil
	self.texts = {}
	self.cb_new = function ()
		--last.debugMode = true
		debugobj = self
	end
	task.New(function ()
		while true do
			if love.keyboard.isDown("f1") then
				if debugobj.debugMode then
					debugobj.debugMode = false
					task._wait(10)
				else
					debugobj.debugMode = true
					task._wait(10)
				end
			end
			coroutine.yield()
		end
	end)
end

function th_debug:render()
	if self.debugMode then
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(font.debug)
		love.graphics.print("Version: " .. GAME_VERSION, 0, 0)
		love.graphics.print("Love2D Version: " .. LOVE_VERSION_MAJOR .. "." .. LOVE_VERSION_MINOR .. "." .. LOVE_VERSION_REVISION, 0, 15)
		love.graphics.print("Game Mode: " .. gameMode, 0, 30)
		for k,v in pairs(self.values) do
			love.graphics.print(v, 0, GetWindowSize(true) - 15 * k - 1)
		end
		for k,v in pairs(self.texts) do
			if k <= 20 then
				love.graphics.printf(v,0,GetWindowSize(true) - 15 * k - 1, GetWindowSize(false),"right")
			else
				table.remove(self.texts, k)
			end
		end
	end
end

function th_debug:frame()
	UpdateValue(1, "FPS", love.timer.getFPS())
	UpdateValue(2, "Time", string.format("%.2f", love.timer.getTime()))
	UpdateValue(3, "Objects", th_object.getObjectsNumber())
	UpdateValue(4, "Tasks", #taskQueue)
	UpdateValue(5, "Player Action - Power", playerAction.power)
end


function thlog(text)
	if debugobj then
		table.insert(debugobj.texts, 1, {{1,1,1,1}, tostring(text)})
	end
end

function thwarning(text)
	if debugobj then
		table.insert(debugobj.texts, 1, {{1,1,0,1}, "Warning: " .. tostring(text)})
	end
end

function therror(text)
	if debugobj then
		table.insert(debugobj.texts, 1, {{1,0,0,1}, "Error: " .. tostring(text)})
	end
end
