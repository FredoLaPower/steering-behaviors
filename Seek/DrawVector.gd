extends Node2D

### PROPERTIES ###

# EXPORT
export(String) var PROPERTY # Property holding the vector
export(Color) var COLOR # Vector color


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	update() # Called to redraw the arrow


func _draw():
	var rotation = Vector2(1,0).angle_to(get_parent().get(PROPERTY)) # Determine the angle to rotate the triangle
	
	var triangle: PoolVector2Array = [
		Vector2(0,0).rotated(rotation) + get_parent().get(PROPERTY),
		Vector2(0,-10).rotated(rotation) + get_parent().get(PROPERTY),
		Vector2(25,0).rotated(rotation) + get_parent().get(PROPERTY),
		Vector2(0,10).rotated(rotation) + get_parent().get(PROPERTY)
	]
	
	draw_line(Vector2.ZERO, get_parent().get(PROPERTY), COLOR, 3, true) # Draw the line
	draw_colored_polygon(triangle, COLOR, PoolVector2Array(), null, null, true) # Draw the triangle
