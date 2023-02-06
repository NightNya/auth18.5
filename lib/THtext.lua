---@class th_text : th_ui
th_text = Class("th_text", th_ui)

TEXT_ALIGN_CENTER = "center"
TEXT_ALIGN_JUSTIFY = "justify"
TEXT_ALIGN_LEFT = "left"
TEXT_ALIGN_RIGHT = "right"

---@param text? string|table 可以是有颜色的
---@param fontname? string
---@param limit? number
---@param textAlign? string
---@param is_format? boolean
---@param cb_new? function
---@param cb_delete? function
---@param cb_kill? function
function th_text:initialize(text, fontname, limit, textAlign, is_format, cb_new, cb_kill, cb_delete)
	th_ui:initialize(cb_new, cb_kill, cb_delete)
	self.text = text or ""
	self.font = fontname or "debug"
	self.limit = limit or 1
	self.textAlign = textAlign or TEXT_ALIGN_LEFT
	self.isFormat = is_format
end

function th_text:render(srw, srh)
	--th_object:render(srw, srh) -- 别问我为啥可以渲染图像
	love.graphics.setFont(font[self.font])
	if not self.isFormat then
		love.graphics.print(self.text, self.x*srw, self.y*srh, self.rot, self.sx*srw, self.sy*srh, self.ox, self.oy, self.kx*srw, self.ky*srh)
	else
		love.graphics.printf(self.text, self.x*srw, self.y*srh, self.limit, self.textAlign, self.rot, self.sx*srw, self.sy*srh, self.ox, self.oy, self.kx*srw, self.ky)
	end
end


---加载字体到 `font`
---@param name string
---@param path string
---@param size? number
---@param hinting? "light"|"mono"|"none"|"normal"
---@param dpiscale? number
---@overload fun(name:string, path:string)
function LoadFont(name, path, size, hinting, dpiscale)
	if size then
		font[name] = love.graphics.newFont(path, size, hinting, dpiscale)
	else
		font[name] = love.graphics.newFont(path)
	end
	love.graphics.newFont()
end
