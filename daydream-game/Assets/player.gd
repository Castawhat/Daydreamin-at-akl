extends CharacterBody2D
 
const SPEED = 90.0       # Horizontal speed
const JUMP_FORCE = -400.0 # Increased jump force for clarity
const REQUIRED_CLICKS = 12

# Global gravity value (safer than calling a missing function)
const GRAVITY = 980.0

var click_counter: int = 0
var counter_label: Label = null

func _ready():
	# Attempt to get the label. Using the relative path as you had it.
	counter_label = get_node("ClickCounterLabel")

	# Await process_frame helps ensure the node is fully ready and drawn before access, 
	# sometimes fixing silent get_node() or label update failures.
	await get_tree().process_frame 
	
	if counter_label == null:
		push_error("ERROR: ClickCounterLabel not found! Check the node path.")
		return
		
	_update_label()


func _physics_process(delta: float) -> void:
	# Diagnostic check for physics environment
	# Note: is_on_floor() will flicker if the character runs over uneven ground.
	print("Is On Floor: ", is_on_floor())
	
	# -----------------------------------------------
	# 1. CONTINUOUS FORWARD MOVEMENT
	# Set the horizontal velocity to the constant SPEED (moving right)
	velocity.x = SPEED
	# -----------------------------------------------

	# 2. GRAVITY 
	# Use the GRAVITY constant to apply physics acceleration
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	# No longer need move_toward(velocity.x, 0, SPEED) since we move continuously

	move_and_slide()


func _update_label():
	if counter_label:
		counter_label.text = "Clicks: %s / %s" % [click_counter, REQUIRED_CLICKS]


func _input(event: InputEvent) -> void:
	# Using "ui_accept" as it is the most reliable action name.
	if event.is_action_pressed("ui_accept"):
		
		click_counter += 1
		print("Clicks: ", click_counter, " / ", REQUIRED_CLICKS) # Diagnostic Check
		
		_update_label()
		
		# Jump Logic
		if click_counter >= REQUIRED_CLICKS and is_on_floor():
			
			print("!!! JUMP CONDITION MET: Applying Jump Velocity !!!")
			
			velocity.y = JUMP_FORCE # Apply the negative force (upward)
			
			print("Velocity Y SET TO: ", velocity.y)
			
			click_counter = 0
			
			_update_label()


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Secne 2.tscn")





func _on_level_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")


func _on_level_1d_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func _on_level_3d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Secne 2.tscn")
	
func _on_level_4d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scene_tres.tscn")

func _on_level_5d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Scene_4.tscn")

func _on_level_23_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scene_4.tscn")
	
func _on_level_34_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scene_5.tscn")
	


func _on_level_45_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
