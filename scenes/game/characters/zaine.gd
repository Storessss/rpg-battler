extends Character

var actions: Dictionary = {
	"Shadow Slash": {
		"description": "Attacks 1 target, gains one shade charge",
		"min_target_allies": 0,
		"max_target_allies": 0,
		"min_target_enemies": 1,
		"max_target_enemies": 1,
		"light_charges": 0,
		"shade_charges": 0,
		"balance_charges": 0,
		"action": Callable(self, "shadow_slash")
	},
	"Double Slash": {
		"description": "Splits a double attack",
		"min_target_allies": 0,
		"max_target_allies": 0,
		"min_target_enemies": 1,
		"max_target_enemies": 2,
		"light_charges": 0,
		"shade_charges": 0,
		"balance_charges": 0,
		"action": Callable(self, "double_slash")
	},
	"Charged Slash": {
		"description": "Attacks x3 on a single target, consumes a shadow charge",
		"min_target_allies": 0,
		"max_target_allies": 0,
		"min_target_enemies": 1,
		"max_target_enemies": 1,
		"light_charges": 0,
		"shade_charges": 1,
		"balance_charges": 0,
		"action": Callable(self, "charged_slash")
	}
}

func shadow_slash(allies: Array[Character], enemies: Array[Character]):
	enemies[0].take_damage(crit(attack))
	GlobalVariables.add_charge("shade", 1, GlobalVariables.taking_turn)
	
func double_slash(allies: Array[Character], enemies: Array[Character]):
	if enemies.size() == 1:
		enemies[0].take_damage(crit(attack * 2))
	else:
		enemies[0].take_damage(crit(attack))
		enemies[1].take_damage(crit(attack))
		
func charged_slash(allies: Array[Character], enemies: Array[Character]):
	if enemies.size() == 1:
		enemies[0].take_damage(crit(attack * 3))
