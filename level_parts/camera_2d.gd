extends Camera2D

var tween: Tween

@onready var window_size := get_viewport().get_visible_rect().size
@export var tween_time := 0.7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pan_camera(dir: Vector2i):
	var dir_vector := Vector2(dir)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "position", position + window_size * dir_vector * 0.5, tween_time)
