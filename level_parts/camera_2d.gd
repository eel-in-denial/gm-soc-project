extends Camera2D

var tween: Tween

@onready var window_size := get_viewport().get_visible_rect().size
@export var camera_velocity := 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if offset:
		offset = offset.move_toward(Vector2.ZERO, camera_velocity)

func pan_camera(dir: Vector2i):
	var dir_vector := Vector2(dir)
	
	position += window_size * dir_vector * 0.5
	offset = - window_size * dir_vector * 0.5
	
