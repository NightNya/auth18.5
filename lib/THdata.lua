local th_data = {}
local error
function th_data.CheckPlayerData()
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

return th_data