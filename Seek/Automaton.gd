# STEERING = DESIRED VELOCITY - CURRENT VELOCITY
# Desired velocity is a normalized vector pointing to the target from the vehicle
# multiplied by the maximum speed

extends KinematicBody2D

# EXPORT
export(int) var MAX_SPEED
export(int) var MAX_FORCE
export(float) var ACCELERATION
export(NodePath) var TARGET

# PRIVATE
var current_velocity: Vector2 = Vector2.ZERO # Automaton current velocity
var desired_velocity: Vector2 = Vector2.ZERO # Automaton desired velocity
var steering_velocity: Vector2 = Vector2.ZERO # Aotumaton steering velovity
var steering_force: Vector2 = Vector2.ZERO # Force applied to move towards the target


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	# Calculate desired velocity
	desired_velocity = get_node(TARGET).position - position # define vector direction
	desired_velocity = desired_velocity.normalized() # normalize vector
	desired_velocity *= MAX_SPEED # define the vector maximum magnitude

	# Calculate steering force
	steering_force = (desired_velocity - current_velocity).clamped(MAX_FORCE) # We want to limit the steering force
	steering_velocity = current_velocity + steering_force
	current_velocity = lerp(current_velocity, steering_velocity, ACCELERATION) # Smmooth movement acceleration
	
	current_velocity = move_and_slide(current_velocity, Vector2.UP)


func _on_Acceleration_value_changed(value):
	ACCELERATION = value


func _on_MaxSpeed_value_changed(value):
	MAX_SPEED = value


func _on_MaxForce_value_changed(value):
	MAX_FORCE = value
