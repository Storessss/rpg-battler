extends Control

@onready var vbox = $VBoxContainer
@onready var selector = $Selector
@onready var description_box = $DescriptionBox
var index: int

var turn_phase: int

var taking_turn: Character
var turn_actions: Dictionary
var turn_action: Callable
var turn_allied_characters: Array[Node]
var turn_enemy_characters: Array[Node]
var min_target_allies: int
var max_target_allies: int
var min_target_enemies: int
var max_target_enemies: int
var target_allies_count: int
var target_enemies_count: int
var target_allies: Array[Character]
var target_enemies: Array[Character]

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
		
func populate_allies():
	if taking_turn.is_in_group("yellow_team"):
		turn_allied_characters = get_tree().get_nodes_in_group("yellow_team")
	elif taking_turn.is_in_group("purple_team"):
		turn_allied_characters = get_tree().get_nodes_in_group("purple_team")
	for ally in turn_allied_characters:
		var label = Label.new()
		label.text = ally.character_name
		vbox.add_child(label)
		
func populate_enemies():
	if taking_turn.is_in_group("yellow_team"):
		turn_enemy_characters = get_tree().get_nodes_in_group("purple_team")
	elif taking_turn.is_in_group("purple_team"):
		turn_enemy_characters = get_tree().get_nodes_in_group("yellow_team")
	for enemy in turn_enemy_characters:
		var label = Label.new()
		label.text = enemy.character_name
		vbox.add_child(label)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		index = (index - 1 + vbox.get_child_count()) % vbox.get_child_count()
	elif Input.is_action_just_pressed("down"):
		index = (index + 1 + vbox.get_child_count()) % vbox.get_child_count()
	selector.position = vbox.get_child(index).position
	selector.position += Vector2(100, -15)
	if turn_phase == 0:
		if taking_turn.actions.has(vbox.get_child(index).text):
			description_box.text = taking_turn.actions[vbox.get_child(index).text]["description"]
		else:
			description_box.text = ""
		if Input.is_action_just_pressed("confirm"):
			var key = vbox.get_child(index).text
			turn_action = taking_turn.actions[key]["action"]
			min_target_allies = taking_turn.actions[key]["min_target_allies"]
			max_target_allies = taking_turn.actions[key]["max_target_allies"]
			min_target_enemies = taking_turn.actions[key]["min_target_enemies"]
			max_target_enemies = taking_turn.actions[key]["max_target_enemies"]
			clear_actions()
			if max_target_allies == 0:
				populate_enemies()
				turn_phase = 2
			else:
				populate_allies()
				turn_phase = 1
	elif turn_phase == 1:
		if Input.is_action_just_pressed("select"):
			if vbox.get_child(index).modulate == Color.WHITE:
				vbox.get_child(index).modulate = Color.GREEN
				target_allies.append(turn_allied_characters[index])
				target_allies_count += 1
			elif vbox.get_child(index).modulate == Color.GREEN:
				target_allies.erase(turn_allied_characters[index])
				vbox.get_child(index).modulate = Color.WHITE
				target_allies_count -= 1
		if Input.is_action_just_pressed("confirm") and target_allies_count >= min_target_allies and \
		 target_allies_count <= max_target_allies:
			clear_actions()
			if max_target_enemies == 0:
				turn_phase = 3
			else:
				turn_phase = 2
				populate_enemies()
	elif turn_phase == 2:
		if Input.is_action_just_pressed("select"):
			if vbox.get_child(index).modulate == Color.WHITE:
				vbox.get_child(index).modulate = Color.GREEN
				target_enemies.append(turn_enemy_characters[index])
				target_enemies_count += 1
			elif vbox.get_child(index).modulate == Color.GREEN:
				vbox.get_child(index).modulate = Color.WHITE
				target_enemies.erase(turn_enemy_characters[index])
				target_enemies_count -= 1
		if Input.is_action_just_pressed("confirm") and target_enemies_count >= min_target_enemies and \
		 target_enemies_count <= max_target_enemies:
			turn_phase = 3
	elif turn_phase == 3:
		turn_action.call(target_allies, target_enemies)
		turn_phase = 0
		target_allies.clear()
		target_enemies.clear()
		target_allies_count = 0
		target_enemies_count = 0
		get_tree().current_scene.turn += 1
	if Input.is_action_just_pressed("back"):
		turn_phase = 0
		target_allies.clear()
		target_enemies.clear()
		target_allies_count = 0
		target_enemies_count = 0
		clear_actions()
		populate_actions()
			
func _physics_process(delta: float) -> void:
	print("t: ", target_enemies_count)
	print("x: ", max_target_enemies)
	print("n: ", min_target_enemies)
