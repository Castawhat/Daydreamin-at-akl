extends CharacterBody2D

const SPEED = 150.0
const JUMP_FORCE = -400.0
const LOUDNESS_THRESHOLD = 0.1

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump (scream)
	var loudness = MicInput.get_volume()
	if loudness > LOUDNESS_THRESHOLD and is_on_floor():
		velocity.y = JUMP_FORCE

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move
	move_and_slide()
