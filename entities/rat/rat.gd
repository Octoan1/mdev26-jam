class_name Rat
extends Node2D
## Boss that spits fans of cheese at the monkey and is beaten once every cannon's bomb has hit it.

signal defeated

const CHEESE: PackedScene = preload("res://entities/rat/cheese/cheese.tscn")

## seconds between volleys
@export var fire_interval: float = 2.0
## cheeses per volley
@export var cheese_count: int = 3
## degrees between neighbouring cheeses in a volley
@export var spread_degrees: float = 25.0
## pixels per second the cheese flies, the monkey walks at 150
@export var cheese_speed: float = 180.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var mouth: Marker2D = $Mouth

var _monkey: Monkey
var _hits_left: int = 0
var _cooldown: float = 0.0


## Finds the monkey, counts one hit per cannon in the level, and starts the cooldown full.
func _ready() -> void:
	_monkey = get_tree().get_first_node_in_group("monkey") as Monkey
	_hits_left = get_tree().get_nodes_in_group("cannon").size()
	_cooldown = fire_interval


## Spits a volley at the monkey every time the cooldown runs out, until one of them is dead.
func _physics_process(delta: float) -> void:
	if _hits_left <= 0 or _monkey == null or _monkey.is_dead():
		return
	_cooldown -= delta
	if _cooldown <= 0.0:
		_spit()


## Spawns a fan of cheese from the mouth, centered on the monkey.
func _spit() -> void:
	_cooldown = fire_interval
	var aim: float = mouth.global_position.angle_to_point(_monkey.global_position)
	for i: int in cheese_count:
		# spread the volley evenly either side of the aim
		var offset: float = (i - (cheese_count - 1) / 2.0) * deg_to_rad(spread_degrees)
		var cheese: Cheese = CHEESE.instantiate()
		cheese.speed = cheese_speed
		# sibling of the rat so it is freed with the level
		get_parent().add_child(cheese)
		cheese.global_position = mouth.global_position
		cheese.global_rotation = aim + offset


## Takes one bomb hit, flashing red, and dies on the last one; a hit after the monkey has died doesn't count.
func take_hit() -> void:
	if _hits_left <= 0 or (_monkey != null and _monkey.is_dead()):
		return
	_hits_left -= 1
	sprite.modulate = Color(1.0, 0.3, 0.3)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.3)
	if _hits_left <= 0:
		_die()


## Clears cheese still in flight, fades the rat out, then emits [signal defeated].
func _die() -> void:
	get_tree().call_group("cheese", "queue_free")
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	await tween.finished
	defeated.emit()
