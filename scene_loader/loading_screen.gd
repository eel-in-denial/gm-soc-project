extends CanvasLayer

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const transition_animation_name := &"transition"

func _ready() -> void:
	if animation_player == null:
		push_error("LoadingScreen: AnimationPlayer node not found")
		loading_screen_ready.emit()
		return
	
	if not animation_player.has_animation(transition_animation_name):
		push_error("LoadingScreen: missing animation '%s" % transition_animation_name)
		loading_screen_ready.emit()
		return
	await animation_player.animation_finished
	loading_screen_ready.emit()
	
func _on_progress_changed(_new_value: float) -> void:
	pass
	
func _on_load_finished() -> void:
	if not animation_player.has_animation(transition_animation_name):
		push_error("LoadingScreen: missing animation '%s" % transition_animation_name)
		queue_free()
		return
	
	animation_player.play_backwards(transition_animation_name)
	await animation_player.animation_finished
	queue_free()
