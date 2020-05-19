extends KinematicBody2D


### PROPERTIES ###

#EXPORT
export(float) var MAX_SPEED
export(float) var ACCELERATION


# PRIVATE
var _velocity: Vector2 = Vector2.ZERO


### METHODS ###

# VIRTUAL

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var move_y = int(Input.is_action_pressed("player_down")) - int(Input.is_action_pressed("player_up"))
	var move_x = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	
	
	_velocity.x = lerp(_velocity.x, move_x * MAX_SPEED, ACCELERATION)
	_velocity.y = lerp(_velocity.y, move_y * MAX_SPEED, ACCELERATION)
	
	_velocity = _velocity.clamped(MAX_SPEED)

	_velocity = move_and_slide(_velocity, Vector2.UP)
