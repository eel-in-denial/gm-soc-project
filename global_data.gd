extends Node

signal on_player_move()
signal on_red_tile
signal on_green_tile
signal player_outside_screen(direction: Vector2i)

var game_objects: GameObjects = null
var game_entities: GameEntities = null
