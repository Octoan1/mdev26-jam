class_name Bullet
extends Area2D
## Turret shot that flies straight, kills the monkey on touch, and disappears on walls.

## pixels per second, set by the turret that fires it
var speed: float = 250.0
## seconds before it removes itself, in case it flies out of the level
var lifetime: float = 4.0


## Listens for bodies the bullet runs into.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


## Flies along its own x axis and removes itself when its lifetime runs out.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


## Kills the monkey if that is what it hit, then removes itself either way.
func _on_body_entered(body: Node2D) -> void:
	if body is Monkey:
		body.die()
	queue_free()
