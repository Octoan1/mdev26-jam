extends Area2D
class_name Draggable
## Lets the mouse pick up and drag its parent node; needs a CollisionShape2D child as the grab area.

## if unset, will default to owner
@export var parent: Node2D
## how quickly the parent catches up to the mouse, higher is snappier
@export var speed: float = 10

var is_hovered: bool = false
var is_dragging: bool = false

## the amount to offset by when draggin, so it doesn't snap to center
var offset: Vector2 = Vector2.ZERO

## Falls back to the owner as parent and listens for mouse events on the grab area.
func _ready() -> void:
	if not parent:
		parent = owner
	
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


## Eases the parent toward the mouse while dragging.
func _process(delta: float) -> void:
	if is_dragging:
		parent.global_position = lerp(global_position, get_global_mouse_position() - offset, speed*delta)


## Starts a drag when the left button is pressed on the grab area.
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			offset = get_global_mouse_position() - self.global_position


# need mouse release to be a global event because we lerp the position
## Ends the drag when the left button is released anywhere.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			is_dragging = false


## Marks the grab area as hovered.
func _on_mouse_entered() -> void:
	# hover logic
	is_hovered = true
	pass # Replace with function body.


## Marks the grab area as no longer hovered.
func _on_mouse_exited() -> void:
	# stop hover logic
	is_hovered = false
	pass # Replace with function body.
