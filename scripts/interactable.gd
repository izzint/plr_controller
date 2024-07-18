class_name Interactable 
extends RigidBody3D

'''
Interactable Physics Object (i can really grab)
'''

@export_category("Entity Settings")
@export var is_grabable : bool
@export var grabable_body : RigidBody3D
