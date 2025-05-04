extends Character

var actions: Dictionary = {
	"Fairy Heal": {
		"description": "Evenly splits a heal of 60 HP up to 3 allies",
		"min_target_allies": 1,
		"max_target_allies": 3,
		"min_target_enemies": 0,
		"max_target_enemies": 0,
		"light_charges": 0,
		"shade_charges": 0,
		"balance_charges": 0,
		"action": Callable(self, "fairy_heal")
	},
	"Purify": {
		"description": "Removes all negative status effects from a target",
		"min_target_allies": 1,
		"max_target_allies": 1,
		"min_target_enemies": 0,
		"max_target_enemies": 0,
		"light_charges": 0,
		"shade_charges": 0,
		"balance_charges": 0,
		"action": Callable(self, "purify")
	},
	"Encourage": {
		"description": "Gives strength up to 3 allies",
		"min_target_allies": 1,
		"max_target_allies": 3,
		"min_target_enemies": 0,
		"max_target_enemies": 0,
		"light_charges": 0,
		"shade_charges": 0,
		"balance_charges": 0,
		"action": Callable(self, "encourage")
	}
}

func fairy_heal(allies: Array[Character], enemies: Array[Character]):
	if allies.size() == 1:
		allies[0].hp += 60
	elif allies.size() == 2:
		allies[0].hp += 30
		allies[1].hp += 30
	else:
		allies[0].hp += 20
		allies[1].hp += 20
		allies[2].hp += 20
	
func purify(allies: Array[Character], enemies: Array[Character]):
	for effect in allies[0].status_effects:
		if not effect["is_positive"]:
			allies[0].status_effects.erase(effect)
			
func encourage(allies: Array[Character], enemies: Array[Character]):
	for ally in allies:
		ally.apply_status(StatusEffectManager.strength_effect.duplicate())
