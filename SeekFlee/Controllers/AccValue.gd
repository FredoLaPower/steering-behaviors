extends Label


func _ready():
	text = str(get_parent().value)


func _on_Acceleration_value_changed(value):
	text = str(value)