extends Node
## Tracks which level is being played and moves between them.
## Usage: LevelManager.complete_level() when the current level is won.
## To add a level, open levels/level_list.tres and drag the scene into the Levels array.

const LEVEL_LIST: LevelList = preload("res://levels/level_list.tres")

var current_index: int = 0


## Starts a fresh run from the first level.
func start_game() -> void:
	go_to_level(0)


## Loads the level at [param index] in the list, refusing indices that don't exist.
func go_to_level(index: int) -> void:
	if not _is_valid_index(index):
		push_error("LevelManager: no level at index %d" % index)
		return
	current_index = index
	SceneManager.change_scene(SceneManager.GAME)


## Advances to the next level, or back to the title after the last one.
func complete_level() -> void:
	if _is_valid_index(current_index + 1):
		go_to_level(current_index + 1)
	else:
		current_index = 0
		SceneManager.change_scene(SceneManager.TITLE)


## Reloads the current level from scratch.
func restart_level() -> void:
	go_to_level(current_index)


## Returns the scene for the level currently being played, or null if the index is bad.
func get_current_level() -> PackedScene:
	if not _is_valid_index(current_index):
		push_error("LevelManager: no level at index %d" % current_index)
		return null
	return LEVEL_LIST.levels[current_index]


## Whether [param index] points at a filled slot in the level list.
func _is_valid_index(index: int) -> bool:
	return index >= 0 and index < LEVEL_LIST.levels.size() and LEVEL_LIST.levels[index] != null
