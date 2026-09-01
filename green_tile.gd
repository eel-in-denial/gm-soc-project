extends Node2D

@onready var map: TileMapLayer = get_parent()
@onready var player: Player = get_parent().get_child(0) as Player
@onready var cell_position: Vector2i = map.local_to_map(position)

func _ready() -> void:
	if not player:
		push_error("plase place player on the topest")
		
	player.player_move.connect(_on_player_move)


func _on_player_move() -> void:
	var player_cell = map.local_to_map(player.get_player_position())
	
	if player_cell == cell_position:
		#print(1)
		GlobalSignal.on_green_tile.emit()
