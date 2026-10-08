extends Node

@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_outside_screen.connect(switch_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_level(direction: Vector2i):
	camera.pan_camera(direction)
