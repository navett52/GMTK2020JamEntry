extends Node2D

var direction = Vector2()
var Shotgun = load("res://Hero/Ammo/Shotgun.tscn")
var WaterPistol = load("res://Hero/Ammo/WaterPistol.tscn")
var IceRifle = load("res://Hero/Ammo/IceRifle.tscn")
var FlameRifle = load("res://Hero/Ammo/FlameRifle.tscn")
var BigAssExplosion = load("res://Hero/Ammo/BigAssExplosion.tscn")


func _process(delta):
	# Keep the gun pointed at the mouse for aiming
	look_at(get_global_mouse_position())


# Shoot the gun
# Needs some work still to randomly assign the different types of ammo
func shoot():
	var mouse_direction = (get_global_mouse_position() - self.global_position).normalized()
	# var bullet = Shotgun.instance()
	# var bullet = WaterPistol.instance()
	# var bullet = IceRifle.instance()
	# var bullet = FlameRifle.instance()
	var bullet = BigAssExplosion.instance()
	bullet.global_position = global_position
	# Below is some weird math I had to do to get the bullets to spawn in the right direction
	bullet.rotation = -atan2(mouse_direction.x, mouse_direction.y) + (PI/2)
	bullet.initialize(mouse_direction)
	G.main_node.add_child(bullet)
