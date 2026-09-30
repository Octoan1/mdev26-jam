# mdev26-jam

Godot 4.7 project. Main scene: `ui/title_screen/title_screen.tscn` (Play loads `game/game.tscn`).

## Project layout

Files are grouped **by thing**, not by file type: a scene, its script, and its art live together.

```
game/          main scene + top-level game flow (loads the current level)
entities/      things in the world, one folder each (monkey/, banana/, ...)
components/    reusable drop-in nodes (e.g. draggable_component.gd)
levels/        one scene per level (level_01.tscn, ...) + shared tileset.tres + level_list.tres (play order)
ui/            menus, HUD, win/lose screens
autoload/      singletons, only if we actually need one
assets/        shared stuff owned by no single entity (audio/, fonts/)
```

## Creating a level

1. In the FileSystem dock, right-click an existing level in `levels/` > **Duplicate**, and name it `level_NN.tscn`.
   (Or start fresh: a `Node2D` root with two `TileMapLayer` children, `Floor` and `Walls`, both using `levels/tileset.tres`.)
2. Paint the `Floor` and `Walls` layers. Tiles are 64x64.
3. Place the **Monkey**, **Banana**, and at least one **Goal** (drag their `.tscn` from `entities/` into the scene).
   Snap the goal to the grid: tile centers are at multiples of 64, plus 32.
4. Select the Monkey and set its **Test Banana** to the Banana in the Inspector. The monkey errors without one.
5. Open `levels/level_list.tres` and drag the new scene into the **Levels** array. Its position in the array is its play order.

## Physics layers

Named in Project Settings > Layer Names > 2D Physics. When adding a tile or hazard, put it on its own layer and
set its mask to whatever it should detect.

| # | Name     | Who's on it                          | Detects (mask)  |
|---|----------|--------------------------------------|-----------------|
| 1 | World    | wall tiles (`levels/tileset.tres`)   | nothing         |
| 2 | Player   | monkey                               | World           |
| 3 | Banana   | reserved for the banana (not set yet: its Draggable area is still on layer 1) | – |
| 4 | GoalFlag | goal (`entities/goal`)               | Player          |

## Winning and failing

Goals and hazards only **emit signals** (e.g. `Goal.reached`); they never change the level themselves.
`game/game.gd` connects to them and decides what happens, calling `LevelManager.complete_level()` or
`LevelManager.restart_level()`. New win/fail conditions (lasers, anti-banana tiles, ...) should follow the same pattern.

## Input

The built-in `ui_up` / `ui_left` / `ui_down` / `ui_right` actions also include WASD (physical keys) alongside the arrows and controller,
so `Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")` covers all of them.
