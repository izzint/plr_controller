extends RayCast3D

'''
Interaction Control
'''

### The joint where the interactable is held from
@export var hold_joint : Generic6DOFJoint3D

### Is the player currently holding something?
var holding : bool = false

func _physics_process(_delta) -> void:
	print(get_collider())
	if Input.is_action_just_pressed("plr_interact"):
		if holding:
			hold_joint.node_b = NodePath()
			holding = false
		else:
			if is_colliding() and get_collider() is RigidBody3D:
				var target = get_collider() as RigidBody3D
				holding = true
				hold_joint.node_b = target.get_path()
