extends Node2D

var characters: Array[Character]

@onready var action_box = $ActionBox

var turn: int
var taking_turn: Character

func _ready() -> void:
	for character in $YellowTeam.get_children():
		character.add_to_group("yellow_team")
		characters.append(character)
	for character in $PurpleTeam.get_children():
		character.add_to_group("purple_team")
		characters.append(character)
	turn_order()
		
func _process(delta: float) -> void:
	if turn == characters.size():
		turn = 0
		turn_order()
	if characters[turn] != taking_turn:
		if taking_turn != null:
			taking_turn.end_turn()
		taking_turn = characters[turn]
		taking_turn.start_turn()
		action_box.taking_turn = taking_turn
		action_box.clear_actions()
		action_box.populate_actions()
		
func turn_order():
	characters.sort_custom(func(a, b):
		return a.speed > b.speed
	)
