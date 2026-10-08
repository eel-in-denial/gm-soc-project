extends TileMapLayer
class_name  GameEntities

@export var entity_scenes: Dictionary[int, PackedScene]
@export var camera: Node2D
var entity_dict: Dictionary[Vector2i, Node] = {}
# Called when the node enters the scene tree for the first time.
# game_entities.gd
func _enter_tree() -> void:
	Global.game_entities = self

func _exit_tree() -> void:
	if Global.game_entities == self:
		Global.game_entities = null

func _ready() -> void:
	print(camera)
	for cell in get_used_cells():
		var id: int = get_cell_tile_data(cell).get_custom_data("is_entity")
		var new_node := entity_scenes[id].instantiate() as Node2D
		new_node.position = map_to_local(cell)
		add_child(new_node)
		entity_dict[cell] = new_node
		
		var movement = new_node.get_node("GridMovement_C") as GridMovement_C
		movement.cell_pos = cell
		movement.teleport(cell)
		if (id == 0) and (Global.last_player_cp != Vector2i.ZERO or !get_viewport_rect().has_point(get_canvas_transform() * new_node.position)):
			if Global.last_player_cp != Vector2i.ZERO:
				movement.teleport(Global.last_player_cp)
			camera.find_player(new_node as Player)
		movement.init_pos = cell
	clear()

func move_cell(prev_cell: Vector2i, new_cell: Vector2i):
	if prev_cell != new_cell:
		entity_dict[new_cell] = entity_dict[prev_cell]
		entity_dict.erase(prev_cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
