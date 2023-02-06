---东方简单脚本库（Touhou Easy Script）

thes = {}
local functions = {}
local scripts = {}

functions[100] = function(v) thlog(v) end
functions[101] = function(v) therror(v) end
functions[102] = function(v) thwarning(v) end
functions[103] = function(v) thlog(v[1]) thlog(v[2]) end
functions[104] = function(v) New(v[1], v[2], v[3], v[4]) end -- 一般就只用这四种参数

function LoadScript(fname, path)
	scripts[fname] = {}
	for line in love.filesystem.lines(path) do
		table.insert(scripts[fname], tostring(line))
	end
end

local function comfind(str)
	local coms = {}
	table.insert(coms, string.find(str, ","))
	thlog(coms[1])
	if next(coms) then
		--[[while string.find(str, ",", coms[#coms]+1) do
			table.insert(coms, string.find(str, ",", coms[#coms]+1))
		end]]
		table.insert(coms, string.find(str, ",", coms[#coms]+1))
		table.insert(coms, string.find(str, ",", coms[#coms]+1))
		return coms
	else
		return nil
	end
end

function thes.Run(fname)
	local vfi, vla, com, v
	for i = 1, #scripts[fname] do
		vfi = string.find(scripts[fname][i], "%(")
		vla = string.find(scripts[fname][i], ")")
		coms = comfind("a,b,c")
		if coms then
			for ind, va in ipairs(coms) do
				thlog(va)
			end
		else
			v = string.sub(scripts[fname][i], vfi+1, vla-1)
		end
		functions[tonumber(string.sub(scripts[fname][i], 1, vfi-1))](v)
	end
end
