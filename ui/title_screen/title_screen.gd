extends Control

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton
@onready var volume_slider: HSlider = $HSlider


## Hooks up the buttons, hides Quit on web builds, and shows the current volume on the slider.
func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# quitting does nothing useful in a browser tab
	quit_button.visible = not OS.has_feature("web")
	# the volume outlives this screen, so the slider has to catch up with it
	volume_slider.set_value_no_signal(AudioManager.volume)


## Starts the game.
func _on_play_pressed() -> void:
	LevelManager.start_game()


## Closes the game.
func _on_quit_pressed() -> void:
	get_tree().quit()


## Applies the slider's value as the music volume.
func _on_h_slider_value_changed(value: float) -> void:
	AudioManager.volume = value
	AudioManager.update_volume()
