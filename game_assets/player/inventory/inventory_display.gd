class_name InventoryDisplay
extends Node2D

@export var HEIGHT := 32
@export var CAMERA_SCALE := 2
@export var WIDTH := 32 * 3

@export var slots: Array[inventory_slot]

func _ready() -> void:
	check_position()

func check_position() -> void:
	var size := get_viewport().get_visible_rect()
	print(size)
	# I don't know
	# this should be I, bt I don't like UI so I'm implementing it liks this so I can do it faster.
	global_position = Vector2(HEIGHT/2, size.size.y - HEIGHT/2)/CAMERA_SCALE + Vector2(8, -8)


func setup(inventory: Inventory) -> void:
	inventory.potion_added.connect(on_potion_added)
	inventory.potion_removed.connect(on_potion_removed)

func on_potion_added(type: Potion.Type) -> void:
	for slot in slots:
		if slot.is_empty():
			slot.store_potion(type)
			return
		else:
			var next_potion: Potion.Type = slot.get_potion()
			slot.store_potion(type)
			type = next_potion


func on_potion_removed() -> void:
	slots[0].empty()
	condense_slots()


func condense_slots() -> void:
	for i in range(slots.size() - 1):
		if slots[i].is_empty() and not slots[i + 1].is_empty():
			slots[i].store_potion(slots[i + 1].get_potion())
			slots[i + 1].empty()
