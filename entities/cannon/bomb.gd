class_name Bomb
extends Node2D
## Cannon shot that flies to the rat, explodes, and counts as one hit on it.

## the rat to fly at, set by the cannon that fires it
var target: Rat
## pixels per second
var speed: float = 300.0

@onready var sprite: AnimatedSprite2D = $Sprite

var _has_exploded: bool = false


## Flies straight at the rat, over walls and hazards, and explodes on reaching it.
func _physics_process(delta: float) -> void:
	if _has_exploded:
		return
	global_position = global_position.move_toward(target.global_position, speed * delta)
	if global_position.is_equal_approx(target.global_position):
		_explode()


## Hits the rat, plays the explosion once, then removes itself.
func _explode() -> void:
	_has_exploded = true
	target.take_hit()
	sprite.play(&"explode")
	await sprite.animation_finished
	queue_free()
