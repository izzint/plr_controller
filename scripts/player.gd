extends CharacterBody3D
class_name Player

'''
Main mode of character movement
'''

@export_category("Player Settings")
@export var acceleration : float = 1
@export var speed : float = 5
@export var gravity : float = 290

@export_category("Camera Settings")
@export var lean_strength : float = 10

func _physics_process(delta) -> void:
	update_movement(delta)
	update_lean(delta)
	flashlight(delta)

func update_movement(delta : float) -> void:
	var dir = Input.get_vector("plr_left", "plr_right", "plr_forward", "plr_backwards")
	var wish_dir = (basis * Vector3(dir.x, 0, dir.y)).normalized()
		
	velocity = wish_dir * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("plr_jump"):
		velocity.y += gravity * delta * 15.0
	
	move_and_slide() # Move

func update_lean(delta : float) -> void:
	var lean_dir = Input.get_action_strength("plr_right") - Input.get_action_strength("plr_left")
	$Head.rotation.z = lerp_angle($Head.rotation.z, -lean_dir * 0.03, delta * lean_strength)

func _input(event) -> void:
	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * 0.002)
		$Head.rotate_x(-event.relative.y * 0.002)
		$Head.rotation.x = clamp($Head.rotation.x, -1.5, 1.5)

	# Handle mouse capture
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Releases mouse control
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func flashlight(delta : float) -> void:
	if Input.is_action_just_pressed("plr_flashlight"):
		if not $Flashlight.visible:
			$Flashlight.visible = true
		else:
			$Flashlight.visible = false
	
	$Flashlight.rotation = lerp($Flashlight.rotation, $Head.rotation, delta * 15)
