class_name Cannon
extends Node2D
## Fires a bomb at the rat when its pressure plate is stepped on.

const BOMB: PackedScene = preload("res://entities/cannon/bomb.tscn")

@onready var muzzle: Marker2D = $Muzzle


## Spawns a bomb at the muzzle that flies to the rat, doing nothing in a level without one.
func fire() -> void:
	var rat: Rat = get_tree().get_first_node_in_group("rat") as Rat
	if rat == null:
		return
	var bomb: Bomb = BOMB.instantiate()
	bomb.target = rat
	# sibling of the cannon so it is freed with the level
	get_parent().add_child(bomb)
	bomb.global_position = muzzle.global_position
