extends Control

@onready var vbox = $VBoxContainer
@onready var selector = $Selector
@onready var description_box = $DescriptionBox

var index: int
var turn_phase: int

var turn_action: Callable
var min_target_allies: int
var max_target_allies: int
var min_target_enemies: int
var max_target_enemies: int
var light_charges: int
var shade_charges: int
var balance_charges: int
var allied_characters: Array[Node]
var enemy_characters: Array[Node]
var target_allies_count: int
var target_enemies_count: int
var target_allies: Array[Character]
var target_enemies: Array[Character]

func clear_actions():
	index = 0
	for child in vbox.get_children():
		child.queue_free()

func populate_actions():
	var action_names: Array[String]
	for key in GlobalVariables.actions.keys():
		action_names.append(key)
	for action_name in action_names:
		var label = Label.new()
		label.text = action_name
		vbox.add_child(label)
		
func populate_allies():
	allied_characters = GlobalVariables.get_team(GlobalVariables.taking_turn, true)
	for ally in allied_characters:
		var label = Label.new()
		label.text = ally.character_name
		vbox.add_child(label)
		
func populate_enemies():
	enemy_characters = GlobalVariables.get_team(GlobalVariables.taking_turn, false)
	for enemy in enemy_characters:
		var label = Label.new()
		label.text = enemy.character_name
		vbox.add_child(label)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		index = (index - 1 + vbox.get_child_count()) % vbox.get_child_count()
	elif Input.is_action_just_pressed("down"):
		index = (index + 1 + vbox.get_child_count()) % vbox.get_child_count()
	if vbox.get_child(index):
		selector.position = vbox.get_child(index).position
		selector.position += Vector2(100, -15)
	if turn_phase == 0:
		if GlobalVariables.actions.has(vbox.get_child(index).text):
			description_box.text = GlobalVariables.actions[vbox.get_child(index).text]["description"]
		else:
			description_box.text = ""
		if Input.is_action_just_pressed("confirm"):
			var key = vbox.get_child(index).text
			turn_action = GlobalVariables.actions[key]["action"]
			min_target_allies = GlobalVariables.actions[key]["min_target_allies"]
			max_target_allies = GlobalVariables.actions[key]["max_target_allies"]
			min_target_enemies = GlobalVariables.actions[key]["min_target_enemies"]
			max_target_enemies = GlobalVariables.actions[key]["max_target_enemies"]
			light_charges = GlobalVariables.actions[key]["light_charges"]
			shade_charges = GlobalVariables.actions[key]["shade_charges"]
			balance_charges = GlobalVariables.actions[key]["balance_charges"]
			var enough_charges: bool
			if GlobalVariables.is_in_yellow_team(GlobalVariables.taking_turn):
				if GlobalVariables.yellow_team_light_charges >= light_charges and \
				GlobalVariables.yellow_team_shade_charges >= shade_charges and \
				GlobalVariables.yellow_team_balance_charges >= balance_charges:
					enough_charges = true
			else:
				if GlobalVariables.purple_team_light_charges >= light_charges and \
				GlobalVariables.purple_team_shade_charges >= shade_charges and \
				GlobalVariables.purple_team_balance_charges >= balance_charges:
					enough_charges = true
			if enough_charges:
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
				target_allies.append(allied_characters[index])
				target_allies_count += 1
			elif vbox.get_child(index).modulate == Color.GREEN:
				target_allies.erase(allied_characters[index])
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
				target_enemies.append(enemy_characters[index])
				target_enemies_count += 1
			elif vbox.get_child(index).modulate == Color.GREEN:
				vbox.get_child(index).modulate = Color.WHITE
				target_enemies.erase(enemy_characters[index])
				target_enemies_count -= 1
		if Input.is_action_just_pressed("confirm") and target_enemies_count >= min_target_enemies and \
		 target_enemies_count <= max_target_enemies:
			turn_phase = 3
	elif turn_phase == 3:
		turn_action.call(target_allies, target_enemies)
		general_reset()
		GlobalVariables.add_charge("light", - light_charges, GlobalVariables.taking_turn)
		GlobalVariables.add_charge("shade", - shade_charges, GlobalVariables.taking_turn)
		GlobalVariables.add_charge("balance", - balance_charges, GlobalVariables.taking_turn)
		GlobalVariables.turn += 1
	if Input.is_action_just_pressed("back"):
		general_reset()
		clear_actions()
		populate_actions()
		
		
func general_reset():
	turn_phase = 0
	target_allies.clear()
	target_enemies.clear()
	target_allies_count = 0
	target_enemies_count = 0
