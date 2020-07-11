extends Node2D

var direction = Vector2()
var Shotgun = load("res://Hero/Ammo/Shotgun.tscn")


func _process(delta):
	look_at(get_global_mouse_position())


func shoot():
	var mouse_direction = (get_global_mouse_position() - self.global_position).normalized()
	var bullet = Shotgun.instance()
	bullet.global_position = global_position
	bullet.rotation = -atan2(mouse_direction.x, mouse_direction.y) + (PI/2)
	bullet._initialize(mouse_direction)
	G.main_node.add_child(bullet)
