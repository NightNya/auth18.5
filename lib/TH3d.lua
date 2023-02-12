local th_3d = Class("th_3d", object)

function th_3d:initialize(vertexname, texturename, translation, rotation, scale, cb_new, cb_kill, cb_delete)
    object:initialize(cb_new, cb_kill, cb_delete)
    self.model = g3d.newModel(vertex[vertexname], image[texturename], translation, rotation, scale)
end

function th_3d:render(srw, srh)
    love.graphics.setColor(self._r,self._g,self._b,self._a)
    self.model:draw()
end

function LoadVertex(name, path)
    vertex[name] = path
end

return th_3d