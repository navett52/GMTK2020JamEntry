extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		$CollisionShape2D.disabled=false
	else:
		$CollisionShape2D.disabled=true

