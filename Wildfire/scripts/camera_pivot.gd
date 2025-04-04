extends Node3D

# Movement settings
var move_speed := 0.01
var smoothing := 8.0

# Rotation settings
var rotation_speed := 90.0  # Degrees per second
var smooth_rotation_factor := 5.0

# Target position and rotation
var target_position := Vector3.ZERO
var target_rotation := 0.0

# Drag tracking
var is_dragging := false
var last_mouse_position := Vector2.ZERO

func _ready():
	target_position = global_transform.origin
	target_rotation = rotation_degrees.y

func _process(delta):
	handle_input(delta)
	# Smoothly move towards target position
	global_transform.origin = lerp(global_transform.origin, target_position, smoothing * delta)
	
	# Smoothly interpolate Y rotation with proper angle wrapping
	var current_y = rotation_degrees.y
	var target_y = target_rotation
	# Normalize angles to -180 to 180 range
	target_y = fmod(target_y + 180.0, 360.0) - 180.0
	current_y = fmod(current_y + 180.0, 360.0) - 180.0
	# Find shortest rotation path
	var diff = target_y - current_y
	if diff > 180.0:
		diff -= 360.0
	elif diff < -180.0:
		diff += 360.0
	rotation_degrees.y = current_y + diff * smooth_rotation_factor * delta

func handle_input(delta):
	# Handle rotation with arrow keys
	if Input.is_action_pressed("ui_left"):
		target_rotation += rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		target_rotation -= rotation_speed * delta

func _input(event):
	# Detect drag start (mouse down)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_dragging = true
			last_mouse_position = event.position
		else:
			is_dragging = false
	
	# Handle mouse drag for movement
	elif event is InputEventMouseMotion and is_dragging:
		var delta = event.position - last_mouse_position
		# Convert mouse movement to world movement
		var move_vector = Vector3.ZERO
		# X movement (left/right in screen space)
		move_vector -= global_transform.basis.x * delta.x * move_speed
		# Z movement (up/down in screen space becomes forward/backward)
		move_vector -= global_transform.basis.z * delta.y * move_speed
		# Keep movement horizontal
		move_vector.y = 0
		target_position += move_vector
		last_mouse_position = event.position
