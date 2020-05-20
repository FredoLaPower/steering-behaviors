extends OptionButton


export(NodePath) var AUTOMATON
export(String) var PROPERTY
export(String) var LIST


func _ready():
# warning-ignore:return_value_discarded
	connect("item_selected", self, "_update_automaton")
	
	for item in get_node(AUTOMATON).get(LIST):
		add_item(item)
	
	select(get_node(AUTOMATON).get(PROPERTY))


func _update_automaton(id):
	get_node(AUTOMATON).set(PROPERTY, id)
