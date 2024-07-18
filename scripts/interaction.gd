extends RayCast3D

'''
Interaction Control
'''

### The joint where the interactable is held from
@export var hold_joint : Generic6DOFJoint3D

### Throw Strength
@export var throw_strength : float

### The current object being held by the Player
var held_object : RigidBody3D

func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("plr_interact"):
		if held_object:
			release_object()
		elif is_colliding() and get_collider() is RigidBody3D:
			held_object = get_collider() as RigidBody3D
			grab_object(held_object)
			
	if Input.is_action_just_pressed("plr_throw") and held_object:
		throw_object()

## Grab a targeted RigidBody
func grab_object(target : RigidBody3D) -> void:
		hold_joint.node_b = target.get_path()

## Throw the held RigidBody
func throw_object() -> void:
		var throw_direction = to_global(target_position * throw_strength)
		held_object.apply_central_force(throw_direction)
		release_object()
		
## Release the current RigidBody
func release_object() -> void:
	hold_joint.node_b = NodePath()
	held_object = null
