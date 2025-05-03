extends Node2D

var characters: Array[Character]
var yellow_team: Array[Character]
var purple_team: Array[Character]

@onready var action_box = $ActionBox

var turn: int
var taking_turn: Character

func _ready() -> void:
	for character in $YellowTeam.get_children():
		character.add_to_group("yellow_team")
		characters.append(character)
		yellow_team.append(character)
	for character in $PurpleTeam.get_children():
		character.add_to_group("purple_team")
		characters.append(character)
		purple_team.append(character)
		
func _process(delta: float) -> void:
	if characters[turn] != taking_turn:
		taking_turn = characters[turn]
		action_box.taking_turn = taking_turn
		action_box.clear_actions()
		action_box.populate_actions()
