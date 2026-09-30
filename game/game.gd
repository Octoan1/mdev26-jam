extends Node
## Hosts the current level and decides what its win/fail events mean.


## Spawns the current level and listens to its goals.
func _ready() -> void:
	var scene: PackedScene = LevelManager.get_current_level()
	if scene == null:
		return
	var level: Node = scene.instantiate()
	add_child(level)

	for node: Node in level.find_children("*", "", true, false):
		if node is Goal:
			node.reached.connect(_on_goal_reached)


## Moves on to the next level.
func _on_goal_reached() -> void:
	LevelManager.complete_level()
