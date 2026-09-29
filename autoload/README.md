# Autoloads

Global singletons that are available from any script by name.

## SceneManager (`scene_manager.gd`)

Use the `SceneManager` autoload from anywhere to change scenes; it fades to black and back:

```gdscript
SceneManager.change_scene(SceneManager.GAME)
```

To add a screen (win, lose, credits, ...), add a constant in `scene_manager.gd` with the scene's uid
(right-click the scene in the FileSystem dock > Copy UID).

## LevelManager (`level_manager.gd`)

Tracks which level is being played and moves between them, using the order in `levels/level_list.tres`:

```gdscript
LevelManager.start_game()      # level 1
LevelManager.complete_level()  # next level, or the title screen after the last one
LevelManager.restart_level()   # reload the current level
```

Levels aren't added here; drag them into `levels/level_list.tres` instead.
