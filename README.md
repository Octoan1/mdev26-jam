# mdev26-jam

Godot 4.7 project.

## Project layout

Files are grouped **by thing**, not by file type: a scene, its script, and its art live together.

```
game/          main scene + top-level game flow (loads the current level)
entities/      things in the world, one folder each (monkey/, banana/, goal/, laser/, turret/, cannon/, rat/)
components/    reusable drop-in nodes (e.g. draggable_component.gd)
levels/        one scene per level (level_01.tscn, ...) + shared tileset.tres + level_list.tres (play order)
ui/            menus, HUD, win/lose screens
autoload/      singletons (SceneManager, LevelManager)
assets/        shared stuff owned by no single entity (audio/, fonts/); not created yet
```

## Input

The built-in `ui_up` / `ui_left` / `ui_down` / `ui_right` actions also include WASD (physical keys) alongside the arrows and controller,
so `Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")` covers all of them.
