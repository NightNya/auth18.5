---禁止实例
th = {}

--stage，难度，符卡，boss等名称均使用整数类型
--所有函数不提供实现，仅用于定义

---重置 Lua 和 LÖVE 的随机数种子并返回
---@return number?
function th.ResetRandomSeed()
	local seed = tonumber(tostring(os.time()):reverse():sub(1, 6))
	if not seed then
		seed = 0
	end
	love.math.setRandomSeed(seed)
	math.randomseed(seed)
	return seed
end

---定义 stage
---@param name string
---@param index integer
---@param _type "menu"|"game"|"ending"|"staff"
function th.DefineStage(name, index, _type)
	table.insert(stage, index, {
		name = name,
		type = _type
	})
end

---定义难度
---@param name string
---@param index integer
---@param is_extra? boolean
function th.DefineDifficulty(name, index, is_extra)
	table.insert(diffculty, index, {
		name = name,
		isExtra = is_extra
	})
end

---定义符卡
---@param name string
---@param index integer
---@param boss string
---@param time integer
---@param hp integer
---@param protect_time integer
---@param is_immune_bomb boolean
---@param level? integer 符卡总阶段
function th.DefineSpellCard(name, index, boss, time, hp, protect_time, is_immune_bomb, level)
	table.insert(spellCard, index, {
		name = name,
		boss = boss,
		time = time,
		hitPoint = hp,
		protectTime = protect_time,
		isImmuneBomb = is_immune_bomb,
		level = level
	})
end

---检测玩家数据是否可用
---@param value string
---@return boolean
function th.AvailablePlayerData(value)
	if value == "finishedDiffculty" or value == "finishedSpellCard" then
		---@diagnostic disable-next-line: empty-block, param-type-mismatch
		if next(playerData[value]) then
			return true
		else
			return false
		end
	else
		if playerData[value] then
			return true
		else
			return false
		end
	end
end

---设置玩家数据（用于练习模式或普通模式初始化）
---@param name? string
---@param stage? integer
---@param diffculty? integer
---@param character? integer
---@param lives? integer
---@param bomb? integer
---@param boss? integer
---@param spellCard? integer
---@param isCleared? boolean
function th.SetPlayerData(name, stage, diffculty, character, lives, bomb, boss, spellCard, isCleared)
	if name then
		playerData.name = name
	end
	if stage then
		playerAction.stage = stage
	end
	if diffculty then
		playerAction.diffculty = diffculty
	end
	if character then
		playerAction.character = character
	end
	if lives then
		playerAction.lives = lives
	end
	if bomb then
		playerAction.bomb = bomb
	end
	if boss then
		playerAction.boss = boss
	end
	if spellCard then
		playerAction.spellCard = spellCard
	end
	if isCleared then
		playerData.isCleared = isCleared
	end
end

---记录玩家已通过难度
---@param value integer
function th.PlayerFinishedDiffculty(value, score)
	if not playerData.finishedDiffculty[value] then
		playerData.finishedDiffculty[value] = {}
		playerData.finishedDiffculty[value].score = score
		if playerData.highestScore < score then
			playerData.highestScore = score
		end
	else
		if playerData.finishedDiffculty[value].score < score then
			playerData.finishedDiffculty[value].score = score
		end
		if playerData.highestScore < score then
			playerData.highestScore = score
		end
	end
end

---记录玩家已通过符卡
---@param value integer
---@param score integer
---@param time number
---@param isAccepted boolean
function th.PlayerFinishedSpellCard(value, score, time, isAccepted)
	if not playerData.finishedSpellCard[value] then
		playerData.finishedSpellCard[value] = {}
		playerData.finishedSpellCard[value].score = score
		playerData.finishedSpellCard[value].time = time
		playerData.finishedSpellCard[value].accepted = 0
		playerData.finishedSpellCard[value].notAccepted = 0
		if isAccepted then
			playerData.finishedSpellCard[value].accepted = 1
		else
			playerData.finishedSpellCard[value].notAccepted = 1
		end
	else
		if playerData.finishedSpellCard[value].score < score then
			playerData.finishedSpellCard[value].score = score
		end
		if playerData.finishedSpellCard[value].time > time then
			playerData.finishedSpellCard[value].time = time
		end
		if isAccepted then
			playerData.finishedSpellCard[value].accepted = playerData.finishedSpellCard[value].accepted + 1
		else
			playerData.finishedSpellCard[value].notAccepted = playerData.finishedSpellCard[value].notAccepted + 1
		end
	end
end

---检测玩家是否已通过难度
---@param value integer
---@return boolean
function th.PlayerIsFinishedDiffculty(value)
	for i, v in ipairs(playerData.finishedDiffculty) do
		if v == value then
			return true
		end
	end
	return false
end

---检测玩家是否已通过符卡
---@param value integer
---@return boolean
function th.PlayerIsFinishedSpellCard(value)
	for i, v in ipairs(playerData.finishedSpellCard) do
		if v == value then
			return true
		end
	end
	return false
end

function th.SetDiffculty(index)
	playerAction.diffculty = diffculty[index]
end

function th.StartStage(index)
    playerAction.stage = stage[index]
end

function th.CompletedStage()
    playerAction.stage = nil
end

function th.StartSpellCard(index)
    if playerAction.boss == spellCard[index].boss then
        playerAction.spellCard = spellCard[index]
    end
end

function th.CompletedSpellCard()
    playerAction.spellCard = nil
end
