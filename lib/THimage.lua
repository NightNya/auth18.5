local th_image = {}
---加载图像到 `image`
---@param name string
---@param path string
---@param settings? {dpiscale: number, linear: boolean, mipmaps: boolean}
function th_image.LoadImage(name, path, settings)
    image[name] = love.graphics.newImage(path, settings)
end

return th_image