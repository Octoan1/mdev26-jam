extends CharacterBody2D

@export var test_banana: Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
	ray_cast_2d.target_position = to_local(test_banana.global_position)
	
	if not ray_cast_2d.is_colliding():
		var dir: Vector2 = self.global_position.direction_to(test_banana.global_position)
		self.velocity = dir * SPEED
	else:
		self.velocity = Vector2.ZERO

	move_and_slide()
