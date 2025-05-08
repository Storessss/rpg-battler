extends Node2D

@onready var action_box = $ActionBox

func _ready() -> void:
	for character in $YellowTeam.get_children():
		character.add_to_group("yellow_team")
		GlobalVariables.characters.append(character)
	for character in $PurpleTeam.get_children():
		character.add_to_group("purple_team")
		GlobalVariables.characters.append(character)
	turn_order()
		
func _process(delta: float) -> void:
	if GlobalVariables.turn == GlobalVariables.characters.size():
		GlobalVariables.turn = 0
		turn_order()
	if GlobalVariables.characters[GlobalVariables.turn] != GlobalVariables.taking_turn:
		if GlobalVariables.taking_turn != null:
			GlobalVariables.taking_turn.end_turn()
		GlobalVariables.taking_turn = GlobalVariables.characters[GlobalVariables.turn]
		GlobalVariables.actions = GlobalVariables.taking_turn.actions
		GlobalVariables.taking_turn.start_turn()
		action_box.clear_actions()
		action_box.populate_actions()
		
	display_charges()
		
func turn_order():
	GlobalVariables.characters.sort_custom(func(a, b):
		return a.speed > b.speed
	)

func display_charges():
	$YellowTeamCharges/Light.text = "Light charges: " + str(GlobalVariables.yellow_team_light_charges)
	$YellowTeamCharges/Shade.text = "Shade charges: " + str(GlobalVariables.yellow_team_shade_charges)
	$YellowTeamCharges/Balance.text = "Balance charges: " + str(GlobalVariables.yellow_team_balance_charges)
	$PurpleTeamCharges/Light.text = "Light charges: " + str(GlobalVariables.purple_team_light_charges)
	$PurpleTeamCharges/Shade.text = "Shade charges: " + str(GlobalVariables.purple_team_shade_charges)
	$PurpleTeamCharges/Balance.text = "Balance charges: " + str(GlobalVariables.purple_team_balance_charges)
