extends Node2D

class_name Character

@export var character_name: String
@export var max_hp: int
@export var hp: int
@export var damage: int
@export var defense: int
@export var speed: int
@export var luck: int
@export var actions: Dictionary = {
	"Normal Attack": {
		"description": "Does damage or something idk",
		"targets_enemy": true,
		"action": Callable(self, "normal_attack")
	},
	"print": {
		"description": "Does damage or something idk",
		"targets_enemy": true,
		"action": Callable(self, "normal_attack2")
	}
}

func normal_attack(caller: Character, targets: Array[Character]):
	GlobalVariables.general_attack_func(caller, targets)
	
func normal_attack2():
	print("okkkk")
