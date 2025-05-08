extends Node

var characters: Array[Character]

var turn: int
var taking_turn: Character
var actions: Dictionary

var yellow_team_light_charges: int
var yellow_team_shade_charges: int
var yellow_team_balance_charges: int
var purple_team_light_charges: int
var purple_team_shade_charges: int
var purple_team_balance_charges: int

func get_team(member: Character, allied: bool = true) -> Array[Node]:
	if member.is_in_group("yellow_team"):
		if allied:
			return get_tree().get_nodes_in_group("yellow_team")
		else:
			return get_tree().get_nodes_in_group("purple_team")
	else:
		if allied:
			return get_tree().get_nodes_in_group("purple_team")
		else:
			return get_tree().get_nodes_in_group("yellow_team")
			
func is_in_yellow_team(member: Character) -> bool:
	if member.is_in_group("yellow_team"):
		return true
	else:
		return false
		
func add_charge(type: String, amount: int, target: Character):
	if GlobalVariables.is_in_yellow_team(target):
		if type == "light":
			GlobalVariables.yellow_team_light_charges += amount
		elif type == "shade":
			GlobalVariables.yellow_team_shade_charges += amount
		elif type == "balance":
			GlobalVariables.yellow_team_balance_charges += amount
	else:
		if type == "light":
			GlobalVariables.purple_team_light_charges += amount
		elif type == "shade":
			GlobalVariables.purple_team_shade_charges += amount
		elif type == "balance":
			GlobalVariables.purple_team_balance_charges += amount
