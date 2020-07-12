extends Node2D


enum ammo {
	WATER_PISTOL,
	SHOTGUN,
	ICE_RIFLE,
	FLAME_RIFLE,
	BIG_ASS_EXPLOSION
}


var rand = RandomNumberGenerator.new()
var direction = Vector2()
var Shotgun = load("res://Hero/Ammo/Shotgun.tscn")
var WaterPistol = load("res://Hero/Ammo/WaterPistol.tscn")
var IceRifle = load("res://Hero/Ammo/IceRifle.tscn")
var FlameRifle = load("res://Hero/Ammo/FlameRifle.tscn")
var BigAssExplosion = load("res://Hero/Ammo/BigAssExplosion.tscn")
var bullet_count = 0
var bullet_type
var bullet

var ammo_weights = {
	ammo.WATER_PISTOL: 5,
	ammo.SHOTGUN: 6,
	ammo.ICE_RIFLE: 6,
	ammo.FLAME_RIFLE: 6,
	ammo.BIG_ASS_EXPLOSION: 2
}


func _ready():
	bullet_type = choose_ammo()
	instance_bullet_with_count(bullet_type)


func _process(delta):
	randomize()
	# Keep the gun pointed at the mouse for aiming
	look_at(get_global_mouse_position())


# Shoot the gun
# Needs some work still to randomly assign the different types of ammo
func shoot():
	if bullet_count <= 0:
		bullet_type = choose_ammo()
		instance_bullet_with_count(bullet_type)
	else:
		instance_bullet(bullet_type)
	var mouse_direction = (get_global_mouse_position() - self.global_position).normalized()
	bullet.initialize(mouse_direction)
	bullet.global_position = global_position
	# Below is some weird math I had to do to get the bullets to spawn in the right direction
	bullet.rotation = -atan2(mouse_direction.x, mouse_direction.y) + (PI/2)
	G.main_node.call_deferred("add_child", bullet)
	bullet_count -= 1


func instance_bullet(bullet_type):
	match bullet_type:
			ammo.WATER_PISTOL:
				bullet = WaterPistol.instance()
			ammo.SHOTGUN:
				bullet = Shotgun.instance()
			ammo.ICE_RIFLE:
				bullet = IceRifle.instance()
			ammo.FLAME_RIFLE:
				bullet = FlameRifle.instance()
			ammo.BIG_ASS_EXPLOSION:
				bullet = BigAssExplosion.instance()


func instance_bullet_with_count(bullet_type):
	match bullet_type:
			ammo.WATER_PISTOL:
				bullet = WaterPistol.instance()
				bullet_count = rand.randi_range(12, 20)
			ammo.SHOTGUN:
				bullet = Shotgun.instance()
				bullet_count = rand.randi_range(6, 12)
			ammo.ICE_RIFLE:
				bullet = IceRifle.instance()
				bullet_count = rand.randi_range(8, 14)
			ammo.FLAME_RIFLE:
				bullet = FlameRifle.instance()
				bullet_count = rand.randi_range(8, 14)
			ammo.BIG_ASS_EXPLOSION:
				bullet = BigAssExplosion.instance()
				bullet_count = 1


func choose_ammo():
	var sum_of_weight = 0
	var ammo
	for weight in ammo_weights:
		sum_of_weight += ammo_weights[weight]

	var random = rand.randi_range(1, sum_of_weight)

	for weight in ammo_weights:
		if random < ammo_weights[weight]:
			return weight
		random -= ammo_weights[weight]
