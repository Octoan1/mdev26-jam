class_name Monkey
extends CharacterBody2D
## Walks straight at the banana whenever it has a clear line of sight to it, and dies on hazard tiles.

signal died

## the banana to chase, required
@export var test_banana: Node2D
## layer checked for is_hazard tiles, leave unset for levels without any
@export var hazard_tile_map: TileMapLayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $Sprite

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var _is_dead: bool = false


## Aims the ray at the banana and moves toward it unless a wall is in the way.
func _physics_process(_delta: float) -> void:
	ray_cast_2d.target_position = to_local(test_banana.global_position)
	
	if ray_cast_2d.is_colliding():
		if not ray_cast_2d.is_colliding():
			return
		
		var collider: Object = ray_cast_2d.get_collider()
		var parent: Node2D = collider.get_parent()
	
		# check if component is child of banana
		if not (parent and parent.is_in_group("banana")):
			return
		
		var dir: Vector2 = self.global_position.direction_to(test_banana.global_position)
		self.velocity = dir * SPEED
	else:
		self.velocity = Vector2.ZERO
	
	# collision loop for hazards
	check_tile_hazard()

	move_and_slide()

## Kills the monkey if the tile under its center is marked is_hazard.
func check_tile_hazard() -> void:
	if hazard_tile_map:
		var tile_pos: Vector2i = hazard_tile_map.local_to_map(hazard_tile_map.to_local(global_position))
		var tile_data: TileData = hazard_tile_map.get_cell_tile_data(tile_pos)
		# hazard found!
		if tile_data and tile_data.get_custom_data("is_hazard"):
			die()


## Stops the monkey, plays [param animation] once, then emits [signal died], however many hazards hit it.
func die(animation: StringName = &"burning") -> void:
	if _is_dead:
		return
	_is_dead = true
	set_physics_process(false)

	sprite.play(animation)
	# looping animations never finish, so one pass ends on the loop signal instead
	if sprite.sprite_frames.get_animation_loop(animation):
		await sprite.animation_looped
	else:
		await sprite.animation_finished
	# hold the end of the animation through the fade, as ash if the monkey burned
	if animation == &"burning":
		sprite.play(&"burnt")
	else:
		sprite.pause()
		sprite.frame = sprite.sprite_frames.get_frame_count(animation) - 1

	died.emit()
	# a level run by itself (F6) has no game.gd listening, so reload it from here
	if owner and owner == get_tree().current_scene:
		SceneManager.change_scene(owner.scene_file_path)
