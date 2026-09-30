extends Control

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


## Hooks up the buttons, hides Quit on web builds, and focuses Play for keyboard/controller.
func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# quitting does nothing useful in a browser tab
	quit_button.visible = not OS.has_feature("web")
	play_button.grab_focus()


## Starts the game.
func _on_play_pressed() -> void:
	LevelManager.start_game()


## Closes the game.
func _on_quit_pressed() -> void:
	get_tree().quit()
