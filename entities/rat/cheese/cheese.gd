class_name Cheese
extends Bullet
## Rat shot: a bullet whose sprite stays upright whichever way it flies.

@onready var sprite: AnimatedSprite2D = $Sprite


## Cancels the flight rotation on the sprite so the wedge never tips over.
func _process(_delta: float) -> void:
	sprite.global_rotation = 0.0
