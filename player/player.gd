extends "res://moveable_object.gd"
class_name Player

signal player_move


const MOVE_INTERVAL := 0.2 
var move_cooldown := 0.0
var step_len := 1
var has_superpower := false

func _ready() -> void:
	super._ready()
	#button.pressed.connect(_on_pressed)
	GlobalSignal.on_red_tile.connect(_on_red_tile)
	GlobalSignal.on_green_tile.connect(_on_green_tile)
func _process(delta: float) -> void:
	move_cooldown -= delta
	if move_cooldown > 0.0:
		return
	if tween and tween.is_running():
		return
		
	var dir := Vector2i(
		Input.get_vector("left", "right", "up", "down").round()
	)
	if dir == Vector2i.ZERO:
		return
	if dir.x != 0:
		dir.y = 0
	
	player_move.emit()
	var dest :=	cell_position + dir * step_len
	if is_wall(dest):
		return
		
	var projectile := get_projectile(dest)
	if projectile:
		var projectile_dest
		if has_superpower:
			projectile_dest = _find_superpower_dest(dest, dir)
		else:
			projectile_dest = dest + dir
		if is_wall(projectile_dest) or get_projectile(projectile_dest):
			return
		projectile.move_to(projectile_dest)
	
	move_to(dest)
	
	has_superpower = false
	step_len = 1
	move_cooldown = MOVE_INTERVAL
	
#func _on_pressed() -> void:
	#switch_animation()


func _on_red_tile() -> void:
	step_len = 2
	
func _on_green_tile() -> void:
	has_superpower = true
	
func get_player_position() -> Vector2:
	return position
	
func _find_superpower_dest(cell_pos: Vector2i, dir: Vector2i) -> Vector2i:
	var dest := cell_pos + dir
	while not is_wall(dest):
		dest += dir
	dest -= dir
	return dest
