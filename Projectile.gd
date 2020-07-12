extends KinematicBody2D


var speed = 10
var direction = Vector2()
var velocity = Vector2()
var damage
var type

func _ready():
	type = get_parent().name
	if("Shotgun" in type):
		damage = 40
	elif("IceRifle" in type):
		damage = 40
	elif("FlameRifle" in type):
		damage = 50
	else:
		damage = 1

func _physics_process(delta):
	print(type)
	# Move the bullets, if they hit something kill them
	# Some work to apply damage to enemies may need to go here
	var collision = move_and_collide(velocity)
	if (collision != null):
		print("collision")
		queue_free()
		if(collision.collider.has_method("take_damage")):
			print(damage)
			collision.collider.take_damage(damage)
			if(collision.collider.has_method("freeze") && type == "IceRifle"):
				collision.collider.freeze()
			elif(collision.collider.has_method("dot") && type == "FlameRifle"):
				collision.collider.dot()



# Uses the passed direction to create a proper velocity
func initialize(direction):
	velocity = (speed * direction).rotated(rotation)
