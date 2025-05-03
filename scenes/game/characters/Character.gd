extends Node2D

class_name Character

@export var character_name: String
@export var max_hp: int
@export var hp: int
@export var damage: int
@export var defense: int
@export var speed: int
@export var luck: int

var dead: bool
func die():
	dead = true

var status_effects: Array = []

func start_turn():
	if dead:
		get_tree().current_scene.turn += 1
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
	status_effects.append(effect)
	
func update_labels():
	$VBoxContainer/Hp.text = "Health: " + str(hp) + "/" + str(max_hp)
	$VBoxContainer/Damage.text = "Damage: " + str(damage)
	$VBoxContainer/Defense.text = "Defense: " + str(defense)
	$VBoxContainer/Speed.text = "Speed: " + str(speed)
	$VBoxContainer/Luck.text = "Luck: " + str(luck)
	for status_effect in status_effects:
		var label = Label.new()
		label.text = status_effect["name"]
		$VBoxContainer.add_child(label)
		
func _process(delta: float) -> void:
	if hp <= 0:
		die()
	update_labels()
