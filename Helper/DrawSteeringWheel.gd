extends Node2D

### PROPERTIES ###

# EXPORT
export(NodePath) var OWNER
export(String) var DIRECTION # Current Vector
export(String) var TARGET # target point
export(Color) var WHEEL_COLOR # Vector color
export(Color) var TARGET_COLOR # Vector color
export(int, 0, 10, 1) var WIDTH # Vector color
export(bool) var ACTIVE # Antialiasing

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	update() # Called to redraw the arrow


func _draw():
	if get_node(OWNER).BEHAVIOR == 2:
		draw_arcs(get_node(OWNER).get(DIRECTION).normalized() * get_node(OWNER).WHEEL_DISTANCE, get_node(OWNER).WHEEL_RADIUS, 0, 360, 36, WHEEL_COLOR, WIDTH, true) # Draw the circle
		draw_circle(get_node(OWNER).get(TARGET), WIDTH * 4, TARGET_COLOR)

func draw_arcs(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = 1.0, antialiased: bool = false):
	var points: PoolVector2Array = PoolVector2Array()
	var angle: float = 0
	
	for i in range(point_count + 1):
		angle = deg2rad(start_angle + i * (end_angle - start_angle) / point_count - 90)
		points.push_back(center + Vector2(cos(angle), sin(angle)) * radius)

	for index in range(point_count):
		draw_line(points[index], points[index + 1], color, width, antialiased)
