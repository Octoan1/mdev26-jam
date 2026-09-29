class_name Goal
extends Area2D
## Level exit: when the monkey walks onto it, the level is complete.

signal reached


## Listens for bodies entering the goal.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


## Emits [signal reached] once the monkey steps on, ignoring everything else.
func _on_body_entered(body: Node2D) -> void:
	if not body is Monkey:
		return
	# only fire once, even if the monkey wiggles back in during the fade
	set_deferred("monitoring", false)
	reached.emit()
