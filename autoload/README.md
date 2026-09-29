# Autoloads

## SceneManager (`scene_manager.gd`)

Use the `SceneManager` autoload from anywhere to change scenes; it fades to black and back:

```gdscript
SceneManager.change_scene(SceneManager.GAME)
```

To add a screen (win, lose, level 2, ...), add a constant in `scene_manager.gd` with the scene's uid
(right-click the scene in the FileSystem dock > Copy UID).
