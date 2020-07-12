extends Node
func _ready():
	set_process(true)
func _process(delta):
	$KinematicBody2D.rotation=get_angle_to()
