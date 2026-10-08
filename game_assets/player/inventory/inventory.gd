extends Node2D
class_name Inventory

@export var movement: GridMovement_C
var slots_stack: Array[int] = []
signal potion_added(type: Potion.Type)
signal potion_removed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_potion(potion: Potion.Type):
	if slots_stack.size() < 3:
		slots_stack.insert(0, potion)
		potion_added.emit(potion)
		return true
	else:
		return false

func throw() -> bool:
	if slots_stack:
		var aim := movement.cell_pos + movement.step_len * movement.facing
		if _can_throw(aim):
			var potion_type: Potion.Type = slots_stack.pop_front()
			Global.game_objects.break_potion(aim, potion_type)
			potion_removed.emit()
			return true
	return false
	


func _can_throw(path_pos: Vector2i) -> bool:
	var tile_data := Global.game_objects.get_cell_tile_data(path_pos)
	if tile_data:
		var tile_type: GameObjects.Type = tile_data.get_custom_data("is_object")
		if tile_type in [GameObjects.Type.IS_WALL, GameObjects.Type.IS_OBSTACLE]:
			return false
	return true
