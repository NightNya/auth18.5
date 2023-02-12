---`th_ui` 类和继承自该类的类的坐标 (`self.x self.y`) 是不能使用的，必须使用偏移 (`self.ofx self.ofy`)
---@class th_ui : th_object
local th_ui = Class("th_ui", th_object)

UI_ALIGN_CORNER_LEFT_TOP = 1
UI_ALIGN_CORNER_RIGHT_TOP = 2
UI_ALIGN_CORNER_LEFT_BOTTOM = 3
UI_ALIGN_CORNER_RIGHT_BOTTOM = 4
UI_ALIGN_CENTER = 5
UI_ALIGN_CENTER_LEFT = 6
UI_ALIGN_CENTER_RIGHT = 7
UI_ALIGN_CENTER_TOP = 8
UI_ALIGN_CENTER_BOTTOM = 9

---@param cb_new? function
---@param cb_kill? function
---@param cb_delete? function
function th_ui:initialize(cb_new, cb_kill, cb_delete)
	th_object:initialize(cb_new, cb_kill, cb_delete)
	--- x 偏移，相当于 `th_object` 的 `self.x` ，坐标正方向不变
	--- @type number
	self.ofx = 0

	--- y 偏移，相当于 `th_object` 的 `self.y` ，坐标正方向不变
	--- @type number
	self.ofy = 0

	--- 对齐方式
	--- @type integer
	self.align = UI_ALIGN_CORNER_LEFT_TOP
end

function th_ui:frame(dt)
	if self.align == UI_ALIGN_CORNER_LEFT_TOP then -- 左上角
		self.x = self.ofx
		self.y = self.ofy
		-- 不变
	elseif self.align == UI_ALIGN_CORNER_RIGHT_TOP then -- 右上角
		self.x = SCREEN_ORIGIN_WIDTH + self.ofx
		self.y = self.ofy
	elseif self.align == UI_ALIGN_CORNER_LEFT_BOTTOM then -- 左下角
		self.x = self.ofx
		self.y = SCREEN_ORIGIN_HEIGHT + self.ofy
	elseif self.align == UI_ALIGN_CORNER_RIGHT_BOTTOM then -- 右下角
		self.x = SCREEN_ORIGIN_WIDTH + self.ofx
		self.y = SCREEN_ORIGIN_HEIGHT + self.ofy
	elseif self.align == UI_ALIGN_CENTER then -- 中间
		self.x = SCREEN_ORIGIN_WIDTH/2 + self.ofx
		self.y = SCREEN_ORIGIN_HEIGHT/2 + self.ofy
	elseif self.align == UI_ALIGN_CENTER_LEFT then -- 左中
		self.x = self.ofx
		self.y = SCREEN_ORIGIN_HEIGHT/2 + self.ofy
	elseif self.align == UI_ALIGN_CENTER_RIGHT then -- 右中
		self.x = SCREEN_ORIGIN_WIDTH + self.ofx
		self.y = SCREEN_ORIGIN_HEIGHT/2 + self.ofy
	elseif self.align == UI_ALIGN_CENTER_TOP then -- 上中
		self.x = SCREEN_ORIGIN_WIDTH/2 + self.ofx
		self.y = self.ofy
	elseif self.align == UI_ALIGN_CENTER_BOTTOM then -- 下中
		self.x = SCREEN_ORIGIN_WIDTH/2 + self.ofx
		self.y = SCREEN_ORIGIN_HEIGHT
	end
end

return th_ui