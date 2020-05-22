extends Node2D

### PROPERTIES ###

# EXPORT
export(NodePath) var OWNER
export(String) var VECTOR # Vector to draw
export(String) var ORIGIN # Point of origin if any
export(Color) var COLOR # Vector color
export(int) var WIDTH # line width
export(bool) var DRAW_TRIANGLE
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	update() # Called to redraw the arrow


func _draw():
	var origin: Vector2 = Vector2.ZERO
	
	if ORIGIN != "":
		origin += get_node(OWNER).get(ORIGIN)
	
	draw_line(origin, origin + get_node(OWNER).get(VECTOR), COLOR, WIDTH, true) # Draw the line
	
	if DRAW_TRIANGLE:
		var rotation: float = Vector2.RIGHT.angle_to(get_node(OWNER).get(VECTOR)) # Determine the angle to rotate the triangle
	
		var triangle: PoolVector2Array = [
			origin + get_node(OWNER).get(VECTOR) + Vector2(-25,0).rotated(rotation),
			origin + get_node(OWNER).get(VECTOR) + Vector2(-25,-10).rotated(rotation),
			origin + get_node(OWNER).get(VECTOR) + Vector2(0,0).rotated(rotation),
			origin + get_node(OWNER).get(VECTOR) + Vector2(-25,10).rotated(rotation)
		]
		
		draw_colored_polygon(triangle, COLOR, PoolVector2Array(), null, null, true) # Draw the triangle
