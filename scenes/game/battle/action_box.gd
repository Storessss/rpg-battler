extends Control

@onready var vbox = $VBoxContainer
@onready var selector = $Selector
var index: int

var taking_turn: Character
var turn_actions: Dictionary
var turn_action: Callable
var targets_purple_team: bool
var turn_targets: Array[Character]

func clear_actions():
	index = 0
	for child in vbox.get_children():
		child.queue_free()

func populate_actions():
	turn_actions = taking_turn.actions
	var action_names: Array[String]
	for key in turn_actions.keys():
		action_names.append(key)
	for action_name in action_names:
		var label = Label.new()
		label.text = action_name
		vbox.add_child(label)
		
func populate_characters():
	var turn_characters: Array[Node]
	if targets_purple_team:
		turn_characters = get_tree().get_nodes_in_group("purple_team")
	else:
		turn_characters = get_tree().get_nodes_in_group("yellow_team")
	for turn_character in turn_characters:
		var label = Label.new()
		label.text = turn_character.character_name
		vbox.add_child(label)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		index = (index - 1 + vbox.get_child_count()) % vbox.get_child_count()
	elif Input.is_action_just_pressed("down"):
		index = (index + 1 + vbox.get_child_count()) % vbox.get_child_count()
	selector.position = vbox.get_child(index).position
	selector.position += Vector2(100, -15)
	if Input.is_action_just_pressed("confirm"):
		var key = vbox.get_child(index).text
		turn_action = taking_turn.actions[key]["action"]
		var targets_enemy = taking_turn.actions[key]["targets_enemy"]
		if taking_turn.is_in_group("yellow_team"):
			if targets_enemy:
				targets_purple_team = true
			else:
				targets_purple_team = false
		elif taking_turn.is_in_group("purple_team"):
			if targets_enemy:
				targets_purple_team = false
			else:
				targets_purple_team = true
		clear_actions()
		populate_characters()
