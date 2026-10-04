extends Area2D
## Kill zone on the banana: the monkey dies when it reaches it.


## Hides the banana and has the monkey eat it, which kills it, if the monkey is the body that entered.
func _on_body_entered(body: Node2D) -> void:
	if body is Monkey:
		print("Monkey reach banana")
		# the eat animation draws its own banana, and a hidden banana shouldn't still be draggable
		get_parent().hide()
		get_parent().set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		body.die(&"eat")
