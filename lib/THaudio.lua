---@class th_audio : class
local th_audio = Class("th_audio")

---@alias th_audio.SourceType "queue"|"static"|"stream"

---@param path string
---@param audio_type th_audio.SourceType
---@param x number
---@param y number
---@param z number
function th_audio:initialize(path, audio_type, x, y, z)
    self.source = love.audio.newSource(path, audio_type)
    if x and y and z then
        self.source:setPosition(x,y,z)
    end
end

---会以静态（储存在运行内存中）加载声音（建议用作音效）
---@param path string
---@param position_x? number 声音的位置 x
---@param position_y? number 声音的位置 y
---@param position_z? number 声音的位置 z
function th_audio.LoadSound(name, path, position_x, position_y, position_z)
    sound[name] = th_audio:new(path, "static", position_x, position_y, position_z)
end

---会以分段加载声音（建议用作音乐）
---@param path string
---@param position_x? number 声音的位置 x
---@param position_y? number 声音的位置 y
---@param position_z? number 声音的位置 z
function th_audio.LoadMusic(name, path, position_x, position_y, position_z)
    music[name] = th_audio:new(path, "stream", position_x, position_y, position_z)
end

function th_audio.PlaySound(name)
    love.audio.play(sound[name].source)
end

function th_audio.PlayMusic(name)
    love.audio.play(music[name].source)
end

function th_audio.PauseSound(name)
    love.audio.pause(sound[name])
end

function th_audio.PauseMusic(name)
    love.audio.pause(music[name])
end

function th_audio.SetSoundPosition(name, x, y, z)
    sound[name].source:setPosition(x,y,z)
end

function th_audio.SetMusicPosition(name, x, y, z)
    music[name].source:setPosition(x,y,z)
end

return th_audio