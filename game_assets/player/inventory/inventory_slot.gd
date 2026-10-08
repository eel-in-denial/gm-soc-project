class_name inventory_slot
extends Sprite2D

@export var potion_sprite: Sprite2D
var p_type: Potion.Type


func empty() -> void:
	potion_sprite.visible = false

func store_potion(type: Potion.Type) -> void:
	potion_sprite.visible = true
	p_type = type
	potion_sprite.region_rect = _type_to_region()

func is_empty() -> bool:
	return not potion_sprite.visible

func get_potion() -> Potion.Type:
	return p_type


func _type_to_region() -> Rect2:
	match p_type:
		Potion.Type.SLOW_DOWN:
			return Rect2(32, 64, 32, 32)
		Potion.Type.SPEED_UP:
			return Rect2(0, 96, 32, 32)
		Potion.Type.STRENGTH:
			return Rect2(32, 96, 32, 32)
		_:
			return Rect2()
