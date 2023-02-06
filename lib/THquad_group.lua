--[[
---@param qtype "x"|"y"|"batch" 切片方式
---@param qimage string 在 `image` 中的名字
---@param n integer 如果 `type` 为 `"x"` 或 `"y"` 则此值为数量，如果为 `"batch"` 则此值为表
---@overload fun(type:"x"|"y"|"batch", qimage:string, n:table)
function th_quadGroup:initialize(qtype, qimage, n)
	local tw = image[qimage]:getWidth()
	local th = image[qimage]:getHeight()
	if qtype == "x" then
		for i = 0, n do
			table.insert(self, love.graphics.newQuad(i*tw/n, 0, tw/n, th, tw, th))
		end
	elseif qtype == "y" then
		for i = 0, n do
			table.insert(self, love.graphics.newQuad(0, i*th/n, tw, th/n, tw, th))
		end
	elseif qtype == "batch" then
		---认不出来 table ，笑嘻了
		---@diagnostic disable-next-line: param-type-mismatch
		for k,v in pairs(n) do
			self[v[5] = love.graphics.newQuad(v[1], v[2], v[3], v[4], tw, th)
		end
	end
end]]

---添加切片到 `quad`
---@param name string
---@param qimage string
---@param x number
---@param y number
---@param width number
---@param height number
function NewQuad(name, qimage, x, y, width, height)
	quad[name] = love.graphics.newQuad(x, y, width, height, image[qimage]:getWidth(), image[qimage]:getHeight())
end

---X轴图像规律切片，添加到 `quadGroup`
---@param name string
---@param qimage string 在 `image` 中的图像名
---@param n integer 数量
function NewQuadGroupX(name, qimage, n)
	--quadGroup[name] = th_quadGroup:new("x", qimage, n)
	local tw = image[qimage]:getWidth()
	local th = image[qimage]:getHeight()
	quadGroup[name] = {}
	for i = 0, n do
		table.insert(quadGroup[name], love.graphics.newQuad(i*tw/n, 0, tw/n, th, tw, th))
	end
end

---Y轴图像规律切片，添加到 `quadGroup`
---@param name string
---@param qimage string 在 `image` 中的图像名
---@param n integer 数量
function NewQuadGroupY(name, qimage, n)
	--quadGroup[name] = th_quadGroup:new("y", qimage, n)
	quadGroup[name] = {}
	local tw = image[qimage]:getWidth()
	local th = image[qimage]:getHeight()
	for i = 0, n do
		table.insert(quadGroup[name], love.graphics.newQuad(0, i*th/n, tw, th/n, tw, th))
	end
end

---批量切片，位置、大小、名字请按 `{x,y,w,h,n}` 排列，并将所有该数据写在一个表里，添加到 `quadGroup`
---@param name string
---@param qimage string 在 `image` 中的图像名
---@param t table 切片的位置、大小、名字
function NewQuadGroupBatch(name, qimage, t)
	--quadGroup[name] = th_quadGroup:new("batch", qimage, t)
	quadGroup[name] = {}
	local tw = image[qimage]:getWidth()
	local th = image[qimage]:getHeight()
	for k,v in pairs(t) do
		quadGroup[name][v[5]] = love.graphics.newQuad(v[1], v[2], v[3], v[4], tw, th)
	end
end
