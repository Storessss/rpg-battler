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
		"description": "Evenly splits a 40 damage double attack, receaves weakness",
		"min_target_allies": 0,
		"max_target_allies": 0,
		"min_target_enemies": 1,
		"max_target_enemies": 2,
		"light_charges": 0,
		"shade_charges": 0,
		"balance_charges": 0,
		"action": Callable(self, "double_slash")
	}
}

func attack(allies: Array[Character], enemies: Array[Character]):
	var crit: int = 1
	if luck > randi_range(1, 100):
		crit = 2
	enemies[0].hp -= max(damage * crit - enemies[0].defense, 1)
	
func double_slash(allies: Array[Character], enemies: Array[Character]):
	if enemies.size() == 1:
		enemies[0].hp -= 40
	else:
		enemies[0].hp -= 20
		enemies[1].hp -= 20
