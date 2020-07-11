extends KinematicBody2D


var speed = 10
var direction = Vector2()
var velocity = Vector2()


func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if (collision != null):
		queue_free()


func _initialize(direction):
	velocity = (speed * direction).rotated(rotation)
