extends Node
## Hosts the current level and decides what its win/fail events mean.


## Spawns the current level and listens to its goals, its boss, and its monkey.
func _ready() -> void:
	var scene: PackedScene = LevelManager.get_current_level()
	if scene == null:
		return
	var level: Node = scene.instantiate()
	add_child(level)

	for node: Node in level.find_children("*", "", true, false):
		if node is Goal:
			node.reached.connect(_on_level_won)
		elif node is Rat:
			node.defeated.connect(_on_level_won)
		elif node is Monkey:
			node.died.connect(_on_monkey_died)


## Moves on to the next level once any fade already running has finished.
func _on_level_won() -> void:
	if await _wait_for_fade():
		LevelManager.complete_level()


## Restarts the level once any fade already running has finished.
func _on_monkey_died() -> void:
	if await _wait_for_fade():
		LevelManager.restart_level()


## Waits out a running fade so the next scene change isn't dropped, returning false if this scene was swapped out meanwhile.
func _wait_for_fade() -> bool:
	while SceneManager.is_changing():
		await get_tree().process_frame
		# a fade that ends by replacing this scene leaves nothing to act on
		if not is_inside_tree():
			return false
	return true
