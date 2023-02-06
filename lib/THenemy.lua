---@class th_enemy : th_object
th_enemy = Class("th_enemy", th_object)

---comment
---@param cb_new function
---@param cb_kill function
---@param cb_delete function
function th_enemy:initialize(cb_new, cb_kill, cb_delete)
	th_object:initialize(cb_new, cb_kill, cb_delete)
	self.layer = LAYER_ENEMY
	self.collision = COLLI_CIRCLE
	self.collisionGroup = COLLI_GROUP_PLAYER_BULLET
end
