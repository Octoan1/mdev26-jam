class_name Bullet
extends Area2D
## Turret shot that flies straight, kills the monkey on touch, and disappears on walls.

## pixels per second, set by the turret that fires it
var speed: float = 250.0
## pixels it can fly before it removes itself, in case it leaves the level
var max_distance: float = 2000.0

var _travelled: float = 0.0


## Listens for bodies the bullet runs into.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


## Flies along its own x axis and removes itself once it has gone its full distance.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	# measured in distance, not time, so slow bullets reach as far as fast ones
	_travelled += speed * delta
	if _travelled >= max_distance:
		queue_free()


## Kills the monkey if that is what it hit, then removes itself either way.
func _on_body_entered(body: Node2D) -> void:
	if body is Monkey:
		body.die()
	queue_free()
