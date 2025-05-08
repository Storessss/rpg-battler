extends Node

var poison_effect = {
	"name": "Poison",
	"is_positive": false,
	"tick_time": "start",
	"duration": 3,
	"apply": func(target):
		target.hp -= 3,
	"on_expire": func(target):
		print("Poison wears off from ", target.name)
}
var strength_effect = {
	"name": "Strength",
	"is_positive": true,
	"tick_time": "end",
	"duration": 2,
	"apply": func(target):
		var bonus = int(target.attack * 0.33)
		target.temp_effect_modifiers["strength"] = bonus
		target.attack += bonus,
	"on_expire": func(target):
		var bonus = target.temp_effect_modifiers["strength"]
		target.attack -= bonus
		target.temp_effect_modifiers.erase("strength")
}
var weakness_effect = {
	"name": "Weakness",
	"is_positive": false,
	"tick_time": "end",
	"duration": 2,
	"apply": func(target):
		target.damage -= 15,
	"on_expire": func(target):
		print("Weakness from ", target.name)
		target.damage += 15
}
