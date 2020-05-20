extends HSlider

export(NodePath) var AUTOMATON
export(String) var PROPERTY

func _ready():
# warning-ignore:return_value_discarded
	connect("value_changed", self, "_update_automaton")
	
	value = get_node(AUTOMATON).get(PROPERTY)
	
	$Value.text = str(value)


func _update_automaton(value):
	get_node(AUTOMATON).set(PROPERTY, value)
	$Value.text = str(value)
