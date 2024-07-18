extends RayCast3D

'''
Interaction Control
'''

### The joint where the interactable is held from
@export var hold_joint : Generic6DOFJoint3D

### The current object being held by the Player
var held_object : RigidBody3D

func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("plr_interact"):
		if held_object:
			release_object()
		elif is_colliding() and get_collider() is RigidBody3D:
			held_object = get_collider() as RigidBody3D
			grab_object(held_object)

func grab_object(target : RigidBody3D) -> void:
		hold_joint.node_b = target.get_path()

func release_object() -> void:
	hold_joint.node_b = NodePath()
	held_object = null
