class_name Laser
extends Node2D
## Rotating beam that kills the monkey when it touches it; walls cut it short.

## degrees per second, negative spins counter-clockwise
@export var rotation_speed: float = 45.0
## how far the beam reaches when nothing blocks it
@export var max_length: float = 600.0

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var beam: Line2D = $Beam


## Points the ray along the laser's local x axis at full length.
func _ready() -> void:
	ray_cast_2d.target_position = Vector2(max_length, 0.0)


## Spins the laser, trims the beam to whatever it hits, and kills the monkey if that is what it hit.
func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	# the ray moved this frame, so refresh it before reading the hit
	ray_cast_2d.force_raycast_update()

	var end: Vector2 = ray_cast_2d.target_position
	if ray_cast_2d.is_colliding():
		end = to_local(ray_cast_2d.get_collision_point())
		var monkey: Monkey = ray_cast_2d.get_collider() as Monkey
		if monkey:
			monkey.die()
	beam.set_point_position(1, end)
