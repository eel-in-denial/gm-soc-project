extends Node

@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_outside_screen.connect(switch_level)
	Global.find_player.connect(find_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_level(direction: Vector2i) -> void:
	camera.pan_camera(direction)
	for entity_key in Global.game_entities.entity_dict:
		var entity := Global.game_entities.entity_dict[entity_key]
		if not entity is Player and  entity.get_viewport_rect().has_point(entity.get_canvas_transform() * entity.position):
			entity.get_node("GridMovement_C").teleport(entity.get_node("GridMovement_C").init_pos)


func find_player(player: Player) -> void:
	camera.find_player(player)
