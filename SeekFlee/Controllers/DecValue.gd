extends Label


func _ready():
	text = str(get_parent().value)


func _on_DecDistance_value_changed(value):
	text = str(value)
