extends Node2D
export var enabled=false
var ena=true
func _ready():
	set_process(true)
	$Laser.add_exception(get_parent().get_parent())
func _process(delta):
	look_at(get_global_mouse_position())
	$Particles2D.process_material.set("velocity",Vector3(get_viewport().get_mouse_position().normalized().x*1000,get_viewport().get_mouse_position().normalized().y*1000,0))
	if Input.is_action_pressed("shoot") and enabled:
		$Particles2D.emitting=true
		var k=$Laser.get_collider()
		if ena:
			if k!=null and k.has_method("hit") :
				k.hit()
				get_parent().heal()
			ena=false
		else:
			if $Timer.is_stopped():
				$Timer.start()
		
	else:
		$Particles2D.emitting=false


func _on_Timer_timeout():
	ena=true
	print("ok")
