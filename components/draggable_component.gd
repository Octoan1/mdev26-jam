extends Area2D
class_name Draggable

## if unset, will default to owner
@export var parent: Node2D
@export var speed: float = 10

var is_hovered: bool = false
var is_dragging: bool = false

## the amount to offset by when draggin, so it doesn't snap to center
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not parent:
		parent = owner
	
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _process(delta: float) -> void:
	if is_dragging:
		parent.global_position = lerp(global_position, get_global_mouse_position() - offset, speed*delta)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			offset = get_global_mouse_position() - self.global_position


# need mouse release to be a global event because we lerp the position
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			is_dragging = false


func _on_mouse_entered() -> void:
	# hover logic
	is_hovered = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	# stop hover logic
	is_hovered = false
	pass # Replace with function body.
