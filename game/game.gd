extends Node
## Hosts the current level and decides what its win/fail events mean.


## Spawns the current level and listens to its goals and its monkey.
func _ready() -> void:
	var scene: PackedScene = LevelManager.get_current_level()
	if scene == null:
		return
	var level: Node = scene.instantiate()
	add_child(level)

	for node: Node in level.find_children("*", "", true, false):
		if node is Goal:
			node.reached.connect(_on_goal_reached)
		elif node is Monkey:
			node.died.connect(_on_monkey_died)


## Moves on to the next level.
func _on_goal_reached() -> void:
	LevelManager.complete_level()


## Restarts the level, waiting out any fade already running so the restart isn't dropped.
func _on_monkey_died() -> void:
	while SceneManager.is_changing():
		await get_tree().process_frame
		# the fade swapped this scene out (the level was won), so there is nothing left to restart
		if not is_inside_tree():
			return
	LevelManager.restart_level()
