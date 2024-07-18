extends RayCast3D

'''
Interaction Control
'''

@export var hold_joint : Generic6DOFJoint3D

func _process(_delta):
	if Input.is_action_just_pressed("plr_interact") and is_colliding():
		#hold_joint.node_b = get_collider()
		pass
