extends Node

func general_attack_func(caller: Character, targets: Array[Character]) -> void:
	for target in targets:
		var crit: int = 1
		if caller.luck > randi_range(1, 100):
			crit = 2
		target.hp -= max(caller.damage * crit - target.defense, 1)
		if target.hp <= 0:
			target.die()
			
func to_all_friends(caller: Character):
	if caller.is_in_group("yellow_team"):
		return get_tree().get_nodes_in_group("yellow_team")
	elif caller.is_in_group("purple_team"):
		return get_tree().get_nodes_in_group("purple_team")
		
func to_all_foes(caller: Character):
	if caller.is_in_group("yellow_team"):
		return get_tree().get_nodes_in_group("purple_team")
	elif caller.is_in_group("purple_team"):
		return get_tree().get_nodes_in_group("yellow_team")
