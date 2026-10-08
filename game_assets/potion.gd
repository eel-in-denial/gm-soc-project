extends Node
class_name Potion

enum Type {SPEED_UP, SLOW_DOWN, STRENGTH}

static var data = {
	Type.SPEED_UP: {
		"effect": _speed_up
	},
	
	Type.SLOW_DOWN: {
		"effect": _slow_down
	},
	
	Type.STRENGTH: {
		"effect": _strength
	},
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func _speed_up(target: Node2D):
	var movement = target.get_node_or_null("GridMovement_C")
	if movement:
		movement.set_step_length(2)
		
static func _slow_down(target: Node2D):
	var movement = target.get_node_or_null("GridMovement_C")
	if movement:
		movement.set_step_length(1)

static func _strength(target: Node2D):
	var movement = target.get_node_or_null("GridMovement_C")
	if movement:
		movement.push_strength = 50
	
