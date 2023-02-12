GAME_VERSION = "18.5-0.12-23.2.4"
LOVE_VERSION_MAJOR, LOVE_VERSION_MINOR, LOVE_VERSION_REVISION = love.getVersion()

GAME_MODE_DEBUG = "Debug"
GAME_MODE_CHEAT = "Cheat"
GAME_MODE_NORMAL = "Normal"

gameMode = GAME_MODE_DEBUG
image = {}
vertex = {}
quad = {}
quadGroup = {}
sound = {}
music = {}
font = {}
data = {}
stage = {}
spellCard = {}
diffculty = {}

objectPool = {}
last = nil
player = {}

playerData = {
	name = nil,
	highestScore = 0,
	finishedDiffculty = {},
	finishedSpellCard = {},
	listenedMusic = {},
	isCleared = false
}

playerAction = {
	stage = nil,
	diffculty = nil,
	character = nil,
	score = 0,
	lives = 0,
	bomb = 0,
	power = 0,
	point = 0,
	paradox = 0,
	boss = nil,
	spellCard = nil,
	isSlow = false -- item 所需，仅定义
}

taskQueue = {}

LAYER_DEBUG = 10
LAYER_UI = 20
LAYER_ENEMY_BULET = 30
LAYER_ITEM = 40
LAYER_PLAYER = 50
LAYER_PLAYER_BULLET = 60
LAYER_ENEMY = 70
LAYER_BACKGROUND = 80

COLLI_NONE = 0
COLLI_CIRCLE = 1
COLLI_SQUARE = 2

COLLI_GROUP_GHOST = 1
COLLI_GROUP_ENEMY_BULLET = 2
COLLI_GROUP_ENEMY = 3
COLLI_GROUP_PLAYER_BULLET = 4
COLLI_GROUP_INDES = 5
COLLI_GROUP_ITEM = 6
COLLI_GROUP_NONJIT = 7
COLLI_GROUP_SPELL = 8
COLLI_GROUP_CPLAYER = 9
COLLI_GROUP_ALL = 10

---@param a boolean `true` 为高，`false` 为长
---@return number
function GetWindowSize(a)
	if a then
		local windowWidth, windowHeight, windowFlags = love.window.getMode()
		return windowHeight
	else
		local windowWidth, windowHeight, windowFlags = love.window.getMode()
		return windowWidth
	end
end

---角度制转弧度制
---@param ang number
---@return number
function AngToRad(ang)
	return ang * math.pi / 180
end

--- 屏幕坐标横向的最大值，可以作为图片素材的基准大小（如果屏幕大小与其不一样则会按比例缩放，对象原坐标不变）
SCREEN_ORIGIN_WIDTH = 1024
--- 屏幕坐标纵向的最大值，可以作为图片素材的基准大小（如果屏幕大小与其不一样则会按比例缩放，对象原坐标不变）
SCREEN_ORIGIN_HEIGHT = 576

--- 窗口大小与屏幕坐标最大值（图片素材基准大小）的比，可以用于在渲染时与坐标和大小等相乘以占满屏幕
ScreenRatio = {
	_1024x576_WIDTH = 1024/SCREEN_ORIGIN_WIDTH,
	_1024x576_HEIGHT = 576/SCREEN_ORIGIN_HEIGHT,
	_1280x720_WIDTH = 1280/SCREEN_ORIGIN_WIDTH,
	_1280x720_HEIGHT = 720/SCREEN_ORIGIN_HEIGHT,
	_1366x768_WIDTH = 1366/SCREEN_ORIGIN_WIDTH,
	_1366x768_HEIGHT = 768/SCREEN_ORIGIN_HEIGHT,
	_1600x900_WIDTH = 1600/SCREEN_ORIGIN_WIDTH,
	_1600x900_HEIGHT = 900/SCREEN_ORIGIN_HEIGHT,
	_1920x1080_WIDTH = 1920/SCREEN_ORIGIN_WIDTH,
	_1920x1080_HEIGHT = 1080/SCREEN_ORIGIN_HEIGHT,
	_2560x1440_WIDTH = 2560/SCREEN_ORIGIN_WIDTH,
	_2560x1440_HEIGHT = 1440/SCREEN_ORIGIN_HEIGHT,
	ADAPTIVE_WIDTH = GetWindowSize(false)/SCREEN_ORIGIN_WIDTH,
	ADAPTIVE_HEIGHT = GetWindowSize(true)/SCREEN_ORIGIN_HEIGHT
	--自适应
}

screenRatioWidth = ScreenRatio.ADAPTIVE_WIDTH
screenRatioHeight = ScreenRatio.ADAPTIVE_HEIGHT
FRONT_X = 282
FRONT_Y = 20
FRONT_WIDTH = 460
FRONT_HEIGHT = 536
--游戏时的外框

--暂时弃用
--require "lib.thes"

Class = require "lib.middleclass"
th_data = require "lib.THdata"
task = require "lib.THtask"
th_object = require "lib.THobject"
th_debug = require "lib.THdebug"
th_image = require "lib.THimage"
th_ui = require "lib.THui"
th_text =  require "lib.THtext"
th = require "lib.THgame"
--[[require "lib.THquad_group"
require "lib.THaudio"
require "lib.THui"
require "lib.THbullet"
require "lib.THcanvas"
require "lib.THplayer"
require "lib.THitem"]]


function love.load()
	th_text.LoadFont("debug", "assets/font/arial.ttf", 15) -- debug需要
	th_image.LoadImage("loading", "assets/ui/loading.png")
	th.ResetRandomSeed() -- 重置随机数种子
	if gameMode == GAME_MODE_DEBUG then
		New(th_debug) -- debug模式, 需要提前加载THobject, THtask, THtext, THdebug
	end
	New(th_object,function (self) -- 开屏加载动画, 需要提前加载THobject, THtask, THimage, THgame, THdata
		self._a = 0
		self.image = "loading"
		task.New(function ()
			--[[task._wait(40)
			for i = 0, 1, 1/100 do
				self._a = i
				coroutine.yield()
			end]]
			require "lib.THquad_group"
			require "lib.THaudio"
			require "lib.THbullet"
			require "lib.THcanvas"
			require "lib.THplayer"
			require "lib.THenemy"
			require "lib.THitem"
			require "lib.TH3d"
			g3d = require "g3d"
			require "assets.thmian"
			--[[task._wait(150)
			for i = 1, 0, -1/100 do
				self._a = i
				coroutine.yield()
			end]]
			Main()
			self:Delete()
		end)
	end)
	--require "assets.thmian"
	--Main()
end

function love.keypressed(key)
    if key == "f12" then
        love.graphics.captureScreenshot(os.time() .. ".png")
    end
end

function love.update(dt) -- delta time因为task获取dalta麻烦的原因所以不用了
    task.frame()
	--g3d.camera.firstPersonMovement(dt)
	for k, obj in pairs(objectPool) do
		if obj.frame and obj.isActive and obj.isUsing then
			obj:frame(dt*love.timer.getFPS())
		end
	end
end

function love.draw()
	for i = 90, 1, -1 do
    	for k, obj in pairs(objectPool) do
			if obj.layer == i and obj.render and obj.isRender and obj.isUsing then
				obj:render(screenRatioWidth, screenRatioHeight)
			end
		end
	end
end

--[[function love.mousemoved(x,y, dx,dy)
    g3d.camera.firstPersonLook(dx,dy)
end]]
