extends Node
class_name GridMovement_C

@export var tween_anim := true
@export var effects_enabled := true
@export var can_jump := true
@export var object: Node2D

# logic variables

@export var step_len := 1
var cell_pos := Vector2i.ZERO
var push_strength := 1
var temp_push_strength := 0
@export var facing := Vector2i.RIGHT
@export var tween_time := 0.07
@export var scale_tween := true
var init_pos: Vector2i

signal step_len_changed()

# anim variables
var tween: Tween

const DIRECTIONS: Dictionary = {
	"up": Vector2i(0, -1),
	"down": Vector2i(0, 1),
	"left": Vector2i(-1, 0),
	"right": Vector2i(1, 0)
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_step_length(n: int):
	step_len = n
	step_len_changed.emit()

# returns its destiation
func move(dir: Vector2i, speed := 0, pre_dist := 0) -> Vector2i:
	facing = dir
	speed += step_len
	temp_push_strength = speed + push_strength - 1
	var dest = cell_pos + dir * speed
	var path_pos := cell_pos + dir
	dest = _check_path(path_pos, dest, dir)
	dest = dest if dest else cell_pos
	cell_pos = _move_to(cell_pos, dest, pre_dist);
	return cell_pos

func _check_path(path_pos: Vector2i, dest: Vector2i, dir: Vector2i):
	var can_move
	var pre_dist := (cell_pos - path_pos).length() - 1
	if can_jump and path_pos != dest:
		can_move = _path_logic(path_pos, dir, false, pre_dist)
	else:
		can_move = _path_logic(path_pos, dir, true, pre_dist)
		
	var next_pos
	if can_move:
		if path_pos == dest:
			return path_pos
		next_pos = _check_path(path_pos + dir, dest, dir)
	else:
		return null
	if !next_pos:
		if can_jump:
			var can_land := _path_logic(path_pos, dir, true, pre_dist)
			if can_land:
				return path_pos
			return null
		else:
			return path_pos
	else:
		return next_pos
	
# checks tile and returns true if traversable, false if not + some extra logic
# if hits a pushable object it basically uses recurssion (last object to be pushed
# in a chain of pushes gets resolved first)
func _path_logic(path_pos: Vector2i, dir: Vector2i, is_grounded: bool, pre_dist: int) -> bool:
	if path_pos in Global.game_entities.entity_dict:
		var entity = Global.game_entities.entity_dict[path_pos]
		#var total_push = push_strength + 
		var pushed_pos: Vector2i = entity.get_node("GridMovement_C").move(dir, temp_push_strength, pre_dist)
		if pushed_pos == path_pos:
			return false
	
	var tile_data := Global.game_objects.get_cell_tile_data(path_pos)
	if tile_data:
		var tile_type: GameObjects.Type = tile_data.get_custom_data("is_object")
		match tile_type:
			GameObjects.Type.IS_WALL:
				return false
			GameObjects.Type.IS_POTION:
				if is_grounded:
					var potion_type: Potion.Type = tile_data.get_custom_data("potion_type")
					if object is Player:
						if object.inventory.add_potion(potion_type):
							Global.game_objects.collect_potion(path_pos)
							return true
					# break potion if not player or player inventory full
					Global.game_objects.break_potion(path_pos, potion_type)
			GameObjects.Type.IS_EFFECT:
				if effects_enabled and is_grounded:
					var potion_type: Potion.Type = tile_data.get_custom_data("potion_type")
					Potion.data[potion_type]["effect"].call(object)
			GameObjects.Type.IS_OBSTACLE:
				if is_grounded:
					return false
			GameObjects.Type.IS_BUTTON:
				var button_group: int = tile_data.get_custom_data("button_group");
				Global.game_objects.update_button_group(button_group, true);
			GameObjects.Type.IS_CHECKPOINT:
				Global.last_player_cp = path_pos
			_:
				pass
	
	# handle when buttons stop being pressed.
	var prev_pos: Vector2i = path_pos - dir;
	var prev_tile_data := Global.game_objects.get_cell_tile_data(prev_pos);
	if (prev_tile_data):
		var prev_tile_type: GameObjects.Type = prev_tile_data.get_custom_data("is_object");
		
		if (prev_tile_type == GameObjects.Type.IS_BUTTON):
			var button_group: int = prev_tile_data.get_custom_data("button_group");
			Global.game_objects.update_button_group(button_group, false);
	
	return true

func _move_to(curr_cell: Vector2i, dest_cell: Vector2i, pre_dist := 0) -> Vector2i:
	var distance = (dest_cell - curr_cell).length();
	print(curr_cell, " ", dest_cell, " ",  object.name)
	var mod_tween_time = tween_time
	if (scale_tween):
		mod_tween_time *= distance;

	#Fix bug where player can move on top of projectile by spamming fast enough
	if not get_parent() is Player:
		mod_tween_time -= 0.02
	var local_pos = Global.game_objects.map_to_local(dest_cell)
	if tween_anim:
		if tween:
			tween.kill()
		if !tween:
			tween = create_tween()
		if !tween.is_valid():
			tween.kill()
			tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		if pre_dist:
			tween.tween_interval(pre_dist * tween_time)
		tween.tween_property(object, "position", local_pos, mod_tween_time)
	else:
		object.position = local_pos
	Global.game_entities.move_cell(curr_cell, dest_cell)
	return dest_cell
	

func teleport(coords: Vector2i):
	
	# handle when buttons stop being pressed.
	var prev_pos: Vector2i = cell_pos;
	var prev_tile_data := Global.game_objects.get_cell_tile_data(prev_pos);
	if (prev_tile_data):
		var prev_tile_type: GameObjects.Type = prev_tile_data.get_custom_data("is_object");
		
		if (prev_tile_type == GameObjects.Type.IS_BUTTON):
			var button_group: int = prev_tile_data.get_custom_data("button_group");
			Global.game_objects.update_button_group(button_group, false);
	Global.game_entities.move_cell(cell_pos, coords)
	cell_pos = coords
	var local_pos = Global.game_objects.map_to_local(coords)
	object.position = local_pos
