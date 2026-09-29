extends Node
## Global scene switcher with a fade to black.
## Usage: SceneManager.change_scene(SceneManager.GAME)
## To add a screen, add a constant below with its uid (right-click the scene > Copy UID).

const TITLE := "uid://gywbpgqwxmdi"
const GAME := "uid://dxnmievu7c8yh"

## seconds for each half of the fade (out, then in)
@export var fade_time: float = 0.25

var _fade: ColorRect
var _is_changing: bool = false


## Builds the black fade overlay on a CanvasLayer above everything else.
func _ready() -> void:
	# keep fading even if the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)

	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.modulate.a = 0.0
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_fade)


## Fades out, swaps to the scene at [param path], and fades back in, ignoring calls made mid-transition.
func change_scene(path: String) -> void:
	if _is_changing:
		return
	_is_changing = true
	# block clicks while the screen is covered
	_fade.mouse_filter = Control.MOUSE_FILTER_STOP

	await _fade_to(1.0)
	var err: Error = get_tree().change_scene_to_file(path)
	if err != OK:
		push_error("SceneManager: couldn't load %s (error %d)" % [path, err])
	else:
		await get_tree().scene_changed
	await _fade_to(0.0)

	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_is_changing = false


## Tweens the overlay to [param alpha] over [member fade_time] seconds.
func _fade_to(alpha: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(_fade, "modulate:a", alpha, fade_time)
	await tween.finished
