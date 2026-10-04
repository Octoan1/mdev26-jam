extends Control
## Credits screen, opened from the title screen and shown after the last level is beaten.

@onready var back_button: Button = %BackButton


## Hooks up the Back button.
func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)


## Returns to the title screen.
func _on_back_pressed() -> void:
	SceneManager.change_scene(SceneManager.TITLE)
