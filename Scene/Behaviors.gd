# STEERING FORCE = DESIRED VELOCITY - CURRENT VELOCITY
# Desired velocity is a normalized vector pointing to the target from the vehicle
# multiplied by the maximum speed

class_name Behaviors
extends KinematicBody2D

# ENUMERATOR
enum behaviors {seek, flee, wander} # seek = 0 ... wander = 2


# EXPORT
export(float, 0, 1, 0.1) var ACCELERATION
export(int, 0, 1000, 10) var MAX_SPEED
export(int, 0, 1000, 10) var MAX_FORCE
export(int, 0, 1000, 10) var DECELERATION_DISTANCE
export(int, 0, 1000, 10) var SAFETY_DISTANCE
export(int, 0, 1000, 10) var WHEEL_DISTANCE
export(int, 0, 1000, 10) var WHEEL_RADIUS
export(int, 0, 100, 5) var STEERING_DISPLACEMENT # In degrees
export(int, 0, 60, 1) var SKIPPED_FRAMES # In degrees
export(behaviors) var BEHAVIOR
export(NodePath) var TARGET

# PUBLIC
var current_velocity: Vector2 = Vector2.ZERO # Automaton current velocity
var desired_velocity: Vector2 = Vector2.ZERO # Automaton desired velocity
var steering_velocity: Vector2 = Vector2.ZERO # Aotumaton steering velovity
var steering_force: Vector2 = Vector2.ZERO # Force applied to move towards the target
var steering_point: Vector2 = Vector2.ZERO # Point on the steering wheel if automaton is wandering

# PRIVATE
var _last_angle: float = 0.0 # In Radiant
var frames_skipped: int = 0

func _ready():
	randomize()


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var target_position: Vector2 = Vector2.ZERO
	var direction: Vector2 = Vector2.ZERO
	var distance: float = 0.0
	var speed: float = MAX_SPEED
	
	# Calculate desired velocity
	if BEHAVIOR == 2:
		if  frames_skipped >= SKIPPED_FRAMES:
			_last_angle += -STEERING_DISPLACEMENT if randi() % 10 + 1 > 5 else STEERING_DISPLACEMENT
	
			if _last_angle > 360:
				_last_angle = _last_angle - 360
			elif _last_angle < 0:
				_last_angle = 360 - _last_angle

			frames_skipped = 0
		else:
			frames_skipped += 1
		
		steering_point = current_velocity.normalized() * WHEEL_DISTANCE + Vector2.RIGHT.rotated(deg2rad(_last_angle)) * WHEEL_RADIUS  #Vector to the center of the wheel + Vector from wheel to the point
		target_position = position + steering_point
	else:
		target_position = get_node(TARGET).position
	
	desired_velocity = target_position - position # define direction
	direction = desired_velocity.normalized() # normalize
	distance = position.distance_to(target_position) # define distance
	
	match BEHAVIOR:
		0: # Seek
			if distance < DECELERATION_DISTANCE:
				speed *= distance / DECELERATION_DISTANCE
		1: # Flee
			if distance < SAFETY_DISTANCE:
				speed *= (distance - SAFETY_DISTANCE) / SAFETY_DISTANCE
			else:
				speed = 0
	
	desired_velocity = direction * speed

	# Calculate steering force
	steering_force = (desired_velocity - current_velocity).clamped(MAX_FORCE) # We want to limit the steering force
	steering_velocity = current_velocity + steering_force
	current_velocity = lerp(current_velocity, steering_velocity, ACCELERATION) # Smmooth movement acceleration
	current_velocity = move_and_slide(current_velocity, Vector2.UP)
