extends Node2D

@export var next_scene: StringName = &""
@onready var play_button: Button = $CanvasLayer/Button



func _ready() -> void:
	play_button.pressed.connect(_on_button_pressed)
	
func _on_button_pressed() -> void:
	SceneLoader.load_scene(next_scene)
