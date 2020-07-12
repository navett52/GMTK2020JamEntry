extends KinematicBody2D


var speed = 10
var direction = Vector2()
var velocity = Vector2()


func _physics_process(delta):
	# Move the bullets, if they hit something kill them
	# Some work to apply damage to enemies may need to go here
	var collision = move_and_collide(velocity)
	#if(collision.collider.name != "BigEnemy" && collision.collider.name != "SmallEnemy"):
	if(collision != null):
		if(collision.collider.name == "Hero"):
			collision.collider.take_damage(7)
			queue_free()


# Uses the passed direction to create a proper velocity
func initialize(direction):
	velocity = (speed * direction).rotated(rotation)
