extends Character

var actions: Dictionary = {
	"Normal Attack": {
		"description": "Does damage or something idk",
		"target_allies": 0,
		"target_enemies": 1,
		"action": Callable(self, "normal_attack2")
	},
	"poison": {
		"description": "Poisons",
		"target_allies": 0,
		"target_enemies": 1,
		"action": Callable(self, "poison2")
	}
}

func normal_attack2(allies: Array[Character], enemies: Array[Character]):
	enemies[0].hp -= damage
	
func poison2(allies: Array[Character], enemies: Array[Character]):
	enemies[0].apply_status(StatusEffectManager.poison_effect.duplicate())

func _process(delta: float) -> void:
	$Label.text = str(hp)
