# STEERING FORCE = DESIRED VELOCITY - CURRENT VELOCITY
# Desired velocity is a normalized vector pointing to the target from the vehicle
# multiplied by the maximum speed

extends KinematicBody2D

# EXPORT
export(float) var ACCELERATION
export(int) var MAX_SPEED
export(int) var MAX_FORCE
export(int) var DECELERATION_DISTANCE
export(int) var SAFETY_DISTANCE
export(bool) var SEEK

export(NodePath) var TARGET

# PRIVATE
var current_velocity: Vector2 = Vector2.ZERO # Automaton current velocity
var desired_velocity: Vector2 = Vector2.ZERO # Automaton desired velocity
var steering_velocity: Vector2 = Vector2.ZERO # Aotumaton steering velovity
var steering_force: Vector2 = Vector2.ZERO # Force applied to move towards the target

func _ready() -> void:
	owner.get_node("Control/Acceleration").value = ACCELERATION
	owner.get_node("Control/MaxSpeed").value = MAX_SPEED
	owner.get_node("Control/MaxForce").value = MAX_FORCE
	owner.get_node("Control/DecDistance").value = DECELERATION_DISTANCE
	owner.get_node("Control/SafeDistance").value = SAFETY_DISTANCE
	owner.get_node("Control/Seek").pressed = SEEK


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var distance: float = .0
	var speed: float = MAX_SPEED
	
	# Calculate desired velocity
	desired_velocity = get_node(TARGET).position - position # define vector direction
	desired_velocity = desired_velocity.normalized() # normalize vector
	
	# ARRIVE
	distance = position.distance_to(get_node(TARGET).position)
	
	if SEEK:
		if distance < DECELERATION_DISTANCE:
			speed *= distance / DECELERATION_DISTANCE
		else:
			speed = MAX_SPEED
	else:
		if distance < SAFETY_DISTANCE:
			speed *= (SAFETY_DISTANCE - distance) / SAFETY_DISTANCE
		else:
			speed = 0
	
	
	desired_velocity *= speed if SEEK else -speed # define the vector maximum magnitude modulo seek or flee

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


func _on_DecDistance_value_changed(value):
	DECELERATION_DISTANCE = value


func _on_SafeDistance_value_changed(value):
	SAFETY_DISTANCE = value


func _on_Behavior_toggled(button_pressed):
	SEEK = button_pressed
