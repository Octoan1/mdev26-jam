extends Node


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("reset_level"):
		LevelManager.restart_level()
