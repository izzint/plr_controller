extends CharacterBody3D
class_name Player

'''
Main mode of character movement
'''

@export_category("Player Settings")
@export var acceleration : float = 1
@export var speed : float = 5
@export var gravity : float = 32
@export var mouse_sens : float = .005
@export var jump_spd : float = 12.0

@export_category("Camera Settings")
@export var lean_strength : float = 10

var lerp_spd : float = 8.5
var dir = Vector3.ZERO
var current_spd = 5.0

func _physics_process(delta) -> void:
	update_movement(delta)
	update_lean(delta)
	flashlight(delta)

func update_movement(delta : float) -> void:
	var wish_dir = Input.get_vector("plr_left", "plr_right", "plr_forward", "plr_backwards")
	dir = lerp(dir,(transform.basis * Vector3(wish_dir.x, 0, wish_dir.y)).normalized(), delta * lerp_spd)
	
	if dir:
		velocity.x = dir.x * current_spd
		velocity.z = dir.z * current_spd
	
	if Input.is_action_pressed("plr_jump") and is_on_floor():
		velocity.y += gravity * delta * jump_spd
		
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if velocity.y >= 64:
		velocity.y = 64
	
	move_and_slide() # Move

func update_lean(delta : float) -> void:
	var lean_dir = Input.get_action_strength("plr_right") - Input.get_action_strength("plr_left")
	$Head.rotation.z = lerp_angle($Head.rotation.z, -lean_dir * 0.03, delta * lean_strength)

func _input(event) -> void:
	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sens)
		$Head.rotate_x(-event.relative.y * mouse_sens)
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
