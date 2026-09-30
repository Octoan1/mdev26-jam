class_name Monkey
extends CharacterBody2D

@export var test_banana: Node2D
@export var hazard_tile_map: TileMapLayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
	ray_cast_2d.target_position = to_local(test_banana.global_position)
	
	if not ray_cast_2d.is_colliding():
		var dir: Vector2 = self.global_position.direction_to(test_banana.global_position)
		self.velocity = dir * SPEED
	else:
		self.velocity = Vector2.ZERO
	
	# collision loop for hazards
	check_tile_hazard()

	move_and_slide()

func check_tile_hazard():
	if hazard_tile_map:
		var tile_pos = hazard_tile_map.local_to_map(hazard_tile_map.to_local(global_position))
		var tile_data = hazard_tile_map.get_cell_tile_data(tile_pos)
		# hazard found!
		# can run whatever animations or custom content here:
		if tile_data and tile_data.get_custom_data("is_hazard"):
			LevelManager.restart_level()
		
