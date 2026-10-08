extends Node2D

@export var player_movement: GridMovement_C

func update_positions() -> void:
	for child: Sprite2D in get_children():
		var tween := create_tween()
		var target_pos = child.position.normalized() * 32 * player_movement.step_len
		tween.tween_property(child, "position", target_pos, 0.05)
	

func _on_grid_movement_c_step_len_changed() -> void:
	update_positions()
