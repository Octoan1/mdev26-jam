extends Area2D
## Kill zone on the banana: the monkey dies when it reaches it.


## Kills the monkey if it is the body that entered.
func _on_body_entered(body: Node2D) -> void:
	if body is Monkey:
		print("Monkey reach banana")
		body.die()
