extends KinematicBody2D


# Exported variables
export (int) var speed = 250
export (int) var health = 100

# Private variables
var direction = Vector2()
var velocity = Vector2()
var gun = Node


func _ready():
	# Grab a reference to the gun
	gun = get_node("Gun")


func _process(delta):
	# Shoot the gun
	if (Input.is_action_just_pressed("shoot")):
		if (gun.has_method("shoot")):
			gun.shoot()
	
	# Activate ability
	if (Input.is_action_just_pressed("activate_passive")):
		print("Passive activated!")


# Simple movement code. Works pretty well, actually.
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


# Get input and determine direction
func get_input():
	velocity = Vector2()
	direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	velocity = direction.normalized() * speed
