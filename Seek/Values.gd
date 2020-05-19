extends Label


export(NodePath) var Automaton
export(NodePath) var Player


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	text = "%s\n%s\n%s" % [get_node(Automaton).current_velocity, get_node(Automaton).desired_velocity, get_node(Automaton).steering_force]
