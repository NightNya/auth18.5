local error
function CheckPlayerData()
	love.filesystem.createDirectory("save")
	love.filesystem.createDirectory("replay")
	love.filesystem.createDirectory("snapshot")
	if not love.filesystem.getInfo("save/progress.thd") then
		data["progress"] = love.filesystem.newFile("progress.txt")
	else
		--data["progress"]
	end
	if data["progress"] then
		thlog("finished")
	end
end
