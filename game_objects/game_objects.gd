extends TileMapLayer
class_name GameObjects
enum Type {IS_WALL, IS_OBSTACLE, IS_POTION, IS_EFFECT, IS_MOVEABLE, IS_BUTTON, IS_CHECKPOINT}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_objects = self
	var tileset := get_tile_set()
	var atlas := tileset.get_source(3)
	for p in Potion.data:
		Potion.data[p]["potion_atlas_coords"] = find_tile(atlas, Type.IS_POTION, p)
		Potion.data[p]["effect_atlas_coords"] = find_tile(atlas, Type.IS_EFFECT, p)


func break_potion(cell: Vector2i, p: Potion.Type):
	set_cell(cell, 3, Potion.data[p]["effect_atlas_coords"])
	print(cell, Potion.data[p]["effect_atlas_coords"])

func collect_potion(cell: Vector2i):
	erase_cell(cell)
	
func find_tile(atlas: TileSetAtlasSource, is_object: int, potion_type: int) -> Vector2i:
	for i in atlas.get_tiles_count():
		var coords := atlas.get_tile_id(i)
		var data := atlas.get_tile_data(coords, 0)
		if data.get_custom_data("is_object") == is_object and data.get_custom_data("potion_type") == potion_type:
			return coords
	return Vector2i(-1, -1)
	
func update_button_group(button_group: int, active: bool) -> void:
	var tiles = get_used_cells_by_id(4);
	for coords in tiles:
		var tile := get_cell_tile_data(coords);
		
		if (tile.get_custom_data("button_group") == button_group &&
			tile.get_custom_data("is_object") != Type.IS_BUTTON):
			var sprite_offset_x: int = (tile.get_custom_data("button_group") - 1) % 2 * 2;
			var sprite_offset_y: int = floor((tile.get_custom_data("button_group") - 1) / 2) * 2;
			
			if (active):
				set_cell(coords, 4, Vector2i(1 + sprite_offset_x, 1 + sprite_offset_y));
			else:
				set_cell(coords, 4, Vector2i(0 + sprite_offset_x, 1 + sprite_offset_y));
