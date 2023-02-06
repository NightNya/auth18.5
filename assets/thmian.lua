require "assets.font.font"
require "assets.music.music"
require "assets.se.se"
require "assets.ui.ui"
require "assets.player.player"
require "assets.bullet.bullet"
require "assets.item.item"
require "assets.misc.misc"

function Main()
	th.DefineDifficulty("easy", 1)
	th.DefineDifficulty("normal", 2)
	th.DefineDifficulty("hard", 3)
	th.DefineDifficulty("lunatic", 4)
	th.DefineDifficulty("spasmodic", 5)
	th.DefineDifficulty("extra", 6, true)
	th.DefineStage("title", 1, "menu")
	th.DefineStage("1", 2, "game")
	th.DefineStage("2", 3, "game")
	th.DefineStage("3", 4, "game")
	th.DefineStage("4", 5, "game")
	th.DefineStage("5", 6, "game")
	th.DefineStage("6", 7, "game")
	th.DefineStage("ex", 8, "game")
	th.DefineStage("ending", 9, "ending")
	th.DefineStage("staff", 10, "staff")
	th.StartStage(2)
	UpdateWorld()
end

function UpdateWorld()
	if playerAction.stage.name == "title" then
		New(th_object, function (self)
			self.image = "board"
			self.sx = 64
			self.sy = 36
			self._r = 0
			self._g = 0
			self._b = 0
			task.New(function ()
				for i = 1, 0, -1/50 do
					self._a = i
					coroutine.yield()
				end
				self:Delete()
			end)
		end)
		ui.DrawUI("title")
	elseif playerAction.stage.name == "1" then
		New(th_player, "reimu")
		th_item.New("power", 40, FRONT_X,FRONT_Y,150+FRONT_X,150+FRONT_Y)
		ui.DrawUI("game")
	end
end
