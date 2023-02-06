th_3d = Class("th_3d")

function th_3d:initialize(vertexname, texturename, translation, rotation, scale, cb_new, cb_kill, cb_delete)
    self.isUsing = true
    self.isActive = true
    self.isRender = true
	self._r = 1
	self._g = 1
	self._b = 1
	self._a = 1
    self.layer = LAYER_BACKGROUND
    self.model = g3d.newModel(vertex[vertexname], image[texturename], translation, rotation, scale)
    self.cb_new = cb_new or function()end
    self.cb_kill = cb_kill or function()end
    self.cb_kill = cb_delete or function()end
end

function th_3d:render(srw, srh)
    love.graphics.setColor(self._r,self._g,self._b,self._a)
    self.model:draw()
end

function LoadVertex(name, path)
    vertex[name] = path
end
