---加载图像到 `image`
---@param name string
---@param path string
---@param settings? {dpiscale: number, linear: boolean, mipmaps: boolean}
function LoadImage(name, path, settings)
    image[name] = love.graphics.newImage(path, settings)
end
