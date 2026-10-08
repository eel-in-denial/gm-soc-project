extends Camera2D

var tween: Tween

@onready var window_size := get_viewport().get_visible_rect().size
@export var tween_time := 0.7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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

func find_player(player: Player) -> void:
	var w = 640
	var h = 704/2
	while not get_viewport_rect().has_point(get_canvas_transform() * player.position):
		if position.x < player.position.x:
			position.x += w
		elif position.x > player.position.x:
			position.x -= w
		elif position.y < player.position.y:
			position.y += h
		elif position.y > player.position.y:
			position.y -= h
		else:
			player.quack()
		await get_tree().process_frame
	
