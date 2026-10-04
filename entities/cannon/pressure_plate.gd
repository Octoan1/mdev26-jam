class_name PressurePlate
extends Area2D
## One-use floor button: when the monkey steps on it, its cannon fires.

## the cannon this plate fires, required
@export var cannon: Cannon

@onready var sprite: AnimatedSprite2D = $Sprite

var _is_pressed: bool = false


## Listens for bodies stepping onto the plate.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


## Presses the plate and fires its cannon the first time the monkey steps on, ignoring everything else.
func _on_body_entered(body: Node2D) -> void:
	if _is_pressed or not body is Monkey:
		return
	_is_pressed = true
	sprite.play(&"pressed")
	cannon.fire()
