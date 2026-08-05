extends Node

signal progress_changed(progress)
signal load_finished

# SceneLoader usage:
# 1) Call `SceneLoader.load_scene(&"res://path/to/your_scene.tscn")` from gameplay/UI scripts.
# 2) Optional: replace `loading_scene` with your own loading screen PackedScene.
var loading_scene: PackedScene = preload("uid://c200i2a3lnad4")
var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []
var use_sub_threads: bool = true

func _ready() -> void:
	set_process(false)
	
# Entry point for callers.
# Pass a valid scene path (for example: &"res://levels/level_1.tscn").
func load_scene(_scene_path: String) -> void:
	scene_path = _scene_path
	
	if loading_scene == null:
		push_error("loading_scene is not set, cannot load scene: " + _scene_path)
		return
	var new_load_screen = loading_scene.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)

	await new_load_screen.loading_screen_ready
	
	_start_load()
	
func _start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)
	else:
		push_error("Load request failed: %s -> %s" % [error_string(state), scene_path])

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	if not progress.is_empty():
		progress_changed.emit(progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Load failed: invalid resource ->" + scene_path)
			set_process(false)
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Load failed: loading error ->" + scene_path)
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()
		
		
		
		
		
