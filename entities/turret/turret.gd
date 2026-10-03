class_name Turret
extends Node2D
## Tracks the monkey when it has line of sight and fires bullets at it; walls block its view.

const BULLET: PackedScene = preload("res://entities/turret/bullet.tscn")

## seconds between shots
@export var fire_interval: float = 1.5
## how far the turret can see
@export var view_range: float = 500.0
## degrees per second the barrel turns
@export var turn_speed: float = 180.0
## pixels per second the bullets fly, the monkey walks at 150
@export var bullet_speed: float = 250.0

@onready var barrel: Node2D = $Barrel
@onready var muzzle: Marker2D = $Barrel/Muzzle
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var _monkey: Monkey
var _cooldown: float = 0.0


## Finds the monkey and starts the cooldown full so it can't fire on the first frame.
func _ready() -> void:
	_monkey = get_tree().get_first_node_in_group("monkey") as Monkey
	_cooldown = fire_interval


## Turns the barrel toward the monkey while it is visible and fires when aimed and off cooldown.
func _physics_process(delta: float) -> void:
	_cooldown -= delta
	if not _can_see_monkey():
		return

	var target_angle: float = barrel.global_position.angle_to_point(_monkey.global_position)
	barrel.global_rotation = rotate_toward(barrel.global_rotation, target_angle, deg_to_rad(turn_speed) * delta)

	# only shoot once the barrel has caught up with the monkey
	var is_aimed: bool = absf(angle_difference(barrel.global_rotation, target_angle)) < 0.1
	if is_aimed and _cooldown <= 0.0:
		_fire()


## Whether the monkey is alive and in range with no wall between it and the turret.
func _can_see_monkey() -> bool:
	if _monkey == null or _monkey.is_dead():
		return false
	if global_position.distance_to(_monkey.global_position) > view_range:
		return false
	ray_cast_2d.target_position = ray_cast_2d.to_local(_monkey.global_position)
	ray_cast_2d.force_raycast_update()
	return ray_cast_2d.get_collider() is Monkey


## Spawns a bullet at the muzzle, flying the way the barrel points.
func _fire() -> void:
	_cooldown = fire_interval
	var bullet: Bullet = BULLET.instantiate()
	bullet.speed = bullet_speed
	# sibling of the turret so it is freed with the level
	get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = barrel.global_rotation
