extends Control

var text: String

func _ready() -> void:
	$Label.text = text

func _on_destroy_timer_timeout() -> void:
	queue_free()
