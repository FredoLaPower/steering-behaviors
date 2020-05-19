extends Node2D

export(String) var PROPERTY # Property holding the vector
export(Color) var COLOR # Vector color


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	update()


func _draw():
	var rotation = Vector2(1,0).angle_to(get_parent().get(PROPERTY))
	
	var triangle: PoolVector2Array = [
		Vector2(0,0).rotated(rotation) + get_parent().get(PROPERTY),
		Vector2(0,-10).rotated(rotation) + get_parent().get(PROPERTY),
		Vector2(25,0).rotated(rotation) + get_parent().get(PROPERTY),
		Vector2(0,10).rotated(rotation) + get_parent().get(PROPERTY)
	]
	
	draw_line(Vector2.ZERO, get_parent().get(PROPERTY), COLOR, 3)
	draw_colored_polygon(triangle, COLOR)
