extends Node2D

class_name Character

@export var character_name: String
@export var max_hp: int
@export var hp: int
@export var attack: int
@export var magic: int
@export var defense: int
@export var speed: int
@export var crit_chance: int
@export var crit_multiplier: float = 1.5

var downed: bool
func down():
	downed = true
func take_damage(raw_damage: int):
	var reduced_damage = raw_damage * (1.0 - (defense / (defense + 100.0)))
	hp -= int(max(reduced_damage, 1))
	if hp <= 0:
		down()
func crit(raw_amount: int):
	var is_crit: bool
	if randf() < (crit_chance / 100.0):
		is_crit = true
	var multiplier: float = 1.0
	if is_crit:
		multiplier = crit_multiplier
	return multiplier

var status_effects: Array
var temp_effect_modifiers: Dictionary

func start_turn():
	if downed:
		GlobalVariables.turn += 1
	modulate = Color.YELLOW
	for effect in status_effects.duplicate():
		if effect["tick_time"] == "start":
			effect["apply"].call(self)
			effect["duration"] -= 1
			if effect["duration"] <= 0:
				if effect.has("on_expire"):
					effect["on_expire"].call(self)
				status_effects.erase(effect)

func end_turn():
	modulate = Color.WHITE
	for effect in status_effects.duplicate():
		if effect["tick_time"] == "end":
			effect["apply"].call(self)
			effect["duration"] -= 1
			if effect["duration"] <= 0:
				if effect.has("on_expire"):
					effect["on_expire"].call(self)
				status_effects.erase(effect)

func apply_status(effect: Dictionary):
	var existing_index := -1
	for i in status_effects.size():
		if status_effects[i]["name"] == effect["name"]:
			if effect["duration"] > status_effects[i]["duration"]:
				existing_index = i
			return
	if existing_index != -1:
		status_effects[existing_index] = effect
	else:
		status_effects.append(effect)
	
func update_labels():
	for label in $VBoxContainer.get_children():
		if label.modulate == Color.BLUE:
			label.queue_free()
	$VBoxContainer/Hp.text = "Health: " + str(hp) + "/" + str(max_hp)
	$VBoxContainer/Damage.text = "Attack: " + str(attack)
	$VBoxContainer/Magic.text = "Magic: " + str(magic)
	$VBoxContainer/Defense.text = "Defense: " + str(defense)
	$VBoxContainer/Speed.text = "Speed: " + str(speed)
	$VBoxContainer/CritChance.text = "Crit Chance: " + str(crit_chance) + "%"
	$VBoxContainer/CritMultiplier.text = "Crit Multiplier: " + str(crit_multiplier) + "x"
	for status_effect in status_effects:
		var label = Label.new()
		label.text = status_effect["name"]
		label.modulate = Color.BLUE
		label.add_theme_font_size_override("font_size", 100)
		$VBoxContainer.add_child(label)
		
func _process(delta: float) -> void:
	update_labels()
	
