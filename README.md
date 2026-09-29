# mdev26-jam

Godot 4.7 project. Main scene: `ui/title_screen/title_screen.tscn` (Play loads `game/game.tscn`).

## Project layout

Files are grouped **by thing**, not by file type: a scene, its script, and its art live together.

```
game/          main scene + top-level game flow (loads the current level)
entities/      things in the world, one folder each (monkey/, banana/, ...)
components/    reusable drop-in nodes (e.g. draggable_component.gd)
levels/        one scene per level (level_01.tscn, ...) + shared tileset.tres
ui/            menus, HUD, win/lose screens
autoload/      singletons, only if we actually need one
assets/        shared stuff owned by no single entity (audio/, fonts/)
```
