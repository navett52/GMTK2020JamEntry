extends KinematicBody2D


var speed = 10
var direction = Vector2()
var velocity = Vector2()


func _physics_process(delta):
	# Move the bullets, if they hit something kill them
	# Some work to apply damage to enemies may need to go here
	var collision = move_and_collide(velocity)
	if (collision != null):
		queue_free()


# Uses the passed direction to create a proper velocity
func initialize(direction):
	velocity = (speed * direction).rotated(rotation)
