extends Node

var poison_effect = {
	"name": "Poison",
	"tick_time": "start",
	"duration": 3,
	"apply": func(target):
	target.hp -= 1,
	"on_expire": func(target):
		print("Poison wears off from", target.name)
}
