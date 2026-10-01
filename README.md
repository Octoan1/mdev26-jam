# mdev26-jam

Godot 4.7 project. Main scene: `ui/title_screen/title_screen.tscn` (Play loads `game/game.tscn`).

## Project layout

Files are grouped **by thing**, not by file type: a scene, its script, and its art live together.

```
game/          main scene + top-level game flow (loads the current level)
entities/      things in the world, one folder each (monkey/, banana/, goal/, laser/)
components/    reusable drop-in nodes (e.g. draggable_component.gd)
levels/        one scene per level (level_01.tscn, ...) + shared tileset.tres + level_list.tres (play order)
ui/            menus, HUD, win/lose screens
autoload/      singletons (SceneManager, LevelManager)
assets/        shared stuff owned by no single entity (audio/, fonts/); not created yet
```

## Creating a level

1. In the FileSystem dock, right-click an existing level in `levels/` > **Duplicate**, and name it `level_NN.tscn`.
   (Or start fresh: a `Node2D` root with `TileMapLayer` children `Floor`, `Walls`, and optionally `Hazards`, all using `levels/tileset.tres`.)
2. Paint the `Floor` and `Walls` layers. Tiles are 48x48. Only the light blue wall tile has collision; every other tile is walkable.
3. Place the **Monkey**, **Banana**, and at least one **Goal** (drag their `.tscn` from `entities/` into the scene).
   Snap the goal to the grid: tile centers are at multiples of 48, plus 24.
4. Select the Monkey and set its **Test Banana** to the Banana in the Inspector. The monkey errors without one.
5. For hazard tiles, paint the skull tile on the `Hazards` layer and set the Monkey's **Hazard Tile Map** to that layer.
   Hazard tiles do nothing in a level where this is unset.
6. For a laser, drag `entities/laser/laser.tscn` into the scene. The node's rotation is its starting angle;
   **Rotation Speed** (degrees per second, negative for counter-clockwise) and **Max Length** are in the Inspector.
7. Open `levels/level_list.tres` and drag the new scene into the **Levels** array. Its position in the array is its play order.

## Physics layers

Named in Project Settings > Layer Names > 2D Physics. When adding a tile or hazard, put it on its own layer and
set its mask to whatever it should detect.

| # | Name     | Who's on it                          | Detects (mask)  |
|---|----------|--------------------------------------|-----------------|
| 1 | World    | wall tiles (`levels/tileset.tres`)   | nothing         |
| 2 | Player   | monkey                               | World           |
| 3 | Banana   | banana's `DeathZone` area (its Draggable area is still on layer 1) | Player |
| 4 | GoalFlag | goal (`entities/goal`)               | Player          |

The laser is on no layer: its `RayCast2D` scans World and Player, so walls cut the beam short. Untick World on a
laser's ray to let its beam pass through walls.

## Winning and failing

Goals and hazards never change the level themselves. `game/game.gd` listens for two signals and decides what happens:

**Winning:** the goal emits `Goal.reached`, and `game.gd` calls `LevelManager.complete_level()`.

**Failing:** every hazard calls `monkey.die()`. The monkey stops moving and emits `Monkey.died` once, and `game.gd`
calls `LevelManager.restart_level()`. There is no death animation, lives count, or fail screen yet: an animation or
sound goes in `Monkey.die()`, and anything about the level (a fail screen, a lives count) goes in
`game.gd`'s `_on_monkey_died()`. New hazards should call `die()` too. The monkey dies to:

| Hazard        | Where                                   | Kills when                                              |
|---------------|-----------------------------------------|---------------------------------------------------------|
| Banana        | `entities/banana/banana_death_zone.gd`  | the monkey's body enters the banana's `DeathZone`       |
| Hazard tiles  | `check_tile_hazard()` in `entities/monkey/monkey.gd` | the monkey's center is on a tile with `is_hazard` custom data |
| Laser         | `entities/laser/laser.gd`               | the beam touches the monkey's body                      |

To make a tile deadly, tick its `is_hazard` custom data in `levels/tileset.tres`.

A level scene run by itself (F6) has no `game.gd`, so the monkey reloads that level itself when it dies. Reaching
the goal does nothing there; run the game from the title screen to test moving between levels.

## Input

The built-in `ui_up` / `ui_left` / `ui_down` / `ui_right` actions also include WASD (physical keys) alongside the arrows and controller,
so `Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")` covers all of them.
