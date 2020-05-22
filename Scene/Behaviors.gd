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
export(int, 0, 1000, 10) var STEERING_FORCE
export(int, 0, 1000, 10) var AVOIDANCE_FORCE
export(int, 0, 1000, 10) var LOOKUP_DISTANCE
export(int, 0, 1000, 10) var BREAKING_DISTANCE
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
var steering_velocity: Vector2 = Vector2.ZERO # Automaton steering velovity
var steering_force: Vector2 = Vector2.ZERO # Force applied to steer the automaton
var avoidance_force: Vector2 = Vector2.ZERO # Force applied to move away from the nearest obstacle
var lookup_vector: Vector2 = Vector2.ZERO # Force applied to move away from the nearest obstacle
var steering_point: Vector2 = Vector2.ZERO # Steering wheel position while wandering

# PRIVATE
var _last_angle: float = 0.0 # In Radiant
var frames_skipped: int = 0

func _ready():
	randomize()
	
	$RayCast.cast_to.x = LOOKUP_DISTANCE


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var target_position: Vector2 = Vector2.ZERO
	var direction: Vector2 = Vector2.ZERO
	var distance: float = 0.0
	var speed: float = MAX_SPEED
	var heading_direction: float = Vector2.RIGHT.angle_to(current_velocity)
	
	# Look for obstacles
	
	
	if BEHAVIOR == 0:
		$RayCast.look_at(get_node(TARGET).position)
		lookup_vector = $RayCast.cast_to.rotated($RayCast.rotation)
	else:
		lookup_vector = current_velocity.normalized() * LOOKUP_DISTANCE
		$RayCast.rotation = heading_direction
	
	$Sprite.rotation = heading_direction
	$Collider.rotation = heading_direction
	
	if $RayCast.is_colliding():
		distance = position.distance_to($RayCast.get_collision_point())
		avoidance_force = $RayCast.get_collision_normal() * (AVOIDANCE_FORCE - distance) # Closer we are stronger is the force
	else:
		avoidance_force = lerp(avoidance_force, Vector2.ZERO, ACCELERATION) # Lerp to reduce the jitter
		
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
			if distance < BREAKING_DISTANCE:
				speed *= distance / BREAKING_DISTANCE
		1: # Flee
			if distance < SAFETY_DISTANCE:
				speed *= (distance - SAFETY_DISTANCE) / SAFETY_DISTANCE
			else:
				speed = 0
	
	desired_velocity = direction * speed
	
	# Calculate steering force
	steering_force = (desired_velocity - current_velocity + avoidance_force).clamped(STEERING_FORCE) # We want to limit the steering force
	steering_velocity = current_velocity + steering_force
	
	current_velocity = lerp(current_velocity, steering_velocity, ACCELERATION) # Smmooth movement acceleration
	current_velocity = move_and_slide(current_velocity, Vector2.UP)


func _on_AvoidDistance_value_changed(value):
	$RayCast.cast_to.x = value
